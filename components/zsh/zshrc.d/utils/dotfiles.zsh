function dotfiles-update(){
  git -C ~/.dotfiles stash
  git -C ~/.dotfiles pull --recurse-submodules
  git -C ~/.dotfiles stash pop
}

function dotfiles-update-submodules(){
  git -C ~/.dotfiles submodule foreach 'git pull origin master'
  git -C ~/.dotfiles submodule foreach 'git checkout master'
}
