# set emacs keybinding
bindkey -e

# disable ctrl-s suspend
stty stop undef

export LESS='--tabs=4 --no-init --LONG-PROMPT --ignore-case'
export EDITOR='vim'

function up(){
    echo
	cd ..
    zle reset-prompt
}
zle -N up
bindkey '^Z^Z' up
