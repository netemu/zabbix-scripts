#!/bin/bash
# zagent.sh : install and configure zabbix agent components
#

# get settings to use to configure the agent from user
echo -e "What's the IP for the Zabbix server?"
read ZABBIX_SERVER_IP < /dev/tty
echo -e "What's the IP for this server to listen on?"
read THIS_SERVER_IP < /dev/tty
echo -e "What's this server's hostname that Zabbix uses?"
read THIS_SERVER_HOSTNAME < /dev/tty

# official zabbix 2.2 (lts version) supported sources for ubuntu 14.04
pushd /tmp
wget --quiet http://repo.zabbix.com/zabbix/2.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_2.2-1+trusty_all.deb
dpkg -i zabbix-release_2.2-1+trusty_all.deb
apt-get -qq -y update
popd

# install zabbix agent
apt-get -qq -y install zabbix-agent

# add zabbix user to the 'adm' group (necessary for log monitoring)
usermod -a -G adm zabbix

# add configure zabbix agent
cat > /etc/zabbix/zabbix_agent.conf << DELIM
PidFile=/var/run/zabbix/zabbix_agent.pid
LogFile=/var/log/zabbix-agent/zabbix_agent.log
LogFileSize=0
Hostname=$THIS_SERVER_HOSTNAME
SourceIP=$THIS_SERVER_IP
ListenIP=$THIS_SERVER_IP
ListenPort=10050
Server=$ZABBIX_SERVER_IP
ServerActive=$ZABBIX_SERVER_IP
Include=/etc/zabbix/zabbix_agent.conf/
DELIM

# install git just in case, then clone my zabbix-scripts repo
apt-get -qq -y install git
pushd /tmp
https://github.com/vicgarcia/zabbix-scripts.git
# XXX install stuff via cp from here
popd


# create location for zabbix monitor scripts
#mkdir -p /etc/zabbix/scripts

# create location for the zabbix agent configs
#mkdir -p /etc/zabbix/zabbix_agent.conf

# install redis monitor script from git repo with curl

# install redis monitoring ...
#curl -o /etc/zabbix/zabbix_agent.conf/config-redis.conf \
#    https://raw.githubusercontent.com/vicgarcia/zabbix-scripts/master/config-redis.conf
#curl -o /etc/zabbix/scripts/monitor-redis.pl \
#    https://raw.githubusercontent.com/vicgarcia/zabbix-scripts/master/monitor-redis.pl
#chmod +x /etc/zabbix/scripts/monitor-redis.pl

# install nginx monitoring ...
#curl -o /etc/zabbix/zabbix_agent.conf/config-nginx.conf \
#    https://raw.githubusercontent.com/vicgarcia/zabbix-scripts/master/config-nginx.conf
#curl -o /etc/zabbix/scripts/monitor-nginx.sh \
#    https://raw.githubusercontent.com/vicgarcia/zabbix-scripts/master/monitor-nginx.sh
#curl -o /etc/zabbix/scripts/nginx-stats-site.conf \
#    https://raw.githubusercontent.com/vicgarcia/zabbix-scripts/master/nginx-stats-site.conf
#chmod +x /etc/zabbix/scripts/monitor-nginx.sh

# install mysql monitoring ...
#curl -o /etc/zabbix/zabbix_agent.conf/config-mysql.conf \
#    https://raw.githubusercontent.com/vicgarcia/zabbix-scripts/master/config-mysql.conf

# install postgres monitoring ...
#curl -o /etc/zabbix/zabbix_agent.conf.d/config-pgsql.conf \
#    https://raw.githubusercontent.com/vicgarcia/zabbix-scripts/master/config-pgsql.conf
#curl -o /etc/zabbix/scripts/monitor-pgsql-find-dbname.sh \
#    https://raw.githubusercontent.com/vicgarcia/zabbix-scripts/master/monitor-pgsql-find-dbname.sh
#curl -o /etc/zabbix/scripts/monitor-pgsql-find-dbname-table.sh \
#    https://raw.githubusercontent.com/vicgarcia/zabbix-scripts/master/monitor-pgsql-find-dbname-table.sh
#chmod +x /etc/zabbix/scripts/monitor-pgsql-find-dbname.sh
#chmod +x /etc/zabbix/scripts/monitor-pgsql-find-dbname-table.sh

# enable zabbix agent start on boot
#update-rc.d zabbix-server defaults

# restart zabbix agent with new settings
#service zabbix-agent restart

# references
#   http://www.badllama.com/content/monitor-mysql-zabbix
#   http://addmoremem.blogspot.com/2010/10/zabbixs-template-to-monitor-redis.html
#   https://github.com/jizhang/zabbix-templates
#   http://www.hjort.co/2009/12/postgresql-monitoring-on-zabbix.html
#   http://pg-monz.github.io/pg_monz/index-en.html
#
