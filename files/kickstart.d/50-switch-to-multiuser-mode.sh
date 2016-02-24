#!/bin/bash
set -ue

# Change target init stage from from graphical mode to multiuser text-only mode.
exec systemctl set-default multi-user.target
