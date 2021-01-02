# Genealogy

This is a hobby project used to deploy the webtrees

## Provisioning

- Purchase a cx21 VM from Hetzner, running Ubuntu

### Install a kubernetes instance

We will use microk8s to run our single-node kubernetes cluster

```bash
# Install snap for microk8s
sudo apt install snapd
# Install microk8s
sudo snap install microk8s --classic --channel=1.19
sudo usermod -a -G microk8s $USER
sudo chown -f -R $USER ~/.kube
microk8s status --wait-ready
# Prepare some microk8s plugins
microk8s enable dns storage dashboard metallb helm3
```

Note: metallb makes a LoadBalancer implementation available on bare-metal VMs.
Hetzner actually provider a LoadBalancer now but you need to pay for it, and I
imagine a single-node cluster doesn't

### Install Helm

```bash
# Install helm
snap install helm --classic
# Add chart repository
helm repo add stable https://charts.helm.sh/stable
```

### Install services

#### Ingress

Install the ingress controller using Helm

```bash
microk8s helm3 install my-release haproxytech/kubernetes-ingress
```

Most of the services are manually defined in this repo in manifests.

The HAProxy service was installed u
