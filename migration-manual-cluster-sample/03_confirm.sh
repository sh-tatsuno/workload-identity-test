#!/bin/bash

set -eu

PROJECT_ID=myproj-193510
CLUSTER_NAME=cluster-witest
GSA_NAME=gsa-witest
K8S_NAMESPACE=ns-witest
KSA_NAME=ksa-witest

gcloud container clusters get-credentials $CLUSTER_NAME

echo "please wait a minute, because the program is downloading a docker image."

kubectl run -it \
    --generator=run-pod/v1 \
    --image google/cloud-sdk \
    --serviceaccount ksa-witest \
    --namespace ns-witest \
    workload-identity-test


    gcloud auth list
