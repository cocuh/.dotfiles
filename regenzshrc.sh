#!/bin/zsh
if [ -e ~/.zshrc ];then
    rm ~/.zshrc
fi
for filename in $(find ~/.zshrc.d/ -type f | sort)
do
    echo \#$(basename $filename) >> ~/.zshrc
    cat $filename >> ~/.zshrc
    echo >> ~/.zshrc 
done
echo regened zshrc
source ~/.zshrc
