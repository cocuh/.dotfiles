#zsh PROMPT
local the_prompt="%{${fg_bold[cyan]}%}%n@%{${fg[red]}%}%m%{${reset_color}%}"
case $(hostname) in
cocu-P193-arch)
  the_prompt="_(_「ε:)_"
  ;;
eliphas)
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
