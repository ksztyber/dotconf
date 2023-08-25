# bash-preexec is installed alongside bashrc
. ~/.bashrc.d/bash-preexec.sh

# Setup C-z to toggle fg/bg
preexec() { stty susp '^Z'; }
precmd() { stty susp undef; }
on_ctrl_z() {
	[[ -z $(jobs) ]] && return
	fg
}
bind '"\C-z":"\C-uon_ctrl_z\n"'

EDITOR=vim
