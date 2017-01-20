set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'https://github.com/VundleVim/Vundle.vim'
Plugin 'https://github.com/scrooloose/nerdtree'
Plugin 'https://github.com/mileszs/ack.vim'
Plugin 'https://github.com/ctrlpvim/ctrlp.vim'
call vundle#end()

"Plugin 'https://github.com/Valloric/YouCompleteMe'
"Plugin 'https://github.com/rdnetto/YCM-Generator'
"let g:ycm_enable_diagnostic_signs = 0
"let g:ycm_enable_diagnostic_highlighting = 0

"call pathogen#infect()
filetype plugin on
syntax on
set number
"let g:NERTTreeDirArrows=0
set t_Co=256
color mustang

" Disable ESC timeout
set timeoutlen=1000 ttimeoutlen=0

let s:activedh = 1

function! TabSetup(width)
  set expandtab
  let &shiftwidth=a:width
  let &tabstop=a:width
  set smarttab
  set autoindent
  set smartindent
endfunction

function! ToggleExtraWhitespaceH()
  if s:activedh == 0
    let s:activedh = 1
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
"  if a:search
    "echom 'Reg = ' getreg('/')
    let val = getreg('/')
    let val = substitute(val, '^ *\\<', '', 'g')
    let val = substitute(val, '\\> *$', '', 'g')
"  else
"    let val = getreg('/')
"  endif if !empty(val)
    call system("xsel -ib", val)
  "endif
endfunction

call TabSetup(4)
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
" Set format text to 120 columns
set textwidth=120

"let g:clang_snippets=1
"let g:clang_conceal_snippets=1
" The single one that works with clang_complete
"let g:clang_snippets_engine='clang_complete'
" Make the CtrlP window scrollable
let g:ctrlp_match_window = 'results:100'
" Disable searching working dir
let g:ctrlp_working_path_mode = 0
" Powerline fancy symbols
let g:Powerline_symbols = "fancy"
" Change leader to space
let mapleader=' '

" Highlight trailing whitespaces

highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
autocmd FileType c,cpp,cs,python,perl,sh,make,vim  :match ExtraWhitespace /\s\+$/
"autocmd FileType c,cpp,cs,python,perl,sh,make,vim  :set colorcolumn=80
autocmd FileType c,cpp,cs,python,perl,sh,make,vim  :set colorcolumn=120
autocmd FileType c,cpp,h :source $HOME/.vim/colors/ext-c.vim
autocmd FileType c,cpp :let g:ycm_global_ycm_extra_conf='~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'

" Keep clipboard after vim is exited
autocmd VimLeave * call system("xsel -ib", getreg('+'))
"autocmd VimEnter * call setreg('/', getreg('+'))
"autocmd FocusGained * echo 'Getting reg = ' getreg('+') 
"call setreg('/', getreg('+'))

" Complete options (disable preview scratch window, longest removed to aways
" show menu)
" set completeopt=menu,menuone

" Limit popup menu height
" set pumheight=20

" SuperTab completion fall-back
" let g:SuperTabDefaultCompletionType='<c-x><c-u><c-p>'

" powerline
set laststatus=2
"set rtp+=$HOME/.local/lib/python2.7/site-packages/powerline/bindings/vim/
python from powerline.vim import setup as powerline_setup
python powerline_setup()
python del powerline_setup

set wildignore+=*.o,*.d,*oprofile_data*

command! -nargs=1 Tab call TabSetup(<f-args>)

function! VimGrep()
    let filetypes = {}
    let filetypes['c']      = '{c,cpp,h}'
    let filetypes['cpp']    = '{c,cpp,h}'
    let filetypes['python'] = '{py}'
    let l:pattern = GetSearchReg()
    execute "vimgrep! /" . l:pattern . "/g **/*." . get(filetypes, &filetype, expand('%:e'))
    copen
endfunction

nnoremap <C-f>         :tabn<CR><Esc>
nnoremap <C-d>         :tabp<CR><Esc>
nnoremap <C-e>         :tabe 
nnoremap <C-n>         :NERDTreeToggle<CR>
nnoremap <C-p>         :CtrlP<CR>
nnoremap <silent> <F2> :let @/ = ""<CR><Esc>
nnoremap <F3>          :call ToggleExtraWhitespaceH()<CR><Esc>
nnoremap ?             :set relativenumber!<CR><Esc>
nnoremap K             :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
nnoremap <leader>ff    :NERDTreeFind<CR>
nnoremap <leader>m     :tabn<CR><Esc>
nnoremap <leader>n     :tabp<CR><Esc>
nnoremap <leader>df    *NN:YcmCompleter GoTo<CR><Esc>
nnoremap <leader>fd    :e #<CR><Esc>
nnoremap <leader>[     [{
nnoremap <leader>]     ]}
nnoremap <leader>kk    <C-w>k
nnoremap <leader>jj    <C-w>j
nnoremap <leader>qq    :q<CR><Esc>
nnoremap <leader>v     :tabn<CR><Esc>
nnoremap <leader>c     :tabp<CR><Esc>
"nnoremap <leader>gg    :Ack! --cc 
"nnoremap <leader>gh    :Ack! --hh 
nnoremap <leader>gg    :call VimGrep()<CR><Esc>


if has('clipboard')
  " Keep clipboard when vim is suspended
"  :nnoremap <silent> <C-z> :call system("xsel -ib", getreg('+'))<CR><C-z>
"  :nnoremap <silent> <C-z> :call CopySearchClipboard(0)<CR><C-z>
  "<CR><C-z>
"  :nnoremap <silent> * *N :call CopySearchClipboard(1)<CR><Esc>
  :nnoremap <silent> * *N :call CopySearchClipboard(1)<CR><Esc>
endif

" tmux/screen sisue
"set t_ut=

" vimdiff color schemes
highlight DiffAdd    cterm=bold ctermbg=17 gui=none guibg=Red
highlight DiffDelete cterm=bold ctermbg=17 gui=none guibg=Red
highlight DiffChange cterm=bold ctermbg=17 gui=none guibg=Red
highlight DiffText   cterm=bold ctermbg=88 gui=none guibg=Red

" source ext c syntax
:source ~/.vim/colors/ext-c.vim

