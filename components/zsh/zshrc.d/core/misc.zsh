# disable ctrl-s suspend
[[ -t 0 ]] && stty stop undef

function up(){
    echo
    print -r -- $PWD
	cd ..
    zle reset-prompt
}
zle -N up

# ctrl-right / ctrl-left (xterm, rxvt, old xterm-style)
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[Oc' forward-word
bindkey '^[Od' backward-word
bindkey '^[[5C' forward-word
bindkey '^[[5D' backward-word
bindkey '^Z^Z' up
