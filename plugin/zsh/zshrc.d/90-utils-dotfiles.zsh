function dotfiles-update(){
    (){
        cd ~/.dotfiles
        git pull
        cd $*
    } $(pwd)
}

