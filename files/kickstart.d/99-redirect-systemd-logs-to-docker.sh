#!/bin/bash

# Wait 1s (so systemd will start and create log files for journalctl to watch).
# TODO: FIXME: create journal manually, to avoid waiting.
( ( sleep 1 && exec journalctl -o short -f </dev/null ) & )

# OR simple alternative for syslog logs or custom log.
# touch /var/log/messages && ( exec tail -f /var/log/messages </dev/null & )

# OR use "cat" command and your own pipe.
# mkfifo /var/log/docker-log.sock && ( exec cat /var/log/docker-log.sock </dev/null & )
