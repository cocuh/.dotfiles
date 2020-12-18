colorscheme molokai-cocuh

syntax enable
set cursorline

" keybinding
nmap <C-w>: :split<CR>
nmap <C-w>" :vsplit<CR>
command! Q q
command! W w

nmap <silent> <Leader><Leader> :<C-u>update<CR>
imap <silent> <C-c> <C-[>

" encoding
if has('vim_starting')
  set encoding=utf-8
endif


" split to below
" Note: this is to show preview (information) below
set splitbelow

" file path completion
set wildmenu
set wildmode=longest:full,full

" search
set hlsearch " highlight search terms
set incsearch
set ignorecase
set smartcase

" line number
set relativenumber
set number
set numberwidth=5

" backspace for deleting special characters
set backspace=indent,eol,start

" misc
setl expandtab tabstop=4 shiftwidth=4 softtabstop=4
set matchpairs& matchpairs+=<:> " enable to highlight < and >

" swp directory
if !filewritable($HOME . '/.cache/nvim/swp')
	call mkdir($HOME . '/.cache/nvim/swp', 'p')
endif
set directory=~/.cache/nvim/swp

set listchars=eol:~,tab:>-
set foldmethod=marker

" clipboard
set clipboard& clipboard^=unnamedplus " use x11 clipboard

" do not create .netrwhist file
let g:netrw_dirhistmax=0
