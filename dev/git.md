**Table of Contents**  *generated with [DocToc](http://doctoc.herokuapp.com/)*

- [Installation](#installation)
- [SSH keys](#ssh-keys)
- [Adding remote Origin](#adding-remote-origin)
- [Forking a repo](#forking-a-repo)
	- [Add remote of forked repo](#add-remote-of-forked-repo)
	- [Pull in upstream changes](#pull-in-upstream-changes)
- [Fetch vs. Pull](#fetch-vs-pull)

# Installation
    sudo apt-get git

# SSH keys

Follow [these](http://help.github.com/mac-set-up-git/) instructions.

    ssh-keygen -t rsa -C "your_email@youremail.com"

    git config --global user.name "Firstname Lastname"
    git config --global user.email "your_email@youremail.com"

# Adding remote Origin

`git remote add origin git@github.com:username/reponame.git`
`git pull origin master`

# Forking a repo

[docs](http://help.github.com/fork-a-repo/)

## Add remote of forked repo

    git add remote upstream git://github.com/...

## Pull in upstream changes
    git fetch upstream
    git merge upstream/master

# Fetch vs. Pull

- when `pull`ing, git tries to merge commits automatically without review which may cause frequent conflicts
- when `fetch`ing, git gathers commits on target branch that don't exist in current branch, but doesn't merge them
- use manual `merge` later on to integrate commits into master branch


