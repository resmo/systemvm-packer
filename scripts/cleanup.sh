#!/bin/bash

set -x

date

echo "Removing uneeded packages"
apt-get -y autoremove
apt-get -y clean

echo "cleaning up dhcp leases"
rm -f /var/lib/dhcp/*

echo "cleaning up udev rules"
rm -f /etc/udev/rules.d/70-persistent-net.rules
rm -rf /dev/.udev/
rm -f /lib/udev/rules.d/75-persistent-net-generator.rules

echo "cleaning up log files"
if [ -f /var/log/audit/audit.log ]; then cat /dev/null > /var/log/audit/audit.log; fi
cat /dev/null > /var/log/wtmp 2>/dev/null
logrotate -f /etc/logrotate.conf 2>/dev/null
rm -f /var/log/*-* /var/log/*.gz 2>/dev/null
rm -f /var/log/upstart/*.log /var/log/upstart/*.log.*.gz

echo "removing history"
history -c
unset HISTFILE
