#!/usr/bin/env bash

# bootstrap script for all gateway simulation machines

# enable output what is executed:
set -x

MACHINE=$1

# optional: if you have brances in your own repo that should be merged add the repo here (example: 'https://github.com/...')
FFNORD_TESTING_REPO=''
# and add the branches here (komma separated):
FFNORD_TESTING_BRANCHES=('')

SCRIPTPATH="/vagrant"
MACHINE_PATH="$SCRIPTPATH/machines/${MACHINE}/"
mkdir -p "$MACHINE_PATH"

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

# comment this out, if you want to keep manuals, documentation and all locales in your machines
#source $SCRIPTPATH/minify_debian.sh

apt-get update
apt-get install --no-install-recommends -y puppet git tcpdump mtr-tiny
# optional apt-get install --no-install-recommends -y vim

puppet module install puppetlabs-stdlib 
puppet module install puppetlabs-apt --version 1.5.1
puppet module install puppetlabs-vcsrepo

: '####### Download the puppet package ffnord ######'
cd /etc/puppet/modules
git clone https://github.com/ffnord/ffnord-puppet-gateway ffnord

if [ "x${FFNORD_TESTING_REPO}" != "x" ]; then
  cd ffnord
  git remote add testing "$FFNORD_TESTING_REPO"
  git fetch testing
  for branch in ${FFNORD_TESTING_BRANCHES[@]}; do
    git merge --no-ff -X theirs "testing/${branch}"
  done
fi

cd "$MACHINE_PATH"
cp -r * /root
cd /root
puppet apply manifest.pp --verbose
# workaround for dependeny cycle (issue #25):
rm -rf /etc/fastd/*
puppet apply manifest.pp --verbose

cat > /etc/iptables.d/199-allow-wan << EOF
## allow all connections from wan for experimental envionments
ip46tables -A wan-input -j ACCEPT
EOF

build-firewall
service iptables-persistent save

# comment this out, if you want to keep manuals, documentation and all locales in your machines
#source $SCRIPTPATH/minify_debian.sh

service alfred start
/etc/init.d/fastd restart

: '####### Check for services if they are running correctly ######'
SERVICES='(isc-dhcp-server|radvd|ntp|openvpn|rpcbind|fastd|bind9|bird6|bird|alfred|batadv-vis|named|tincd)'
service --status-all 2>&1 | egrep $SERVICES
pgrep -lf $SERVICES
