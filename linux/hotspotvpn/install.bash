#!/bin/bash

echo "Run as root"

apt-get update && apt-get autoremove -y

echo "Removing libreoffice"
apt-get remove --purge -y libreoffice* && \
  apt-get clean -y && \
  apt-get autoremove -y

echo "Updating OS"
apt-get upgrade -y

echo "Adding qbittorent repository"
echo "Full instructions https://www.qbittorrent.org/download.php"
add-apt-repository ppa:qbittorent-team/qbittorrent-stable && \
  apt-get update

echo "Installing qbittorrent"
apt-get install -y qbittorent


echo "Installing youtube-dl"
echo "Full instructions https://ytdl-org.github.io/youtube-dl/download.html"
curl -kL https://yt-dl.org/downloads/latest/youtube-dl -o /home/ubuntu/.local/bin/youtube-dl
chown ubuntu:ubuntu /home/ubuntu/.local/bin/youtube-dl
chmod +x /home/ubuntu/.local/bin/youtube-dl


echo "I've gone as far as I can go.  You must log into HotspotShield"
echo "VPN and get the download link from: "
echo "  https://app.hotspotshield.com/app/hotspotshield/linux"
