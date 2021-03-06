colorscheme molokai-cocuh

" sh
set sh=zsh

" color
syntax on
set cursorline " add underline on cursorline

" emphasis EOF
highlight WhitespaceEOF ctermbg=DarkGray guibg=DarkGray
match WhitespaceEOF /\s\+$/  

" keybinding
nmap <C-w>: :split<CR>
nmap <C-w>" :vsplit<CR>
command! Q q
command! W w
nmap <silent> <Leader><Leader> :<C-u>update<CR>
nmap <silent> <Space>ec :<C-u>edit ~/.dotfiles/components<CR>
nmap <silent> <Space>rc :<C-u>source $MYVIMRC\|echo "re-source ".$MYVIMRC<CR>
nmap <silent>bp :bprevious<CR>
nmap <silent>bn :bnext<CR>
imap <silent> <C-c> <C-[>

if has('nvim') " for terminal
    tnoremap <silent> <ESC> <C-\><C-n>
    tnoremap <silent> <C-[> <C-\><C-n>
    nmap TT :terminal<CR>
endif

" encoding
if has('vim_starting') && &encoding !=# 'utf-8'
   set encoding=utf-8
endif
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
set relativenumber
set number
set numberwidth=5
set backspace=indent,eol,start
setl expandtab tabstop=4 shiftwidth=4 softtabstop=4
set matchpairs& matchpairs+=<:> " add matcha pair highlight

" misc
if !filewritable($HOME."/.cache/nvim/swp")
    call mkdir($HOME."/.cache/nvim/swp", "p")
endif
set directory=~/.cache/nvim/swp
set listchars=eol:~,tab:>-
set foldmethod=marker
filetype plugin indent on
let g:netrw_home=expand('~/.cache/vim')
set mouse=


" clipboard
if (!has('nvim') || $DISPLAY != '') && has('clipboard')
  if has('unnamedplus')
     set clipboard& clipboard+=unnamedplus
  else
     set clipboard& clipboard+=unnamed
  endif
endif

