local vim = vim
local api = vim.api
local lsp = vim.lsp
local validate = vim.validate

local util = require 'util'
local callbacks = require 'callbacks'
local store = require 'store'

local M = {}

-- Determines if this plugin's LSP request/response callbacks have been
-- registered.
M.callbacks_are_registered = false

-- Registers this plugin's LSP request/response callbacks. Existing callbacks
-- are called _before_ this plugin's callbacks.
function M.register_callbacks()
  -- Return early if callbacks were already registered.
  if M.callbacks_are_registered then return end

  for k,callback in pairs(callbacks) do
    local existing_callback = lsp.callbacks[k]
    lsp.callbacks[k] = function(...)
      if existing_callback then existing_callback(...) end
      callback(...)
    end
  end

  M.callbacks_are_registered = true
end

-- Restarts all clients for the given buffer.
function M.buf_restart_clients(bufnr)
  validate {
    bufnr = { bufnr, 'n', true }
  }
  bufnr = bufnr or api.nvim_win_get_buf(0)

  local buf_clients = lsp.buf_get_clients(bufnr)
  for _, client in ipairs(buf_clients) do
    util.buf_restart_client(bufnr, client.id)
  end
end

-- Changes cursor location to next closest diagnostic.
function M.buf_jump_to_next_diagnostic(bufnr)
  validate {
    bufnr = { bufnr, 'n', true }
  }
  bufnr = bufnr or api.nvim_win_get_buf(0)

  local buf_diagnostics = store.diagnostics[bufnr]
  local diagnostics = buf_diagnostics.diagnostics
  local next_diagnostic

  local cursor = api.nvim_win_get_cursor(0)

  for _,diagnostic in ipairs(diagnostics) do
    local range = diagnostic.range
    local cursor_is_after = util.is_cursor_after_range(cursor, range)

    if not cursor_is_after then
      next_diagnostic = diagnostic
      break
    end
  end

  if not next_diagnostic then
    print('No next diagnostic')
    return
  end

  local location = {
    uri = buf_diagnostics.uri,
    range = next_diagnostic.range
  }
  lsp.util.jump_to_location(location)
end

-- Changes cursor location to previous closest diagnostic.
function M.buf_jump_to_prev_diagnostic(bufnr)
  validate {
    bufnr = { bufnr, 'n', true }
  }
  bufnr = bufnr or api.nvim_win_get_buf(0)

  local buf_diagnostics = store.diagnostics[bufnr]
  local diagnostics = buf_diagnostics.diagnostics
  local prev_diagnostic

  local cursor = api.nvim_win_get_cursor(0)

  for _,diagnostic in ipairs(util.reverse(diagnostics)) do
    local range = diagnostic.range
    local cursor_is_after = util.is_cursor_after_range(cursor, range, false)

    if cursor_is_after then
      prev_diagnostic = diagnostic
      break
    end
  end

  if not prev_diagnostic then
    print('No previous diagnostic')
    return
  end

  local location = {
    uri = buf_diagnostics.uri,
    range = prev_diagnostic.range
  }
  lsp.util.jump_to_location(location)
end

return M
