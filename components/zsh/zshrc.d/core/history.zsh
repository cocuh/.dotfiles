local histdir=${XDG_STATE_HOME:-$HOME/.local/state}/zsh
[[ -d $histdir ]] || mkdir -p $histdir
HISTFILE=$histdir/history
HISTSIZE=100000
SAVEHIST=100000

setopt extended_history
setopt hist_ignore_dups
setopt hist_reduce_blanks
setopt inc_append_history
