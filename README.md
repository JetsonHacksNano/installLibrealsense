# installLibrealsense
Build and install Intel's librealsense for the NVIDIA Jetson Nano Developer Kit

<h3>installLibrealsense.sh</h3>
These scripts are for installing the Intel RealSense SDK librealsense on the NVIDIA Jetson Nano Developer Kit. The current release of librealsense (V2) supports the D415, D435, D435i and T265 cameras. All of the cameras need to have librealsense installed. CUDA support is enabled by default. The CLI flag ( -w | --build_no_cuda ) will build without CUDA support. 


Building without CUDA support will take signficantly less time. Because the Jetson Nano uses CUDA 10, it requires CMake version 3.11+. The version in the Ubuntu repository does not meet the requirement. The installLibrealsense script will build CMake if a CUDA build is indicated, and use that version to configure the librealsense build.

```
During compilation, the script will run out of memory on the Nano
You will need either to:
* Enable swap memory
OR:
* Modify the script to 'make' with only 1 processor
```

If you are using the T265 Tracking Camera exclusively, it is worth considering compiling without CUDA support. The librealsense CUDA support is for the Depth cameras. To build and installLibrealsense with CUDA support:

```
$ ./installLibrealsense.sh
```

To build and install librealsense WITHOUT CUDA support:

```
$ ./installLibrealsense.sh --build_no_cuda
```

<em><b>Note:</b> If you are using a RealSense T265 exclusively, this is the only installation necessary. You do not need to patch the modules and kernels noted below.</em>

<h3>patchUbuntu.sh</h3>
The patchUbuntu.sh patches kernel modules and installs them to support the RealSense cameras. These patches include adding the different image formats to the uvcvideo module, support for proper time stamp reporting, and HID interface for the D435i. In addition, a Nano specific patch is added addressing a USB throughput issue. After updating and installting the modules, the script rebuilds the kernel and install it.

If you run one of the Depth cameras without addressing these issues, you will see the issues listed on the console about not being able to recognize the image formats, along with time stamp issues and so on. You will also notice that the system log is flooded with OOPs related to not being able to recognize the camera formats from the kernel. 

<em><b>Note:</b> If you are building from a USB or some other device than the SD card, you will need to copy the Image file to the /boot directory on the SD card.</em>


<h2>Notes</h2>
<h4>April 30, 2019</h4>
<h4>installLibrealsense.sh</h4>

* Add CLI argument build_no_cuda ; script defaults to build with CUDA. Saves considerable amount of compilation because CMake does not need to be built from source.


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

