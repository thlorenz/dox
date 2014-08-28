<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](http://doctoc.herokuapp.com/)*

- [User and Group management](#user-and-group-management)
  - [Users](#users)
    - [`/etc/passwd` format](#etcpasswd-format)
    - [useradd](#useradd)
    - [usermod](#usermod)
    - [userdel](#userdel)
  - [Groups](#groups)
    - [addgroup](#addgroup)
    - [delgroup](#delgroup)
      - [Resources](#resources)
- [Programs and processes](#programs-and-processes)
  - [System Services](#system-services)
    - [Killing running services](#killing-running-services)
  - [Process management](#process-management)
    - [Listing processes](#listing-processes)
    - [Killing Processes](#killing-processes)
    - [Further Reading](#further-reading)
  - [Memory Management](#memory-management)
    - [System Memory Usage](#system-memory-usage)
  - [Managing System Logs](#managing-system-logs)
- [Linux File System](#linux-file-system)
  - [Partitions](#partitions)
    - [Partition Types](#partition-types)
    - [Swap Partition](#swap-partition)
  - [Filesystems](#filesystems)
    - [Creating Filesystems](#creating-filesystems)
    - [Checking Filesystems](#checking-filesystems)
    - [Mounting Filesystems](#mounting-filesystems)
      - [`mount` options](#mount-options)
    - [What devices are mounted?](#what-devices-are-mounted)
    - [Unmounting Filesystems](#unmounting-filesystems)
    - [Remounting Filesystems](#remounting-filesystems)
  - [`/etc/fstab`](#etcfstab)
  - [Directory structure](#directory-structure)
  - [Pseudo devices](#pseudo-devices)
    - [Devices Files](#devices-files)
  - [`/proc` Filesystem](#proc-filesystem)
    - [Show process information](#show-process-information)
    - [Show meminfo](#show-meminfo)
    - [Show ioports](#show-ioports)
  - [Files and inodes](#files-and-inodes)
    - [EXT3 filesystem](#ext3-filesystem)
    - [Inodes](#inodes)
    - [Symbolic and hard links](#symbolic-and-hard-links)
      - [Symbolic links](#symbolic-links)
      - [Hard links](#hard-links)
  - [Compression and archiving](#compression-and-archiving)
    - [tar](#tar)
    - [rar and zip](#rar-and-zip)
- [System administration tools](#system-administration-tools)
  - [Superuser](#superuser)
  - [System verification and maintenance](#system-verification-and-maintenance)
    - [Disk and memory tools](#disk-and-memory-tools)
    - [Package management](#package-management)
  - [Files and permissions](#files-and-permissions)
    - [Files](#files)
    - [Directories](#directories)
    - [Octal representation](#octal-representation)
    - [Changing permissions](#changing-permissions)
    - [Default mode and `umask`](#default-mode-and-umask)
    - [Changing ownership and group](#changing-ownership-and-group)
    - [Find files associated with particular user](#find-files-associated-with-particular-user)
    - [setuid and setgid bit](#setuid-and-setgid-bit)
      - [Find files with `setuid` or `setgid` set](#find-files-with-setuid-or-setgid-set)
- [System services](#system-services)
  - [Startup init](#startup-init)
    - [Further Reading](#further-reading-1)
- [Installing Libraries/Binaries](#installing-librariesbinaries)
  - [List Dependencies of a Binary with ldd](#list-dependencies-of-a-binary-with-ldd)
- [Transfer files using netcat and tar](#transfer-files-using-netcat-and-tar)
  - [linux to linux](#linux-to-linux)
  - [mac to linux](#mac-to-linux)
- [Scheduling Recurring Jobs using cron](#scheduling-recurring-jobs-using-cron)
  - [Resources](#resources-1)
  - [Resource](#resource)
- [Managing installed libraries](#managing-installed-libraries)
  - [Managing dependencies](#managing-dependencies)
  - [Shared libraries](#shared-libraries)
    - [Shared static libraries](#shared-static-libraries)
    - [Shared dynamic libraries](#shared-dynamic-libraries)
- [General](#general)
  - [Further Reading](#further-reading-2)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# User and Group management

## Users 

- stored inside `/etc/passwd`
- may edit that file to manage users or do it via one of the below commands

### `/etc/passwd` format

Example:

```
www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
```

```
# username  : password :  uid : gid : user id info  : home dir  : command shell
  www-data  : x        :  33  : 33  : www-data      :/var/www   : /usr/sbin/nologin
```


### useradd

Creates new user account with default settings

- `useradd [configurations] username`
- Example: 

    `useradd --shell /sbin/nologin --home-dir /usr/local/nginx nginx`
- nologin denies user shell access (used for accounts destined to be running a service)
- default adduser settings inside `/etc/adduser.conf`

### usermod

- allows later modification of user (e.g., password)
- e.g., give shell access: `usermod --shell /bin/bash nginx`

### userdel

- allows deleting user (-r switch will wipe his home directory)

## Groups

- stored in `/etc/group`
- allows users of a group to inherit all its access permissions on files and directories
- user account belongs to at least user's primary group

### addgroup

- adds up to two groups with given name
- add user to group `usermod --append --groups groupname username`

### delgroup

- removes group (remove all users from group first)

#### Resources

- [how to setuid and gid](http://linuxg.net/how-to-set-the-setuid-and-setgid-bit-for-files-in-linux-and-unix/)
- [ArchWiki - Users and groups](https://wiki.archlinux.org/index.php/users_and_groups)
- [nixCraft - Understanding /etc/passwd File Format](http://www.cyberciti.biz/faq/understanding-etcpasswd-file-format/)

# Programs and processes

## System Services

- applications running in the background (can be started in background via `&` after command)
- scripts that manage service startup and shutdown placed in several dirs, most common `/etc/init.d`
- commands given to init scripts (but not always implemented) `start, stop, restart, reload, status`
- `service --status-all` lists all system services and their status
- `service <name> <command>` allows controlling (e.g., starting, stopping) services

### Killing running services

Most daemons add a `.pid` entry to `/var/run`, so to kill xyz do:

    kill -HUP `cat /var/run/xyz.pid`

## Process management

### Listing processes

- `ps aux` lists all currently running processes
- `ps -C pname` lists all processes whose names contain `pname`
- `top` or `htop` show all currently running processes sorted by CPU usage and refreshes every second

### Killing Processes

- `kill pid` e.g., `kill 111` sends kill signal to process (process may ignore it)
- `kill -9 pid` forces process to terminate
- `killall processname` kills all processes with given name

### Further Reading

- [Different ways of showing Unix processes](http://www.cyberciti.biz/faq/show-all-running-processes-in-linux/)
- [htop examples](http://www.thegeekstuff.com/2011/09/linux-htop-examples/)
- [Linux System Monitoring Tools](http://www.cyberciti.biz/tips/top-linux-monitoring-tools.html)

## Memory Management

### System Memory Usage

    free

Reports used memory and swap space.

## Managing System Logs

Daemon `syslogd` logs various kinds of system activity to locations controlled by `/etc/syslog.conf`.

On some distros like arch linux this was replaced by [Journal](https://wiki.archlinux.org/index.php/systemd#Journal)
which is configured via `/etc/systemd/journald.conf`.

# Linux File System

## Partitions

First sector of disk is master boot record with a partition table (info about locations/sizes of partitions).

### Partition Types

- primary, used most often, but partion table size is limited -> only 4 partitions supported
- extended, holds no data, but acts as container for **logical** partitions

### Swap Partition

Needed to support Memory swapping and hybernation.

Create and turn on via (`-c` says swap for bad blocks)

    mkswap -c /dev/hda3 
    swapon /dev/hda3 

Linux also supports swap files (usually not as performant).
    
    dd if=/dev/zero of=/swap bs=1024 count=32768

## Filesystems

Detect what file systems a kernel supports:

    cat /proc/filesystems

### Creating Filesystems

To support different file systems specify this when building kernel.

    mkfs -t type device
    mkfs -t ext2 /dev/fd0

Or create via one of the `mk*` commands, so to create an `ext3fs` filesystem do

    mke2fs -j -c /dev/hda2
    
- `-j` stands for journaled (keeps track of changes made to file system to make it easier/faster to restore corrupted
  filesystem)

### Checking Filesystems

    fsck -t type device
    fsck -t ext3 /dev/hda2

### Mounting Filesystems

    mount -t type device    mount-point
    mount -t ext3 /dev/hda2 /mnt

Non sudo users can only mount devices listed in `/etc/fstab` with user option. In that case only device **or**
mountpoint needs to be given, i.e.:

    mount /cdrom

Mount all devices listed in `/etc/fstab` that have `noauto` option

    mount -a

Kernel mounts filesystem directly at boot time, therefore the device containing the root filesystem is coded into the
kernel image which can be altered via `rdev`.

#### `mount` options

`mount` has many more options turned on via `-o`

Auto convert text files from MSDOS `cr-lf` to UNIX `\n`:

    mount -o conv=auto -t msdos /dev/fd0 /mnt

Mount a device as readonly (CD-ROM):

    mount -o ro -t iso9660 /dev/cdrom /mnt

### What devices are mounted?

    mount

### Unmounting Filesystems

Specific device:

    umount /dev/fd0

All devices mounted on a particular directory:

    umount /mnt

### Remounting Filesystems

Remount a filesystem previously mounted as readonly as read/write:

      mount -o remount rw /mnt

## `/etc/fstab`

Contains entry for each filesystem that is to be mounted at boot time:
  
    # device     mount-point    type    options
    /dev/hda2     /             ext3    defaults

Options are comma-separated list to use with `mount -o`, including `defaults` is recommended

## Directory structure

- **/bin and /sbin**    binaries and system binaries respectively
- **/boot**             files used during system boot
- **/dev**              Devices (e.g., cdrom)
- **/home**             home directories for all users except root
- **/lib**              libraries required by binaries in **bin** and **sbin**
- **/media**            acess removable media using mount points
- **/mnt**              temporarily mounted file systems
- **/opt**              optional software packages (rarely used)
- **/proc**             kernel and process information virtual filesystem (statistics and details about running processes)
- **/root**             root user home directory
- **/srv**              service data (rarely used)
- **/tmp**              temporary files not to be preserved beyond program execution
- **/usr**              mirrors root directory structure to provide secondare hierarchy for shareable read-only user data
- **/var**              files that are expected to be modified by running applications or services
    - **/lib**          state information related to apps or the OS (e.g., MySql database files)
    - **/lock**         files used for synchronized resource access between applications
    - **/log**          log files generated by programs, services or system kernel
    - **/mail**         shortcut to /var/spool/mail
    - **/run**          runtime data, provides info about state of the system since it started (cleared on reboot)
    - **/spool**        files to be processed (e.g., emails and print jobs)
    - **/tmp**          temporary files deleted on reboot

## Pseudo devices

- **/dev**
    - **/null**          Null device: writing is always successful, reading returns no data (use to redirect/hide output)
    - **/random**        stream of true rambom numbers (write to it to feed pool)
    - **/urandom**       stream of pseudo random numbers (write to it to feed pool)
    - **/full**          returns error when written to and reads infinite stream of null characters
    - **/zero**          always successful when written to and reads infinite stream of null characters

### Devices Files

Allow user programs to access hardware devices thought the kernel, by making them look like files from the program's
point of view. Fle operations are supported although they really are devices.

- `b` permissions flag indicates block devices (i.e. hard drives where block size is determined and thus allows random access)
- `c` permissions flag indicates character devices (i.e. serial port)

    ls -l /dev
    
## `/proc` Filesystem

Contains system information represented as directory/file structure which is dynamically generated.

Most system report tools use the information found here.

### Show process information

    ls /proc

Each number represents a running process into which we can probe:

    ls  /proc/459
    cat /proc/459/status

### Show meminfo

    cat /proc/meminfo

`free` uses that info and just rearranges it a bit

### Show ioports

    cat /proc/ioports

## Files and inodes

### EXT3 filesystem 

- has 16 terabytes/file and 32 terabytes/device restrictions 
- lays out data so that file fragmentation is kept to minimum, hence no defragmentation is needed
- filenames up to 256 characters are case sensitive

### Inodes

- index nodes store extra information about a file (e.g., file permissions, ownership, filesize, access/modification times)
- `ls -i` retrieves inode number
- timestamps (use `stat` to retrieve them)
    - atime: Access time (last time read)
    - mtime: Modification time (last time file content changed)
    - ctime: Change time (last time file content or inode data changed)

### Symbolic and hard links

#### Symbolic links

- `ln -s target link` 
- read and write access is performed on the target of the link
- `rm` performed on link doesn't affect target
- may connect via relative paths

#### Hard links

- `ln target link`
- represent actual connections to file data
- once last link to target is removed, target is removed as well
- if target is removed, link remains

## Compression and archiving

### tar

- extension represents .gathering.compression algorithm/method
- .tar.gz (Gzip) and .tar.bz2 (bzip2) favored since they are open source
- tar (Tape archive) concatenates multiple files into one tarball and optionally compresses it
- `tar czvf archive.tar.gz folder` creates Gzip tar file
- `tar cjvf archive.tar.bz2 folder` creates bzip2 tar file
- `tar xzvf archive.tar.gz` extracts Gzip tar file
- `tar xjvf archive.tar.gz` extracts bzip2 tar file

### rar and zip

- `unrar x file.rar`
- `unzip file.zip`

# System administration tools

## Superuser

- `su` logs in as root
- `su -` logs in as root and execute root's configuration files
- `su andy` logs in as andy
- `su - andy` logs in as andy and execute andy's configuration files
- `sudo command` executes command with superuser account
- users allowed to gain root privileges are in `/etc/sudoers` (edit it via **visudo**)

## System verification and maintenance

### Disk and memory tools

- `df -h` Disk Free shows available storage on mounted devices
- `du -h` Disk Usage shows space occupied by each folder in given directory
- `free -m` displays current system memory usage, swap memory stats and buffers used by the system 

### Package management

Manually download and install debian package via:

    wget ftp://.../name.deb
    sudo dpkg -i name.deb

note, that this doesn't process dependencies

Build from source via (consult readme file after download):

    wget http://../name.tar.gz
    tar zxvf name.tar.gz
    cd name
    ./configure
    make
    sudo make install

## Files and permissions

### Files

- three access types (**r**ead, **w**rite, e**x**ecute)
- columns `drwx|rwx|rwx`
    - first character (-: file, d: directory, l: link)
    - first column: owner permissions
    - second column: group permissions
    - third column: other user's permissions

### Directories

- **x** specifies folder entry permission
- **r** specifies list folder content permission
- **w** specifies writing of new files in folder permission

### Octal representation

- three to four digits (no permissions 0..7 all permissions) map to permission columns (above)
- each digit has weight: (r=1, w=2, x=4), add them to get octal presentation
- use `chmod ugo` octal to reset permissions for everyone (e.g., `chmod 744` - owner=all, everyone else=x permissions)

### Changing permissions

- `chmod who+/-what filename`
    - who: combination of **u**ser/owner, **g**roup, **o**thers and **a**ll
    - +/-: grant/remove permissions
    - what: **r**ead, **w**rite and e**x**ecute
- `chmod go-rwx file` only owner has access to file
- `chmod a-w file` nobody can edit file
- `chmod -R g+rx folder` folder can be accessed by all users in the group (applied recursively)

### Default mode and `umask`

Set default mode for each file that is created by executing `umask` command, i.e inside `.bashrc`.

Meaning of bits are inverted from the meanings applied to `chmod` command. Determine the access you want and substract
`7` from each digit to get the 3 digit mask.

Set default permissions `750`:

    umask 027

### Changing ownership and group

- `chown user filename` changes file's owner
- `chgrp group filename` changes file's group
- `chown user:group filename` alternative syntax to change both owner and group
- commands accept `-R` switch

### Find files associated with particular user

    find /usr -user username -ls

### setuid and setgid bit

Causes the program to be executed with the permissions of the owner of that file.

Add `setuid` bit (applies to user)

    chmod u+s /path/to/file

Add `setgid` bit (applies to group)

    chmod g+s /path/to/file

#### Find files with `setuid` or `setgid` set

    find /usr -type f -perm /6000 -exec stat -c "%A %a %n" {} \;

Find only the files with setuid

    find /usr -type f -perm /4000

Find only the files with setgid

    find /usr -type f -perm /200-

# System services

## Startup init

- System-V style init daemon uses `init` daemon to manage startup process
    - funcions on `runlevels` principle
        - 0: System is halted
        - 1: Single-user (rescue) mode
        - 2: Multiuser mode (without NFS support)
        - 3: Full multiuser mode
        - 4: Not used
        - 5: GUI mode
        - 6: System reboot
    - can be manually invoked via `telinit runlevel` (e.g., `telinit 6` to reboot)
    - set of services execute for each **runlevel transition**
    - on startup level goes from 0 to 2 (Debian and Ubuntu)
    - each runlevel has scripts folder associated with it (/etc/rc0.d ../etc/rc6.d) with links to scripts in `/etc/init.d`
- init script controls daemon application via **start** (invoked when computer
  starts), **stop** and can be manually executed via: `service name command` or `/etc/init.d/name command`
- enable init script for system runlevel (after adding it to /etc/inid.d/): `update-rc.d -f name defaults`
    - creates links in default runlevel folders
    - script will execute with **stop** for **reboot** and **shut[down** and with **start** for **all other runlevels**
- show and switch on/off enabled init scripts via `rcconf` tool

### Further Reading

- sample script for [installing a virtual box as a service](http://www.glump.net/howto/virtualbox_as_a_service)
- [update-rc.d explained](http://www.debuntu.org/how-to-manage-services-with-update-rc.d)

# Installing Libraries/Binaries

## List Dependencies of a Binary with ldd

ldd prints shared library dependencies of a binary:
`ldd /path/to/binary`


# Transfer files using netcat and tar

## linux to linux

Source:

    tar -cz . | nc -q 10 -l -p 45454

Target:

    nc -w 10 $SOURCE_HOST 45454 | tar -xz
    
## mac to linux

I modified the above steps slightly to make this work when a Mac (BSD Unix) is the source.

Source:

    tar -cz . | nc -l 45454
    
Target:

    nc -w 10 $SOURCE_HOST 45454 | tar -xz

# Scheduling Recurring Jobs using cron

## Resources

- [Running Linux, 5th Edition](http://www.amazon.com/Running-Linux-Matthias-Kalle-Dalheimer/dp/0596007604) pages 688-698
- [howto add jobs to cron](http://www.cyberciti.biz/faq/how-do-i-add-jobs-to-cron-under-linux-or-unix-oses/)
- [cron examples](http://www.thegeekstuff.com/2009/06/15-practical-crontab-examples/)

## Resource

[explanation on how to do this for two linux machines](http://superuser.com/a/326218/35373)

# Managing installed libraries

## Managing dependencies

List libs an executable depends on:

    ldd /usr/bin/tty

Regenerate library cache:

    ldconfig

which updates `/etc/ld.so.cache`

## Shared libraries

Each shared library is present in two different files on a system.

### Shared static libraries

- statically linked (routines are copied into the executable)
- inside `/usr/lib` 

### Shared dynamic libraries

- dynamically linked (**stub** routines are copied so `ld.so` can find them later)
- inside `/lib`
- on execution `ld.so` copies routines from shared lib into memory

# General

## Further Reading

- [Set operation in Unix cheatsheet](http://www.catonmat.net/download/setops.pdf) 
- [Running Linux, 5th Edition](http://www.amazon.com/Running-Linux-Matthias-Kalle-Dalheimer/dp/0596007604)

