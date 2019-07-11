#!/bin/bash -e

source check-obs-distro-arg.sh

check_obs_distro "$@"

wget http://download.opensuse.org/repositories/home:/laszlo_budai:/syslog-ng/$1/Release.key -O ./$1.Release.key

