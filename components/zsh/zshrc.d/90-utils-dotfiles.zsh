function dotfiles-update(){
    pwd=$(pwd)
    cd ~/.dotfiles
    git pull
    cd $pwd
}

