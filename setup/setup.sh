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

export PKG_CONFIG_PATH=/opt/sphinxbase:/opt/pocketsphinx
npm install

cp $src/evernoteConfig.json .
systemctl disable mdns
systemctl stop mdns

opkg install avahi

cp config/hostapd.conf /etc/hostapd/hostapd.conf
cp $src/udhcpd-for-hostapd.service /lib/systemd/system/udhcpd-for-hostapd.service
cp config/udhcpd.conf /etc/hostapd/udhcpd-for-hostapd.conf
cp $src/wpa_supplicant.conf /etc/wpa_supplicant/
cp $src/vaani-setup.service /lib/systemd/system
systemctl enable vaani-setup

echo "Rebooting..."
reboot
