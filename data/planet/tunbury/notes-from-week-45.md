---
title: Notes from week 45
description: day10 builds Windows packages again and agrees with GitHub Actions on
  all but a handful of explainable cells; OCaml 5 has been killed by Ctrl-Break since
  2022; opam 2.6 reached every CI; a page cache saved 0.64 seconds; and one CephFS
  metadata server was doing all the work.
url: https://www.tunbury.org/2026/11/09/week-45/
date: 2026-11-09T09:00:00-00:00
preview_image: https://www.tunbury.org/images/day10-vs-gha-windows.png
authors:
- Mark Elvers
source:
ignore:
keywords:
- ctrl-break
- day10
- dune-release
- gha
- layers
- lwt
- msys2
- ocaml-ci
- ocurrent
- windows
---

<p><code class="language-plaintext highlighter-rouge">day10</code> builds Windows packages again and agrees with GitHub Actions on all but a handful of explainable cells; OCaml 5 has been killed by Ctrl-Break since 2022; opam 2.6 reached every CI; a page cache saved 0.64 seconds; and one CephFS metadata server was doing all the work.</p>

<h1><code class="language-plaintext highlighter-rouge">day10</code></h1>

<h2>Windows is back</h2>

<p>The Windows backend hadn’t been run in months, and after the recent Linux work to improve teardown from cancelled jobs, it didn’t start at all.</p>

<p>The cleanup code used <code class="language-plaintext highlighter-rouge">Sys.signal</code> to catch SIGHUP and SIGPIPE, which raise an exception on Windows. <code class="language-plaintext highlighter-rouge">OpamStd.Sys.uname</code> is Unix-only (still true in opam 2.6.1), the colon in <code class="language-plaintext highlighter-rouge">c:\opam-repository</code> was parsed as the <code class="language-plaintext highlighter-rouge">path:rev</code> separator, the <code class="language-plaintext highlighter-rouge">hcn-namespace</code> helper needs <code class="language-plaintext highlighter-rouge">libffi-6.dll</code>, and <code class="language-plaintext highlighter-rouge">ctr</code> escapes quotes, so <code class="language-plaintext highlighter-rouge">set "PATH=..."</code> never ran.</p>

<p>Testing on Windows Server 2025, <code class="language-plaintext highlighter-rouge">day10 health-check uutf.1.0.4</code> was the first success, building the base and 14 layers. <code class="language-plaintext highlighter-rouge">day10-install</code> 1.4.0 is released with Windows and FreeBSD assets.</p>

<p>Looking at the first fixes, it was clear that the boundary between what was OS specific has become blurred. <code class="language-plaintext highlighter-rouge">main.ml</code> included things like <code class="language-plaintext highlighter-rouge">sudo rm</code>. The differentiator had been <code class="language-plaintext highlighter-rouge">S.CONTAINER</code> for <code class="language-plaintext highlighter-rouge">runc</code> vs <code class="language-plaintext highlighter-rouge">jails</code> vs HCS, but this was reworked into <code class="language-plaintext highlighter-rouge">S.PLATFORM</code>, which then added the OS specific functions. This took a couple of iterations trying some common functions in <code class="language-plaintext highlighter-rouge">posix.ml</code>, which I later discarded.</p>

<h2>A symlink a container can’t execute</h2>

<p><code class="language-plaintext highlighter-rouge">praxo-core</code> failed on 5.5.2. Since OCaml 5.4 (<a href="https://github.com/ocaml/ocaml/pull/13494">ocaml/ocaml#13494</a>), <code class="language-plaintext highlighter-rouge">flexlink.exe</code> in <code class="language-plaintext highlighter-rouge">opt/bin</code> is a relative symlink rather than a copy, and a Windows container cannot execute a relative symlink on a bind mount. <code class="language-plaintext highlighter-rouge">mklink</code> alone reproduces it, on NTFS and ReFS.</p>

<p>The first workaround was to build as a non-admin <code class="language-plaintext highlighter-rouge">opam</code> user, so OCaml’s configure falls back to <code class="language-plaintext highlighter-rouge">cp -pf</code>. That needed <code class="language-plaintext highlighter-rouge">CopyFileW</code> for layer copies, since Cygwin’s fallback symlinks depend on the SYSTEM attribute and a byte copy dropped it, which broke <code class="language-plaintext highlighter-rouge">awk</code> in <code class="language-plaintext highlighter-rouge">why3</code>’s configure. It worked, but it was a pile of workarounds.</p>

<p>Clearing attributes, an NTFS backing filesystem and enabling every <code class="language-plaintext highlighter-rouge">SymlinkEvaluation</code> option on the host made no difference, nor did a different Windows build on navajo. HCS ignores the lower layer when stacking sibling layers, so native container layers were out.</p>

<p>Instead, the entire cache is now mounted read-only, and the layers are assembled inside the container: <code class="language-plaintext highlighter-rouge">robocopy</code> moves 1.3 GB in 2.7 s, compared to 3.9 s for a host ReFS block clone. Results are copied out by archive bit. That deleted <code class="language-plaintext highlighter-rouge">copy_tree</code>, <code class="language-plaintext highlighter-rouge">hardlink_tree</code>, <code class="language-plaintext highlighter-rouge">CopyFileW</code> and the ctypes dependency (594602a), and builds run as ContainerAdministrator again, with <code class="language-plaintext highlighter-rouge">flexlink</code> a native symlink.</p>

<p>At the same time as the above layer changes, I had been adding MSYS2 as <code class="language-plaintext highlighter-rouge">--os-distribution msys2</code>, which reinforced the issues as working on a bind mount: pacman cannot replace its own binaries, <code class="language-plaintext highlighter-rouge">gpg-agent</code> held the container open, and an empty CA bundle was generated. A 20-job matrix of zarith, sqlite3, lwt, uutf and ppxlib on Cygwin and MSYS2 with 4.14.4 and 5.5.2 all passed.</p>

<p><code class="language-plaintext highlighter-rouge">windows.ml</code> now differentiates between <code class="language-plaintext highlighter-rouge">cygwin.ml</code> and <code class="language-plaintext highlighter-rouge">msys2.ml</code> as <code class="language-plaintext highlighter-rouge">S.UNIX_LAYER</code>.</p>

<h2>navajo becomes the <code class="language-plaintext highlighter-rouge">day10</code> Windows worker</h2>

<p>navajo was reinstalled with a single Windows guest, 200 GB of RAM, and 16 jobs, serving the <code class="language-plaintext highlighter-rouge">day10-windows-x86_64</code> pool. Running the worker as a Windows service needed patches: there is no console, so <code class="language-plaintext highlighter-rouge">day10</code> died silently; Cygwin’s DACLs blocked deletes; and the SIGTERM used to cancel a job crashed the service. Lwt on Windows resolves <code class="language-plaintext highlighter-rouge">FD_copy stdout</code> in the parent, so <code class="language-plaintext highlighter-rouge">day10</code>’s <code class="language-plaintext highlighter-rouge">[NOTE]</code> and <code class="language-plaintext highlighter-rouge">[ERROR]</code> lines went to the worker’s log rather than the job log.</p>

<h2>Smaller fixes</h2>

<p>By design, <code class="language-plaintext highlighter-rouge">ctr</code> exits with “All pipe instances are busy” when containerd is loaded. <code class="language-plaintext highlighter-rouge">day10</code> now retries only that error, up to 60 times. The old code retried only <code class="language-plaintext highlighter-rouge">snapshot prepare</code> ten times on any error and then parsed an empty <code class="language-plaintext highlighter-rouge">mounts.json</code>. <code class="language-plaintext highlighter-rouge">day10</code> also kept building on a failed base while the job reported success. It now stops and keeps no base, on every platform.</p>

<h2>FreeBSD</h2>

<p>With Windows now working again, and the changes currently in mind, I updated the FreeBSD code to address the same changes there. Additionally, <code class="language-plaintext highlighter-rouge">opam</code> reports the family as <code class="language-plaintext highlighter-rouge">bsd</code>, so 128 filters in the opam-repository were evaluated as false. The arch was <code class="language-plaintext highlighter-rouge">amd64</code>, where opam says <code class="language-plaintext highlighter-rouge">x86_64</code>.</p>

<p><code class="language-plaintext highlighter-rouge">bsdinstall script</code> was hanging on 15.1 (replaced with fetching <code class="language-plaintext highlighter-rouge">base.txz</code>, checking it against the MANIFEST and untarring). The base installation is now step-by-step and follows <code class="language-plaintext highlighter-rouge">--os-version</code>, so 1501000 becomes 15.1-RELEASE. 14.3 has gone from the mirror; 14.5 built to 14.5-RELEASE-p3.</p>

<h2>Trusting the solution for depexts</h2>

<p>Last week’s <code class="language-plaintext highlighter-rouge">prune --depexts</code> needs to know which layers installed system packages. The Windows implementation compared a layer against whichever base was present now, so a rebase would have pruned everything. The second attempt recorded a flag via a probe of the tree, with probe-on-first-sight as the migration path for old layers. The third attempt added a field to <code class="language-plaintext highlighter-rouge">layer.json</code> derived from the solution’s depexts. The existing layers were updated with a one-off script.</p>

<p>The migration updated about 460,000 layer records in under two minutes, 296,000 of them on doris. The first automatic base replacement ran on 5 November: doris removed 15 bases and pruned 820 depext layers, okypous 12 and 426, orithia 7 and 227. Doris had remade 12 bases within the hour.</p>

<h2>Checking <code class="language-plaintext highlighter-rouge">day10</code> against GitHub Actions</h2>

<p>opam-repository runs Windows tests in GitHub Actions on Cygwin and MSYS2. I took 53 open PRs at fixed SHAs, 572 cells across both environments and OCaml 4.14.4 and 5.5, and ran them on navajo. 30 PRs had a GHA result to compare with.</p>

<p><img src="https://www.tunbury.org/images/day10-vs-gha-windows.png" alt="day10 vs GHA"></p>

<p><em>OCaml 5.5 cells where both systems produced a result</em></p>

<p>Cygwin matched on 76 of 80 and MSYS2 on 73 of 79. The four compiler packages in #31117 differ in design: <code class="language-plaintext highlighter-rouge">day10</code> builds them with <code class="language-plaintext highlighter-rouge">--update-invariant</code>, whereas GHA’s switch is locked to 5.5.2 and skips them.</p>

<p>The other two, <code class="language-plaintext highlighter-rouge">opam-audit</code> and <code class="language-plaintext highlighter-rouge">dune-release</code> on MSYS2, I initially took for a <code class="language-plaintext highlighter-rouge">day10</code> solver bug, but they are opam-repository metadata issues. <code class="language-plaintext highlighter-rouge">opam-core</code>’s mingw branch needs both the i686 and x86_64 toolchains, and on MSYS2 these pull in <code class="language-plaintext highlighter-rouge">msys2-mingw32</code> and <code class="language-plaintext highlighter-rouge">msys2-mingw64</code>, which share a conflict class. The only solution is the MSVC branch. GHA passes because the runner has Visual Studio installed, and it ends up with a mingw compiler marked as <code class="language-plaintext highlighter-rouge">host-system-msvc</code>. GHA succeeds only by not building what it was asked to build.</p>

<p>On three new PRs, <code class="language-plaintext highlighter-rouge">day10</code> was 2-30 times faster than GHA, but mostly because its cache was warm. GHA spends 95 to 773 seconds on setup before testing anything.</p>

<h2>OCaml’s Ctrl-Break</h2>

<p>While working on job cancellation, I found that OCaml 5 processes are killed by Ctrl-Break even with a SIGINT handler installed. <a href="https://github.com/ocaml/ocaml/pull/10898">ocaml/ocaml#10898</a> dropped the <code class="language-plaintext highlighter-rouge">#define</code> which routed <code class="language-plaintext highlighter-rouge">signal()</code> to <code class="language-plaintext highlighter-rouge">caml_win32_signal</code>.</p>

<table>
  <thead>
    <tr>
      <th>&nbsp;</th>
      <th>Ctrl-C</th>
      <th>Ctrl-Break</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>4.14.2</td>
      <td>handled</td>
      <td>handled</td>
    </tr>
    <tr>
      <td>5.3.0</td>
      <td>handled</td>
      <td>killed</td>
    </tr>
    <tr>
      <td>trunk</td>
      <td>handled</td>
      <td>killed</td>
    </tr>
    <tr>
      <td>trunk + PR</td>
      <td>handled</td>
      <td>handled</td>
    </tr>
  </tbody>
</table>

<p><a href="https://github.com/ocaml/ocaml/pull/15267">ocaml/ocaml#15267</a> restores it with a test in <code class="language-plaintext highlighter-rouge">tests/lib-sys</code>. MSVC builds failed on the test’s use of <code class="language-plaintext highlighter-rouge">ShowWindow</code> from user32, which is now looked up at runtime. nojb merged it on Saturday, and it will be in 5.6; until then, <code class="language-plaintext highlighter-rouge">day10</code> needs a small C stub, built with dune’s <code class="language-plaintext highlighter-rouge">foreign_stubs</code>, to hook this signal.</p>

<h2>basil joins the obuilder pool</h2>

<p>Basil was reinstalled with two 7.3 TB volumes, each with an 830 GiB writeback dm-cache on SSD, running ltsc2025-5 and -6 with 20 vCPUs each, one per NUMA node. This takes the obuilder Windows pool from 16 slots to 24.</p>

<p>I based the new configuration on metrics from the 444 Windows jobs over the last two weeks. Build time follows the OBuilder cache hit rate: ltsc2025-4 hit 77% with a 10-minute median, while the others hit 46-48% with 40-96 minute medians. Four concurrent builds are no slower than one, and the median queue wait was six hours at 5.9% utilisation, because work arrives in bursts. Fewer workers with large disks are better; whether those disks are spinning disk or SSD made little difference.</p>

<p>The windows_worker changes from <code class="language-plaintext highlighter-rouge">run.sh</code> to systemd units, so VMs survive a host reboot and stop via the ACPI power button.</p>

<h2>The FsDepends leak</h2>

<p>ltsc2025-1 had an impressive run of 54 days but ended up unable to start a new container with <code class="language-plaintext highlighter-rouge">CreateComputeSystem ... Insufficient system resources</code>. It had 13,320 <code class="language-plaintext highlighter-rouge">FsDepends</code> minifilter instances, 13,316 of them detached, plus 4,861 <code class="language-plaintext highlighter-rouge">bindflt</code> instances, and 10.3 GB of kernel nonpaged pool. A reboot brought the pool back to 129 MB.</p>

<p>A probe now records the instance counts every ten minutes. ltsc2025-2 sat at 5-7 for 30 hours and then started climbing. Across the machines, it starts after 88-262 builds or 2.1-3.2 days, and I can’t yet separate the two. The mechanism is unknown.</p>

<h1>Other CI work</h1>

<h2>opam 2.6</h2>

<p>ocaml-ci’s first attempt passed <code class="language-plaintext highlighter-rouge">--cli=2.6</code>, which opam 2.6.0 and 2.6.1 reject even though <code class="language-plaintext highlighter-rouge">--help</code> lists it as the default: <code class="language-plaintext highlighter-rouge">supported_versions</code> was never extended. That’s <a href="https://github.com/ocaml/opam/pull/7229">ocaml/opam#7229</a>, and ocaml-ci now omits <code class="language-plaintext highlighter-rouge">--cli</code> for 2.6.</p>

<p>On macOS, the <code class="language-plaintext highlighter-rouge">opam-vars</code> jobs then failed because <code class="language-plaintext highlighter-rouge">opam-2.6</code> didn’t exist, blocking all macOS dispatch, so every worker’s base images were rebuilt. Apple Silicon took 30-97 minutes per worker; Intel took two to four hours.</p>

<p>FreeBSD (<a href="https://github.com/ocurrent/freebsd-infra/pull/29">ocurrent/freebsd-infra#29</a>) and OpenBSD (<a href="https://github.com/ocurrent/obuilder/pull/223">ocurrent/obuilder#223</a>) have opam 2.6.1 and OCaml 5.5.2, and opam-repo-ci tests opam 2.6 (<a href="https://github.com/ocurrent/opam-repo-ci/pull/491">#491</a>). After the opam-repo-ci redeploy, the new urgent 2.6 jobs sat behind about 5,000 urgent dune 3.25 alpha revdeps, so commit pages showed “Testing in progress” with nothing running.</p>

<h2>macOS ZFS</h2>

<p>There was a recurrence of the ZFS corruption on 3 out of the 4 macOS workers, with only m1-worker-02 surviving. Somewhat embarrassingly, I’d been updating macFUSE in the belief that it was the only version at play, but actually the OpenZFS package is completely separate and needs to be updated separately, and its version is not reported in the System Preferences dialogue. Upgrading from 2.2.2 to 2.4.1p1 seems to have fixed the ZFS corruption. Interestingly, it’s an Apple Silicon problem, as the Intel machines aren’t affected.</p>

<h2>One list of opam versions</h2>

<p>Each opam release meant edits in ocaml-dockerfile, docker-base-images, ocaml-ci and opam-repo-ci. <a href="https://github.com/ocurrent/ocaml-dockerfile/pull/277">ocurrent/ocaml-dockerfile#277</a> makes <code class="language-plaintext highlighter-rouge">Dockerfile_opam.Opam_version</code> a closed variant, and the Docker base image builder and both CIs take it from there. Released as 8.4.7 alongside Fedora 45 (<a href="https://github.com/ocurrent/ocaml-dockerfile/pull/278">#278</a>). openSUSE Leap 16.1 (<a href="https://github.com/ocurrent/ocaml-dockerfile/pull/279">#279</a>) and the docker-base-images update (<a href="https://github.com/ocurrent/docker-base-images/pull/363">#363</a>) are open.</p>

<h2>Intel macOS leaves OCaml-CI</h2>

<p>Homebrew 7 no longer publishes Intel bottles, so every depext builds from source, and upstream OCaml has moved Intel macOS to Tier 2. <a href="https://github.com/ocurrent/ocaml-ci/pull/1079">ocurrent/ocaml-ci#1079</a> drops it; it was merged and live on Tuesday. opam-repo-ci still uses the Intel workers, which now sit at 4-9% occupancy.</p>

<h2>A cache that saved 0.64 seconds</h2>

<p>The scrapers hitting opam-repo-ci led me to implement the proof-of-work challenge page, but I never merged the commit because I wasn’t really sure it was the right solution. Shon mentioned it too, as he ended up needing headless Chromium in order to solve the JS challenge. The idea which followed was that the commit summary page is the expensive one: up to 333,482 variants and over 60 MB of HTML, so could that be cached? I added an in-process cache with single-flight, short TTLs for busy commits and validation on each hit for settled ones (<a href="https://github.com/ocurrent/opam-repo-ci/pull/492">#492</a>).</p>

<p>After 26 hours with the proof-of-work challenge still on, there had been 97 commit views and 1 real cache hit. So I removed the PoW challenge. A crawl started within a minute, peaking at 37 requests/s from 511 distinct IPs in 30 seconds, about one IP per request, which makes per-IP rate limiting useless. It was walking the menhir release commit with 21,214 variants, consuming about 2% of an engine CPU. As I had said before, you can’t stop the scrapers; you just need to make it cheap.</p>

<p>After 30 hours and 39,500 requests, the cache had served 6 of 161 summary pages and saved 0.64 s. The real fix was <a href="https://github.com/ocurrent/opam-repo-ci/pull/482">#482</a> in August, which changed a <code class="language-plaintext highlighter-rouge">LIKE</code> to a <code class="language-plaintext highlighter-rouge">GLOB</code> so that commit lookups use the primary key, taking them from 968 ms to about 1 ms.</p>

<p>However, I was still slightly annoyed that the scrapers were wasting resources pulling these logs. Spotting a pattern in the URLs and realising that Caddy can group similar URLs together with a rate limit, Caddy now limits requests for a specific commit to 5 per second. Additionally, unknown commits return 404 rather than 500 (<a href="https://github.com/ocurrent/opam-repo-ci/pull/493">#493</a>), as about 6% of variant requests were for commits that aren’t in the index. #492 and the proof-of-work PRs are closed.</p>

<h1>Tessera</h1>

<h2>Greenland, continued</h2>

<p>The EPFL run is 536 of 1,122 items through. 2017 finished on 4 November with 294 of 298 shards. 2019 is at 242 of 412, and 2023 hasn’t started. At 50-100 uploads a day, there’s about another week to go.</p>

<h1>Cambridge machines</h1>

<h2>CVE follow-up</h2>

<p>After 36 hours, the drop counters were zero on all 88 hosts with the filter. Red Hat’s rating has since moved to Critical 9.8, and it now says that disabling MPTCP alone is not enough; the nftables rule is the part that matters. Ubuntu’s fixed kernels reached <code class="language-plaintext highlighter-rouge">-updates</code> on 5-6 November, but no host has installed them, as unattended-upgrades only reads <code class="language-plaintext highlighter-rouge">-security</code>. The rolling upgrade, reboot, and filter removal are planned but not yet done; the RISC-V boxes on Scaleway’s 5.10 and 20.04 hosts will keep the filter.</p>

<h2>CephFS: one MDS doing all the work</h2>

<p>sherwood hung on Wednesday, thrashing without an OOM kill, and was reset via IPMI. When it came back, I applied the HWE 7.0 kernel. The “slow shared filesystem” was a single CPU-bound MDS: rank 0 had 42 GB RSS against a 32 GB cache limit and 29 million strays, while rank 1 sat idle. The balancer is off by default in Squid. Pinning the maps subvolume to rank 1 took about two hours to migrate, during which it got worse, and then 0.04 s on all three hosts.</p>

<h2>winter and okavango</h2>

<p>winter went from 22.04 to 26.04 in two hops. The 6.8 reboot lost the network because <code class="language-plaintext highlighter-rouge">eno1</code> became <code class="language-plaintext highlighter-rouge">eno1np0</code>; it was fixed via the serial console with a netplan configuration matched to the MAC address. 15 of 21 accounts, unused for a year, are locked.</p>

<p>okavango went from 24.04 to 26.04 to 26.10, and is now on 7.3.0-10 with all three pools online.</p>

<h2>monteverde</h2>

<p><code class="language-plaintext highlighter-rouge">nvme.sgl_threshold=0</code> isn’t the whole answer. The drive’s error log went from 24,818 to 24,896 in 20 hours, about one rejection a minute. The kernel retries silently, and the same command then succeeds, which points to the firmware. Dell’s two firmware packages contain the same 1.1.0 image, and the newer releases are for U.2 only, so I’ve requested a proactive replacement for the surviving drive.</p>

<h1>Other</h1>

<h2>conservation-copilot</h2>

<p>Ahead of a 26-person workshop, I ran a load test with six concurrent queries: 57 queries in three bursts with no failures. The R timeout fired three times, and each query recovered. Peak memory usage was 7.3 GB out of 7.9 GB.</p>

<h2>ocluster-top</h2>

<p><a href="https://github.com/mtelvers/ocluster-top">mtelvers/ocluster-top</a> is a small <code class="language-plaintext highlighter-rouge">top</code>-style terminal UI for the OCluster scheduler. It uses the same admin API as <code class="language-plaintext highlighter-rouge">ocluster-admin</code> and shows the pools, busiest first, with the selected pool’s workers and backlog below. Workers can be paused, drained, updated and forgotten from there.</p>
