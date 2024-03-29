#!/bin/bash 

# Import global config
source $(dirname $(realpath "$0"))/init.sh 0

REMOTE_WORKSPACE_FOLDER_NAME=' /  '
#REMOTE_WORKSPACE_FOLDER_NAME=${REMOTE_WORKSPACE_FOLDER_NAME%%*( )}
REMOTE_WORKSPACE_FOLDER_NAME="${REMOTE_WORKSPACE_FOLDER_NAME#"${REMOTE_WORKSPACE_FOLDER_NAME%%[![:space:]]*}"}"
REMOTE_WORKSPACE_FOLDER_NAME="${REMOTE_WORKSPACE_FOLDER_NAME%"${REMOTE_WORKSPACE_FOLDER_NAME##*[![:space:]]}"}"

if [ "$REMOTE_WORKSPACE_FOLDER_NAME" = "" ] || [ "$REMOTE_WORKSPACE_FOLDER_NAME" = "/" ] || [ "$REMOTE_WORKSPACE_FOLDER_NAME" == "." ]
then
  echo "Remote workspace folder '$REMOTE_WORKSPACE_FOLDER_NAME' is not allowed!" > $ERROR_OUTPUT
  error_handler
  exit -1
fi


echo "End $REMOTE_WORKSPACE_FOLDER_NAME"

