#!/bin/bash

echo "Run install tools"
sleep 1
echo "Updating repositories.."
sudo apt update

tools_to_install=(git vim tmux htop sed zsh glances nmap screen i3lock-fancy);
#tools_to_install=(zsh);
plugins_zsh=(git docker npm python sudo systemd web-search)

echo "Total tools: ${#tools_to_install[@]}";

function echo_fail {
  # echo first argument in red
  echo "\e[31m✘ ${1} No Installed"
  # reset colours back to normal
  echo -e "\033[0m \n"
}

# display a message in green with a tick by it
# example
# echo echo_fail "Yes"
function echo_pass {
  # echo first argument in green
  echo "\e[32m✔ ${1} Installed"
  # reset colours back to normal
  echo -e "\033[0m \n"
}

check_tool(){
    if type "$1" &>/dev/null; then
        echo_pass $1
    else
        echo_fail $1
        sudo apt install $1 -y
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
    source ~/.zshrc
    add_plugins_oh_my_zsh
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

for tool in ${tools_to_install[*]}
do
    check_tool $tool
done
