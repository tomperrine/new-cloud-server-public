#!/bin/sh

# this will copied onto and run on the host that's being installed
# all that should be there is the base OS (must have git client)

# must run as root, obviously

# dont return from here until the OS is running, all packages have been installed and
# the ansible update has happened

# update the base OS
sudo apt-get update --assume-yes
sudo apt-get upgrade --assume-yes

# make sure git is present, might as well get ansible while we're at it
sudo apt-get install git ansible --assume-yes

# go get the ansible repo
git clone https://github.com/tomperrine/ansible-ispmail-tep-public.git

# and run ansible against it
sudo ansible-playbook -i "localhost," -c local  ./ansible-ispmail-tep-public/ispmail.yml



