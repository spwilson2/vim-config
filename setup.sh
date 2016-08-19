#!/bin/bash

set -e

SOURCE="${BASH_SOURCE[0]}"

while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
	DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
	SOURCE="$(readlink "$SOURCE")"
	[[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done

DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

set +e

ln -s "$DIR" "~/.vim"
ln -s "$DIR/vimrc" "~/.vimrc"

set -e

git pull; git submodule update --init --recursive

vim +PluginInstall +qall

echo "\
###################################################

Remember to run:

python ~/.vim/bundle/YouCompleteMe/install.py

if you want to install YouCompleteMe! 

Don't forget you'll need to have cmake installed.

###################################################\
"
