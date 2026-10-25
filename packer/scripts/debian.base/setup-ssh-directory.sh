#!/usr/bin/bash

# Notice we need /home/deploy user already added for this file

# useradd won't make this yet
mkdir -p /home/deploy/.ssh

# Create an authorized_keys file with only our master key inside
# See debian.base.pkr.hcl for how this tmp key file is setup
mv /tmp/master_key.pub /home/deploy/.ssh/authorized_keys

# make sure the .ssh directory has the correct permissions, because SSH is very pedantic
chown -R deploy:deploy /home/deploy/.ssh
chmod 700 /home/deploy/.ssh
chmod 600 /home/deploy/.ssh/authorized_keys
