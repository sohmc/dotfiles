#!/bin/bash

set -ev

DISTRO_NAME=jammy

# VirtualBox Install:
#   https://www.virtualbox.org/wiki/Linux_Downloads
echo "Installing VirtualBox"
echo "  Installing VirtualBox gpg keys..."
curl -fsSL https://www.virtualbox.org/download/oracle_vbox_2016.asc | gpg --yes --dearmor --output /usr/share/keyrings/oracle-virtualbox-2016.gpg

echo "  Downloading VirtualBox"
echo "  Please note that you are downloading a hard-coded version."
curl -fsSL -o /tmp/virtualbox.deb "https://download.virtualbox.org/virtualbox/7.0.14/virtualbox-7.0_7.0.14-161095~Ubuntu~jammy_amd64.deb"

apt install /tmp/virtualbox.deb

apt-get update

