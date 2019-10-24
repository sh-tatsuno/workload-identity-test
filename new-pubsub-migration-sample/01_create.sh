#!/bin/bash
set -eu

cd `dirname $0`
. ./vars.txt

cd `dirname $0`
if [ ! -e $FILE ]; then
    echo "prepare key.json and set the same directory in this script."
    exit 1
fi

gcloud config set project $PROJECT_ID
gcloud config set compute/region $REGION
gcloud config set compute/zone $ZONE

# create cluster
gcloud beta container clusters create $CLUSTER_NAME \
    --cluster-version=1.12 
gcloud container clusters get-credentials $CLUSTER_NAME

# create pubsub
gcloud pubsub topics create $PUBSUB_TOPIC
gcloud pubsub subscriptions create $PUBSUB_SUBSCRIPTION --topic=$PUBSUB_TOPIC

# create namespace
kubectl create namespace $K8S_NAMESPACE_1
kubectl create namespace $K8S_NAMESPACE_2

# copy credential key
kubectl create secret generic pubsub-key --from-file=key.json=$FILE --namespace=$K8S_NAMESPACE_1
kubectl create secret generic pubsub-key --from-file=key.json=$FILE --namespace=$K8S_NAMESPACE_2

# create pods
kubectl apply -f deployment/pubsub1.yaml --namespace=$K8S_NAMESPACE_1
kubectl apply -f deployment/pubsub2.yaml --namespace=$K8S_NAMESPACE_2

# send topic
gcloud pubsub topics publish $PUBSUB_TOPIC --message='Hello World!'


#kubectl delete -f deployment/pubsub2.yaml --namespace=ns-pubsub2