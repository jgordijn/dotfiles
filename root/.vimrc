call plug#begin('~/.vim/plugged')
" Colors for themes
Plug 'chriskempson/base16-vim'
Plug 'Shougo/denite.nvim'
Plug 'Shougo/deoplete.nvim'
" FZF plugin
Plug '/usr/bin/fzf'
Plug 'junegunn/fzf.vim'

Plug 'udalov/kotlin-vim'
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree'
Plug 'mhartington/nvim-typescript'
Plug 'Quramy/tsuquyomi'
Plug 'leafgarland/typescript-vim'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'fatih/vim-go'
Plug 'jason0x43/vim-js-indent'
Plug 'Quramy/vim-js-pretty-template'
Plug 'Shougo/vimproc.vim'
Plug 'tpope/vim-surround'
Plug 'HerringtonDarkholme/yats.vim'
call plug#end()
let base16colorspace=256  " Access colors present in 256 colorspace
let mapleader=" "

" NERD Tree
" When vim starts without arg, or with dirname, start NERDTree automatically
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
"Close vim when NERDTree is last open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

map <C-n> :NERDTreeToggle<CR>
" end NERD Tree

" FZF START
map <leader>b :Buffers<CR>
map <leader>f :Files<cr>
map <leader>F :GFiles<cr>
map <leader>s :Ag 
" FZF END

source ~/.vimrc_background
