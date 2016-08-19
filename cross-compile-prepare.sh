#!/usr/bin/env bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

set -e

swigv="3.0.10"
pcrev="8.39"

if [ "$(id -u)" != "0" ]; then
	echo "Sorry, you are not root."
	exit 1
fi

if [ ! -d tools ]; then
    echo "downloading the cross compiler..."
    git clone --depth 1 --branch master git://github.com/raspberrypi/tools
fi

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
rm -rf pcre-*
wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-$pcrev.tar.gz
bash Tools/pcre-build.sh
./configure
make -j 4
make install
cd ..
