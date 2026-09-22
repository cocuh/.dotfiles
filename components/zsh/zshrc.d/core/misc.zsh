# disable ctrl-s suspend
stty stop undef

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
