#!/bin/bash 

# Import global config
source $(dirname $(realpath "$0"))/init.sh


if [ $USE_PYTHON == true ]; then

    echo -e "$COLOR_CYAN_BOLD`date +"%F %T.%3N"` Generate object list $COLOR_END" $1
    "$OBI_PYTHON_PATH" -X utf8 "$OBI_DIR_PYTHON"/main.py -a gen_obj_list -p $WORKSPACE_FOLDER

else

    source $(dirname $(realpath "$0"))/sync2ibmi.sh

    echo -e "$COLOR_CYAN_BOLD`date +"%F %T.%3N"` Generate object list on IBM i $COLOR_END" $1
    echo -e "$COLOR_CYAN_BOLD`date +"%F %T.%3N"` (This can take longer than if it is executed to be locally.) $COLOR_END" $1
    ssh "$REMOTE_HOST" "source .profile; cd $REMOTE_WORKSPACE_FOLDER_NAME; $REMOTE_OBI_PYTHON_PATH -X utf8 $REMOTE_OBI_DIR/main.py -a gen_obj_list -p $REMOTE_WORKSPACE_FOLDER_NAME || true" >> $RUN_BUILD_LOG 2>> $ERROR_OUTPUT

    [[ -s "$ERROR_OUTPUT" ]] &&  error_handler
    # Get all back to lokal
    source $(dirname $(realpath "$0"))/sync_back_from_ibmi.sh

fi


echo -e "$COLOR_GREEN`date +"%F %T.%3N"`  finished generation $COLOR_END"