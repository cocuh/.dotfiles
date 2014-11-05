if [ -x ~/.rbenv/bin/rbenv -a -e ~/.rbenv/completions/rbenv.zsh ] ;then
    export RBENV_SHELL=zsh
    source "${HOME}/.rbenv/completions/rbenv.zsh"
    rbenv rehash 2>/dev/null
    rbenv() {
      local command
      command="$1"
      if [ "$#" -gt 0 ]; then
        shift
      fi
    
      case "$command" in
      rehash|shell)
        eval "`rbenv "sh-$command" "$@"`";;
      *)
        command rbenv "$command" "$@";;
      esac
    }
fi
