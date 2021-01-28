#! /bin/bash
apt update && apt install curl wget unzip
wget -q https://github.com/shawn1m/overture/releases/download/v1.7-rc4/overture-linux-amd64.zip
unzip overture-linux-amd64.zip  "overture-linux-amd64"
mv overture-linux-amd64 /sbin/overture
cat << EOF > /lib/systemd/system/overture.service
[Unit]
Description=overture-dns-server
After=syslog.target network-online.target
[Service]
ExecStart=/sbin/overture -c /etc/overture/config.yml
StandardOutput=syslog
Restart=on-abnormal
[Install]
WantedBy=multi-user.target
EOF
mkdir /etc/overture
cat << EOF > /etc/overture/config.yml
bindAddress: :53
debugHTTPAddress:
dohEnabled: false
primaryDNS:
  - name: dns1
    address: 114.114.114.114:53
    protocol: udp
    socks5Address:
    timeout: 2
    ednsClientSubnet:
      policy: disable
      externalIP:
      noCookie: true
  - name: dns2
    address: 223.5.5.5:53
    protocol: udp
    socks5Address:
    timeout: 2
    ednsClientSubnet:
      policy: disable
      externalIP:
      noCookie: true
alternativeDNS:
  - name: google8888
    address: 8.8.8.8:53
    protocol: udp
    socks5Address:
    timeout: 3
    ednsClientSubnet:
      policy: disable
      externalIP:
      noCookie: true
  - name: google8844
    address: 8.8.4.4:53
    protocol: udp
    socks5Address:
    timeout: 3
    ednsClientSubnet:
      policy: disable
      externalIP:
      noCookie: true
onlyPrimaryDNS: false
ipv6UseAlternativeDNS: false
alternativeDNSConcurrent: true
whenPrimaryDNSAnswerNoneUse: alternativeDNS
ipNetworkFile:
  primary: /etc/overture/china_ip_list.txt
  alternative: /etc/overture/china_ip_list.txt
domainFile:
  primary: /etc/overture/china_list.txt
  alternative: /etc/overture/gfw_list.txt
  matcher: suffix-tree
hostsFile:
  hostsFile:
  finder: full-map
minimumTTL: 0
domainTTLFile:
cacheSize: 0
cacheRedisUrl:
cacheRedisConnectionPoolSize:
rejectQType:
  - 255
EOF
systemctl enable overture
