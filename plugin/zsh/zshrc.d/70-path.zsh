# path
binPathArrayBefore=(\
    "$HOME/.rbenv/bin"\
)
binPathArrayAfter=(\
    "$HOME/bin"\
    "$HOME/bin/bin"\
    "$HOME/bin/local"\
    "$HOME/bin/bin-git/utils"\
    "$HOME/bin/bin-git/twitter"\
    "$HOME/bin/utils"\
    "$HOME/bin/coins-tools"\
    "$HOME/bin/coins-utils"\
    "$HOME/.local/bin"\
    "$HOME/.gem/ruby/2.1.0/bin"\
)

for binPath in "${binPathArrayBefore[@]}";do;
    if [ -d $binPath ]; then
        export PATH=$binPath:$PATH
    fi
done

for binPath in "${binPathArrayAfter[@]}";do;
    if [ -d $binPath ]; then
        export PATH=$PATH:$binPath
    fi
done


