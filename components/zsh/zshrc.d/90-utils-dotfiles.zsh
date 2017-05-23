function dotfiles-update(){
  pwd=$(pwd)
  cd ~/.dotfiles
  git stash
  git pull --recurse-submodules
  git submodule foreach 'git pull origin master'
  git submodule foreach 'git checkout master'
  git stash pop
  cd $pwd
}


