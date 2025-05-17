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

### Community Infrastructure Services

These services power the broader OCaml ecosystem, supporting package repositories, documentation, and other essential community resources:

#### Docker Base Images
**Service:** [docker-base-images](https://github.com/ocurrent/docker-base-images)  
**Website:** [images.ci.ocaml.org](https://images.ci.ocaml.org)

This service builds the official `ocaml/opam` Docker images for various Linux distributions, OCaml versions, compiler flags, and architectures (including x86, ARM, PowerPC, s390x, and RISC-V). These images provide a consistent environment for development and testing and are used by many other CI services.

**Developer Usage:** You can view the available [pre-built Docker images for various OCaml configurations at DockerHub](https://hub.docker.com/r/ocaml/opam).

#### Package Submission CI (opam-repo-ci)
**Service:** [opam-repo-ci](https://github.com/ocurrent/opam-repo-ci)  
**Website:** [opam.ci.ocaml.org](https://opam.ci.ocaml.org)

Tests package submissions to the opam repository. When you submit a pull request to opam-repository, this service verifies that your package builds correctly and also tests all dependent packages to ensure compatibility.

**Developer Usage:** After creating a GitHub release with `dune-release`, monitor your opam-repository PR to ensure all tests pass.

#### Documentation CI
**Service:** [ocaml-docs-ci](https://github.com/ocurrent/ocaml-docs-ci)  
**Website:** [docs.ci.ocaml.org](https://docs.ci.ocaml.org)

Builds documentation for all packages in the opam repository, with correct cross-package linking. Generated documentation is published to the OCaml.org website.

**Developer Usage:** After publishing your package to opam-repository, your documentation will automatically be built and integrated with the OCaml.org website's package documentation.

#### Package Health Check
**Service:** [opam-health-check](https://github.com/ocurrent/opam-health-check)  
**Website:** [check.ci.ocaml.org](https://check.ci.ocaml.org)

Regularly tests that all packages in the opam repository still build correctly. This service is used by OCaml compiler developers when preparing major changes like new OCaml compiler releases.

### Services for Individual Projects

These services can be enabled for your own GitHub repositories to help with testing, benchmarking, and continuous integration:

#### OCaml CI
**Service:** [ocaml-ci](https://github.com/ocurrent/ocaml-ci)  
**Website:** [ocaml.ci.dev](https://ocaml.ci.dev)

A CI service for OCaml projects hosted on GitHub. It automatically tests projects against multiple OCaml versions and OS platforms by examining your opam files to determine build requirements.

**Developer Usage:** Check out the ["Getting Started" guide on the OCaml CI website](https://ocaml.ci.dev/getting-started) to learn how to enable OCaml CI on your GitHub repository.

#### Continuous Benchmarking
**Service:** [current-bench](https://github.com/ocurrent/current-bench)  
**Website:** [bench.ci.dev](https://bench.ci.dev)

Provides continuous benchmarking for OCaml projects to track performance across different commits and branches.

FIXME: link to docs

**Developer Usage:** 
- Enable the GitHub app on your repository
- Add a `bench` target to your Makefile
- Emit benchmark results in JSON format
- Monitor performance of your code over time

#### Multicore OCaml CI
**Service:** [ocaml-multicore-ci](https://github.com/ocurrent/ocaml-multicore-ci)  
**Website:** [ocaml-multicore.ci.dev](https://ocaml-multicore.ci.dev)

Tests OCaml projects against multicore OCaml versions - particularly useful if you want to ensure your code is compatible with OCaml 5.x.

FIXME: link to docs

#### MirageOS CI
**Service:** [mirage-ci](https://github.com/ocurrent/mirage-ci)  
**Website:** [ci.mirage.io](https://ci.mirage.io)

CI service specifically for MirageOS projects, helping to test unikernels across different configurations.

FIXME: link to docs

## Platform Support

The OCaml infrastructure supports building and testing on multiple platforms:
- Linux: Various distributions (Debian, Ubuntu, Alpine, etc.)
- Architecture diversity: x86_64, ARM64, ARM32, PowerPC, s390x, RISC-V
- macOS: Through [macos-infra](https://github.com/ocurrent/macos-infra)
- FreeBSD: Through [freebsd-infra](https://github.com/ocurrent/freebsd-infra)

## Getting Involved

The OCaml infrastructure is open source and welcomes contributions. You can:
- Contribute to the codebase on GitHub
- Report issues or suggest improvements
- Deploy the tools locally to test your projects

For more information on OCurrent and these services, visit [ocurrent.org](https://ocurrent.org) or explore the [OCurrent GitHub organization](https://github.com/ocurrent).