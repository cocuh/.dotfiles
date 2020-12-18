if &compatible
  set nocompatible
endif


" Special handing for no dein.vim
if empty(glob('~/.vim/dein.vim/README.md'))
  echo 'dein.vim not installed!!(run :DotfilesSubmoduleUpdate)'
  function! DotfilesSubmoduleUpdate()
    cd ~/.dotfiles
    !git submodule init
    !git submodule update
    q
  endfunction
  command DotfilesSubmoduleUpdate :call DotfilesSubmoduleUpdate()
  runtime! core.vim
  finish
endif

" dein
set runtimepath+=~/.vim/dein.vim

call dein#begin('~/.cache/nvim/dein', '~/.vim/plugins/*.vim')

call dein#load_toml("~/.config/nvim/plugins.toml")
for plugin_name in keys(dein#get())
	call dein#set_hook(plugin_name, 'hook_add', 'runtime! plugins/' . plugin_name . '.vim')
	call dein#set_hook(plugin_name, 'hook_post_source', 'runtime! plugins/' . plugin_name . '-post.vim')
endfor

call dein#end()

filetype plugin indent on
syntax enable


runtime! core.vim
