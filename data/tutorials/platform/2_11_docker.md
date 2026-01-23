---
id: "ocaml-docker"
title: "OCaml Docker Images"
short_title: "Docker Images"
description: |
  :OCaml official docker images, what they are, what they provide, how to use them
category: "Additional Tooling"
---

## Docker Hub Repository: `ocaml/opam`

The official OCaml Docker images are hosted at **[hub.docker.com/r/ocaml/opam](https://hub.docker.com/r/ocaml/opam)**. The [`ocurrent/docker-base-images`](https://github.com/ocurrent/docker-base-images`) repository contains their build instructions.

**Note:** The older repositories `ocaml/opam2`, `ocaml/opam2-staging`, `ocurrent/opam`, and `ocaml/ocaml` are **no longer updated**. Use `ocaml/opam` for the latest images.

## What's Inside Each Image

Each image contains the following:
- The latest release of `opam`
- A global `opam` switch with the base image specific compiler pre-installed
- A local copy of [`opam-repository`](https://github.com/ocaml/opam-repository) from when the base-image was created
- A default user called `opam`

Each image also includes two Dockerfiles showing how it was built:
- `/Dockerfile.opam` - the first stage installing the opam binary
- `/Dockerfile.ocaml` - builds on the first stage by installing a particular opam switch

## Tag Format

Images are tagged with distribution and OCaml version:

```bash
# Full explicit tag
docker run --rm -it ocaml/opam:debian-11-ocaml-4.14

# Shorter aliases (latest versions)
docker run --rm -it ocaml/opam:debian      # Latest Debian + latest OCaml
docker run --rm -it ocaml/opam:ubuntu-lts  # Latest Ubuntu LTS
docker run --rm -it ocaml/opam:alpine      # Latest Alpine
```

The `latest` tag is the latest release of OCaml running on the latest version of Debian (Debian is used as it has the widest architecture support for OCaml).

## Supported Distributions

- **Debian** (various versions)
- **Ubuntu** (including `ubuntu-lts` for latest LTS)
- **Alpine**
- **Fedora**
- **openSUSE**
- **Arch Linux** (rolling release, just `archlinux` tag)
- **Windows**: `windows-mingw-*` (MinGW-w64) and `windows-msvc-*` (Visual Studio)

## Supported Architectures

The images are multi-arch images including support for 32 and 64 bit where possible and `arm`, `x86` and `ppc`.

## OCaml Compiler Variants

Beyond standard OCaml versions, there are variants like:
- Flambda enabled (`ocaml-option-flambda`)
- Frame pointers enabled (`ocaml-option-fp`)

## How They're Built

This is an OCurrent pipeline that builds Docker images for OCaml, for various combinations of Linux distribution, Windows version, OCaml version and architecture.

The images are **updated weekly** via an automated pipeline at [images.ci.ocaml.org](https://images.ci.ocaml.org).

## Usage Notes

This is important. If you use the base-images as a base to build upon in a Dockerfile (i.e. `FROM ocaml/opam...`) this will be run as the `opam` user. This can cause permission errors if you try to build somewhere that needs root access. You can either change the user to `root` before building anything or ensure you build somewhere you have access to such as `/home/opam`.

When copying files into the image, use:
```dockerfile
COPY --chown=opam <SRCs> <DST>
```

## Special Tags

- **`archive`** - Contains a snapshot of all source archives for opam-repository (useful for setting up a local cache)
- **SHA256 hashes** - Used by OCaml-CI for reproducible builds

## Primary Use Cases

These images are primarily intended for OCaml's Continuous Testing systems, and can be a little quirky to use as development images.

They're used by:
- **ocaml-ci** - for testing OCaml projects
- **opam-repo-ci** - for testing opam package submissions
- **opam-health-check** - for monitoring package health

## Example: Basic Usage

```bash
# Interactive session with latest Debian + OCaml
docker run --rm -it ocaml/opam

# Specific distribution and OCaml version
docker run --rm -it ocaml/opam:ubuntu-22.04-ocaml-5.1

# Mount your project
docker run --rm -it -v $(pwd):/home/opam/project ocaml/opam
```

## Pinning Images

Instead of using tags (which can change when images are updated weekly), you can **pin** to an exact immutable image using its SHA256 digest:

```dockerfile
# Unpinned - may change over time
FROM ocaml/opam:debian-11-ocaml-4.14

# Pinned - guaranteed to be identical every time
FROM ocaml/opam:debian-11-ocaml-4.14@sha256:167218493be2d3a2f93c9546fc73f249c6911ee5c8998874a2038677bfbd6fb2
```

**Why pin?**

- **Reproducibility**: When you pull an image by its digest, you are guaranteed to get the exact same image every time, regardless of when or by whom it was pushed to the registry.
- **Debugging**: OCaml-CI uses pinning so you can reproduce a failing build with the exact same environment
- **Security**: If the image changes for any reason, the mathematics of cryptography guarantees that the digest also changes.

**Finding a digest:**
```bash
docker images --digests ocaml/opam
```

**Trade-off**: Pinned images don't get automatic updates, so you must manually update the digest to receive security patches.
