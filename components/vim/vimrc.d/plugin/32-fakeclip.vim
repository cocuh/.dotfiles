NeoBundle 'kana/vim-fakeclip.git'
set clipboard=unnamed

if executable('tmux') && $TMUX != ''
    nmap y  <Plug>(fakeclip-screen-y)
    nmap Y  <Plug>(fakeclip-screen-Y)
    nmap yy  <Plug>(fakeclip-screen-Y)
    vmap y  <Plug>(fakeclip-screen-y)
    vmap Y  <Plug>(fakeclip-screen-Y)

    nmap p  <Plug>(fakeclip-screen-p)
    nmap P  <Plug>(fakeclip-screen-P)
    nmap gp  <Plug>(fakeclip-screen-gp)
    nmap gP  <Plug>(fakeclip-screen-gP)
    nmap ]p  <Plug>(fakeclip-screen-]p)
    nmap ]P  <Plug>(fakeclip-screen-]P)
    nmap [p  <Plug>(fakeclip-screen-[p)
    nmap [P  <Plug>(fakeclip-screen-[P)
    vmap p  <Plug>(fakeclip-screen-p)
    vmap P  <Plug>(fakeclip-screen-P)
    vmap gp  <Plug>(fakeclip-screen-gp)
    vmap gP  <Plug>(fakeclip-screen-gP)
    vmap ]p  <Plug>(fakeclip-screen-]p)
    vmap ]P  <Plug>(fakeclip-screen-]P)
    vmap [p  <Plug>(fakeclip-screen-[p)
    vmap [P  <Plug>(fakeclip-screen-[P)

    map! <C-r>&  <Plug>(fakeclip-screen-insert)
    map! <C-r><C-r>&  <Plug>(fakeclip-screen-insert-r)
    map! <C-r><C-o>&  <Plug>(fakeclip-screen-insert-o)
    imap <C-r><C-p>&  <Plug>(fakeclip-screen-insert-p)

    nmap d  <Plug>(fakeclip-screen-d)
    vmap d  <Plug>(fakeclip-screen-d)
    nmap dd  <Plug>(fakeclip-screen-dd)
    nmap D  <Plug>(fakeclip-screen-D)
    vmap D  <Plug>(fakeclip-screen-D)
endif
