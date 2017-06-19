#zsh PROMPT

local sha
if [ `which sha1sum` ];then
  sha=sha1sum
else
  sha=shasum
fi

local host_formats
host_formats=('%{${fg[red]}%}' '%{${fg[green]}%}' '%{${fg[cyan]}%}' '%{${fg[blue]}%}' '%{${fg[yellow]}%}' '%{${fg[magenta]}%}' '%{${fg[white]}%}')
local host_int=$(echo "ibase=16;hostname=$(echo $(hostname) | $sha | awk '{print toupper($1)}');ibase=A;hostname%$#host_formats + 1" | bc)

local the_prompt;
case $(hostname) in
stern)
  the_prompt="%{${fg_bold[green]}%}ヾ(  _ﾟ々｡ア"
  ;;
saya)
  the_prompt="_(:3｣_)_"
  ;;
shiina)
  the_prompt="%{${fg_bold[blue]}%}_(:3｣_)_"
  ;;
*)
  the_prompt="%{${fg_bold[cyan]}%}%n@${host_formats[host_int]}%m%{${reset_color}%}"
  ;;
esac



PROMPT="
%{${fg_bold[blue]}%}[ %~ ]%{${reset_color}%}
%{${fg[green]}%}${the_prompt}%(?,%{${fg_bold[green]}%},%{${fg_bold[red]}%})%# %{${reset_color}%}"
#PROMPT2=
#SPROMPT=
#RPROMPT="[${vcs_echo}]"
#RPROMPT=$'$(vcs_info_wrapper)'
