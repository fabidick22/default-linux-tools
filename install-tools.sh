#!/bin/bash
echo "Run install tools"
sleep 2
tools_to_install=(tmux htop zsh);
#plugins=(git docker npm python sudo systemd web-search)
echo "Total tools: ${#array[*]}";

check_tool(){
	if [ $1 ]; then
	    echo "installed";
	else
	    echo "no installed"
	fi
}

for tool in ${tools_to_install[*]}
do
    check_tool $tool
done

#check_tool "tmux"
#echo "Array size: ${#array[*]}"
#sh -c `$1`
