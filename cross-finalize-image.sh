#!/usr/bin/env bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.



if [ "$(id -u)" != "0" ]; then
	echo "Sorry, you are not root."
	exit 1
fi

echo "cleaning up..."
rm -f mnt/home/pi/cross-chroot-script.sh
rm -f mnt/etc/ld.so.preload
mv mnt/etc/ld.so.preload.bak mnt/etc/ld.so.preload
rm -f mnt/etc/resolv.conf
mv mnt/etc/resolv.conf.bak mnt/etc/resolv.conf
rm -f mnt/usr/bin/qemu-arm-static
rm -f mnt/home/pi/cross-build.sh
echo "unmounting the file system..."
umount mnt/dev/pts
umount mnt/dev
umount mnt/sys
umount mnt/proc
umount mnt
echo "unlooping the image..."
losetup -d /dev/loop0
