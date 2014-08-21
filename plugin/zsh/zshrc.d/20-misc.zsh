# set emacs keybinding
bindkey -e

# disable ctrl-s suspend
stty stop undef

if [ -e ~/.python/startup.py ];then
    export PYTHONSTARTUP=~/.python/startup.py
fi
if [ -e /usr/bin/virtualenvwrapper.sh ];then
    source /usr/bin/virtualenvwrapper.sh
fi

export LESS='--tabs=4 --no-init --LONG-PROMPT --ignore-case'

function up(){
    echo
	cd ..
    zle reset-prompt
}
zle -N up
bindkey '^U' up
