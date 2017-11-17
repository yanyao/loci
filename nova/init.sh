#!/bin/bash

PROC=$1

FLAG=0
for svc in api scheduler compute placement conductor metadata spicehtml5proxy novncproxy consoleauth;do
   if [[ $PROC == "$svc" ]];then
      FLAG=1
      break
   fi
done


if [[ $FLAG -eq 0 ]];then
    exit 12
fi

INIT_DB=${INIT_DB:-true}


if [ "$INIT_DB" = "true" ]; then
 /bin/sh -c    "cinder-manage db sync" 
fi



exec cinder-${PROC}


