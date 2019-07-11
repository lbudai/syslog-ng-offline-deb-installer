#!/bin/bash -e

apt-key add $1.Release.key
echo "deb http://download.opensuse.org/repositories/home:/laszlo_budai:/syslog-ng/$1 ./" | tee /etc/apt/sources.list.d/syslog-ng-obs.list
apt-get update

