#!/usr/bin/env bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

set -e
src=$(pwd)

# getting the repo
cd /opt
rm -rf git-auto-updater
git clone https://github.com/andrenatal/git-auto-updater
cd git-auto-updater

cp $src/git-auto-updater.service /lib/systemd/system
