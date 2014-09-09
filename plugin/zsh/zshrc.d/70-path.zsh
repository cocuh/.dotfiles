# path
binPathArrayBefore=(\
    "$HOME/.rbenv/bin",\
)
binPathArrayAfter=(\
    "$HOME/bin/bin",\
    "$HOME/bin/bin-git/utils",\
    "$HOME/bin/bin-git/twitter",\
    "$HOME/bin/bin-git/utils",\
    "$HOME/bin/utils",\
    "$HOME/bin/coins-tools",\
    "$HOME/bin/coins-utils",\
    "$HOME/.local/bin",\
)

for binPath in "${binPathArrayBefore[@]}";do;
    if [ -d $binPath ]; then
        export PATH=$PATH:$binPath
    fi
done

for binPath in "${binPathArrayAfter[@]}";do;
    if [ -d $binPath ]; then
        export PATH=$PATH:$binPath
    fi
done


