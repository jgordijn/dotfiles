set expandtab
set wildmenu
set mouse=a
set clipboard=unnamedplus
set ts=4

call plug#begin('~/.vim/plugged')
" Colors for themes
Plug 'chriskempson/base16-vim'
Plug 'Shougo/denite.nvim'
Plug 'Shougo/deoplete.nvim'
" FZF plugin
Plug '/usr/bin/fzf'
Plug 'junegunn/fzf.vim'

Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree'

Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'Shougo/vimproc.vim'
Plug 'tpope/vim-surround'

" LANGUAGES
" Kotlin
Plug 'udalov/kotlin-vim'
" Typescript
Plug 'Quramy/tsuquyomi'
Plug 'mhartington/nvim-typescript'
Plug 'leafgarland/typescript-vim'
Plug 'jason0x43/vim-js-indent'
Plug 'Quramy/vim-js-pretty-template'
Plug 'HerringtonDarkholme/yats.vim'

" Go
Plug 'fatih/vim-go'
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

" GO config
set autowrite
map <A-n> :cnext<CR>
map <A-m> :cprevious<CR>
nnoremap <A-c> :cclose<CR>
let g:go_list_type = "quickfix"
autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <leader>t  <Plug>(go-test)
" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
	let l:file = expand('%')
	if l:file =~# '^\f\+_test\.go$'
		call go#test#Test(0, 1)
	elseif l:file =~# '^\f\+\.go$'
		call go#cmd#Build(0)
	endif
endfunction
autocmd FileType go nmap <leader>p :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <leader>t  <Plug>(go-test)
autocmd FileType go nmap <leader>c <Plug>(go-coverage-toggle)
autocmd FileType go nmap <leader>T  <Plug>(go-test)
let g:go_fmt_command = "goimports"
"highlighting might be slow
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_generate_tags = 1

autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4 
autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
set foldmethod=syntax

" GO END

source ~/.vimrc_background
