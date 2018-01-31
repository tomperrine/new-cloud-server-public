#!/bin/bash

# given a GCP, etc account and the SDK on the install-from host, build and install a new server


# set specifics for this instance
. set-data.sh

# get the install script we're going to put on the host

rm install-server.sh
# make sure I can get the on-host install script
curl https://raw.githubusercontent.com/tomperrine/new-cloud-server-public/master/install-server.sh > install-server.sh
# TODO CHECK TO MAKE SURE IT EXISTS


# create the instance

time gcloud compute instances create ${INSTANCENAME} --machine-type=${MACHINETYPE} --image-family=${IMAGEFAMILY} --image-project=${IMAGEPROJECT}
gcloud compute instances get-serial-port-output ${INSTANCENAME}

# add the oslogin option so I don't need to manage SSH keys
gcloud compute instances add-metadata ${INSTANCENAME} --metadata enable-oslogin=TRUE

#
# it can take some time, and sometimes(?) the create returns much faster than expected, or the system
# takes a long time to boot and get to the SSH server, so wait for it to be READY
SSHRETURN="dummy"
while [[ "RUNNING" != ${SSHRETURN} ]]; do
    SSHRETURN=`gcloud compute instances describe ${INSTANCENAME} | grep status: | awk -F\  ' {print $2}' `
    sleep 3
#    echo sshreturn ${SSHRETURN}
done
#echo ${SSHRETURN}

#
# now wait until the SSH server is running (we get a response without a timeout)
SSHRETURN=255
while [[ ${SSHRETURN} -ne 0 ]]; do
    gcloud compute ssh ${CLOUD_USERNAME}@${INSTANCENAME} --project ${PROJ} --zone ${CLOUDSDK_COMPUTE_ZONE} -- hostname
    SSHRETURN=$?
    sleep 3
done


# put the main install script on the host and run it
# dont return here until the OS is running, all packages have been installed and
# the ansible update has happened
gcloud compute scp install-server.sh ${CLOUD_USERNAME}@${INSTANCENAME}: --project ${PROJ} --zone ${CLOUDSDK_COMPUTE_ZONE}
gcloud compute ssh ${CLOUD_USERNAME}@${INSTANCENAME} --project ${PROJ} --zone ${CLOUDSDK_COMPUTE_ZONE} -- chmod +x install-server.sh
gcloud compute ssh ${CLOUD_USERNAME}@${INSTANCENAME} --project ${PROJ} --zone ${CLOUDSDK_COMPUTE_ZONE} -- 'ls -l'

# what's left to do??




exit
