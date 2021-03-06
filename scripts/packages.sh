#!/bin/bash

set -x

date

install_vhd_util () {
  [[ -f /bin/vhd-util ]] && return

  wget --no-check-certificate http://download.cloud.com.s3.amazonaws.com/tools/vhd-util -O /bin/vhd-util
  chmod a+x /bin/vhd-util
}

install_packages () {
  DEBIAN_FRONTEND=noninteractive
  DEBIAN_PRIORITY=critical
  local arch=`dpkg --print-architecture`

  install_vhd_util

  local apt_get="apt-get --no-install-recommends -q -y --force-yes"

  #32 bit architecture support:: not required for 32 bit template
  if [ "${arch}" != "i386" ]; then
    dpkg --add-architecture i386
    apt-get update
    ${apt_get} install links:i386 libuuid1:i386 libc6:i386
  fi

  ${apt_get} -t wheezy-backports install keepalived irqbalance open-vm-tools qemu-guest-agent haproxy iputils-ping
  ${apt_get} -t wheezy-backports install strongswan libcharon-extra-plugins libstrongswan-extra-plugins

  ${apt_get} -t wheezy-backports install initramfs-tools
  ${apt_get} -t wheezy-backports install linux-image-3.16.0-0.bpo.4-amd64

  apt-get update
  apt-get -y --force-yes upgrade

  if [ "${arch}" == "amd64" ]; then
    # XS tools
    wget https://raw.githubusercontent.com/bhaisaab/cloudstack-nonoss/master/xe-guest-utilities_6.5.0_amd64.deb
    dpkg -i xe-guest-utilities_6.5.0_amd64.deb
    rm -f xe-guest-utilities_6.5.0_amd64.deb
  fi
}

return 2>/dev/null || install_packages
