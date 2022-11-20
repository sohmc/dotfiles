#!/bin/bash -xe

echo "----- DROPBOX VM -----"
echo "Run this as ubuntu"


echo "Updating Ubuntu Packages"
sudo apt-get update && \
  sudo apt-get upgrade -y && \
  sudo apt-get autoremove -y

echo "Installing samba"
sudo apt-get install samba

echo "Copy dropbox-smb.conf to /etc/samba and then include it"
echo "in smb.conf by adding the following line at the end of"
echo "the file:"
echo "  include = /etc/samba/includes/dropbox-smb.conf"


echo "Downloading dropbox management cli"
curl -o $HOME/.local/bin/dropbox \
  "https://www.dropbox.com/download?dl=packages/dropbox.py" && \
  chmod +x $HOME/.local/bin/dropbox

echo "Downloading dropbox binaries..."
cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -

echo "Dropbox installed.  Before continuing, you must set up"
echo "your account credentials.  You can do so by running the"
echo "following:"
echo "    ~/.dropbox-dist/dropboxd"

echo ""
echo "Once installed, copy dropbox.service to /etc/systemd/system/"
echo "and restart systemd:"
echo "    sudo systemctl daemon-reload"
