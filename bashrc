# bash-preexec is installed alongside bashrc
. ~/.bashrc.d/bash-preexec.sh
. ~/.bashrc.d/ps1

# Redefine bash-preexec's function that purges HISTCONTROL.  According to
# https://github.com/rcaloras/bash-preexec/issues/48, it's safe to do so.
__bp_adjust_histcontrol() { :; }

# Setup C-z to toggle fg/bg
preexec() { stty susp '^Z'; }
precmd() { stty susp undef; export PS1=$(update_ps1); }

on_ctrl_z() {
	[[ -z $(jobs) ]] && return
	fg
}
bind '"\C-z":"\C-u on_ctrl_z\n"'

export EDITOR=vim
export HISTCONTROL=ignorespace

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias pacman='pacman --color=auto'
