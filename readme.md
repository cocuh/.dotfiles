cocuh's dotfiles
==============

usage
-----

Run `python install.py`. it makes symbolic link to dotfiles.
This script required python. (but compatible for python2/3)

```
$ cd ~
$ git clone http://github.com/cocuh/.dotfiles.git
$ cd .dotfiles
$ ./install.py [PROFILE]
$ ./regenzshrc.py
```

### warning
This install script doesn't generate `.zshrc`.
You must run `regenzshrc.py` to generate `.zshrc` after calling install script.
After first zsh script generation, `.zshrc` watches `.zshrc.d/*/*.zsh` files to re-generate itself.

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
Components define how to make symbolic links on each dotfiles.

* zsh
* bin
* vim
* tmux
* mlterm
* ipython
* xdefaults
* xresources
* vimfx
* python
  * virtualenvwrapper
* awesome
  * lain
  * vicious
  * pomodoro
  * rofi
  * feh
  * wallpaperchanger.py
* ~~vimperator~~
  * change to `vimfx`(2017/03/11)
* ~~qtile~~
  * change to `awesome`(2017/01/20)
  * rofi
  * xboomx
  * feh
  * wallpaperchanger.py
* ~~xmonad~~
  * change to `qtile`(2015/04/18)

screenshots
-----------

### awesome
![](https://raw.github.com/wiki/cocuh/.dotfiles/screenshots/awesome.jpg)

### qtile
#### saya
![](https://raw.github.com/wiki/cocuh/.dotfiles/screenshots/qtile-saya.jpg)

#### stern
![](https://raw.github.com/wiki/cocuh/.dotfiles/screenshots/qtile-stern.jpg)
