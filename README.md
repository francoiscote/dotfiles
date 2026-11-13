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
| **macOS** | Homebrew bundles, system defaults |
| **Other** | 1Password, Raycast, Obsidian, Linear, CleanShot X |

## Installation

```shell
$ brew install stow
$ git clone git@github.com:francoiscote/dotfiles.git ~/.dotfiles
```

## Usage

Create the symbolic links for each feature you need. Watch out, some folders have a README.md with custom installation instructions

```shell
$ cd ~/.dotfiles
$ stow git
$ stow tmux
$ stow ...
```

Agent settings live here as Stow packages:

```sh
cd ~/.dotfiles
stow --simulate --target="$HOME" agents codex opencode pi
stow --target="$HOME" agents codex opencode pi
```

- `agents`: shared skills-manager lockfile at `~/.agents/.skill-lock.json`.
- `codex`: `config.toml`, `hooks.json`, and `keybindings.json` at `~/.codex`.
- `opencode`: configuration at `~/.config/opencode`.
- `pi`: settings, instructions, extensions, dependency manifests, and Pi's
  separate skills-manager lockfile at `~/.pi/agent`.

Skills live in the private [skills](https://github.com/francoiscote/skills)
repo at `~/skills`. Run its `./install.sh` to link them into `~/.agents/skills`.
This repo does not own the skills themselves.

Stow preserves existing directories with `--no-folding` and excludes package
`setup.zsh` scripts. Zsh sources those scripts directly from dotfiles, including
Pi's shell environment. Credentials, sessions, caches, and installed dependencies
stay outside Git. Existing local config files must be backed up and moved aside
before first stowing; Stow will report conflicts rather than overwrite them.

Codex settings preserve this Mac's current configuration, including local paths,
plugin entries, project trust, and hook trust state. Review machine-specific
paths before installing on another Mac. Hooks currently use
`/opt/homebrew/bin/moshi-hook`; install it separately if using those hooks.
Pi's dependency manifests preserve its existing package manager files; installed
`node_modules` remain local. Applications may update their linked settings;
review those changes before committing.

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
