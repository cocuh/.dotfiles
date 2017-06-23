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
bindkey '^Z^Z' up
