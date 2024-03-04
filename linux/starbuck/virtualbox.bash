#!/bin/bash

set -ev

DISTRO_NAME=jammy

# VirtualBox Install:
#   https://www.virtualbox.org/wiki/Linux_Downloads
echo "Installing VirtualBox"
echo "  Installing VirtualBox gpg keys..."
curl -fsSL https://www.virtualbox.org/download/oracle_vbox_2016.asc | gpg --yes --dearmor --output /usr/share/keyrings/oracle-virtualbox-2016.gpg

echo "  Adding repository to /etc/apt/sources.list.d"
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] https://download.virtualbox.org/virtualbox/debian ${DISTRO_NAME} contrib" | tee /etc/apt/sources.list.d/virtualbox.list > /dev/null

apt-get update

apt-get install -y virtualbox-7

