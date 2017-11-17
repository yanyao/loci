#!/bin/bash

INIT_DB=${INIT_DB:-true}

if [ "$INIT_DB" = "true" ]; then
 /bin/sh -c    "keystone-manage db_sync" keystone
 /bin/sh -c    "keystone-manage bootstrap --bootstrap-password passw0rd --bootstrap-admin-url http://keystone:35357/v3/  --bootstrap-internal-url http://keystone:5000/v3/ --bootstrap-region-id RegionOne" keystone
fi





# Start the first process
uwsgi -i /etc/uwsgi/keystone-wsgi-public.ini &
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start keystone-wsgi-public: $status"
  exit $status
fi

# Start the second process
uwsgi -i /etc/uwsgi/keystone-wsgi-admin.ini &
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start keystone-wsgi-admin: $status"
  exit $status
fi

# Naive check runs checks once a minute to see if either of the processes exited.
# This illustrates part of the heavy lifting you need to do if you want to run
# more than one service in a container. The container will exit with an error
# if it detects that either of the processes has exited.
# Otherwise it will loop forever, waking up every 60 seconds

while /bin/true; do
  ps aux |grep keystone-wsgi-public |grep -q -v grep
  PROCESS_1_STATUS=$?
  ps aux |grep keystone-wsgi-admin |grep -q -v grep
  PROCESS_2_STATUS=$?
  # If the greps above find anything, they will exit with 0 status
  # If they are not both 0, then something is wrong
  if [ $PROCESS_1_STATUS -ne 0 -o $PROCESS_2_STATUS -ne 0 ]; then
    echo "One of the processes has already exited."
    exit -1
  fi
  sleep 60
done

