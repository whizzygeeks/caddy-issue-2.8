#!/bin/bash
# Install OS libraries
apt install build-essential curl cpio automake 

# Install caddy
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https curl
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt update
sudo apt install caddy

# Install xcaddy
apt install -y debian-keyring debian-archive-keyring apt-transport-https
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/xcaddy/gpg.key' |  gpg --dearmor -o /usr/share/keyrings/caddy-xcaddy-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/xcaddy/debian.deb.txt' |  tee /etc/apt/sources.list.d/caddy-xcaddy.list
apt update
apt install xcaddy

# Install golang
apt install golang-1.21
ln -s /usr/lib/go-1.21/bin/go /usr/bin/go

# Build caddy 2.8.4 with tlsredis nd ratelimit module
cd /opt
xcaddy build --with github.com/gamalan/caddy-tlsredis --with github.com/mholt/caddy-ratelimit
mv caddy /usr/bin/caddy

# install redis
apt install redis-server
echo "requirepass monk" >> /etc/redis/redis.conf
systemctl restart redis-server 

# Append host file
cp /etc/hosts /etc/hosts_backup_`date +%d%m%Y`
echo "127.0.0.1 localhost primary-redis.mydomain.com www.mydomain.com domain-validator.mydomain.com" > /etc/hosts 

