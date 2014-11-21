function highlight(){
    pygmentize -O style=monokai -f console256 -g $*
}
