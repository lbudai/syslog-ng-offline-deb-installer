#!/bin/bash

OBS_DISTRO="$1"
shift

./setup-sources-list.sh "$OBS_DISTRO"

PACKAGE_LIST=$@
TMP_CACHE_DIR="$PWD/bundle"

function check_args
{
  if [ "$#" -lt 1 ]; then
    echo "usage: $0 <package names>"
    echo "example: $0 syslog-ng-core syslog-ng-mod-pgsql"
    exit 1
  fi
}

function create_tmp_cache_dir
{
  mkdir $TMP_CACHE_DIR
}

function download_package_list
{
  apt-get -y --reinstall --download-only -o Dir::Cache="$TMP_CACHE_DIR" \
        -o Dir::Cache::archives="$TMP_CACHE_DIR/archives" install $PACKAGE_LIST
}

function targz_packages
{
  mv $TMP_CACHE_DIR/archives .
  tar czf bundle.tgz archives
  rm -rf archives
}

function generate_installer
{
  mkdir installer
  mv bundle.tgz installer/
  cd installer
  echo "#!/bin/sh -e" > install.sh
  echo "tar xzf bundle.tgz" >> install.sh
  echo "dpkg -i archives/*.deb" >> install.sh
  chmod +x install.sh
  cd ..
  tar czf installer.tgz installer
  rm -rf installer
}

function remove_tmp_cache_dir
{
  if [ -d "$TMP_CACHE_DIR" ]; then
    rm -rf "$TMP_CACHE_DIR"
  fi
}

function main
{
  create_tmp_cache_dir
  download_package_list
  targz_packages
  generate_installer
  remove_tmp_cache_dir
}

check_args "$@"
main

