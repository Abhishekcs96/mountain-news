#!/usr/bin/env bash

set -eu -o pipefail
#set -x

# TODO: Better logging
# TODO: Check if directories available or not and if the binaries are installed
# TODO: eg: if chmod exisits, if cp exists and if /usr/local/bin exists...

echo "Setting up..."
EXEC_PATH="$(sudo grealpath news 2>/dev/null || sudo realpath news 2>/dev/null || ( echo "realpath/grealpath commands not found..."; exit 1 ))"
EXECUTABLE="/usr/local/bin/news"

# Required binaries: pandoc

YES_PATTERN="^[yY]$"
NO_PATTERN="^[nN]$"

if 2>/dev/null hash pandoc; then
   echo "\"pandoc\" found..."
else
   read -p "\"pandoc\" not found...pandoc is required for the program. Would you like to install pandoc? [y/n]" -n 1 -r
   if [[ $REPLY =~ ${YES_PATTERN} ]]; then
       echo "yes"
      # install pandoc here  
   else
       # exit here if user denies
       echo "no"
       exit 1
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
