local M = {}

M.translate = function(target_lang)
  vim.api.nvim_call_function('_google_translate_selection_async', { target_lang })
end

M.detect_language = function()
  vim.api.nvim_call_function('_google_translate_detect_language_async', {})
end

M.get_supported_languages = function()
  return vim.api.nvim_call_function('_google_translate_supported_languages', {})
end

M.setup = function()
  local opts = {
    range = true
  }

  vim.api.nvim_create_user_command('TranslateTW', function() M.translate('zh-TW') end, opts)
  vim.api.nvim_create_user_command('TranslateCN', function() M.translate('zh-CN') end, opts)
  vim.api.nvim_create_user_command('TranslateEN', function() M.translate('en') end, opts)
  vim.api.nvim_create_user_command('DetectLanguage', M.detect_language, opts)
  vim.api.nvim_create_user_command('ListLanguages', M.get_supported_languages, opts)
end

return M
