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
docker build . --build-arg PROJECT=keystone --build-arg PROFILES="requirements"  --build-arg FROM=ubuntu:startcloud --tag keystone:ubuntu --no-cache --rm


