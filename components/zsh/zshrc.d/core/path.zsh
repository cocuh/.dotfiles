if [ -z $_PATH ]; then
  export _PATH="$PATH"
else
  export PATH="$_PATH"
fi
