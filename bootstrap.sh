#!/usr/bin/env bash

MACHINE=$1

cat > /etc/apt/sources.list << EOF
deb http://ftp.de.debian.org/debian wheezy main
deb-src http://ftp.de.debian.org/debian wheezy main

deb http://security.debian.org/ wheezy/updates main contrib
deb-src http://security.debian.org/ wheezy/updates main contrib

# wheezy-updates, previously known as 'volatile'
deb http://ftp.de.debian.org/debian wheezy-updates main contrib
deb-src http://ftp.de.debian.org/debian wheezy-updates main contrib
EOF

apt-get update
apt-get install --no-install-recommends -y puppet git tcpdump mtr-tiny vim

puppet module install puppetlabs-stdlib
puppet module install puppetlabs-apt
puppet module install puppetlabs-vcsrepo

cd /etc/puppet/modules
git clone https://github.com/ffnord/ffnord-puppet-gateway ffnord

cd "/vagrant/machines/${MACHINE}/"
cp * /root
cd /root
puppet apply manifest.pp --verbose

build-firewall
service iptables-persistent save
