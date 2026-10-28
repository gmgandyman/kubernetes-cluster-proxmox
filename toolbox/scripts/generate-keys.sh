#!/usr/bin/bash
set -eu

# KEY_DIR comes from toolbox/.env
ssh-keygen -t ed25519 -f "$KEY_DIR/admin/admin-ed25519" -N "" -C admin-key
ssh-keygen -t ed25519 -f "$KEY_DIR/kubeadmin/kubeadmin-ed25519" -N "" -C kubeadmin-key
