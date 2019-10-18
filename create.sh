set -eu

# create cluster
gcloud container clusters create pubsub-test
gcloud container clusters get-credentials pubsub-test

# create namespace
kubectl create namespace ns-pubsub1
kubectl create namespace ns-pubsub2

# create pods
kubectl apply -f pubsub1.yaml --namespace=ns-pubsub1
kubectl apply -f pubsub2.yaml --namespace=ns-pubsub2

# create pubsub
gcloud pubsub topics create echo-test
gcloud pubsub subscriptions create echo-read-test --topic=echo-test

# create service account
gcloud iam service-accounts create gsa-pubsub-test \
    --display-name "test for workload identity"

gcloud projects add-iam-policy-binding \
    $1 \
    --member=serviceAccount:gsa-pubsub-test@$1.iam.gserviceaccount.com \
    --role=roles/pubsub.subscriber

# update k8s to enable workload identity
gcloud beta container clusters update pubsub-test \
    --identity-namespace=$1.svc.id.goog

gcloud beta container node-pools create migration-for-workload-identity \
    --cluster=pubsub-test \
    --workload-metadata-from-node=GKE_METADATA_SERVER

# gcloud container node-pools list --cluster pubsub-test
# kubectl get nodes
# kubectl get pods -o=wide
# kubectl get nodes -l cloud.google.com/gke-nodepool=default-pool

for node in $(kubectl get nodes -l cloud.google.com/gke-nodepool=default-pool -o=name); do
    kubectl cordon "$node";
done

# kubectl get nodes

for node in $(kubectl get nodes -l cloud.google.com/gke-nodepool=default-pool -o=name); do
    kubectl drain --force --ignore-daemonsets --delete-local-data --grace-period=10 "$node";
done

# kubectl get pods -o=wide --namespace=ns-pubsub1 

gcloud container node-pools delete -q default-pool --cluster pubsub-test

# kubectl get nodes 

# create ksa only in ns-pubsub1
kubectl create serviceaccount \
    --namespace ns-pubsub1 \
    ksa-ns-pubsub1

gcloud iam service-accounts add-iam-policy-binding \
    --role roles/iam.workloadIdentityUser \
    --member "serviceAccount:$1.svc.id.goog[ns-pubsub1/ksa-ns-pubsub1]" \
    gsa-pubsub-test@$1.iam.gserviceaccount.com

# gcloud iam service-accounts get-iam-policy gsa-pubsub-test@$1.iam.gserviceaccount.com

kubectl annotate serviceaccount \
    --namespace ns-pubsub1 \
    ksa-ns-pubsub1 \
    iam.gke.io/gcp-service-account=gsa-pubsub-test@$1.iam.gserviceaccount.com

# kubectl describe serviceaccounts ksa-ns-pubsub1 --namespace ns-pubsub1


kubectl run -it \
  --generator=run-pod/v1 \
  --image google/cloud-sdk \
  --serviceaccount ksa-ns-pubsub1 \
  --namespace ns-pubsub1 \
  workload-identity-test