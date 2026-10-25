#!/usr/bin/bash
set -eu

# curl, ca-certificates for web traffic
# python3 for Ansible
# qemu-guest-agent so Proxmox/OpenTofu can tell when the VM is actually up (see
# infra/proxmox's agent.enabled) - Debian's systemd preset enables it on install,
# so it's already running by the time the real cloned VM boots for the first time.
apt-get install -y --no-install-recommends curl ca-certificates python3 qemu-guest-agent
