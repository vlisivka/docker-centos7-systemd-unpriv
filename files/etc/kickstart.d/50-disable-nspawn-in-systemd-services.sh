#!/bin/bash
set -ue

# Systemd cannot use NSPAWN in non-privileged container
exec sed -i 's/PrivateTmp/#PrivateTmp/' /usr/lib/systemd/system/*.service
