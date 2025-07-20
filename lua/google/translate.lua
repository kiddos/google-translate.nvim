local M = {}

local json = require('vim.json')

local function get_access_token()
  local token = vim.fn.system('gcloud auth application-default print-access-token')
  return token:gsub('%s+', '')
end

local function api_request(url, body)
  local token = get_access_token()
  local project_id = os.getenv('GOOGLE_API_PROJECT_ID')
  local parent = 'projects/' .. project_id
  url = url:gsub('{parent}', parent)

  local cmd = {
    'curl',
    '-X',
    'POST',
    '-H',
    'Authorization: Bearer ' .. token,
    '-H',
    'Content-Type: application/json; charset=utf-8',
    '-d',
    json.encode(body),
    url,
  }
  local response = vim.fn.system(cmd)
  return json.decode(response)
end

function M.translate_text(text, target_language_code)
  local url = 'https://translation.googleapis.com/v3/{parent}:translateText'
  local body = {
    contents = { text },
    targetLanguageCode = target_language_code,
  }
  return api_request(url, body)
end

function M.detect_language(text)
  local url = 'https://translation.googleapis.com/v3/{parent}:detectLanguage'
  local body = {
    content = text,
  }
  return api_request(url, body)
end

function M.get_supported_languages()
  local url = 'https://translation.googleapis.com/v3/{parent}/supportedLanguages'
  local token = get_access_token()
  local project_id = os.getenv('GOOGLE_API_PROJECT_ID')
  local parent = 'projects/' .. project_id
  url = url:gsub('{parent}', parent)

  local cmd = {
    'curl',
    '-X',
    'GET',
    '-H',
    'Authorization: Bearer ' .. token,
    url,
  }
  local response = vim.fn.system(cmd)
  return json.decode(response)
end

return M
