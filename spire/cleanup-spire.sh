#!/bin/bash

. ../config.sh

kubectl config use-context ${CLUSTER1_CTX}
kubectl delete -f crds.yaml
kubectl delete -f spire-frontend.yaml
kubectl delete -f spiffe-id-frontend.yaml
# kubectl delete ns istio-system

kubectl config use-context ${CLUSTER2_CTX}
kubectl delete -f crds.yaml
kubectl delete -f spire-backend.yaml
kubectl delete -f spiffe-id-backend.yaml
# kubectl delete ns istio-system

