# Vaani for the Raspberry Pi
Installs and maintains a Vaani Appliance for the Raspberry Pi

## Prerequisites

- Raspberry Pi 3(!) board (plus power support)
- Recent Raspbian image
- Micro SD card of at least 4GB size
- Ethernet patch cable (plus USB or Thunderbolt adapter if needed)

## Creating the image

### Preparing the SD card

Insert the SD card into your card reader.
For the sake of simplicity you should choose a
rather small one, if you want to redistribute the final image.
Shrinking the SD card image after this installation process is
complicated and tedious.

You can download the Raspbian image from [here][].
Uncompress the archive with your preferred unarchiver
(on Mac this should work automatically).
Then flash the raw image to the SD card using your preferred SD card flashing
tool or ```dd```. E.g. on Mac you can use
[Apple Pi Baker][http://www.tweaking4all.com/hardware/raspberry-pi/macosx-apple-pi-baker/]
for this
([download link][http://www.tweaking4all.com/?wpfb_dl=94 ]).
If the SD card is ready, you should now put it into your Pi.

### Connect to the Pi

Connect the Pi to your local network or directly to your computer using a
patch cable (and an adapter if needed).
Boot it up by connecting it to the power supply.

Time to SSH into the Pi: The Raspberry Pi's SSH is already running -
its mDNS name is ```raspberry.local```.
Prepare your computer or network accordingly.

E.g. if you want to connect it directly to you Mac, you can execute the
following:
```sh
sudo /usr/libexec/bootpd -D -d -i en0
```

If everything is set up, you can finally call
```sh
ssh -l pi raspberrypi.local
```
to connect (password: raspberry).

If the Pi is not connected to your home network yet, you somehow have to give it
internet access. This is how you could for example connect it to some
wifi access point:
```sh
sudo iwconfig wlan0 essid "access point name" key "your secret access point key"
sudo dhclient wlan0
```
For open wifi networks you can leave out the key part.
In some cases you first have to do
```sudo iwdown wlan0``` and/or ```sudo iwup wlan0```.

Finally you can start the setup process by:
```sh
wget https://raw.githubusercontent.com/mozilla/vaani.raspberrypi/master/bootstrap.sh
sudo bash bootstrap.sh
```
This will take quite a while.
