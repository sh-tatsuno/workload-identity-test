#!/bin/bash

# I recommend that you should run one by one manually

# check if each pod is running
kubectl get pods -l app=pubsub -n ns-pubsub1 
kubectl get pods -l app=pubsub -n ns-pubsub2

# check if pods can catch the message from topic
kubectl logs -l app=pubsub -n ns-pubsub1
kubectl logs -l app=pubsub -n ns-pubsub2