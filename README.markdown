# FfNord Community Example

Instead of taking real communities we decided to take a subset of the DC Universe
for our examples. This document is nailing the details for those communities.

There are three villages inside our setting, named:

 * Gotham
 * Metropolis
 * Smallville

Inside these three villages Freifunk communities have emerged. These communities
started to cooperate and also use an intercity as well as air based links
between the sites. Every community has decided basic values of its setup.

Gotham is the oldest of the three communities with hundreds of nodes and
a evolved large backbone infrastructure. Including 5 existing gateway servers.
And many services. Metropolis has been inspired by Gotham and has a strong
growing community with 2 existing gateways. And finally Smallville has
only few nodes and is an community in its beginning, has nearly no
infrastructure by itself and relies on the help of the other communities
in its region. So the other communities, both, have one of their gateways
be a multi community gateway, and help Smallville to kickstart their
infrastructure.

## Gotham City

 * Site Code: FFGC
 * Site TLD:  .ffgc

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


## Metropolis

 * Site Code: FFMP
 * Site TLD:  .ffmp

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


## Smallville

 * Site Code: FFSV
 * Site TLD:  .ffsv

 * IPv6 ULA:         fdd7:e0f1:4128::/48 
 * IPv6 Mesh Prefix: fdd7:e0f1:4128::/64

 * IPv4 Network:     10.215.0.0/16
 * IPv4 Mesh Subnet: 10.215.0.0/19 Netmask 255.255.224.0
 
 * Port used for VPN: 10215

 * Existing Gateway Servers:
   * SV-GW0: (MP-GW0) IPv4: 10.215.0.1  IPv6: fdd7:e0f1:4128::ff00
   * SV-GW1: (GC-GW0) IPv4: 10.215.16.1  IPv6: fdd7:e0f1:4128::ff01

