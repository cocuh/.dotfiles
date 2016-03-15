colorscheme molokai-cocuh

" color
syntax on
set cursorline " add underline on cursorline

" emphasis EOF
highlight WhitespaceEOF ctermbg=DarkGray guibg=DarkGray
match WhitespaceEOF /\s\+$/  

" keybinding
nmap <C-w>: :split<CR>
nmap <C-w>" :vsplit<CR>
command Q q
command W w

" encoding
set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp,cp932,sjis,euc-jp

" completion
set wildmenu
set wildmode=longest:full,full

" search
set hlsearch
set incsearch
set wrapscan
set gdefault " s/~~/~~/g <- default g

set ignorecase
set smartcase

" line number
set number
set numberwidth=5
set backspace=indent,eol,start
setl expandtab tabstop=4 shiftwidth=4 softtabstop=4
set matchpairs& matchpairs+=<:> " add matcha pair highlight

" misc
set directory=~/.cache/nvim/swp
set listchars=eol:~,tab:>-
set foldmethod=marker
filetype plugin indent on
let g:netrw_home=expand('~/.cache/vim')


