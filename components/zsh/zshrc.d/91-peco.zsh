
export EDITOR=vim

function _insert_commandline() {
  local filepath="$1"
  [ -z "$filepath" ] && return
  if [ -n "$LBUFFER" ]; then
    BUFFER="${LBUFFER}${filepath}"
  else
    if [ -d "$filepath" ]; then
      BUFFER="cd $filepath"
    elif [ -f "$filepath" ]; then
      BUFFER="$EDITOR $filepath"
    fi
  fi
  CURSOR=$#BUFFER
}

function peco-find() {
  local filepath="$(find . | grep -v '/\.' | peco --prompt 'PATH>')"
  _insert_commandline $filepath
}

function peco-ls() {
  function custom-ls() {
    if [ "$(uname)" == 'Darwin' ];then
      ls
      ls -A | grep "^\."
    else
      ls --color='never'
      ls --color='never' -A | grep "^\."
    fi
  }
  local filepath="./$(custom-ls | peco --prompt 'PATH>')"
  _insert_commandline $filepath
  return
}

zle -N peco-find
bindkey -r '^F'
bindkey '^F' peco-find

zle -N peco-ls
bindkey -r '^L'
bindkey '^L' peco-ls

# http://hotolab.net/blog/peco_select_path/

function agvim() {
  local data="$(ag $@ | peco)"
  local filepath="$(echo $data | awk -F : '{print $1}')"
  local lineno="$(echo $data | awk -F : '{print $2}')"
  vim -c $lineno "$filepath"
}

