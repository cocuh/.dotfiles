if has('nvim')
    let s:dein_cache_path = expand('~/.cache/nvim/dein')
else
    let s:dein_cache_path = expand('~/.cache/vim/dein')
endif
let s:dein_toml_path = '~/.config/nvim/dein.toml'
let s:dein_runtime_path = expand('~/.config/nvim/dein.vim')

augroup plugin_hook
    autocmd!
augroup END

if &compatible
  set nocompatible
endif

if has('vim_starting')
    let &runtimepath.=',~/.config/nvim/dein.vim'
    let &runtimepath.=',~/.config/nvim'
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
    runtime! rc.basics.vim
    finish
endif

if dein#load_state(s:dein_cache_path)
    call dein#begin(s:dein_cache_path)
    if dein#load_cache([ expand('<sfile>'), s:dein_toml_path ])
        call dein#load_toml(s:dein_toml_path)
    endif
    call dein#end()

    call dein#save_state()
endif

runtime! rc.basics.vim
runtime! rc.plugins.vim


