let s:dein_plugin_path = 'rc.plugins'


function! s:_hook_path(plugin)
    return expand('~/.config/nvim/').s:dein_plugin_path.'/'.a:plugin.'-after.vim'
endfunction

function! s:_conf_path(plugin)
    return s:dein_plugin_path.'/'.a:plugin.'.vim'
endfunction

function! s:apply_config(plugin)
    let l:name = a:plugin['name']
    execute "runtime! ".s:_conf_path(l:name)
    let l:path = s:_hook_path(l:name)
    if filereadable(l:path)
        execute 'autocmd plugin_hook User' 'dein#source#'.l:name
                        \ 'source '.l:path
    endif
endfunction

call map(deepcopy(dein#get()), 's:apply_config(v:val)')

