# dot v1.0

`dot`はbash製のdotfiles管理フレームワークです。

## 説明

このスクリプトを使うとdotfilesの管理が簡単になります。

スクリプトはbashで書かれており，移植性に優れ，設定が容易にできます。

日常的に複数マシンを使う人，新しいPCのセットアップするとき，毎日dotfilesでcontributionに草を生やし続けている人におすすめです。

## 使い方

ユーザーの設定ファイルは'[dotrc](./examples/dotrc)'。
シンボリックリンクの対応表は'[dotlink](./examples/dotlink)'に書きます。

* dotfiesをpullしてくる(by git).  
```bash
dot pull
```

* シンボリックリンクを対話的に作成  
  このコマンドは，`dotlink`に書かれたシンボリックリンクを貼っていきます
  (もし既にファイルが存在する場合には，1.差分表示，2.2ファイルを編集，3.既存ファイルに上書き，4.バックアップを作成して上書き，5.何もしない，の操作を選ぶことができます。)。
  オプション`-i`をつけると非対話的になり，もし競合が起こった際は何もしません。
  `-v`オプションをつけると，より冗長なメッセージを表示します。
```bash
dot set [-i][-v]
```

* 新たなファイルをdotfilesに追加，シンボリックリンクを貼り，対応関係を`dotlink`に追記  
```bash
dot add some_file [~/.dotfiles/path/to/the/file]
```

* 選択したシンボリックリンクをunlinkし，dotfilesから元ファイルのコピーを持ってくる  
```bash
dot unlink <link> [<link> <link> ... ]
```

* `$dotlink`ファイルに記載された**すべての**シンボリックリンクをunlinkする  
```bash
dot clear
```

* (私の)dotfilesを自分のPCにクローンするなら  
```bash
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
# You can change the dotfiles to clone
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

## インストール

### 必要なもの

* bash
* git

### 手順

* このリポジトリを自分のPCにforkかcloneしてください:  
```
git clone https://github.com/ssh0/dot ~/.git/dot
```

* `make install`を実行してください:
```
sudo make install
```

`/usr/local/bin/`に`dot`がインストールされます。

* 設定ファイルのサンプルを自分のdotfilesに追加してください:  
```
make copy-config 
```

で, `examples/dotrc`と`examples/dotlink`が`~/.dotfiles`にコピーされます。

違う場所にコピーしたいときは,

```
make copy-config DOTDIR=-$HOME/dotfiles
```

のようにしてください。

* マシン固有の設定をする場合には，`dotrc.local`，`dotlink.local`なども必要に応じてコピーします:  
```
make copy-local-config
```

コピs-する場所を指定するには(規定値: `$HOME/.config/dot/`)

```
make copy-local-config USERCONFDIR=-$HOME/.dot
```

としてください。

既にdotfilesからリンクが貼られているものをリンク対応表に追記するには，

```
dot add <link1> <link2> <link2> <link3> ...
```

とするだけで良いです。

## TODO

* 他OSでのテスト (いくつかのUbuntu 14.04搭載マシンでテストしただけなので...)

## ライセンス

このプロジェクトは[MIT](./LICENSE)ライセンスで公開します。

## 連絡先

もっと改善できるよとかバグ見つけたとか質問などあればお気軽にご連絡ください。

* [ssh0(Shotaro Fujimoto) - GitHub](https://github.com/ssh0)

