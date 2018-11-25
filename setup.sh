#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
[ -e ~/.vim ] || ln -s "$DIR" ~/.vim
vim +PlugInstall +qall
