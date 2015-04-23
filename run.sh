#!/bin/bash

docker kill centos7_systemd
docker rm centos7_systemd
docker run -d -v /sys/fs/cgroup:/sys/fs/cgroup:ro --name centos7_systemd vlisivka/centos7-systemd-unpriv
sleep 1
docker logs centos7_systemd
