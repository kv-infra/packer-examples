# Packer KubeVirt Templates

This is a plugin to create VM images using KubeVirt and Kubernetes.

## Prerequisites

- Packer
- Kubernetes with KubeVirt installed

## VM Images

Create a new VM image using a Packer template:

```bash
# Path to your Packer template
export TEMPLATE="./<TEMPLATE_NAME>.pkr.hcl"

# Downloads required plugins
packer init ${TEMPLATE}

# Checks for syntax errors
packer validate ${TEMPLATE}

# Run the steps defined in the template
packer build ${TEMPLATE}
```

The new VM image will be available in the KubeVirt cluster.
