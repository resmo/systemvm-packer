#!/bin/bash

set -x

date

add_backports () {
  sed -i '/backports/d' /etc/apt/sources.list
  echo 'deb http://http.debian.net/debian stretch-backports main' >> /etc/apt/sources.list
}

apt_upgrade () {
  DEBIAN_FRONTEND=noninteractive
  DEBIAN_PRIORITY=critical

  add_backports

  apt-get clean
  apt-get -q -y update
  apt-get -q -y upgrade
}

return 2>/dev/null || apt_upgrade
