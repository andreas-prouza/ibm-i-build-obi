#!/bin/bash 

# Import global config
source $(dirname $(realpath "$0"))/init.sh


if [ $USE_PYTHON == true ]; then

    # Create the compile list and the markdown file
    "$OBI_PYTHON_PATH" "$OBI_DIR"/main.py -a create -p $WORKSPACE_FOLDER
    # Sync to IBM i
    source $(dirname $(realpath "$0"))/sync2ibmi.sh

else

    # Sync to IBM i
    source $(dirname $(realpath "$0"))/sync2ibmi.sh

    # Create the compile list and the markdown file
    echo "Create the compile list and the summary"
    ssh "$REMOTE_HOST" "source .profile; cd $REMOTE_WORKSPACE_FOLDER_NAME; $REMOTE_OBI_PYTHON_PATH $REMOTE_OBI_DIR/main.py -a create -p $REMOTE_WORKSPACE_FOLDER_NAME || true" >> $RUN_BUILD_LOG 2>> $ERROR_OUTPUT
    [[ -s "$ERROR_OUTPUT" ]] &&  error_handler
    # Get all back to lokal
    source $(dirname $(realpath "$0"))/sync_back_from_ibmi.sh

fi

echo  "Open compile summary"
$EDITOR build-output/compiled-object-list.md

echo "Run compile commands ..."
ssh "$REMOTE_HOST" "source .profile; cd $REMOTE_WORKSPACE_FOLDER_NAME; $REMOTE_OBI_PYTHON_PATH $REMOTE_OBI_DIR/main.py -a run -p $REMOTE_WORKSPACE_FOLDER_NAME || true" >> $RUN_BUILD_LOG 2>> $TEMP_DIR/RUN_BUILD_LOG.log
source $(dirname $(realpath "$0"))/sync_back_from_ibmi.sh

# Open the markdown file
# Should not be necessary, because of auto-refresh of the opened file
#$EDITOR build-output/compiled-object-list.md

mv $TEMP_DIR/RUN_BUILD_LOG.log $ERROR_OUTPUT
[[ -s "$ERROR_OUTPUT" ]] &&  error_handler


echo -e "$COLOR_GREEN finished build $COLOR_END"