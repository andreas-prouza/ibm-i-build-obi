#!/bin/bash 

# Import global config
source $(dirname $(realpath "$0"))/init.sh

if [ $USE_PYTHON == true ]; then
    "$OBI_PYTHON_PATH" "$OBI_DIR"/main.py -a create -p $WORKSPACE_FOLDER
else
    # Sync to IBM i
    source $(dirname $(realpath "$0"))/sync2ibmi.sh

    # Create the compile list and the markdown file
    echo "Create the compile list and the summary"
    ssh "$REMOTE_HOST" "source .profile; cd $REMOTE_WORKSPACE_FOLDER_NAME; $REMOTE_OBI_PYTHON_PATH $REMOTE_OBI_DIR/main.py -a create -p $REMOTE_WORKSPACE_FOLDER_NAME || true" >> $RUN_BUILD_LOG 2> $ERROR_OUTPUT
    [[ -s "$ERROR_OUTPUT" ]] &&  error_handler
    # Get all back to lokal
    source $(dirname $(realpath "$0"))/sync_back_from_ibmi.sh
fi

echo  "Open compile summary"
$EDITOR build-output/compiled-object-list.md

echo -e "$COLOR_GREEN \n finished creation of build script $COLOR_END"