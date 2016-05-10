function dotfiles-update(){
  pwd=$(pwd)
  cd ~/.dotfiles
  git pull --recurse-submodules
  git submodule foreach 'git pull origin master'
  git submodule foreach 'git checkout master'
  cd $pwd
}

