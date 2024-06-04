#!/bin/bash 

# Import global config
source $(dirname $(realpath "$0"))/init.sh

# Undo changes
# git restore -s@ -SW -- build

# Get version from another branch
git checkout remotes/origin/production -- etc/object-builds.toml


echo -e "$COLOR_GREEN finished clean up of: \n`ls -d $WORKSPACE_FOLDER/etc/object-builds.toml` $COLOR_END"