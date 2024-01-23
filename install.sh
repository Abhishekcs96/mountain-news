#!/usr/bin/env bash

set -eu -o pipefail
#set -x

# TODO: Better logging
# TODO: Check if directories available or not and if the binaries are installed
# Required binaries: pandoc

echo "Setting up..."
EXEC_PATH="$(sudo grealpath news 2>/dev/null || sudo realpath news 2>/dev/null || ( echo "realpath/grealpath commands not found..."; exit 1 ))"
EXECUTABLE="/usr/local/bin/news"
YES_PATTERN="^[yY]$"
NO_PATTERN="^[nN]$"


if [[ "$(command -v pandoc)" ]]; then
   echo "\"pandoc\" found. Continuing..."
else
   read -p "\"pandoc\" not found...pandoc is required for the program. Would you like to install pandoc? [y/n]" -n 1 -r
   if [[ $REPLY =~ ${YES_PATTERN} ]]; then
       echo "Installing pandoc..."
       # check package manager. -x will check if the file path returned by command exists and is executable.
       if [[ -x "$(command -v apt)" ]]; then sudo apt install -y pandoc
       elif [[ -x "$(command -v dnf)" ]]; then sudo dnf install -y pandoc
       elif [[ -x "$(command -v yum)" ]]; then sudo yum install -y pandoc 
       elif [[ -x "$(command -v pacman)" ]]; then sudo pacman install -y pandoc
       elif [[ -x "$(command -v zypper)" ]]; then sudo zypper install -y pandoc
       else
           >&2 echo "unable to find correct package manager to install... please manually install \"pandoc\""
       fi 
   else
       echo "Not installing \"pandoc\". \"Pandoc\" is needed for script to run."
   fi
fi

if [[ -d "${EXECUTABLE%/*}" ]]; then
    echo "Directory ${EXECUTABLE%/*} found..."
    sudo ln -s "${EXEC_PATH}" "${EXECUTABLE}"
else
    >&2 echo "Directory \"/usr/local/bin\" not found"
    exit 1
fi

if [[ $? ]]; then
    echo "Setup complete..."
    echo "Type in \"news\" and see what happens..."
    exit 0
else
    >&2 echo "setup not complete, error encountered..."
    exit 1
fi
