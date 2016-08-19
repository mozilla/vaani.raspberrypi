#!/usr/bin/env bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

set -e

if [ "$(id -u)" != "0" ]; then
	echo "Sorry, you are not root."
	exit 1
fi

cp cross-chroot-script.sh mnt/home/pi/cross-chroot-script.sh

cd mnt
chroot . /home/pi/cross-chroot-script.sh
cd ..
