# Kubernetes Cluster on Proxmox
This project uses packer, open tofu, and Ansible in order to provision 3 VMs on a Proxmox
hypervisor, and install a Kubernetes cluster across all 3. This is not a k3s, it is a full
k8s installation, though it is only 1 Control Plane + 2 Worker nodes

## Requirements
- Working Proxmox hypervisor with 4 cores and 100gb free drive space
- Docker desktop/podman
- Proxmox installed on a private network with static 3 open IP address available

## Provisioning the VMs
1. ```cp toolbox/.env.example toolbox/.env```
2. Fill out the variables, ignore TF_VAR_ssh_public_keys for now
3. ```source load-bash-functions.sh``` then ```start-toolbox```
4. ```cd toolbox/scripts```
5. ```bash generate-keys.sh```
6. Fill out the TF_VAR_ssh_public_keys in .env now
7. ```bash build-images.sh```
8. ```bash flatten-images.sh```
9. ```cd /work/infra/proxmox```
10. ```tofu init```
11. ```tofu apply```

## Kubernetes install
Node prerequisites (swap, sysctl, containerd, kubeadm/kubelet/kubectl) are already baked into
the image with packer. That leaves configuration that occurs at boot/runtime on the
vm
1. ```eval "$(ssh-agent -s)"```
2. ```ssh-add /work/keys/admin/admin-ed25519```
3. ```cd /work/ansible```
4. ```ansible-playbook playbooks/k8s-init/main.yml```
6. ```kubectl get nodes -o wide``` should show your control-plane and 2 worker nodes

## Kubernetes Configuration
- CRI: containerd
- CNI: flannel

## Build stack
- Packer
- Open Tofu
- Ansible

### Why Packer?
Debian does not include qemu-guest-agent in their cloud-init images. This means that the
Proxmox hypervisor will have no idea when a server is up and running, nor can it shut it down
gracefully. Worse, Open Tofu will run for a full 15 minutes after provisioning the VM before
it times out, because it cannot detect the VM booted successfully.

Packer lets us build our own image based on the Debian cloud-init images, with qemu-guest-agent
installed, along with some convenience packages like SSHD and a passwordless sudo capable deploy
user

### Why Open Tofu
Because HashiCorp got weird about Terraform source code and licensing, and Open Tofu will 
still provision our VMs just as well.

### Why Ansible
Kubernetes requires a relatively heavy set of configuration steps directly after open tofu
provisions the cluster nodes (VMs). Initialing kubeadm on the control plane, setting up
the flannel (CNI) manifest, generating the control plane token, and joining the worker nodes
to the control plane are typically done AFTER provisioning. 

Cluster API can handle this for you, but for a simple 3 node k8s cluster, it's overkill. 

Two bash scripts, one that gets called on the control plane, and another that
gets called on each worker node, are another option. This is not as easy as it seems though.
You would have ot ensure the tofu provisioning of the control plane finishes before each worker
node, stores the join token, and then proceeds to provision each worker node, and hands off the token
to node as it completes. Tofu was not designed to do this type of work easily.

Ansible can, so this project uses it. A playbook runs once right after all three nodes are provisioned.
It generates the configuration files, stores the token, copies the token to each worker node as a
variable, and then pulls down the config file to power the user's kubectl calls from the toolbox. 