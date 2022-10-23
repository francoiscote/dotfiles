# dotfiles

These are the dotfiles for my macOS setup. The dotfiles
are managed by [GNU Stow](https://www.gnu.org/software/stow/).

## Features

- Zsh Shell
  - `zsh-autosuggestions` and `zsh-syntax-highlighting` plugins
  - [Spaceship prompt](https://github.com/denysdovhan/spaceship-prompt)
  - [tmux](https://github.com/tmux/tmux)
  - [tmuxp](https://tmuxp.git-pull.com/)
- [Hammerspoon](https://www.hammerspoon.org/)
- [Karabiner Elements](https://pqrs.org/osx/karabiner/)
- Git Configs
- macOS defaults
- homebrew bundles

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

## TO DO

### Installation script

- install XCode command line tools
  - `xcode-select --install`
- install brew
  - `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"`
- `brew install stow`

- checkout `dotfiles-private` using https
  - using https
  - `stow localrc ssh tmuxp`
  - fix permissions on `.ssh`
- checkout `dotfiles`
  - `stow ...`
- install brew packages bundle
  - `brew bundle --global`
- `brew install starship`
- checkout git projects in "Code"
