#!/bin/bash
# set -eu

PROJECT_ID=myproj-193510
CLUSTER_NAME=cluster-witest
GSA_NAME=gsa-witest
K8S_NAMESPACE=ns-witest
KSA_NAME=ksa-witest

gcloud iam service-accounts remove-iam-policy-binding \
    --role roles/iam.workloadIdentityUser \
    --member "serviceAccount:$PROJECT_ID.svc.id.goog[$K8S_NAMESPACE/$KSA_NAME]" \
    $GSA_NAME@$PROJECT_ID.iam.gserviceaccount.com

gcloud iam service-accounts delete -q $GSA_NAME@$PROJECT_ID.iam.gserviceaccount.com
gcloud container clusters delete -q $CLUSTER_NAME
