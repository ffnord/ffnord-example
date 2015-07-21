class {
  'ffnord::params':
    router_id => "10.35.0.1",
    icvpn_as => "65035",
	wan_devices => ['eth0','eth1'],
    
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
  dns_servers => [ '10.35.5.1', '10.35.10.1', '10.35.15.1', '10.35.20.1' ],
}

ffnord::fastd { "ffgc_old":
    mesh_code       => "ffgc",
    mesh_interface  => "ffgc-old",
    mesh_mac        => "de:ad:be:ef:fd:00",
    vpn_mac         => "de:ad:be:ef:fc:00",
    mesh_mtu        => 1426,
    fastd_secret    => "/root/fastd_secret.conf",
    fastd_port      => 10035,
    fastd_peers_git => '/vagrant/fastd/gc/'
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
