# Kubernetes cluster on proxmox

## VM Install
1. ```cp .env.lcoal .env```
2. Fill out the variables, ignore TF_VAR_ssh_public_keys for now
3. ```(docker|podman) compose run --build toolbox bash ```
4. ```cd toolbox/scripts```
5. ```bash build-images.sh```
6. ```bash flatten-images.sh```
7. ```cd /work/infra/proxmox```
8. ```tofu init```
9. ```tofu apply```

## Kubernetes install
1. Install container runtime
2. kubeadm
3. init master