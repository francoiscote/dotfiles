# dotfiles

These are the dotfiles for my macOS setup. The dotfiles
are managed by [GNU Stow](https://www.gnu.org/software/stow/).

## Features

| | |
|---|---|
| **Shell** | Zsh w/ `zsh-autosuggestions`, `zsh-syntax-highlighting`, [Starship](https://starship.rs) prompt |
| **Terminal** | [Ghostty](https://ghostty.org) — Catppuccin Macchiato / GitHub Light |
| **Multiplexer** | [herdr](https://github.com/manaflow-ai/herdr) (prefix `^A`) |
| **Editor** | Neovim, VS Code, Zed |
| **Git** | `delta` diff, `lazygit`, `gh` |
| **CLI** | `eza`, `ripgrep`, `fd`, `fzf`, `bat`, `btop`, `jq` |
| **Languages** | Node (`n`), Python (`pyenv`), Ruby (`rbenv`), PHP (`phpbrew`), Rust (Cargo), Java 8 |
| **AI** | Claude Code, OpenCode, Sourcegraph Amp |
| **macOS** | Homebrew bundles, system defaults |
| **Other** | 1Password, Raycast, Obsidian, Linear, CleanShot X |

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

### Adopting new config files

```shell
$ stow-adopt ~/.config/btop
$ stow-adopt -p git ~/.config/lazygit
```

Interactively adopt config files into a stow package. Lists every file under
the given path in fzf (with a content/size preview) — pick the ones worth
keeping with `Space`, confirm with `Enter`. Selected files are moved into the
package (mirroring their path relative to `$HOME`) and symlinked back;
unselected files are left untouched.

- the path must live under `$HOME`; the package name is derived from its
  basename, or set explicitly with `-p <package>`
- files already symlinked into the dotfiles are shown tagged `[stowed]` and
  ignored if selected
- if a selected file diverged from an existing repo copy, the home version wins
- nothing is committed — review with `git status` afterwards

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
