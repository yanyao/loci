#!/bin/bash

set -ex

if [[ "${PYTHON3}" != "no" ]]; then
    python3=python3
fi

PACKAGES=($(bindep -f /opt/loci/bindep.txt -b ${PROJECT} ${PROFILES} ${python3} || :))
EXTRA_PIP_PACKAGES=(${EXTRA_PIP_PACKAGES[@]})


if [[ ! -z ${PACKAGES} ]]; then
    case ${distro} in
        debian|ubuntu)
            apt-get install -y --no-install-recommends ${PACKAGES[@]}
            ;;
        centos)
            yum -y --setopt=skip_missing_names_on_install=False install ${PACKAGES[@]}
            ;;
        *)
            echo "Unknown distro: ${distro}"
            exit 1
            ;;
    esac
fi

if [[ ! -z ${EXTRA_PIP_PACKAGES} ]];then
   pip install  -c /tmp/wheels/upper-constraints.txt ${EXTRA_PIP_PACKAGES[@]}
fi
