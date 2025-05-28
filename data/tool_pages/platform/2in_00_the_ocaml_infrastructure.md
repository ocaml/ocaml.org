---
id: "ocaml-infrastructure"
short_title: "The OCaml Infrastructure"
title: "The OCaml Infrastructure: Tools and Services for the OCaml Ecosystem"
description: "An overview of the services that belong to the OCaml Infrastructure."
category: "OCaml Infrastructure"
---

The OCaml ecosystem is supported by a [robust infrastructure built around OCurrent](https://github.com/ocurrent/overview). The OCaml Infrastructure powers many essential services that OCaml developers rely on daily.

## What is OCurrent?

[OCurrent](https://ocurrent.org) is an OCaml eDSL for creating processing pipelines that automatically adjust when their inputs change. For example, when a Git repository is updated, OCurrent pipelines can automatically rebuild, test, and deploy the changes without manual intervention.

## OCaml Infrastructure Services

The OCaml infrastructure services can be grouped into three main categories: Community infrastructure services, services for individual projects, and infrastructure operation services. Here we present a brief overview of the major services from the first two categories.

### Docker Base Images

**Source Code:** [docker-base-images](https://github.com/ocurrent/docker-base-images)

**Website:** [images.ci.ocaml.org](https://images.ci.ocaml.org)

This service builds the official [`ocaml/opam`](https://hub.docker.com/r/ocaml/opam) Docker images for various Linux distributions, OCaml versions, compiler flags, and architectures (including x86, ARM, PowerPC, s390x, and RISC-V). These images provide a consistent environment for development and testing and are used by many other CI services.

**Using the pre-built OCaml Docker images:** You can view the available [pre-built Docker images for various OCaml configurations at DockerHub](https://hub.docker.com/r/ocaml/opam/tags), and use them in your own deployments.

### Package Submission CI (opam-repo-ci)

**Source Code:** [opam-repo-ci](https://github.com/ocurrent/opam-repo-ci)

**Website:** [opam.ci.ocaml.org](https://opam.ci.ocaml.org)

Tests package submissions to the opam repository. When you submit a pull request to opam-repository, this service verifies that your package builds correctly and also tests all dependent packages to ensure compatibility.

**Maintaining compatibility for packages in the opam-repository:** After publishing a package by creating a GitHub release and opening an opam-repository PR (e.g. by [using `dune-release`](/publishing-packages-w-dune)), monitor your opam-repository PR to ensure all tests pass.

### Documentation CI

**Source Code:** [ocaml-docs-ci](https://github.com/ocurrent/ocaml-docs-ci)

**Website:** [docs.ci.ocaml.org](https://docs.ci.ocaml.org)

Builds **documentation for all packages in the opam repository**, with correct cross-package linking. After publishing your package to opam-repository, the documentation will automatically be built and published to the [OCaml.org website's package area](https://ocaml.org/packages).

### Health Check Services

* [check.ci.ocaml.org](https://check.ci.ocaml.org): Regularly tests that all packages in the opam repository still build correctly. This service is used by OCaml compiler developers when preparing major changes like new OCaml compiler releases. **GitHub**: [opam-health-check](https://github.com/ocurrent/opam-health-check)
* [dune.check.ci.dev](https://dune.check.ci.dev): Regularly tests OCaml packages with the Dune build system to ensure compatibility and correctness.
* [windows.check.ci.dev](https://windows.check.ci.dev): Tests OCaml packages on Windows platforms to identify Windows-specific issues in the OCaml ecosystem and to assist package maintainers in supporting Windows environments.
* [freebsd.check.ci.dev](https://freebsd.check.ci.dev): This service helps package maintainers identify and fix FreeBSD-specific issues in their packages, by testing OCaml packages on FreeBSD to ensure compatibility.
* [oxcaml.check.ci.dev](https://oxcaml.check.ci.dev): Tests OCaml packages with OxCaml, an alternative OCaml compiler implementation. This service helps identify compatibility issues between packages and the OxCaml compiler variant.

## Platform Support

The OCaml infrastructure supports building and testing on multiple platforms:

* Linux: Various distributions (Debian, Ubuntu, Alpine, etc.)
* Architecture diversity: x86_64, ARM64, ARM32, PowerPC, s390x, RISC-V
* macOS: Through [macos-infra](https://github.com/ocurrent/macos-infra)
* FreeBSD: Through [freebsd-infra](https://github.com/ocurrent/freebsd-infra)

## Getting Involved

The OCaml infrastructure is open source and welcomes contributions. You can:

* [Contribute to the various codebases on GitHub](https://github.com/ocurrent/overview)
* Report issues or suggest improvements on [discuss.ocaml.org](https://discuss.ocaml.org)
* Deploy the tools locally to test your projects (see the individual documentation of the service you want to run)

For more information on OCurrent and these services, visit [ocurrent.org](https://ocurrent.org) or explore the [OCurrent GitHub organization](https://github.com/ocurrent).
