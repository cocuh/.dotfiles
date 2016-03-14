if &compatible
  set nocompatible
endif

let s:dein_toml_path = '~/.config/nvim/dein.toml'
let s:dein_toml_lazy_path = '~/.config/nvim/dein_lazy.toml'

if empty(glob("~/.config/nvim/dein.vim/README.md"))
    echo 'dein.vim not installed!!(run :DotfilesSubmoduleUpdate)'
    function! DotfilesSubmoduleUpdate()
        cd ~/.dotfiles
        !git submodule init
        !git submodule update
        q
    endfunction
    command DotfilesSubmoduleUpdate :call DotfilesSubmoduleUpdate()
else
    let &runtimepath.=',~/.config/nvim/dein.vim'

    call dein#begin(expand('~/.cache/dein'))
    if dein#load_cache([expand('<sfile>'), '~/.config/nvim/dein.toml', '~/.config/nvim/dein-lazy.toml'])
        call dein#load_toml(s:dein_toml_path, {'lazy': 0})
        call dein#load_toml(s:dein_toml_lazy_path, {'lazy': 1})
        call dein#save_cache()
    endif
    call dein#end()

    if dein#check_install()
        call dein#install()
    endif
endif
