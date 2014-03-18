<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](http://doctoc.herokuapp.com/)*

- [Setting up SmartOS on Mac with VMWare](#setting-up-smartos-on-mac-with-vmware)
	- [Install tools on Mac](#install-tools-on-mac)
	- [Launch VMWare `Version 6.0.2 (1398658)` on Mac](#launch-vmware-version-602-1398658-on-mac)
		- [Wizard starts](#wizard-starts)
		- [Machine Restarts and SmartOS launches](#machine-restarts-and-smartos-launches)
		- [After second Restart and SmartOS launch](#after-second-restart-and-smartos-launch)
	- [Login From Mac](#login-from-mac)
		- [Or add this to your `~/.ssh/config`](#or-add-this-to-your-~sshconfig)
	- [Logged into SmartOS host](#logged-into-smartos-host)
		- [Import latest zone](#import-latest-zone)
		- [Create zone](#create-zone)
			- [Get gateway](#get-gateway)
			- [Specify zone definition (`/zones/defs/base.json`)](#specify-zone-definition-zonesdefsbasejson)
				- [Notes](#notes)
			- [Create zone from SmartOS host](#create-zone-from-smartos-host)
		- [List zones from SmartOS host](#list-zones-from-smartos-host)
		- [Login to zone from SmartOS host](#login-to-zone-from-smartos-host)
	- [Login to zone from Mac](#login-to-zone-from-mac)
		- [Or add this to your `~/.ssh/config`](#or-add-this-to-your-~sshconfig-1)
		- [Inside Zone](#inside-zone)
			- [install git](#install-git)
	- [Use Virtual Box instead of VMWare](#use-virtual-box-instead-of-vmware)
	- [Resources](#resources)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Install tools on Mac

```sh
#!/usr/bin/env sh

# add brew-cask to brew
brew tap phinze/cask
brew install brew-cask

# install vmware to use as virtual machine
brew cask install vmware-fusion

# get latest smartos live image (go get some coffee, this may take a while)
curl -L https://download.joyent.com/pub/iso/latest.iso > smartos-latest.iso
```

## Launch VMWare `Version 6.0.2 (1398658)` on Mac

From `~/Applications` (`brew cask` linked it for you)

###  Wizard starts

If wizard doesn't laucnh, choose `File -> New`

- choose **More Options**
- choose **Create a custom virtual machine** -> Continue
- select `Solaris 10 64-bit` -> Continue
- choose **Create a new virtual disk** -> Continue
- Finish -> Save
- Menu: `Virtual Machine -> Connect DVD/CD`
- Menu: `Virtual Machine -> Choose Disc or Image` and select the `smartos-latest.iso` you downloaded above
- When machine starts first time (will have no OS)
  - click on **Settings** Icon (hex nut driver)
    - `Startup Disc -> CD/DVD` -> Restart

### Machine Restarts and SmartOS launches 

- choose **Live 64-bit (text)**
- `Continue with configuration` -> **Accept Default**
- `IP address (or 'dhcp')` -> **'dhcp'**
- `storage pool` -> first valid choice, i.e. **'c1t0d0'**
- `Enter root password` -> **your password**
- `Like to edit configuration file` -> **'n'**
- `Erase ALL DATA - are you sure` -> **'y'**


### After second Restart and SmartOS launch

- provide user: root, password: your password
- `ifconfig -a`, look for `e1000g0` - inet: (example: `192.168.247.130` 

## Login From Mac

    ssh root@192.168.247.130

### Or add this to your `~/.ssh/config`

```
host smartos
  User root
  Hostname 192.168.247.130 
```

and login via:

    ssh smartos

The following assumes that you have `.ssh/id_rsa.pub` key [generated on your
Mac](https://help.github.com/articles/generating-ssh-keys#step-2-generate-a-new-ssh-key).

## Logged into SmartOS host

You can follow the steps below to manually create a zone or modify [this script](https://gist.github.com/sax/3113693) in
order to have it done for you. Make sure to add `customer_metadata` or `ssh` keys won't work out of the box (you'd have
to copy them into the right locations manually).

### Import latest zone

```sh
imgadm avail | grep base64

# c353c568-69ad-11e3-a248-db288786ea63 was latest image in my case
imgadm import c353c568-69ad-11e3-a248-db288786ea63
```

### Create zone

#### Get gateway

Remember this and add to your zones definition (see Notes)

```sh
netstat -r
```

```sh
# /zones is the permanent dir, others are deleted when smartos powers off
mkdir zones/defs
vim zones/defs/base.json
```

#### Specify zone definition (`/zones/defs/base.json`)

```json
{
  "brand": "joyent",
  "ram": 512,
  "max_physical_memory": 512,
  "autoboot": true,
  "image_uuid": "c353c568-69ad-11e3-a248-db288786ea63",
  "alias": "dtrace",
  "hostname": "dtrace",
  "quota": 20, 
  "nics": [
    {
      "nic_tag": "admin",
      "ip": "192.168.247.230",
      "netmask": "255.255.255.0",
      "gateway": "192.168.247.2"
    }
  ],
  "resolvers": [
    "192.168.247.2",
    "8.8.8.8"
  ],
  "customer_metadata": {
      "root_authorized_keys": "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA8aQRt2JAgq6jpQOT5nukO8gI0Vst+EmBtwBz6gnRjQ4Jw8pERLlMAsa7jxmr5yzRA7Ji8M/kxGLbMHJnINdw/TBP1mCBJ49TjDpobzztGO9icro3337oyvXo5unyPTXIv5pal4hfvl6oZrMW9ghjG3MbIFphAUztzqx8BdwCG31BHUWNBdefRgP7TykD+KyhKrBEa427kAi8VpHU0+M9VBd212mhh8Dcqurq1kC/jLtf6VZDO8tu+XalWAIJcMxN3F3002nFmMLj5qi9EwgRzicndJ3U4PtZrD43GocxlT9M5XKcIXO/rYG4zfrnzXbLKEfabctxPMezGK7iwaOY7w== wooyay@houpla",
      "user-script" : "/usr/sbin/mdata-get root_authorized_keys > ~root/.ssh/authorized_keys ; /usr/sbin/mdata-get root_authorized_keys > ~admin/.ssh/authorized_keys"
  }
}
```

##### Notes 

- `alias` and `hostname`                   : can be whatever you like
- `nics.ip`                                : given smartos ip = '192.168.247.130' pick last '.230' randomly
- `nics.gateway`                           : smartos `netstat -r` = '192.168.247.2' (also used by resolvers)
- `customer_metadata.root_authorized_keys` : content of `.ssh/id_rsa.pub` on your Mac

#### Create zone from SmartOS host

    vmadm create -f /zones/defs/base.json

### List zones from SmartOS host 

    vmadm list

### Login to zone from SmartOS host

    zlogin zone-id

## Login to zone from Mac

Login in from your Mac should require no password since you setup an `ssh` key.

    ssh root@192.168.247.230 

### Or add this to your `~/.ssh/config`

```
host dtrace
  User root
  Hostname 192.168.247.230 
```

and login via:

    ssh dtrace

### Inside Zone

#### install git

    pkgin search git
    pkgin install git-1.8.4

[many more](https://gist.github.com/AndreasMadsen/3732950#install-some-basic-packages)

## Use Virtual Box instead of VMWare

I tried to get this working on VirtualBox, by running [this
script](http://www.perkin.org.uk/posts/pkgsrc-on-solaris.html).

I got the smartos host setup fine and was able to connect to the internet from it and `ssh` into it from my Mac. However
I was unable to connect the zone created inside of it or `ssh` into it.

The smartos guys [seem to be aware of this issue](http://wiki.smartos.org/display/DOC/SmartOS+on+VirtualBox):

> This seems to work on Windows and Linux (Ubuntu) - on OSX 10.8 this seems to not work.


There seem to be some workarounds for this issue (all are using a `Bridged Adapter` for the network connection instead
of forwarding a port via `NAT`. Although none of them solved my problem, I'm listing them here for reference:

- [How to get Solaris 11 VNICs in a Virtualbox VM to work - kind of ...](http://www.c0t0d0s0.org/archives/7520-How-to-get-Solaris-11-VNICs-in-a-Virtualbox-VM-to-work-kind-of-....html) 
- [Issues connecting to internet from localzone](http://www.kdump.cn/forums/viewtopic.php?id=900)


## Resources

- [Running SmartOS under vmware Fusion](https://gist.github.com/AndreasMadsen/3732950) - lots more resources here
- [How to create a zone ( OS virtualized machine ) in SmartOS](http://wiki.smartos.org/display/DOC/How+to+create+a+zone+%28+OS+virtualized+machine+%29+in+SmartOS)
