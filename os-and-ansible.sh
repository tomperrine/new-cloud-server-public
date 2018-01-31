#!/bin/sh

# this will copied onto and run on the host that's being installed
# all that should be there is the base OS (must have git client)

# must run as root, obviously

# dont return from here until the OS is running, all packages have been installed and
# the ansible update has happened

# update the base OS
apt-get update --assume-yes
apt-get upgrade --assume-yes

# make sure git is present, might as well get ansible while we're at it
apt-get install git ansible --assume-yes

# now use ansible to install *ALL THE THINGS*
# postfix, imap, etc




