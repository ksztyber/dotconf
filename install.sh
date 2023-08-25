#!/bin/bash

set -e

rootdir=$(dirname $0)

copy() { cp -r --force "$rootdir/$1" "$2"; }

mkdir -p ~/.bashrc.d
copy vimrc				~/.vimrc
copy zshrc				~/.zshrc
copy vim				~/.vim
copy gitconfig				~/.gitconfig
copy gitignore				~/.config
copy Xdefaults				~/.Xdefaults
copy bash-preexec/bash-preexec.sh	~/.bashrc.d/
copy bashrc	 			~/.bashrc.d/

[[ ! -e ~/.bashrc ]] && cat > ~/.bashrc <<- EOF
	for _rc in ~/.bashrc.d/*; do
		[[ -f "\$_rc" ]] && source "\$_rc"
	done
	unset _rc
EOF

if [ ! -e ~/.vim/bundle ]; then
  mkdir ~/.vim/bundle
  git clone https://github.com/VundleVim/Vundle.vim ~/.vim/bundle/Vundle.vim
fi

echo "Don't forget to run :PluginInstall from vim"
