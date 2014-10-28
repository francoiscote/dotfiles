# François Côté's' Dot Files

These are my .dotfiles. This is a fork of [Ryan Bates dot files](https://github.com/ryanb/dotfiles).
It uses [Oh My ZSH](https://github.com/robbyrussell/oh-my-zsh).

I am running on Mac OS X, but it will likely work on Linux as well.


## Installation

Run the following commands in your terminal. It will prompt you before it does anything destructive. Check out the [Rakefile](https://github.com/francoiscote/dotfiles/blob/custom-bash-zsh/Rakefile) to see exactly what it does.

```terminal
git clone git://github.com/francoiscote/dotfiles ~/.dotfiles
cd ~/.dotfiles
rake install
```



## Features

See Ryan's original Repo for most of the features.

I added a couple of git aliases and configs. I also have an alias for flushing my dns cache (because I always forget about it), and copying mu public key on the pasteboard.

I also copied some usefull stuff from Holman's dotfiles, like:
* a backupMySql script to quickly make a backup of all my local databases.
* a git-wtf utility that gives you a nice overview of the state of your repo.

The plugin will also try to source a ~/.localrc file. I use this file to keep private stuff that I don't want to share in this repo.
