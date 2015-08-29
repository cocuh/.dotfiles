export EDITOR=vim # 好きなエディタ


function peco-find() {
  local filepath="$(find . | grep -v '/\.' | peco --prompt 'PATH>')"
  [ -z "$filepath" ] && return
  echo $filepath
  if [ -n "$LBUFFER" ]; then
    BUFFER="$LBUFFER$filepath"
  else
    if [ -d "$filepath" ]; then
      BUFFER="cd $filepath"
    elif [ -f "$filepath" ]; then
      BUFFER="$EDITOR $filepath"
    fi
  fi
  CURSOR=$#BUFFER
}

function peco-ls() {
  function custom-ls() {
    ls --color='never'
    ls --color='never' -A | grep "^\."
  }
  local filepath="./$(custom-ls | peco --prompt 'PATH>')"
  [ -z "$filepath" ] && return
  if [ -n "$LBUFFER" ]; then
    BUFFER="$LBUFFER$filepath"
  else
    if [ -d "$filepath" ]; then
      BUFFER="cd $filepath"
    elif [ -f "$filepath" ]; then
      BUFFER="$EDITOR $filepath"
    fi
  fi
  CURSOR=$#BUFFER
}

zle -N peco-find
bindkey -r '^F'
bindkey '^F' peco-find

zle -N peco-ls
bindkey -r '^L'
bindkey '^L' peco-ls

# http://hotolab.net/blog/peco_select_path/
