"
" ~/.vimrc by pbrisbin 2009
"

" OPTIONS {{{
" set 256 colors if we can
if $TERM =~ "-256color"
  set t_Co=256
  colorscheme evening 
endif

if $TERM =~ "rxvt"
  "Set the cursor white in cmd-mode and orange in insert mode
  let &t_EI = "\<Esc>]12;white\x9c"
  let &t_SI = "\<Esc>]12;red\x9c"
  "We normally start in cmd-mode
  silent !echo -e "\e]12;white\x9c"
  set t_Co=256
  colorscheme desert
endif

" set the window title in screen
if $STY != ""
  set t_ts=k
  set t_fs=\
endif

" use folding if we can
if has ('folding')
  set foldenable
  set foldmethod=marker
  set foldmarker={{{,}}}
  set foldcolumn=0
endif

" main options
set autoindent
set autowrite
set backspace=indent,eol,start
set completeopt=longest
set cursorline
set expandtab
set history=50
set hls
set incsearch
set laststatus=2
set mouse=v
set nobackup
set nocompatible
set nomousehide
set nowrap
set novisualbell
set number
set ruler
set scrolloff=5
set shiftwidth=4
set shortmess+=r
set showmode
set showcmd
set showtabline=1
set sm
set smartcase
set smartindent
set smarttab
set splitright
set tags=~/.tags
set textwidth=0
set title
set vb t_vb=
set wildmode=longest,full

" syntax highlighting
syntax on
filetype plugin indent on

" change <LocalLeader> to ,
let maplocalleader = ','

" python
let python_highlight_all=1
let python_highlight_space_errors=1
let python_fold=1

" lua
let lua_fold=1
let lua_version=5
let lua_subversion=1

" java
let java_highlight_all=1
let java_highlight_functions="style"
let java_allow_cpp_keywords=1

" eclim
let g:EclimBrowser     = '$BROWSER'
let g:EclimHome        = '/usr/share/vim/vimfiles/eclim'
let g:EclimEclipseHome = '/usr/share/eclipse'

" default comment symbols
let StartComment="#"
let EndComment=""

" }}}

" KEYMAPS {{{
" unmap annoying keys
nnoremap q: <Nop>
nnoremap q/ <Nop>
nnoremap q? <Nop>

" quicker window navigation
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" a transpose key
nmap <LocalLeader>t xp

" comment/uncomment a visual block
vmap <LocalLeader>c :call CommentLines()<CR>

" save the current file as root and reload
cmap w!! w !sudo tee % >/dev/null<CR>:e!<CR><CR>

" }}}

" AUTOCOMMANDS {{{
if has('autocmd')
  " vim itself
  au FileType vim let StartComment = "\""
  au BufWritePost ~/.vimrc source %

  " always do these
  au BufRead     * call SetStatusLine()
  au BufReadPost * call RestoreCursorPos()
  au BufWinEnter * call OpenFoldOnRestore()
  au BufEnter    * let &titlestring = "vim: " . substitute(expand("%:p"), $HOME, "~", '')
  au BufEnter    * let &titleold    = substitute(getcwd(), $HOME, "~", '')

  " file types for nonstandard/additional config files
  au BufNewFile,BufRead *conkyrc*          set ft=conkyrc
  au BufNewFile,BufRead *muttrc*           set ft=muttrc
  au BufNewFile,BufRead *.txt              set ft=text
  au BufNewFile,BufRead *.rem              set ft=remind
  au BufNewFile,BufRead *.xcolors          set ft=xdefaults
  au BufNewFile,BufRead *.rss              set ft=xml
  au BufNewFile,BufRead ~/.mutt/temp/*     set ft=mail

  if $SCREEN_CONF_DIR != ""
    au BufNewFile,BufRead $SCREEN_CONF_DIR/* set ft=screen
  endif

  " shorter filetype stuff
  au FileType c      set fo+=ro
  au FileType c,cpp  let StartComment = "//"
  au FileType c,cpp  syn match matchName /\(#define\)\@<= .*/
  au FileType text   set tw=72
  au FileType text   set fo+=t
  au FileType make   set shiftwidth=8
  au FileType python set shiftwidth=4 tabstop=4

  " haskell options {{{
  au Filetype haskell call SetHaskellOpts()

  function! SetHaskellOpts()
    command! CheckHaskell :! ghci % <CR>
    let StartComment = "--"
  endfunction
  " }}}

  " java options {{{
  au Filetype java call SetJavaOpts()

  function! SetJavaOpts()
    set sw=4
    set foldmethod=indent

    nnoremap <silent> <LocalLeader>i :JavaImport<CR>
    nnoremap <silent> <LocalLeader>d :JavaDocSearch -x declarations<CR>
    nnoremap <silent> <LocalLeader><CR> :JavaSearchContext<CR>
    nnoremap <silent> <LocalLeader>jv :Validate<CR>
    nnoremap <silent> <LocalLeader>jc :JavaCorrect<CR>

    " supertab
    let g:SuperTabDefaultCompletionTypeDiscovery = [
          \ "&completefunc:<c-x><c-u>",
          \ "&omnifunc:<c-x><c-o>",
          \ ]

    let g:SuperTabLongestHighlight = 1
    let StartComment="//"
  endfunction
  " }}}

  " mail options {{{
  au Filetype mail call SetMailOpts()

  function! SetMailOpts()
    source ~/.vim/autofix.vimrc " auto-correct

    set spell
    set nohls

    " auto format all paragraphs
    set fo+=a

    nmap <F1> gqap
    nmap <F2> gqqj
    nmap <F3> kgqj
    map! <F1> <ESC>gqapi
    map! <F2> <ESC>gqqji
    map! <F3> <ESC>kgqji
  endfunction
  " }}}

  " html/php options {{{
  au Filetype html,xhtml,php call SetWebOpts()

  function! SetWebOpts()
    set spell
    set tw=80

    " format text
    set fo+=t

    command! CheckPHP :! php -l % <CR>
    command! OpenPHP :! php % <CR>

    nmap <F1> gqap
    nmap <F2> gqqj
    nmap <F3> kgqj
    map! <F1> <ESC>gqapi
    map! <F2> <ESC>gqqji
    map! <F3> <ESC>kgqji

    au Filetype html,xhtml let StartComment = "<!-- " | let EndComment = " -->"
    au Filetype php        let StartComment = "//"

    if $DISPLAY != ""
      command! OpenPage :! $BROWSER "$(file2link %)"<CR><CR>
      command! RefreshPage :! $HOME/.local/share/uzbl/scripts/target-refresh % <CR><CR>

      au BufWritePost /srv/http/pages/* silent RefreshPage
    endif
  endfunction
  " }}}

  " set latex options {{{
  au Filetype tex call SetTexOpts()

  function! SetTexOpts()
    set autochdir
    let StartComment="%"

    if $DISPLAY != ""
      command! OpenTex    :! (file="%"; pdflatex $file && zathura "${file/.tex/.pdf}" &>/dev/null) &
      command! RefreshTex :! (pdflatex % &>/dev/null) &

      au BufWritePost *.tex silent RefreshTex
    endif
  endfunction
  " }}}
endif

" }}}

" FUNCTIONS/COMMANDS {{{ 
function! SetStatusLine()
  let l:s1="%3.3n\\ %f\\ %h%m%r%w"
  let l:s2="[%{strlen(&filetype)?&filetype:'?'},\\ %{&encoding},\\ %{&fileformat}]"
  let l:s3="%=\\ 0x%-8B\\ \\ %-14.(%l,%c%V%)\\ %<%P"
  execute "set statusline=" . l:s1 . l:s2 . l:s3
endfunction

function! RestoreCursorPos()
  if expand("<afile>:p:h") !=? $TEMP 
    if line("'\"") > 1 && line("'\"") <= line("$") 
      let line_num = line("'\"") 
      let b:doopenfold = 1 
      if (foldlevel(line_num) > foldlevel(line_num - 1)) 
        let line_num = line_num - 1 
        let b:doopenfold = 2 
      endif 
      execute line_num 
    endif 
  endif
endfunction

function! OpenFoldOnRestore()
  if exists("b:doopenfold") 
    execute "normal zv"
    if(b:doopenfold > 1)
      execute "+".1
    endif
    unlet b:doopenfold 
  endif
endfunction

function! CommentLines()
  try
    execute ":s@^".g:StartComment."@\@g"
    execute ":s@".g:EndComment."$@@g"
  catch
    execute ":s@^@".g:StartComment."@g"
    execute ":s@$@".g:EndComment."@g"
  endtry
endfunction

function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction

command! DiffSaved call s:DiffWithSaved()

function! MapToggle(key, opt)
  let cmd = ':set '.a:opt.'! \| set '.a:opt."?\<CR>"
  exec 'nnoremap '.a:key.' '.cmd
  exec 'inoremap '.a:key." \<C-O>".cmd
endfunction

command! -nargs=+ MapToggle call MapToggle(<f-args>)

MapToggle <F4> foldenable 
MapToggle <F5> number 
MapToggle <F6> spell 
MapToggle <F7> paste 
MapToggle <F8> hlsearch 
MapToggle <F9> wrap 

" }}}

" To use with Mutt, just put this line your ~/.vimrc :
" "   autocmd BufRead ~/.mutt/temp/mutt*      :source ~/.vim/mail
"
" " * <F1> to re-format the current paragraph correctly
" " * <F2> to format a line which is too long, and go to the next line
" " * <F3> to merge the previous line with the current one, with a correct
" "        formatting (sometimes useful associated with <F2>)
"
" " turn on spell checking
" set spell
"
" " reformat paragraphs
nmap    <F1>    gqap
nmap    <F2>    gqqj
nmap    <F3>    kgqj
map!    <F1>    <ESC>gqapi
map!    <F2>    <ESC>gqqji
map!    <F3>    <ESC>kgqji

autocmd BufRead ~/.mutt/temp/mutt*   :source ~/.vim/mail.vimrc
set list
" Shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<CR>
"  
"  " Use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:›\ ,eol:¬

