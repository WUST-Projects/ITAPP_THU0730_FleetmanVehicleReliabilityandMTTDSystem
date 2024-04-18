#!/bin/bash

. ../config.sh

#load helloworld and sleep images

echo "Pulling images to a docker host..."
docker pull docker.io/istio/examples-helloworld-v1
docker pull docker.io/istio/examples-helloworld-v2
docker pull docker.io/kong/httpbin
docker pull curlimages/curl

echo "Load images to kind clusters..."
kind load docker-image --name $CLUSTER1_NAME docker.io/istio/examples-helloworld-v1
kind load docker-image --name $CLUSTER1_NAME docker.io/istio/examples-helloworld-v2
kind load docker-image --name $CLUSTER1_NAME curlimages/curl
#kind load docker-image --name $CLUSTER1_NAME docker.io/kong/httpbin

kind load docker-image --name $CLUSTER2_NAME docker.io/istio/examples-helloworld-v1
kind load docker-image --name $CLUSTER2_NAME docker.io/istio/examples-helloworld-v2
kind load docker-image --name $CLUSTER2_NAME curlimages/curl
#kind load docker-image --name $CLUSTER2_NAME docker.io/kong/httpbin

echo "Install demo apps to kind clusters..."
kubectl --context="${CLUSTER1_CTX}" create ns istio-test
kubectl --context="${CLUSTER1_CTX}" label ns istio-test istio-injection=enabled --overwrite
kubectl --context="${CLUSTER1_CTX}" -n istio-test apply -f helloworld-gcs-mom-dev.yaml
kubectl --context="${CLUSTER1_CTX}" -n istio-test apply -f gcs-mom-dev.yaml

kubectl --context="${CLUSTER2_CTX}" create ns istio-test
kubectl --context="${CLUSTER2_CTX}" label ns istio-test istio-injection=enabled --overwrite
kubectl --context="${CLUSTER2_CTX}" -n istio-test apply -f helloworld-gcs-mom.yaml
kubectl --context="${CLUSTER2_CTX}" -n istio-test apply -f gcs-mom.yaml