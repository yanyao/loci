#!/bin/bash

PROC=$1

FLAG=0
for svc in api-os-compute scheduler compute placement conductor api-metadata spicehtml5proxy novncproxy consoleauth;do
   if [[ $PROC == "$svc" ]];then
      FLAG=1
      break
   fi
done


if [[ $FLAG -eq 0 ]];then
    exit 12
fi

INIT_DB=${INIT_DB:-false}
SPICE_HTML5PROXY_BASE_URL=${SPICE_HTML5PROXY_BASE_URL:-http://172.29.236.100:6082/spice/auto.html}
SPICE_LISTEN=${SPICE_LISTEN:-0.0.0.0}
SPICE_SERVER_PROXYCLIENT_ADDRESS=${SPICE_SERVER_PROXYCLIENT_ADDRESS:-127.0.0.1}


if [ "$INIT_DB" = "true" ]; then
 /bin/sh -c    "nova-manage api_db version" nova
 /bin/sh -c    "nova-manage api_db sync" nova
 /bin/sh -c    "nova-manage cell_v2 map_cell0" nova
 /bin/sh -c    "nova-manage cell_v2 create_cell --name cell1" nova
 /bin/sh -c    "nova-manage api_db sync" nova
 /bin/sh -c    "nova-manage db sync" nova

fi




ln -s /var/lib/openstack/bin/nova-rootwrap /usr/bin/
ln -s /var/lib/openstack/bin/privsep-helper /usr/bin/


case "$PROC" in 
  api-os-compute)
     uwsgi --ini /etc/uwsgi/nova-api-os-compute.ini
     ;;
  api-metadata)
     uwsgi --ini /etc/uwsgi/nova-api-metadata.ini
     ;;
  placement)
     uwsgi --ini /etc/uwsgi/nova-placement-api.ini
    ;;
  *)
     crudinit --set /etc/nova/nova.conf spice "html5proxy_base_url" "$SPICE_HTML5PROXY_BASE_URL"
     crudinit --set /etc/nova/nova.conf spice "listen" "$SPICE_LISTEN"
     crudinit --set /etc/nova/nova.conf spice "server_proxyclient_address" "$SPICE_SERVER_PROXYCLIENT_ADDRESS"
     /bin/sh -c "nova-$PROC" nova
    ;;
esac
