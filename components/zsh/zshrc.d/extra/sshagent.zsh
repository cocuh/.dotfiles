if [ -e ~/.ssh-agent-info ]; then
    source ~/.ssh-agent-info
fi

ssh-add -l >&/dev/null
if [ $? = 2 ] ; then
    ssh-agent | sed -e 's/^echo/\# echo/g' > ~/.ssh-agent-info
    source ~/.ssh-agent-info
fi
if ssh-add -l >& /dev/null ; then
else
    ssh-add >& /dev/null
fi
