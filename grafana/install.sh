#!/bin/bash

. ../config.sh

kubectl config use-context ${CLUSTER2_CTX}
kubectl apply -f install.yaml