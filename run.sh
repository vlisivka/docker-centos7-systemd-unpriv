#!/bin/bash

docker run -d --stop-signal=$(kill -l RTMIN+3) -v /sys/fs/cgroup:/sys/fs/cgroup:ro --name centos7_systemd vlisivka/centos7-systemd-unpriv "$@"
echo "INFO: Use command \"docker logs centos7_systemd\" to see logs of container."
