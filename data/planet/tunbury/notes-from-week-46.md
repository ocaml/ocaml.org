---
title: Notes from week 46
description: "day10 now builds on every platform obuilder does: Linux, Windows, macOS
  and FreeBSD; CephFS spent the week being slow; monteverde\u2019s replacement drive
  has the same fault as the one it replaced; and Greenland is nearly done."
url: https://www.tunbury.org/2026/11/16/week-46/
date: 2026-11-16T09:00:00-00:00
preview_image: https://www.tunbury.org/images/day10-parity.png
authors:
- Mark Elvers
source:
ignore:
keywords:
- ceph
- concurrency
- day10
- freebsd
- macos
- obuilder
- ocaml-ci
- strays
- week
- windows
---

<p><code class="language-plaintext highlighter-rouge">day10</code> now builds on every platform obuilder does: Linux, Windows, macOS and FreeBSD; CephFS spent the week being slow; monteverde’s replacement drive has the same fault as the one it replaced; and Greenland is nearly done.</p>

<h1><code class="language-plaintext highlighter-rouge">day10</code></h1>

<h2>System parity with obuilder</h2>

<p><code class="language-plaintext highlighter-rouge">day10</code> now supports Linux, Windows, FreeBSD and macOS, and these are running in parallel with the obuilder jobs in opam-repo-ci.</p>

<p>The results are better than 90% identical across the platforms. The remaining differences are largely due to the base commit differing between this week, when the <code class="language-plaintext highlighter-rouge">day10</code> job ran, and potentially many months ago, when some of the obuilder jobs ran.</p>

<p>FreeBSD was written when <code class="language-plaintext highlighter-rouge">day10</code> started, but wasn’t deployed until now. However, the macOS support was newly written this week.</p>

<h2>macOS: a VM per build</h2>

<p>The macOS backend uses a new tool, <code class="language-plaintext highlighter-rouge">day10-vm</code>, to run each build in a Virtualization.framework VM. Unfortunately, there is no layered filesystem. There are external mounts, which are basically network shares, but as we have found on FreeBSD and Windows, these filesystems do not behave the same as a local filesystem in corner cases.</p>

<p>The image is built from an IPSW: macOS 15.6.1, the command-line tools, and an opam user. When a job starts, the snapshot filesystem is mounted, and the layers, the command (to be run by a one-shot LaunchDaemon in the VM) and a timestamp marker are copied over. The volume is unmounted, and the machine is booted. The command runs in the VM, with its output redirected to the virtual serial port for real-time logging. Once the command finishes, the machine is stopped, the filesystem is remounted, and the differences are determined by comparing the timestamp on the marker file.</p>

<p>Test builds of astring, zarith (with a Homebrew depext) and <code class="language-plaintext highlighter-rouge">--with-test</code> passed, and a cancel exits with 130 and leaves nothing behind. m1-worker-04 was then converted from an obuilder worker to a dedicated <code class="language-plaintext highlighter-rouge">day10-macos-arm64</code> worker: its ZFS pool was destroyed and replaced with a 227 GiB APFS volume. The Virtualization framework allows at most two macOS VMs per host, which isn’t much, but it is better than obuilder’s single concurrency. Its host is on macOS 15.5 while the image is 15.6.1. It needs updating to the latest macOS, as do the obuilder workers.</p>

<p>Of 596 jobs, 573 matched obuilder. Of the 23 differences, 16 are base drift, 3 came from a layer-merge bug (a symlink against a directory in Homebrew’s <code class="language-plaintext highlighter-rouge">share/gettext/its</code>) that has since been fixed, and 2 are <code class="language-plaintext highlighter-rouge">odnnr</code>, which differs because <code class="language-plaintext highlighter-rouge">day10</code> runs opam with <code class="language-plaintext highlighter-rouge">--disable-sandboxing</code>.</p>

<h2>FreeBSD: out with unionfs</h2>

<p>thyme was netbooted into mfsBSD and reinstalled as a FreeBSD 15.1 <code class="language-plaintext highlighter-rouge">day10</code> worker on UFS. After months of problems with ZFS-backed obuilder (now worked around), I was pleased to be using UFS.</p>

<p>Comparing 632 jobs with obuilder, 443 of 488 matched pairs agreed. 38 of the 40 cases where <code class="language-plaintext highlighter-rouge">day10</code> failed and obuilder passed had a single cause: pkg failing with <code class="language-plaintext highlighter-rouge">Failed to rename ... -&gt; /usr/local/lib/gdk-pixbuf-2.0: Invalid argument</code>. On FreeBSD’s unionfs, renaming a directory over an empty directory returns EINVAL. No combination of mount options changes it.</p>

<p>So FreeBSD now uses the same model as Windows and macOS: assemble a real root, build, and collect the changes with <code class="language-plaintext highlighter-rouge">find -newercm</code>. Real copies cost about 6 s per build. With them, conf-gtk4, conf-gdk-pixbuf, ocgtk, conf-gnuplot, conf-r and conf-mysql all build.</p>

<p>That exposed a problem unionfs had been hiding. With several layers merged, pkg saw only the database from the topmost layer. Each layer now records a manifest, and the database is reassembled with <code class="language-plaintext highlighter-rouge">pkg register</code> inside the jail, which unfortunately takes about 8 s.</p>

<h2>Windows in opam-repo-ci</h2>

<p>opam-repo-ci now tests Cygwin and MSYS2 with OCaml 4.14 and 5.5 via <code class="language-plaintext highlighter-rouge">day10</code>. Over 53 PR heads, 952 of 960 jobs completed: 233 succeeded, 292 had no solution, 195 had a failed dependency, and 228 failed. Windows never passes where Linux fails.</p>

<p>Once real jobs were flowing:</p>

<ul>
  <li><code class="language-plaintext highlighter-rouge">dune-site</code> failed on a 262-character path against Windows’ 259 limit, so opam’s root moved from <code class="language-plaintext highlighter-rouge">APPDATA</code> to <code class="language-plaintext highlighter-rouge">C:\opam</code>, and navajo’s D: was reformatted as ReFS while I was at it.</li>
  <li>The MSYS2 mirrors return HTTP 429 when they see a burst, so the base now fetches one package at a time and retries after a pause.</li>
  <li>A dependency cycle exited with opam’s code 60, which bypassed the classifier and gated the job. It now reports <code class="language-plaintext highlighter-rouge">[ERROR] dependency cycle</code> and exits 0.</li>
</ul>

<p><code class="language-plaintext highlighter-rouge">x-ci-accept-failures</code> caused some frustration on <a href="https://github.com/ocaml/opam-repository/pull/31195">#31195</a> and <a href="https://github.com/ocaml/opam-repository/pull/31240">#31240</a>. The convention from <a href="https://github.com/ocaml/opam-repository/pull/28856">#28856</a> is <code class="language-plaintext highlighter-rouge">cygwin-mingw</code> and <code class="language-plaintext highlighter-rouge">msys2-mingw</code>, with bare <code class="language-plaintext highlighter-rouge">cygwin</code> meaning pure Cygwin, but <code class="language-plaintext highlighter-rouge">day10</code> was matching the bare names, so <code class="language-plaintext highlighter-rouge">flint</code> needed both. <code class="language-plaintext highlighter-rouge">day10</code> now matches only the <code class="language-plaintext highlighter-rouge">-mingw</code> forms. That newly silences a few packages and un-silences <code class="language-plaintext highlighter-rouge">ortools_solvers</code>, which lists only the bare names.</p>

<p>Finally, the layers are now filled and read from the host through <code class="language-plaintext highlighter-rouge">wclayer</code> rather than copied inside the container. Timing showed no difference, but I preferred this as the model matched the other architectures such as macOS and FreeBSD.</p>

<h2>Cancelling a job</h2>

<p>Cancelling a job now works the same way on every platform: ocluster-worker interrupts, then kills. Linux sends SIGINT rather than SIGTERM, and Windows uses a small <code class="language-plaintext highlighter-rouge">console-interrupt</code> helper.</p>

<p>The Windows job logs also had dozens of blank lines. Some were CRLF from Windows stdout, including the odd <code class="language-plaintext highlighter-rouge">\r\r\n</code>. The remainder were from robocopy, which now logs everything to a file except for failures.</p>

<h2>Smaller fixes</h2>

<ul>
  <li>Arch: openssl 4.1.0 broke fresh base builds. The base had been correctly rebuilt from scratch, but the builder stages ran <code class="language-plaintext highlighter-rouge">pacman -Sy</code> and then <code class="language-plaintext highlighter-rouge">-S</code>, which is a partial upgrade. They now use <code class="language-plaintext highlighter-rouge">-Syu</code>.</li>
  <li>Fedora 45: dnf5 keeps its repository files in <code class="language-plaintext highlighter-rouge">/usr/share/dnf5/repos.d</code>, so the <code class="language-plaintext highlighter-rouge">metadata_expire</code> edit matched nothing.</li>
  <li><code class="language-plaintext highlighter-rouge">day10 prune --temp</code> reclaims orphaned <code class="language-plaintext highlighter-rouge">temp-*</code> directories.</li>
</ul>

<h1>Windows FsDepends leak</h1>

<p>Last week’s leak, with thousands of orphaned FsDepends minifilter instances and tens of GB of kernel nonpaged pool, continues to be tracked.</p>

<p>The model appears to be that when a single instance isn’t released, all future occurrences queue behind it and aren’t released either. Neither concurrency nor uptime seems to predict it.</p>

<p>Searching online suggested that <code class="language-plaintext highlighter-rouge">EnablePerVolumeLazyWriter=0</code> may address this. I tried it on ReFS, and it prevents the volume from mounting at boot time. Testing is continuing on NTFS.</p>

<p>ltsc2025-1 and -2 on thyme have been retired. These are replaced by ltsc2025-5 and ltsc2025-6, which have much larger disks. thyme has been repurposed for FreeBSD.</p>

<h1>Other CI work</h1>

<h2>OxCaml health check</h2>

<p>My fork of opam-health-check ignores <code class="language-plaintext highlighter-rouge">extra-repositories:</code> for <code class="language-plaintext highlighter-rouge">day10</code> builds, so instead of plumbing it through three layers, I wrote the oxcaml check as a <a href="https://github.com/mtelvers/ferry">mtelvers/ferry</a> pipeline on doris: the oxcaml overlay in front of opam-repository, 1,972 package versions against 9 compilers, 17,748 combinations in all. The results are at <a href="https://oxcaml.mint.caelum.ci.dev/">oxcaml.mint.caelum.ci.dev</a>.</p>

<h2>opam and OCaml versions</h2>

<p>ocaml-ci (<a href="https://github.com/ocurrent/ocaml-ci/pull/1083">#1083</a>) and opam-repo-ci (<a href="https://github.com/ocurrent/opam-repo-ci/pull/494">#494</a>) now take their opam versions from <code class="language-plaintext highlighter-rouge">Dockerfile_opam.Opam_version</code>. ocaml-version has OCaml 4.14.5 (<a href="https://github.com/ocurrent/ocaml-version/pull/95">#95</a>), and ocaml-dockerfile 8.4.8 adds openSUSE Leap 16.1 (<a href="https://github.com/ocurrent/ocaml-dockerfile/pull/279">#279</a>).</p>

<h2>macOS</h2>

<p>The Apple Silicon obuilder workers moved to OCaml 5.5.2. Intel macOS has also left opam-repo-ci (<a href="https://github.com/ocurrent/opam-repo-ci/pull/495">#495</a>), following OCaml-CI last week.</p>

<h2>jupiter2</h2>

<p>A Milk-V Jupiter 2, with a SpacemiT K3 implementing RVA23, ran 362 jobs as a RISC-V worker before it overheated: the NVMe reached 95C. Ubuntu’s 7.3 kernel has no driver for its fan controller, and the vendor 6.18 kernel hung. It is powered off.</p>

<h1>Cambridge machines</h1>

<h2>CephFS: pins, strays and a crash</h2>

<p>The shared filesystem was slow for several days due to three reasons.</p>

<p>On Monday, a single metadata server was doing all the work. Our first step was to add more MDS servers and enable distributed pins for <code class="language-plaintext highlighter-rouge">/maps</code> and <code class="language-plaintext highlighter-rouge">/papers</code>. The resulting migration storm triggered heartbeat failovers, but did eventually converge and appeared to make virtually no difference to the performance.</p>

<p>On Wednesday, Anil’s copy of <code class="language-plaintext highlighter-rouge">/papers</code> to comanche was crawling. A fresh look showed most of rank 0’s work was now requests forwarded between ranks. The load came from a 9-way parallel indexer running over <code class="language-plaintext highlighter-rouge">/maps</code>, at 166k requests/s, which the distributed pins had spread over the same ranks as <code class="language-plaintext highlighter-rouge">/papers</code>. We went back to what we had started with: <code class="language-plaintext highlighter-rouge">/papers</code> on rank 0, <code class="language-plaintext highlighter-rouge">/maps</code> on rank 1, everything else on 2 and 3.</p>

<p>On Thursday, the real problem emerged: 24.7 million strays, hard links whose primary name had been deleted, were being reintegrated at about 10 per second. Behind each request, the cache worked hard to keep the active set in memory. Prometheus showed it had been going on for at least a week, and rank 0 already held <a href="https://www.tunbury.org/2026/11/09/week-45/#cephfs-one-mds-doing-all-the-work">29 million strays</a> in week 45. <code class="language-plaintext highlighter-rouge">mds_dir_prefetch false</code> took rank 0 from 52 to about 3,400 requests/s, and the strays drained from 24.6M at 07:50 to 587k by 21:11. With this set, the MDS used more RAM, which exceeded the high water mark and I feared it would continue to grow without bound, but it levelled off at double the configured setting.</p>

<h2>Ceph housekeeping</h2>

<p>The Ceph daemons restarting early on Friday turned out to be an unattended upgrade of <code class="language-plaintext highlighter-rouge">libc6</code>, which restarted every Ceph daemon on nine hosts.</p>

<p>I decided to be proactive and update all 20 Ceph hosts to kernel version 6.8.0-149, to address CVE-2026-98432. I used an Ansible playbook to update and reboot each host in turn, ensuring that the cluster was stable before moving on.</p>

<p>Each client machine now has a single key, rather than a key per mount. This makes sense, as everything mounted on a machine is visible to all users, regardless of which key was used to mount it. POSIX permissions block access. Users still have keys in the cases where I have no access to the machine.</p>

<p>After a mammoth effort, the UID renumbering on daintree, kinabalu and sherwood is complete. All users across the machines now have unique UIDs.</p>

<p>I’ve moved 55 unclaimed items, totalling about 27 TiB, from the top level of <code class="language-plaintext highlighter-rouge">/maps</code> to <code class="language-plaintext highlighter-rouge">/maps/_unclaimed</code> for their owners to claim.</p>

<p>A short mains outage on Friday morning took down daintree, kinabalu and marpe. I took the opportunity to install the HWE 7.0 kernel to address the CephFS issue reported in <a href="https://www.tunbury.org/2026/10/26/week-43/#files-that-read-as-zeros">week 43</a>.</p>

<h2>monteverde</h2>

<p>The failing PS1010 was evacuated with <code class="language-plaintext highlighter-rouge">zpool remove</code>, copying 1.29 TB in five minutes. Dell’s replacement is another PS1010 with the same 1.1.0 firmware. It ran 764 GiB of raw I/O without an error, but as a ZFS pool it logged 313 errors in eight minutes: 18 rejections in 1.07 million SGL-mapped commands and none in 331,000 PRP-mapped commands.</p>

<h1>Tessera</h1>

<h2>Greenland</h2>

<p>The EPFL run is at 1,041 of 1,122 items: 2017 and 2019 are complete, and 2023 is at 335 of 412.</p>

<h2>tessera-inference</h2>

<p>The C++/CUDA and oneDNN encoder from the Endeavour post is published at <a href="https://github.com/mtelvers/tessera-inference">mtelvers/tessera-inference</a>. It matches PyTorch with a cosine similarity of 0.99997 on the L4, using the published v2 large checkpoint from Hugging Face.</p>

<h1>Other</h1>

<h2>32-bit OCaml</h2>

<p>My nightly rebase of the 32-bit backends onto trunk hit conflicts in <code class="language-plaintext highlighter-rouge">runtime/power.S</code> three days running. Once those were resolved, it failed for two more nights in the tests on remote workers: a stray <code class="language-plaintext highlighter-rouge">#endif</code> left over from the conflict resolution broke PPC32 and PPC64BE. This morning’s run, still going as I write, is the first with the fix.</p>
