#!/bin/bash

cd `dirname $0`
. ./vars.txt

gcloud iam service-accounts remove-iam-policy-binding \
    --role roles/iam.workloadIdentityUser \
    --member "serviceAccount:$PROJECT_ID.svc.id.goog[$K8S_NAMESPACE/$KSA_NAME]" \
    $GSA_NAME@$PROJECT_ID.iam.gserviceaccount.com

gcloud projects remove-iam-policy-binding \
    --role roles/pubsub.subscriber \
    --member "serviceAccount:$GSA_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
    $PROJECT_ID

gcloud iam service-accounts delete -q $GSA_NAME@$PROJECT_ID.iam.gserviceaccount.com
gcloud pubsub subscriptions delete -q $PUBSUB_SUBSCRIPTION
gcloud pubsub topics delete -q $PUBSUB_TOPIC
gcloud container clusters delete -q $CLUSTER_NAME
