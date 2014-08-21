# path
export PATH=$PATH:/home/cocu/bin/bin
export PATH=$PATH:/home/cocu/bin/bin-git/utils
export PATH=$PATH:/home/cocu/bin/bin-git/twitter
export PATH=$PATH:/home/cocu/bin/bin-git/utils
export PATH=$PATH:/home/cocu/bin/utils
export PATH=$PATH:/home/cocu/bin/coins-tools
export PATH=$PATH:/home/cocu/bin/coins-utils

if [ -d /home/cocu/.local/bin ]; then
	export PATH=$PATH:/home/cocu/.local/bin
fi

if [ -d /home/cocu/.rbenv/bin/ ]; then
	export PATH=$PATH:/home/cocu/.rbenv/bin/
fi
