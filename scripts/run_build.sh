#!/bin/bash 

# Import global config
source $(dirname $(realpath "$0"))/init.sh


if [ $USE_PYTHON == true ]; then

    echo -e "$COLOR_CYAN_BOLD`date +"%F %T.%3N"` Create the compile list and the markdown file $COLOR_END" $1
    "$OBI_PYTHON_PATH" -X utf8 "$OBI_DIR_PYTHON"/main.py -a create -p $WORKSPACE_FOLDER

    source $(dirname $(realpath "$0"))/sync2ibmi.sh

else

    source $(dirname $(realpath "$0"))/sync2ibmi.sh

    echo -e "$COLOR_CYAN_BOLD`date +"%F %T.%3N"` Create the compile list and summary document on IBM i $COLOR_END" $1
    echo -e "$COLOR_CYAN_BOLD`date +"%F %T.%3N"` (This can take longer than if it is executed locally.) $COLOR_END" $1
    ssh "$REMOTE_HOST" "source .profile; cd $REMOTE_WORKSPACE_FOLDER_NAME; $REMOTE_OBI_PYTHON_PATH -X utf8 $REMOTE_OBI_DIR/main.py -a create -p $REMOTE_WORKSPACE_FOLDER_NAME || true" >> $RUN_BUILD_LOG 2>> $ERROR_OUTPUT

    [[ -s "$ERROR_OUTPUT" ]] &&  error_handler
    # Get all back to lokal
    source $(dirname $(realpath "$0"))/sync_back_from_ibmi.sh

fi

echo  "Open compile summary"
$EDITOR build-output/compiled-object-list.md

echo -e "$COLOR_CYAN_BOLD`date +"%F %T.%3N"` Run compile commands ... $COLOR_END" $1
ssh "$REMOTE_HOST" "source .profile; cd $REMOTE_WORKSPACE_FOLDER_NAME; $REMOTE_OBI_PYTHON_PATH -X utf8 $REMOTE_OBI_DIR/main.py -a run -p $REMOTE_WORKSPACE_FOLDER_NAME || true" >> $RUN_BUILD_LOG 2>> $TEMP_DIR/RUN_BUILD_LOG.log
source $(dirname $(realpath "$0"))/sync_back_from_ibmi.sh

# Open the markdown file
# Should not be necessary, because of auto-refresh of the opened file
#$EDITOR build-output/compiled-object-list.md

mv $TEMP_DIR/RUN_BUILD_LOG.log $ERROR_OUTPUT
[[ -s "$ERROR_OUTPUT" ]] &&  error_handler


echo -e "$COLOR_GREEN`date +"%F %T.%3N"`  finished build $COLOR_END"