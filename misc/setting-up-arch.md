<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](http://doctoc.herokuapp.com/)*

- [Install via USB](#install-via-usb)
- [Partitions](#partitions)
  - [Create [Partitions](https://wiki.archlinux.org/index.php/Partitioning)](#create-partitionshttpswikiarchlinuxorgindexphppartitioning)
  - [[Format Partitions](https://wiki.archlinux.org/index.php/File_Systems#Step_2:_create_the_new_file_system)](#format-partitionshttpswikiarchlinuxorgindexphpfile_systems#step_2_create_the_new_file_system)
  - [Mount partitions](#mount-partitions)
- [Connect to the Network](#connect-to-the-network)
  - [wireless](#wireless)
  - [wired](#wired)
    - [static ip](#static-ip)
      - [`/etc/conf.d/network@interface`](#etcconfdnetwork@interface)
      - [`/etc/systemd/system/network@.service`](#etcsystemdsystemnetwork@service)
      - [Enable the unit and start it, passing the name of the interface](#enable-the-unit-and-start-it-passing-the-name-of-the-interface)
- [bootstrap system](#bootstrap-system)
  - [Install base system and grub bootloader](#install-base-system-and-grub-bootloader)
  - [Generate fstab](#generate-fstab)
  - [Configure system](#configure-system)
    - [`chroot` into newly installed system](#chroot-into-newly-installed-system)
    - [Write hostname:](#write-hostname)
    - [Setup timezone:](#setup-timezone)
    - [Setup locale:](#setup-locale)
    - [Set root password](#set-root-password)
    - [Create initial ramdisk environment](#create-initial-ramdisk-environment)
    - [Configure bootloader](#configure-bootloader)
      - [Grub EFI](#grub-efi)
        - [edit linux kernel boot image part](#edit-linux-kernel-boot-image-part)
        - [Move linux kernel and boot image to grub directory](#move-linux-kernel-and-boot-image-to-grub-directory)
- [Post Installation](#post-installation)
  - [Add User](#add-user)
  - [mounting raid volumes](#mounting-raid-volumes)
- [Resources](#resources)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Install via USB

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

### Create [Partitions](https://wiki.archlinux.org/index.php/Partitioning)

Show disks:

`lsblk`, `blkid` or `fdisk -l` or `mount`

Create partitions with [cgidsk](http://www.rodsbooks.com/gdisk/cgdisk-walkthrough.html)

```sh
cgdisk /dev/sda
```

Sample setup:

```
> fdisk -l  (adjusted a bit)

/boot   200M  EFI System    /dev/sdb1
/        15G                /dev/sdb4 
/home   167G                /dev/sdb5 
/swap     4G  Linux Swap    /dev/sdb6

> lsblk (shortened)
sda...
sdb       233.8G
|-sdb1
|-sdb2
|-sdb3
|-sdb4
|-sdb5
--sdb6
loop0 ...
```

### [Format Partitions](https://wiki.archlinux.org/index.php/File_Systems#Step_2:_create_the_new_file_system)

For each partition except swap and boot do:

- if mounted unmount each partition via: `umount /mountpoint`
- `mkfs.ext4 /dev/partition`

For boot partition do:

```
mkfs.vfat -F32 /dev/partition
```

For [swap partition](https://wiki.archlinux.org/index.php/Swap) do:

- check swap status via `swapon -s` or `free -m`

```
# create it
mkswap /dev/partition

# enable for paging
swapon /dev/partition
```

Enable swap partition on boot add the following to fstab:

```
/dev/partition      none      swap      defaults    0    0 
```

### Mount partitions

For example to mount `/mnt/boot/efi, /mnt/home, /` do:

```sh
mkdir /mnt
mount /dev/partition /mnt 

mkdir /mnt/home
mount /dev/partition /mnt/home

mkdir /mnt/boot/efi
mount /dev/partition /mnt/boot/efi
```

## Connect to the Network

### wireless

[guide](https://wiki.archlinux.org/index.php/Beginners'_guide#Wireless)

Sometimes just `wifi-menu` works, otherwise:

```sh
iw dev
wl=xxx

ip link set $wl up
ip link show $Wl

wifi-menu $wl
```

### wired

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

## bootstrap system

Check [mirrors](https://wiki.archlinux.org/index.php/Mirrors) `vi /etc/pacman.d/mirrorlist`

### Install base system and grub bootloader

- `dialog` and `wpa_supplicant` are needed to launch `wifi-menu` from the installed arch

```sh
pacstrap /mnt base base-devel grub-efi-x86_64 dialog wpa_supplicant
```

### Generate fstab

```sh
genfstab -Up /mnt >> /mnt/etc/fstab
```

### Configure system

#### `chroot` into newly installed system

```sh
arch-chroot /mnt /bin/bash
```

#### Write hostname:

```sh
hostname > /etc/hostname
```

#### Setup timezone:

```sh
ln -s /usr/share/zoneinfo/US/Eastern /etc/localtime
```

#### Setup locale:

- uncomment `en_US.UTF8` inside `/etc/locale.gen`
- run: `locale-gen`
- list current via `locale` (after reboot this spits out more complete info)
- edit `/etc/locale.conf` to change it or just create it via `locale > /etc/locale.conf`

Completely configured locale looks similar to:

```
LANG=en_US.UTF-8
LC_CTYPE="en_US.UTF-8"
LC_NUMERIC="en_US.UTF-8"
LC_TIME="en_US.UTF-8"
LC_COLLATE="en_US.UTF-8"
LC_MONETARY="en_US.UTF-8"
LC_MESSAGES="en_US.UTF-8"
LC_PAPER="en_US.UTF-8"
LC_NAME="en_US.UTF-8"
LC_ADDRESS="en_US.UTF-8"
LC_TELEPHONE="en_US.UTF-8"
LC_MEASUREMENT="en_US.UTF-8"
LC_IDENTIFICATION="en_US.UTF-8"
LC_ALL=
```

#### Set root password

`passwd`

#### Create initial ramdisk environment

```sh
mkinitcpio -p linux
```

#### Configure bootloader

##### Grub EFI

```sh
pacman -Sy efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub --boot-directory=/boot/EFI --recheck
grub-mkconfig -o /boot/EFI/grub/grub.cfg
```

###### edit linux kernel boot image part

edit from `/boot/initramfs-linux.img` or `/initramfs-linux.img` to `/EFI/grub/kernel/initramfs-linux.img`
edit from `/boot/initramfs-linux-fallback.img` or `/initramfs-linux-fallback.img` to `/EFI/grub/kernel/initramfs-linux-fallback.img`
edit from `/boot/vmlinuz-linux` or `/vmlinuz-linux`  to `/EFI/grub/kernel/vmlinuz-linux`

###### Move linux kernel and boot image to grub directory

```sh
mkdir /boot/EFI/grub/kernel
mv /boot/initramfs-linux*.img /boot/EFI/grub/kernel
mv /boot/vmlinuz-linux /boot/EFI/grub/kernel
```

If all is well this results in a message similar to:

```
Found linux image: /boot/vmlinuz-linux
Found intramfs image: /boot/iniramfs-linux.img
Found fallback initramfs image: /boot/initramfs-linux-fallback.img
Found linux image: /boot/vmlinuz-linux
Found initrd image: /boot/initramfs-linux.img
done
```

Now logout of `chroot` environment, unmount partitions and reboot:

```sh
umount -R /mnt
reboot
```

## Post Installation

### Add User

```sh
useradd -m -g users -G wheel,storage,network,power -s /bin/bash <username>
passwd <username>
```


### mounting raid volumes

    pacman -S dmraid

    # activate raids and make them appear inside /dev/mapper
    systemctl enable dmraid.service  

    # manually activate raid to prep for next two steps
    dmraid -ay

    # mount raid volumes
    mount /dev/mapper/xxxx_RAIDVOL2
    mount /dev/mapper/xxxx_RAIDVOL3

    # get UUIDs
    blkid


For each `UUID` add a line to fstab, i.e.

    UUID=1CEC84C2ECD42822   /media/data    ntfs         defaults  0 0

[stackoverflow answer](http://askubuntu.com/a/387127/53802)


## Resources

- [installation steps gist](https://gist.github.com/alphazo/3285090) (old) 
- [uefi setup gist](https://gist.github.com/Apsu/4108795) (semi-old)
- [efi step by step](http://www.insanelymac.com/forum/topic/294443-easy-step-arch-linux-efi-with-clover-efi/) (Dec 2013)
