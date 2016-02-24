#!/bin/bash
set -ue

# Systemd cannot use NSPAWN in non-privileged container
sed -i 's/PrivateTmp/#PrivateTmp/' /usr/lib/systemd/system/*.service
