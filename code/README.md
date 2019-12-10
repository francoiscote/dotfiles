# VS Code

## Installing extensions from the list

```shell
$ cat extensions.txt | xargs -L1 code --install-extension
```

## Saving the current extensions to the list

```shell
$ code --list-extensions > ~/.dotfiles/code/extensions.txt
```
