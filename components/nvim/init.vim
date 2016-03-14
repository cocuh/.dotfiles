runtime! vimrc.basic/*.vim

let s:dein_path = expand('~/.cache/dein')
let s:dein_toml_path = '~/.config/nvim/dein.toml'
let s:dein_runtime_path = expand('~/.config/nvim/dein.vim')
let s:dein_toml_lazy_path = '~/.config/nvim/dein_lazy.toml'

if &compatible
  set nocompatible
endif


if empty(glob(s:dein_runtime_path.'/README.md'))
    echo 'dein.vim not installed!!(run :DotfilesSubmoduleUpdate)'
    function! DotfilesSubmoduleUpdate()
        cd ~/.dotfiles
        !git submodule init
        !git submodule update
        q
    endfunction
    command DotfilesSubmoduleUpdate :call DotfilesSubmoduleUpdate()
    finish
endif

let &runtimepath.=',~/.config/nvim/dein.vim'

if !dein#load_state(s:dein_path)
    finish
endif

call dein#begin(s:dein_path)
if dein#load_cache([expand('<sfile>'), s:dein_toml_path, s:dein_toml_lazy_path ])
    call dein#load_toml(s:dein_toml_path, {'lazy': 0})
    " currently not used
    "call dein#load_toml(s:dein_toml_lazy_path, {'lazy': 1})
endif
call dein#end()

dein#save_state()

runtime! vimrc.plugin/*.vim
