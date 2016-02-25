#!/bin/bash
set -ue

# Systemd cannot adjust out-of-memory killer in non-privileged container
exec sed -i 's/OOMScoreAdjust/#OOMScoreAdjust/' /usr/lib/systemd/system/*.service
