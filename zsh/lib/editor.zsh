#!/bin/sh

if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    if [ -x $(brew --prefix)/bin/zed ]; then
        export EDITOR='zed'
    else
        if [ -x $(brew --prefix)/bin/code-insiders ]; then
            export EDITOR='code-insiders'
        else
            if [ -x $(brew --prefix)/bin/code ]; then
                export EDITOR='code'
            else
                export EDITOR="nvim"
            fi
        fi
    fi
fi