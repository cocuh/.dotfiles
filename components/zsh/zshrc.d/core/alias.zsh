#alias
alias ls='ls -F --color=auto'

alias la='ls -a'
alias ll='ls -al'
alias sl='ls'

alias g='git'
alias gst='git status'

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

alias ta='tmux_ornot'
alias ocaml='rlwrap ocaml'

alias sudovim='sudoedit'

alias simplehttpserver='python -m http.server'

alias unzip-cp932='unzip -O cp932'

hogehoge() {
    local hogehoge_commit_msgs=(':beer:' ':cocktail:' ':lollipop:' ':cookie:' ':shaved_ice:' ':oden:' ':ramen:' ':sake:' ':wine_glass:' ':beers:' ':coffee:' ':tea:' ':dango:' ':pizza:' ':bento:' ':sushi:')
    git commit -m "${hogehoge_commit_msgs[$RANDOM%$#hogehoge_commit_msgs+1]}" && git push
}

if (( $+commands[nvim] )); then
    alias vim='nvim'
fi

alias globalip='curl -fsS https://ifconfig.me; echo'

alias 進捗='echo ダメです🙅'
