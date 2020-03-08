local vim = vim
local api = vim.api
local validate = vim.validate
local lsp = vim.lsp

local M = {}

-- Restarts a client and returns the client ID.
function M.restart_client(client_id)
  validate {
    client_id = { client_id, 'n' }
  }

  local client = lsp.get_client_by_id(client_id)
  lsp.stop_client(client_id)
  return lsp.start_client(client.config)
end

-- Restarts a client for a buffer.
function M.buf_restart_client(bufnr, client_id)
  validate {
    bufnr = { bufnr, 'n' },
    client_id = { client_id, 'n' }
  }

  local new_client_id = M.restart_client(client_id)
  lsp.buf_attach_client(bufnr, new_client_id)
end

-- Determines if a cursor position is after a range.
function M.is_cursor_after_range(cursor, range, inclusive)
  validate {
    ['cursor[1]'] = { cursor[1], 'n' },
    ['cursor[2]'] = { cursor[2], 'n' },
    ['range.start.line'] = { range.start.line, 'n' },
    ['range.start.character'] = { range.start.character, 'n' },
    ['range.end.line'] = { range['end'].line, 'n' },
    ['range.end.character'] = { range['end'].character, 'n' },
    inclusive = { inclusive, 'b', true }
  }
  if type(inclusive) ~= 'boolean' then inclusive = true end

  local line = cursor[1]
  local column = cursor[2]

  local line_dir = M.distance_to_direction(line - 1 - range.start.line)
  local column_dir = M.distance_to_direction(column - range.start.character)

  if line_dir > 0 then return true end
  if line_dir < 0 then return false end

  if column_dir > 0 then return true end
  if column_dir < 0 then return false end

  return inclusive
end

-- Converts a unit-less distance to a numerical direction.
function M.distance_to_direction(distance)
  validate {
    distange = { distance, 'n' }
  }

  if distance > 0 then
    return 1
  elseif distance == 0 then
    return 0
  else
    return -1
  end
end

-- Reverses an array. Returns a new array.
function M.reverse(arr)
  local reversed = {}

  local n = #arr
  local i = 1
  while i <= n do
    reversed[i] = arr[n - i + 1]
    i = i + 1
  end

  return reversed
end

-- Prints an error message.
function M.err_message(...)
  api.nvim_err_writeln(table.concat(vim.tbl_flatten{...}))
  api.nvim_command("redraw")
end

return M
