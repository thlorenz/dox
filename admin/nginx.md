<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](http://doctoc.herokuapp.com/)*

- [Nginx](#nginx)
	- [Users and permissions](#users-and-permissions)
	- [Testing configuration](#testing-configuration)
	- [Controlling daemon](#controlling-daemon)
	- [Configuration](#configuration)
	- [Modules overview](#modules-overview)
		- [Core module](#core-module)
		- [Events module](#events-module)
		- [Configuration module](#configuration-module)
	- [Adapting setups](#adapting-setups)
	- [Performance](#performance)
	- [HTTP Configuration](#http-configuration)
		- [HTTP Core module](#http-core-module)
			- [Server block](#server-block)
			- [Location block](#location-block)
- [Sample Setup](#sample-setup)
	- [Install](#install)
	- [Control](#control)
	- [Configuration](#configuration-1)
		- [General](#general)
			- [Edits made (defaults of current nginx version match suggested settings mostly)](#edits-made-defaults-of-current-nginx-version-match-suggested-settings-mostly)
		- [Yesod specific](#yesod-specific)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Nginx 

## Users and permissions

- master process runs as **root** in order to make standard ports (e.g., 80, 443) accessible
- worker processes run as **www-data** (or any other customized user and group)

## Testing configuration

- `nginx -t` checks current config file for syntax, validity or integrity errors
- `nginx -t -c name.conf` checks specific file
- follow by `nginx -s reload` to start using edited config file

## Controlling daemon

- direclty via `nginx -s <signal>`, signal being:
    - **stop** send TERM signal
    - **quit** send QUIT signal
    - **reopen** reopen logs
    - **reload** reload configuration 
- sending signal causes the config file to be parsed and potentially errors thrown

## Configuration

- default path to configuration file: `/etc/nginx/nginx.conf`
- `nginx -V` shows version and configure options
- `nginx -c name` sets configuration file
- `nginx -g "directive"` specify additional configuration directives not included in configuration file

## Modules overview

### Core module

- `error log /file/path level;` (level: debug, info, notice, warm, error, crit)
- `master_process [on|off];` if off, nginx works with unique process (use for testing)
- `user username <groupname>` define user account and optionally user group for worker processes
- `worker_threads num;` amount of threads per worker

### Events module

- configure network mechanisms (may affect appliciation's perfomnace)
- `worker_connections num;` amount of connections a worker process may treat simultaneously

### Configuration module

- enables file inclusions
- `include file` inserts content of file at exact location of inclusion
- multi file inclusion, e.g, `include sites/*.conf`

## Adapting setups

- worker processes should match number of cores in CPU

## Performance

- `httperf --server <address> --port <num> --uri /index.html --rate <num> --num-conn <num> --num-call <num> --timeout <num>`
    - **rate** reqs/sec
    - **num-conn** total amount of connections
    - **num-call** reqs/connection
    - **timeout** elapsed secs until req is considered lost

## HTTP Configuration

### HTTP Core module

- allows websites to be served, also known as **virtual hosts**

#### Server block

- declares websie with its own configuration (resides inside **http** block)

#### Location block

- defines group of settings to be applied to particular location on a website
- `listen [ip] [:port] [additional options];
    - options: **default**: use server block as default website for any request received at ip and port
    - e.g., `listen 80 default;` `listen 443 ssl;` `listen 192.168.1.1:80;`
    

# Sample Setup

## Install

    sudo aptitude install nginx

## Control

    sudo /etc/init.d/nginx start
    sudo /etc/init.d/nginx stop
    sudo /etc/init.d/nginx restart

## Configuration

### General 

Follow [these instructions](http://articles.slicehost.com/2009/3/5/ubuntu-intrepid-nginx-configuration)
to edit default configs slighly.

These configs are located at `/etc/nginx/nginx.conf`

#### Edits made (defaults of current nginx version match suggested settings mostly)

    worker_connections 1024; 
    keepalive_timeout 5;
    

### Yesod specific

Follow [these](http://www.fatvat.co.uk/2011/06/deploying-yesod-application-on-linode.html) instructions or the ones
given on the [deploy chapter](http://www.yesodweb.com/book/deploying-your-webapp) of the Yesod Book.

