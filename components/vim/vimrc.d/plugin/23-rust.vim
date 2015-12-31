NeoBundle 'rust-lang/rust.vim'
NeoBundleLazy 'phildawes/racer', {
        \   'build' : {
        \     'mac'  : 'cargo build --release',
        \     'unix' : 'cargo build --release',
        \   },
        \   'autoload' : {
        \     'filetypes' : 'rust',
        \   },
        \ }

let $RUST_SRC_PATH = expand('/usr/src/rust/src')

let g:quickrun_config = get(g:, 'quickrun_config', {})
let g:quickrun_config['syntax/rust'] = {
            \   'command' : 'rustc',
            \   'cmdopt' : '-Zparse-only',
            \   'exec' : '%c %o %s:p',
            \   'outputter' : 'quickfix',
            \ }

au BufNewFile,BufRead *.rs set filetype=rust
