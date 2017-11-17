#!/bin/bash

PROC=$1

FLAG=0
for svc in server agent;do
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
 /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf  --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron
fi



if [[ $PROC == "server" ]];then
  /bin/sh -c "neutron-server --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini --log-file=/var/log/neutron/neutron-server.log" neutron
else 
  supervisord -c /etc/supervisord.conf
fi


