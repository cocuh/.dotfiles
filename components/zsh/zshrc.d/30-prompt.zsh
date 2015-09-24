#zsh PROMPT
local host_formats;host_formats=('%{${fg[red]}%}' '%{${fg[green]}%}' '%{${fg[cyan]}%}')
local host_int=$(echo "ibase=16;hostname=$(echo $(hostname) | shasum | awk '{print toupper($1)}');ibase=A;hostname%${#host_formats}+1" | bc)

local the_prompt="%{${fg_bold[cyan]}%}%n@${host_formats[host_int]}%m%{${reset_color}%}"
case $(hostname) in
stern)
  the_prompt="%{${fg_bold[green]}%}ヾ(  _ﾟ々｡ア"
  ;;
saya)
  the_prompt="_(:3｣_)_"
  ;;
esac



PROMPT="
%{${fg_bold[blue]}%}[ %~ ]%{${reset_color}%}
%{${fg[green]}%}${the_prompt}%(?,%{${fg_bold[green]}%},%{${fg_bold[red]}%})%# %{${reset_color}%}"
#PROMPT2=
#SPROMPT=
#RPROMPT="[${vcs_echo}]"
RPROMPT=$'$(vcs_info_wrapper)'
