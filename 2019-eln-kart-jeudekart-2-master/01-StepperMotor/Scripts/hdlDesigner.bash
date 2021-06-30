#!/bin/bash

#================================================================================
# hdl_designer.bash - Starts HDL designer
#
base_directory="$(dirname "$(readlink -f "$0")")"
pushd $base_directory
base_directory="$base_directory/.."

SEPARATOR='--------------------------------------------------------------------------------'
INDENT='  '

echo "$SEPARATOR"
echo "-- ${0##*/} Started!"
echo ""

#--------------------------------------------------------------------------------
# Parse command line options
#
command_switches='n:d:p:m:i:u:t:s:c:y:vh'
usage='Usage: hdl_designer.bash [-v] [-h]'
usage="$usage\n\t[-d designDirectory] [-u userPrefsDirectory]"
                                                    # set name and base directory
design_name=`basename $0 .bash`
design_directory=`dirname ${BASH_SOURCE[0]}`

while getopts $command_switches options; do
  case $options in
    n ) design_name=$OPTARG;;
    d ) design_directory=$OPTARG;;
  esac
done
                                            # continue with preferences directory
prefs_directory="$design_directory/Prefs"

OPTIND=1
while getopts $command_switches options; do
  case $options in
    n ) design_name=$OPTARG;;
    d ) design_directory=$OPTARG;;
    p ) prefs_directory=$OPTARG;;
  esac
done
                                                   # finish with other parameters
library_matchings='hds.hdp'
library_matchings="$design_name.hdp"
simulation_directory="$design_directory/Simulation"
user_prefs_directory="$prefs_directory/hds_user-linux"
team_prefs_directory="$prefs_directory/hds_team"
scratch_directory='/tmp/eda/'
synthesis_subdirectory="Board/ise"
concat_directory="$design_directory/Board/concat"

OPTIND=1
while getopts $command_switches options; do
  case $options in
    n ) ;;
    d ) ;;
    m ) library_matchings=$OPTARG;;
    i ) simulation_directory=$OPTARG;;
    u ) user_prefs_directory=$OPTARG;;
    t ) team_prefs_directory=$OPTARG;;
    s ) scratch_directory=$OPTARG;;
    c ) concat_directory=$OPTARG;;
    y ) synthesis_subdirectory=$OPTARG;;
    v ) verbose=1;;
    h ) echo -e $usage
          exit 1;;
    * ) echo -e $usage
          exit 1;;
  esac
done

design_directory=`realpath $design_directory`
library_matchings=`realpath $prefs_directory/$library_matchings`
simulation_directory=`realpath $simulation_directory`
user_prefs_directory=`realpath $user_prefs_directory`
team_prefs_directory=`realpath $team_prefs_directory`
concat_directory=`realpath $concat_directory`
mkdir -p $scratch_directory
scratch_directory=`realpath $scratch_directory`
echo "${INDENT}Concat directory is $concat_directory"

#================================================================================
# Main script
#

#-------------------------------------------------------------------------------
# System environment variables
#
export HDS_HOME=/usr/opt/HDS
export MODELSIM_HOME=/usr/opt/Modelsim
export ISE_HOME=/usr/opt/Xilinx/ISE_DS/ISE
export LC_ALL=C
export LD_LIBRARY_PATH=/usr/openwin/lib:/usr/lib:/usr/dt/lib:/usr/opt/HDS/ezwave/lib:/usr/opt/HDS/bin
export MGLS_HOME=/usr/opt/HDS/license/mgls

#-------------------------------------------------------------------------------
# Project environment variables
#
export DESIGN_NAME=$design_name
export HDS_LIBS=$library_matchings
export HDS_USER_HOME="$user_prefs_directory"
export HDS_TEAM_HOME=$team_prefs_directory
export SIMULATION_DIR=$simulation_directory
export SCRATCH_DIR=$scratch_directory
export CONCAT_DIR=$concat_directory
export ISE_BASE_DIR=`realpath $design_directory/$synthesis_subdirectory`
export ISE_WORK_DIR=$scratch_directory/$synthesis_subdirectory

#-------------------------------------------------------------------------------
# Display info
#
if [ -n "$verbose" ] ; then
  echo "$SEPARATOR"
  echo "Launching HDL Designer"
  echo "${INDENT}Design name          is $DESIGN_NAME"
  echo "${INDENT}Lib matchings file   is $HDS_LIBS"
  echo "${INDENT}Simulation directory is $SIMULATION_DIR"
  echo "${INDENT}User prefs directory is $HDS_USER_HOME"
  echo "${INDENT}Team prefs directory is $HDS_TEAM_HOME"
  echo "${INDENT}Concat directory     is $CONCAT_DIR"
  echo "${INDENT}ISE base directory   is $ISE_BASE_DIR"
  echo "${INDENT}Scratch directory    is $SCRATCH_DIR"
  echo "${INDENT}ISE work directory   is $ISE_WORK_DIR"
fi

#-------------------------------------------------------------------------------
# Copy synthesis data to scratch
#
if true; then
  echo "$ISE_BASE_DIR"
  echo "  -> $ISE_WORK_DIR"
fi
if [ -z "$ISE_BASE_DIR" ]; then
  echo -e "\nDon't start HDL designer directly from this script !\n"
  exit 1
else
  rm -Rf $ISE_WORK_DIR
  mkdir -p $ISE_WORK_DIR
  cp -pr $ISE_BASE_DIR/* $ISE_WORK_DIR/
fi

#-------------------------------------------------------------------------------
# Launch application
#
hdldesigner &

#-------------------------------------------------------------------------------
# Exit
#
echo ""
echo "-- ${0##*/} Finished!"
echo "$SEPARATOR"
popd