[日本語](./README_ja.md)

# dot v1.1

bash based dotfiles management framework

## Description

This script makes it easy to manage your dotfiles.

Script is written in bash, and very configurable.

You can use it for multi-machines usage, setup for new machine, daily watering to your dotfiles repository, etc...

## Usage

Configuration file is in '[dotrc](./examples/dotrc)'.
Link relation table is in '[dotlink](./examples/dotlink)'.

### dot pull

Pull remote dotfile repository (by git)

```
dot pull
```

### dot set

Set symbolic links configured in 'dotlink'.

If you have your file already, you can choose the operation interactively:  
show diff, edit these files, overwrite, make-backup or do-nothing.

With option "-i", this script runs without interaction mode and with "-v", this script shows verbose messages.

```
dot set [-i][-v]
```

### dot add

Move the new file to the dotfile dir, make the link, and edit 'dotlink'.

```
dot add some_file [~/.dotfiles/path/to/the/file]
```

### dot edit

Edit 'dotlink'

```
dot edit
```

### dot config

Edit configuration file 'dotrc'

```
dot config
```

### dot unlink

Unlink the selected symbolic links and copy its original files from the dotfile directory.

```
dot unlink <link> [<link> <link> ... ]
```

### dot clear

Remove the *all* symbolic link written in the dotlink file `$dotlink`.

```
dot clear
```

### dot clone

Clone dotfile repository on your computer with git.

```
dot clone [<dir_to_clone>]
```

## Use case

### Multi-machine configuration

You can add `dotrc.local` and `dotlink.local` on each computers and don't have to divide dotfiles repository.

Share or don't share the configuration what you want.

`dot pull` provides you fresh dotfiles anywhere.

### New machine setup

If you have your own dotfiles already and manage with `dot`, just:

* Install git and dot.
* Clone to your computer.
* Edit `dotrc` like below:  
```
clone_repository='https://github.com/yourusername/dotfiles.git'
```
* And just run  
```
dot clone && dot set
```

### For daily use

If you want to add your new configuration file to your dotfiles repository, just run

```
dot add newfile
```

Then the script asks you like:

```
Suggestion:
dot add -m '' newfile /home/username/.dotfiles/newfile

Continue? [y/N]'
```

Type `y` and `Enter`, then move `newfile` to `/home/username/.dotfiles/newfile` and make symbolic link to `newfile` and this link information is written in `dotlink`

Other things you should do is `git commit` and `git push` to your repository.
(Or if you use Dropbox or so, you can skip these steps.)

In order to add link-relation-table already exists, just

```
dot add <link1> <link2> <link2> <link3> ...
```

## Install

### Requirements

* bash
* git

### Install manually

Clone this repository on your computer and source from your `bashrc` or `zshrc`.

```
git clone https://github.com/ssh0/dot $HOME/.zsh/dot
echo "source $HOME/.zsh/dot" >> ~/.zshrc
```

### With plugin manager

If you use some zsh plugin manager (ex. antigen, zgen, zplug, etc.), load from `zshrc` like:

```
antigen bundle ssh0/dot
```

## Configuration

First, you should set the dotfiles repository to manage and the dotfiles directory.

In `~/.zshrc`,

```
export DOT_REPO="https://github.com/yourusername/dotfiles.git"
export DOT_DIR="$HOME/.dotfiles"
```

### Edit or copy your configuratoin file

```
dot config 
```

will edit or copy `$DOT_DIR/dotrc`.

### [optional] Copy local settings

```
cp ~/.zsh/dot/examples/dotrc ~/.config/dot/dotrc.local
```

and source this file from your configuration file `dotrc`:

```
dotbundle "$HOME/.config/dot/dotrc.local"
```

## TODO

* test in other OS (I use some Ubuntu 14.04 machines and only tested in there)

## LICENSE

This project is under [MIT](./LICENSE) license.

## Contact

If you improve this project, find bugs or have a question, feel free to contact me.

* [ssh0(Shotaro Fujimoto) - GitHub](https://github.com/ssh0)

