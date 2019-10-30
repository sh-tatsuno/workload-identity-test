#!/bin/bash

set -eu

cd `dirname $0`
. ./vars.txt

gcloud config set project $PROJECT_ID
gcloud config set compute/region us-central1
gcloud config set compute/zone us-central1-f

gcloud container clusters get-credentials $CLUSTER_NAME

# apply
kubectl apply -f k8s/deployment.yaml

# binding
gcloud iam service-accounts add-iam-policy-binding \
    --role roles/iam.workloadIdentityUser \
    --member "serviceAccount:$PROJECT_ID.svc.id.goog[$K8S_NAMESPACE/$KSA_NAME]" \
    $GSA_NAME@$PROJECT_ID.iam.gserviceaccount.com

# kubectl get pods -n ns-witest -o wide 
# kubectl exec -it pod-witest /bin/bash -n ns-witest
# gcloud auth list