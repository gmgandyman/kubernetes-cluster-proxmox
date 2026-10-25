#cloud-config
# Lets Packer SSH straight in as root to run the provisioning scripts. This key is only
# used during the image build - the real cluster VMs get their own user/keys from
# infra/proxmox's cloud-init (var.vm_default_username / var.ssh_public_keys) at clone time.
disable_root: false
ssh_pwauth: false
users:
  - name: root
    # Without this, cloud-init locks the account (! in /etc/shadow), and PAM's account
    # check rejects even pubkey SSH logins for a locked account - not just password auth
    lock_passwd: false
    ssh_authorized_keys:
      - ${ssh_public_key}
