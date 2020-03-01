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
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'liuchengxu/vista.vim'

" File finder
    Plug '/usr/local/opt/fzf'
    Plug 'junegunn/fzf.vim'

" Git
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-rhubarb'

" Scratch
    Plug 'duff/vim-scratch'

" Language Support
    Plug 'sheerun/vim-polyglot'
    Plug 'hail2u/vim-css3-syntax'
    Plug 'styled-components/vim-styled-components', { 'branch': 'main' }

" Rainbow parentheses
    Plug 'junegunn/rainbow_parentheses.vim'

" Intellisense
    Plug 'neoclide/coc.nvim', { 'branch': 'release' }

    " Install the following coc.nvim extensions
    "   e.g. :CocInstall coc-tsserver
    "
    " coc-tsserver    - TSServer support for JavaScript/TypeScript
    " coc-json        - JSON support
    " coc-prettier    - Prettier support
    " coc-marketplace - Easily install new coc.nvim extensions

call plug#end()



""""""""""""""""""
" Settings - Settings
""""""""""""""""""

" Clipboard
    " Use the system clipboard
    set clipboard+=unnamedplus

    " Fixes an issue where netrw yanks empty line
    let g:netrw_banner = 1

" UI
    set termguicolors
    set lazyredraw
    set cursorline
    set number

    " Themes
    set background=dark
    colorscheme space_vim_theme

    " Airline
    let g:airline_theme = 'base16_spacemacs'

    " Hide fzf status bar
    autocmd! FileType fzf set laststatus=0 noshowmode noruler
          \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

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

    " Syntax highlight Markdown fenced blocks
    let g:vim_markdown_fenced_languages = ['js', 'bash=sh']

    let g:polyglot_disabled = ['jsx'] 

" Prettier
    command! -nargs=0 Prettier :CocCommand prettier.formatFile

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
      autocmd FileType javascript,lisp,clojure RainbowParentheses
    augroup END

" Vista
    " Use coc.nvim LSP symbols.
    let g:vista_default_executive = 'coc'

    " Disable special icons (displaying icons requires special font).
    let g:vista#renderer#enable_icon = 0

    " Set default width.
    let g:vista_sidebar_width = 50

" coc.nvim
    " Update diagnostics every 300 milliseconds.
    set updatetime=300

    " Use tab for trigger completion with characters ahead and navigate.
    " Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
    inoremap <silent><expr> <TAB>
          \ pumvisible() ? "\<C-n>" :
          \ <SID>check_back_space() ? "\<TAB>" :
          \ coc#refresh()
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

    function! s:check_back_space() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    " Use <c-space> to trigger completion.
    inoremap <silent><expr> <c-space> coc#refresh()

    " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
    " Coc only does snippet and additional edit on confirm.
    inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

    " Use `[g` and `]g` to navigate diagnostics
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)

    " Remap keys for gotos
    nmap <silent> gd <Plug>(coc-definition)

    " Use K to show documentation in preview window
    nnoremap <silent> K :call <SID>show_documentation()<CR>

    function! s:show_documentation()
      if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
      else
        call CocAction('doHover')
      endif
    endfunction

    " Remap for rename current word
    nmap <leader>rn <Plug>(coc-rename)

    " Show all diagnostics
    nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>

    " Remap for format selected region
    xmap <leader>f  <Plug>(coc-format-selected)
    nmap <leader>f  <Plug>(coc-format-selected)

    " Run jest for current project
    command! -nargs=0 Jest :call  CocAction('runCommand', 'jest.projectTest')

    " Run jest for current file
    command! -nargs=0 JestCurrent :call  CocAction('runCommand', 'jest.fileTest', ['%'])

    " Run jest for current test
    nnoremap <leader>te :call CocAction('runCommand', 'jest.singleTest')<CR>
