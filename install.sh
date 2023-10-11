#!/usr/bin/env bash

# TODO: Better logging
# TODO: Check if directories available or not and if the binaries are installed
# TODO: eg: if chmod exisits, if cp exists and if /usr/local/bin exists...
echo "Setting up..."
sudo cp ./news /usr/local/bin/ 
sudo chmod +x /usr/local/bin/news
if [[ $? ]]; then
    echo "Setup complete..."
    echo "Type in \"news\" and see what happens..."
else
    1>&2 echo "setup not complete, error encountered..."
fi
