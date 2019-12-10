# macOs

## 1. Defaults Scripts

Provided `.scripts/default.sh`, which sets up a bunch of default macOs Preferences that I like.

## 2. Brewfile Bundler

Stows a `~/.Brewfile` to be used with `brew bundle`. It contains all taps, brews and casks to install. See `brew bundle --help` for more details.

## Install

First, make sure you did `stow macOs` and that the Brewfile is simlinked as the global brewfile at `~/.Brewfile`. Then:

```shell
$ brew bundle --global
```

## Dump

```shell
$ brew dump --global --force
```
