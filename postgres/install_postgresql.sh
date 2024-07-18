#!/bin/bash

# Update the package list and upgrade installed packages
sudo apt update
sudo apt upgrade -y

# Install PostgreSQL repository key
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# Add PostgreSQL repository
RELEASE=$(lsb_release -cs)
echo "deb http://apt.postgresql.org/pub/repos/apt/ $RELEASE-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list

# Update the package list again
sudo apt update

# Install PostgreSQL 14
sudo apt install -y postgresql-14

# Optional: Install additional PostgreSQL contrib packages
sudo apt install -y postgresql-contrib-14

# Start and enable PostgreSQL service
sudo systemctl start postgresql
sudo systemctl enable postgresql

echo "PostgreSQL 14 has been installed successfully."
