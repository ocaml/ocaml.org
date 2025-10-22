---
id: "unikernel-target"
short_title: "Compilation Targets: Unikernels"
title: "Compilation Targets: Unikernels"
description: "Compile OCaml to specialized unikernel targets using MirageOS. Create minimal, fast-booting applications for hvt, virtio, Xen, and more with reduced attack surfaces."
category: "Compilation Targets"
---

OCaml can compile to specialized unikernel targets through [MirageOS](https://mirage.io), a library operating system that creates secure, high-performance single-purpose applications.

## What are Unikernels?

Unikernels are specialized, single-purpose virtual machine images that bundle your application with only the minimal OS functionality it needs. Unlike traditional applications that run on general-purpose operating systems, unikernels:

- Include only the necessary OS components, resulting in tiny footprints (often just a few megabytes)
- Boot in milliseconds
- Have reduced attack surfaces due to minimal code
- Run directly on hypervisors or specialized monitor layers

MirageOS lets you write OCaml applications once and deploy them as unikernels to different virtualization platforms.

## Available Targets

MirageOS supports compilation to several unikernel backends:

### Solo5 Targets

[Solo5](https://github.com/Solo5/solo5) is a sandboxed execution environment that provides multiple deployment options:

- **hvt** (Hardware Virtualized Tender) - Runs on KVM/Linux and bhyve/FreeBSD with minimal overhead
- **spt** (Sandboxed Process Tender) - Runs as a regular Unix process with seccomp sandboxing on Linux
- **virtio** - Runs on standard virtio-based hypervisors including QEMU/KVM, Google Compute Engine, and OpenStack
- **muen** - Runs on the Muen Separation Kernel
- **genode** - Runs on the Genode OS framework

### Xen

- **xen** - Runs on the Xen hypervisor as a paravirtualized guest (PVHv2 mode)

### Unix

- **unix** - Runs as a standard Unix process (useful for development and testing)

## Choosing a Target

**Use Unix** when you're developing and testing your unikernel locally.

**Use hvt** when you want lightweight virtualization on Linux or FreeBSD with KVM or bhyve.

**Use virtio** when deploying to cloud providers like Google Compute Engine, or standard KVM/QEMU setups.

**Use spt** when you want process-level isolation on Linux without full virtualization.

**Use Xen** when deploying to Xen-based infrastructure or cloud providers that support Xen.

## Getting Started

To start building unikernels with OCaml, visit the [MirageOS Getting Started Guide](https://mirage.io/docs/). The guide walks you through:

- Installing the MirageOS tooling
- Creating your first unikernel application
- Configuring and building for different targets
- Deploying your unikernel

## Learn More

- [MirageOS Documentation](https://mirage.io/docs/) - Comprehensive guides and tutorials
- [MirageOS Blog](https://mirage.io/blog/) - Updates and advanced topics
- [Solo5 Documentation](https://github.com/Solo5/solo5) - Details on Solo5 targets and deployment
- [MirageOS Examples](https://github.com/mirage/mirage-skeleton) - Sample unikernel applications to explore

## Community

- [Discuss OCaml Forums](https://discuss.ocaml.org/) - Ask questions in the Ecosystem category
- [MirageOS Mailing List](https://lists.xenproject.org/cgi-bin/mailman/listinfo/mirageos-devel) - Development discussions
- IRC: `#mirage` on Libera.Chat