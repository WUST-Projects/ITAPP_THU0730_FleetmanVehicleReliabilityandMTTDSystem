#!/bin/bash

# Setup instruction is found here: https://devopscube.com/setup-prometheus-monitoring-on-kubernetes/
. ../config.sh

kubectl config use-context ${CLUSTER2_CTX}
kubectl create namespace monitoring
kubectl label ns monitoring istio-injection=enabled --overwrite
kubectl apply -f clusterRole.yaml
kubectl apply -f prometheus-config.yaml
kubectl apply -f prometheus-deployment.yaml
# Install kube-state-metrics
kubectl -n kube-system apply -f kube-state-metrics/
# Install alert manager components
kubectl apply -f alert-manager/
