#!/bin/bash
# DO NOT EXECUTE THIS SCRIPT LOCALLY, run ./firewall_runner.sh instead, to run it on your instance.
set -e

sudo apt update -y && sudo apt upgrade -y

if ! command -v firewall-cmd &> /dev/null; then
    echo "firewalld not found, installing..."
    sudo apt install firewalld -y
else
    echo "firewalld is already installed."
fi

echo "Starting firewall configuration..."

# Ensure firewalld is running
systemctl status firewalld > /dev/null
if [ $? -ne 0 ]; then
    echo "Starting firewalld service..."
    systemctl start firewalld
    systemctl enable firewalld
fi

echo "Removing old configuration..."
for service in $(firewall-cmd --zone=public --list-services); do
    firewall-cmd --zone=public --remove-service=$service
done
for port in $(firewall-cmd --zone=public --list-ports); do
    firewall-cmd --zone=public --remove-port=$port
done


echo "Applying custom configuration..."
firewall-cmd --zone=public --add-service=dhcpv6-client
firewall-cmd --zone=public --add-service=ssh # important, without that you can't access server
firewall-cmd --zone=public --add-port=3000/tcp # node
firewall-cmd --zone=public --add-port=8080/tcp # java

firewall-cmd --runtime-to-permanent

echo "Current firewall settings:"
firewall-cmd --list-all
