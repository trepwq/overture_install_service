#! /bin/bash
cd /etc/overture
rm china_list.txt gfw_list.txt china_ip_list.txt
curl -s https://raw.githubusercontent.com/17mon/china_ip_list/master/china_ip_list.txt > china_ip_list.txt
curl -s https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/accelerated-domains.china.conf  | sed 's/server=\///g;s/\/114.114.114.114//g' > china_list1.txt
curl -s https://raw.githubusercontent.com/hq450/fancyss/master/rules/WhiteList_new.txt  | sed 's/Server=\///g;s/\///g' > china_list2.txt
cat china_list1.txt china_list2.txt | sort -u > china_list.txt
rm china_list1.txt china_list2.txt
curl -s https://raw.githubusercontent.com/Loukky/gfwlist-by-loukky/master/gfwlist.txt | base64 -d | sort -u | sed '/^$\|@@/d'| sed 's#!.\+##; s#|##g; s#@##g; s#http:\/\/##; s#https:\/\/##;' | sed '/\*/d; /apple\.com/d; /sina\.cn/d; /sina\.com\.cn/d; /baidu\.com/d; /qq\.com/d' | sed '/^[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+$/d' | grep '^[0-9a-zA-Z\.-]\+$' | grep '\.' | sed 's#^\.\+##' | sort -u > gfwlist.txt
curl -s https://raw.githubusercontent.com/hq450/fancyss/master/rules/gfwlist.conf | sed 's/ipset=\/\.//g; s/\/gfwlist//g; /^server/d' > koolshare.txt
cat gfwlist.txt koolshare.txt | sort -u > gfw_list.txt
rm gfwlist.txt  koolshare.txt
systemctl restart overture
