# setting up arch on top of manjaro

## pacman installs

    sudo pacman -Syu
    sudo pacman -Sy vim
    sudo pacman -Sy git
    sudo pacman -S chromium
    sudo pacman -S flashplugin
    sudo pacman -S base-devel
    sudo pacman -S yaourt
    sudo pacman -S synapse
    sudo pacman -S the_silver_searcher
    sudo pacman -S autojump
    sudo pacman -S hexchat

## public ssh

    mkdir -p .ssh && ssh-keygen -t rsa -C thlorenz.gmx.de

## reverse scrolling

[wiki](https://wiki.archlinux.org/index.php/xmodmap)

### `~/.Xmodemap`:

    pointer = 1 2 3 5 4 7 6 8 9 10 11 12 13 14 15

### `~/.xinitrc`

    if [ -s ~/.Xmodemap ]; then
        xmodmap ~/.Xmodemap
    fi

## map caps to ctrl

Find all mappings inside: `/usr/share/X11/xkb/rules/base.lst`

### `~/.xinitrc

Make Caps Lock an additional Ctrl

    setxkbmap -option caps:ctrl_modifier

## touchpad

[wiki](https://wiki.archlinux.org/index.php/MacBook#Touchpad)

    yaourt -S xf86-input-mtrack-git 

### configure

Edit `etc/X11/xorg.conf` and add options listed in [package readme](https://github.com/BlueDragonX/xf86-input-mtrack).

```
Section "InputClass"
	MatchIsTouchpad    "on"
	Identifier         "Touchpads"
	Driver             "mtrack"
	Option             "Sensitivity"           ".50"
	Option             "TapButton1"            "1"
	Option             "TapButton2"            "3"
	Option             "TapButton3"            "2"
	Option             "ScrollDistance"        "100"
	Option             "FingerHigh"            "8"
	Option             "FingerLow"             "8"
	Option             "IgnoreThumb"           "true"
	Option             "IgnorePalm"            "true"
EndSection
```

## bluetooth

### Install Needed packages

    sudo pacman -S bluez bluez-utils

## Enable bluetoot and start it

    sudo hciconfig hci0 up # sometimes needed only
    sudo systemctl enable bluetooth
    sudo systemctl start bluetooth

### bluetoothctl tool

[wiki](https://wiki.archlinux.org/index.php/bluetooth)

    > agent on
    > default-agent
    > scan on

#### Pairing **Apple Magic Trackpad** has it's problems (I failed).

More information is [here](https://wiki.ubuntu.com/Multitouch/AppleMagicTrackpad). Tried `hcitool` (*Using the command
line*) with similar results.

The problem is that the device doesn't get discoverd.

Adding the below to my `X11/xorg.conf` didn't help either:

```
Section "InputClass"
  Identifier "Magic Trackpad"
  MatchUSBID "05ac:030e"
  Driver "synaptics"
  Option "SHMConfig" "True"
EndSection

```

Other bluetooth devices were discovered just fine.

## nodejs
    
    pacman -S nodejs
    mkdir .npmglobal && npm config set prefix ~/.npmglobal
