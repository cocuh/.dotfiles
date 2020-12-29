if ((${+TMUX})) && (type fzf-tmux &> /dev/null); then
  FZF="fzf-tmux"
  FZF_OPTION="-u 70%"
else
  FZF="fzf"
  FZF_OPTION=""
fi

function fzf--insert-commandline() {
  local filepath="$1"
  [ -z "$filepath" ] && return
  if [ -n "$LBUFFER" ]; then
    BUFFER="${LBUFFER}$filepath:q"
  else
    if [ -d "$filepath" ]; then
      BUFFER="cd $filepath:q"
    elif [ -f "$filepath" ]; then
      BUFFER="$EDITOR $filepath:q"
    fi
  fi
  CURSOR=$#BUFFER
}

function fzf-find() {
  local filepath="$(find . | grep -v '/\.' | $FZF $FZF_OPTION --prompt 'PATH>')"
  fzf--insert-commandline $filepath
}

function fzf-find_dep2() {
  local filepath="$(find . -maxdepth 2 | grep -v '/\.' | $FZF $FZF_OPTION --prompt 'PATH>')"
  fzf--insert-commandline $filepath
}

function fzf-ls() {
  function custom-ls() {
    case $(uname) in
    Darwin*)
      /bin/ls
      /bin/ls -A | grep "^\."
      ;;
    Linux*)
      /bin/ls --color='never'
      /bin/ls --color='never' -A | grep "^\."
      ;;
    *)
      /bin/ls
      ;;
    esac
  }
  local filepath="./$(custom-ls | $FZF $FZF_OPTION --prompt 'PATH>')"
  fzf--insert-commandline $filepath
  return
}

zle -N fzf-find
bindkey -r '^S'
bindkey '^S' fzf-find

zle -N fzf-find_dep2
bindkey -r '^D'
bindkey '^D' fzf-find_dep2

zle -N fzf-ls
bindkey -r '^F'
bindkey '^F' fzf-ls

function agvim() {
  local data="$(ag $@ | fzf)"
  local filepath="$(echo $data | awk -F : '{print $1}')"
  local lineno="$(echo $data | awk -F : '{print $2}')"
  [ -z "$filepath" ] && return
  if [ -f "$filepath" ]; then
    vim -c $lineno "$filepath"
  fi
}

function fdr() {
  local declare dirs=()
  get_parent_dirs() {
    if [[ -d "${1}" ]]; then dirs+=("$1"); else return; fi
    if [[ "${1}" == '/' ]]; then
      for _dir in "${dirs[@]}"; do echo $_dir; done
    else
      get_parent_dirs $(dirname "$1")
    fi
  }
  local DIR=$(get_parent_dirs $(realpath "${1:-$PWD}") | $FZF --tac)
  cd "$DIR"
}

function fh() {
  LBUFFER=$(history 0 | fzf +s --tac -e | sed -e 's/\s*[0-9]\+\s\+\(\*\s\+\)\?//')
  zle redisplay
}
if type $FZF &> /dev/null; then
  zle -N fh
  bindkey -r '^R'
  bindkey '^R' fh
fi
