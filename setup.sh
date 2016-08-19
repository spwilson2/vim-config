#!/bin/bash

set -ex

SOURCE="${BASH_SOURCE[0]}"

while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
	DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
	SOURCE="$(readlink "$SOURCE")"
	[[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done

DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

set +e

ln -s "$DIR" "$HOME/.vim"
ln -s "$DIR/vimrc" "$HOME/.vimrc"

git pull; git submodule update --init --recursive

#vim +PluginInstall +qall
#python ~/.vim/bundle/YouCompleteMe/install.py
