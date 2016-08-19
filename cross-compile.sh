#!/usr/bin/env bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

set -e

if [ "$(id -u)" != "0" ]; then
	echo "Sorry, you are not root."
	exit 1
fi

export TBIN=`pwd`/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin
export SYSROOT=`pwd`/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/arm-linux-gnueabihf/libc
export CC=$TBIN/arm-linux-gnueabihf-gcc
export CXX=$TBIN/arm-linux-gnueabihf-g++
export PREFIX=/usr
export ARCH=arm-linux-gnueabihf

# Get Mozilla's version of sphinxbase and build it
if [ ! -d "sphinxbase" ]; then
    git clone https://github.com/cmusphinx/sphinxbase.git
fi
cd sphinxbase
./autogen.sh --without-python --host=$ARCH --with-sysroot=$SYSROOT --prefix=$PREFIX
make -j 4
cd ..
rm -rf mnt/opt/sphinxbase
cp -r sphinxbase mnt/opt/

# Get Mozilla's version of pocketsphinx and build it
if [ ! -d "pocketsphinx" ]; then
    git clone https://github.com/cmusphinx/pocketsphinx.git
fi
cd pocketsphinx
./autogen.sh --without-python --host=$ARCH --with-sysroot=$SYSROOT --prefix=$PREFIX
make -j 4
cd ..
rm -rf mnt/opt/pocketsphinx
cp -r pocketsphinx mnt/opt/
