#!/usr/bin/env bash

USR_BIN="$HOME/bin"
USR_ETC="$HOME/etc"
USR_TMP="$HOME/tmp"
USR_LOGS="$HOME/logs"

## 
function check_binary() {
  if ! which "$1" > /dev/null; then
    # Using a subshell to redirect output to stderr. It's cleaner this way and will play nice with other redirects.
    # https://stackoverflow.com/a/23550347/225905
    ( >&2 echo "$2" )
    # Exit with a nonzero code so that the caller knows the script failed.
    exit 1
  fi
}

## Setup the directories
function create_directories {
  mkdir -p "$USR_BIN" \
	   "$USR_ETC" \
	   "$USR_TMP" \
	   "$USR_LOGS"
}

function cprint {
  echo "$2"
}

function install_zsh {
  if ! which zsh > /dev/null; then
    cprint 0 "Need to install zsh"
    sudo apt install zsh -y
  else
    cprint 0 "zsh is alredy installed"
  fi
}

function change_to_zsh {
  current_shell=$(echo $SHELL | awk -F"/" '{print $NF}')
  if [[ "$current_shell" != "zsh" ]]; then
    cprint 0 "Changing to zsh"
    chsh -s $(which zsh)
    cprint 0 "Logout and log back in to take effect"
  else
    cprint 0 "Default zsh is set"
  fi
}

function install_vscode {
  if ! which code > /dev/null; then
    cprint 0 "Need to install vscode"
    [[ ! -f "${USR_TMP}/vscode.deb" ]] && wget -O "${USR_TMP}/vscode.deb" 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
    sudo dpkg -i "${USR_TMP}/vscode.deb"
  else
    cprint 0 "vscode is alredy installed"
  fi
}

function install_git {
  if ! which git > /dev/null; then
    cprint 0 "Need to install git"
    sudo apt-get install git-all -y 
  else
    cprint 0 "git is alredy installed"
  fi
}

function install_ohmyzsh {
  oh_my_zsh=$(set | grep -a ^ZSH= | grep -i oh-my-zsh)
  if [[ -z "$oh_my_zsh" ]]; then
    cprint 0 "Installing oh-my-zsh"
    sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
  else
    cprint 0 "oh my zsh is already installed"
  fi
}

function install_golang {
  if ! which go > /dev/null; then
    cprint 0 "Need to install golang"
    wget -O "${USR_TMP}/go1.20.5.linux-amd64.tar.gz" https://go.dev/dl/go1.20.5.linux-amd64.tar.gz
    sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf "${USR_TMP}/go1.20.5.linux-amd64.tar.gz"
    echo "PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.zshrc
  else
    cprint 0 "golang is alredy installed"
  fi
}

function install_fzf {
  if ! which fzf > /dev/null; then
    cprint 0 "Need to install fuzzy finder"
    sudo apt install fzf -y
    echo "source /usr/share/doc/fzf/examples/key-bindings.zsh" >> $HOME/.zshrc
    echo "source /usr/share/doc/fzf/examples/completion.zsh" >> $HOME/.zshrc
    cprint 0 "Close and open your shell again"
    exit 0
  else
    cprint 0 "fuzzyfinder is alredy installed"
  fi
}

function install_json_tools {
  if ! which fx > /dev/null; then
    cprint 0 "Need to install fx"
    go install github.com/antonmedv/fx@latest
  else
    cprint 0 "fx is alredy installed"
  fi
  if ! which jq > /dev/null; then
    cprint 0 "Need to install jq"
    sudo apt install jq -y
  else
    cprint 0 "jq is alredy installed"
  fi
}

function install_glow {
  if ! which glow > /dev/null; then
    cprint 0 "Need to install glow"
    go install github.com/charmbracelet/glow@latest
  else
    cprint 0 "glow is alredy installed"
  fi
}

function install_gum {
  if ! which gum > /dev/null; then
    cprint 0 "Need to install gum"
    go install github.com/charmbracelet/gum@latest
  else
    cprint 0 "gum is alredy installed"
  fi
}

function install_duf {
  if ! which duf > /dev/null; then
    cprint 0 "Need to install duf"
    go install github.com/muesli/duf@latest
  else
    cprint 0 "duf is alredy installed"
  fi
}

function install_curl {
  if ! which curl > /dev/null; then
    cprint 0 "Need to install curl"
    sudo apt install curl -y
  else
    cprint 0 "curl is alredy installed"
  fi
}

function install_starship {
  if ! which starship > /dev/null; then
    cprint 0 "Need to install starship"
    curl -sS https://starship.rs/install.sh | sh
    echo "eval \"$(starship init zsh)\"" >> $HOME/.zshrc
  else
    cprint 0 "starship is alredy installed"
  fi
}

create_directories
install_zsh
change_to_zsh
install_vscode
install_git
install_ohmyzsh
install_golang
install_fzf
install_json_tools
install_glow
install_gum
install_duf
install_curl
