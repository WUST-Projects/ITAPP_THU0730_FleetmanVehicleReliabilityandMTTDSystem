#!/bin/bash

. ../../config.sh

#load helloworld and sleep images

echo "Pulling images to a docker host..."
docker pull imeshai/echoserver

echo "Load images to kind clusters..."
kind load docker-image --name $CLUSTER1_NAME imeshai/echoserver

kubectl -n ns1 apply -f workload.yaml