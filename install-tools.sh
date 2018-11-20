#!/bin/bash

echo "Run install tools"
sleep 1
echo "Updating repositories.."

comprobate_gpl(){
    local return_=1
    which $1 >/dev/null 2>&1 || { local return_=0; }
    echo "$return_"
}

yum=$(comprobate_gpl "yum")
apt=$(comprobate_gpl "apt")
if [ $apt -eq "1" ]; then
    sudo apt update
  elif [ $yum -eq "1" ]; then
    sudo yum update
fi

tools_requirements=(git sed make wget curl)
tools_to_install=(vim tmux htop nmap screen i3lock-fancy glances zsh);
plugins_zsh=(git docker npm python sudo systemd web-search)


function echo_fail {
  # echo first argument in red
  printf "\e[31m✘ ${1} No Installed"
  # reset colours back to normal
  printf "\033[0m \n"
}

# display a message in green with a tick by it
# example
# echo echo_fail "Yes"
function echo_pass {
  # echo first argument in green
  printf "\e[32m✔ ${1} Installed"
  # reset colours back to normal
  printf "\033[0m \n"
}

check_tool_and_install(){
    if type "$1" &>/dev/null; then
        echo_pass $1
    else
        echo_fail $1
        if [  $apt -eq "1" ]; then
            sudo apt install $1 -y
          elif [  $yum -eq "1" ]; then
            sudo yum install $1 -y
        fi
        if [ "$1" = "zsh" ]; then
            install_oh_my_zsh
        elif [ "$1" = "i3lock-fancy" ]; then
            install_lock
        fi
    fi
}

install_lock(){
    if type git &>/dev/null; then
        git clone https://github.com/meskarune/i3lock-fancy.git
        cd i3lock-fancy/
        sudo make install
        cd ..
        rm -rf i3lock-fancy/
    else
        wget https://github.com/meskarune/i3lock-fancy/archive/master.zip
        unzip master.zip
        cd i3lock-fancy-master
        sudo make install
        cd ..
        rm -rf i3lock-fancy/
        rm -rf master.zip
    fi
}

install_oh_my_zsh(){
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    #add default plugins to zsh
    add_plugins_oh_my_zsh
    #changing to zsh
    source ~/.zshrc | zsh
}

add_plugins_oh_my_zsh(){
    echo "Config plugins of oh my zsh"
    for name in ${plugins_zsh[*]}
    do
        name_plugins+=" \n\t"$name
    done
    echo $name_plugins
    ruta=~/"/.zshrcs"
    sed -i "s/  git/  $name_plugins/g" "$ruta"
}


install_requirements(){
    echo "Install Requirements"
    for tool in ${tools_requirements[*]}
    do
        check_tool_and_install $tool
    done
}


install_requirements

echo "Total tools: ${#tools_to_install[@]}";

for tool in ${tools_to_install[*]}
do
    check_tool_and_install $tool
done
