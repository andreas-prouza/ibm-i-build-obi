#!/bin/bash 

# Import global config
source $(dirname $(realpath "$0"))/init.sh

if [ $USE_PYTHON == true ]; then
    "$OBI_PYTHON_PATH" "$OBI_DIR"/main.py -a open_result -p $WORKSPACE_FOLDER
fi

echo -e "$COLOR_GREEN \n finished creation of build script $COLOR_END"