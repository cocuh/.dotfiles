zmodload zsh/datetime

function notify_preexec {
  notify_prev_started_at=$EPOCHSECONDS
  notify_prev_command=$2
}

function notify_precmd {
  local notify_prev_status=$?
  local EXIT_CODE_KEYBOARD_INTERRUPT=130
  [[ -z $notify_prev_started_at ]] && return
  local elapsed=$(( EPOCHSECONDS - notify_prev_started_at ))
  local started_at=$(strftime '%c' $notify_prev_started_at)
  unset notify_prev_started_at
  if (( elapsed > 30 )) &&
    (( notify_prev_status != EXIT_CODE_KEYBOARD_INTERRUPT )) &&
    (( $+commands[notify-send] )); then
    local elapsed_time
    if (( elapsed < 120 )); then
      elapsed_time=${elapsed}s
    elif (( elapsed < 6000 )); then
      elapsed_time=$(printf '%.1fm' $(( elapsed / 60.0 )))
    else
      elapsed_time=$(printf '%.1fh' $(( elapsed / 3600.0 )))
    fi
    notify-send -i ~/.zshrc.d/resources/zsh.svg "Done: $notify_prev_command" "$started_at ($elapsed_time)"
  fi
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec notify_preexec
add-zsh-hook precmd notify_precmd
