#!/bin/bash 


sync_back_from_ibmi(){

  echo -e "$COLOR_CYAN_BOLD`date +"%F %T.%3N"` Sync back from IBM i $COLOR_END" $1

  # Import global config
  source $(dirname $(realpath "$0"))/init.sh 0

  #set -o xtrace

  rsync -chavz --exclude='__pycache__/' --include={'logs/***','log/***','build-output/***','etc/***'} --exclude='*'  $REMOTE_HOST:$REMOTE_WORKSPACE_FOLDER_NAME/  $WORKSPACE_FOLDER_RSYNC/  2>> $ERROR_OUTPUT  >$TEMP_DIR/SYNC_BACK_LOG.log
  [[ -s "$ERROR_OUTPUT" ]] &&  error_handler

  mv $TEMP_DIR/SYNC_BACK_LOG.log $SYNC_BACK_LOG  2>> $ERROR_OUTPUT  
  [[ -s "$ERROR_OUTPUT" ]] &&  error_handler


  if [ $MODE == 'debug' ]
  then
    cat $SYNC_BACK_LOG
  fi

  echo -e "$COLOR_GREEN finished sync back logs and build files $COLOR_END"

}


if [ $CLIENT_TYPE == 'CLIENT' ]
then
  sync_back_from_ibmi
fi