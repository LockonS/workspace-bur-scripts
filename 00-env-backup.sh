#!/usr/bin/env zsh

# get scripts absolute directory path (compatible for symlink)
SCRIPT_PATH=$(dirname "$(readlink -f "$0")")

# include common functions
source $SCRIPT_PATH/common.sh

# load custom pre-backup scripts
trigger-phase-script "pre-backup"

echo "\n${BIWhite}Running environment backup${NC}"

# vim
copy-file $HOME/.vimrc $BACKUP_DIR_CLI/vimrc
copy-dir $HOME/.vim/bundle/ $BACKUP_DIR_CLI/vim/bundle/

# zshrc and oh-my-zsh
copy-file $HOME/.zshrc $BACKUP_DIR_CLI/zshrc
copy-dir $HOME/.oh-my-zsh/ $BACKUP_DIR_CLI/oh-my-zsh/
# backup zprofile for a reference, do not restore by default
copy-file $HOME/.zprofile $BACKUP_DIR_CLI/zprofile

# ssh
copy-dir $HOME/.ssh/ $BACKUP_DIR_CLI/ssh/

# gitconfig
copy-file $HOME/.gitconfig $BACKUP_DIR_CLI/gitconfig

# aws
copy-dir $HOME/.aws/ $BACKUP_DIR_CLI/aws/

# ossutil
copy-file $HOME/.ossutilconfig $BACKUP_DIR_CLI/ossutilconfig

# custom scripts 
copy-dir $SCRIPT_PATH/custom-scripts/ $BACKUP_ARCHIVE/custom-scripts/

# homebrew formula
if [[ $OS_TYPE == "MACOS" ]]; then
	echo "\n${BIWhite}Backup homebrew formula${NC}"
	brew bundle dump
	copy-file Brewfile $BACKUP_DIR_CLI/Brewfile
	rm Brewfile
fi

# load custom post-backup scripts
trigger-phase-script "post-backup"