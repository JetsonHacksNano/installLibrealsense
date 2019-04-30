# installLibrealsense
Build and install Intel's librealsense for the NVIDIA Jetson Nano Developer Kit

<b>Work In Progress</b>

April 29, 2019
* installLibrealsense.sh
Add CUDACXX flag for compilation using CUDA
Add USE_CUDA flag to script (Defaults to YES)
If using only RealSense T265 camera, this is the only installation necessary
<em>If using the T265, you probably don't need CUDA (still needs to be tested); Set USE_CUDA to false. Saves compilation time</em>
During compilation, the script will run out of memory on the Nano
You will need either to:
* Enable swap memory
OR:
* Modify the script to 'make' with only 1 processor

* patchUbuntu.sh

patchUbuntu will patch all of the needed modules for librealsense, build the modules, and then install the modules. The kernel Image is then built and installed in /boot/Image.

<em><b>Note:</b> If you are building from a USB or some other device than the SD card, you will need to copy the Image file to the /boot directory on the SD card.</em>

