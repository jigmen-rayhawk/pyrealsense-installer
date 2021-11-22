#!/bin/sh

# This script installs pyrealsense to the jetson device
# Requires internet connection!!
# Reference: https://github.com/IntelRealSense/librealsense/issues/6964#issuecomment-707501049

# Install curl
sudo apt-get install curl

# Update CMake - v3.22.0
cd
wget https://cmake.org/files/v3.22/cmake-3.22.0.tar.gz
tar xpvf cmake-3.22.0.tar.gz cmake-3.22.0
cd cmake-3.22.0
./bootstrap --system-curl
make -j6
echo 'export PATH=$HOME/cmake-3.13.0/bin/:$PATH' >> ~/.bashrc
source ~/.bashrc

# Download and install the most recent version of Intel RealSense - v2.50.0
cd
wget https://github.com/IntelRealSense/librealsense/archive/refs/tags/v2.50.0.tar.gz
tar xpvf v2.50.0.tar.gz
cd librealsense-2.50.0
mkdir build && cd build
cmake ../ -DFORCE_RSUSB_BACKEND=ON -DBUILD_PYTHON_BINDINGS:bool=true -DPYTHON_EXECUTABLE=/usr/bin/python3.6 -DCMAKE_BUILD_TYPE=release -DBUILD_EXAMPLES=true -DBUILD_GRAPHICAL_EXAMPLES=true -DBUILD_WITH_CUDA:bool=true

# Setup CUDA compler
echo 'export CUDA_HOME=/usr/local/cuda' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64' >> ~/.bashrc
echo 'export PATH=$PATH:$CUDA_HOME/bin' >> ~/.bashrc
source ~/.bashrc

# Run CMake
make -j4
sudo make install

# Add path to ~/.bashrc
export PATH=$PATH:~/.local/bin
export PYTHONPATH=$PYTHONPATH:/usr/local/lib
export PYTHONPATH=$PYTHONPATH:/usr/local/lib:/usr/lib/python3/dist-packages/pyrealsense2
source ~/.bashrc

# Deal with package restructuring between python2 and python3
sudo cp ~/librealsense-2.50.0/wrappers/python/pyrealsense2/__init__.py /usr/lib/python3/dist-packages/pyrealsense2/

# Done
printf "DONE! Check if installation worked by running python and importing pyrealsense2"
