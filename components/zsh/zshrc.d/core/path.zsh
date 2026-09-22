# re-apply ~/.zshenv in case /etc/zprofile (/etc/profile) reset PATH on login shells
[[ -r ~/.zshenv ]] && source ~/.zshenv
