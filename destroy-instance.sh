#!/bin/bash


# get the private data
# FIXME - check for existance, perhaps do a git pull or set the path as a VAR
. ../new-cloud-server-private/set-private-data.sh
# set specifics for this instance

. ./set-public-server-data.sh

time gcloud compute instances delete ${INSTANCENAME} --zone=${CLOUDSDK_COMPUTE_ZONE} --quiet
