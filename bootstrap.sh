#!/usr/bin/env bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

set -e

echo "deb http://mirror.netcologne.de/raspbian/raspbian/ jessie main contrib non-free rpi" > /etc/apt/sources.list
apt-get update
apt-get dist-upgrade -y
apt-get install -y git

cd /opt
git clone https://github.com/mozilla/vaani.raspberrypi
cd vaani.raspberrypi

./install-prereqs.sh
./setup.sh
./clean.sh
