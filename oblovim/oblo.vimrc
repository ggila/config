" **************************************************************************** "
"                                                                              "
"                                                         :::      ::::::::    "
"    oblovimrc                                          :+:      :+:    :+:    "
"                                                     +:+ +:+         +:+      "
"    By: ggilaber <ggilaber@student.42.fr>          +#+  +:+       +#+         "
"                                                 +#+#+#+#+#+   +#+            "
"    Created: 2015/11/12 02:31:18 by ggilaber          #+#    #+#              "
"    Updated: 2015/12/07 08:17:56 by ggilaber         ###   ########.fr        "
"                                                                              "
" **************************************************************************** "

set foldlevelstart=0

" option {{{
set autoindent
set number
syntax on

" tab style
set tabstop=4
set list
set listchars=tab:\|\ 

set mouse=a
set ruler
set nobackup

" status line
set statusline=%f\ %m%r%=%b\ %y\ %l/%L(%p)

" encoding
set encoding=utf-8

" color
colorscheme peachpuff
" }}}

" source filetype {{{
augroup autocom
	autocmd!
	autocmd BufNewFile,BufRead  *vimrc so ~/config/oblovim/filetype/vim.vimrc
	autocmd bufwritepost *vimrc so ~/config/vimrc
	autocmd FileType c so ~/config/oblovim/filetype/c.vimrc
	autocmd FileType python so ~/config/oblovim/filetype/python.vimrc
	autocmd FileType cpp so ~/config/oblovim/filetype/cpp.vimrc
augroup END
" }}}

" mapleader
let mapleader = ","

" edit config (set new tab)  {{{
fun! SetConfigTab()
	exe ":tabnew ~/config/zshrc"
	exe ":set wrap!"
	exe ":vsp ~/config/vimrc"
	exe ":rightb vsp ~/config/oblovim/filetype/vim.vimrc"
	exe ":sp ~/config/oblovim/filetype/cpp.vimrc"
	exe ":sp ~/config/oblovim/filetype/python.vimrc"
	exe ":sp ~/config/oblovim/filetype/c.vimrc"
	exe "normal \<C-h>"
endfunc
" }}}

noremap <leader>vimrc :call SetConfigTab()<CR>

" Window management {{{
" move window
noremap <C-k> <C-w>k
noremap <C-j> <C-w>j
noremap <C-h> <C-w>h
noremap <C-l> <C-w>l
noremap <C-a> <C-w><C-p>

" resize window
noremap <S-UP> :res -5<CR>
noremap <S-DOWN> :res +5<CR>
noremap <S-LEFT> :vertical res -5<CR>
noremap <S-RIGHT> :vertical res +5<CR>

" new file in new window
noremap <leader>hs :vsp<CR>:e 
noremap <leader>ls :rightb vsp<CR>:e 
noremap <leader>ks :sp<CR>:e 
noremap <leader>js :rightb sp<CR>:e 
" }}}

" move tab
noremap <C-x>h :tabp<CR>
noremap <C-x>l :tabn<CR>

" switch option
noremap <leader>sw <ESC>:set wrap!<CR>
noremap <leader>sp <ESC>:set paste!<CR>

" visual block replace
vnoremap rr d<C-v>`>I

" hlsearch
set incsearch
noremap <leader>hls :set hlsearch!<CR>

" escape keys
inoremap jk <ESC>
inoremap kj <ESC>

" consult man
so ~/config/oblovim/script/man.vim

func! SetScratchBuf()
	setlocal buftype=nofile
	setlocal bufhidden=hide
	setlocal noswapfile
endfunc
noremap <leader>scr :e _scratch<CR>:call SetScratchBuf()<CR>

" project plugin
" if filereadable(".project/vimrc")
" 	so .project/vimrc
" endif

" Compile {{{
fun! CompileOne()
	let l:file = bufname('%')
	if bufexists("_cc")
		exe ":bw _cc"
	endif
	exe ":sp _cc"
	setlocal buftype=nofile
	setlocal bufhidden=hide
	setlocal noswapfile
	silent exe "normal! !!gcc -c ".l:file."\<CR>"
	if (line('$') == 1)
		exe "normal! !rm ".l:file[:-2]."o"."\<CR>"
		exe ":bd"
		echo 'ok'
	endif
endfunc
" }}}

noremap <leader>cc :call CompileOne()<CR>
