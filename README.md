# installLibrealsense
Build and install Intel's librealsense for the NVIDIA Jetson Nano Developer Kit

<b>Work In Progress</b>

April 29, 2019
* installLibrealsense.sh
Add CUDACXX flag for compilation using CUDA
Add USE_CUDA flag to script (Defaults to YES)
If using only RealSense T265 camera, this is the only installation necessary
<em>If using the T265, you probably don't need CUDA (still needs to be tested); Set USE_CUDA to false. Saves compilation time</em>
Added preliminary buildPathcedModules. Currently testing to see if rebuilt Image needs to also be installed.

