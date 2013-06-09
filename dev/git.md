**Table of Contents**  *generated with [DocToc](http://doctoc.herokuapp.com/)*

- [Installation](#installation)
- [SSH keys](#ssh-keys)
- [Adding remote Origin](#adding-remote-origin)
- [Forking a repo](#forking-a-repo)
	- [Add remote of forked repo](#add-remote-of-forked-repo)
	- [Pull in upstream changes](#pull-in-upstream-changes)
- [Fetch vs. Pull](#fetch-vs-pull)
- [Configuration](#configuration)
	- [Configure Remote](#configure-remote)

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

# Configuration

## Config files

- `etc/gitconfig` Contains values for every user on the system and all their repositories. If you pass the
  option--system to git config, it reads and writes from this file specifically.
- `/.gitconfig` Specific to your user. You can make Git read and write to this file specifically by passing the
  --global option.
- `.git/config` of whatever repository you’re currently using
- each level overrides previos values

## Configuring Remote
    
    git config remote.origin.url git@github.com:username/projectname

## Configuring User

    git config --global user.name "John Doe"
    git config --global user.email johndoe@example.com

## Configuring Tools

    git config --global core.editor vim
    git config --global merge.tool vimdiff
    git config --global <color.ui|color.diff> <true|false>

## Checking Settings

    git config --list

# Ignoring Files

- standard glob patterns `/` specifies directory, `!` negates pattern

    # a comment  this is ignored
    *.a       # no .a files
    !lib.a    # but do track lib.a, even though you’re ignoring .a files above
    /TODO     # only ignore the root TODO file, not subdir/TODO
    build/    # ignore all files in the build/ directory
    doc/*.txt # ignore doc/notes.txt, but not doc/server/arch.txt

# Viewing Changes

- `git diff` unstaged changes with staged changes
- `git diff <--cached|-c>` staged changes with last commit

# Logs

- `git log -u <file>` shows all commits that changed the file including diffs
- `git log -n` logs only last `n` commits

# Files

- `git ls-files` lists all tracked files in git repo
