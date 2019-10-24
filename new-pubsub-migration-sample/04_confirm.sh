#!/bin/bash

# I recommend that you should run one by one manually

PUBSUB_TOPIC=echo 
gcloud pubsub topics publish $PUBSUB_TOPIC --message='Hello World!'

# check if each pod is running
kubectl get pods -l app=pubsub -n ns-pubsub1 -o wide
kubectl get pods -l app=pubsub -n ns-pubsub2 -o wide

# check if pods can catch the message from topic
kubectl logs -l app=pubsub -n ns-pubsub1
kubectl logs -l app=pubsub -n ns-pubsub2

# delete secret
kubectl delete secret pubsub-key --namespace=ns-pubsub1
kubectl delete secret pubsub-key --namespace=ns-pubsub2

# check if pods can catch the message from topic
kubectl logs -l app=pubsub -n ns-pubsub1
kubectl logs -l app=pubsub -n ns-pubsub2

# again
gcloud pubsub topics publish $PUBSUB_TOPIC --message='Hello World!'

# check
kubectl logs -l app=pubsub -n ns-pubsub1
