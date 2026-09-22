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

* thinkpad
* server
* work


component
-------
Components define how to make symbolic links on each dotfiles.

* zsh
* bin
* nvim
* tmux
* xdefaults
* xkbdefaults
* xresources
* python
  * virtualenvwrapper
* awesome
  * lain
  * vicious
* git
* dunst

screenshots
-----------

### awesome
![](https://raw.github.com/wiki/cocuh/.dotfiles/screenshots/awesome.jpg)
