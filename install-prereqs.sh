#!/usr/bin/env bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

set -e

swigv="3.0.10"
pcrev="8.39"
soxv="14.4.2"
nodev="v4.4.7"
cmakeva="3.6"
cmakevb="0"
cmakev=$cmakeva.$cmakevb

cd /opt

NPMRCFILE="/root/.npmrc"
NPMRCSTR="unsafe-perm = true"
if ! grep -q $NPMRCSTR $NPMRCFILE; then
   echo $NPMRCSTR >> $NPMRCFILE
fi

/etc/init.d/ntp stop
ntpd -q -g
/etc/init.d/ntp start

# Install the various packages and build tools we'll need
apt-get update
apt-get install -y python-dev autoconf automake libtool bison

# Download and compile a recent version of swig.
# You can change the version number if there is a newer release
if [ ! -d "swig-$swigv" ]; then
    wget http://prdownloads.sourceforge.net/swig/swig-$swigv.tar.gz
    tar xf swig-$swigv.tar.gz
fi
cd swig-$swigv
wget  ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-$pcrev.tar.gz
bash Tools/pcre-build.sh
./configure
make -j 4
make install
cd ..

# Download and compile a recent version of cmake
# You can change the version number if there is a newer release
if [ ! -d "cmake-$cmakev" ]; then
    wget --no-check-certificate https://cmake.org/files/v$cmakeva/cmake-$cmakev.tar.gz
    tar xf cmake-$cmakev.tar.gz
fi
cd cmake-$cmakev
./bootstrap
make -j 4
make install
cd ..

# Get Mozilla's version of sphinxbase and build it
if [ ! -d "sphinxbase" ]; then
    git clone https://github.com/mozilla/sphinxbase.git
fi
cd sphinxbase
./autogen.sh
make -j 4
make install
cd ..

# Get Mozilla's version of pocketsphinx and build it
if [ ! -d "pocketsphinx" ]; then
    git clone https://github.com/mozilla/pocketsphinx.git
fi
cd pocketsphinx
./autogen.sh
make -j 4
make install
cd ..

# We set pkg_config so that node-pocketsphinx can be built
export PKG_CONFIG_PATH=/opt/sphinxbase:/opt/pocketsphinx
export LD_LIBRARY_PATH=/usr/local/lib/
echo "/usr/local/lib/" >> /etc/ld.so.conf
ldconfig

# SOX
if [ ! -d "sox-$soxv" ]; then
    wget --no-check-certificate https://sourceforge.net/projects/sox/files/sox/$soxv/sox-$soxv.tar.gz/download -O sox-$soxv.tar.gz
    tar xf sox-$soxv.tar.gz
fi
cd sox-$soxv
./configure
make -j 4 -s
make install
cd ..

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
