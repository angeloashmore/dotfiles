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
    Plug 'junegunn/rainbow_parentheses.vim'

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

" Language servers
    Plug 'prabirshrestha/async.vim'
    Plug 'prabirshrestha/vim-lsp'
    Plug 'mattn/vim-lsp-settings'
    Plug 'prabirshrestha/asyncomplete.vim'
    Plug 'prabirshrestha/asyncomplete-lsp.vim'

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
    " let g:vista_default_executive = 'coc'

    " Disable special icons (displaying icons requires special font).
    let g:vista#renderer#enable_icon = 0

    " Set default width.
    let g:vista_sidebar_width = 50


" vim-lsp
    let g:lsp_signs_error = {'text': '✗'}
    let g:lsp_signs_warning = {'text': '‼'}
    let g:lsp_signs_hint = {'text': '>'}

map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
