---
title: Notes from week 44
description: "Greenland is being processed into the Zarr store on a single L4; day10
  stopped refreshing its base images and started carrying every package it might need;
  a five-year-old lwt workaround turned out to be the bug; monteverde\u2019s drive
  was failing after all; and a kernel CVE was mitigated across 90 hosts in an evening."
url: https://www.tunbury.org/2026/11/02/week-44/
date: 2026-11-02T09:00:00-00:00
preview_image: https://www.tunbury.org/images/greenland-shards.png
authors:
- Mark Elvers
source:
ignore:
keywords:
- backplane
- daintree
- day10
- dclimate
- hopper
- lwt
- monteverde
- ocaml-ci
- odoc
- unlink
---

<p>Greenland is being processed into the Zarr store on a single L4; <code class="language-plaintext highlighter-rouge">day10</code> stopped refreshing its base images and started carrying every package it might need; a five-year-old lwt workaround turned out to be the bug; monteverde’s drive was failing after all; and a kernel CVE was mitigated across 90 hosts in an evening.</p>

<h1><code class="language-plaintext highlighter-rouge">day10</code></h1>

<h2>Base refresh breaks the invariant</h2>

<p><code class="language-plaintext highlighter-rouge">day10</code> keeps a base image per platform and builds a layer per opam package on top of it. The whole design rests on every layer having been installed from the same package index as its siblings.</p>

<p>However, we need to keep the distributions, or at the very least the mirror list, up to date. To do this, ocluster-worker periodically ran <code class="language-plaintext highlighter-rouge">day10 refresh-base</code> which effectively runs <code class="language-plaintext highlighter-rouge">apt update</code> or equivalent for each distribution in each base image.</p>

<p>PR #31032, adding <code class="language-plaintext highlighter-rouge">imguiml</code>, failed 88 of 307 jobs and showed both consequences. On Debian and Ubuntu, 64 jobs died with apt reporting “Unmet dependencies”: the <code class="language-plaintext highlighter-rouge">conf-freetype</code> layer had pulled <code class="language-plaintext highlighter-rouge">libbrotli1 1.0.9-2+deb12u1</code>, sibling layers still carried the base’s <code class="language-plaintext highlighter-rouge">+b6</code> stanza, and the merge of dpkg’s status files kept whichever came first. On Arch, four jobs died with pacman reporting a duplicate database entry: a layer’s whiteout over the base’s <code class="language-plaintext highlighter-rouge">brotli-1.2.0-1</code> directory had been dropped by the merge, because the base is mounted beneath the merge as a lower layer of its own and the merge only looked at itself.</p>

<p>Those two are fixed in <code class="language-plaintext highlighter-rouge">0a54c2b</code>, which keeps the highest version per package in the dpkg union using opam’s Debian-style comparison with the epoch split off first, and <code class="language-plaintext highlighter-rouge">edaf118</code>, which keeps a marker unless a later layer really provides the path.</p>

<h2>Is <code class="language-plaintext highlighter-rouge">refresh-base</code> conceptually flawed?</h2>

<p>obuilder uses a weekly refresh, which isn’t perfect, as there are days where mirrors or packages are unreachable/unobtainable. However, this does mean that the images themselves are consistent, whereas with <code class="language-plaintext highlighter-rouge">day10</code>, I think that isn’t always true when we start overlaying packages in unintended ways. With Ubuntu and Debian, I think it could work, but distributions with continuous updates, such as Arch, will continue to cause problems.</p>

<h2><code class="language-plaintext highlighter-rouge">prune --base --days N</code> replaces <code class="language-plaintext highlighter-rouge">refresh-base</code></h2>

<p><code class="language-plaintext highlighter-rouge">day10</code> now wipes the base image and all layers which have a depext every 7 days and rebuilds them. Consistency over the 7 days is guaranteed by prefetching all depexts at the point the base image is built, so any opam calls to install depext find the package already cached.</p>

<p>ocluster-worker runs the command on a schedule. Previously, the idle window actually detected the end of the idle window: the worker sat blocked on a Cap’n Proto call until a job arrived, and then the maintenance hook ran exactly when there was work to do. Now a thread wakes once a period, runs the prune if nothing is building, and otherwise logs that it will try again in an hour.</p>

<h2><code class="language-plaintext highlighter-rouge">day10 cp</code></h2>

<p>The copy step was originally a perfect <code class="language-plaintext highlighter-rouge">sudo cp</code> applied oldest to newest, but unfortunately, this isn’t so perfect when whiteout character markers are left. This is largely caused by the original <code class="language-plaintext highlighter-rouge">refresh-base</code> command, but the copy step is growing in complexity with an initial <code class="language-plaintext highlighter-rouge">sudo find</code> followed by a <code class="language-plaintext highlighter-rouge">sudo cp</code> with <code class="language-plaintext highlighter-rouge">sudo rm -rf </code> applied to marks. Some of the later changes also required <code class="language-plaintext highlighter-rouge">day10</code> to run as root, which was a big step back. <code class="language-plaintext highlighter-rouge">sudo cp</code> was one thing, but requiring <code class="language-plaintext highlighter-rouge">sudo day10</code> seemed excessive and broke my own <code class="language-plaintext highlighter-rouge">day10 build .</code> use!</p>

<p>Effectively, the updates have been recreating the overlayfs semantics in <code class="language-plaintext highlighter-rouge">day10</code>. Interestingly, the overlayfs limit of exactly one memory page for the <code class="language-plaintext highlighter-rouge">mount</code> options has been removed from the Linux kernel, so I can now stack unlimited layers rather than creating the hard-linked tree. I decided not to do that as the RISC-V machines still run 5.10 kernel (in some cases).</p>

<p><code class="language-plaintext highlighter-rouge">day10</code> now provides its own version of <code class="language-plaintext highlighter-rouge">cp</code> via <code class="language-plaintext highlighter-rouge">day10 cp</code>, which implements the exact semantics it needs. A trivial benchmark showed that <code class="language-plaintext highlighter-rouge">day10 exec -- tessera-mosaic --help</code> took 2.37 s after the change, down from 2.46 s before, so marginally faster and certainly not worse.</p>

<h2><code class="language-plaintext highlighter-rouge">fetcher</code></h2>

<p>The extra downloading of distributions, coupled with the HTTP GET storms the CI workers generate when the test matrix fans out to N distros and two compiler versions, would benefit from a cache.</p>

<p>I did a quick review of proxy caches which were available looking for these three specific properties: files live at <code class="language-plaintext highlighter-rouge">&lt;root&gt;/&lt;host&gt;/&lt;path&gt;</code>, unhashed, so anything can be found and deleted with <code class="language-plaintext highlighter-rouge">ls</code> and <code class="language-plaintext highlighter-rouge">rm</code>; one upstream fetch per URL however many clients ask at once, the rest waiting on the first; and nothing is ever refreshed or expired until an operator deletes it.</p>

<p>Clients are not proxied, because nearly every mirror is <code class="language-plaintext highlighter-rouge">https</code> and an <code class="language-plaintext highlighter-rouge">https_proxy</code> setting makes them tunnel TLS straight through, so the cache sees nothing. Instead, the URL is rewritten: <code class="language-plaintext highlighter-rouge">https://deb.debian.org/debian/...</code> becomes <code class="language-plaintext highlighter-rouge">http://cache:8080/https/deb.debian.org/debian/...</code>, and the cache terminates TLS to the origin itself.</p>

<p><code class="language-plaintext highlighter-rouge">opam</code> can be configured to use it and similar tricks are available in the package managers.</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>opam option download-command<span class="o">=</span><span class="s1">'["fetcher" "download" "--cache" "10.0.0.1:8080" "%{url}%" "-o" "%{out}%"]'</span>
</code></pre></div></div>

<p>It is on GitHub at <a href="https://github.com/mtelvers/fetcher">mtelvers/fetcher</a>. It is not deployed yet.</p>

<h1>Other CI work</h1>

<h2>A CVE across everything</h2>

<p>CVE-2026-98432 is a use-after-free in the IPv4 TCP handshake path. <code class="language-plaintext highlighter-rouge">tcp_v4_syn_recv_sock</code> hands the request socket’s IP options to the child socket without copying them, and a retransmitted SYN arriving on another CPU can read them after they are freed. It is reachable by any unauthenticated remote peer that can send a SYN carrying IPv4 options, it affects every kernel since 4.4, and the kernel CNA rated it 9.8. IPv6 is not affected.</p>

<p>Of the 121 machines surveyed, every one but monteverde was running a vulnerable kernel, and for almost all of them no fixed kernel had been released. Debian had shipped 6.12.113, so dopey, the only Debian host, was properly patched and rebooted that evening. monteverde happened to be on Ubuntu 26.10, whose 7.3.0-10 carries the fix, and was never vulnerable. For everything else, Ubuntu’s 6.8.0-149 for 24.04, 5.15.0-203 for 22.04, and 7.0.0-43 for 26.04 were all still sitting in <code class="language-plaintext highlighter-rouge">-proposed</code>.</p>

<p>The interim mitigation is an nftables table on the prerouting hook, so Docker-forwarded traffic is covered too, that counts and drops inbound IPv4 TCP carrying IP options, plus <code class="language-plaintext highlighter-rouge">net.mptcp.enabled = 0</code>.</p>

<p>Just under 100 machines were mitigated this way, and will stay that way until the fixed kernels are promoted.</p>

<h2>A symlink, a <code class="language-plaintext highlighter-rouge">stat</code>, and a fix from 2021</h2>

<p>Marek asked for symlinks on the Windows runners as odoc’s tests had been failing with a syntax error in <code class="language-plaintext highlighter-rouge">cases/ocamlary.mli</code>. git had checked the symlink out as a text file containing its target path. Git for Windows is installed with <code class="language-plaintext highlighter-rouge">/VERYSILENT</code>, which takes the installer’s defaults, and the default is <code class="language-plaintext highlighter-rouge">core.symlinks=false</code>. The catch is that git bakes that into every repository’s <code class="language-plaintext highlighter-rouge">.git/config</code> at clone time, so setting it system-wide fixed nothing for the 1,170 repositories already cached across the four workers. Unset in all of them, live, without pausing anything.</p>

<p>odoc’s checkout now had a real symlink, and the next run failed differently: <code class="language-plaintext highlighter-rouge">Unix_error(ENOENT, "stat", "...\\test\\generators\\cases\\ocamlary.mli")</code>, <code class="language-plaintext highlighter-rouge">Internal error</code>, the worker crashing while deleting the build context. <code class="language-plaintext highlighter-rouge">Lwt_io.delete_recursively</code> walks with <code class="language-plaintext highlighter-rouge">lstat</code>, and on Windows, when it finds a symlink, it then calls <code class="language-plaintext highlighter-rouge">stat</code> on it to decide between <code class="language-plaintext highlighter-rouge">rmdir</code> and <code class="language-plaintext highlighter-rouge">unlink</code>. <code class="language-plaintext highlighter-rouge">stat</code> follows the link. If the target has already been deleted, which it has whenever a link points at another file inside the tree and readdir visits the target first, that raises ENOENT and nothing catches it. odoc has exactly one symlink, from <code class="language-plaintext highlighter-rouge">test</code> into <code class="language-plaintext highlighter-rouge">src</code>, and <code class="language-plaintext highlighter-rouge">src</code> is traversed first, so every build of it failed, deterministically.</p>

<p>The first fix caught ENOENT and tried <code class="language-plaintext highlighter-rouge">unlink</code> then <code class="language-plaintext highlighter-rouge">rmdir</code>. However, a quick test on a Windows worker showed the <code class="language-plaintext highlighter-rouge">rmdir</code> leg never fired, as <code class="language-plaintext highlighter-rouge">unlink</code> always worked. That is weird because the entire Windows specialisation in that function was based on the assumption that <code class="language-plaintext highlighter-rouge">rmdir</code> was needed to remove Windows directory links and that <code class="language-plaintext highlighter-rouge">unlink</code> was needed for file links. Perhaps it was just that broken links could be removed with either? Testing on the worker showed this was not the case: <code class="language-plaintext highlighter-rouge">unlink</code> always worked. Of course, on Windows, there is a risk in assuming that the one machine you are using is representative across all Windows machines, so I was reluctant to make a wholesale simplification.</p>

<p>Searching the git history for ocaml/ocaml found <code class="language-plaintext highlighter-rouge">d9cfda1e1a</code>: Antonin Décimo, 16 September 2021 at 16:54, “making <code class="language-plaintext highlighter-rouge">Unix.unlink</code> remove directory symlinks on Windows”, which was released in 4.14.0, so the behaviour did change. Interestingly, earlier the same day Antonin modified the function in lwt.</p>

<p>As lwt requires 4.14, the entire special case is redundant on every runtime lwt supports, making the function identical on all platforms with one <code class="language-plaintext highlighter-rouge">lstat</code> per entry.</p>

<p>Raphaël’s review asked how we know the test reaches the bug, given it depends on readdir order, which was a fair criticism of my test. Based upon what I’d seen, NTFS always returned a sorted file list regardless of the creation order. However, Microsoft does not guarantee that, it just happens to be true for NTFS. If the underlying file system was FAT then it wouldn’t be. I rewrote the test to have two sibling directories cross-linked at each other, so that whichever is removed first leaves the other’s link dangling. <a href="https://github.com/ocsigen/lwt/pull/1132">ocsigen/lwt#1132</a>.</p>

<p><code class="language-plaintext highlighter-rouge">core.autocrlf=true</code> is the same installer default and was fixed at the same time. It had been putting a carriage return at the end of <code class="language-plaintext highlighter-rouge">set -e</code> in every shell script in every checkout.</p>

<h2>macOS, again</h2>

<p>On Tuesday morning, two more of the rebuilt arm64 workers had corrupted overnight: m1-worker-04 with its first <code class="language-plaintext highlighter-rouge">adding existent segment to range tree</code> panic and m1-worker-03 with a data abort inside the ZFS kext. That made three of four within five days of the 21 October rebuild.</p>

<p>The Intel side is quieter. The <code class="language-plaintext highlighter-rouge">/private/tmp</code> sweep from <a href="https://github.com/ocurrent/macos-infra/pull/62">#62</a> was sized against 16 GB a day; under a large batch the real rate was a 3.8 GB Homebrew source tree an hour, and i7-worker-04 was back down to 32 GB free. <a href="https://github.com/ocurrent/macos-infra/pull/63">#63</a> halves the window to six hours.</p>

<h2>OCaml 5.5.2 and new distributions</h2>

<p>The rollout that follows an OCaml release. ocaml-dockerfile 8.4.6 went out with the Ubuntu 26.10 change and is in opam-repository; <a href="https://github.com/ocurrent/docker-base-images/pull/362">docker-base-images#362</a> picks it up along with ocaml-version 4.1.5, adding 5.5.2 and 26.10 and dropping 25.04, 25.10 and Fedora 42; <a href="https://github.com/ocurrent/opam-repo-ci/pull/490">opam-repo-ci#490</a> and <a href="https://github.com/ocurrent/ocaml-ci/pull/1076">ocaml-ci#1076</a> follow, and the <code class="language-plaintext highlighter-rouge">day10</code> branches of both were rebased on top.</p>

<h2>FreeBSD, forty days on</h2>

<p>Before rosemary was rebuilt with OCaml 5.5.2, one last reading of the vnode fix from September: <code class="language-plaintext highlighter-rouge">vnlru_failed</code> frozen at 25 for forty days, through two more traffic surges that took the load average to 33 with eight jails and the store to 21,183 datasets before it pruned itself back to five thousand. No warning ever logged.</p>

<h2>grumpy</h2>

<p>“193 updates could not be installed automatically” turned out to be a release upgrade from jammy to noble that had stopped halfway: <code class="language-plaintext highlighter-rouge">base-files</code>, <code class="language-plaintext highlighter-rouge">dpkg</code> and <code class="language-plaintext highlighter-rouge">libc6</code> from noble, <code class="language-plaintext highlighter-rouge">apt</code>, <code class="language-plaintext highlighter-rouge">systemd</code> and the kernel still jammy, both sources lists present, and noble’s t64 library renames needing removals that unattended-upgrades will never do. The root filesystem was 7.5 GB with 1.3 free, and the volume group had 149 GB unallocated, so 40 GB online and the upgrade finished, then on to 26.04.</p>

<p>A side find for every 26.04 host: the garbage on the serial console at boot is systemd 259’s OSC 3008 context escape and an <code class="language-plaintext highlighter-rouge">XTGETTCAP</code> query that <code class="language-plaintext highlighter-rouge">serial-getty@</code> sends because <code class="language-plaintext highlighter-rouge">TTYReset=yes</code>. A drop-in with <code class="language-plaintext highlighter-rouge">TTYReset=no</code> stops it.</p>

<h1>Tessera</h1>

<h2>Greenland for EPFL</h2>

<p>With monteverde back in service, I have started processing <a href="https://github.com/ucam-eo/geotessera/issues/408">#408</a>: dark ice on the Greenland ice sheet, a bounding box from 55 to 42 degrees west and 59 to 71 north, for 2017, 2019 and 2023.</p>

<p>I used <a href="https://github.com/mtelvers/ferry">mtelvers/ferry</a> to create a pipeline similar to the one I used for 17MPU. This will process 412 shards across UTM zones 21 to 24, 5,513 live sub-windows of 6,592. 114 of the 2017 shards were already in the store from earlier work, so 1,122 remain.</p>

<p>The ice sheet itself is interesting in the logs. Interior shards get no usable Sentinel-1 at all, 165 of 165 dates unavailable, and the model falls back to Sentinel-2 only; the download log has 224,846 lines rejecting HH/HV polar-mode scenes against the model’s VV/VH.</p>

<p>As of 8am this morning: 67 shard-years uploaded, 17.3 minutes a shard, no failures overnight, about 83 shards a day, finishing around 15 November.</p>

<h2>dClimate’s engine against mine</h2>

<p>On a call with dClimate earlier in the week, we discussed the scarcity of GPUs across cloud providers. We suggested using the AMX to do inference on CPUs. However, when they looked at the numbers, dClimate’s optimised Python pipeline was significantly quicker.</p>

<p>I could not remember a recent benchmark on their inference engine, so when monteverde was available, I tested the inference on a single tile vs my CUDA encoder on the NVIDIA L4.</p>

<table>
  <thead>
    <tr>
      <th>engine</th>
      <th>per tile</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>dClimate v2 Large, pipelined</td>
      <td>129.0 to 130.3 s</td>
    </tr>
    <tr>
      <td>dClimate v2 Large, serial loop</td>
      <td>129.8 to 131.6 s</td>
    </tr>
    <tr>
      <td>my CUDA encoder, <code class="language-plaintext highlighter-rouge">TC_CHUNK=64</code></td>
      <td>117.0 s</td>
    </tr>
  </tbody>
</table>

<h1>Cambridge machines</h1>

<h2>monteverde</h2>

<p>monteverde was reporting NVMe errors despite a spotless SMART record and the drive firmware at the latest available. I gathered logs so the issue could be reported to Dell. However, after a single reboot, the box came up in the initramfs: the PS1010 now failed every read, including LBA 0, with <code class="language-plaintext highlighter-rouge">Internal Error</code> rather than the SGL rejection. A controller reset, a physical reseat and a full power cycle changed nothing.</p>

<p>Dell replaced the drive with a Samsung-based PM1743. The rebuild on Saturday had its own obstacles. The department’s PXE rescue entries fail in GRUB with “out of memory”, so the route was a manual-install entry, a shell, a static address typed by hand because nothing offers monteverde DHCPv4, and the 26.04 server ISO written raw onto the new drive and booted from the old GRUB. Root on the BOSS mirror this time as that is a hardware RAID mirror. <code class="language-plaintext highlighter-rouge">tank</code> as a stripe of the two data drives, 27.9 TB, with home, scratch and the container stores on it.</p>

<p>On Saturday, Anil upgraded it to 26.10 with <code class="language-plaintext highlighter-rouge">do-release-upgrade -d</code>, and within an hour the console was logging <code class="language-plaintext highlighter-rouge">Data SGL Length Invalid</code> again. Always on the surviving PS1010, never on the PM1743, on the same bus. We are currently running with <code class="language-plaintext highlighter-rouge">nvme.sgl_threshold=0</code>, which forces PRPs for everything. Hopefully, Dell will give us a preemptive replacement.</p>

<h2>hopper: three releases in a day</h2>

<p>hopper, the Grace Hopper box, was on 22.04 and needed to be updated to 26.04. This has to be done on-site, as the fans are so loud that we need to ensure the server room is empty before rebooting. The upgrade was an uneventful step through 24.04 to get to 26.04 with the latest NVIDIA drivers.</p>

<h2>daintree’s crash was a power cut</h2>

<p>daintree had been restarted, which I initially assumed was an OOM crash which turned into a reboot. The amber light on the front led to <code class="language-plaintext highlighter-rouge">racadm</code>, and the iDRAC’s lifecycle log reported: “iDRAC firmware was rebooted with the following reason: ac”, at 22:17 on 25 October.</p>

<p>hopper’s previous boot ended uncleanly at 22:14 the same night, marpe’s at 22:14, and grumpy rebooted at 22:22. The common factor was that all these machines were in the same rack.</p>

<p>On the way back up daintree ran four firmware jobs that had been staged in May, including a BIOS from 1.12.4 to 1.17.1. The amber light itself is “Unable to authenticate System FPGA/CPLD” at every power-on since at least September. And the reboot did not change the kernel: still 6.8.0-63, with 447 updates pending.</p>

<h2>marpe’s backplane</h2>

<p>marpe came up from the same power cut halted at a BIOS prompt: “Comm Error: Backplane 1”. The third backplane assertion in three months, roughly monthly. Via the serial console, I accepted the configuration to boot it, then found the one combined power and signal cable that runs from the backplane through the latch between the fans to the front edge of the board, and reseated it. If the sensor stays quiet until December, the cable was the fault.</p>

<h2>UID standardisation</h2>

<p>daintree’s power cut was the opportunity to renumber ae491 and sj514. monteverde’s reinstall meant recreating its users, so they went in at their canonical numbers from the start, with mte24 finally renumbered there too. zf281 was back on daintree with 27 processes before his turn came, and remains the other half of the 1012 collision. cae37’s R jobs are still running.</p>

<h1>Other</h1>

<h2>conservation-copilot: the R hang</h2>

<p>On the VM, the Celery worker was in a fork-crash loop: 494 kills in ten minutes. Restarting everything brought the service back, but why did it fail? Fortunately, there are detailed logs, so I could replay the last query, which recreated the crash.</p>

<p>The issue is that when the query runs for more than the hard time limit, the <code class="language-plaintext highlighter-rouge">billiard.Pool</code> tries to kill the process, but the R worker blocked in native code didn’t exit and everything piled up behind it.</p>

<p>I replaced the nested pool with a plain subprocess: pickle in, JSON out, SIGKILL on timeout, which R cannot ignore. PR #24, merged. The R hang itself is still unexplained.</p>

<h2>fuel</h2>

<p>I revisited my <a href="https://fuel.mint.caelum.ci.dev">fuel web app</a>, as the data was missing. Claude wrote it, and I asked for a fix and a review of the project, explaining that it was written six months ago by an earlier version of the agent.</p>

<p>The app was substantially rewritten, taking it from a single file to an API client, a station cache, and a thin server, each with an interface, and moving refresh into a background fibre that publishes an immutable snapshot.</p>

<p>The client adds per-request timeouts, re-authentication on 401 or 403, backoff retries on 429 and 5xx, result-typed errors instead of escaping exceptions, and a connector that tries IPv4 before IPv6 and falls through on failure. A failed or partial refresh now keeps the previous snapshot and retries with backoff, the frontend lives in its own HTML file embedded at build time and polls a status endpoint until data is ready, logging uses proper Logs sources, the stations endpoint supports ETag and 304.</p>
