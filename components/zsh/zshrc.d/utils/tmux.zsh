tmux-reset-display-env(){
    tmux set-environment DISPLAY $DISPLAY
}

bindkey 5C forward-word
bindkey 5D backward-word

