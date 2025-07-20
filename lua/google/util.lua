local M = {}

function M.get_selected_text()
  local buf = vim.api.nvim_get_current_buf()
  local start_cursor = vim.api.nvim_call_function('getpos', { "'<" })
  local end_cursor = vim.api.nvim_call_function('getpos', { "'>" })
  local start_row = start_cursor[2] - 1
  local start_col = start_cursor[3] - 1
  local end_row = end_cursor[2] - 1
  local end_col = end_cursor[3]

  local lines = vim.api.nvim_buf_get_lines(buf, start_row, end_row + 1, false)
  if #lines == 0 then
    return ''
  end

  lines[#lines] = string.sub(lines[#lines], 1, end_col)
  lines[1] = string.sub(lines[1], start_col + 1)

  return table.concat(lines, '\\n')
end

return M
