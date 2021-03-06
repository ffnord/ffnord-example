#!/usr/bin/env bash

# bootstrap script for all gateway simulation machines

# enable output what is executed:
set -x

MACHINE=$1

# optional: if you have brances in your own repo that should be merged add the repo here
# example: FFNORD_TESTING_REPO='https://github.com/ffnord/ffnord-puppet-gateway'
FFNORD_TESTING_REPO=''
# and add the branches here (komma separated):
FFNORD_TESTING_BRANCHES=('')

SCRIPTPATH="/vagrant"
MACHINE_PATH="$SCRIPTPATH/machines/${MACHINE}/"
mkdir -p "$MACHINE_PATH"

LSBDISTCODENAME='jessie'

cat > /etc/apt/sources.list << EOF
deb http://ftp.de.debian.org/debian $LSBDISTCODENAME main
deb-src http://ftp.de.debian.org/debian $LSBDISTCODENAME main

deb http://security.debian.org/ $LSBDISTCODENAME/updates main contrib
deb-src http://security.debian.org/ $LSBDISTCODENAME/updates main contrib

# $LSBDISTCODENAME-updates, previously known as 'volatile'
deb http://ftp.de.debian.org/debian $LSBDISTCODENAME-updates main contrib
deb-src http://ftp.de.debian.org/debian $LSBDISTCODENAME-updates main contrib
EOF

#Reconfigure apt so that it does not install additional packages
echo 'APT::Install-Recommends "0" ; APT::Install-Suggests "0" ; '>>/etc/apt/apt.conf

# install packages without user interaction:
export DEBIAN_FRONTEND=noninteractive

# comment this out, if you want to keep manuals, documentation and all locales in your machines
#source $SCRIPTPATH/minify_debian.sh

# setup locales
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8

apt-get update
apt-get install --no-install-recommends -y puppet git tcpdump mtr-tiny apt-transport-https \
								 tcpdump dnsutils realpath screen htop mlocate tig sudo cmake libpcap-dev
# optional apt-get install --no-install-recommends -y vim
if [ $LSBDISTCODENAME = "wheezy" ] || [ $LSBDISTCODENAME = "jessie" ]; then
  apt-get install -y vim-puppet
fi
if [ $LSBDISTCODENAME != "wheezy" ]; then
  apt-get install -y systemd-sysv libssl-dev
  # TODO: solve this in puppet
  modprobe ip_tables
  modprobe nf_conntrack
fi
puppet module install puppetlabs-stdlib --version 4.15.0
puppet module install puppetlabs-apt --version 1.5.2
puppet module install puppetlabs-vcsrepo --version 1.3.2
# usually installed on a gateway, but not needed in this example case:
#puppet module install saz-sudo
#puppet module install torrancew-account

: '####### Download the puppet package ffnord ######'
mkdir -p /etc/puppet/modules
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

cat > /etc/iptables.d/199-allow-wan << EOF
## allow all connections from wan for experimental envionments
ip46tables -A wan-input -j ACCEPT
EOF

build-firewall
service iptables-persistent save

# comment this out, if you want to keep manuals, documentation and all locales in your machines
#source $SCRIPTPATH/minify_debian.sh

service openvpn restart

if [ $LSBDISTCODENAME != "wheezy" ]; then
	#workaround restart puppet run after openvpn restart
	puppet apply manifest.pp --verbose
fi

service alfred restart
service isc-dhcp-server restart
service fastd restart

: '####### Check for services if they are running correctly ######'
SERVICES='(isc-dhcp-server|radvd|ntp|openvpn|rpcbind|fastd|bind9|bird6|bird|alfred|batadv-vis|named|tincd)'
service --status-all 2>&1 | egrep $SERVICES
pgrep -lf $SERVICES
ps aux | egrep $SERVICES

# download check-services
wget https://raw.githubusercontent.com/rubo77/ffnord-puppet-gateway/check-services/files/usr/local/bin/check-services
chmod +x check-services 
./check-services
echo "if check-services fails add MESH_CODE=ffgc to othe top"
