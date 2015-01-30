#!/usr/bin/env bash

# bootstrap script for all gateway simulation machines

# enable output what is executed:
set -x

MACHINE=$1
FFNORD_TESTING_REPO=
FFNORD_TESTING_BRANCHES=()

cat > /etc/apt/sources.list << EOF
deb http://ftp.de.debian.org/debian wheezy main
deb-src http://ftp.de.debian.org/debian wheezy main

deb http://security.debian.org/ wheezy/updates main contrib
deb-src http://security.debian.org/ wheezy/updates main contrib

# wheezy-updates, previously known as 'volatile'
deb http://ftp.de.debian.org/debian wheezy-updates main contrib
deb-src http://ftp.de.debian.org/debian wheezy-updates main contrib
EOF

#Reconfigure apt so that it does not install additional packages
echo 'APT::Install-Recommends "0" ; APT::Install-Suggests "0" ; '>>/etc/apt/apt.conf

# install packages without user interaction:
export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install --no-install-recommends -y puppet git tcpdump mtr-tiny vim

puppet module install puppetlabs-stdlib
puppet module install puppetlabs-apt
puppet module install puppetlabs-vcsrepo

# Download the puppet package ffnord
cd /etc/puppet/modules
git clone https://github.com/ffnord/ffnord-puppet-gateway ffnord

if [ "x${FFNORD_TESTING_REPO}" != "x" ]; then
  cd ffnord
  git remote add testing "$FFNORD_TESTING_REPO"
  git fetch testing
  for branch in ${FFNORD_TESTING_BRANCHES[@]}; do
    git merge --no-ff "testing/${branch}"
  done
fi

cd "/vagrant/machines/${MACHINE}/"
cp -r * /root
cd /root
puppet apply manifest.pp --verbose

build-firewall
service iptables-persistent save
