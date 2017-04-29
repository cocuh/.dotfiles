function dotfiles-update(){
  pwd=$(pwd)
  cd ~/.dotfiles
  git stash
  git pull --recurse-submodules
  git submodule foreach 'git pull origin master'
  git submodule foreach 'git checkout master'
  if $(ssh github.com 2>&1|grep 'cocuh'); then
    echo 'auto commit'
    git add .
    git commit -m ':up:submodules'
    git push
  else
    echo 'skip commit'
  fi
  git stash pop
  cd $pwd
}


