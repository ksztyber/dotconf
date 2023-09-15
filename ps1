update_ps1() {
	local appid prefix ps1_template

	ps1_template='\e[92m[\e[0m\u\e[92m@\e[0m\h \W\e[92m]\e[0m\$ '
	# The last job is stty, so truncate it
	for appid in $(jobs -p | head -n-1); do
		prefix+="\e[92m[\e[37m$(strings -n1 /proc/$appid/cmdline | head -n1)\e[92m]\e[0m"
	done

	echo "$prefix$ps1_template"
}

export PS1=$(update_ps1)
