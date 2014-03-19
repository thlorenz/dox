<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](http://doctoc.herokuapp.com/)*

- [USB](#usb)
- [Partitions](#partitions)
- [LUKS partition, zpool and filesystems](#luks-partition-zpool-and-filesystems)
- [wireless](#wireless)
- [bootstrap system](#bootstrap-system)
- [wired](#wired)
		- [static ip](#static-ip)
			- [`/etc/conf.d/network@interface`](#etcconfdnetwork@interface)
			- [`/etc/systemd/system/network@.service`](#etcsystemdsystemnetwork@service)
			- [Enable the unit and start it, passing the name of the interface](#enable-the-unit-and-start-it-passing-the-name-of-the-interface)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## USB

[guide](https://help.ubuntu.com/community/How%20to%20install%20Ubuntu%20on%20MacBook%20using%20USB%20Stick)

```sh
# add
diskutil list
diskutil unmountDisk /dev/disk2
dd if=arch-live.iso of=/dev/disk1 bs=8192

# remove
sudo dd if=arch-live.iso of=/dev/disk2 bs=8192
```

## Partitions

```sh
fdisk -l
cgdisk /dev/sda
```

## LUKS partition, zpool and filesystems

```sh
export LUKS=$(uuidgen)
cryptsetup luksFormat /dev/disk/by-partlabel/storage --uuid=$LUKS
cryptsetup luksOpen /dev/disk/by-uuid/$LUKS $LUKS

zpool create storage /dev/mapper/$LUKS

zfs create -o mountpoint=/thlorenz storage/thlorenz # storage/home already existed
zfs create storage/arch
```

## wireless

[guide](https://wiki.archlinux.org/index.php/Beginners'_guide#Wireless)

```sh
iw dev
wl=xxx

ip link set $wl up
ip link show $Wl

wifi-menu $wl
```

## bootstrap system

```sh
pacstrap /storage/arch base
```

## wired

`ip link` to find name of `eth0` interface

```sh
sudo systemctl enable dhcpcd@<interface>.service
sudo systemctl start dhcpcd@<interface>.service
```

[guide](http://news.softpedia.com/news/A-Beginners-Guide-to-Installing-Arch-Linux-352365.shtml)

#### static ip

First create a configuration file for the systemd service, replace interface with the proper network interface name: 

##### `/etc/conf.d/network@interface`

This contains config vars used inside the template below

```
address=192.168.0.15
netmask=24
broadcast=192.168.0.255
gateway=192.168.0.1
```


##### `/etc/systemd/system/network@.service`

```
[Unit]
Description=Network connectivity (%i)
Wants=network.target
Before=network.target
BindsTo=sys-subsystem-net-devices-%i.device
After=sys-subsystem-net-devices-%i.device

[Service]
Type=oneshot
RemainAfterExit=yes
EnvironmentFile=/etc/conf.d/network@%i

ExecStart=/usr/bin/ip link set dev %i up
ExecStart=/usr/bin/ip addr add ${address}/${netmask} broadcast ${broadcast} dev %i
ExecStart=/usr/bin/sh -c 'test -n ${gateway} && /usr/bin/ip route add default via ${gateway}'

ExecStop=/usr/bin/ip addr flush dev %i
ExecStop=/usr/bin/ip link set dev %i down

[Install]
WantedBy=multi-user.target
```

##### Enable the unit and start it, passing the name of the interface

This needs to happen anytime the above is configured to take effect.

```
systemctl enable network@<interface>.service
systemctl start network@<interface>.service
```

[guide](https://wiki.archlinux.org/index.php/Network_configuration#Static_IP_address)




