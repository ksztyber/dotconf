#!/bin/bash

cp='cp -r --force'

$cp vimrc       ~/.vimrc
$cp zshrc       ~/.zshrc
$cp vim         ~/.vim
$cp gitconfig   ~/.gitconfig
$cp gitignore   ~/.config
$cp Xdefaults   ~/.Xdefaults

if [ ! -e ~/.vim/bundle ]; then
  mkdir ~/.vim/bundle
  git clone https://github.com/VundleVim/Vundle.vim ~/.vim/bundle/Vundle.vim
fi

echo "Don't forget to run :PluginInstall from vim"
