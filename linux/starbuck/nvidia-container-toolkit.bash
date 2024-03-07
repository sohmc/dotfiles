#!/bin/bash

set -ev

DISTRO_NAME=jammy

# NVIDIA Container Toolkit
#  https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html
echo "Installing NVIDIA Container Toolkit..."
echo "  Installing nvidia gpg keys..."
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | \
  gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
  sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
  sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

apt-get update

apt-get install -y \
  nvidia-container-toolkit