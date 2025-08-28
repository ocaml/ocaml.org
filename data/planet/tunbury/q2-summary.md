---
title: Q2 Summary
description: "I am grateful for Tarides\u2019 sponsorship of my OCaml work. Below
  is a summary of my activities in Q2 2025."
url: https://www.tunbury.org/2025/07/18/q2-summary/
date: 2025-07-18T12:00:00-00:00
preview_image: https://www.tunbury.org/images/tarides.png
authors:
- Mark Elvers
source:
ignore:
---

<p>I am grateful for <a href="https://tarides.com">Tarides</a>’ sponsorship of my OCaml work. Below is a summary of my activities in Q2 2025.</p>

<h1>OCaml Infrastructure and Development</h1>

<h2>OCaml Maintenance Activities</h2>

<p>General maintenance work on OCaml’s infrastructure spanned many areas, including <a href="https://www.tunbury.org/2025/03/24/recent-ocaml-version/">updating minimum supported OCaml versions from 4.02 to 4.08</a> and addressing issues with <a href="https://www.tunbury.org/2025/04/04/opam-repo-ci/">opam-repo-ci job timeouts</a>. Platform-specific work included resolving compatibility issues with <a href="https://www.tunbury.org/2025/04/22/ocaml-fedora-gcc/">Fedora 42 and GCC 15</a>, addressing <a href="https://www.tunbury.org/2025/05/13/ubuntu-apparmor/">Ubuntu AppArmor</a> conflicts affecting runc operations, and managing <a href="https://www.tunbury.org/2025/05/19/macos-sequoia/">macOS Sequoia</a> upgrades across the Mac Mini CI workers. Complex build issues were investigated and resolved, including <a href="https://www.tunbury.org/2025/06/21/macos-sequoia-include-path/">C++ header path problems in macOS workers</a> and <a href="https://www.tunbury.org/2025/03/26/freebsd-14.2/">FreeBSD system upgrades</a> for the CI infrastructure.</p>

<h2>OCaml Infrastructure Migration</h2>

<p>Due to the impending sunset of the <a href="https://www.tunbury.org/2025/04/23/blade-allocation/">Equinix Metal platform</a>, the OCaml community services needed to be migrated. Services including <a href="https://www.tunbury.org/2025/04/27/ocaml-ci/">OCaml-CI</a>, <a href="https://www.tunbury.org/2025/04/29/equinix-moves/">opam-repo-ci</a>, and the <a href="https://www.tunbury.org/2025/04/29/equinix-moves/">opam.ocaml.org</a> deployment pipeline were migrated to <a href="https://www.tunbury.org/2025/04/25/blade-reallocation/">new blade servers</a>. The migration work was planned to minimise service disruption, which was kept to just a few minutes. Complete procedures were documented, including Docker volume transfers and rsync strategies.</p>

<h2>opam2web Deployment</h2>

<p>Optimisation work was undertaken on the <a href="https://www.tunbury.org/2025/06/24/opam2web/">deployment pipeline for opam2web</a>, which powers opam.ocaml.org, to address the more than two-hour deployment time. The primary issue was the enormous size of the opam2web Docker image, which exceeded 25GB due to the inclusion of complete opam package archives. The archive was moved to a separate layer, allowing Docker to cache the layer and reducing the deployment time to 20 minutes.</p>

<h2>opam Dependency Graphs</h2>

<p>Algorithms for managing OCaml package dependencies were investigated, including <a href="https://www.tunbury.org/2025/03/25/topological-sort/">topological sorting</a> to determine the optimal package installation order. This work extended to handling complex dependency scenarios, including post-dependencies and optional dependencies. Implemented a <a href="https://www.tunbury.org/2025/06/23/transitive-reduction/">transitive reduction algorithm</a> to create a dependency graph with minimal edge counts while preserving the same dependency relationships, enabling more efficient package management and installation processes.</p>

<h2>OCaml Developments under Windows</h2>

<p>Significant work was undertaken to bring <a href="https://www.tunbury.org/2025/06/14/windows-containerd-2/">containerization</a> technologies to OCaml development on Windows. This included implementing a tool to create <a href="https://www.tunbury.org/2025/06/27/windows-containerd-3/">host compute networks</a> via the Windows API,  tackling limitations with <a href="https://www.tunbury.org/2025/06/18/windows-reflinks/">NTFS hard links</a>, and implementing copy-on-write <a href="https://www.tunbury.org/2025/07/07/refs-monteverde/">reflink</a> tool for Windows.</p>

<h2>OxCaml Support</h2>

<p>Support for the new OxCaml compiler variant included establishing an <a href="https://www.tunbury.org/2025/06/12/oxcaml-repository/">opam repository</a> and testing which existing <a href="https://www.tunbury.org/2025/05/14/opam-health-check-oxcaml/">OCaml packages</a> successfully built with the new compiler.</p>

<h1>ZFS Storage and Hardware Deployment</h1>

<p>Early in the quarter, a hardware deployment project centred around <a href="https://www.tunbury.org/2025/04/11/dell-r640-ubuntu/">Dell PowerEdge R640</a> servers with a large-scale SSD storage was undertaken. The project involved deploying multiple batches of <a href="https://www.tunbury.org/2025/04/03/kingston-drives/">Kingston 7.68TB SSD drives</a>, creating automated deployments for Ubuntu using network booting with EFI and cloud-init configuration. Experimented with ZFS implementation as a <a href="https://www.tunbury.org/2025/04/02/ubuntu-with-zfs-root/">root filesystem</a>, which was possibly but ultimately discarded and explored <a href="https://www.tunbury.org/2025/04/21/ubuntu-dm-cache/">dm-cache for SSD acceleration</a> of spinning disk arrays. Investigated using ZFS as a distributed storage archive system using an <a href="https://www.tunbury.org/2025/05/16/zfs-replcation-ansible/">Ansible-based deployment</a> strategy based upon a YAML description.</p>

<h2>Talos II Repairs</h2>

<p><a href="https://www.tunbury.org/2025/04/29/raptor-talos-ii/">Significant hardware reliability issues</a> affected two Raptor Computing Talos II POWER9 machines. The first system experienced complete lockups after as little as 20 minutes of operation, while the second began exhibiting similar problems requiring daily power cycling. Working with Raptor Computing support to isolate the issues, upgrading firmware and eventually <a href="https://www.tunbury.org/2025/05/27/raptor-talos-ii-update/">swapping CPUs</a> between the systems resolved the issue. Concurrently, this provided an opportunity to analyse the performance of OBuilder operations on POWER9 systems, comparing <a href="https://www.tunbury.org/2025/05/29/overlayfs/">OverlayFS on TMPFS versus BTRFS on NVMe storage</a>, resulting in optimised build performance.</p>

<h1>EEG Systems Investigations</h1>

<p>Various software solutions and research platforms were explored as part of a broader system evaluation. This included investigating <a href="https://www.tunbury.org/2025/04/14/slurm-workload-manager/">Slurm Workload Manager</a> for compute resource scheduling, examining <a href="https://www.tunbury.org/2025/04/19/gluster/">Gluster distributed filesystem</a> capabilities, and implementing <a href="https://www.tunbury.org/2025/05/07/otter-wiki-with-raven/">Otter Wiki with Raven authentication</a> integration for collaborative documentation. Research extended to modern research data management platforms, exploring <a href="https://www.tunbury.org/2025/06/03/inveniordm/">InvenioRDM</a> for scientific data archival and <a href="https://www.tunbury.org/2025/07/02/bon-in-a-box/">BON in a Box</a> for biodiversity analysis workflows. To support the <a href="https://www.tunbury.org/2025/07/14/tessera-workshop/">Teserra workshop</a>, a multi-user Jupyter environment was set up using Docker containerization.</p>

<h1>Miscellaneous Technical Explorations</h1>

<p>Diverse technical explorations included implementing <a href="https://www.tunbury.org/2025/03/15/bluesky-pds/">Bluesky Personal Data Server</a> and developing innovative <a href="https://www.tunbury.org/2025/04/25/bluesky-ssh-authentication/">SSH authentication</a> mechanisms using the ATProto network by extracting SSH public keys from Bluesky profiles. Additional projects included developing OCaml-based API tools for <a href="https://www.tunbury.org/2025/04/12/box-diff/">Box cloud storage</a>, creating <a href="https://www.tunbury.org/2025/03/23/real-time-trains/">Real Time Trains</a> API integrations, and exploring various file synchronisation and <a href="https://www.tunbury.org/2025/06/14/borg-backup/">backup</a> solutions. Investigation of <a href="https://www.tunbury.org/2025/07/15/reflink-copy/">reflink copy</a> mechanisms for efficient file operations using OCaml multicore.</p>
