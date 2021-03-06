# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory autocd extendedglob
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/konrad/.zshrc'

autoload -Uz compinit
autoload -U colors
compinit
colors
# End of lines added by compinstall
alias pacman='pacman --color=auto'
alias sudo='sudo '
alias grep='grep --color=auto'
alias tmux='tmux -2'
alias ls='ls --color=auto'
alias l='ls'
alias ll='ls -l'
alias gitl='git log --pretty=oneline --abbrev-commit'
alias sl='ls --color=auto'
alias ackcc='ack --cc --hh --cpp'
alias ackc='ack --cc --hh --cpp'
alias ackh='ack --hh'
alias rmswp='find . -iname "*.sw[a-z]" -exec rm {} \;'

# Use vim with X support when available
vimx --version &>/dev/null && alias vim='vimx'

#alias gcc='gcc -fdiagnostics-color=auto'
#alias g++='g++ -fdiagnostics-color=auto'

xset r rate 200 35

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export PATH=~/bin:$PATH
export PYTHONPATH=$PYTHONPATH:~/bin
export EDITOR=vim
export PYTHONSTARTUP=~/.config/python.startup
# in case full paths are used for gcc/g++
#export CFLAGS='-fdiagnostics-color=auto'
#export CXXFLAGS='-fdiagnostics-color=auto'
# Needed for vim's powerline
#export PYTHONPATH=/usr/lib/python3.4/site-packages

typeset -A key
key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}
# setup key accordingly
[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   beginning-of-buffer-or-history
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" end-of-buffer-or-history

bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word

# # Finally, make sure the terminal is in application mode, when zle is
# # active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
 function zle-line-init () {
     printf '%s' "${terminfo[smkx]}"
 }
function zle-line-finish () {
    printf '%s' "${terminfo[rmkx]}"
}

function vims() {
	sessions=$HOME/.vim/sessions
	if [[ "$1" = "-l" ]]; then
		for s in $(ls $sessions); do
			print $s;
		done
		return 0
	fi

	if [[ "$1" = "-r" ]]; then
		if [[ ! -f $sessions/$2 ]]; then
			echo "No session named '$2'"
			return 1
		fi

		rm $sessions/$2
		return
	fi

	if [[ ! -f $sessions/$1 ]];
	then
		echo "No session named '$1'"
		return 1
	fi

	vim -S $sessions/$1
}

zle -N zle-line-init
zle -N zle-line-finish
fi

# Unset bracketed paste
unset zle_bracketed_paste

_PS1="%F{green}[%f%n%F{green}@%f%m %1~%1 %F{green}]%f$ "
PS1=$_PS1

# prompt set up
reset_prompt() {
    background=
    ps_jobs=
    background_color='blue'
    #PS1="[%n@%m %1~]%(#.#.$) "
    PS1=$_PS1

    [[ -n "$(ps $PPID | awk '{ print $5 }' | grep mc)" ]] && background+=$'mc\n'
    [[ -n "$(jobs | grep -E 'suspended *vim')"         ]] && background+=$'vim\n'

    while read -r ent; do
        if [ -n "$ent" ]; then
            #ps_jobs+="[%{$fg_bold[red]%}$ent%{$reset_color%}]"
            ps_jobs+="%F{green}[%f$ent%F{green}]%f"
        fi
    done <<< $background

    [[ -n "$ps_jobs" ]] && PS1="$ps_jobs$PS1"
}

# ctrl-z handling
on_ctrl_z () {
    if [[ $#BUFFER -eq 0 ]]; then
        fg
        zle redisplay
    else
        zle push-input
        reset_prompt
    fi
}

zle     -N   on_ctrl_z
bindkey '^Z' on_ctrl_z

# hook functions
precmd() {
    reset_prompt
}

if [ -f ~/.config/zsh.conf ]; then
    source ~/.config/zsh.conf
fi

[ "$TERM" != "screen-256color" ] && tmux && exit
