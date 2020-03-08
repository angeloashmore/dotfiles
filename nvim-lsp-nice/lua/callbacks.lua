local vim = vim

local store = require 'store'
local util = require 'util'

local M = {}

M['textDocument/publishDiagnostics'] = function(_, _, result)
  if not result then return end
  local uri = result.uri
  local bufnr = vim.uri_to_bufnr(uri)
  if not bufnr then
    util.err_message("LSP.publishDiagnostics: Couldn't find buffer for ", uri)
    return
  end
  store.diagnostics[bufnr] = result
end

return M
