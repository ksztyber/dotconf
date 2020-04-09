set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'https://github.com/VundleVim/Vundle.vim'
Plugin 'https://github.com/scrooloose/nerdtree'
Plugin 'https://github.com/mileszs/ack.vim'
Plugin 'https://github.com/ctrlpvim/ctrlp.vim'
Plugin 'https://github.com/Valloric/YouCompleteMe'
Plugin 'https://github.com/rdnetto/YCM-Generator'
Plugin 'https://github.com/airblade/vim-gitgutter.git'
call vundle#end()

filetype plugin on
syntax on
set number
set t_Co=256
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

function! RebuildYCM()
	execute "!~/.vim/bundle/YCM-Generator/config_gen.py ."
	execute "YcmRestartServer"
endfunction

call TabSetup(4,1)
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

"let g:clang_snippets=1
"let g:clang_conceal_snippets=1
" The single one that works with clang_complete
"let g:clang_snippets_engine='clang_complete'
" Make the CtrlP window scrollable
let g:ctrlp_match_window = 'results:100'
" Disable searching working dir
let g:ctrlp_working_path_mode = 'ra'
" Find all files on large projects
let g:ctrlp_custom_ignore = '\.git$\|\.hg$'
let g:ctrlp_max_files=0
let g:ctrlp_max_depth=40
" Powerline fancy symbols
let g:Powerline_symbols = "fancy"
" Change leader to space
let mapleader=' '
" Disable diagnostics
let g:ycm_show_diagnostics_ui=0
let g:ycm_auto_trigger=0
"" Goto buffer
"let g:ycm_goto_buffer_command = 'new-or-existing-tab'
"let g:ycm_key_list_select_completion = [ '<Enter>', '<Down>' ]
"" Disable triggering the identifier completion
"let g:ycm_min_num_of_chars_for_completion = 99
"" Close the preview window after insertion
"let g:ycm_autoclose_preview_window_after_insertion = 1
"
"let g:ycm_collect_identifiers_from_tags_files=1

" Highlight trailing whitespaces
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
autocmd FileType c,cpp,cs,python,perl,sh,make,vim  :match ExtraWhitespace /\s\+$/
"autocmd FileType c,cpp,cs,python,perl,sh,make,vim  :set colorcolumn=80
autocmd FileType c,cpp,cs,python,perl,sh,make,vim  :set colorcolumn=100
autocmd FileType c,cpp,h :source $HOME/.vim/colors/ext-c.vim
"autocmd FileType c,cpp :let g:ycm_global_ycm_extra_conf='~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'

" Hide build / swap files in NERDTree
let NERDTreeIgnore = ['\.[od]$', '\.gcda$', '\.gcno$', '\~$', '\.sw[a-z]$']

" Keep clipboard after vim is exited
" autocmd VimLeave * call system("xsel -ib", getreg('+'))

" powerline
set laststatus=2
"set rtp+=$HOME/.local/lib/python2.7/site-packages/powerline/bindings/vim/
python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup

" 100ms update time for gitgutter to show changes quickly
set updatetime=100

set wildignore+=*.o,*.d,*oprofile_data*,*.ko,*.mod.c,*/\.git/*

command! -nargs=1 Tab 	call TabSetup(<f-args>)
command! -nargs=1 Mks 	call MakeSession("<args>")
command! RebuildYCM	call RebuildYCM()
command! RebuildTags 	!ctags -R .

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
"nnoremap <leader>gg    :Ack! --cc 
"nnoremap <leader>gh    :Ack! --hh 
"nnoremap <leader>gg    :call VimGrep('')<CR><Esc>
"nnoremap <leader>gh    :call VimGrep('{h,hh,hpp}')<CR><Esc>
nnoremap <leader>gh     *N:YcmCompleter GoToDeclaration<CR>
"nnoremap <leader>gg     *N:YcmCompleter GoToDefinition<CR>
nnoremap <leader>gg    *N<C-]>
nnoremap <leader>gv    *N<C-W>g]
nnoremap <leader>gt    *N<C-W><C-]><C-W>T
nnoremap <leader>gc    :call VimGrep('{c,cpp}')<CR><Esc>


if has('clipboard')
  " Keep clipboard when vim is suspended
  :nnoremap <silent> <C-z> :call system("xsel -ib", getreg('+'))<CR><C-z>
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

if filereadable($HOME . "/.vim/vimrc")
    source ~/.vim/vimrc
endif

