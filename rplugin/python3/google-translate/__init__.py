from os import environ
from typing import List

import pynvim
from google.cloud import translate


def get_parent():
  project_id = environ.get('GOOGLE_API_PROJECT_ID')
  return f"projects/{project_id}"


@pynvim.plugin
class GoogleTranslatePlugin(object):

  def __init__(self, nvim):
    self.nvim = nvim
    self.parent = get_parent()

  def _get_selected(self):
    buf = self.nvim.current.buffer
    start_cursor = self.nvim.call('getpos', "'<")
    end_cursor = self.nvim.call('getpos', "'>")
    start_row = start_cursor[1]-1
    start_col = start_cursor[2]-1
    end_row = end_cursor[1]
    end_col = end_cursor[2]

    lines = buf[start_row:end_row]
    if len(lines) == 0:
      return lines

    prefix = lines[0][:start_col]
    suffix = lines[-1][end_col:]
    lines[0] = lines[0][start_col:]
    lines[-1] = lines[-1][:end_col]
    return lines, start_row, end_row, prefix, suffix

  @pynvim.function('_google_translate_supported_languages', sync=True)
  def list_supported_languages(self, args: List):
    client = translate.TranslationServiceClient()
    response = client.get_supported_languages(parent=self.parent)

    results = []
    languages = response.languages
    for language in languages:
      results.append({
        'language_code': language.language_code,
        'display_name': language.display_name,
      })
    return results

  @pynvim.function('_google_translate_detect_language_async', sync=False)
  def detect_language(self, args: List):
    client = translate.TranslationServiceClient()

    line = self.nvim.request('nvim_get_current_line')
    response = client.detect_language(
      parent=self.parent,
      content=line,
      mime_type='text/plain',
    )
    log_level = 2  # info
    for language in response.languages:
      message = f'Language code: {language.language_code}\nConfidence: {language.confidence}'
      self.nvim.request('nvim_notify', message, log_level, {})

  def translate_text(self, contents: List[str], target_language_code: str) -> List[translate.Translation]:
    client = translate.TranslationServiceClient()

    response = client.translate_text(
      parent=self.parent,
      contents=contents,
      target_language_code=target_language_code,
      mime_type='text/plain',
    )
    return response.translations

  @pynvim.function('_google_translate_selection_async', sync=False)
  def async_api_call(self, args: List):
    if len(args) != 1 or not isinstance(args[0], str):
      return

    bufnr = self.nvim.request('nvim_get_current_buf')
    lines, start_row, end_row, prefix, suffix = self._get_selected()
    target_language_code = args[0]

    translations = self.translate_text(lines, target_language_code)
    translated_lines = []
    language_code = ''
    for translation in translations:
      translated_text = translation.translated_text
      translated_lines.append(translated_text)
      if not language_code:
        language_code = translation.detected_language_code
    translated_lines[0] = prefix + translated_lines[0]
    translated_lines[-1] = translated_lines[-1] + suffix

    self.nvim.request('nvim_buf_set_lines', bufnr, start_row, end_row, False, translated_lines)
    info = f'Detected language: {language_code}.\n{len(translated_lines)} lines translated.'
    self.nvim.request('nvim_notify', info, 2, {})
