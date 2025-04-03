############################ ######## ########
# Commands to create a local kubernetes cluster.
#
############################ ######## ########
#
# Pre-requisites:
#   Colima [commands.colima.sh]
#
############################ ######## ########

# Kubernetes cluster (Kind)
kind create cluster --config echo-lb/kind/lb-kind.yaml

# Increase k8s node 'open file limits'
docker ps --format "{{.Names}}" | xargs -I {} docker exec -t {} bash -c "echo 'fs.inotify.max_user_watches=1048576' >> /etc/sysctl.conf"
docker ps --format "{{.Names}}" | xargs -I {} docker exec -t {} bash -c "echo 'fs.inotify.max_user_instances=512' >> /etc/sysctl.conf"
docker ps --format "{{.Names}}" | xargs -I {} docker exec -i {} bash -c "sysctl -p /etc/sysctl.conf"

# Gateway CRDs - version from https://github.com/kubernetes-sigs/gateway-api/releases
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.2.1/config/crd/standard/gateway.networking.k8s.io_gatewayclasses.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.2.1/config/crd/standard/gateway.networking.k8s.io_gateways.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.2.1/config/crd/standard/gateway.networking.k8s.io_httproutes.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.2.1/config/crd/standard/gateway.networking.k8s.io_referencegrants.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.2.1/config/crd/standard/gateway.networking.k8s.io_grpcroutes.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.2.1/config/crd/experimental/gateway.networking.k8s.io_tlsroutes.yaml

# Certificate Manager CRD - version from https://github.com/cert-manager/cert-manager/releases
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.17.1/cert-manager.yaml

############################ ######## ########
# Verify Cluster Status
# At this stage the cluster nodes status of 
# NotReady is expected. CNI is not yet established
# and waiting on Cilium.
############################ ######## ########
kubectl get nodes

############################ ######## ########
# Destroy cluster
############################ ######## ########
kind get clusters | xargs -t -n1 kind delete cluster --name
