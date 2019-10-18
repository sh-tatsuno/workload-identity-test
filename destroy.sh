gcloud pubsub subscriptions delete -q echo-read-test
gcloud pubsub topics delete -q echo-test

gcloud iam service-accounts delete -q gsa-pubsub-test@$1.iam.gserviceaccount.com
gcloud container clusters delete -q pubsub-test
