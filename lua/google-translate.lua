local M = {}

local util = require('google.util')
local translator = require('google.translate')

M.translate = function(target_lang)
  local text = util.get_selected_text()
  if text == '' then
    return
  end

  local a = vim.loop.new_async(vim.schedule_wrap(function(_, response)
    if not response or not response.translations then
      vim.notify('Failed to translate text', vim.log.levels.ERROR)
      return
    end

    local translated_text = response.translations[1].translatedText
    local detected_language = response.translations[1].detectedLanguageCode
    local bufnr = vim.api.nvim_get_current_buf()
    local start_cursor = vim.api.nvim_call_function('getpos', { "'<" })
    local end_cursor = vim.api.nvim_call_function('getpos', { "'>" })
    local start_row = start_cursor[2] - 1
    local end_row = end_cursor[2]

    local lines = vim.split(translated_text, '\\n')
    vim.api.nvim_buf_set_lines(bufnr, start_row, end_row, false, lines)
    vim.notify('Translated from ' .. detected_language .. ' to ' .. target_lang)
  end))

  vim.defer_fn(function()
    local response = translator.translate_text(text, target_lang)
    a:send(response)
  end, 0)
end

M.detect_language = function()
  local text = util.get_selected_text()
  if text == '' then
    text = vim.api.nvim_get_current_line()
  end

  local a = vim.loop.new_async(vim.schedule_wrap(function(_, response)
    if not response or not response.languages then
      vim.notify('Failed to detect language', vim.log.levels.ERROR)
      return
    end

    local lang = response.languages[1].languageCode
    local confidence = response.languages[1].confidence
    vim.notify('Detected language: ' .. lang .. ' (confidence: ' .. confidence .. ')')
  end))

  vim.defer_fn(function()
    local response = translator.detect_language(text)
    a:send(response)
  end, 0)
end

M.get_supported_languages = function()
  local a = vim.loop.new_async(vim.schedule_wrap(function(_, response)
    if not response or not response.languages then
      vim.notify('Failed to get supported languages', vim.log.levels.ERROR)
      return
    end

    local languages = {}
    for _, lang in ipairs(response.languages) do
      table.insert(languages, lang.languageCode .. ': ' .. (lang.displayName or ''))
    end
    vim.notify(table.concat(languages, '\\n'))
  end))

  vim.defer_fn(function()
    local response = translator.get_supported_languages()
    a:send(response)
  end, 0)
end

M.setup = function()
  local opts = {
    range = true
  }

  vim.api.nvim_create_user_command('TranslateTW', function() M.translate('zh-TW') end, opts)
  vim.api.nvim_create_user_command('TranslateCN', function() M.translate('zh-CN') end, opts)
  vim.api.nvim_create_user_command('TranslateEN', function() M.translate('en') end, opts)
  vim.api.nvim_create_user_command('DetectLanguage', M.detect_language, opts)
  vim.api.nvim_create_user_command('ListLanguages', M.get_supported_languages, {})
end

return M
