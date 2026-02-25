---
id: "opam-repository"
short_title: "The Opam Repository"
title: "The Opam Repository: The Central Package Registry for OCaml"
description: "Breakdown of How the Opam Respository Works"
category: "OCaml Infrastructure"
---

The [opam repository](https://github.com/ocaml/opam-repository) is the central package registry for the OCaml ecosystem, hosting over 4,500 packages and processing nearly 200 new packages and releases each month. It operates as a curated Git repository containing package metadata rather than the packages themselves.

Source Code: [opam-repository](https://github.com/ocaml/opam-repository)

Wiki: [opam-repository wiki](https://github.com/ocaml/opam-repository/wiki)

## How It Works

Each package is described by an `opam` file specifying dependencies, build instructions, and a URL pointing to the source code. The actual source code remains in the original repositories maintained by package authors. See the [opam package format documentation](https://opam.ocaml.org/doc/Packaging.html) for details.

When you submit a pull request, the [opam-repo-ci](https://opam.ci.ocaml.org) service validates your package metadata, tests compilation across multiple OCaml versions (back to 4.08), verifies installation on various platforms (Linux, macOS, FreeBSD, Windows) and architectures, runs tests, and checks reverse dependencies to ensure your changes don't break existing packages.

## Governance and Curation

The opam repository is a curated commons, not a publishing platform. Every submission undergoes both automated testing and human review by a dedicated team of volunteer maintainers. The [repository policies](https://github.com/ocaml/opam-repository/tree/master/governance/policies) document the key principles:

- **Package utility**: Packages must provide substantial value to the community
- **Naming and security**: Names are reviewed to prevent confusion and security risks
- **Dependency constraints**: Overly strict version constraints are discouraged
- **Maintenance requirements**: Packages must support recent OCaml versions or may be archived

A distinctive feature is the `x-maintenance-intent` field, which lets maintainers explicitly declare their commitment level. Unmaintained packages are moved to the [opam-repository-archive](https://github.com/ocaml/opam-repository-archive) rather than deleted.

## Publishing Packages

The typical workflow involves creating a source archive (usually by pushing a git tag), opening a pull request using tools like [dune-release](https://github.com/tarides/dune-release) or [opam-publish](https://github.com/ocaml-opam/opam-publish), addressing any CI failures, and responding to maintainer feedback.

> **Publishing your first package:** See the [CONTRIBUTING.md guide](https://github.com/ocaml/opam-repository/blob/master/CONTRIBUTING.md) for detailed submission guidelines, or follow the tutorial on [publishing packages with dune](/docs/publishing-packages-w-dune).

## Getting Involved

The maintainer team actively seeks new volunteers to help manage growing submission volumes. Contributing offers opportunities to connect with the OCaml community, learn advanced packaging techniques, and gain experience with large-scale open source project management.

> **Becoming a maintainer:** Check out the [call for volunteers](https://github.com/ocaml/opam-repository/issues/27740) or review the [onboarding documentation](https://github.com/ocaml/opam-repository/wiki/Onboarding-documentation).

## Learn More

For a comprehensive look at the repository's architecture, CI infrastructure, funding, and maintainer team, read [OCaml Infrastructure: How the opam-repository Works](https://ocaml.org/backstage/2025-11-05-how-the-opam-repository-works).