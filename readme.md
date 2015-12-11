cocuh's dotfiles
==============

usage
-----

run `install.py`. it makes symbolic link to dotfiles.

```
$ cd ~
$ git clone http://github.com/cocuh/.dotfiles.git
$ cd .dotfiles
$ ./install.py [PROFILE]
$ ./regenzshrc.sh
```

### warning
this script required python. (but compatible for either python2 or 3)


This install script doesn't generate `.zshrc`.
You should run `regenzshrc.sh` to generate `.zshrc` at first.
After first generation, `.zshrc` watches `.zshrc.d/*/*.zsh` files to re-generate itself if these files changes.

できればzcompileでやりたかったぽよ

profile
--------

componentのまとまり

* p193
* macbookair
* macbookpro
* server


component
-------
Components define how to make symbolic links on each software.

* zsh
* bin
* vim
* tmux
* mlterm
* ipython
* xdefaults
* xresources
* vimperator
* python
* qtile
  * rofi
  * xboomx
  * feh
  * wallpaperchanger.py
* ~~xmonad~~
  * change to `qtile`(2015/04/18)

screenshots
-----------

### qtile
#### saya
![](https://raw.github.com/wiki/cocuh/.dotfiles/screenshots/qtile-saya.jpg)
#### stern
![](https://raw.github.com/wiki/cocuh/.dotfiles/screenshots/qtile-stern.jpg)
