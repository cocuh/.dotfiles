function dotfiles-update(){
  pwd=$(pwd)
  cd ~/.dotfiles
  git stash
  git pull --recurse-submodules
  git submodule foreach 'git pull origin master'
  git submodule foreach 'git checkout master'
  git add .
  git commit -m ':up:submodules'
  git push
  git stash pop
  cd $pwd
}


