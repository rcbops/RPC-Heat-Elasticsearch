elasticsearch:
  user: elasticsearch
  group: elasticsearch
  download_url: https://download.elasticsearch.org/elasticsearch/elasticsearch
  version: 1.4.2
  md5: 70bbd1d63c91c71251012e7d8553e39d
  apt_pkgs:
    - htop
    - ntp
    - unzip

  max_open_files: 65535
  max_locked_memory: unlimited

  home_dir: /usr/share/elasticsearch
  plugin_dir: /usr/share/elasticsearch/plugins
  log_dir: /var/log/elasticsearch
  data_dir: /var/lib/elasticsearch
  work_dir: /tmp/elasticsearch
  conf_dir: /etc/elasticsearch

  service_startonboot: no
  service_state: started
  network_transport_tcp_port: 9300
  network_http_port: 9200

  discovery_zen_minimum_master_nodes: 1
  discovery_zen_ping_timeout: 30s

  auto_create_index: True
  disable_delete_all_indices: True
  query_bool_max_clause_count: 4096
  java_opts: "-XX:-UseSuperWord"


interfaces:
  public: eth0
  private: eth2

mine_functions:
  internal_ips:
    mine_function: network.ipaddrs
    interface: eth2
  external_ips:
    mine_function: network.ipaddrs
    interface: eth0
  id:
    - mine_function: grains.get
    - id
  host:
    - mine_function: grains.get
    - host

user-ports:
  ssh:
    chain: INPUT
    proto: tcp
    dport: 22
  salt-master:
    chain: INPUT
    proto: tcp
    dport: 4505
  salt-minion:
    chain: INPUT
    proto: tcp
    dport: 4506
  es-http:
    chain: INPUT
    proto: tcp
    dport: 9200
  es-transport:
    chain: INPUT
    proto: tcp
    dport: 9300
