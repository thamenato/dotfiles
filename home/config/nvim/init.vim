" Basic on init.vim from subfuzion
" https://gist.github.com/subfuzion/7d00a6c919eeffaf6d3dbf9a4eb11d64
"
" Plugins (vim-plug)
"

call plug#begin('~/.vim/plugged')

" Theme
  Plug 'crusoexia/vim-monokai'
  Plug 'sainnhe/sonokai'

" Conquer of Completion
  Plug 'neoclide/coc.nvim', {'branch': 'release'}

" NERD Commenter
  Plug 'preservim/nerdcommenter'

" NERD Tree - tree explorer
  Plug 'preservim/nerdtree'
  " show git status in NERD Tree
  Plug 'Xuyuanp/nerdtree-git-plugin'

" vim-airline - enhanced statusline
  Plug 'vim-airline/vim-airline' 
  Plug 'vim-airline/vim-airline-themes' 

" Save/restore session support
  Plug 'tpope/vim-obsession'

" Tagbar
  Plug 'majutsushi/tagbar'

" indentline
  Plug 'Yggdroot/indentLine'

" Tabs/Spaces
  Plug 'tpope/vim-sleuth'
  Plug 'editorconfig/editorconfig-vim'
" Auto Pairs
  Plug 'jiangmiao/auto-pairs'
  Plug 'machakann/vim-sandwich'

  Plug 'cespare/vim-toml'

call plug#end()


" Auto start NERD tree when opening a directory
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | wincmd p | endif

" Auto start NERD tree if no files are specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | exe 'NERDTree' | endif

" Let quit work as expected if after entering :q the only window left open is NERD Tree itself
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"
" Initial Settings
"
syntax on
" theme
set termguicolors
colorscheme sonokai
let g:sonokai_style = 'shusia'
let g:sonokai_enable_italic = 1
let g:sonokai_disable_italic_comment = 1
set guioptions-=r
set guifont=MesloLGS\ NF
" show line numbers
set number relativenumber
" highlight matches when searching
set hlsearch
" disable line wrapping
set nowrap
" enable line and column display
set ruler
" disable showmode since using vim-airline
set noshowmode
"file type recognition
filetype on
filetype plugin on
filetype indent on

" Make it easier to work with buffers
" http://vim.wikia.com/wiki/Easier_buffer_switching
set hidden
set confirm
set autowriteall
set wildmenu wildmode=full

" open new split panes to right and below (as you probably expect)
set splitright
set splitbelow

set expandtab
set tabstop=2
set shiftwidth=2
"key maps
let mapleader=";"

"use ;; for escape
" http://vim.wikia.com/wiki/Avoid_the_escape_key
inoremap ;; <Esc>

" toggle NERDTree
nnoremap <silent> <Space> :NERDTreeToggle<CR>
nmap <F3> :NERDTreeToggle<CR>
" toggle tagbar
nnoremap <silent> <leader>tb :TagbarToggle<CR>
nmap <F4> :TagbarToggle<CR>
" toggle buffer (switch between current and last buffer)
nnoremap <silent> <leader>bb <C-^>
" go to next buffer
nnoremap <silent> <leader>bn :bn<CR>
nnoremap <C-l> :bn<CR>
" go to previous buffer
nnoremap <silent> <leader>bp :bp<CR>
" https://github.com/neovim/neovim/issues/2048
nnoremap <C-h> :bp<CR>
" close buffer
nnoremap <silent> <leader>bd :bd<CR>
" kill buffer
nnoremap <silent> <leader>bk :bd!<CR>
" list buffers
nnoremap <silent> <leader>bl :ls<CR>
" list and select buffer
nnoremap <silent> <leader>bg :ls<CR>:buffer<Space>
" horizontal split with new buffer
nnoremap <silent> <leader>bh :new<CR>
" vertical split with new buffer
nnoremap <silent> <leader>bv :vnew<CR>
" redraw screan and clear search highlighted items
" http://stackoverflow.com/questions/657447/vim-clear-last-search-highlighting#answer-25569434
nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
" improved keyboard navigation
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l
" improved keyboard support for navigation (especially terminal)
" https://neovim.io/doc/user/nvim_terminal_emulator.html
tnoremap <Esc> <C-\><C-n>
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

let g:airline_theme='sonokai'
