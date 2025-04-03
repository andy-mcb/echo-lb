############################ ######## ########
# Commands to create local DNS entries for:
#   - *.echo-lb.kube
############################ ######## ########
#
# Pre-requisites:
#   Echo Gateway [commands.echo.sh]
############################ ######## ########

# Mac custom DNS routing
brew install dnsmasq
sudo brew services start dnsmasq

# Setup DNSMasq - only needed for first time cluster creation
bash -c "echo 'address=/echo-lb.kube/172.18.250.12' > $(brew --prefix)/etc/dnsmasq.d/echo-lb-kube.conf"

cat <<EOF | sudo tee /etc/resolver/echo-lb.kube
domain echo-lb.kube
search echo-lb.kube
nameserver 127.0.0.1
EOF

# Flush mac dns cache
sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder

# restart / start dnsmasq after config change
sudo brew services restart dnsmasq

# Verify DNS configuration
dig @127.0.0.1 echo.echo-lb.kube
dig echo.echo-lb.kube
