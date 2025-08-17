---
title: Functional Networking for Millions of Docker Desktops
description:
url: https://dl.acm.org/doi/10.1145/3747525
date: 2025-08-01T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
ignore:
---


Docker is a developer tool used by millions of developers to build, share and
run software stacks. The Docker Desktop clients for Mac and Windows have long
used a novel combination of virtualisation and OCaml unikernels to seamlessly
run Linux containers on these non-Linux hosts.

We reflect on a decade of shipping this functional OCaml code into production
across hundreds of millions of developer desktops, and discuss the lessons
learnt from our experiences in integrating OCaml deeply into the container
architecture that now drives much of the global cloud. We conclude by observing
just how good a fit for systems programming that the unikernel approach has
been, particularly when combined with the OCaml module and type system.

