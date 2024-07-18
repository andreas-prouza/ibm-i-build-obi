#!/bin/bash 

# Import global config
source $(dirname $(realpath "$0"))/init.sh

# Undo changes
# git restore -s@ -SW -- build

# Get version from another branch
git checkout remotes/origin/production -- etc/object-builds.toml

if [ $? != 0 ]; then
  echo -e "$COLOR_RED Coudln't retrieve object timestamp from production branch. $COLOR_END\n"
  exit $?
fi


echo -e "$COLOR_GREEN finished clean up of: \n`ls -d $WORKSPACE_FOLDER/etc/object-builds.toml` $COLOR_END\n"