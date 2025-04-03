############################ ######## ########
# Commands to create Certificate Authority and
# install root certificate into local 
# certificate store.
# 
# Use Key Chain Tool to view installation on Mac.
############################ ######## ########
#
# Pre-requisites:
#   DNSMasq (commands.dns.sh)
#   Cilium Mesh [commands.cilium.sh]
#   Echo Service [commands.echo.sh]
#
############################ ######## ########

# CA Cluster Issuer
kubectl apply -f echo-lb/certificates/ca-issuer.yaml

# Generate Echo certificates
kubectl apply -f echo-lb/certificates/cert-echo.yaml

# Download CA Certificate
kubectl get secret echo-lb-ca-tls -n cert-manager -o jsonpath="{.data['tls\.crt']}" | base64 -d > rootCA.pem

# Install rootCA certificate into local trust store
CAROOT=. mkcert -install
rm rootCA.pem

# Verify Kube certificate chain is valid
openssl verify -CAfile \
<(kubectl get secret echo-lb-ca-tls -n cert-manager \
-o jsonpath='{.data.ca\.crt}' | base64 -d) \
<(kubectl get secret kube-tls -n cert-manager \
-o jsonpath='{.data.tls\.crt}' | base64 -d)
