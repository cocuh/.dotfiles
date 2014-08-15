cocu's dotfiles
==============

usage
-----

`install.py`を走らせればシンボリックリンクを貼ってくれる。

```
$ cd ~
$ git clone http://github.com/cocu/dotfiles.git .dotfiles
$ cd .dotfiles
$ ./install.py [PROFILE]
$ ./regenzshrc.sh
```

### 注意
このzshの設定では`.zshrc`は生成しないので、
初期起動時に`~/zshrc.d`の内部を結合して`.zshrc`を作る必要がある。

最初に生成後は`~/.zshrc.d`に更新チェックをかけて再生成する。

できればzcompileでやりたかったぽよ

profiles
--------

pluginのまとまり

* p193
* macbookair
* server


plugins
-------

dotfileをどのようにシンボリックリンクするかの定義を大まかにソフトウェアごとに分けた集合

いい命名が思いつかなかった

* zsh
* tmux
* xmonad
* xdefaults
* xresources
* python