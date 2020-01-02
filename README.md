# dotfiles

These are the dotfiles for my macOS setup. The dotfiles
are managed by [GNU Stow](https://www.gnu.org/software/stow/).

## Features

- Zsh Shell
  - [Oh-my-zsh](https://ohmyz.sh/) framework
  - `zsh-autosuggestions` and `zsh-syntax-highlighting` plugins
  - [Spaceship prompt](https://github.com/denysdovhan/spaceship-prompt)
  - [tmux](https://github.com/tmux/tmux) & [tmuxp](https://github.com/tmux-python/tmuxp)
- [Alacritty](https://github.com/jwilm/alacritty) terminal
- [Hammerspoon](https://www.hammerspoon.org/)
- [Karabiner Elements](https://pqrs.org/osx/karabiner/)
- Git Configs
- macOS defaults
- homebrew bundle
- VSCode Settings

## Installation

```shell
$ brew install stow
$ git clone git@github.com:francoiscote/dotfiles-macos.git ~/.dotfiles
```

## Usage

Create the symbolic links for each feature you need. Watch out, some folders have a README.md with custom installation instructions

```shell
$ cd ~/.dotfiles
$ stow git
$ stow tmux
$ stow ...
```

Make the content of `~/.scripts` executable

```shell
$ sudo chmod +x ~/.scripts/\*
```
