function notify_preexec {
  notify_prev_executed_at=`date`
  notify_prev_command=$2
}

function notify_precmd {
  notify_prev_status=$?
  EXIT_CODE_KEYBOARD_INTERRUPT=130
  if [ $TTYIDLE -gt 30 ] &&
    [ $notify_prev_status -ne $EXIT_CODE_KEYBOARD_INTERRUPT ] &&
    (type notify-send &> /dev/null); then
    elapsed_time=$(python -c "print((lambda s:'{:.0f}s'.format(s)if s<120 else(lambda m:'{:.1f}m'.format(m)if m<100 else(lambda h:'{:.1f}h'.format(h))(m/60))(s/60))($TTYIDLE))")
    notify-send -i ~/.zshrc.d/resources/zsh.svg "Done: $notify_prev_command" "$notify_prev_executed_at ($elapsed_time)"
  fi
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec notify_preexec
add-zsh-hook precmd notify_precmd
