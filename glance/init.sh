#!/bin/bash

INIT_DB=${INIT_DB:-true}


if [ "$INIT_DB" = "true" ]; then
 /bin/sh -c    "glance-manage db_sync" 
 /bin/sh -c "glance-manage db_load_metadefs /var/lib/openstack/etc/glance/metadefs/"
fi



exec glance-api


