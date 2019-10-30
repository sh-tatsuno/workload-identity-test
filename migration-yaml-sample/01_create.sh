

set -eu

cd `dirname $0`
. ./vars.txt

gcloud config set project $PROJECT_ID
gcloud config set compute/region us-central1
gcloud config set compute/zone us-central1-f

# create cluster
gcloud beta container clusters create $CLUSTER_NAME \
    --cluster-version=1.12 #\
    # --identity-namespace=$PROJECT_ID.svc.id.goog

gcloud container clusters get-credentials $CLUSTER_NAME

# create service accounts
gcloud iam service-accounts create $GSA_NAME

kubectl create namespace $K8S_NAMESPACE
kubectl create serviceaccount \
    --namespace $K8S_NAMESPACE \
    $KSA_NAME

# update cluster
gcloud beta container clusters update $CLUSTER_NAME \
    --identity-namespace=$PROJECT_ID.svc.id.goog

# create new node-pools
gcloud beta container node-pools create $NEW_NODEPOOL_NAME \
    --cluster=$CLUSTER_NAME \
    --workload-metadata-from-node=GKE_METADATA_SERVER
