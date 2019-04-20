#!/bin/bash
# Install the Intel Realsense library kernel patches on a NVIDIA Jetson Nano Developer Kit
# Copyright (c) 2016-19 Jetsonhacks 
# MIT License

set -e

INSTALL_DIR=$PWD
module_dir=$PWD/modules
echo $module_dir

cd ${HOME}/librealsense
LIBREALSENSE_DIR=$PWD
kernel_branch="master"
echo "kernel branch" $kernel_branch
kernel_name="kernel-4.9"


# For L4T 32.1.0 the kernel is 4.9.108 hence kernel-4.9

# Patches are available for kernel 4.4, 4.10 and 4.16
# For L4T 32.1.0, the kernel is 4.9
# Therefore we have to do a little dance; patches are modified versions of xenial 4.4 and 4.8 kernel patches

cd /usr/src/kernel/kernel-4.9

# ubuntu_codename=`. /etc/os-release; echo ${UBUNTU_CODENAME/*, /}`
# ubuntu_codename is xenial for L4T 28.X (Ubuntu 16.04)
# ubuntu_codename is bionic for L4T 31.1 (Ubuntu 18.04)
# Patching kernel for RealSense devices
echo -e "\e[32mApplying Realsense-camera-formats patch\e[0m"
patch -p1 < ${INSTALL_DIR}/patches/realsense-camera-formats_ubuntu-bionic-Jetson-4.9.140.patch
echo -e "\e[32mApplying realsense-metadata patch\e[0m"
patch -p1 < ${INSTALL_DIR}/patches/realsense-metadata-ubuntu-bionic-Jetson-4.9.140.patch
echo -e "\e[32mApplying realsense-hid patch\e[0m"
# This appears to be the closest
patch -p1 < ${INSTALL_DIR}/patches/realsense-hid-ubuntu-bionic-Jetson-4.9.140.patch
echo -e "\e[32mApplying URBS UVC patch\e[0m"
patch -p1 < ${INSTALL_DIR}/patches/0001-media-uvc-restrict-urb_num-no-less-than-UVC_URBS.patch
echo -e "\e[32mpowerlinefrequency-control-fix patch\e[0m"
patch -p1 < ${LIBREALSENSE_DIR}/scripts/realsense-powerlinefrequency-control-fix.patch


