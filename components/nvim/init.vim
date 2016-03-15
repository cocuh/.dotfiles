let s:dein_path = expand('~/.cache/dein')
let s:dein_toml_path = '~/.config/nvim/dein.toml'
let s:dein_runtime_path = expand('~/.config/nvim/dein.vim')

let g:dein#enable_name_conversion = 1

augroup MyAutoCmd
    autocmd!
augroup END

if &compatible
  set nocompatible
endif

runtime! rc.basics/*.vim

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

if dein#load_state(s:dein_path)
    call dein#begin(s:dein_path)
    if dein#load_cache([ expand('<sfile>'), s:dein_toml_path ])
        call dein#load_toml(s:dein_toml_path, {'lazy': 0})
    endif
    call dein#end()

    call dein#save_state()
endif

runtime! plugins.vim
