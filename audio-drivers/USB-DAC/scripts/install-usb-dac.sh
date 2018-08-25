#!/bin/bash
#
# Configure Raspberry Pi audio for USB DAC.

set -o errexit

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (use sudo)" 1>&2
   exit 1
fi

cd "$(dirname "${BASH_SOURCE[0]}")/.."

asoundrc=/home/pi/.asoundrc
global_asoundrc=/etc/asound.conf

if [ ! -d "/home/pi/GassistPi-Config/" ]; then
  sudo mkdir "/home/pi/GassistPi-Config/"
fi

audioconfig=/home/pi/GassistPi-Config/audiosetup

for rcfile in "$asoundrc" "$global_asoundrc"; do
  if [[ -f "$rcfile" ]] ; then
    echo "Renaming $rcfile to $rcfile.bak..."
    sudo mv "$rcfile" "$rcfile.bak"
  fi
done

if [ -f $audioconfig ] ; then
    sudo rm $audioconfig
fi

echo 'USB-DAC' >> $audioconfig

sudo cp scripts/asound.conf "$global_asoundrc"
sudo cp scripts/.asoundrc "$asoundrc"
echo "Installing USB DAC config"
