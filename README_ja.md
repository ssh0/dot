[English](./README.md)

# dot v1.2

`dot`はシェルスクリプトで書かれたdotfiles管理フレームワークです。

## 説明

このスクリプトを使うとdotfilesの管理が簡単になります。

日常的に複数マシンを使う人，新しいPCのセットアップするとき，毎日dotfilesでcontributionに草を生やし続けている人におすすめです。

## 使い方

ユーザーの設定ファイルは'[dotrc](./examples/dotrc)'。
シンボリックリンクの対応表は'[dotlink](./examples/dotlink)'に書きます。

**サブコマンド**

|サブコマンド名|説明|オプション or 引数|
|---       |---    |---        |
| pull     |dotfiesをpullしてくる(by git). ||
|set       |`dotlink`に書かれたシンボリックリンクを貼る|`[-i][-v]`|                                                 |
| add      |新たなファイルをdotfilesに追加，シンボリックリンクを貼り，対応関係を`dotlink`に追記|`some_file [$DOT_DIR/path/to/the/file]` or `link1 [link2 [link3 [...] ] ]`|
|edit      |'dotlink'を手動で編集||
|config    |設定ファイル'dotrc'を編集||
|unlink    |選択したシンボリックリンクをunlinkし，dotfilesから元ファイルをコピー|`link1 [link2 [link3 [...] ] ]`|
|clear     |`$dotlink`ファイルに記載された**すべての**シンボリックリンクをunlink||
|clone     |gitコマンドを使ってdotfilesを自分のPCにクローン|`[/directory/to/clone/]`|

### dot pull

dotfiesをpullしてくる(by git).  
```bash
dot pull
```

### dot set

このコマンドは，`dotlink`に書かれたシンボリックリンクを貼っていきます。

もし既にファイルが存在する場合には,

1. 差分表示
2. 2ファイルを編集
3. 既存ファイルに上書き
4. バックアップを作成して上書き
5. 何もしない

の操作を選ぶことができます。

オプション`-i`をつけると非対話的になり，もし競合が起こった際は何もしません。 `-v`オプションをつけると，より冗長なメッセージを表示します。

```
dot set [-i][-v]
```

### dot add

新たなファイルをdotfilesに追加，シンボリックリンクを貼り，対応関係を`dotlink`に追記

```
dot add some_file [~/.dotfiles/path/to/the/file]
```

### dot edit

'dotlink'を手動で編集する。

```
dot edit
```

### dot config

設定ファイル'dotrc'を編集する。

```
dot config
```

### dot unlink

選択したシンボリックリンクをunlinkし，dotfilesから元ファイルのコピーを持ってくる。

```
dot unlink <link> [<link> <link> ... ]
```

### dot clear

`$dotlink`ファイルに記載された**すべての**シンボリックリンクをunlinkする

```
dot clear
```

### dot clone

gitコマンドを使ってdotfilesを自分のPCにクローンする

```
dot clone [<dir_to_clone>]
```

## ユースケース

### 複数マシン間での設定共有，非共有

`dotrc.local`や`dotlink.local`をそれぞれのPCに作成し，そこに固有のリンクを記載すれば，マシンそれぞれについてdotfilesをつくる必要はなくなります。

共有したい設定はいつでも共有でき，共有したくない設定も，gitで管理しながら独立に扱えます。

PCを立ち上げて`dot pull`コマンドを実行すれば，すぐに最新の設定環境になります。

### 新しいPCのセットアップ

dotfilesをGitHubなどで管理していて， `dot`を既に使っていれば，以下のように簡単にセットアップが行えます。

* gitとdotを新PCにインストール
* dotfilesをクローン
* `dotrc`を以下のように編集:  
```
clone_repository='https://github.com/yourusername/dotfiles.git'
```
* 以下のコマンドを実行:  
```
dot clone && dot set
```

おしまい。

### 普段使い

新しい設定ファイルをdotfilesに追加したいときは，

```
dot add newfile
```

とすれば良いです。

こうすると，スクリプト側から:

```
Suggestion:
dot add -m '' newfile /home/username/.dotfiles/newfile

Continue? [y/N]'
```

のように訊かれるので`y`を押して`Enter`キーを押すと，`newfile`が`/home/username/.dotfiles/newfile`に移動され，`newfile`のあった場所にシンボリックリンクが貼られ，この対応関係が`dotlink`に追記されます。

あとは`git commit`して`git push`するだけです。
(もしDropboxなどを使っていれば，この操作もいりません。)

既にdotfilesからリンクが貼られているものをリンク対応表に追記するには，

```
dot add <link1> <link2> <link2> <link3> ...
```

とするだけで良いです。


## インストール

### 必要なもの

* bash(or zsh)
* git

### マニュアルインストール

このリポジトリを自分のPCにforkかcloneし,`bashrc`や`zshrc`から`source`してください。

```
git clone https://github.com/ssh0/dot $HOME/.zsh/dot
```

```
source $HOME/.zsh/dot/dot.sh
```

### プラグインマネージャを利用する場合

zshを利用していて,プラグインマネージャを利用している場合(ex. [zplug](https://github.com/b4b4r07/zplug), [zgen](https://github.com/tarjoilija/zgen), [antigen](https://github.com/zsh-users/antigen), etc.)には,`zshrc`でプラグインとして読み込んでください。

```
zplug "ssh0/dot"
```

```
zgen load ssh0/dot
```

```
antigen bundle ssh0/dot
```

## 設定

まず,`dot`で管理するdotfilesのリポジトリと,ローカルにおけるディレクトリ名を設定します。

`~/.zshrc`に以下のように書いてください:

```
export DOT_REPO="https://github.com/yourusername/dotfiles.git"
export DOT_DIR="$HOME/.dotfiles"
```

### コマンド名を好きな名前に変更する

"dot"という名前はあまりに一般的すぎて，他のスクリプトやアプリケーションで既に使われているかもしれません。

もしくは，さらに短いタイプ数で呼び出したいと考えるかもしれません。

`dot`コマンドに対してaliasを登録することはもちろんできますが，
`dot`という名前を無効にして，他の名前をつけることも可能です。

`bashrc`や`zshrc`に，以下のように記述してください。

```
export DOT_COMMAND=DOOOOOOOOOOOOT
```

このようにすると，このコマンドは`dot`という名前をもちません。

(当然本体の関数名である`dot_main`でもスクリプトを実行することができます。)

### 設定ファイルの編集

設定ファイルは

```
dot config
```

で編集することができ,また設定ファイルが存在しなければ,デフォルトの設定ファイルが`$DOT_DIR/dotrc`にコピーされます。

### dotlinkファイルを編集する

`dotlink`ファイルは

```
dot edit
```

で編集することができます。

**設定例**

`dotlink`

```

# コメントアウトされた行は無視されます。

# 空行も同様です。

# フォーマット:
# <dotfile>,<linkto>
#
# スクリプトによってホームの位置やdotfilesのパスが補完されるので,
# すべてのパスを記述する必要はありません。
# したがって,以下のように書けます:
myvimrc,.vimrc

# このようにすると,`$DOT_DIR/myvimrc`から`$HOME/.vimrc`にシンボリックリンクが
# 張られることになります。

# 以下のように指定することはできません。
# x   ~/.dotfiles/myvimrc,~/.vimrc
#

# "/"で始まる場合には,それはパスとして正しく認識されます。
# これはプライベートな情報を含んだファイルを管理したいときに役立ちます。
# これらのファイルをdotfilesにアップロードすることなく,以下のようにできます。
/home/username/Dropbox/briefcase/netrc,.netrc

```

私の`dotlink`は[ここ](https://github.com/ssh0/dotfiles/blob/master/dotlink)にあるので,ご参考にどうぞ。


### マシン固有の設定ファイル


マシン固有の設定をする場合には，`dotrc.local`，`dotlink.local`なども必要に応じてコピーします。

```
cp ~/.zsh/dot/examples/dotrc ~/.config/dot/dotrc.local
```

`dotrc`内で忘れずにsourceしてください。

## TODO

* 他OSでのテスト (いくつかのUbuntu 14.04搭載マシンでテストしただけなので...)

## ライセンス

このプロジェクトは[MIT](./LICENSE)ライセンスで公開します。

## 連絡先

もっと改善できるよとかバグ見つけたとか質問などあればお気軽にご連絡ください。

* [ssh0(Shotaro Fujimoto) - GitHub](https://github.com/ssh0)

