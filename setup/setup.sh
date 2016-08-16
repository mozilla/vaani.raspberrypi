#!/usr/bin/env bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

set -e
src=$(pwd)

# getting the repo
cd /opt
rm -rf vaani.setup
git clone https://github.com/mozilla/vaani.setup.git
cd vaani.setup

apt-get install -y hostapd
apt-get install -y udhcpd
systemctl disable hostapd
systemctl disable udhcpd

ln -s /boot/config/evernoteConfig.json evernoteConfig.json
export PKG_CONFIG_PATH=/opt/sphinxbase:/opt/pocketsphinx
npm install

HAPDFILE="/etc/default/hostapd"
HAPDSTR="DAEMON_CONF=\"/etc/hostapd/hostapd.conf\""
if ! grep -q $HAPDSTR $HAPDFILE; then
   echo $HAPDSTR >> $HAPDFILE
fi

sed -i '/^DHCPD_ENABLED="no"/s/^/#/' /etc/default/udhcpd

cp config/hostapd.conf /etc/hostapd/hostapd.conf
cp config/udhcpd.conf /etc/udhcp.conf
cp $src/vaani-setup.service /lib/systemd/system

systemctl enable vaani-setup
