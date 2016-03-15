function dotfiles-update(){
  pwd=$(pwd)
  cd ~/.dotfiles
  git pull
  git submodule init
  git submodule update
  cd $pwd
}

