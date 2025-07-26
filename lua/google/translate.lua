local M = {}

local json = vim.json

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
  local response = vim.system(cmd, { text = true }):wait()
  return json.decode(response.stdout)
end

M.translate_text = function(text, target_language_code)
  local url = 'https://translation.googleapis.com/v3/{parent}:translateText'
  local body = {
    contents = { text },
    targetLanguageCode = target_language_code,
  }
  return api_request(url, body)
end

M.detect_language = function(text)
  local url = 'https://translation.googleapis.com/v3/{parent}:detectLanguage'
  local body = {
    content = text,
  }
  return api_request(url, body)
end

M.get_supported_languages = function()
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
  local response = vim.system(cmd):wait()
  return json.decode(response.stdout)
end

return M
