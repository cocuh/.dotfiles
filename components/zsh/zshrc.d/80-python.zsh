if [ -e ~/.python/startup.py ];then
    export PYTHONSTARTUP=~/.python/startup.py
fi
for vwpath in $(where virtualenvwrapper.sh);do
    if [ -e $vwpath ];then
        source $vwpath
    fi
done


