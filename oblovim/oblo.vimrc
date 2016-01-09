" mapleader
let mapleader = ","

" escape keys
inoremap jk <ESC>
inoremap kj <ESC>

" option  ------------------------------------------- {{{

set autoindent
set number
set incsearch
set ruler
set nobackup
syntax on

" tab style (python tab define in filetype/python.vim)
set tabstop=4
set list
set listchars=tab:\|\ 

" status line
set statusline=%f\ \ \ \ %y\ %m%r%=%b\ %l/%L(%p)
set laststatus=2

" encoding
set encoding=utf-8

" color
colorscheme peachpuff

" switch option
noremap <leader>sw :set wrap!<CR>
noremap <leader>SW :tabdo windo set wrap!<CR>1gt
noremap <leader>sp :set paste!<CR>
noremap <leader>hls :set hlsearch!<CR>

"  ------------------------------------------- }}}

" (non actif) set status line color according to mode (non actif) ------ {{{
" first, enable status line always
"set laststatus=2

" now set it up to change the status line based on mode
"if version >= 700
"  au InsertEnter * hi StatusLine term=reverse ctermbg=5 gui=undercurl guisp=Blue
"  au InsertLeave * hi StatusLine term=reverse ctermfg=0 ctermbg=2 gui=bold,reverse
"endif
" }}}

" source filetype  ------------------------------------------- {{{
augroup kindoffile
	autocmd!
	autocmd BufNewFile,BufRead *.h set filetype=c
	autocmd Filetype vim so ~/config/oblovim/filetype/vim.vim
	autocmd FileType c so ~/config/oblovim/filetype/c.vim
	autocmd FileType python so ~/config/oblovim/filetype/python.vim
	autocmd FileType cpp so ~/config/oblovim/filetype/cpp.vim
	autocmd FileType help :noremap <buffer> q :q<CR>
augroup END
"  ------------------------------------------- }}}
noremap <leader>s :so ~/config/vimrc
noremap <leader>svi :so ~/config/oblovim/filetype/vim.vim<CR>
noremap <leader>sc :so ~/config/oblovim/filetype/c.vim<CR>
noremap <leader>spy :so ~/config/oblovim/filetype/python.vim<CR>
noremap <leader>scpp :so ~/config/oblovim/filetype/cpp.vim<CR>
noremap ss :so %<CR>

" edit config (set new tab)   ------------------------------------------- {{{
fun! SetConfigTab()
	exe ":tabnew"
	exe ":set wrap!"
	exe ":e ~/config/vimrc"
	exe ":rightb vsp ~/config/oblovim/filetype/vim.vim"
	exe ":rightb vsp ~/config/oblovim/filetype/python.vim"
	exe ":sp ~/config/oblovim/filetype/cpp.vim"
	exe "normal \<C-h>"
	exe ":sp ~/config/oblovim/filetype/c.vim"
	exe "normal \<C-h>"
endfunc
"  ------------------------------------------- }}}
noremap <leader>conf :call SetConfigTab()<CR>

" Window management  ------------------------------------------- {{{
noremap <leader>wd :windo

" move window
noremap <C-k> <C-w>k
noremap <C-j> <C-w>j
noremap <C-h> <C-w>h
noremap <C-l> <C-w>l
noremap <C-q> <C-w><C-p>

" resize window
noremap <S-UP> :res -5<CR>
noremap <S-DOWN> :res +5<CR>
noremap <S-LEFT> :vertical res -5<CR>
noremap <S-RIGHT> :vertical res +5<CR>

" new file in new window
noremap <leader>vsh :vsp<CR>:e 
noremap <leader>vsl :rightb vsp<CR>:e 
noremap <leader>sk :sp<CR>:e 
noremap <leader>sj :rightb sp<CR>:e 
"  ------------------------------------------- }}}

" tab management  ------------------------------------------- {{{
noremap <leader>td :tabdo

" move tab

noremap + :tabn<CR>
noremap _ :tabp<CR>
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
" }}}

"  visual mode ----------------------- {{{
let @n = ''
function! SwapVisual()
	let l:len = strlen(@n)
	if l:len  == 0
		exe 'normal! `<v`>"nymn'
	else
		exe 'normal! `<v`>"by`n'.l:len.'x"bP`<v`>"nP'
		let @n = ''
	endif
endfunction
" }}}
vnoremap <leader>s :call SwapVisual()<CR>
vnoremap rr d<C-v>`>I

" fold ------------------------------ {{{
"func! s:closeFold()
"	let l:line = getline('.')
"	if match(l:line, '[{}]\{1,3}\d\?$') != -1
"		exe 'normal zc'
"	else
"		exe 'normal! h'
"	endif
"endfunc

"func! s:swapFold()
"	let l:line = getline('.')
"	if match(l:line, '[{}]\{1,3}\d\?\s*$') != -1
"		exe 'normal za'
"	else
"		exe 'normal! h'
"	endif
"endfunc
" }}}
"noremap h :call <SID>closeFold()<CR>
noremap <SPACE> za
noremap <leader>see zR

" Set scratch buffer  ------------------------------------------- {{{
func! SetScratchBuf(bname)
	setlocal buftype=nofile
	setlocal bufhidden=hide
	setlocal noswapfile
	noremap <buffer> q :bw<CR>
endfunc
"  ------------------------------------------- }}}
noremap <leader>scr :call SetScratchBuf()<CR>

" man  ------------------------------------------- {{{
" Open new window with man page for word under cursor
fun! ReadMan(section)
	let s:man_word = expand('<cword>')
	:exe ":wincmd n"
	:exe ":r!man " . a:section . " " . s:man_word . " | col -b"
	:exe ":goto"
	:exe ":delete"
	:exe ":set filetype=man"
	:setlocal buftype=nofile
	:setlocal bufhidden=hide
	:setlocal noswapfile
endfun
"  ------------------------------------------- }}}
noremap K :call ReadMan("")<CR>
noremap @K :call ReadMan("2")<CR>
noremap #K :call ReadMan("3")<CR>
noremap $K :call ReadMan("4")<CR>
noremap %K :call ReadMan("5")<CR>

" Compile  ------------------------------------------- {{{
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
		exe "normal! :!rm ".l:file[:-2]."o\<CR>"
		exe ":bd"
		silent echo 'ok'
	endif
endfunc

func! s:run()
	silent exe ":!gcc %"
	silent exe "normal! !!./a.out \<CR>"
endfunc

"  ------------------------------------------- }}}
noremap <leader>cc :call CompileOne()<CR>
noremap <leader>out :call <SID>run()

" Comment  ------------------------------------------- {{{
func! Comment1Line()
	let l:len = strlen(b:com) 
	let l:line = getline('.')
	if l:line[0:(l:len - 1)] ==# b:com
		call setline('.', l:line[(l:len):])
	else
		call setline('.', b:com.l:line)
	endif
endfunc

func! CommentVisual() range
	let l:len = strlen(b:com) 
	for lin in range (a:firstline, a:lastline)
		call setline(lin, b:com.getline(lin))
	endfor
endfunc

func! UncommentVisual() range
	let l:len = strlen(b:com) 
	for lin in range (a:firstline, a:lastline)
		let l:line = getline(lin)
		if l:line[0:(l:len - 1)] ==# b:com
			call setline(lin, l:line[(l:len):])
		endif
	endfor
endfunc
"  ------------------------------------------- }}}
nnoremap C :call Comment1Line()<CR>
vnoremap C :call CommentVisual()<CR>
vnoremap u :call UncommentVisual()<CR>

nnoremap <leader>proj :source ~/config/oblovim/cproj.vim<CR>
