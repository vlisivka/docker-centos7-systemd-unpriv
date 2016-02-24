[![Docker Repository on Quay](https://quay.io/repository/vlisivka/docker-centos7-systemd-unpriv/status "Docker Repository on Quay")](https://quay.io/repository/vlisivka/docker-centos7-systemd-unpriv)

[![Docker Repository on Docker hub](http://dockeri.co/image/vlisivka/docker-centos7-systemd-unpriv)](https://hub.docker.com/r/vlisivka/docker-centos7-systemd-unpriv/)

# Description

This is image of CentOS7 with systemd installed, which can be ran in unprivileged mode, or privileged mode (use with caution: in privileged mode systemd can affect host system, use --cap-add=SYS_ADMIN instead).

It contains initialization script /usr/local/sbin/init.sh, which allows of fine tuning of container before systemd is started via /kickstart.d/ directory:

# Shutdown

To shutdown container properly:

  * (docker 1.9) run container with option `docker run --stop-signal=$(kill -l RTMIN+3) CONTAINER`, so command `docker stop` will work properly;
  * OR kill server with signal RTMIN+3: `docker kill --signal=$(kill -l RTMIN+3) CONTAINER` 
  * OR attach to container and shutdown your services `systemctl stop SERVICE...`, then kill container.

