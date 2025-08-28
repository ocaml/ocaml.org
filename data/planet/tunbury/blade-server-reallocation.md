---
title: Blade Server Reallocation
description: We have changed our mind about using dm-cache in the SSD/RAID1 configuration.
  The current thinking is that the mechanical drives would be better served as extra
  capacity for our distributed ZFS infrastructure, where we intend to have two copies
  of all data, and these disks represent ~100TB of storage.
url: https://www.tunbury.org/2025/04/25/blade-reallocation/
date: 2025-04-25T10:15:00-00:00
preview_image: https://www.tunbury.org/images/supermicro.png
authors:
- Mark Elvers
source:
ignore:
---

<p>We have changed our mind about using <code class="language-plaintext highlighter-rouge">dm-cache</code> in the SSD/RAID1 configuration. The current thinking is that the mechanical drives would be better served as extra capacity for our distributed ZFS infrastructure, where we intend to have two copies of all data, and these disks represent ~100TB of storage.</p>

<p>As mentioned previously, we have a deadline of Wednesday, 30th April, to move the workloads from the Equinix machines or incur hosting fees.</p>

<p>I also noted that the SSD capacity is 1.7TB in all cases. The new distribution is:</p>

<ul>
  <li>rosemary: FreeBSD CI Worker (releasing spring &amp; summer)</li>
  <li>oregano: OpenBSD CI Worker (releasing bremusa)</li>
  <li>basil: Equinix c2-2 (registry.ci.dev)</li>
  <li>mint: @mte24 workstation</li>
  <li>thyme: spare</li>
  <li>chives: Equinix c2-4 (opam-repo-ci) + Equinix c2-3 (OCaml-ci) + Equinix c2-1 (preview.dune.dev)</li>
  <li>dill: spare</li>
  <li>sage: docs-ci (new implementation, eventually replacing eumache)</li>
</ul>
