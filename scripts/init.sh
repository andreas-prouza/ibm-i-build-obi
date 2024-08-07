
#set +o xtrace
#trap - DEBUG

MODE=$1 # debug, ...

# Import global config
source etc/global.cfg

ERROR=

error_handler() {
  sleep 0 # Only to get stdout first printed and errors at the end of the console
  set +x
  echo -e "$COLOR_RED Error occured! $COLOR_END\n"
  ERROR=$(<$ERROR_OUTPUT)
  echo -e "$COLOR_RED $ERROR $COLOR_END\n"
  exit 1
}
print_debug() { 
  echo "#DEBUG-$SCRIPT: "$BASH_COMMAND >> $STD_OUTPUT
}
#on_exit() {
#  cat $STD_OUTPUT_TMP >> $STD_OUTPUT 2>/dev/null
#  echo '' > $STD_OUTPUT_TMP
#}

#trap 'on_exit' EXIT
#trap 'error_handler' ERR

# Remove trim leading & trailing blanks
REMOTE_WORKSPACE_FOLDER_NAME="${REMOTE_WORKSPACE_FOLDER_NAME#"${REMOTE_WORKSPACE_FOLDER_NAME%%[![:space:]]*}"}"
REMOTE_WORKSPACE_FOLDER_NAME="${REMOTE_WORKSPACE_FOLDER_NAME%"${REMOTE_WORKSPACE_FOLDER_NAME##*[![:space:]]}"}"

# Check if a correct remote path is set
if [ "$REMOTE_WORKSPACE_FOLDER_NAME" = "" ] || [ "$REMOTE_WORKSPACE_FOLDER_NAME" = "/" ] || [ "$WORKSPACE_FOLDER" = "C:\\" ] || [ "$REMOTE_WORKSPACE_FOLDER_NAME" == "." ] || [ "$REMOTE_WORKSPACE_FOLDER_NAME" == "~" ] || [ "$REMOTE_WORKSPACE_FOLDER_NAME" == "~/" ]
then
  echo "Remote workspace folder '$REMOTE_WORKSPACE_FOLDER_NAME' is not allowed!" > $ERROR_OUTPUT
  error_handler
  exit -1
fi

# Remove trim leading & trailing blanks
WORKSPACE_FOLDER="${WORKSPACE_FOLDER#"${WORKSPACE_FOLDER%%[![:space:]]*}"}"
WORKSPACE_FOLDER="${WORKSPACE_FOLDER%"${WORKSPACE_FOLDER##*[![:space:]]}"}"

# No need to change the workspace folder for Python.
# This can be provided in original format
WORKSPACE_FOLDER_PYTHON="$WORKSPACE_FOLDER"
OBI_DIR_PYTHON=$OBI_DIR

#Rsync
WORKSPACE_FOLDER_RSYNC="$WORKSPACE_FOLDER"

# Check if a correct remote path is set
if [ "$WORKSPACE_FOLDER" = "" ] || [ "$WORKSPACE_FOLDER" = "/" ] || [ "$WORKSPACE_FOLDER" = "C:\\" ] || [ "$WORKSPACE_FOLDER" == "." ] || [ "$WORKSPACE_FOLDER" == "~" ] || [ "$WORKSPACE_FOLDER" == "~/" ]
then
  echo "Local workspace folder '$WORKSPACE_FOLDER' is not allowed!" > $ERROR_OUTPUT
  error_handler
  exit -1
fi

if [ $OSTYPE == 'msys' ] || [ $OSTYPE == 'win32' ] || [ $OSTYPE == 'mingw' ] || [ $OSTYPE == 'mingw32' ]; then
    WORKSPACE_FOLDER_RSYNC=$(cygpath --unix -a "$WORKSPACE_FOLDER")
    WORKSPACE_FOLDER=$(cygpath --windows -a "$WORKSPACE_FOLDER")
    WORKSPACE_FOLDER_PYTHON=$(cygpath --windows -a "$WORKSPACE_FOLDER_PYTHON")
    OBI_DIR_PYTHON=$(cygpath --windows -a "$OBI_DIR_PYTHON")
fi

exec > >(tee -a $STD_OUTPUT)

if [ -z "$MODE" ] # argument has not been passed
then
  MODE='default' # default value
fi

MODE=${MODE,,}

if [ -z $1 ] || [ $1 != '0' ]
then
  echo -e "\n$COLOR_MAGENTA_BOLD###################################################  $COLOR_END"
  echo -e "$COLOR_CYAN_BOLD`date +"%F %T.%3N"` ... $SCRIPT $COLOR_END" $1
  echo -e "$COLOR_MAGENTA_BOLD################################################### $COLOR_END\n"
fi

#exec > (tee -a stdout.txt.log)  #"$STD_OUTPUT_TMP".log
#set -x
#set -v
#set -o xtrace
trap 'print_debug' DEBUG
