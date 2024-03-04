#!/bin/bash

set -ev

DISTRO_NAME=jammy

echo "Installing vscode..."
echo "  Downloading VS Code..."
curl -fsSL -o /tmp/vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"

echo "  Installing via apt..."
apt install /tmp/vscode.deb

apt-get update

