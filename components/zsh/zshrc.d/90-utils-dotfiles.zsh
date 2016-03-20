function dotfiles-update(){
  pwd=$(pwd)
  cd ~/.dotfiles
  git pull --recurse-submodules
  git submodule --update --recursive
  cd $pwd
}

