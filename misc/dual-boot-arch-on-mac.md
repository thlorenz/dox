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
  - [Audio](#audio)
  - [Developer Tools](#developer-tools)
    - [Vim with python and ruby support](#vim-with-python-and-ruby-support)
- [Wifi](#wifi)
  - [SSD](#ssd)
- [Power](#power)
  - [Hibernate/Suspend](#hibernatesuspend)
- [Autologin](#autologin)
- [Development Tools](#development-tools)

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

- `dialog` and `wpa_supplicant` are needed to launch `wifi-menu` from the installed arch in order to get wifi initially


Edit fstab to make SSD drive work properly and add `tmpfs` entry:

```
# <file system>	      <dir>	      <type>	      <options>	                              <dump>	<pass>

/dev/sda5           	/boot     	ext2      		defaults,relatime,stripe=4		          0         2
/dev/sda6           	/         	ext4      		defaults,noatime,discard,data=writeback	0         1
/dev/sda7           	/home     	ext4      		defaults,noatime,data=ordered		        0         2
/dev/sda8           	none      	swap      		defaults  				                      0         0
tmpfs			           /dev/shm 	  tmpfs		      defaults,noatime,nodev,nosuid,noexec,size=2G		0 0
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

## Xorg

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

## i3

```
pacman -Sy i3-wm i3status i3lock
yaourt -Sy i3-dmenu-desktop
yaourt -R cmake
```

See `.i3/config` in my [dotfiles](https://github.com/thlorenz/dotfiles/blob/master/config/i3/config).

## Various other tools

- [`arandr`](http://christian.amsuess.com/tools/arandr/) `xrandr` gui front end
- [`google-talk-plugin`](https://aur.archlinux.org/packages/google-talkplugin/) needed for google hangouts
- [`alsa-utils`](http://www.linuxfromscratch.org/blfs/view/svn/multimedia/alsa-utils.html) to get `alsamixer`
- [`terminator`]() terminal that supports `UTF-8` properly out of the box (we'll set it to not show titles) [see
  here](https://github.com/thlorenz/dotfiles/blob/master/config/terminator/config)
- [`xflux`](https://justgetflux.com/) adapts computer's display to time of day

```sh
pacman -S arandr
yaourt -S google-talkplugin
pacman -S alsa-utils
pacman -S terminator
pacman -S xflux
pacman -S git
pacman -S chromium
yaourt -S chromium-libpdf
pacman -S flashplugin
```

### Audio

```sh
pacman -S pulseaudio pulseaudio-alsa pavucontrol
```

### Developer Tools

- [iotop](http://www.cyberciti.biz/hardware/linux-iotop-simple-top-like-io-monitor/) watches I/O usage
- [ncdu](http://mylinuxbook.com/ncdu-ncurses-based-disk-usage-utility/) curses based disk usage util
- [silver-searcher](https://github.com/ggreer/the_silver_searcher) ag (ack/grep replacement)
- [clang](https://wiki.archlinux.org/index.php/Clang) includes `clang` and `clang++`
- clang-analyzer provides `scan-build`
- [valgrind](http://valgrind.org/) checks for memory leaks
- [ctags](http://ctags.sourceforge.net/) exuberant ctags -- clang-complete support
- [libclang-dev]() (not available on arch??) -- clang-complete support
- jshint to support vim syntastic JavaScript errors
- [pygments](http://pygments.org/) to make our `c` command work (syntax highlighting `cat`)
- [ccache](https://wiki.archlinux.org/index.php/ccache) caches compilation results to speed things up
  - works with `g++`, but also [works with clang](http://petereisentraut.blogspot.com/2011/05/ccache-and-clang.html)


```
pacman -S iotop ncdu gnu-netcat silver-searcher-git
pacman -S clang clang-analyzer
pacman -S valgrind
pacman -S ctags

pacman -S ccache

mkdir -p ~/npm-global
npm config set prefix '~/npm-global'
npm install -g jshint

pacman -S python-pip
sudo pip install Pygments
```

#### Vim with python and ruby support

```sh
pacman -S abs
sudo abs extra/vim
mkdir ~/abs && cd abs
cp -r /var/abs/vim . && cd vim
```

Change `--disable-python` and ruby options to enable and remove lua dependency among other tweaks.
Change `--with-x` in order to get clipboard support.

```
    --with-x=yes \
    --enable-pythoninterp \
    --disable-python3interp \
    --enable-rubyinterp \
```

```sh
vim PKGBUILD
pacman -S ruby
makepkg
sudo pacman -U vim-runtime-7.4.214-1-x86_64.pkg.tar.xz
sudo pacman -U vim-7.4.214-1-x86_64.pkg.tar.xz 

vim --version # will have +python and + ruby
```

## Wifi

Preinstalled `wifi-menu` allows connecting manually, but in order to automate this, we'll install
[`netctl`](https://wiki.archlinux.org/index.php/netctl) and configure it.

Assuming we connected before `wifi-menu` already included a config for us inside `/etc/netctl/`.
If not, we can copy an example: `cp /etc/netctl/examples/wireless-wpa /etc/netctl/my-profile`

```sh
sudo pacman -S netctl

# list all available proviles
sudo netctl list

# try it
sudo netctl start my-profile

# a) just enable a profile and it'll be used when available
sudo netctl enable my-profile

# b) setup automatic switching of profiles

sudo pacman -S wpa_actiond
sudo systemctl enable netctl-auto@wifi-interface
```

### SSD

Edit `/etc/udev/rules.d/60-schedulers.rules`:

```
# Set deadline scheduler for non-rotating disks
ACTION=="add|change", KERNEL=="sda", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="deadline"
```

## Power

Most came [from here](https://gist.github.com/denji/6530540)

- [`macfanctld-git`](http://adrian15sgd.wordpress.com/tag/macfanctl/) to enable laptop fans
- [`laptop-mode-tools`](https://wiki.archlinux.org/index.php/Laptop_Mode_Tools) laptop power savings package
  - [`cpupower`](https://www.archlinux.org/packages/community/x86_64/cpupower/) examines and tunes processor power
    savings
  - [`pm-utils`](https://wiki.archlinux.org/index.php/Pm-utils) suspend and powerstate setting framework
  - [`powertop`](https://wiki.archlinux.org/index.php/Powertop) enables various powersaving modes in userspace and
    give info about which processes are using CPU and wake it from idling
- [`profile-sync-daemon`](https://wiki.archlinux.org/index.php/profile-sync-daemon) manages browserprofile syncing to
  harddrive to make it more efficient
- [`anything-sync-daemon`](https://wiki.archlinux.org/index.php/Anything-sync-daemon) same as `profile-sync-daemon` but
  used for anything but browsers
- [`granola`](https://aur.archlinux.org/packages/granola/) intelligent power management
- [`uswsusp`](https://wiki.archlinux.org/index.php/Uswsusp) software suspend (hibernation/standby)

```sh
yaourt -S macfanctld-git
systemctl enable macfanctld.service
```

```sh
sudo pacman -S cpupower pm-utils
yaourt -S laptop-mode-tools profile-sync-daemon anything-sync-daemon uswsusp-git
sudo systemctl enable laptop-mode
sudo systemctl enable cpupower
sudo systemctl enable psd
sudo systemctl enable psd-resync
sudo systemctl enable asd
sudo systemctl enable asd-resync
```

- edit `/etc/psd.conf` and add `USERS` and `BROWSERS`
- edit `/etc/asd.conf` and add at least one location to sync
- edit `/etc/laptop-mode/laptop-mode.conf` with value `LM_BATT_MAX_LOST_WORK_SECONDS=15`
- edit `/etc/laptop-mode/conf.d/usb-autosuspend.conf` with value `AUTOSUSPEND_TIMEOUT=1`
- edit `/etc/laptop-mode/conf.d/intel-hda-powersave.conf` with value `INTEL_HDA_DEVICE_TIMEOUT=1`

### Hibernate/Suspend

In order to hibernate/suspend without passwd add the following to the `/etc/sudoers` file (assuming your user belongs to
`wheel`):

```
%wheel ALL=NOPASSWD: /usr/sbin/pm-hibernate
%wheel ALL=NOPASSWD: /usr/sbin/pm-suspend
```

Unfortunately external thunderbolt monitors don't survive suspending.

## Autologin

Edit: `/etc/systemd/system/getty@tty1.service.d/autologin.conf`

```
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin username --noclear %I 38400 linux
```

## Development Tools


