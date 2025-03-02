#!/bin/bash
# Usage: Run it to connect to your instance.

HOST="ubuntu@xxx.xx.xxx.xxx" # IPv4 public address of your instance, see: https://cloud.oracle.com/compute/instances

ssh "$HOST"

# The first time you use ssh you might need to supply the certificate.
# First, move your private key to this directory (named 'server.key'), then:
# run this instead (comment previous ssh command, uncomment this command):
# ssh -i ./server.key "$HOST"