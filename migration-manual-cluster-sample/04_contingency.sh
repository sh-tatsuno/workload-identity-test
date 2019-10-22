#!/bin/bash

set -eu

PROJECT_ID=myproj-193510
CLUSTER_NAME=cluster-witest
GSA_NAME=gsa-witest
K8S_NAMESPACE=ns-witest
KSA_NAME=ksa-witest
NODEPOOL_NAME=default-pool
NEW_NODEPOOL_NAME=witest-pool

gcloud config set project $PROJECT_ID
gcloud config set compute/region us-central1
gcloud config set compute/zone us-central1-f

gcloud container clusters get-credentials $CLUSTER_NAME

for node in $(kubectl get nodes -l cloud.google.com/gke-nodepool=$NODEPOOL_NAME -o=name); do
    kubectl uncordon "$node";
done

for node in $(kubectl get nodes -l cloud.google.com/gke-nodepool=$NEW_NODEPOOL_NAME -o=name); do
    kubectl uncordon "$node";
done

for node in $(kubectl get nodes -l cloud.google.com/gke-nodepool=$NEW_NODEPOOL_NAME -o=name); do
    kubectl drain --force --ignore-daemonsets --delete-local-data --grace-period=10 "$node";
done
