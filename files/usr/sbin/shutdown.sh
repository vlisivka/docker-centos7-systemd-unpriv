#!/bin/bash

# Quote from systemd man page:
#
# SIGRTMIN+3
#   Halts the machine, starts the halt.target unit. This is mostly
#   equivalent to systemctl start halt.target.
kill -s RTMIN+3 1
