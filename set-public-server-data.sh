#!/bin/bash
#
# this file sets all the non-sensitive customizations
# anything in here would be the same for anyone using this to install this type of server

# first, pick up all the sensitive info
. set-private-data.sh


# pick a region
export CLOUDSDK_COMPUTE_ZONE="us-central1-f"


# set information for the instance we will create
INSTANCENAME="mailserver"
MACHINETYPE="f1-micro"
IMAGEFAMILY="ubuntu-1710"
IMAGEPROJECT="ubuntu-os-cloud"


