# dotfiles
These are the dotfiles for my macOS setup. The dotfiles
are managed by [GNU Stow](https://www.gnu.org/software/stow/).

These dotfiles are currently used on my [hackintosh setup](https://gist.github.com/francoiscote/fd090c482936b94afe3e4322c4f6189b).

## Installation
```
$ brew install stow
$ git clone --recurse-submodules git@github.com:francoiscote/dotfiles-macos.git ~/.dotfiles
```

## Usage
Create the symbolic links for each component you need.

```
$ cd ~/.dotfiles
$ stow git
$ stow tmux
$ stow ...
$ sudo chmod +x ~/.scripts/*
```

### zsh
`zsh` depends on (antigen)[https://github.com/zsh-users/antigen/] (available on the AUR for Arch).
```
$ brew install antigen
$ cd ~/.dotfiles
$ stow zsh
```
Open a new shell prompt for antigen to install the dependencies.
