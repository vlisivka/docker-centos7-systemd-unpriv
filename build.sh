#!/bin/bash

exec docker build -t vlisivka/docker-centos7-systemd-unpriv "$@" .
