#!/usr/bin/env bash

# install packages without user interaction:
export DEBIAN_FRONTEND=noninteractive

echo "### Reducing the size of the installation ###"

echo "==> Disk usage before cleanup"
df -h

echo "==> Speed-up Grub boot, but always show the boot menu."
sed -i 's/GRUB_TIMEOUT=[[:digit:]]\+/GRUB_TIMEOUT=1/g' /etc/default/grub
sed -i 's/GRUB_HIDDEN_TIMEOUT/#GRUB_HIDDEN_TIMEOUT/g' /etc/default/grub
update-grub

echo "==> Removing documentation and manuals"
cat > /etc/dpkg/dpkg.cfg.d/01_nodoc << EOF
path-exclude /usr/share/doc/*
path-exclude /usr/share/man/*
path-exclude /usr/share/groff/*
path-exclude /usr/share/info/*
# lintian stuff is small, but really unnecessary
path-exclude /usr/share/lintian/*
path-exclude /usr/share/linda/*
EOF

echo "==> install localepurge to remove all unnecesary languages"
apt-get install -y localepurge
localepurge

# source: https://github.com/box-cutter/debian-vm/blob/master/script/minimize.sh
echo "==> Installed packages before cleanup"
dpkg --get-selections | grep -v deinstall | cut -f 1 | xargs

# Remove some packages to get a minimal install
echo "==> Removing all linux kernels except the currrent one"
dpkg --list | awk '{ print $2 }' | grep 'linux-image-3.*-generic' | grep -v $(uname -r) | xargs apt-get -y purge

#echo "==> Removing linux headers"
#dpkg --list | awk '{ print $2 }' | grep linux-headers | xargs apt-get -y purge
#rm -rf /usr/src/linux-headers*
#echo "==> Removing linux source"
#dpkg --list | awk '{ print $2 }' | grep linux-source | xargs apt-get -y purge
#echo "==> Removing development packages"
#dpkg --list | awk '{ print $2 }' | grep -- '-dev$' | xargs apt-get -y purge

echo "==> Removing documentation packages"
dpkg --list | awk '{ print $2 }' | grep -- '-doc$' | xargs apt-get -y purge

echo "==> Removing X11 libraries"
apt-get -y purge libx11-data xauth libxmuu1 libxcb1 libx11-6 libxext6

echo "==> Removing obsolete networking components"
apt-get -y purge ppp pppconfig pppoeconf

echo "==> Removing other oddities"
apt-get -y purge popularity-contest installation-report wireless-tools wpasupplicant

#optional
#echo "==> Removing default system Python"
#apt-get -y purge python-dbus libnl1 python-smartpm python-twisted-core libiw30 python-twisted-bin libdbus-glib-1-2 python-pexpect python-pycurl python-serial python-gobject python-pam python-openssl

# Clean up orphaned packages with deborphan
apt-get -y install deborphan
while [ -n "$(deborphan --guess-all --libdevel)" ]; do
	deborphan --guess-all --libdevel | xargs apt-get -y purge
done
# apt-get -y purge deborphan dialog
echo those were just a wild guess
echo "--> nothing done"

echo "==> Purge prior removed packages"
dpkg -l|grep "^rc"|cut -f 3 -d" "|xargs apt-get -y purge

# Clean up the apt cache
apt-get -y autoremove --purge
apt-get -y autoclean
apt-get -y clean
echo "==> Removing APT lists"
find /var/lib/apt/lists -type f -delete
echo "==> Removing man pages"
find /usr/share/man -type f -delete
echo "==> Removing anything in /usr/src"
rm -rf /usr/src/*
echo "==> Removing any docs"
find /usr/share/doc -type f -delete
echo "==> Removing caches"
find /var/cache -type f -delete
echo "==> Removing groff info lintian linda"
rm -rf /usr/share/groff/* /usr/share/info/* /usr/share/lintian/* /usr/share/linda/*

echo "==> Disk usage after cleanup"
df -h
