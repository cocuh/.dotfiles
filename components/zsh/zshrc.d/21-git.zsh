autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' max-exports 6 # formatに入る変数の最大数
zstyle ':vcs_info:git:*' check-for-changes true

zstyle ':vcs_info:*' actionformats '%F{7}[%F{2}%b%F{7}:%F{3}%r%F{3}|%F{1}%a%F{7}]%f'
zstyle ':vcs_info:*' formats '%F{7}[%F{2}%b%F{7}:%F{3}%r%F{7}]%f'


vcs_info_wrapper() {
    vcs_info
    if [ -n "$vcs_info_msg_0_" ]; then
        echo "${vcs_info_msg_0_}%{$reset_color%}$del"
    fi
}

function git-root(){
    cd $(git rev-parse --show-toplevel)
}
