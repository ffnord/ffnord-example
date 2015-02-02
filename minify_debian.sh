#!/usr/bin/env bash

echo "### Reducing the size of the installation ###"

# show disk usage before and after
df -h

echo "Removing documentation and manuals"
cat > /etc/dpkg/dpkg.cfg.d/01_nodoc << EOF
path-exclude /usr/share/doc/*
path-exclude /usr/share/man/*
path-exclude /usr/share/groff/*
path-exclude /usr/share/info/*
# lintian stuff is small, but really unnecessary
path-exclude /usr/share/lintian/*
path-exclude /usr/share/linda/*
EOF
find /usr/share/doc -depth -type f |xargs rm || true
rm -rf /usr/share/man/* /usr/share/groff/* /usr/share/info/* /usr/share/lintian/* /usr/share/linda/* /var/cache/man/*

echo "Speed-up Grub boot, but always show the boot menu."
sed -i 's/GRUB_TIMEOUT=[[:digit:]]\+/GRUB_TIMEOUT=1/g' /etc/default/grub
sed -i 's/GRUB_HIDDEN_TIMEOUT/#GRUB_HIDDEN_TIMEOUT/g' /etc/default/grub
update-grub

# install packages without user interaction:
export DEBIAN_FRONTEND=noninteractive

echo "install localepurge to remove all unnecesary languages"
apt-get install -y localepurge
rm -rf /usr/share/man/??
rm -rf /usr/share/man/??_*
localepurge

echo "clean up"
apt-get autoremove -y; apt-get clean -y; apt-get autoclean -y;
rm -rf /var/lib/apt/lists/*

df -h
