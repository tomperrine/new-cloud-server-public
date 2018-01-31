#!/bin/bash


# set specifics for this instance
. set-data.sh


time gcloud compute instances delete ${INSTANCENAME} --zone=${CLOUDSDK_COMPUTE_ZONE} --quiet
