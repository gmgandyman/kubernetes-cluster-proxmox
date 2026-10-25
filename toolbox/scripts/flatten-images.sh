#!/usr/bin/bash
set -eu

# Packer's qemu builder uses a backing file (use_backing_file=true) for fast local builds -
# the resulting qcow2 only holds the diff against a cache file in /root/.cache/packer, so it
# needs flattening into a standalone qcow2 before infra/proxmox's proxmox_virtual_environment_file
# resource can upload it (see vm-template.tf).

echo "Flattening image..."
qemu-img convert -O qcow2 /work/packer/output/debian/packer-debian_bookworm /work/packer/output/debian/debian_bookworm.qcow2
echo "Done."
