#!/usr/bin/bash
set -eu

# KEY_DIR comes from toolbox/.env
ssh-keygen -t ed25519 -f "$KEY_DIR/admin-ed25519" -N "" -C admin-key
