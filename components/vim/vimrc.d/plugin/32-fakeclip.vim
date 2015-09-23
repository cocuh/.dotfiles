NeoBundle 'kana/vim-fakeclip.git'
set clipboard=unnamed

if executable('tmux') && $TMUX != ''
    for _ in ['+', '*']
        execute 'nmap '._.'y  <Plug>(fakeclip-screen-y)'
        execute 'nmap '._.'Y  <Plug>(fakeclip-screen-Y)'
        execute 'nmap '._.'yy  <Plug>(fakeclip-screen-Y)'
        execute 'vmap '._.'y  <Plug>(fakeclip-screen-y)'
        execute 'vmap '._.'Y  <Plug>(fakeclip-screen-Y)'

        execute 'nmap '._.'p  <Plug>(fakeclip-screen-p)'
        execute 'nmap '._.'P  <Plug>(fakeclip-screen-P)'
        execute 'nmap '._.'gp  <Plug>(fakeclip-screen-gp)'
        execute 'nmap '._.'gP  <Plug>(fakeclip-screen-gP)'
        execute 'nmap '._.']p  <Plug>(fakeclip-screen-]p)'
        execute 'nmap '._.']P  <Plug>(fakeclip-screen-]P)'
        execute 'nmap '._.'[p  <Plug>(fakeclip-screen-[p)'
        execute 'nmap '._.'[P  <Plug>(fakeclip-screen-[P)'
        execute 'vmap '._.'p  <Plug>(fakeclip-screen-p)'
        execute 'vmap '._.'P  <Plug>(fakeclip-screen-P)'
        execute 'vmap '._.'gp  <Plug>(fakeclip-screen-gp)'
        execute 'vmap '._.'gP  <Plug>(fakeclip-screen-gP)'
        execute 'vmap '._.']p  <Plug>(fakeclip-screen-]p)'
        execute 'vmap '._.']P  <Plug>(fakeclip-screen-]P)'
        execute 'vmap '._.'[p  <Plug>(fakeclip-screen-[p)'
        execute 'vmap '._.'[P  <Plug>(fakeclip-screen-[P)'

        execute 'map! '._.'<C-r>&  <Plug>(fakeclip-screen-insert)'
        execute 'map! '._.'<C-r><C-r>&  <Plug>(fakeclip-screen-insert-r)'
        execute 'map! '._.'<C-r><C-o>&  <Plug>(fakeclip-screen-insert-o)'
        execute 'imap '._.'<C-r><C-p>&  <Plug>(fakeclip-screen-insert-p)'

        execute 'nmap '._.'d  <Plug>(fakeclip-screen-d)'
        execute 'vmap '._.'d  <Plug>(fakeclip-screen-d)'
        execute 'nmap '._.'dd  <Plug>(fakeclip-screen-dd)'
        execute 'nmap '._.'D  <Plug>(fakeclip-screen-D)'
        execute 'vmap '._.'D  <Plug>(fakeclip-screen-D)'
    endfor
endif
