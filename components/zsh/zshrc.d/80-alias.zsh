#alias
case $(uname) in
  Darwin*)
    alias ls='ls -FG'
    ;;
  Linux*)
    alias ls='ls -F --color'
    ;;
esac

alias la='ls -a'
alias ll='ls -al'
alias sl='ls'
alias fire='firefox'

alias g='git'
alias gst='git status;'

alias tree='tree -N'
alias du='du -h'
alias df='df -h'

alias cd..='cd ..'
alias dc='cd'

alias pingg='ping -c 3 www.google.co.jp'
alias less='less -R'

alias sozsh='source ~/.zshrc'
alias :q='exit'
alias :Q='exit'
alias vi='vim'

alias wifi='nmtui'
alias pm-suspend='sudo pm-suspend'

alias ta='tmux_ornot'
alias pdb='python /usr/lib/python2.7/pdb.py'
alias ocaml='rlwrap ocaml'

alias sudovim='sudoedit'

alias mitmproxy-p9999='mitmproxy -p 9999'
alias simplehttpserver='python -m http.server'
alias cgihttpserver='python -m http.server --cgi'

alias gcal='gcalcli agenda --color_owner=green --color_date=white'

alias virtualenvwrapper='source /usr/bin/virtualenvwrapper.sh'
hogehoge() {
    local hogehoge_commit_msgs=(':beer:' ':cooktail:' ':lolipop:' ':cookie:' ':shaved_ice:' ':oden:' ':ramen:' ':sake:' ':wine:' ':beers:' ':coffee:' ':tea:' ':dango:' ':pizza:' ':bento:' ':sushi:')
    git commit -m "${hogehoge_commit_msgs[$RANDOM%$#hogehoge_commit_msgs+1]}" && git push
}

if [ -n "$(builtin command -v nvim)" ];then
    alias vim='nvim'
    export EDITOR='nvim'
elif [ -n "$(builtin command -v vim)" ];then
    export EDITOR='vim'
fi

refresh(){
  echo c
}
alias globalip='curl http://ipecho.net/plain'

alias 進捗='echo ダメです🙅'
