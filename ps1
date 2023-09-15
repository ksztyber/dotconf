update_ps1() {
	local appid prefix ps1_template
	local cgrn='\[\e[92m\]' cgrey='\[\e[37m\]' cres='\[\e[0m\]'

	ps1_template="${cgrn}[${cres}\u${cgrn}@${cres}\h \W${cgrn}]${cres}\\$ "
	# The last job is stty, so truncate it
	for appid in $(jobs -p | head -n-1); do
		prefix+="${cgrn}[${cgrey}$(strings -n1 /proc/$appid/cmdline | head -n1)${cgrn}]${cres}"
	done

	echo "$prefix$ps1_template"
}

export PS1=$(update_ps1)
