#!/bin/bash
# Builds Cmake on a Jetson Developer Kit
# Copyright (c) 2016-18 Jetsonhacks 
# MIT License

cd ${HOME}
# Support for CUDA 10
CMAKE_VERSION=3.14.1
wget https://github.com/Kitware/CMake/archive/v${CMAKE_VERSION}.zip
# Make it easier to work with a shorter name
unzip v${CMAKE_VERSION}.zip
mv CMake-${CMAKE_VERSION} CMake
rm v${CMAKE_VERSION}.zip
cd CMake
time ./bootstrap
# Get the number of CPUs 
NUM_CPU=$(nproc)
time make -j$(($NUM_CPU - 1))
if [ $? -eq 0 ] ; then
  echo "CMake make successful"
else
  # Try to make again; Sometimes there are issues with the build
  # because of lack of resources or concurrency issues
  echo "CMake did not build " >&2
  echo "Retrying ... "
  # Single thread this time
  time make 
  if [ $? -eq 0 ] ; then
    echo "CMake make successful"
  else
    # Try to make again
    echo "CMake did not successfully build" >&2
    echo "Please fix issues and retry build"
    exit 1
  fi
fi



