## Steps

Follow [these instructions](http://codylittlewood.com/arch-linux-on-macbook-pro-installation/)
interspersed with adaptations/additions from [this gist](https://gist.github.com/denji/6530540)

## Adaptations

### Bootloader 

Remove `-C` command for `grub-mkstandalone` to get the following:

```sh
grub-mkstandalone -o boot.efi -d usr/lib/grub/x86_64-efi -O x86_64-efi boot/grub/grub.cfg
```

### Xorg

In case we have an [Intel HD Graphics card](https://wiki.archlinux.org/index.php/Intel_Graphics) and want better
trackpad support change the pacman install to the following:

```sh
pacman -S xorg-server xorg-xinit xorg-server-utils  xf86-video-intel acpid
system enable acpid

yaourt -S xf86-input-mtrack-git
```

Pick default `mesa-libgl` 3D graphics library.

### i3

```
pacman -Sy i3-wm i3status i3lock
yaourt -Sy j4-dmenu-desktop
yaourt -R cmake
```

#### Get useful configs

Most of these are part of dotfiles now

[various, but notably i3 config](git clone http://github.com/gotbletu/shownotes) 
