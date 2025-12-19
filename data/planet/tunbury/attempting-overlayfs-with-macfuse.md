---
title: Attempting overlayfs with macFuse
description: "It would be great if overlayFS or unionFS worked on macOS! Initially,
  I attempted to use DYLD_INTERPOSE, but I wasn\u2019t able to intercept enough system
  calls to get it to work. However, macFuse provides a way to implement our own userspace
  file systems. Patrick previously wrote obuilder-fs, which implemented a per-user
  filesystem redirection. It would be interesting to extend this concept to provide
  an overlayfs-style implementation."
url: https://www.tunbury.org/2025/10/06/overlayfs-macFuse/
date: 2025-10-06T06:00:00-00:00
preview_image: https://www.tunbury.org/images/macfuse-home.png
authors:
- Mark Elvers
source:
ignore:
---
