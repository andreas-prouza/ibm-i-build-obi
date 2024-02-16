#!/bin/bash 

# Import global config
source $(dirname $(realpath "$0"))/init.sh

obi/venv/bin/python obi/main.py -a open_result -p $WORKSPACE_FOLDER

echo -e "$COLOR_GREEN \n finished creation of build script $COLOR_END"