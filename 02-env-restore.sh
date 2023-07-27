#!/usr/bin/env zsh

# get scripts absolute directory path (compatible for symlink)
SCRIPT_PATH=$(dirname "$(readlink -f "$0")")

# include common functions
source $SCRIPT_PATH/common.sh

# load custom pre-restore scripts
trigger-phase-script "pre-restore"

echo "\n${BIWhite}Running environment restore${NC}"

# vim
copy-file $BACKUP_DIR_CLI/vimrc $HOME/.vimrc
copy-dir $BACKUP_DIR_CLI/vim/bundle/ $HOME/.vim/bundle/

# zshrc and oh-my-zsh
copy-file $BACKUP_DIR_CLI/zshrc $HOME/.zshrc
copy-dir $BACKUP_DIR_CLI/oh-my-zsh/ $HOME/.oh-my-zsh/
copy-dir $BACKUP_DIR_CLI/zfunc/ $HOME/.zfunc/
# backup zprofile for a reference, do not restore by default
# copy-file $BACKUP_DIR_CLI/zprofile $HOME/.zprofile 

# ssh
copy-dir $BACKUP_DIR_CLI/ssh/ $HOME/.ssh/

# gitconfig
copy-file $BACKUP_DIR_CLI/gitconfig $HOME/.gitconfig

# npmrc
copy-file $BACKUP_DIR_CLI/npmrc $HOME/.npmrc

# aws
copy-dir $BACKUP_DIR_CLI/aws/ $HOME/.aws/

# pip
copy-dir $BACKUP_DIR_CLI/config/pip/ $HOME/.config/pip/

# podman
copy-dir $BACKUP_DIR_CLI/config/containers/ $HOME/.config/containers/

# ossutil
copy-file $BACKUP_DIR_CLI/ossutilconfig $HOME/.ossutilconfig

# custom scripts 
copy-dir $BACKUP_ARCHIVE/custom-scripts/ $SCRIPT_PATH/custom-scripts/

# homebrew formula
if [[ $OS_TYPE == "MACOS" ]]; then
	if [[ -f $BACKUP_DIR_CLI/Brewfile ]]; then
		echo "\n${BIWhite}Restore homebrew formula${NC}"
		brew bundle --file $BACKUP_DIR_CLI/Brewfile
	fi
fi

# load custom post-restore scripts
trigger-phase-script "post-restore"
