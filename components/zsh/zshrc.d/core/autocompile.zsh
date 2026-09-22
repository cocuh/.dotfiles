# auto compile
function regenzshrc() {
  echo regenzshrc
  python3 ~/.dotfiles/regenzshrc.py
  zcompile ~/.zshrc
}
if [ ! -f ~/.zshrc -o ${#$(find ~/.zshrc.d/ -type f -newer ~/.zshrc)} -ne 0 ]; then
  regenzshrc
fi
