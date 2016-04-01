#!/bin/bash

set -x

cp='cp -r --force'

$cp vimrc       ~/.vimrc
$cp zshrc       ~/.zshrc
#$cp vim/*	      ~/.vim
$cp gitconfig   ~/.gitconfig
$cp gitignore   ~/.config

if [ ! -e ~/.vim/bundle ]; then
  mkdir ~/.vim/bundle
  git clone https://github.com/VundleVim/Vundle.vim ~/.vim/bundle/Vundle.vim
fi

echo "Don't forget to run :PluginInstall from vim"
