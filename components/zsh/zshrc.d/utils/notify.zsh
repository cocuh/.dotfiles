function notify_preexec {
  notify_prev_executed_at=`date`
  notify_prev_command=$2
}

function notify_precmd {
  notify_prev_status=$?
  KEYBOARD_INTERRUPT_STATUS=130
  if [ $TTYIDLE -gt 30 ] &&
    [ $notify_prev_status -ne $KEYBOARD_INTERRUPT_STATUS ] &&
    [ $(which notify-send) ]; then
    notify-send -i ~/.zshrc.d/resources/zsh.svg "<big><b>Done: $notify_prev_command</b></big> <br/>$notify_prev_executed_at"
  fi
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec notify_preexec
add-zsh-hook precmd notify_precmd
