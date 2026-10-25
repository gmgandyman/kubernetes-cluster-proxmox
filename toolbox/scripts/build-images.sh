#!/usr/bin/bash
set -eu

cd /work

packer init packer/

echo "Building debian image..."
packer build -force -only='debian-custom.qemu.debian_bookworm' packer/

echo "Done."
