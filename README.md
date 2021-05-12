# dotfiles
These are the dotfiles of my Fedora + GNOME setup. The dotfiles
are managed by [GNU Stow](https://www.gnu.org/software/stow/).

## Installation

### Install Dependencies
```
$ sudo dnf install zsh zsh-autosuggestions zsh-syntax-highlighting

```

### Clone dotfiles
```
$ git clone git@github.com:francoiscote/dotfiles-linux.git ~/.dotfiles
```

## Usage
Create the symbolic links for each component you need.

```
$ cd ~/.dotfiles
$ stow gnome
$ stow alacritty
$ stow ...[etc]
$ sudo chmod +x ~/.scripts/*
```
