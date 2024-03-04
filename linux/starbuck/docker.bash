#!/bin/bash

set -ev

DISTRO_NAME=jammy

# Docker Install:
#  https://linuxiac.com/how-to-install-docker-on-linux-mint-21/
echo "Installing docker..."
echo "  Installing docker gpg keys..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --yes --dearmor -o /usr/share/keyrings/docker.gpg

echo "  Adding repository to /etc/apt/sources.list.d"
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu ${DISTRO_NAME} stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update

apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

echo "Adding 'mike' to the group 'docker'"
usermod -aG docker mike

