#!/bin/bash

ln -s ~/.vim/vimrc ~/.vimrc 
git submodule update --init --recursive
vim -c 'PluginInstall'
python ~/.vim/bundle/YouCompleteMe/install.py
