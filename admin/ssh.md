<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](http://doctoc.herokuapp.com/)*

- [Config SSH](#config-ssh)
	- [Local Station](#local-station)
	- [Remote Machine](#remote-machine)
		- [SSH config](#ssh-config)
		- [Reload ssh](#reload-ssh)
		- [Local Station](#local-station-1)
		- [Making ssh safer](#making-ssh-safer)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Config SSH

Follow steps given [here](http://articles.slicehost.com/2010/10/18/ubuntu-maverick-setup-part-1)

## Local Station

    mkdir ~/.ssh
    ssh-keygen -t rsa

    scp ~/.ssh/id_rsa.pub user@target:

## Remote Machine
    
    sudo mkdir ~user/.ssh
    sudo mv ~user/id_rsa.pub ~user/.ssh/authorized_keys

    sudo chown -R user:user ~user/.ssh
    sudo chmod 700 ~user/.ssh
    sudo chmod 600 ~user/.ssh/authorized_keys

### SSH config
    
Change port in config:

    sudo vim /etc/ssh/sshd_config 

### Reload ssh
    `sevice reload ssh` or `/etc/init.d/ssh reload` 

### Local Station

    ssh -p port user@url

### Making ssh safer

Mainly by tweaking `/etc/ssh/sshd_config`.

[resource](http://www.nixtutor.com/linux/installing-and-configuring-an-ssh-server/)
