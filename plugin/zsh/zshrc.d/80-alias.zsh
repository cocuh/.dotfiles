#alias
case $OSTYPE in
  Darwin*)
    alias ls='ls -FG'
    ;;
  linux*)
    alias ls='ls -F --color'
    ;;
esac

alias la='ls -a'
alias ll='ls -al'
alias sl='ls'

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

alias wifi='wicd-curses'

alias ta='tmux_ornot'
alias pdb='python /usr/lib/python2.7/pdb.py'
alias ocaml='rlwrap ocaml'

alias sudovim='sudoedit'

alias mitmproxy-p9999='mitmproxy -p 9999'
alias simplehttpserver='python -m http.server'
alias cgihttpserver='python -m http.server --cgi'

alias virtualenvwrapper='source /usr/bin/virtualenvwrapper.sh'

refresh(){
  echo c
}
