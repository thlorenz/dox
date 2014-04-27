<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](http://doctoc.herokuapp.com/)*

- [Steps](#steps)
- [Partitions](#partitions)
  - [Format Partitions and install](#format-partitions-and-install)
- [Configure](#configure)
  - [Setup root and User](#setup-root-and-user)
    - [Create initial ramdisk environment](#create-initial-ramdisk-environment)
- [Bootloader](#bootloader)
  - [Preparation in Arch](#preparation-in-arch)
  - [Preparation in OSX](#preparation-in-osx)
  - [Xorg](#xorg)
  - [i3](#i3)
  - [Various other tools](#various-other-tools)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Steps

Follow [these instructions](http://codylittlewood.com/arch-linux-on-macbook-pro-installation/)
interspersed with adaptations/additions from [this gist](https://gist.github.com/denji/6530540)

## Partitions

- `cgdisk /dev/sda` (don't touch first 3 which are MacOS partitions)

```
Part #    Size      Partition type    Partition Code  Partition name
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
1     |   200 Mib | EFI System       |              | EFI system partition
2     |    93 Gib | Apple HFS+       |              | Macintosh HD
3     |   700 MiB | Apple boot       |              | Recovery HD
4     |   128 MiB | Apple HFS+       |  af00        | Linux Boot loader from Apple
5     |   256 MiB | Linux filesystem |  8300        | boot
6     |    30 GiB | Linux filesystem |  8300        | root
7     |   250 GiB | Linux filesystem |  8300        | home
8     |     4 GiB | Linux swap       |  8200        | swap       
```

### Format Partitions and install

```sh
mkfs.ext2 /dev/sda5

mkfs.ext4 /dev/sda6

mkfs.ext4 /dev/sda7

mount /dev/sda6 /mnt

mkdir /mnt/boot && mount /dev/sda5 /mnt/boot

mkdir /mnt/home && mount /dev/sda7 /mnt/home

pacstrap /mnt base base-devel grub-efi-x86_64 dialog wpa_supplicant

genfstab -p /mnt >> /mnt/etc/fstab
```

- `dialog` and `wpa_supplicant` are needed to launch `wifi-menu` from the installed arch


Edit fstab to make SSD drive work properly:

```
# <file system>	      <dir>	      <type>	      <options>	                              <dump>	<pass>

/dev/sda5           	/boot     	ext2      		defaults,relatime,stripe=4		          0         2
/dev/sda6           	/         	ext4      		defaults,noatime,discard,data=writeback	0         1
/dev/sda7           	/home     	ext4      		defaults,noatime,data=ordered		        0         2
/dev/sda8           	none      	swap      		defaults  				                      0         0
```

## Configure

Most instructions taken from [setting up arch](https://github.com/thlorenz/dox/blob/master/misc/setting-up-arch.md)

```sh
arch-chroot /mnt /bin/bash
hostname > /etc/hostname
ln -s /usr/share/zoneinfo/US/Eastern /etc/localtime
```

Uncomment `en_US.UTF8` inside `/etc/locale.gen`

```
locale-gen
locale > /etc/locale.conf
```

### Setup root and User

```
passwd
useradd -m -g users -G wheel,storage,network,power -s /bin/bash <username>
passwd <username>
```

#### Create initial ramdisk environment

```sh
mkinitcpio -p linux
```

## Bootloader 

All bootloading info comes from [these instructions](http://codylittlewood.com/arch-linux-on-macbook-pro-installation/).

### Preparation in Arch

```sh
arch-chroot /mnt /bin/bash
pacman -S grub-efi-x86_x64
```

Alter `/etc/default/grub`: `GRUB_CMDLINE_LINUX_DEFAULT="quiet rootflags=data=writeback"`

```sh
grub-mkconfig -o boot/grub/grub.cfg 
grub-mkstandalone -o boot.efi -d usr/lib/grub/x86_64-efi -O x86_64-efi boot/grub/grub.cfg

# Copy standalone grub file to usb stick to use from OSX
mkdir /mnt/usbdisk
mount /dev/sdb /mnt/usbdisk 
cp boot.efi /mnt/usbdisk/

```

Exit arch-chroot, umount and reboot

```sh
umount -R /mnt
sudo reboot
```

### Preparation in OSX

Launch disk utility, select `/dev/sda4`, erase as Mac OSx Journaled.

Create dirs and `.plist` and bless it to make it bootable.

```sh
cd /Volumes/disk0s4
mkdir mach_kernel
mkdir -p System/Library/CoreServices
cd System/Library/CoreServices
cp /Volumes/usbstick/boot.efi .
vim SystemVersion.plist
```

SystemVersion.plist:

```xml
<xml version="1.0" encoding="utf-8"?>
<plist version="1.0">
<dict>
    <key>ProductBuildVersion</key>
    <string></string>
    <key>ProductName</key>
    <string>Linux</string>
    <key>ProductVersion</key>
    <string>Arch Linux</string>
</dict>
</plist>
```

```sh
sudo bless --device /dev/disk0s4 --setBoot
```

Boot into Linux (hold `Alt` key when restarting).

### Xorg

- `xf86-video-intel` because we have a [Intel HD Graphics card](https://wiki.archlinux.org/index.php/Intel_Graphics) 
- `xf86-input-mtrack-git` because we want better trackpad support
- [`acpid`](https://wiki.archlinux.org/index.php/acpid) to get support for various laptop events, i.e. enabling volume,
  power/sleep/suspend, etc.
- [`xorg-xprop`](http://www.xfree86.org/current/xprop.1.html) to get info about X windows
- [`xorg-xev`](https://wiki.archlinux.org/index.php/Extra_Keyboard_Keys) to get keycodes

```sh
pacman -S xorg-server xorg-xinit xorg-server-utils xorg-xprop xorg-xev xf86-video-intel acpid
system enable acpid

yaourt -S xf86-input-mtrack-git
```

Pick default `mesa-libgl` 3D graphics library.

### i3

```
pacman -Sy i3-wm i3status i3lock
yaourt -Sy i3-dmenu-desktop
yaourt -R cmake
```

See `.i3/config` in my [dotfiles](https://github.com/thlorenz/dotfiles/blob/master/config/i3/config).

### Various other tools

- [`arandr`](http://christian.amsuess.com/tools/arandr/) `xrandr` gui front end
- [`google-talk-plugin`](https://aur.archlinux.org/packages/google-talkplugin/) needed for google hangouts
- [`alsa-utils`](http://www.linuxfromscratch.org/blfs/view/svn/multimedia/alsa-utils.html) to get `alsamixer`

```sh
pacman -S arandr
yaourt -S google-talkplugin
pacman -S htop
pacman -S alsa-utils
```
