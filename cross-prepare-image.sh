#!/usr/bin/env bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

set -e

if [ "$(id -u)" != "0" ]; then
	echo "Sorry, you are not root."
	exit 1
fi

if [ ! -e raspbian_lite_latest ]; then
    echo "downloading the original image..."
    wget https://downloads.raspberrypi.org/raspbian_lite_latest
fi

rm -f *.img
echo "unzipping the original image..."
unzip raspbian_lite_latest
echo "renaming the image..."
mv -f *.img vaani.img
echo "truncating the image to 4GB..."
truncate -s 4G vaani.img
echo "determining ext4 start block..."
block=`fdisk -l vaani.img | grep vaani.img2 | grep -oE '[0-9]+' | sed '2q;d'`
echo "partitioning the image (ext4 partition starting at block $block)..."
echo -e "d\n2\nn\np\n\n$block\n\nw\n" | fdisk vaani.img > /dev/null
echo "looping the ext4 partition..."
sudo losetup -o $(($block * 512)) /dev/loop0 vaani.img
echo "checking the file system..."
e2fsck -f /dev/loop0
echo "resizing the file system..."
resize2fs /dev/loop0
echo "mounting the file system..."

mkdir -p mnt
mount /dev/loop0 -o rw mnt
cd mnt
mount --bind /sys sys/
mount --bind /proc proc/
mount --bind /dev dev/
mount --bind /dev/pts dev/pts
cp /usr/bin/qemu-arm-static usr/bin
cp ../cross-build.sh home/pi/
cp etc/resolv.conf etc/resolv.conf.bak 2>/dev/null || :
cp /etc/resolv.conf etc
cp etc/ld.so.preload etc/ld.so.preload.bak
sed -i 's/^/#/' etc/ld.so.preload
cd ..
