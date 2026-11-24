---
title: Notes from week 47
description: "day10 now builds every package offline on all four platforms, matching
  obuilder; a use-after-free went away by building with OCaml 4.14; banning immutable
  let rec cycles breaks about 30% of opam-repository until 41 patches are applied;
  the Windows lazy-writer workaround held up in a controlled trial; and most machines
  are now patched for last month\u2019s kernel CVE."
url: https://www.tunbury.org/2026/11/23/week-47/
date: 2026-11-23T09:00:00-00:00
preview_image: https://www.tunbury.org/images/fsdepends-jams.png
authors:
- Mark Elvers
source:
ignore:
keywords:
- day10
- doris
- dune
- image
- lwt
- obuilder
- ocaml-ci
- ocurrent
- rejected
- round
---

<p><code class="language-plaintext highlighter-rouge">day10</code> now builds every package offline on all four platforms, matching obuilder; a use-after-free went away by building with OCaml 4.14; banning immutable <code class="language-plaintext highlighter-rouge">let rec</code> cycles breaks about 30% of opam-repository until 41 patches are applied; the Windows lazy-writer workaround held up in a controlled trial; and most machines are now patched for last month’s kernel CVE.</p>

<h1><code class="language-plaintext highlighter-rouge">day10</code></h1>

<h2>Builds without network</h2>

<p>My first approach was to prefetch everything a build might need into each base image: sources, every system package, and any system dependencies, <em>depexts</em>, that might be requested. That got as far as working prototypes on Linux, FreeBSD and MSYS2, and using a patched opam for Cygwin, before I stopped. The issue is that the offline system packages would always be a retrospective view of the packages needed by opam-repository, so if a contributor adds a new <code class="language-plaintext highlighter-rouge">conf-*</code> package, the system package they need won’t be in the base because nobody knew to prefetch it. The idea of caching system packages was appealing, as it also addresses the mirror drift issue, where distributions, Arch in particular, end up with a stale package database pointing to URLs that no longer exist.</p>

<p>Only about 5% of package versions have depexts at all, so the design now is: a layer with depexts gets a short networked start which runs only <code class="language-plaintext highlighter-rouge">day10-install --depexts-only</code>, and then the build itself runs with no network; everything else builds entirely offline. Sources are staged on the host into the build’s opam-repository <code class="language-plaintext highlighter-rouge">cache/</code> through <code class="language-plaintext highlighter-rouge">archive-mirrors:</code>; this includes the few git sources, which are fetched shallow and turned into a tarball with <code class="language-plaintext highlighter-rouge">git archive</code>, with submodules grafted in using <code class="language-plaintext highlighter-rouge">git mktree</code> and the commit time as the mtime so the bytes are reproducible. opam rejected a plain tar (<code class="language-plaintext highlighter-rouge">Unknown archive type</code>) because cache entries have no extension, so they are <code class="language-plaintext highlighter-rouge">.tar.gz</code>.</p>

<p>The new approach was tested on each platform: thyme (FreeBSD), navajo (Windows), m1-worker-04 (macOS), and my machine (Linux). The design is the same everywhere, but the mechanism differs: a networked jail followed by a <code class="language-plaintext highlighter-rouge">vnet</code> jail with only <code class="language-plaintext highlighter-rouge">lo0</code> on FreeBSD; two container starts on the same snapshot on Windows; and two boots of the same disk clone on macOS.</p>

<h2>A use-after-free and OCaml 4.14</h2>

<p>Last week, <code class="language-plaintext highlighter-rouge">day10-install --reinstall --with-test</code> was crashing on doris and okypous with <code class="language-plaintext highlighter-rouge">Fatal error: allocation failure during minor GC</code>, but not on my machine with the identical binary. A core dump showed the GC promoting a <code class="language-plaintext highlighter-rouge">Forward_tag</code> block, a forced <code class="language-plaintext highlighter-rouge">Lazy</code>, whose field pointed 48 bytes into a string in the major heap holding a path under <code class="language-plaintext highlighter-rouge">.opam-switch/build/</code>. The GC read the bytes <code class="language-plaintext highlighter-rouge">witch/bu</code> as a block header and tried to allocate about 8x10^15 words.</p>

<p>day10-install had been built with OCaml 5.3.0. opam’s own releases are built with 4.14, so I tried that as an easy workaround: 6 out of 6 runs crashed with 5.3.0 and 3 out of 3 passed with 4.14.4. The root cause has not been investigated.</p>

<h2>pin-depends and Windows build/exec</h2>

<p>A project’s <code class="language-plaintext highlighter-rouge">pin-depends</code> are now resolved on the host (<a href="https://github.com/mtelvers/day10/issues/9">mtelvers/day10#9</a>): each git source is fetched one commit deep, its opam file is added to the repository with the URL rewritten to the resolved commit, and the source is staged like any other, so the build stays offline. This was tested on all four platforms.</p>

<p>On Windows, <code class="language-plaintext highlighter-rouge">build</code> and <code class="language-plaintext highlighter-rouge">exec</code> of a project directory had never been implemented. This has now been implemented using a bind mount of the project directory into the container. I acknowledge that Windows bind mounts have been problematic, but these were mostly with system packages, and that <code class="language-plaintext highlighter-rouge">dune build</code> would be fine on a bind mount. In limited testing, this has been fine. My test build with an empty cache took about 1,140 s on Cygwin and 1,280 s on MSYS2, and subsequent rebuilds take 22 s - 29 s.</p>

<p>I also noticed that <code class="language-plaintext highlighter-rouge">day10 ci</code> is unused except for a test case. OCaml-CI uses <code class="language-plaintext highlighter-rouge">build</code>, so that partially implemented function was removed.</p>

<h2>Agreeing with obuilder</h2>

<p>Differences between <code class="language-plaintext highlighter-rouge">day10</code> and obuilder this week have been:</p>

<ul>
  <li><code class="language-plaintext highlighter-rouge">x-ci-accept-failures</code> lists opam-repo-ci’s platform names, such as <code class="language-plaintext highlighter-rouge">freebsd-15.1</code> and <code class="language-plaintext highlighter-rouge">macos-homebrew</code>. opam on FreeBSD reports <code class="language-plaintext highlighter-rouge">os-version</code> as <code class="language-plaintext highlighter-rouge">1501000</code>, and <code class="language-plaintext highlighter-rouge">day10</code> was matching against that. It now matches opam-repo-ci’s names. A scan of opam-repository found 70 distinct accept-failure strings in 509 opam files.</li>
  <li>On <a href="https://github.com/ocaml/opam-repository/pull/31282">#31282</a>, <code class="language-plaintext highlighter-rouge">day10</code> had 84 failures against obuilder’s 1. 38 were the accept-failures names. The other 46 were <code class="language-plaintext highlighter-rouge">conf-bison.2</code> on CentOS: opam’s <code class="language-plaintext highlighter-rouge">os-family</code> there is <code class="language-plaintext highlighter-rouge">rhel</code>, which conf-bison doesn’t list, and obuilder passed only because <code class="language-plaintext highlighter-rouge">ocaml/opam:centos-*</code> already ships bison. 25 other packages still test <code class="language-plaintext highlighter-rouge">os-family = "centos"</code>, which never matches.</li>
  <li><a href="https://github.com/ocaml/opam-repository/pull/31290">#31290</a>, merge-fmt, is the mirror image: it fails on obuilder’s alpine image because <code class="language-plaintext highlighter-rouge">diff</code> is BusyBox, which prints unified diffs, and passes on <code class="language-plaintext highlighter-rouge">day10</code> because its base installs GNU diffutils. The package is missing <code class="language-plaintext highlighter-rouge">conf-diffutils</code>. I’ve promised to align the default package sets of the two systems.</li>
  <li>ostap.0.6.1 failed only under <code class="language-plaintext highlighter-rouge">day10</code>. The cause is that Dune 3.25.0 no longer puts the install area on <code class="language-plaintext highlighter-rouge">OCAMLPATH</code> for actions (<a href="https://github.com/ocaml/dune/issues/16617">dune#16617</a>), and obuilder masks it because it runs the tests with the package still installed.</li>
</ul>

<h2>macOS</h2>

<p>All four Apple Silicon Macs have now been updated to macOS 27.2.1 with OpenZFS 2.4.1p2.</p>

<h1>Windows</h1>

<h2>The FsDepends leak</h2>

<p>On Windows Server 2025, the per-volume lazy writer can leak a reference, causing every container volume that is removed to remain mounted until reboot. This week I ran a trial on two identical VMs, one treated with <code class="language-plaintext highlighter-rouge">EnablePerVolumeLazyWriter=0</code> and one not.</p>

<p>The treated machines ran 416 builds without a jam. The untreated ones jammed after 10 and 14 builds, and kept jamming after each reboot: four jams in four segments.</p>

<p>The key prevents ReFS volumes from mounting at boot, so navajo’s day10 worker was moved to NTFS. I posted the results on <a href="https://github.com/microsoft/Windows-Containers/issues/663">Windows-Containers#663</a>.</p>

<p>ltsc2025-3 hit an issue <code class="language-plaintext highlighter-rouge">Could not resolve host: github.com</code> as the scheduled task that writes containerd’s CNI config had raced the host network service at boot, leaving containers on a dead subnet. I’ve updated the script so it now waits for the network before writing the configuration.</p>

<h1>Other CI work</h1>

<h2>Banning immutable <code class="language-plaintext highlighter-rouge">let rec</code> cycles</h2>

<p>David asked how much of opam-repository would break with <a href="https://github.com/mkoconnor/ocaml">mkoconnor’s branch</a> of OCaml 5.4.1, which rejects recursive definitions such as <code class="language-plaintext highlighter-rouge">let rec x = 1 :: x</code>. The first result was that dune itself fails to bootstrap as its fiber scheduler’s root context refers to itself. However, while this was interesting, it didn’t really show the impact of the change, as dune might be the only package which uses the feature.</p>

<p>With dune patched, 1,059 of 3,582 packages that build on 5.4.1 failed. Of those, only 22 were rejected directly; the rest failed through dependencies, mostly menhirLib (491) and lwt (395). The pattern is almost never a cyclic list. It’s a sentinel, root or self-pointer: menhirLib’s empty stack points to itself, and an lwt channel record contains itself.</p>

<p><img src="https://www.tunbury.org/images/letrec-rounds.png" alt="letrec rounds"></p>

<p><em>Each round patches the packages rejected directly, then rebuilds everything</em></p>

<p>Next I ran this in a loop: each round ran <code class="language-plaintext highlighter-rouge">day10</code> to quickly test the entirety of opam-repository, and Claude then fixed all the failing packages, usually by making the closing field mutable or using <code class="language-plaintext highlighter-rouge">Obj.set_field</code>, and then repeated. <code class="language-plaintext highlighter-rouge">day10</code> reuses every unchanged layer, so a round took 36 minutes at first and 6 minutes by the end. Round 2 found some real cyclic lists (catala’s parenthesis colours, oskel’s spinner). Round 4 found two of Claude’s own patches had broken packages on both compilers. It converged after five rounds: 41 patches across 31 packages, 127 lines, on a <a href="https://github.com/mtelvers/opam-repository/tree/letrec-no-immutable-cycles">branch</a>. The single remaining failure asks for <code class="language-plaintext highlighter-rouge">ocaml-base-compiler</code> by name.</p>

<h2>One EMFILE, 654 missing jobs</h2>

<p>On opam-repository, Fedora 44 x86<em>64 OCaml 4.14 showed “not started” for both obuilder and <code class="language-plaintext highlighter-rouge">day10</code>. Every Linux build node depends on a weekly <code class="language-plaintext highlighter-rouge">Docker.peek</code> of its base image, and the peek for that image failed when the opam-repo-ci engine ran out of file descriptors: <code class="language-plaintext highlighter-rouge">Unix.Unix_error(15, "pipe", "")</code>. 15 is the position of <code class="language-plaintext highlighter-rouge">EMFILE</code> in OCaml’s <code class="language-plaintext highlighter-rouge">Unix.error</code> type, not errno 15. The failure was cached, so 654 variants across all PRs had no job. <code class="language-plaintext highlighter-rouge">day10</code> doesn’t _need</em> the peek result, but in the way I’ve patched <code class="language-plaintext highlighter-rouge">day10</code> to run alongside obuilder in ocurrent, it is an unused input.</p>

<h2>Smaller items</h2>

<ul>
  <li><a href="https://github.com/ocaml/opam/pull/7229">ocaml/opam#7229</a>, adding CLI version 2.6, is merged.</li>
  <li>The Docker base images builder now builds images with OCaml 4.14.5 and adds images for openSUSE Leap 16.1 (<a href="https://github.com/ocurrent/docker-base-images/pull/364">#364</a>).</li>
  <li>Both the Docker base image builder and OCaml-CI (<a href="https://github.com/ocurrent/ocaml-ci/pull/1085">#1085</a>) had stopped building because <code class="language-plaintext highlighter-rouge">COPY --chown=opam --link</code> is now an error. That came from Dockerfile frontend 1.28.0 (buildkit <a href="https://github.com/moby/buildkit/pull/7134">#7134</a>), picked up automatically through <code class="language-plaintext highlighter-rouge"># syntax=docker/dockerfile:1</code>, not from a Docker upgrade. Numeric <code class="language-plaintext highlighter-rouge">1000:1000</code> works.</li>
  <li>OCaml-CI builds on OpenBSD 8.0 (<a href="https://github.com/ocurrent/ocaml-ci/pull/1084">#1084</a>, <a href="https://github.com/ocurrent/obuilder/pull/226">obuilder#226</a>), and the 7.6 to 7.9 images are gone. oregano’s capacity was measured at 10, 15 and 20: about 55, 75 and 70 jobs an hour, so it stays at 15.</li>
  <li>The Intel Macs are powered off.</li>
  <li>The Apple Silicon Macs are in a temporary location awaiting transit to Cambridge Datacenter.</li>
</ul>

<h1>Cambridge machines</h1>

<h2>A fleet patch round</h2>

<p>The interim nftables filter for <a href="https://www.tunbury.org/2026/11/02/week-44/">CVE-2026-98432</a> is coming off as machines move to fixed kernels. Rather than rebooting just to update the kernel, I took the opportunity to run a full <code class="language-plaintext highlighter-rouge">apt full-upgrade</code> across the board, one machine at a time. I also assessed each machine’s activity and found a few idle machines at Scaleway.</p>

<p>About 50 machines were done this week. A few notes:</p>

<ul>
  <li><strong>opam.ocaml.org</strong> Each server was booted into the new kernel once with <code class="language-plaintext highlighter-rouge">grub-reboot</code> and <code class="language-plaintext highlighter-rouge">panic=30</code>, leaving the old kernel as the default in case it didn’t come back. The first attempt failed before any reboot: the cloud image’s GRUB configuration discarded <code class="language-plaintext highlighter-rouge">panic=30</code>. With that fixed, both servers came back in under 30 s.</li>
  <li><strong>Warm-reboot hangs.</strong> Four of six Dell R630s hung in firmware after a clean shutdown, as did fermat (SuperMicro) and doris (R6525), and toxis came back with no network link. Each needed a full power cycle, and two a BMC reset. The first hypothesis, old kernels after long uptime, was ruled out by doris, which was already on a current kernel. The second, the R630 model, was ruled out by fermat and doris. The BIOS versions are identical across the R630s. I’ve rebooted these machines hundreds of times without needing a power cycle, so it’s a bit of a mystery why that’s started happening.</li>
  <li><strong>aello</strong>, a PostgreSQL server, was also on 20.04. It went to 22.04 and then 24.04, with PostgreSQL 14 to 16 done as a link-mode <code class="language-plaintext highlighter-rouge">pg_upgrade</code> of about 18 TB in about 11 minutes.</li>
  <li>doc, the nameserver for caelum.ci.dev, spent two minutes of every boot waiting for an uncabled network port, so I have applied a fix for that in netplan.</li>
</ul>

<h2>Ceph</h2>

<p>Six OSDs were at 85% full on a cluster, triggering a space warning. This comes from the balancer’s default <code class="language-plaintext highlighter-rouge">upmap_max_deviation</code> of 5. Setting it to 1 brought the OSDs from 62-85% to 72-77% and raised usable headroom from 47 TiB to 86 TiB.</p>

<p>daintree’s CephFS client was silently evicted three times in nine days, each time on a heavily written mount holding up to a million caps, with nothing logged except the eviction. I’ve increased the <code class="language-plaintext highlighter-rouge">session_timeout</code> to 120 s on daintree’s mounts and enabled <code class="language-plaintext highlighter-rouge">recover_session=clean</code>. Why daintree stops renewing is not known.</p>

<h2>monteverde</h2>

<p>I couldn’t find anyone else online complaining about the issues with their PS1010, which raised the question that this was a software issue rather than a hardware one. Every NVMe command was logged: on the PS1010, 22 commands had a buffer ending exactly at 2^64, and all 22 were rejected with <code class="language-plaintext highlighter-rouge">Data SGL Length Invalid</code>; on the Samsung PM1743 in the same machine, 376 ended there, and none were rejected. The addresses come from the IOMMU’s per-CPU address caches; with 768 logical CPUs, they hold about 24 GiB of address space for 128 KiB buffers alone, so allocations spill out of the low 4 GiB window into the top of the 64-bit space.</p>

<p>I challenged Claude to write a script to reproduce the problem separate from anything else. Claude wrote a user-space VFIO reproducer which drives the drive directly. It failed on the first try, exactly as predicted: SGL writes ending at 2^64 are rejected; the same pages via PRP, or ending 128 KiB lower, succeed. Hopefully Dell will now arrange a firmware fix or a replacement drive.</p>

<h1>Tessera</h1>

<p>The Greenland run for EPFL is complete for 2017, 2019, and 2023, including a refill of 114 shards for 2017, whose existing embeddings were only partially populated. A second, much smaller request for central Senegal was six shard-years and took two and a half hours.</p>

<h1>Other</h1>

<h2><a href="https://inbox.ci.dev/caml-list">inbox.ci.dev</a></h2>

<p>inbox.ci.dev, the caml-list archive, was running on Ubuntu 20.04, which has no fixed kernel. As part of the CVE work, it moved to a new 24.04 VM, and then to a Debian Trixie container image (664 MB, down from 1.13 GB). The old bullseye image can no longer be rebuilt because bullseye-backports has gone.</p>

<p>At the same time, I applied a stylesheet to make it look more like ocaml.org.</p>

<h2>32-bit OCaml</h2>

<p>The nightly rebase of the 32-bit backends hit conflicts in <code class="language-plaintext highlighter-rouge">runtime/power.S</code> for several days, then a stray <code class="language-plaintext highlighter-rouge">#endif</code> from resolving them, then a missing <code class="language-plaintext highlighter-rouge">#else</code> that left PPC64’s <code class="language-plaintext highlighter-rouge">caml_c_call_stack_args</code> with no call in it, so <code class="language-plaintext highlighter-rouge">ocamlc.opt</code> crashed on startup. Since Wednesday, it has been green every day.</p>
