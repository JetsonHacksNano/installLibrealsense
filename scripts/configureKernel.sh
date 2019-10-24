#!/bin/bash
# Configure the kernel for the Intel Realsense library on a NVIDIA Jetson Developer Kits
# Copyright (c) 2016-19 Jetsonhacks 
# MIT License

# For L4T 32.1.0 the kernel is 4.9.140 hence kernel-4.9
echo "Configuring Kernel for librealsense"

cd /usr/src/kernel/kernel-4.9
echo "Current working directory: "$PWD
KERNEL_VERSION=$(uname -r)
# For L4T 32.1.0 the kernel is 4.9.140-tegra ; everything after that is the local version
# This removes the suffix
LOCAL_VERSION=${KERNEL_VERSION#$"4.9.140"}

# On L4T 32.1.0 Kernel 4.9, Industrial I/O support is enabled
# This was not true on earlier versions 

# == Industrial I/O support
# IIO_BUFFER - Enable buffer support within IIO
# IIO_TRIGGERED_BUFFER -
# HID_SENSOR_IIO_COMMON - Common modules for all HID Sensor IIO drivers
# HID_SENSOR_IIO_TRIGGER - Common module (trigger) for all HID Sensor IIO drivers)
# Note: HID_SENSOR_IIO_TRIGGER does not appear in Kernel 4.9
# HID_SENSOR_HUB - HID Sensors framework support
# == Devices
# HID_SENSOR_ACCEL_3D - HID Accelerometers 3D (NEW)
# HID_SENSOR_GYRO_3D - HID Gyroscope 3D (NEW)

bash scripts/config --file .config \
	--set-str LOCALVERSION $LOCAL_VERSION \
        --module HID_SENSOR_IIO_COMMON \
        --module HID_SENSOR_ACCEL_3D \
	--module HID_SENSOR_GYRO_3D

yes "" | make olddefconfig

