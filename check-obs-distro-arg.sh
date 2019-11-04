SUPPORTED_DISTROS=("Debian_8.0"
                   "Debian_9.0"
                   "Debian_10"
                   "xUbuntu_14.04"
                   "xUbuntu_16.04"
                   "xUbuntu_18.04"
                   "xUbuntu_18.10"
                   "xUbuntu_19.10")

function check_obs_distro
{
if [ "$#" -ne 1 ]; then
  echo "usage: $0 OBS distro name"
  echo "examples: "
  echo "  $0 xUbuntu_16.04"
  echo "  $s Debian_9.0"
  exit 1
fi

if [[ ! " ${SUPPORTED_DISTROS[@]} " =~ " $1 " ]]; then
  echo "$1 is not supported"
  echo "list of supported distros:"
  echo "${SUPPORTED_DISTROS[@]}"
  exit 1
fi
}

