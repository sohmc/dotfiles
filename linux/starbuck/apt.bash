#!/bin/bash

set -ev

DISTRO_NAME=jammy

apt-get install -y \
    zfs-auto-snapshot \
    vim \
    openssh-server \
    samba

