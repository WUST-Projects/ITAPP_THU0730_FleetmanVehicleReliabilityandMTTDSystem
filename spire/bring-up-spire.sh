#/bin/bash

. ../config.sh

# set -e

kubectl config use-context ${CLUSTER1_CTX}
# kubectl create ns istio-system
# until kubectl apply -f ./spire/crds.yaml; do sleep 3; done
# kubectl apply -f ./spire/configmaps.yaml
kubectl apply -f ./spire-frontend.yaml
echo "sleeping..."
sleep 30
kubectl apply -f ./spiffe-id-frontend.yaml
FRONTEND_POD="$(kubectl get pod -n spire -l app=spire-server -ojsonpath='{ .items[0].metadata.name }')"
frontend_bundle="$(kubectl exec --stdin $FRONTEND_POD -c spire-server -n spire  -- /opt/spire/bin/spire-server bundle show -format spiffe)"
echo "$frontend_bundle"
kubectl -n spire expose svc spire-server-bundle-endpoint --port 8443 --target-port 8443 --name bundle-api --type LoadBalancer


kubectl config use-context ${CLUSTER2_CTX}
kubectl apply -f ./spire-backend.yaml
echo "sleeping..."
sleep 30
kubectl apply -f ./spiffe-id-backend.yaml
BACKEND_POD="$(kubectl get pod -n spire -l app=spire-server -ojsonpath='{ .items[0].metadata.name }')"
backend_bundle="$(kubectl exec --stdin $BACKEND_POD -c spire-server -n spire  -- /opt/spire/bin/spire-server bundle show -format spiffe)"
echo "$backend_bundle"
kubectl -n spire expose svc spire-server-bundle-endpoint --port 8443 --target-port 8443 --name bundle-api --type LoadBalancer

sleep 10
# Set example.org bundle to domain.test SPIRE bundle endpoint
kubectl exec --stdin "$BACKEND_POD" -c spire-server -n spire -- /opt/spire/bin/spire-server  bundle set -format spiffe -id spiffe://frontend.com <<< "$frontend_bundle"
### move to cluster 1
kubectl config use-context ${CLUSTER1_CTX}
# Set domain.test bundle to example.org SPIRE bundle endpoint
kubectl exec --stdin "$FRONTEND_POD" -c spire-server -n spire -- /opt/spire/bin/spire-server  bundle set -format spiffe -id spiffe://backend.com <<< "$backend_bundle"


