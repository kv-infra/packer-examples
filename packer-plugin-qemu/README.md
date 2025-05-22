# Packer QEMU Templates

This is a plugin to create VM images using QEMU locally.

## Prerequisites

- Packer
- QEMU

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

After the build completes, a new `./output-*` directory will be created
containing the generated `*.qcow2` disk image.

## KubeVirt Images

To use a `*.qcow2` disk image with KubeVirt, you need to package it as a
`containerDisk` image and push it to your container registry.

Here is an example workflow:

```bash
# Set environment variables
export DISK_IMAGE_PATH="./<DISK_IMAGE_NAME>.qcow2"
export REGISTRY_URL="<HOST_NAME>"
export REGISTRY_USERNAME="<USER_NAME>"
export REGISTRY_PASSWORD="<USER_PASSWORD>"
export IMAGE_NAME="<NAME>"
export IMAGE_TAG="<TAG>"
export IMAGE_URL=${REGISTRY_URL}/${REGISTRY_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}

# Build the container image with the qcow2 disk
podman build --build-arg DISK_IMAGE=${DISK_IMAGE_PATH} -t ${IMAGE_NAME}:${IMAGE_TAG} .

# Tag the image with the full registry URL
podman tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_URL}

# Log in to the container registry
podman login -u ${REGISTRY_USERNAME} -p ${REGISTRY_PASSWORD} ${REGISTRY_URL}

# Push the image to the registry
podman push ${IMAGE_URL}
```

## Example Usage

Deploy a new VM with the VM image from the container registry:

```YAML
apiVersion: kubevirt.io/v1
kind: VirtualMachine
metadata:
  labels:
    kubevirt.io/vm: vm-example-datavolume
  name: example-vm
spec:
  dataVolumeTemplates:
  - metadata:
      creationTimestamp: null
      name: example-dv
    spec:
      storage:
        accessModes:
        - ReadWriteOnce
        resources:
          requests:
            storage: 5Gi
      source:
        registry:
          url: docker://quay.io/containerdisks/fedora:40 # Replace with your own Image URL
  template:
    metadata:
      labels:
        kubevirt.io/vm: vm-example-datavolume
    spec:
      domain:
        devices:
          disks:
          - disk:
              bus: virtio
            name: datavolumedisk
        resources:
          requests:
            memory: 2Gi
      terminationGracePeriodSeconds: 0
      volumes:
      - dataVolume:
          name: example-dv
        name: datavolumedisk
```

VM image will be imported before starting the VM. Ensure that the image
repository is publicly available.
