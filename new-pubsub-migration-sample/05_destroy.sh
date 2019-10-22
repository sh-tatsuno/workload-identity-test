#!/bin/bash

PROJECT_ID=myproj-193510
REGION=us-central1
ZONE=us-central1-f

CLUSTER_NAME=pubsub-test
GSA_NAME=gsa-pubsub
K8S_NAMESPACE=ns-pubsub1
KSA_NAME=ksa-pubsub1
NODEPOOL_NAME=default-pool
NEW_NODEPOOL_NAME=witest-pool

# pubsub names are binding with the container of pubsub-sample image
PUBSUB_TOPIC=echo # DO NOT CHANGE
PUBSUB_SUBSCRIPTION=echo-read # DO NOT CHANGE

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
