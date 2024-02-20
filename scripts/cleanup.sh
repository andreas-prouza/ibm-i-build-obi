#!/bin/bash 

SCRIPT_VARS=/tmp/script-variables.txt
SCRIPT_VARS2=/tmp/script-variables2.txt
( set -o posix ; set ) > $SCRIPT_VARS


# Only to clean up the output file
source etc/global.cfg
echo '' > $STD_OUTPUT_TMP


# Print all script variables
( set -o posix ; set ) > $SCRIPT_VARS2
diff $SCRIPT_VARS $SCRIPT_VARS2 >> $STD_OUTPUT_TMP || true
#diff $SCRIPT_VARS $SCRIPT_VARS2 2>$ERROR_OUTPUT

echo WORKSPACE_FOLDER $WORKSPACE_FOLDER


mkdir -p $WORKSPACE_FOLDER/log
mkdir -p $WORKSPACE_FOLDER/build

find $WORKSPACE_FOLDER/log -maxdepth 2 -type f -delete
rm -rf $WORKSPACE_FOLDER/log/**/**/* || true 2>/dev/null
rm -rf $WORKSPACE_FOLDER/tmp/* || true 2>/dev/null

mkdir -p $WORKSPACE_FOLDER/tmp/log

cat $STD_OUTPUT_TMP >> $STD_OUTPUT

# Import global config
source $(dirname $(realpath "$0"))/init.sh 0
