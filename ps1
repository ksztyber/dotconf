update_ps1() {
	local appid prefix ps1_template
	local cgrn='\[\e[92m\]' cgrey='\[\e[37m\]' cres='\[\e[0m\]'
	local col=${PS1_MAIN_COLOR:-$cgrn}

	ps1_template="${col}[${cres}\u${col}@${cres}\h \W${col}]${cres}\\$ "
	# The last job is stty, so truncate it
	for appid in $(jobs -p | head -n-1 | tac); do
		prefix+="${col}[${cgrey}$(strings -n1 /proc/$appid/cmdline | head -n1)${col}]${cres}"
	done

	echo "$prefix$ps1_template"
}

export PS1=$(update_ps1)
