function dotfiles-update(){
  pwd=$(pwd)
  cd ~/.dotfiles
  git pull --recurse-submodules
  cd $pwd
}

