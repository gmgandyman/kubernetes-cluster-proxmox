FROM debian:trixie-slim

# No prompts, thank you
ENV DEBIAN_FRONTEND=noninteractive

# bash + pipefail so a failed curl in a pipe (e.g. curl | gpg) actually fails
# the build, instead of the downstream command masking it with a confusing error
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Ansible requires python3
# ca-certificates, curl, gnupg, and lsb-release are so we can get HashiCorp's apt repo for Packer
# openssh-client because we're going to be doing a lot of SSH work
# shellcheck because we're going to write a lot of shell scripts, and linting is nice to have
# python3-pip because python package manager, and we want ruff for linting our python files
# ansible.posix because linux operations
# community.general for the modprobe/misc modules used by the k8s-prereqs playbook
# gnupg, apt-transport-https because open tofu
# qemu-system-x86, qemu-utils for Packer's qemu builder - it shells out to qemu-system-x86_64
# and qemu-img directly, no container engine/daemon involved. This is what bakes
# qemu-guest-agent into the template image itself (see packer/debian.base.pkr.hcl) -
# without it, agent.enabled on the Proxmox VM resources has nothing to talk to on
# first boot and OpenTofu hangs waiting on it.
# xorriso lets Packer build the cloud-init NoCloud seed ISO (cd_content) it feeds the VM
RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
        apt-transport-https \
        ansible-core \
        ca-certificates \
        curl \
        gnupg \
        lsb-release \
        openssh-client \
        python3 \
        python3-pip \
        qemu-system-x86 \
        qemu-utils \
        shellcheck \
        xorriso \
    && ansible-galaxy collection install -p /usr/share/ansible/collections \
        ansible.posix \
        community.general \
    && rm -rf /var/lib/apt/lists/*

# Oh HashiCorp..., this is for packer
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg \
      | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" \
      | tee /etc/apt/sources.list.d/hashicorp.list && \
    apt-get update && \
    apt-get install --yes --no-install-recommends packer=1.16.0-* && \
    rm -rf /var/lib/apt/lists/*

# linting python scripts
RUN pip install --break-system-packages ruff

# Open Tofu
# Download the installer script:
RUN curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh \

# Give it execution permissions:
    && chmod +x install-opentofu.sh \

# Run the installer:
    && ./install-opentofu.sh --install-method deb \

# Remove the installer:
    && rm -f install-opentofu.sh

# Boot to a terminal if no command is given
CMD ["bash"]
