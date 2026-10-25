#!/usr/bin/bash

# create if not exists
echo "deploy ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/deploy
chmod 0440 /etc/sudoers.d/deploy
chown root:root /etc/sudoers.d/deploy
