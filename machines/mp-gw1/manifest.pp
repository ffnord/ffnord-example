class {
  'ffnord::params':
    router_id => "10.215.8.1",
    icvpn_as => "65003",
	wan_devices => ['eth0','eth1'],
    
}

ffnord::mesh { 'mesh_ffmp':
  mesh_name        => "Freifunk Metropolis",
  mesh_as          => 65003,
  mesh_code        => "ffgc",
  mesh_mac         => "de:ad:be:ef:ff:01",
  mesh_ipv6        => "fdd7:e0f1:4128::ff01/64",
  mesh_ipv4        => "10.215.8.1/17",
  range_ipv4       => "10.215.0.0/16",
  mesh_peerings    => "/root/mesh_peerings.yaml",

  fastd_secret     => "/root/fastd_secret.conf",
  fastd_port       => 10003,
  fastd_peers_git  => '/vagrant/fastd/mp/',

  dhcp_ranges => [ '10.215.8.2 10.215.15.254' ],
  dns_servers => [ '10.215.0.1' ],
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

class { 'ffnord::alfred': }

class { 'ffnord::rsyslog': }

class { 'ffnord::etckeeper': }
