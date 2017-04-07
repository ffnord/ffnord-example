package {
  ['vim-puppet', 'tcpdump', 'dnsutils', 'realpath', 'screen', 'htop', 'mlocate', 'tig', 'sudo', 'mtr-tiny', 'cmake', 'libpcap-dev']:
     ensure => installed;
}

class {
  'ffnord::params':
  router_id => "10.35.0.1",       # The id of this router, probably the ipv4 address
                                  # of the mesh device of the providing community
  icvpn_as => "65035",            # The as of the providing community
  wan_devices => ['eth0','eth1'], # An array of devices which should be in the wan zone

  wmem_default => 87380,          # Define the default socket send buffer
  wmem_max     => 12582912,       # Define the maximum socket send buffer
  rmem_default => 87380,          # Define the default socket recv buffer
  rmem_max     => 12582912,       # Define the maximum socket recv buffer
  
  gw_control_ips => "217.70.197.1 89.27.152.1 138.201.16.163 8.8.8.8", # Define target to ping against for function check

  max_backlog  => 5000,           # Define the maximum packages in buffer
}

ffnord::mesh { 'mesh_ffgc':
  mesh_name        => "Freifunk Gotham City",
  mesh_as          => 65035,
  mesh_code        => "ffgc",
  mesh_mac         => "de:ad:be:ef:ff:00",
  vpn_mac          => "de:ad:be:ef:fe:00",
  mesh_ipv6        => "fd35:f308:a922::ff00/64",
  mesh_ipv4        => "10.35.0.1/19",
  range_ipv4       => "10.35.0.0/16",
  mesh_peerings    => "/root/mesh_peerings.yaml",

  fastd_secret     => "/root/fastd_secret.conf",
  fastd_port       => 11235,
  fastd_peers_git  => '/vagrant/fastd/gc/',

  dhcp_ranges => [ '10.35.0.2 10.35.4.254' ],
  dns_servers => [ '10.35.0.1' ],
}

#ffnord::fastd { "ffgc_old":
#    mesh_code       => "ffgc",
#    mesh_interface  => "ffgc-old",
#    mesh_mac        => "de:ad:be:ef:fd:00",
#    vpn_mac         => "de:ad:be:ef:fc:00",
#    mesh_mtu        => 1426,
#    fastd_secret    => "/root/fastd_secret.conf",
#    fastd_port      => 10035,
#    fastd_verify    => 'true',
#    fastd_peers_git => '/vagrant/fastd/gc/'
#}

ffnord::icvpn::setup { 'gotham_city0':
  icvpn_as           => 65035,
  icvpn_ipv4_address => "10.0.1.1",
  icvpn_ipv6_address => "fec0::a:cf:0:35",
  icvpn_exclude_peerings => [],
  tinc_keyfile       => "/root/tinc_rsa_key.priv"
}

class { 'ffnord::vpn::provider::generic':
  name => 'vpn-service',
  config => '/root/vpn-service'
}

#class { 'ffnord::alfred': master => true }

class { 'ffnord::rsyslog': }

class { 'ffnord::etckeeper': }
