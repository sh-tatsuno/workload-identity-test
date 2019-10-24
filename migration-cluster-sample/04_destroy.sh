#!/bin/bash

# set -eu

cd `dirname $0`
. ./vars.txt

# contingency
gcloud beta container node-pools update $NODEPOOL_NAME \
    --cluster=$CLUSTER_NAME \
    --workload-metadata-from-node=EXPOSED

gcloud iam service-accounts remove-iam-policy-binding \
    --role roles/iam.workloadIdentityUser \
    --member "serviceAccount:$PROJECT_ID.svc.id.goog[$K8S_NAMESPACE/$KSA_NAME]" \
    $GSA_NAME@$PROJECT_ID.iam.gserviceaccount.com

gcloud iam service-accounts delete -q $GSA_NAME@$PROJECT_ID.iam.gserviceaccount.com
gcloud container clusters delete -q $CLUSTER_NAME
