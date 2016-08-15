#!/usr/bin/env bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

set -e
src=$(pwd)

# getting the repo
cd /opt
rm -rf vaani.client
git clone https://github.com/mozilla/vaani.client/
cd vaani.client
git checkout deployed

ln -s /boot/config/secret.json secret.json
export PKG_CONFIG_PATH=/opt/sphinxbase:/opt/pocketsphinx:/usr/local/lib/pkgconfig
npm install

mkdir /lib/systemd/system/vaani.service.d
cp $src/vaani.service  /lib/systemd/system
