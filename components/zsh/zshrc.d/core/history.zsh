local histdir=${XDG_STATE_HOME:-$HOME/.local/state}/zsh
[[ -d $histdir ]] || mkdir -p $histdir
HISTFILE=$histdir/history
# migrate from the old location
if [[ -f ~/.zsh_history && ! -e $HISTFILE ]]; then
  mv ~/.zsh_history $HISTFILE
fi
HISTSIZE=100000
SAVEHIST=100000

setopt extended_history
setopt hist_ignore_dups
setopt hist_reduce_blanks
setopt inc_append_history
