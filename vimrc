call pathogen#infect()
filetype plugin on
syntax on
set number
"let g:NERTTreeDirArrows=0
set t_Co=256
color mustang

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

function! CopySearchClipboard()
  if ! has('clipboard')
    return
  endif
  let val = getreg('/')
  let val = substitute(val, '^\\<', '', 'g')
  let val = substitute(val, '\\>$', '', 'g')
  call system("xsel -ib", val)
endfunction

call TabSetup(2)
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

let g:clang_snippets=1
let g:clang_conceal_snippets=1
" The single one that works with clang_complete
let g:clang_snippets_engine='clang_complete'
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
autocmd FileType c,cpp,cs,python,perl,sh,make,vim  :set colorcolumn=80
autocmd FileType c,cpp,h :source $HOME/.vim/colors/ext-c.vim

" Keep clipboard after vim is exited
autocmd VimLeave * call system("xsel -ib", getreg('+'))

" Complete options (disable preview scratch window, longest removed to aways
" show menu)
" set completeopt=menu,menuone

" Limit popup menu height
" set pumheight=20

" SuperTab completion fall-back
" let g:SuperTabDefaultCompletionType='<c-x><c-u><c-p>'

" powerline
set laststatus=2
set rtp+=$HOME/.local/lib/python2.7/site-packages/powerline/bindings/vim/

set wildignore+=*.o,*.d,*oprofile_data*

command! -nargs=1 Tab call TabSetup(<f-args>)

nnoremap <C-f>      :tabn<CR><Esc>
nnoremap <C-d>      :tabp<CR><Esc>
nnoremap <C-e>      :tabe 
nnoremap <C-n>      :NERDTreeToggle<CR>
nnoremap <C-p>      :CtrlP<CR>
"nnoremap <F2>       :set hlsearch!<CR><Esc>
nnoremap <silent> <F2> :let @/ = ""<CR><Esc>
nnoremap <F3>       :call ToggleExtraWhitespaceH()<CR><Esc>
nnoremap ?          :set relativenumber!<CR><Esc>
nnoremap K          :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
nnoremap <leader>f  :NERDTreeFind<CR>
nnoremap <leader>m  :tabn<CR><Esc>
nnoremap <leader>n  :tabp<CR><Esc>

if has('clipboard')
" Keep clipboard when vim is suspended
:nnoremap <silent> <C-z> :call system("xsel -ib", getreg('+'))<CR><C-z>
:nnoremap <silent> * * :call CopySearchClipboard()<CR>
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

