if [ -d "/home/cocu/.rbenv/shims" ];then
    export PATH="${PATH}:/home/cocu/.rbenv/shims"
fi
if [ -d "/home/cocu/.gem/ruby/2.1.0/bin/" ];then
    export PATH="${PATH}:/home/cocu/.gem/ruby/2.1.0/bin/"
fi
export RBENV_SHELL=zsh
if [ -f '/home/cocu/.rbenv/libexec/../completions/rbenv.zsh' ];then
    source '/home/cocu/.rbenv/libexec/../completions/rbenv.zsh'
fi
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
