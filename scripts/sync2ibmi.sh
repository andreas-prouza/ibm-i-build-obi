#!/bin/bash 

if [ $CLIENT_TYPE == 'SERVER' ]
then
  exit 0
fi


echo -e "$COLOR_CYAN_BOLD`date +"%F %T.%3N"` Sync to IBM i $COLOR_END" $1

# Import global config
source $(dirname $(realpath "$0"))/init.sh 0


if [ $MODE == 'debug' ]
then

  echo "MODE: $MODE"
  echo "SYNC2REMOTE_LOG: $SYNC2REMOTE_LOG"

fi

#rsync -adv   --exclude={'.git','.vscode','.project','.gitignore','/bin*','/boot','/dev','/home','/lib*','/media','/mnt','/opt','/proc','/temp','/root','/run','/sbin','/sys','/srv','/usr','/var','/Q*','/www'} \
#  --delete $WORKSPACE_FOLDER/ $REMOTE_HOST:$REMOTE_WORKSPACE_FOLDER_NAME/  > $TEMP_DIR/SYNC2REMOTE_LOG.log  2> $ERROR_OUTPUT
rsync -av --include='etc/' --include={'*.toml','*.py','*.cfg'} --include={'log/***','build*/***','src/***','scripts/***','tmp/***'} --exclude '*'  \
  --delete $WORKSPACE_FOLDER_RSYNC/ $REMOTE_HOST:$REMOTE_WORKSPACE_FOLDER_NAME/  > $TEMP_DIR/SYNC2REMOTE_LOG.log  2>> $ERROR_OUTPUT
[[ -s "$ERROR_OUTPUT" ]] &&  error_handler

mv $TEMP_DIR/SYNC2REMOTE_LOG.log "$SYNC2REMOTE_LOG"  2>> $ERROR_OUTPUT  
[[ -s "$ERROR_OUTPUT" ]] &&  error_handler

if [ $MODE == 'debug' ]
then
  cat $SYNC2REMOTE_LOG
fi


echo -e "$COLOR_GREEN finished sync to $REMOTE_HOST $COLOR_END"