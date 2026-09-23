# ssh passes TERM through, and hosts without its terminfo entry (e.g. xterm-kitty
# on fresh containers) make ZLE redraw garbage; fall back to a universal entry.
# Assigning TERM makes zsh reload terminfo, so this takes effect immediately.
if (( $+commands[infocmp] )) && ! infocmp "$TERM" &>/dev/null; then
    export TERM=xterm-256color
fi
