#!/bin/bash - 
#===============================================================================
#
#          FILE: build_docker.sh
# 
#         USAGE: ./build_docker.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 11/15/2017 23:58
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
#docker build . --build-arg PROJECT=glance --build-arg PROFILES="ceph cinder ceph glance ceph nova  requirements glance" --build-arg FROM=ubuntu:startcloud --tag glance:ubuntu --no-cache --rm
docker build . --build-arg PROJECT=cinder --build-arg PROFILES="requirements ceph cinder ceph nova ceph glance" --build-arg FROM=ubuntu:startcloud --tag cinder:ubuntu --no-cache --rm


