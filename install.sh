#!/bin/bash

set -x

cp='cp -r --force'

$cp vimrc       ~/.vimrc
$cp zshrc       ~/.zshrc
$cp vim/*	      ~/.vim
$cp gitconfig   ~/.gitconfig
$cp gitignore   ~/.config

