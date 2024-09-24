#!/bin/bash

# Prompt for username and port number
read -p "Enter the username to add: " USERNAME
read -p "Enter the SSH port number to configure: " SSH_PORT

# Add user and add to sudo group
adduser "$USERNAME"
adduser "$USERNAME" sudo

# Update and upgrade the system
apt update && apt upgrade -y

# Install necessary packages
echo "Installing basic Packages..."
apt install -y ca-certificates curl gnupg lsb-release git htop zip unzip apt-transport-https net-tools ncdu apache2-utils
echo

# Configure SSH
echo "Configuring SSH..."
sed -i "s/#Port 22/Port $SSH_PORT/" /etc/ssh/sshd_config
systemctl restart sshd
echo

# Configure system parameters
echo "Configuring system parameters..."
echo "vm.swappiness=10" >> /etc/sysctl.conf
echo "vm.vfs_cache_pressure=50" >> /etc/sysctl.conf
echo "fs.inotify.max_user_watches=262144" >> /etc/sysctl.conf
sysctl -p

# Configure UFW (Uncomplicated Firewall)
echo "Configuring UFW..."
ufw default deny incoming
ufw default allow outgoing
ufw allow from 192.168.100.0/24
ufw enable
ufw status

echo "OS preparation completed successfully."