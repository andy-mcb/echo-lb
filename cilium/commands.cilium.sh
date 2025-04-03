############################ ######## ########
# Commands to create Cilium cluster mesh.
#
############################ ######## ########
# Pre-requisites:
#   Kind Cluster [commands.kind.sh]
############################ ######## ########

# Mesh, Gateway & Ingress (Cilium)
cilium install --version=v1.17.2 --helm-values echo-lb/cilium/lb-cilium.yaml \
    --set l2announcements.leaseDuration="3s" \
    --set l2announcements.leaseRenewDeadline="1s" \
    --set l2announcements.leaseRetryPeriod="500ms" \
    --set devices="{eth0,net0}"

cilium status --wait

# Load Balancer IP Pool & L2 Network Announcer
kubectl apply -f echo-lb/cilium/ip-pool.yaml

############################ ######## ########
# Cilium Upgrade Only
############################ ######## ########
cilium upgrade --version=v1.17.2 --helm-values echo-lb/cilium/lb-cilium.yaml \
    --set l2announcements.leaseDuration="3s" \
    --set l2announcements.leaseRenewDeadline="1s" \
    --set l2announcements.leaseRetryPeriod="500ms" \
    --set devices="{eth0,net0}"

kubectl -n kube-system rollout restart deployment/cilium-operator
kubectl -n kube-system rollout restart ds/cilium
############################ ######## ########
