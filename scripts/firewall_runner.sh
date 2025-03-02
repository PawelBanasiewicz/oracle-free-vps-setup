#!/bin/bash
# Usage: Execute it to upload firewall.sh to your instance and execute it there.

HOST="ubuntu@xxx.xx.xxx.xxx" # IPv4 public address of your instance, see: https://cloud.oracle.com/compute/instances

scp ./firewall.sh "$HOST:~/firewall.sh"
ssh "$HOST" "sudo chmod +x firewall.sh; sudo ./firewall.sh"