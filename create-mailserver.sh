#!/bin/bash

# given a GCP, etc account and the SDK on the install-from host, build and install a new server

# get the private data
# FIXME - check for existance, perhaps do a git pull or set the path as a VAR
. ../new-cloud-server-private/set-private-data.sh
# set specifics for this instance

. ./set-public-server-data.sh


#
# create the instance
#
gcloud compute instances create ${INSTANCENAME} --machine-type=${MACHINETYPE} --image-family=${IMAGEFAMILY} --image-project=${IMAGEPROJECT}
gcloud compute instances get-serial-port-output ${INSTANCENAME}

# add the oslogin option so I don't need to manage SSH keys
gcloud compute instances add-metadata ${INSTANCENAME} --metadata enable-oslogin=TRUE

#
# it can take some time, and sometimes(?) the create returns much faster than expected, or the system
# takes a long time to boot and get to the SSH server, so wait for it to be READY
SSHRETURN="dummy"
while [[ "RUNNING" != ${SSHRETURN} ]]; do
    SSHRETURN=`gcloud compute instances describe ${INSTANCENAME} | grep status: | awk -F\  ' {print $2}' `
    sleep 5
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

#
# here's how to get the internal and external IP addresses for all instances
echo "internal address: " `gcloud --format="value(networkInterfaces[0].networkIP)"  compute instances list`
echo "external IP address: " `gcloud --format="value(networkInterfaces[0].accessConfigs[0].natIP)"  compute instances list`

# or for just the known instance
echo just this instance
gcloud --format="value(networkInterfaces[0].networkIP)"  compute instances describe ${INSTANCENAME} --zone ${CLOUDSDK_COMPUTE_ZONE}


# put the main install script on the host and run it
# dont return here until the OS is running, all packages have been installed and
# the ansible update has happened
gcloud compute scp os-and-ansible.sh ${CLOUD_USERNAME}@${INSTANCENAME}: --project ${PROJ} --zone ${CLOUDSDK_COMPUTE_ZONE}
gcloud compute ssh ${CLOUD_USERNAME}@${INSTANCENAME} --project ${PROJ} --zone ${CLOUDSDK_COMPUTE_ZONE} -- chmod +x os-and-ansible.sh

gcloud compute ssh ${CLOUD_USERNAME}@${INSTANCENAME} --project ${PROJ} --zone ${CLOUDSDK_COMPUTE_ZONE} -- './os-and-ansible'







exit
