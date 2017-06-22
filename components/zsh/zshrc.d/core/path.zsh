function path-append-before() {
    binPath = $1
    if [ -d $binPath ]; then
        export PATH=$binPath:$PATH
    fi
}

function path-append-after() {
    binPath = $1
    if [ -d $binPath ]; then
        export PATH=$PATH:$binPath
    fi
}
