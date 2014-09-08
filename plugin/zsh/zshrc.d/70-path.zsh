# path
binPathArray=(\
    "$HOME/bin/bin",\
    "$HOME/bin/bin-git/utils",\
    "$HOME/bin/bin-git/twitter",\
    "$HOME/bin/bin-git/utils",\
    "$HOME/bin/utils",\
    "$HOME/bin/coins-tools",\
    "$HOME/bin/coins-utils",\
    "$HOME/.local/bin",\
)
for binPath in "${binPathArray[@]}";do;
    if [ -d $binPath ]; then
        export PATH=$PATH:$binPath
    fi
done
