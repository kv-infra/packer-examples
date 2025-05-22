# Packer KubeVirt (QEMU-based Virtualization)

Packer is a tool to create KubeVirt VM images from a single source template.

## Introduction

Packer VM template is the HCL configuration that defines how to build an image,
and VM image is the actual machine image produced from that template.

## Prerequisites

- Packer
- Kubernetes (If you use KubeVirt plugin)
- QEMU (If you use QEMU plugin)

## Installation

Packer is supported on Windows, Linux, macOS and other operating systems.
Follow the official instructions [here](https://developer.hashicorp.com/packer/install)
to install Packer.

## Features

Advantages of using Packer over plain QEMU:

- HCL templating for Infrastructure-as-Code (IaC)
- Automated ISO downloading
- Built-in HTTP server for file serving (e.g., Kickstart configs)
- Boot command automation (e.g., via VNC)
- Integrated SSH or WinRM for provisioning and customization
- Support for multi-platform builds (e.g., AWS, GCP, Azure)

## Usage

Navigate to one of the available plugins:

- [packer-plugin-qemu](./packer-plugin-qemu)
- [packer-plugin-kubevirt](./packer-plugin-kubevirt)

Each plugin describes how to create VM images and use it in KubeVirt cluster.

## References

- [Packer KVM](https://github.com/goffinet/packer-kvm)
- [Packer Windows](https://github.com/proactivelabs/packer-windows)
