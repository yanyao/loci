#!/bin/bash

PROC=$1


FLAG=0
for svc in server linuxbridge-agent dhcp-agent l3-agent metering-agent metadata-agent lbaasv2-agent;do
   if [[ $PROC == "$svc" ]];then
      FLAG=1
      break
   fi
done


if [[ $FLAG -eq 0 ]];then
    exit 12
fi

INIT_DB=${INIT_DB:-false}
VXLAN_INT=${VXLAN_INT:-eth1}
INT_MAPPING=${INT_MAPPING:-flat:eth12,vlan:eth11}

if [ "$INIT_DB" = "true" ]; then
 /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf  --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron
fi


ln -s /var/lib/openstack/bin/neutron-rootwrap /usr/bin/
ln -s /var/lib/openstack/bin/privsep-helper /usr/bin/

case $PROC in 
   server)
     /bin/sh -c "neutron-server --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini --log-file=/var/log/neutron/neutron-server.log" neutron
    ;;
   linuxbridge-agent)
      my_ip=`ip r|grep ${VXLAN_INT} |awk '{print $9}'` 
      echo $my_ip
      if [[  -z $my_ip  ]];then
        my_ip=127.0.0.1
      fi
      crudini --set etc/neutron/plugins/ml2/linuxbridge_agent.ini vxlan "local_ip" "$my_ip"
      crudini --set etc/neutron/plugins/ml2/linuxbridge_agent.ini linux_bridge "physical_interface_mappings" "${INT_MAPPING}"

      /bin/sh -c "neutron-linuxbridge-agent --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini --config-file /etc/neutron/plugins/ml2/linuxbridge_agent.ini" neutron
     
      ;;
    dhcp-agent)
      ip -all netns delete
      /bin/sh -c "neutron-dhcp-agent --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/dhcp_agent.ini " neutron
      ;;
    l3-agent)
      ip -all netns delete
      /bin/sh -c "neutron-l3-agent --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/l3_agent.ini" neutron
      ;;
    metering-agent)
      /bin/sh -c "neutron-metering-agent --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/metering_agent.ini" neutron
      ;;
    metadata-agent)
      /bin/sh -c "neutron-metadata-agent --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/metadata_agent.ini" neutron
      ;;
    lbaasv2-agent)
      /bin/sh -c "neutron-metadata-agent --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/lbaasv2-agent_agent.ini" neutron
      ;;
esac


