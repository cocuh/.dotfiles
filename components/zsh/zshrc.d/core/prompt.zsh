#zsh PROMPT

local host_colors=(red green cyan blue yellow magenta white)

# host color index = sha1("$HOST\n") % 7 + 1, cached because sha1 needs an external command
local host_int host_int_cache=${XDG_CACHE_HOME:-$HOME/.cache}/zsh/host-color-$HOST
if [[ -r $host_int_cache ]]; then
  host_int=$(<$host_int_cache)
else
  local digest=${$(print -r -- $HOST | sha1sum)[1]} d r=0
  for d in ${(s::)digest}; do
    (( r = (r * 16 + 16#$d) % $#host_colors ))
  done
  host_int=$(( r + 1 ))
  mkdir -p ${host_int_cache:h} && print -r -- $host_int > $host_int_cache
fi

local the_prompt;
case $HOST in
stern)
  the_prompt="%B%F{green}ヾ(  _ﾟ々｡ア"
  ;;
saya)
  the_prompt="%F{green}_(:3｣_)_"
  ;;
shiina)
  the_prompt="%B%F{blue}_(:3｣_)_"
  ;;
*)
  the_prompt="%B%F{cyan}%n@%F{${host_colors[host_int]}}%m%f%b"
  ;;
esac



PROMPT="
%B%F{blue}[ %~ ]%f%b
${the_prompt}%B%(?.%F{green}.%F{red})%#%f%b "
#PROMPT2=
#SPROMPT=
#RPROMPT="[${vcs_echo}]"
#RPROMPT=$'$(vcs_info_wrapper)'
