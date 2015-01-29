"####################
"number
"####################
set number
set numberwidth=5
set backspace=indent,eol,start
setl expandtab tabstop=4 shiftwidth=4 softtabstop=4
set fileencodings=iso-2022-jp,cp932,sjis,euc-jp,utf-8


" swp files
set directory=~/.vim/swp

" listchar
set listchars=eol:~,tab:>.


"####################
"search
"####################
set hlsearch
set incsearch
set wrapscan
set gdefault


"####################
"command line completion
"####################
set wildmenu
set wildmode=longest:full,full


"####################
"misc
"####################
set matchpairs& matchpairs+=<:> " add match pair highlight
set cmdheight=2 " command pane height

set ignorecase " ignore larger or smaller case
set smartcase  " search smarter case pattern
