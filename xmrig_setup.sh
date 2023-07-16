#!/bin/bash

# Update and upgrade
sudo apt update && sudo apt full-upgrade

# Install dependencies
sudo apt-get install git build-essential cmake libuv1-dev libssl-dev libhwloc-dev -y

# Clone repository
git clone https://github.com/xmrig/xmrig.git

# Navigate to xmrig directory
cd xmrig

# Create build directory
mkdir build

# Navigate to build directory
cd build

# Run cmake
cmake ..

# Build xmrig
make

# Download configure_xmrig.sh from GitHub repo
wget https://raw.githubusercontent.com/joehighton/xmrig-setup/main/configure_xmrig.sh

# Make configure_xmrig.sh executable
chmod +x configure_xmrig.sh

# Call configure_xmrig.sh script
./configure_xmrig.sh
