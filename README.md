# installLibrealsense
Build and install scripts for Intel's librealsense for the NVIDIA Jetson Nano Developer Kit

Original article on JetsonHacks: https://wp.me/p7ZgI9-34j

The Intel® RealSense™ SDK is here: https://github.com/IntelRealSense/librealsense
The SDK library name is librealsense. This is for version 2 of the library, which supports
the D400 series depth cameras, T265 tracking camera, and the SR300 depth camera.

Starting with L4T 32.2.1 (JetPack 4.2.2) on the NVIDIA Jetsons and the Intel RealSense SDK 
version v2.23.0, it is now possible to do a simple install from a RealSense debian repository
(i.e. apt-get install). Previous versions of this repository require building librealsense from source, and (possibly) rebuilding the Linux kernel.

The current recommendation from Intel is to use UVC for video input on the Jetson family. The
UVC API in librealsense has been rewritten to better support this use case.

<h3>installLibrealsense.sh</h3>
This script will install librealsense from the Intel Librealsense Debian Repository.


```
$ ./installLibrealsense.sh
```

<em><b>Note:</b> You do not have to patch modules and kernels.</em>

<h3>buildLibrealsense.sh</h3>
This script will build librealsense from source and install it on the system. It is recommended to install from Debian repository as described above. However, if you need to compile from source, you will find this script useful.

```
$ ./buildLibrealsense.sh
```

<em><b>Note:</b> The build uses libuvc. You will not have to rebuild the kernel or modules in order to use this build.</em>

<h2>Notes</h2>
If you use realsense-ros, make sure that you match the librealsense versions with the realsense-ros version requirement.

<h4>December, 2019</h4>

* Release vL4T32.3.1
* Jetson Nano
* L4T 32.3.1, JetPack 4.3, Kernel 4.9.
* Also works with L4T 32.2.1 - 32.2.3
* Current  librealsense version v2.31.0
* Fixed Issue: D435i and T265 have issues working together. Upgrading D435i firmware fixes this issue.
* Requires realsense-ros version 2.2.11 
* Now uses libuvc in buildLibrealsense, no need to recompile linux kernel/modules


<h4>November, 2019</h4>

* Release vL4T32.2.3
* Jetson Nano
* L4T 32.2.3, JetPack 4.2.2, Kernel 4.9.
* Also works with L4T 32.2.1
* Currently librealsense version v2.31.0
* Issue: L4T 32.2.3 has issues with using RealSense cameras D435i and T265 simultaneously. Under L4T 32.2.1 appears to work correctly.
* Requires realsense-ros version 2.2.11 
* Now uses libuvc in buildLibrealsense, no need to recompile linux kernel/modules

<h4>October, 2019</h4>

* Release vL4T32.2.1
* Jetson Nano
* L4T 32.2.1, JetPack 4.2.2, Kernel 4.9 
* librealsense version v2.25.0 (matches realsense-ros package)


<h4>July, 2019</h4>

* Release vL4T32.2
* Jetson Nano
* L4T 32.2, Kernel 4.9, JetPack 4.2.1
* Add Python 3 support
* UVC_MAX_STATUS changed in Kernel to 1024, remove Patch 
* Remove URBS UVC patch
* librealsense version v2.24.0

<h4>June, 2019</h4>

* Release vL4T32.1
* Jetson Nano
* L4T 32.1.0, Kernel 4.9-140
* Bump librealsense version to v2.22.0 for compatibility with realsense-ros

<h4>June, 2019</h4>

* Release v0.9
* Jetson Nano
* L4T 32.1.0, Kernel 4.9-140
* Bump librealsense version to v2.22.0 for compatibility with realsense-ros

<h4>May, 2019</h4>

* Release v0.8
* Jetson Nano
* L4T 32.1.0, Kernel 4.9-140
* D435i issue resolved - Make kernel image before modules 


<h4>May 6, 2019</h4>

* Initial Release v0.7
* Jetson Nano
* L4T 32.1.0, Kernel 4.9-140
* D435i issue addressed

<h4>April 30, 2019</h4>
<h4>installLibrealsense.sh</h4>

* Switch CLI argument to build_with_cuda ; Build with CUDA takes a lot more time because CMake needs to be rebuilt. Default is to build without CUDA support

* <em>previous commit</em> Add CLI argument build_no_cuda ; script defaults to build with CUDA. 

* D435i is not recognized by RealSense applications, but shows up in Cheese webcam viewer.


<h4>April 29, 2019</h4>
<h4>installLibrealsense.sh</h4>

Add CUDACXX flag for compilation using CUDA

Add USE_CUDA flag to script (Defaults to YES)

If using only RealSense T265 camera, this is the only installation necessary

<em>If using the T265, you probably don't need CUDA (still needs to be tested); Set USE_CUDA to false. Saves compilation time</em>

During compilation, the script will run out of memory on the Nano
You will need either to:

* Enable swap memory

<b>OR:</b>

* Modify the script to 'make' with only 1 processor

<h4>patchUbuntu.sh</h4>

patchUbuntu will patch all of the needed modules for librealsense, build the modules, and then install the modules. The kernel Image is then built and installed in /boot/Image.

<em><b>Note:</b> If you are building from a USB or some other device than the SD card, you will need to copy the Image file to the /boot directory on the SD card.</em>

