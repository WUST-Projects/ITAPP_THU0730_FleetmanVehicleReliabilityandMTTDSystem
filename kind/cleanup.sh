#!/bin/bash

. ../config.sh

# Delete the cluster with name ambient
echo "Deleting $CLUSTER1_NAME..."
kind delete cluster --name $CLUSTER1_NAME

echo "Deleting $CLUSTER2_NAME..."
kind delete cluster --name $CLUSTER2_NAME

# Verify that the cluster is deleted
echo "Verifying cluster deletion..."
kind get clusters

