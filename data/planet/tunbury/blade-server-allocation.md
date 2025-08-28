---
title: Blade Server Allocation
description: Equinix has stopped commercial sales of Metal and will sunset the service
  at the end of June 2026. Equinix have long been a supporter of OCaml and has provided
  free credits to use on their Metal platform. These credits are coming to an end
  at the end of this month, meaning that we need to move some of our services away
  from Equinix. We have two new four-node blade servers, which will become the new
  home for these services. The blades have dual 10C/20T processors with either 192GB
  or 256GB of RAM and a combination of SSD and spinning disk.
url: https://www.tunbury.org/2025/04/23/blade-allocation/
date: 2025-04-23T00:00:00-00:00
preview_image: https://www.tunbury.org/images/supermicro.png
authors:
- Mark Elvers
source:
ignore:
---

<p>Equinix has stopped commercial sales of Metal and will sunset the service at the end of June 2026. Equinix have long been a supporter of OCaml and has provided free credits to use on their Metal platform. These credits are coming to an end at the end of this month, meaning that we need to move some of our services away from Equinix. We have two new four-node blade servers, which will become the new home for these services. The blades have dual 10C/20T processors with either 192GB or 256GB of RAM and a combination of SSD and spinning disk.</p>

<p>192GB, 20C/40T with 1.1TB SSD, 2 x 6T disks</p>
<ul>
  <li>rosemary: FreeBSD CI Worker (releasing spring &amp; summer)</li>
  <li>oregano: OpenBSD CI Worker (releasing bremusa)</li>
  <li>basil: docs-ci (new implementation, eventually replacing eumache)</li>
  <li>mint: spare</li>
</ul>

<p>256GB, 20C/40T with 1.5TB SSD, 2 x 8T disks</p>
<ul>
  <li>thyme: Equinix c2-2 (registry.ci.dev)</li>
  <li>chives: Equinix c2-4 (opam-repo-ci) + Equinix c2-3 (OCaml-ci) + Equinix c2-1 (preview.dune.dev)</li>
</ul>

<p>256GB, 20C/40T with 1.1TB SSD, 2 x 6T disks</p>
<ul>
  <li>dill: spare</li>
  <li>sage: spare</li>
</ul>

<p>VMs currently running on hopi can be redeployed to chives, allowing hopi to be redeployed.</p>

<p>Machines which can then be recycled are:</p>
<ul>
  <li>sleepy (4C)</li>
  <li>grumpy (4C)</li>
  <li>doc (4C)</li>
  <li>spring (8T)</li>
  <li>tigger</li>
  <li>armyofdockerness</li>
</ul>
