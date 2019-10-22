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

# create cluster
gcloud beta container clusters create $CLUSTER_NAME \
    --cluster-version=1.12 #\
    # --identity-namespace=$PROJECT_ID.svc.id.goog

gcloud container clusters get-credentials $CLUSTER_NAME

# create service accounts
gcloud iam service-accounts create $GSA_NAME

kubectl create namespace $K8S_NAMESPACE
kubectl create serviceaccount \
    --namespace $K8S_NAMESPACE \
    $KSA_NAME

# create new node-pools
gcloud beta container node-pools create $NEW_NODEPOOL_NAME \
    --cluster=$CLUSTER_NAME \
    --workload-metadata-from-node=SECURE

for node in $(kubectl get nodes -l cloud.google.com/gke-nodepool=$NODEPOOL_NAME -o=name); do
    kubectl cordon "$node";
done
# kubectl get nodes

for node in $(kubectl get nodes -l cloud.google.com/gke-nodepool=$NODEPOOL_NAME -o=name); do
    kubectl drain --force --ignore-daemonsets --delete-local-data --grace-period=10 "$node";
done