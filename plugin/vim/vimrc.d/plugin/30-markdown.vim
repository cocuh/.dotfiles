NeoBundle 'plasticboy/vim-markdown'

au BufRead,BufNewFile *.md set filetype=markdown

let g:quickrun_config['markdown'] = {'outputter': 'browser'}
