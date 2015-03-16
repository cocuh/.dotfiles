cocuh's dotfiles
==============

usage
-----

`install.py`を走らせればシンボリックリンクを貼ってくれる。

```
$ cd ~
$ git clone http://github.com/cocuh/.dotfiles.git
$ cd .dotfiles
$ ./install.py [PROFILE]
$ ./regenzshrc.sh
```

### 注意
pythonが必要(2,3 compatible)

このzshの設定では`.zshrc`は生成しないので、
初期起動時に`~/zshrc.d`の内部を結合して`.zshrc`を作る必要がある。

最初に生成後は`~/.zshrc.d`に更新チェックをかけて再生成する。

できればzcompileでやりたかったぽよ

profile
--------

pluginのまとまり

* p193
* macbookair
* macbookpro
* server


plugin
-------

dotfileをどのようにシンボリックリンクするかの定義を大まかにソフトウェアごとに分けた集合

いい命名が思いつかなかった

* zsh
* tmux
* xmonad
* xdefaults
* xresources
* python
