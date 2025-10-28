---
title: "OCaml Infrastructure: How the opam-repository Works"
tags: [infrastructure]
---

The [opam repository](https://github.com/ocaml/opam-repository) serves as the central package registry for the OCaml ecosystem, hosting over 4,500 packages and processing nearly 200 new packages and releases each month. Understanding how this critical infrastructure works is essential for any OCaml developer looking to contribute packages or understand the ecosystem's inner workings.

## Architecture and Infrastructure

The opam repository operates as a curated Git repository containing package metadata rather than the packages themselves. Each package is described by an `.opam` file that specifies dependencies, build instructions, and other metadata. The package also includes a URL pointing to the source of the actual package. The actual source code remains in the original repositories maintained by package authors.

For example, the [yojson.3.0.0 package](https://github.com/ocaml/opam-repository/blob/master/packages/yojson/yojson.3.0.0/opam) provides a simple illustration of the package format. For more details, see the [opam package format documentation](https://opam.ocaml.org/doc/Packaging.html).

### The CI Pipeline

At the heart of the repository's reliability is an extensive continuous integration (CI) system built around [OCurrent](https://ocurrent.org), which powers the [opam-repo-ci service](https://opam.ci.ocaml.org). When you submit a pull request to add or update a package, this system:

- **Validates package metadata** using [an extensive set of linting rules](https://github.com/ocurrent/opam-repo-ci/blob/babb8b03e5eabf8e5ecc12384587a8303004a22b/opam-ci-check/lint/lint_error.ml#L13-L37)
- **Tests compilation** across multiple OCaml compiler versions (currently supporting back to OCaml 4.08)
- **Verifies installation** on various platforms including Linux distributions, macOS, FreeBSD, Windows, and multiple CPU architectures (x86_64, ARM64, ARM32, PowerPC, s390x, RISC-V)
- **Runs package tests** to ensure functionality
- **Checks reverse dependencies** to ensure your changes don't break existing packages that depend on your package

This comprehensive testing matrix helps maintain the repository's high quality standards. Windows support was added in 2024, marking a significant expansion of the platform coverage.

### Supporting Infrastructure

The opam repository integrates with several other OCaml infrastructure services:

- **Docker Base Images**: The [docker-base-images service](https://images.ci.ocaml.org) provides consistent testing environments, building official images for various Linux distributions, OCaml versions, and architectures
- **Documentation CI**: Automatically builds and publishes package documentation to the [OCaml.org website's package area](https://ocaml.org/packages)
- **Health Check Services**: Multiple services continuously monitor package installability across different platforms and compiler versions:
  - [check.ci.ocaml.org](https://check.ci.ocaml.org): Tests all packages regularly
  - [dune.check.ci.dev](https://dune.check.ci.dev): Tests with the Dune build system
  - [windows.check.ci.dev](https://windows.check.ci.dev): Windows-specific testing
  - [freebsd.check.ci.dev](https://freebsd.check.ci.dev): FreeBSD compatibility
  - [oxcaml.check.ci.dev](https://oxcaml.check.ci.dev): Tests with OxCaml compiler variant

## Governance and Curation Policies

The opam package repository is a [commons](https://en.wikipedia.org/wiki/Commons) rather than a publishing platform: it is manually curated, so not all packages submitted for publication are accepted; it is maintained communally, so anyone can suggest changes to any package.

### Core Principles

The repository maintains quality through several key policies, documented in the [repository policies](https://github.com/ocaml/opam-repository/tree/master/governance/policies). The policies are derived from some core principles, including:

**Package Utility**: Packages must provide substantial utility to the OCaml community. Single-function modules or packages with minimal functionality are generally rejected to preserve namespace and repository efficiency.

**Naming and Security**: Package names are reviewed to prevent confusion with existing packages and potential security risks. Name squatting and packages with deceptively similar names to established libraries are not permitted.

**Dependency Constraints**: The repository discourages overly strict version constraints (using `=` or `<=`) as they make package combination difficult and worsen the user experience. Instead, packages should use reasonable upper bounds and allow opam's solver to find compatible combinations.

**Maintenance Requirements**: Packages must be actively maintained for modern OCaml versions. There is a [compiler cutoff threshold](https://github.com/ocaml/opam-repository/blob/master/governance/policies/archiving.md#compiler-cutoff-threshold), which will be increased as newer releases become available. Packages that don't support recent compiler versions may be archived.

### The Archiving Process

To manage repository growth and maintain quality, the opam repository has implemented a systematic archiving process for unmaintained packages. Packages that no longer meet the compiler cutoff threshold or are explicitly marked as unmaintained get moved to the [opam-repository-archive](https://github.com/ocaml/opam-repository-archive).

The process works through maintenance intent declarations using the `x-maintenance-intent` field in package metadata. When maintainers stop supporting older versions, the community is notified, and if no new maintainer steps forward, packages are archived rather than removed entirely.

## The Human Element

### Review Process

Every package submission undergoes human review in addition to automated testing. Maintainers check for compliance with repository policies, verify licensing information, assess package utility, and ensure proper dependency declarations. This human oversight is crucial for maintaining the repository's curation standards.

### Current Maintainer Team

The repository is maintained by a dedicated team of volunteers who review every package submission. Kate Deplaix (kit-ty-kate) was the primary opam-repository maintainer from 2017 to 2024. Her contribution was instrumental in maintaining the repository's quality and establishing many of the current processes and documentation. She is now contributing to the opam tool itself.

The current active maintainers are listed in the [governance documentation](https://github.com/ocaml/opam-repository/tree/master/governance).

### Community Involvement

The maintainer team actively seeks new volunteers to help manage the growing submission volume. The role offers excellent opportunities to:

- Connect with and support contributors from across the OCaml ecosystem
- Learn advanced packaging techniques and build system intricacies  
- Contribute to ecosystem sustainability and health
- Gain experience with large-scale open source project management

For information about the onboarding process, see the [Onboarding documentation](https://github.com/ocaml/opam-repository/wiki/Onboarding-documentation). If you're interested in contributing to this essential piece of OCaml infrastructure, check out the [call for volunteers](https://github.com/ocaml/opam-repository/issues/27740) or reach out to the current maintainer team.

## Publishing Workflow

For package authors, the typical publishing workflow involves:

1. **Creating a package source archive** (commonly done by pushing a git tag to your online forge of choice: GitHub, GitLab, Codeberg, or other)
2. **Opening a pull request** to opam-repository (often automated with tools like `dune-release` or `opam-publish`)
3. **Monitoring CI results** and addressing any build failures or policy violations
4. **Responding to maintainer feedback** during the review process
5. **Package acceptance** and automatic propagation to opam users worldwide

The process is streamlined by extensive documentation including the [CONTRIBUTING.md guide](https://github.com/ocaml/opam-repository/blob/master/CONTRIBUTING.md) and the comprehensive [wiki](https://github.com/ocaml/opam-repository/wiki) that covers everything from basic submission guidelines to detailed policy explanations.

## Looking Forward

The opam repository continues to evolve as the OCaml ecosystem grows. Recent initiatives include the introduction of an archiving policy, improving maintainer documentation, and scaling the review process to handle increasing submission volumes.

For developers interested in contributing to this critical infrastructure, whether as package authors or potential maintainers, the repository represents one of the most impactful ways to support the broader OCaml community. The combination of technical infrastructure, human oversight, and community governance makes the opam repository a model for how modern package ecosystems can balance growth with quality.
