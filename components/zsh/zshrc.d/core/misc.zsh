# disable ctrl-s suspend
stty stop undef

export LESS='--tabs=4 --no-init --LONG-PROMPT --ignore-case'

function up(){
    echo
    echo $(pwd)
	cd ..
    zle reset-prompt
}
zle -N up

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey '^Z^Z' up
