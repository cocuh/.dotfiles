let $CACHE = expand('~/.cache')
if !($CACHE->isdirectory())
  call mkdir($CACHE, 'p')
endif

if &runtimepath !~# '/dein.vim'
  let s:dein_dir = fnamemodify('dein.vim', ':p')
  if !isdirectory(s:dein_dir)
    let s:dein_dir = $CACHE .. '/dein/repos/github.com/Shougo/dein.vim'
    if !isdirectory(s:dein_dir)
      execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
    endif
  endif
  execute 'set runtimepath^=' .. substitute(
        \ fnamemodify(s:dein_dir, ':p') , '[/\\]$', '', '')
endif

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
