# FfNord Community Example

Instead of taking real communities we decided to take a subset of the DC Universe
for our examples. This document is nailing the details for those communities.

There are three villages inside our setting, named:

 * Gotham
 * Metropolis
 * Smallville

Inside these three villages Freifunk communities have emerged. These communities
started to cooperate and also use an intercity-VPN as well as air based links
between the sites. Every community has decided basic values of its setup.

Furthermore we rollout configuration details and with the help of `vagrant`,
are able to instantiate parts of the machines described below. So we
have a nearly full featured multi-community environment to experiment with.

## The Communities 

**Gotham** is the oldest of the three communities with hundreds of nodes and
an evolved large backbone infrastructure. Including 5 existing gateway servers.
And many services. **Metropolis** has been inspired by Gotham and has a strong
growing community with two existing gateways. And finally **Smallville**, a community in its beginning, has
only a few nodes and has nearly no infrastructure by itself thus relies on the help of the other communities
in its region. So the other communities, both have one of their gateways
be a multi community gateway, and help Smallville to kickstart their infrastructure.

### Gotham City

 * Site Code: FFGC
 * Site TLD:  .ffgc
 * Site AS:   65035

 * IPv6 ULA:         fd35:f308:a922::/48
 * IPv6 Mesh Prefix: fd35:f308:a922::/64

 * IPv4 Network:     10.35.0.0/16
 * IPv4 Mesh Subnet: 10.35.0.0/19 Netmask: 255.255.224.0

 * Port used for VPN: 10035

 * Existing Gateway Servers:
   * GC-GW0: IPv4 10.35.0.1    IPv6 fd35:f308:a922::ff00
   * GC-GW1: IPv4 10.35.5.1    IPv6 fd35:f308:a922::ff01
   * GC-GW2: IPv4 10.35.10.1   IPv6 fd35:f308:a922::ff02
   * GC-GW3: IPv4 10.35.15.1   IPv6 fd35:f308:a922::ff03
   * GC-GW4: IPv4 10.35.20.1   IPv6 fd35:f308:a922::ff04

 Every gateway runs DNS, ICVPN, AnonVPN, NTP, DHCP and RADV.

 * Monitoring Server:
   * GC-MO0: IPv4 10.35.31.1   IPv6 fd35:f308:a922::fd00
   * GC-MO1: IPv4 10.35.31.2   IPv6 fd35:f308:a922::fd01

 * Mirror Server:
   * GC-MI0: IPv4 10.35.31.50   IPv6 fd35:f308:a922::fc00
   * GC-MI1: IPv4 10.35.31.51   IPv6 fd35:f308:a922::fc01


### Metropolis

 * Site Code: FFMP
 * Site TLD:  .ffmp
 * Site AS:   65003

 * IPv6 ULA:         fd03:5fcf:9003::/48
 * IPv6 Mesh Prefix: fd03:5fcf:9003::/64
  
 * IPv4 Network:     10.3.0.0/16 
 * IPv4 Mesh Subnet: 10.3.0.0/17 Netmask 255.255.128.0

 * Port used for VPN: 10003

 * Existing Gateway Servers:
   * MP-GW0: IPv4 10.3.0.1    IPv6 fd03:5fcf:9003::ff00
   * MP-GW1: IPv4 10.3.8.1    IPv6 fd03:5fcf:9003::ff01

   Every gateway runs DNS, ICVPN, AnonVPN, NTP, DHCP and RADV.

 * Monitoring Server:
   * MP-MO0: IPv4 10.3.120.1   IPv6  fd03:5fcf:9003::fd00

 * Monitoring Server:
   * MP-MO0: See MP-GW0


### Smallville

 * Site Code: FFSV
 * Site TLD:  .ffsv
 * Site AS:   65215

 * IPv6 ULA:         fdd7:e0f1:4128::/48 
 * IPv6 Mesh Prefix: fdd7:e0f1:4128::/64

 * IPv4 Network:     10.215.0.0/16
 * IPv4 Mesh Subnet: 10.215.0.0/19 Netmask 255.255.224.0
 
 * Port used for VPN: 10215

 * Existing Gateway Servers:
   * SV-GW0: (MP-GW0) IPv4: 10.215.0.1  IPv6: fdd7:e0f1:4128::ff00
   * SV-GW1: (GC-GW0) IPv4: 10.215.16.1  IPv6: fdd7:e0f1:4128::ff01


## Experimental environment

### INSTALL

install the packages vagrant and virtualbox, for example on debian:

    sudo apt-get install vagrant virtualbox
    
Vagrant 1.5 or later is required, which is available on the [Vagrant download page](http://www.vagrantup.com/downloads.html)

Now start your virtualbox service.

To explore the described communities and to have an experimental environment for
testing of new features and tools, you like to deploy in your real world community,
you can setup parts of or the whole virtual world, using `vagrant`.

Before you start to roll out the virtual machines you should proceed some setup steps:

You need about 10 GB free diskspace (1.2 GB for each f the 8 virtual machines) in your homefolder in `~/VirtualBox VMs/`.

The following will initialise a git repository in all fastd subdirs and the icvpn directory,
these are the repositories of the communities. They will be checked out by the created
machines.

    for dir in fastd/* icvpn; do ( cd ${dir} ; git init ; git add --all ; git commit -m "Initial commit" ) done

Now we can rollout some of the machines.

    vagrant up services gc-gw0 gc-gw1 mp-gw0 mp-gw1
    # Get a cup of coffee, take a walk or do something interesting. This will take time...
    vagrant ssh gc-gw0

Vagrant uses the configuration in `Vagrantfile` to create each machine. In our `Vagrantfile` there is defined that on each machine the shell script `bootstrap.sh` is executed on install, so if you like to change the way machines are deployed, you can manipulate the `bootstrap.sh`.

On each machine this folder is mounted in the path `/vagrant/`. This way the configurations from the ffnord-example can be transfered on each machine.

If you want to see the boot process on the VMs, you can enable the virtualbox gui in `Vagrantfile` by uncommenting the line

    vb.gui = true


### The services machine

This special machine simulates third party service provider, like anonvpn via openvpn.
It has an own bootstrap file `bootstrap-services.sh`.
