class {
  'ffnord::params':
    router_id => "10.35.0.1",
    icvpn_as => "65035",
    wan_devices => ['eth0']
}

ffnord::mesh { 'mesh_ffgc':
  mesh_name        => "Freifunk Gotham City",
  mesh_as          => 65035,
  mesh_code        => "ffgc",
  mesh_mac         => "de:ad:be:ef:ff:00",
  mesh_ipv6        => "fd35:f308:a922::ff00/64",
  mesh_ipv4        => "10.35.0.1/19",
  mesh_peerings    => "/root/mesh_peerings.yaml",

  fastd_secret => "50292dd647f0e41eb0c72f18c652bfd1bea8c8bd00ae9da3f772068b78111644",
  fastd_port   => 10035,
  fastd_peers_git => 'git://freifunk.in-kiel.de/fastd-peer-keys.git',

  dhcp_ranges => [ '10.35.0.2 10.35.4.254' ],
  dns_servers => [ '10.35.5.1', '10.35.10.1', '10.35.15.1', '10.35.20.1' ],
}

ffnord::bird6::icvpn { 'gotham_city0':
  icvpn_as           => 65035,
  icvpn_ipv4_address => "10.112.0.1",
  icvpn_ipv6_address => "fec0::a:cf:0:35",
  icvpn_exclude_peerings => [],
  tinc_keyfile       => "/root/tinc_rsa_key.priv"
}

class { 'ffnord::alfred': }

class { 'ffnord::rsyslog': }
