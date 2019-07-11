#!/bin/bash

source check-obs-distro-arg.sh

check_obs_distro "$1"

function get_docker_image_str
{
  local distro=$(echo "$1" | cut -d '_' -f 1 | tr '[:upper:]' '[:lower:]' | cut -d'x' -f 2)
  local version=$(echo "$1"| cut -d '_' -f 2)
  echo "$distro:$version"
}

obs_distro="$1"
./download-syslog-ng-obs-apt-key.sh "$obs_distro"
./start-docker.sh $(get_docker_image_str "$obs_distro") $@


