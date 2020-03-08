if exists('g:loaded_nvim_lsp_nice') | finish | endif

let s:save_cpo = &cpo
set cpo&vim

lua require'nvim-lsp-nice'.register_callbacks()

command! LspRestart lua require'nvim-lsp-nice'.buf_restart_clients()
command! LspDiagnosticsNext lua require'nvim-lsp-nice'.buf_jump_to_next_diagnostic()
command! LspDiagnosticsPrev lua require'nvim-lsp-nice'.buf_jump_to_prev_diagnostic()

nnoremap <silent> ]g :LspDiagnosticsNext<CR>
nnoremap <silent> [g :LspDiagnosticsPrev<CR>

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_nvim_lsp_nice = 1
