#!/usr/bin/env bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

set -e

nodev="v4.4.7"

# Renaming the system to "vaani" - now one can connect to "vaani.local"
sed -i -- 's/raspberrypi/vaani/g' /etc/hostname /etc/hosts

# Default ALSA card should be 1 (the USB one)
sed -i -- 's/defaults\.ctl\.card\ 0/defaults\.ctl\.card\ 1/g' /usr/share/alsa/alsa.conf
sed -i -- 's/defaults\.pcm\.card\ 0/defaults\.pcm\.card\ 1/g' /usr/share/alsa/alsa.conf

# Install the various packages and build tools we'll need
echo "deb http://mirror.netcologne.de/raspbian/raspbian/ jessie main contrib non-free rpi" > /etc/apt/sources.list
apt-get update
apt-get install -y git python-dev autoconf automake libtool bison swig cmake sox

# Allowing root to do npm builds
NPMRCFILE="/root/.npmrc"
NPMRCSTR="unsafe-perm = true"
if [ ! -f $NPMRCFILE ]
then
	echo $NPMRCSTR > $NPMRCFILE
elif [ ! grep -q $NPMRCSTR $NPMRCFILE ]
then
    echo $NPMRCSTR >> $NPMRCFILE
fi

cd /opt/sphinxbase
make install

cd /opt/pocketsphinx
make install

cd /opt

# We set pkg_config so that node-pocketsphinx can be built
export PKG_CONFIG_PATH=/opt/sphinxbase:/opt/pocketsphinx
export LD_LIBRARY_PATH=/usr/local/lib/

# Install a recent version of node and npm.
# See https://nodejs.org/en/download/ for latest stable download link
if [ ! -d "node-$nodev-linux-armv7l" ]; then
    wget --no-check-certificate https://nodejs.org/dist/$nodev/node-$nodev-linux-armv7l.tar.xz
    tar xf node-$nodev-linux-armv7l.tar.xz
fi
cd node-$nodev-linux-armv7l
cp -R bin include lib share /usr/local/
cd ..

# Install node bindings for cmake
npm install -g cmake-js

if [ ! -d "vaani.raspberrypi" ]; then
	git clone https://github.com/mozilla/vaani.raspberrypi
fi
cd vaani.raspberrypi

./setup.sh
./clean.sh
