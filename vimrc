set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'https://github.com/VundleVim/Vundle.vim'
Plugin 'https://github.com/scrooloose/nerdtree'
Plugin 'https://github.com/mileszs/ack.vim'
Plugin 'https://github.com/ctrlpvim/ctrlp.vim'
Plugin 'https://github.com/airblade/vim-gitgutter.git'
call vundle#end()

call plug#begin('~/.vim/plugged')
Plug 'MattesGroeger/vim-bookmarks'
" coc.nvim requires nodejs
if has('node')
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
end
call plug#end()

filetype plugin on
syntax on
set number
set t_Co=256
set hlsearch
color mustang

" Disable ESC timeout
set timeoutlen=1000 ttimeoutlen=0
" Disable immediate jump when searching
set noincsearch

let s:activedh = 1

function! TabSetup(width, expand)
  if a:expand
    set expandtab
  else
    set noexpandtab
  endif
  let &shiftwidth=a:width
  let &tabstop=a:width
  set smarttab
  set autoindent
  set smartindent
endfunction

function! ToggleExtraWhitespaceH()
  if s:activedh == 0
    let s:activedh = 1
    highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
    match ExtraWhitespace /\s\+$/
  else
    let s:activedh = 0
    match none
  endif
endfunction

function! GetSearchReg()
    let val = getreg('/')
    let val = substitute(val, '^ *\\<', '', 'g')
    let val = substitute(val, '\\> *$', '', 'g')
    return val
endfunction

function! CopySearchClipboard(search)
  if ! has('clipboard')
    return
  endif
    let val = getreg('/')
    let val = substitute(val, '^ *\\<', '', 'g')
    let val = substitute(val, '\\> *$', '', 'g')
    call system("xsel -ib", val)
endfunction

let s:mouse_en = 0
function! ToggleMouse()
    if s:mouse_en == 0
        let s:mouse_en = 1
        set mouse=a
    else
        let s:mouse_en = 0
        set mouse=
    endif
endfunction

function! VimGrep(type)
    let filetypes = {}
    let filetypes['c']      = '{c,cpp,h,hpp,hh}'
    let filetypes['cpp']    = '{c,cpp,h,hpp,hh}'
    let filetypes['python'] = '{py}'
    let l:pattern = GetSearchReg()
    if a:type == ""
        let l:ft = get(filetypes, &filetype, expand('%:e'))
    else
        let l:ft = a:type
    endif
    execute "vimgrep /" . l:pattern . "/j **/*." . l:ft
    copen
endfunction

function! MakeSession(name)
    let fname = $HOME . "/.vim/sessions/" . a:name
    execute "mksession! " . fname
endfunction

function! OpenSession(name)
    let fname = $HOME . "/.vim/sessions/" . a:name
    execute "source " . fname
endfunction

function! HasDisplay()
	let _ = system('xsel')
	return v:shell_error == 0
endfunction

if HasDisplay()
	set mouse=a
endif
call TabSetup(8,0)
set conceallevel=2
set concealcursor=vin
set runtimepath^=~/.vim/bundle/ctrlp.vim
set ignorecase
set smartcase
set autoindent
" fixes ultra slow vimdiff scroll
set lazyredraw
" Copy yanks to X11's clipboard
set clipboard=unnamedplus
" Set format text to 100 columns
set textwidth=100
"Keep sessions light and only remember opened tabs
set sessionoptions-=options

" Make the CtrlP window scrollable
let g:ctrlp_match_window = 'results:100'
" Disable searching working dir
let g:ctrlp_working_path_mode = 'ra'
" Find all files on large projects
let g:ctrlp_custom_ignore = '\.git$\|\.hg$'
let g:ctrlp_max_files=0
let g:ctrlp_max_depth=40
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
if executable('ag')
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif
" Powerline fancy symbols
let g:Powerline_symbols = "fancy"
" Change leader to space
let mapleader=' '

" Highlight trailing whitespaces
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
autocmd FileType c,cpp,cs,python,perl,sh,make,vim  :match ExtraWhitespace /\s\+$/
autocmd FileType c,cpp,cs,python,perl,sh,make,vim,rust  :set colorcolumn=100
autocmd FileType c,cpp,h :source $HOME/.vim/colors/ext-c.vim
" Enable spellchecker in gitcommit
autocmd FileType gitcommit :set spell

" Hide build / swap files in NERDTree
let NERDTreeIgnore = ['\.[od]$', '\.gcda$', '\.gcno$', '\~$', '\.sw[a-z]$']

" powerline
python3 import vim, importlib.util;
	\ vim.command('let has_powerline={}'.format(
	\	int(importlib.util.find_spec("powerline") is not None)))

if has_powerline
	set laststatus=2
	python3 from powerline.vim import setup as powerline_setup
	python3 powerline_setup()
	python3 del powerline_setup
endif

" 100ms update time for gitgutter to show changes quickly
set updatetime=100

set wildignore+=*.o,*.d,*oprofile_data*,*.ko,*.mod.c,*/\.git/*

command! -nargs=1 Tab 	call TabSetup(<f-args>)
command! -nargs=1 Mks 	call MakeSession("<args>")
command! RebuildTags 	!ctags -R .

" coc.nvim requires nodejs
if has('node')
	" coc.nvim settings
	" This disables the transparent cursor, which makes the cursor disappear when C-c'ed when
	" displaying a list (e.g. from coc-references).
	let g:coc_disable_transparent_cursor = 1
	nmap <silent> gd <Plug>(coc-definition)
	nmap <silent> gi <Plug>(coc-implementation)
	nmap <silent> gr <Plug>(coc-references)
	nmap <silent> gh <Plug>(coc-declaration)
	nmap <leader>gg :call CocAction('jumpDefinition')<CR><Esc>
	nmap <leader>gh :call CocAction('jumpDeclaration')<CR><Esc>
	nmap <leader>gr :call CocAction('jumpReferences')<CR><Esc>

	" Use <c-space> to trigger completion.
	if has('nvim')
		inoremap <silent><expr> <c-space> coc#refresh()
	else
		inoremap <silent><expr> <c-@> coc#refresh()
	endif
	" Use tab for trigger completion with characters ahead and navigate.
	inoremap <silent><expr> <TAB>
		\ pumvisible() ? "\<C-n>" : "\<TAB>"
	 inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
	" Highlight the symbol and its references when holding the cursor.
	autocmd CursorHold * silent call CocActionAsync('highlight')
end

" vim-bookmark's settings
highlight BookmarkSign ctermbg=NONE ctermfg=160
highlight BookmarkLine ctermbg=2 ctermfg=NONE
let g:bookmark_sign = '!!'
let g:bookmark_highlight_lines = 1

nnoremap <C-f>         :tabn<CR><Esc>
nnoremap <C-d>         :tabp<CR><Esc>
nnoremap <C-e>         :tabe 
nnoremap <C-n>         :NERDTreeToggle<CR>
nnoremap <C-p>         :CtrlP<CR>
nnoremap <silent> <F2> :let @/ = ""<CR><Esc>
nnoremap <F3>          :call ToggleExtraWhitespaceH()<CR><Esc>
nnoremap <F4>          :call ToggleMouse()<CR><Esc>
nnoremap ?             :set relativenumber!<CR><Esc>
nnoremap J             <C-E>
nnoremap K             <C-Y>
nnoremap <leader>ff    :NERDTreeFind<CR>
nnoremap <leader>m     :tabn<CR><Esc>
nnoremap <leader>n     :tabp<CR><Esc>
nnoremap <leader>fd    :e #<CR><Esc>
nnoremap <leader>[     [{
nnoremap <leader>]     ]}
nnoremap <leader>kk    <C-w>k
nnoremap <leader>jj    <C-w>j
nnoremap <leader>qq    :q<CR><Esc>
nnoremap <leader>v     :tabn<CR><Esc>
nnoremap <leader>c     :tabp<CR><Esc>

if has('clipboard')
  " Keep clipboard when vim is suspended
  :nnoremap <silent> <C-z> :call system("xsel -ib", getreg('+'))<CR><C-z>
  :nnoremap <silent> * *N :call CopySearchClipboard(1)<CR><Esc>
endif

" vimdiff color schemes
highlight DiffAdd    cterm=bold ctermbg=17 gui=none guibg=Red
highlight DiffDelete cterm=bold ctermbg=17 gui=none guibg=Red
highlight DiffChange cterm=bold ctermbg=17 gui=none guibg=Red
highlight DiffText   cterm=bold ctermbg=88 gui=none guibg=Red

highlight GitGutterAdd    ctermfg=2
highlight GitGutterChange ctermfg=3
highlight GitGutterDelete ctermfg=1

" source ext c syntax
:source ~/.vim/colors/ext-c.vim

if filereadable($HOME . "/.vim/vimrc")
    source ~/.vim/vimrc
endif
