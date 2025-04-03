############################ ######## ########
# Commands to create the Echo Service & Gateway.
#
############################ ######## ########
# Pre-requisites:
#   Kind Cluster [commands.cilium.sh]
############################ ######## ########

# Deploy Echo Service
kubectl apply -f echo-lb/echo/echo-service.yaml

# Identify Echo Service External IP
kubectl get svc -n echo

# Confirm connectivity to Echo Service
curl -I -v http://172.18.250.2:5678

# Deploy & Test Echo Gateway
kubectl apply -f echo-lb/echo/echo-gateway.yaml

# Identify Echo Gateway External IP
kubectl get svc -n echo

# Confirm connectivity to Echo Gateway
curl -I -v http://172.18.250.12

############################ ######## ########
# DNS & TLS Verification
############################ ######## ########
# Pre-requisites:
#   DNSMasq [commands.dns.sh] -> configure echo-lb.kube
#   TLS Certificates [commands.certificates.sh]
#
# DNS: the Gateway has preallocated IP address
#      as such this should only need configuring
#      once.
############################ ######## ########
# Confirm DNS routing
curl -I -v http://echo.echo-lb.kube
curl http://echo.echo-lb.kube

# Confirm TLS resolution 
curl -I -v https://echo.echo-lb.kube
curl https://echo.echo-lb.kube
