# bash-preexec is installed alongside bashrc
. ~/.bashrc.d/bash-preexec.sh
. ~/.bashrc.d/ps1

# Setup C-z to toggle fg/bg
preexec() { stty susp '^Z'; }
precmd() { stty susp undef; export PS1=$(update_ps1); }

on_ctrl_z() {
	[[ -z $(jobs) ]] && return
	fg
}
bind '"\C-z":"\C-uon_ctrl_z\n"'

export EDITOR=vim

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias pacman='pacman --color=auto'
