#!/usr/bin/env zsh

# get scripts absolute directory path
SCRIPT_PATH=$(cd `dirname $0` && pwd)

# include common functions
source $SCRIPT_PATH/common.sh

# homebrew formula
if [[ $OS_TYPE == "MACOS" ]]; then
	# install homebrew
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	# install brew bundle
	brew tap Homebrew/bundle
	# install open-source tools
	mkdir -p $HOME/Documents/Tools
	# install one-key-hidpi script
	git clone https://github.com/xzhih/one-key-hidpi.git $HOME/Documents/Tools/one-key-hidpi
fi

# install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash