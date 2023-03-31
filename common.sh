#!/usr/bin/env zsh

# get scripts absolute directory path
SCRIPT_PATH=$(cd `dirname $0` && pwd)
PROJECT_PATH=`dirname $SCRIPT_PATH`

# indent for stdout output format
LINE_INDENT="  "
# double the indent in sub scripts
SUB_SCRIPT_INDENT=$LINE_INDENT$LINE_INDENT

# get base backup directory
BACKUP_ARCHIVE=$PROJECT_PATH/archive
# get cli environment backup directory
BACKUP_DIR_CLI=$BACKUP_ARCHIVE/cli

# colorplate
Black='\033[0;30m'
Red='\033[0;31m'
Green='\033[0;32m'
BIGreen='\033[1;92m'
Yellow='\033[0;33m'
Blue='\033[0;34m'
Purple='\033[0;35m'
Cyan='\033[0;36m'
White='\033[0;37m'
BIWhite='\033[1;97m'
NC='\033[0m'


# check os type
check-os(){
	local OSNAME=$(uname -s | tr "[:lower:]" "[:upper:]")
	if [[ $OSNAME == DARWIN* ]]; then
		export OS_TYPE="MACOS"
	elif [[ $OSNAME == LINUX* ]]; then
		export OS_TYPE="LINUX"
		if [[ $(grep Microsoft /proc/version) ]]; then
        	export OS_TYPE="LINUX-WSL"
		fi
	else
		echo "Unsupported OS, exiting"
		exit 1
	fi
    unset OSNAME
}

# create directory if not exist already
ensure-dir(){
	if [[ ! -d ${1} ]]; then
		mkdir -p ${1}
	fi
}

# copy file and create parent directory if not exist
copy-file(){
	if [[ -f ${1} ]]; then
		ensure-dir `dirname ${2}`
		echo "${LINE_INDENT}${1} ${Blue}==>${NC} ${2}"
		cp ${1} ${2}
	fi
}

# sync directory and create parent directory if not exist
copy-dir(){
	if [[ -d ${1} ]]; then
		ensure-dir ${2}
		echo "${LINE_INDENT}${1} ${Blue}==>${NC} ${2}"
		rsync -a --delete ${1} ${2}
	fi
}

# stdout output with custom format and indent to be used in custom scripts
sub-echo(){
    local MSG_STR=$@
	local OPTION=()
	if [[ $# -gt 0 ]]; then
		for PARAM in "$@"
		do
			if [[ $PARAM = -* ]]; then
				OPTION+=($PARAM)
			else
				MSG_STR=$PARAM
			fi
		done
	fi
	echo $OPTION "${LINE_INDENT}${BIWhite}${PHASE_FILE_NAME}${NC}: $MSG_STR"	
}

# load custom phase scripts
trigger-phase-script(){
	local PHASE=${1}
	if [[ -d $SCRIPT_PATH/custom-scripts/ ]]; then
		local DIR_NAME=$SCRIPT_PATH/custom-scripts/$PHASE
		if [[ ! -z "$(ls -A $DIR_NAME | grep '\.sh$' )" ]]; then
			echo "\n${BIWhite}Running custom phase scripts${NC}: ${BIGreen}${PHASE}${NC}"
			for FILE in $DIR_NAME/*.sh; do
				PHASE_FILE_NAME=$(basename $FILE)
				echo "${LINE_INDENT}Executing ${Blue}==>${NC} $PHASE/$PHASE_FILE_NAME"
				# override echo command in sub directories
				alias echo=sub-echo
				source $FILE
				# unset alias for echo
				unalias echo
				echo ""
			done
		fi
	fi
}

check-os
ensure-dir $BACKUP_ARCHIVE
