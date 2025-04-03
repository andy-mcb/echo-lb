############################ ######## ########
# Commands to create a local docker runtime.
#
############################ ######## ########
# Pre-requisites:
#
# Docker Mac Net Connect
brew install chipmk/tap/docker-mac-net-connect
sudo brew services start docker-mac-net-connect
# ... Restart Mac ...
#
# Restart both root and local user services after mac reboot
sudo brew services restart docker-mac-net-connect
brew services restart docker-mac-net-connect
############################ ######## ########

# Docker (Colima)
mkdir ~/.colima/echo-lb && \
cp echo-lb/colima/lb-colima.yaml ~/.colima/echo-lb/colima.yaml && \
colima start echo-lb

# Link default docker.sock to colima to support Docker-Mac-Net-Connect
# Need to do this after every reboot or change to colima context
sudo ln -sf ~/.colima/echo-lb/docker.sock /var/run/docker.sock

# LB: using docker-mac-net-connect
# LB: ping 172.18.0.2 times out (172.18.0.2 -> use 'docker inspect kind' -> worker -> ipv4address)
# LB: need to add missing forwarding rule to the colima host
# LB: this will need adding after every Colima restart 
#
# Replaced with a provision script in Colima yaml configuration
# colima ssh -p echo-lb -- sudo iptables --list-rules | grep 10.33.33.1
# colima ssh -p echo-lb -- sudo iptables -A FORWARD -s 10.33.33.1 -j ACCEPT

############################ ######## ########
# Verification
############################ ######## ########
docker container run --rm --name nginx -d nginx

# usually 172.17.0.2
docker inspect nginx --format '{{.NetworkSettings.IPAddress}}'

# Expect: ping success
ping 172.17.0.2

# Tidy up
docker stop nginx

############################ ######## ########
# Troubleshooting
############################ ######## ########
# Restart
colima restart -p echo-lb

# Restart of Colima with Kind cluster deployed 
# sometimes requires restart (delete and reinstall)
# of Cilium when kube-system services fail to start
# correctly.
# I suspect this occurs if there is a mismatch 
# between the 'hostnames' specified for Colima, 
# Kind & Cilium

# See commands.cilium.sh to install
helm delete cilium -n kube-system
