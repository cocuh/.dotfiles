# machine-local settings (zshrc.d/local is gitignored)
local f
for f in ~/.zshrc.d/local/*.zsh(N); do
  source $f
done
