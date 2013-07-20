# [SmartOS](http://smartos.org/)

- specialized [Type 1 Hypervisor](http://en.wikipedia.org/wiki/Hypervisor) platform based on
  [illumos](http://en.wikipedia.org/wiki/Illumos).

## illumos

- unix like derives from [OpenSolaris](http://en.wikipedia.org/wiki/OpenSolaris)
- OpenSolaris derives from [UNIX System V](http://en.wikipedia.org/wiki/UNIX_System_V),
  [R4](http://en.wikipedia.org/wiki/SVR4) and [Berkeley Software
  Distribution](http://en.wikipedia.org/wiki/Berkeley_Software_Distribution)

## Virtualization 

### Two types of virtualization supported

- **OS Virtual Machines** (Zones): A light-weight virtualization solution offering a complete and secure userland
  environment on a single global kernel, offering true bare metal performance and all the features Illumos has, namely
  dynamic introspection via DTrace
- **KVM Virtual Machines**: A full virtualization solution for running a variety of guest OS's including Linux, Windows,
  BSD, Plan9 and more

### Virtualization is built on top of illumos technologies inherited from OpenSolaris

- [ZFS](http://wiki.smartos.org/display/DOC/ZFS) for storage virtualization
- Crossbow (dladm) for [network virtualization](http://wiki.smartos.org/display/DOC/Networking+and+Network+Virtualization)
- [Zones](http://wiki.smartos.org/display/DOC/SmartOS+Virtualization) for virtualization and containment
- [DTrace](http://wiki.smartos.org/display/DOC/DTrace) for introspection
- [SMF](http://wiki.smartos.org/display/DOC/Basic+SMF+Commands) for service management
- RBAC/BSM for auditing and role based security
- more

## Installation

- [download](http://wiki.smartos.org/display/DOC/Download+SmartOS)
- typically from OS on USB key by booting it
- first boot configures base networking, root password, disks to use to create ZFS Zpool (persistent storage)

### [SmartOS on VirtualBox](http://wiki.smartos.org/display/DOC/SmartOS+on+VirtualBox)

- [applicance](https://dl.dropbox.com/u/2265989/SmartOS/SmartOS.ova)

## Managing VMs

- logging into SmartOS enters 'global zone'
- download VM Images (imgadm tool) which are pre-configured OS and KVM virtual machines
- manage VMs via vmadm tool


## Resources

## Guides

- [managing a smartmachine](http://wiki.joyent.com/wiki/display/jpc2/Managing+a+SmartMachine)

### CheatSheets

- [linux to smartos](http://wiki.joyent.com/wiki/display/jpc2/The+Joyent+Linux-to-SmartOS+Cheat+Sheet)
- [system and user dirs](http://wiki.joyent.com/wiki/display/jpc2/Where+to+Find+Things)

### Videos

- [smartos operations](http://www.youtube.com/watch?v=96PGoXHli3Q&feature=player_embedded)
- [smartos for sysadmins](http://www.youtube.com/watch?v=dxZExLeJz2I&feature=player_embedded)
