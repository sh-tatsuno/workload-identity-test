#!/bin/bash

# I recommend that you should run one by one manually

cd `dirname $0`
. ./vars.txt

gcloud container clusters get-credentials $CLUSTER_NAME

echo "please wait a minute, because the program is downloading a docker image."

kubectl run -it \
    --generator=run-pod/v1 \
    --image google/cloud-sdk \
    --serviceaccount ksa-witest \
    --namespace ns-witest \
    workload-identity-test


    gcloud auth list
