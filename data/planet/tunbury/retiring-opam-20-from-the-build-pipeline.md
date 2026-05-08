---
title: Retiring opam 2.0 from the build pipeline
description: ocurrent/docker-base-images publishes the ocaml/opam:* Docker images
  which the OCaml CI systems use. For each distro, it tracks 2.0, 2.1, 2.2, 2.3, 2.4,
  2.5, and master opam release branches in parallel and produces both an opam-version-suffixed
  tag (e.g. debian-13-ocaml-5.4_opam-2.5) and an un-suffixed default that points at
  the oldest tracked version.
url: https://www.tunbury.org/2026/05/07/removing-opam-2.0/
date: 2026-05-07T14:00:00-00:00
preview_image: https://www.tunbury.org/images/opam.png
authors:
- Mark Elvers
source:
ignore:
---
