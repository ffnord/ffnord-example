class {
  'ffnord::params':
  router_id => "10.215.8.1",      # The id of this router, probably the ipv4 address
                                  # of the mesh device of the providing community
  icvpn_as => "65003",            # The as of the providing community
  wan_devices => ['eth0','eth1'], # An array of devices which should be in the wan zone

  wmem_default => 87380,          # Define the default socket send buffer
  wmem_max     => 12582912,       # Define the maximum socket send buffer
  rmem_default => 87380,          # Define the default socket recv buffer
  rmem_max     => 12582912,       # Define the maximum socket recv buffer
  
  gw_control_ips => "217.70.197.1 89.27.152.1 138.201.16.163 8.8.8.8", # Define target to ping against for function check

  max_backlog  => 5000,           # Define the maximum packages in buffer
}

ffnord::mesh { 'mesh_ffmp':
  mesh_name        => "Freifunk Metropolis",
  mesh_as          => 65003,
  mesh_code        => "ffmp",
  mesh_mac         => "de:ad:be:ef:ff:01",
  vpn_mac          => "de:ad:be:ef:fe:01",
  mesh_ipv6        => "fdd7:e0f1:4128::ff01/64",
  mesh_ipv4        => "10.215.8.1/17",
  range_ipv4       => "10.215.0.0/16",
  mesh_peerings    => "/root/mesh_peerings.yaml",

  fastd_secret     => "/root/fastd_secret.conf",
  fastd_port       => 11203,
  fastd_peers_git  => '/vagrant/fastd/mp/',

  dhcp_ranges => [ '10.215.8.2 10.215.15.254' ],
  dns_servers => [ '10.215.8.1' ],
}

ffnord::fastd { "ffmp_old":
    mesh_code       => "ffmp",
    mesh_interface  => "ffmp-old",
    mesh_mac        => "de:ad:be:ef:fd:01",
    vpn_mac         => "de:ad:be:ef:fc:01",
    mesh_mtu        => 1426,
    fastd_secret    => "/root/fastd_secret.conf",
    fastd_port      => 10003,
    fastd_peers_git => '/vagrant/fastd/mp/'
}

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

#class { 'ffnord::alfred': }

class { 'ffnord::rsyslog': }

class { 'ffnord::etckeeper': }
