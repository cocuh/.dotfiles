function dotfiles-update(){
  pwd=$(pwd)
  cd ~/.dotfiles
  git pull --recurse-submodules
  git submodule foreach 'git pull origin master'
  git submodule foreach 'git checkout master'
  cd $pwd
}

function dotfiles-submodule-update(){
  pwd=$(pwd)
  cd ~/.dotfiles
  git submodule foreach 'git pull origin master'
  git submodule foreach 'git checkout master'
  git commit -m 'update submodules'
  cd $pwd
}

