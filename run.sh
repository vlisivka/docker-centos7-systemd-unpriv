#!/bin/bash

docker run -dt \
  --stop-signal=$(kill -l RTMIN+3) \
  -v=/sys/fs/cgroup:/sys/fs/cgroup:ro \
  $(mount | awk '/\/sys\/fs\/cgroup\// && ! /systemd/ { print "-v="$3":"$3":ro" ; }' ) \
  --name centos7_systemd \
  vlisivka/docker-centos7-systemd-unpriv \
  "$@"

echo "INFO: Use command \"docker logs centos7_systemd\" to see logs of container."
