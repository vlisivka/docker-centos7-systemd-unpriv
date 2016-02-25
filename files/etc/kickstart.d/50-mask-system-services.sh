#!/bin/bash
set -ue

# Mask (create override which points to /dev/null) system services, which
# cannot be started in container anyway.
cd /etc/mask.d/
exec systemctl mask *
