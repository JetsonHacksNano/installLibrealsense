#!/bin/bash
# Patch the kernel for the Intel Realsense library librealsense on a Jetson Nano Developer Kit
# Copyright (c) 2016-19 Jetsonhacks 
# MIT License

LIBREALSENSE_DIRECTORY=${HOME}/librealsense
LIBREALSENSE_VERSION=v2.20.0
JETSON_MODEL="jetson-nano"
L4T_TARGET="32.1.0"

# < is more efficient than cat command
# NULL byte at end of board description gets bash upset; strip it out
JETSON_BOARD=$(tr -d '\0' </proc/device-tree/model)

JETSON_L4T=""
if [ -f /etc/nv_tegra_release ]; then
    # L4T string
    JETSON_L4T_STRING=$(head -n 1 /etc/nv_tegra_release)

    # Load release and revision
    JETSON_L4T_RELEASE=$(echo $JETSON_L4T_STRING | cut -f 1 -d ',' | sed 's/\# R//g' | cut -d ' ' -f1)
    JETSON_L4T_REVISION=$(echo $JETSON_L4T_STRING | cut -f 2 -d ',' | sed 's/\ REVISION: //g' )
    # unset variable
    unset JETSON_L4T_STRING
    
    # Write Jetson description
    JETSON_L4T="$JETSON_L4T_RELEASE.$JETSON_L4T_REVISION"
fi
echo "Jetson Model: "$JETSON_BOARD
echo "Jetson L4T: "$JETSON_L4T

function usage
{
    echo "usage: ./buildPatchedKernel.sh [[-n nocleanup ] | [-h]]"
    echo "-h | --help  This message"
}

# Iterate through command line inputs
while [ "$1" != "" ]; do
    case $1 in
        -n | --nocleanup )      CLEANUP=false
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
# e.g. echo "${red}The red tail hawk ${green}loves the green grass${reset}"


INSTALL_DIR=$PWD

# Error out if something goes wrong
set -e

# Check to make sure we're installing the correct kernel sources
# Determine the correct kernel version
# The KERNEL_BUILD_VERSION is the release tag for the JetsonHacks buildKernel repository
KERNEL_BUILD_VERSION=master
if [ "$JETSON_BOARD" == "$JETSON_MODEL" ] ; then 
  if [ $JETSON_L4T = "$L4T_TARGET" ] ; then
     KERNEL_BUILD_VERSION=$L4T_TARGET
  else
   echo ""
   tput setaf 1
   echo "==== L4T Kernel Version Mismatch! ============="
   tput sgr0
   echo ""
   echo "This repository is for modifying the kernel for a L4T "$L4T_TARGET "system." 
   echo "You are attempting to modify a L4T "$JETSON_MODEL "system with L4T "$JETSON_L4T
   echo "The L4T releases must match!"
   echo ""
   echo "There may be versions in the tag/release sections that meet your needs"
   echo ""
   exit 1
  fi
else 
   tput setaf 1
   echo "==== Jetson Board Mismatch! ============="
   tput sgr0
    echo "Currently this script works for the $JETSON_MODEL."
   echo "This processor appears to be a $JETSON_BOARD, which does not have a corresponding script"
   echo ""
   echo "Exiting"
   exit 1
fi


echo "Through OK"
exit 



# Is librealsense on the device?

if [ ! -d "$LIBREALSENSE_DIRECTORY" ] ; then
   echo "The librealsense repository directory is not available"
   read -p "Would you like to git clone librealsense? (y/n) " answer
   case ${answer:0:1} in
     y|Y )
         # clone librealsense
         cd ${HOME}
         echo "${green}Cloning librealsense${reset}"
         git clone https://github.com/IntelRealSense/librealsense.git
         cd librealsense
         # Checkout version the last tested version of librealsense
         git checkout $LIBREALSENSE_VERSION
     ;;
     * )
         echo "Kernel patch and build not started"   
         exit 1
     ;;
   esac
fi

# Is the version of librealsense current enough?
cd $LIBREALSENSE_DIRECTORY
VERSION_TAG=$(git tag -l $LIBREALSENSE_VERSION)
if [ ! $VERSION_TAG  ] ; then
   echo ""
  tput setaf 1
  echo "==== librealsense Version Mismatch! ============="
  tput sgr0
  echo ""
  echo "The installed version of librealsense is not current enough for these scripts."
  echo "This script needs librealsense tag version: "$LIBREALSENSE_VERSION "but it is not available."
  echo "This script uses patches from librealsense on the kernel source."
  echo "Please upgrade librealsense before attempting to patch and build the kernel again."
  echo ""
  exit 1
fi

# Switch back to the script directory
cd $INSTALL_DIR
# Get the kernel sources 
echo "${green}Getting Kernel sources${reset}"
sudo ./scripts/getKernelSources.sh

echo "${green}Patching and configuring kernel${reset}"
sudo ./scripts/configureKernel.sh
sudo ./scripts/patchKernel.sh

# Make the new Image and build the modules
echo "${green}Building Kernel and Modules then installing Modules${reset}"
sudo ./scripts/makeKernel.sh

# The user still needs to copy the new kernel ...
echo "${green}Please flash the new kernel Image file on to the Jetson.${reset}"
echo "${green}The new kernel Image is in the directory named 'image'.${reset}"

mkdir -p image
cp /usr/src/kernel/kernel-4.9/arch/arm64/boot/Image ./image/Image


