function git-root(){
    cd $(git rev-parse --show-toplevel)
}
alias gitroot=git-root
alias root=git-root
