#!/bin/bash

. ../config.sh

# Install backend micro services
# kubectl config use-context ${CLUSTER2_CTX}
# kubectl label ns default istio-injection=enabled --overwrite
kubectl -n default apply -f pvc.yaml
kubectl -n default apply -f mongo-stack.yaml
kubectl -n default apply -f workloads.yaml
kubectl -n default apply -f services.yaml


# Install frontend app
# kubectl config use-context ${CLUSTER1_CTX}
# kubectl label ns default istio-injection=enabled --overwrite
# kubectl -n default apply -f webapps.yaml