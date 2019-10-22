#!/bin/bash

set -eu

PROJECT_ID=myproj-193510
CLUSTER_NAME=cluster-witest
GSA_NAME=gsa-witest
K8S_NAMESPACE=ns-witest
KSA_NAME=ksa-witest
NODEPOOL_NAME=default-pool

gcloud config set project $PROJECT_ID
gcloud config set compute/region us-central1
gcloud config set compute/zone us-central1-f

gcloud container clusters get-credentials $CLUSTER_NAME

# binding
gcloud iam service-accounts add-iam-policy-binding \
    --role roles/iam.workloadIdentityUser \
    --member "serviceAccount:$PROJECT_ID.svc.id.goog[$K8S_NAMESPACE/$KSA_NAME]" \
    $GSA_NAME@$PROJECT_ID.iam.gserviceaccount.com

kubectl annotate serviceaccount \
    --namespace $K8S_NAMESPACE \
    $KSA_NAME \
    iam.gke.io/gcp-service-account=$GSA_NAME@$PROJECT_ID.iam.gserviceaccount.com
