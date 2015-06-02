if [ -e ~/.python/startup.py ];then
    export PYTHONSTARTUP=~/.python/startup.py
fi

if [ -e $(where virtualenvwrapper.sh) ];then
    source $(where virtualenvwrapper.sh)
fi


