# auto compile
function regenzshrc(){
    rm ~/.zshrc
    for filename in $(find ~/.zshrc.d/ -type f -name "*.zsh"| sort)
    do
        echo \#$(basename $filename) >> ~/.zshrc
        cat $filename >> ~/.zshrc
        echo >> ~/.zshrc 
    done
    echo regened zshrc
}
if [ ! -f ~/.zshrc -o ${#$(find ~/.zshrc.d/ -type f -newer ~/.zshrc)} -ne 0 ]; then
    regenzshrc
fi
