export PYENV_ROOT="$HOME/.pyenv"
if [ -d $PYENV_ROOT ]; then
    export PATH="$PYENV_ROOT/bin:$PATH"
fi
if [ `which pyenv` ]; then
    eval "$(pyenv init -)"
fi
