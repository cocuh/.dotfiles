function dotfiles-update(){
  pwd=$(pwd)
  cd ~/.dotfiles
  git stash
  git pull --recurse-submodules
  git stash pop
  cd $pwd
}

function dotfiles-update-submodules(){
  pwd=$(pwd)
  cd ~/.dotfiles
  git submodule foreach 'git pull origin master'
  git submodule foreach 'git checkout master'
  cd $pwd
}


