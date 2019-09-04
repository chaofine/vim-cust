" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2017 Sep 20
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Get the defaults that most users want.
source $VIMRUNTIME/defaults.vim

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file (restore to previous version)
  if has('persistent_undo')
    set undofile	" keep an undo file (undo changes after closing)
  endif
endif

if &t_Co > 2 || has("gui_running")
  " Switch on highlighting the last used search pattern.
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
  packadd! matchit
endif

"""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""customize"""""""""""""""
set nocompatible
colorscheme LightTan
set hlsearch
"set nu
set autoindent
set sw=4
set ts=4
set nu
"highlight PMenu ctermfg=12 ctermbg=225 "guifg=black guibg=grey
"highlight PMenuSel ctermfg=225 ctermbg=12 "guifg=grey guibg=black
highlight PMenu ctermfg=0 ctermbg=6 guifg=#444444
highlight PMenuSel ctermfg=7 ctermbg=4 guifg=#ffffff guibg=#555555
inoremap jj <ESC>

"""""""""""""""plug-in"""""""""""""""""""
call plug#begin('~/.vim/plugged')
Plug 'itchyny/lightline.vim'
Plug 'Valloric/YouCompleteMe'
" 延迟按需加载，使用到命令的时候再加载或者打开对应文件类型才加载 
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' } 
" 确定插件仓库中的分支或者tag
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' } 
Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }
Plug 'scrooloose/syntastic'
"函数参数补全
Plug 'tenfyzhong/CompleteParameter.vim'
Plug 'flazz/vim-colorschemes'
call plug#end()


let g:ycm_server_python_interpreter='/usr/bin/python'
let g:ycm_global_ycm_extra_conf='~/.vim/.ycm_extra_conf.py'

"函数原型预览1:on/0:off
let g:ycm_add_preview_to_completeopt = 0
"诊断信息
let g:ycm_show_diagnostics_ui = 0 
let g:ycm_server_log_level = 'info'
"弹出补全信息前需要输入的字符数
let g:ycm_min_num_identifier_candidate_chars = 2 
"是否收集并补全字符串和注释信息
let g:ycm_collect_identifiers_from_comments_and_strings = 1 
"是否在""字符串内跳出补全窗口，默认1
let g:ycm_complete_in_strings=1 
"补全快捷键，默认<C-Space>
let g:ycm_key_invoke_completion = '<C-z>'
"
set completeopt=menu,menuone 
noremap <c-z> <NOP> 

let g:ycm_semantic_triggers = { 
	\ 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'], 
	\ 'cs,lua,javascript': ['re!\w{2}'], 
	\ }


let g:ycm_filetype_whitelist = { 
			\ "c":1,
			\ "cpp":1, 
			\ "objc":1,
			\ "sh":1,
			\ "zsh":1,
			\ "zimbu":1,
			\ }


" for ycm
let g:ycm_error_symbol = '>>'
let g:ycm_warning_symbol = '>*'
nnoremap <leader>gl :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>gf :YcmCompleter GoToDefinition<CR>
nnoremap <leader>gg :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <leader>gt :YcmCompleter GoToInclude<CR>
nmap <F4> :YcmDiags<CR>


"for 'scrooloose/syntastic'
let g:syntastic_error_symbol='>>'
let g:syntastic_warning_symbol='>*'
let g:syntastic_check_on_open=1
let g:syntastic_check_on_wq=0
let g:syntastic_enable_highlighting=1

"for 'tenfyzhong/CompleteParameter.vim'
inoremap <silent><expr> ( complete_parameter#pre_complete("()")
smap <c-j> <Plug>(complete_parameter#goto_next_parameter)
imap <c-j> <Plug>(complete_parameter#goto_next_parameter)
smap <c-k> <Plug>(complete_parameter#goto_previous_parameter)
imap <c-k> <Plug>(complete_parameter#goto_previous_parameter)

"to match quote pairs
"inoremap ( <c-r>=OpenPair('(')<CR>
"inoremap ) <c-r>=ClosePair(')')<CR>
inoremap { <c-r>=OpenPair('{')<CR>
inoremap } <c-r>=ClosePair('}')<CR>
inoremap [ <c-r>=OpenPair('[')<CR>
inoremap ] <c-r>=ClosePair(']')<CR>
inoremap <Enter> <c-r>=TestEnterPair()<CR>
function! TestEnterPair()
       let linestr = getline('.')
        let colno = col('.')
            if linestr[colno - 1] == '}' && linestr[colno - 2] == '{'
                     return "\<Enter>\<Enter>\<Up>\t"
             else
                     return "\n"
             endif
endfunction
function! OpenPair(char)
        let PAIRs = {
                        \ '{' : '}',
                        \ '[' : ']',
						\ '(' : ')',
                        \ '<' : '>'
                        \}
         if line('$')>2000
             let line = getline('.')
                        
             let txt = strpart(line, col('.')-1)
          else
             let lines = getline(1,line('$'))
             let line=""
             for str in lines
                 let line = line . str . "\n"
             endfor
                                                                                
             let blines = getline(line('.')-1, line("$"))
             let txt = strpart(getline("."), col('.')-1)
             for str in blines
                 let txt = txt . str . "\n"
             endfor
         endif
         let oL = len(split(line, a:char, 1))-1
         let cL = len(split(line, PAIRs[a:char], 1))-1
                                                                                
         let ol = len(split(txt, a:char, 1))-1
         let cl = len(split(txt, PAIRs[a:char], 1))-1
                                                                                
         if oL>=cL || (oL<cL && ol>=cl)
             return a:char . PAIRs[a:char] . "\<Left>"
         else
             return a:char
         endif
endfunction  

function! ClosePair(char)
        if getline('.')[col('.')-1] == a:char
           return "\<Right>"
        else
           return a:char
        endif
endf
                                    
inoremap ' <c-r>=CompleteQuote("'")<CR>
inoremap " <c-r>=CompleteQuote('"')<CR>
function! CompleteQuote(quote)
    let ql = len(split(getline('.'), a:quote, 1))-1
    let slen = len(split(strpart(getline("."), 0, col(".")-1), a:quote, 1))-1
    let elen = len(split(strpart(getline("."), col(".")-1), a:quote, 1))-1
    let isBefreQuote = getline('.')[col('.') - 1] == a:quote
    if isBefreQuote
         return "\<Right>"
    elseif '"'==a:quote && "vim"==&ft && 0==match(strpart(getline('.'), 0, col('.')-1), "^[\t ]*$")
         return a:quote
    elseif "'"==a:quote && 0==match(getline('.')[col('.')-2], "[a-zA-Z0-9]")
         return a:quote
    elseif (ql%2)==1
         return a:quote
     elseif((slen%2)==1 && (elen%2)==1 && !isBefreQuote) || ((slen%2)==0 && (elen%2)==0)
     	     return a:quote . a:quote . "\<Left>"
    else
        return a:quote . a:quote . "\<Left>"
    endif
endfunction 

