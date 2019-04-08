# dotfiles
These are the dotfiles for my macOS setup. The dotfiles
are managed by [GNU Stow](https://www.gnu.org/software/stow/).

These dotfiles are currently used on my [hackintosh setup](https://gist.github.com/francoiscote/fd090c482936b94afe3e4322c4f6189b).

## Features
- Zsh Shell
- [Oh-my-zsh](https://ohmyz.sh/) framework
- [Pure prompt](https://github.com/sindresorhus/pure)
- `zsh-autosuggestions` and `zsh-syntax-highlighting`
- Tmux & Tmuxp
- Hammerspoon (OS scripting)
- Hyper (not used at the moment)
- Git configs
- macOS defaults
- VSCode Settings
- Awesome Font Icons (as an optional vendor)

## Installation
```
$ brew install stow
$ git clone --recurse-submodules git@github.com:francoiscote/dotfiles-macos.git ~/.dotfiles
```

### Install zsh-autosuggestions
```
$ git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
```

### Install zsh-syntax-highlighting
```
$ git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
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