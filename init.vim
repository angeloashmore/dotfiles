""""""""""""""""""
" Plugins
""""""""""""""""""

call plug#begin()

" Base
    Plug 'tpope/vim-sensible'
    Plug 'tpope/vim-vinegar'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-repeat'
    Plug 'jiangmiao/auto-pairs'
    Plug 'maxbrunsfeld/vim-yankstack'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-repeat'
    Plug 'junegunn/vim-easy-align'
    Plug 'tpope/vim-abolish'

" UI
    Plug 'balanceiskey/vim-framer-syntax'
    Plug 'liuchengxu/space-vim-theme'
    Plug 'arzg/vim-colors-xcode'
    Plug 'itchyny/lightline.vim'
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'liuchengxu/vista.vim'
    Plug 'junegunn/rainbow_parentheses.vim'

" File finder
    Plug '/usr/local/opt/fzf'
    Plug 'junegunn/fzf.vim'

" Git
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-rhubarb'

" Scratch
    Plug 'duff/vim-scratch'

" Formatting
    Plug 'prettier/vim-prettier', { 'do': 'yarn install' }

" Language Support
    Plug 'sheerun/vim-polyglot'
    Plug 'hail2u/vim-css3-syntax'
    Plug 'styled-components/vim-styled-components', { 'branch': 'main' }

" Language server
    Plug 'prabirshrestha/async.vim'
    Plug 'prabirshrestha/vim-lsp'
    Plug 'mattn/vim-lsp-settings'

" Autocompletion
    Plug 'prabirshrestha/asyncomplete.vim'
    Plug 'prabirshrestha/asyncomplete-lsp.vim'

" Testing
    Plug 'janko/vim-test'

call plug#end()



""""""""""""""""""
" Settings
""""""""""""""""""

" Leader
    map <SPACE> <leader>

" Clipboard
    " Use the system clipboard
    set clipboard+=unnamedplus

    " Fixes an issue where netrw yanks empty line
    let g:netrw_banner = 0

" UI
    set termguicolors
    set lazyredraw
    set cursorline
    set number
    set noshowmode

    " Themes
    set background=dark
    colorscheme space_vim_theme

    " Lightline
		let g:lightline = {
      \ 'colorscheme': 'OldHope',
      \ 'active': {
      \   'left': [ ['mode', 'paste'],
      \             ['gitbranch', 'readonly', 'filename', 'modified'] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ }
      \ }

    " Hide fzf status bar
    autocmd! FileType fzf set laststatus=0 noshowmode noruler
          \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

    " Bind <esc> to close focused floating windows
    augroup customize_floating_windows
        au!
        au BufNew * au OptionSet buftype ++once if has_key(nvim_win_get_config(0), 'anchor')
            \ | exe 'nno <buffer><nowait><silent> <esc> :<c-u>q!<cr>'
            \ | endif
    augroup END

" Terminal window movement mappings
    tnoremap <C-w>h <C-\><C-n><C-w>h
    tnoremap <C-w>j <C-\><C-n><C-w>j
    tnoremap <C-w>k <C-\><C-n><C-w>k
    tnoremap <C-w>l <C-\><C-n><C-w>l

" Indention
    filetype plugin indent on
    set tabstop=2
    set shiftwidth=2
    set expandtab

" Folding
    set foldmethod=indent
    set foldlevelstart=99

" EasyAlign
    " Start interactive EasyAlign in visual mode (e.g. vipga)
    xmap ga <Plug>(EasyAlign)

    " Start interactive EasyAlign for a motion/text object (e.g. gaip)
    nmap ga <Plug>(EasyAlign)

" Yankstack
    let g:yankstack_map_keys = 0
    nmap <C-P> <Plug>yankstack_substitute_older_paste

" Language Support
    let g:jsx_ext_required = 0

    " Set Dockerfile syntax for *.dockerfile
    au BufRead,BufNewFile *.[Dd]ockerfile setf Dockerfile

    let g:polyglot_disabled = ['jsx'] 

" Prettier
    let g:prettier#autoformat = 0

    " vim-prettier's autoformat does not work for .ts/.tsx out of the box
    autocmd BufWritePre *.ts,*.tsx,*.jsx,*.js,*.json,*.css,*.md,*.graphql PrettierAsync

" Make 0 go to first character in line
    map 0 ^

" Allow netrw to remove non-empty local directories
    let g:netrw_rmdir_cmd = 'trash'

" Rainbow parenthesis
    " Add [] and {} support
    let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]

    " Activate on file types
    augroup rainbow_lisp
      autocmd!
      autocmd FileType javascript,javascriptreact,typescript,typescriptreact,lisp,clojure RainbowParentheses
    augroup END

" Vista
    " Use LSP symbols
    let g:vista_default_executive = 'vim_lsp'

    " Disable special icons (displaying icons requires special font)
    let g:vista#renderer#enable_icon = 0
    let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]

    " Set default width
    let g:vista_sidebar_width = 50


" Language server
    let g:lsp_virtual_text_enabled = 0
    let g:lsp_highlight_references_enabled = 1
    let g:lsp_diagnostics_float_cursor = 1
    let g:lsp_diagnostics_float_delay = 0
    " lua require'nvim_lsp'.tsserver.setup{}

    " nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.declaration()<CR>
    " nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
    " nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
    " nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
    " nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
    " nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
    " nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
    " nnoremap <leader>rn     <cmd>lua vim.lsp.buf.rename()<CR>

    " " Restart servers
    " command! -nargs=0 LspRestart <cmd>lua vim.lsp.stop_client(vim.lsp.buf_get_clients())

    " " Load LSP completion into omni
    " autocmd Filetype javascript,javascriptreact,typescript,typescriptreact,json,css,html setlocal omnifunc=v:lua.vim.lsp.omnifunc

" Autocompletion
    inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
    inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"

    imap <c-space> <Plug>(asyncomplete_force_refresh)

    " Register omni as a completion source
    " call asyncomplete#register_source(asyncomplete#sources#omni#get_source_options({
    " \ 'name': 'omni',
    " \ 'whitelist': ['*'],
    " \ 'blacklist': ['c', 'cpp', 'html'],
    " \ 'completor': function('asyncomplete#sources#omni#completor')
    " \  }))

" Testing
    nmap <silent> te :TestNearest<CR>
    nmap <silent> tf :TestFile<CR>
    nmap <silent> ta :TestSuite<CR>
    nmap <silent> tt :TestLast<CR>

    let g:test#strategy = 'neovim'
