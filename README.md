# Genealogy

This is a hobby project used to deploy the webtrees

## Provisioning

- Purchase a cx21 VM from Hetzner, running Ubuntu

```bash
apt-get update && apt-get install -yq fish git snapd
chsh -s `which fish`
```

### Install a kubernetes instance

We will use microk8s to run our single-node kubernetes cluster

```bash
# Install microk8s
sudo snap install microk8s --classic
# Allow us to use microk8s commands without sudo
# Obviously unnecessary if we are root...
# sudo usermod -a -G microk8s $USER
# sudo chown -f -R $USER ~/.kube
# Alias the kubectl command
alias mkctl="microk8s kubectl"
# Prepare some microk8s plugins
microk8s status --wait-ready
microk8s enable ingress dns storage dashboard helm3 metallb
# Provide the IP range as: <IP-of-VM>-<IP-of-VM>
```

Note: we need metallb to allow us to use the LoadBalancer service type.
The LoadBalancer service type allows us to expose our services externally.

### Install services

#### CertManager

LetsEncrypt TLS certificate are provisioned and renewed by certbot.
To do this simply, install the jetstack cert-manager helm chart.

```bash
# Prepare Helm
microk8s helm3 repo add jetstack https://charts.jetstack.io
microk8s helm3 repo update
# Install cert manager
microk8s kubectl create namespace cert-manager
microk8s helm3 install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --version v1.4.0 \
  --set installCRDs=true
```

### Install the services

```bash
# Clone the repo
git clone https://github.com/briggySmalls/hobby-k8s.git
cd hobby-k8s/
# Install all of our services
mkctl apply -k .
# Check that they are now running
mkctl get svc
# Create the ingress and letsencrypt certificates
mkctl apply -f ingress.yaml letsencrypt.yaml
```
