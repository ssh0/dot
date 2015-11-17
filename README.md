# dot

bash based dotfiles management framework

## Description

This script makes it easy to manage your dotfiles.

Script is written in bash, and very configurable.

You can use it for multi-machines usage, setup for new machine, daily watering to your dotfiles repository, etc...

## Usage

Configuration file is in '[dotrc](./dotrc)'.
Link relation table is in '[dotlink](./dotlink)'.

* Pull remote dotfile repository (by git).  
```bash
dot pull
```

* Make symbolic link interactively.  
  This command sets symbolic links configured in 'dotlink'.(If you have your file already, you can choose the operation interactively: show diff, edit these files, overwrite, make-backup or do-nothing).  With option "-i", this script runs without interaction mode and with "-v", this script shows verbose message.
```bash
dot set [-i][-v]
```

* Move the new file to the dotfile dir, make the link, and edit 'dotlink'.  
```bash
dot add some_file [~/.dotfiles/path/to/the/file]
```

* Unlink the selected symbolic links and copy its original files from the dotfile directory.  
```bash
dot unlink <link> [<link> <link> ... ]
```

* Remove the *all* symbolic link written in the dotlink file `$dotlink`.

```bash
dot clear
```

* Clone (my) dotfile repository on your computer.  
```bash
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
# You can change the dotfiles to clone
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

## Install

### Requirements

* bash
* git

### Procedure

* clone this repository on your computer:  
```
git clone https://github.com/ssh0/dot ~/.git/dot
```
* make a symbolic link to your PATH directory:  
```
sudo ln -s ~/.git/dot/dot /usr/local/bin/dot
```
* copy sample configuratoin files to your repository:  
```
cp ~/.git/dot/config/dotrc ~/.dotfiles/dotrc
cp ~/.git/dot/config/dotlink ~/.dotfiles/dotlink
```
* copy local settings if you want:  
```
mkdir -p ~/.config/dot
cp ~/.git/dot/config/dotrc.local ~/.config/dot/dotrc.
cp ~/.git/dot/config/dotlink.local ~/.config/dot/dotlink.local
```

done.

In order to add link-relation-table already exists, just

```
dot add <link1> <link2> <link2> <link3> ...
```

## TODO

* more easy installation
* test in other OS (I use some Ubuntu 14.04 machines and only tested in there)

## LICENSE

This project is under [MIT](./LICENSE) license.

## Contact

If you improve this project, find bugs or have a question, feel free to contact me.

* [ssh0(Shotaro Fujimoto) - GitHub](https://github.com/ssh0)

