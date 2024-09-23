#!/bin/bash

set -e

rootdir=$(dirname $0)

copy() { cp -r --force "$rootdir/$1" "$2"; }

mkdir -p ~/.bashrc.d
mkdir -p ~/.local/bin
mkdir -p $(python -m site --user-site)
copy vimrc				~/.vimrc
copy zshrc				~/.zshrc
copy vim				~/.vim
copy gitconfig				~/.gitconfig
copy gitignore				~/.config
copy Xdefaults				~/.Xdefaults
copy bash-preexec/bash-preexec.sh	~/.bashrc.d/
copy bashrc	 			~/.bashrc.d/
copy ps1				~/.bashrc.d/
copy alias				~/.bashrc.d/
copy tmux.conf				~/.tmux.conf
copy bin/dnfproxy			~/.local/bin
copy bin/git-colog			~/.local/bin
copy bin/git-gerritlog			~/.local/bin
copy bin/xfce4-switch-mode		~/.local/bin
copy gerrit-helpers/gerritlog.py	~/.local/bin/gerritlog
copy gerrit-helpers/gerrithelpers	$(python -m site --user-site)

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

plugvimdir=~/.vim/autoload/plug.vim
plugvimsite=https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
[[ ! -e "$plugvimdir" ]] && curl --create-dirs -fLo "$plugvimdir" "$plugvimsite"

vim +PluginInstall +PlugInstall +qall
