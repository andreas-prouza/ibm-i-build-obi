#!/bin/bash 

#set -x
git pull


check_untracked_files () {

  changed_files=$(git status -u --porcelain)

  if [ "$changed_files" != '' ]; then
    echo -e "$COLOR_RED There are untracked changes. Please save (commit) them first! $COLOR_END\n"
    echo -e "$COLOR_YELLOW$changed_files $COLOR_END"
    exit 1
  fi

}

git_checkout_release_branch () {

  git show-ref --quiet refs/heads/$1

  if [ $? -gt 1 ]; then
    echo -e "$COLOR_RED Error $? when verify branch $1 $COLOR_END\n"
    exit $?
  fi
  if [ $? == 1 ]; then
    echo -e "$COLOR_RED Branch $1 does already exist $COLOR_END\n"
    exit $?
  fi

  echo "Create new branch $1 with commit $2"
  git checkout -b $1 $2
  git push --set-upstream origin $1

}


check_object_list () {

  if [ ! -s "${COMPILE_OBJECT_LIST}" ]; then
    echo -e "\n\n$COLOR_RED No objects available to compile $COLOR_END\n"
    exit 1
  fi

}

# Import global config
source $(dirname $(realpath "$0"))/init.sh


check_untracked_files



# Undo changes
# git restore -s@ -SW -- build

# get current commit-hash
current_branch=`git rev-parse --abbrev-ref HEAD`
current_commit=`git rev-parse HEAD`

# Index all untracked files (so they become visible in "git diff")
#git add -N -A

#changed_files=$(git diff --name-status)

#if [ "$changed_files" != '' ]; then

#  echo -e "$COLOR_RED Untracked files exist!! $COLOR_END"
#  echo -e "$COLOR_CYAN_BOLD $changed_files $COLOR_END"
#  echo -e "$COLOR_RED Please commit them first $COLOR_END"
  #!!!!!!!!!!!!exit 1

#fi

# Save all uncommited files
# Not necessary anymore, because all is commited
#git stash clear
#git stash --include-untracked

#git pull

# Get version from another branch
#git checkout remotes/origin/production -- build

git checkout $DEPLOYMENT_UAT_MAIN_BRANCH

git pull



#-----------------------------------------
# Create compile script
#-----------------------------------------
scripts/cleanup.sh
source $(dirname $(realpath "$0"))/get-prod-object-timestamp.sh

echo "Exit: $?"
echo "Create object and compile list"
scripts/create_build_script.sh

check_object_list


#-----------------------------------------
# First create a new deployment
#-----------------------------------------
echo -e "$COLOR_GREEN current_commit: $current_commit $COLOR_END"

url=$DEPLOYMENT_UAT_URL/api/create_deployment/$DEPLOYMENT_UAT_WORKFLOW/$current_commit?auth-token=$DEPLOYMENT_AUTH_TOKEN
echo "URL: $url" >> $STD_OUTPUT

response=$(curl $url)
echo $response >> $STD_OUTPUT

#error=$(jq -r '.Error' <<< $response 2> $ERROR_OUTPUT)
status=$(jq -r '.status' <<< $response 2> $ERROR_OUTPUT)
error=$(jq -r '.error' <<< $response 2> $ERROR_OUTPUT)
if [[ "$status" == 'error' ]]; then
  echo -e "$COLOR_RED $response $COLOR_END"
  error_handler
  #echo -e "$COLOR_RED $ERROR_OUTPUT $COLOR_END"
fi

if [[ "$error" != null ]]; then
  echo -e "$COLOR_RED $error $COLOR_END"
  git checkout $current_branch
  exit 1
fi

new_release=$(jq -r '.meta_file.general.release_branch' <<< $response)
deployment_version=$(jq -r '.meta_file.general.deploy_version' <<< $response)
project=$(jq -r '.meta_file.general.project' <<< $response)
file_name=$(jq -r '.meta_file.general.file_name' <<< $response)

echo -e "$COLOR_GREEN Created new deployment $COLOR_END"
echo -e "$COLOR_GREEN Workflow: $DEPLOYMENT_UAT_WORKFLOW $COLOR_END"
echo -e "$COLOR_GREEN Version: $deployment_version $COLOR_END"
echo -e "$COLOR_GREEN Commit: $current_commit $COLOR_END"
echo -e "$COLOR_GREEN New branch: $new_release $COLOR_END"
echo -e "$COLOR_GREEN $DEPLOYMENT_UAT_URL/show_details/$project/$deployment_version $COLOR_END"

#-----------------------------------------
# Create a release branch based on current commit for that deplyoment
#-----------------------------------------

git_checkout_release_branch $new_release $current_commit


echo "Get commit hash of release branch"
new_release_commit=$(git show-ref --verify refs/heads/$new_release | cut -d " " -f1)

echo "Check if commit hash ist the same"
if [ "$new_release_commit" != "$current_commit" ]; then
  echo -e "$COLOR_RED Commit of branch $new_release ($new_release_commit) does not match current commit ($current_commit) $COLOR_END"
  git checkout $current_branch
  #git stash pop
  exit 1
fi


# git add -A; git commit -m "Object list & build script created"; git push --set-upstream origin $new_release


#-----------------------------------------
# Open deplyoment
#-----------------------------------------


$OS_CMD_2_OPEN_URL $DEPLOYMENT_UAT_URL/show_details/$project/$deployment_version

#-----------------------------------------
# Restore workspace
#-----------------------------------------

echo "Restore workspace"

# Get uncommited files back
git checkout $current_branch
#git stash pop || true


echo -e "$COLOR_GREEN Created new deployment $COLOR_END"
echo -e "$COLOR_GREEN Workflow: $DEPLOYMENT_UAT_WORKFLOW $COLOR_END"
echo -e "$COLOR_GREEN Version: $deployment_version $COLOR_END"
echo -e "$COLOR_GREEN Commit: $current_commit $COLOR_END"
echo -e "$COLOR_GREEN New branch: $new_release $COLOR_END"
echo -e "$COLOR_GREEN $DEPLOYMENT_UAT_URL/show_details/$project/$deployment_version $COLOR_END"
