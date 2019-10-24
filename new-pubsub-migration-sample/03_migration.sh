#!/bin/bash
set -eu

cd `dirname $0`
. ./vars.txt

gcloud config set project $PROJECT_ID
gcloud config set compute/region $REGION
gcloud config set compute/zone $ZONE
gcloud container clusters get-credentials $CLUSTER_NAME

# create service accounts
gcloud iam service-accounts create $GSA_NAME
gcloud projects add-iam-policy-binding \
    --role roles/pubsub.subscriber \
    --member "serviceAccount:$GSA_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
    $PROJECT_ID

# binding
gcloud iam service-accounts add-iam-policy-binding \
    --role roles/iam.workloadIdentityUser \
    --member "serviceAccount:$PROJECT_ID.svc.id.goog[$K8S_NAMESPACE/$KSA_NAME]" \
    $GSA_NAME@$PROJECT_ID.iam.gserviceaccount.com

kubectl create serviceaccount \
    --namespace $K8S_NAMESPACE \
    $KSA_NAME

kubectl annotate serviceaccount \
    --namespace $K8S_NAMESPACE \
    $KSA_NAME \
    iam.gke.io/gcp-service-account=$GSA_NAME@$PROJECT_ID.iam.gserviceaccount.com

# create new node-pools
gcloud beta container node-pools create $NEW_NODEPOOL_NAME \
    --cluster=$CLUSTER_NAME \
    --workload-metadata-from-node=SECURE

# migration
for node in $(kubectl get nodes -l cloud.google.com/gke-nodepool=$NODEPOOL_NAME -o=name); do
    kubectl cordon "$node";
done

for node in $(kubectl get nodes -l cloud.google.com/gke-nodepool=$NODEPOOL_NAME -o=name); do
    kubectl drain --force --ignore-daemonsets --delete-local-data --grace-period=10 "$node";
done
