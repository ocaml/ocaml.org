---
title: A ZFS Scaling Adventure
description: 'The FreeBSD workers have been getting [slower]( (https://github.com/ocurrent/opam-repo-ci/issues/449):
  jobs that should take a few minutes are now timing out after 60 minutes. My first
  instinct was that ZFS was acting strangely.'
url: https://www.tunbury.org/2025/08/23/zfs-scaling/
date: 2025-08-23T00:00:00-00:00
preview_image: https://www.tunbury.org/images/ocaml-logo.png
authors:
- Mark Elvers
source:
ignore:
---

<p>The FreeBSD workers have been getting [slower](
(https://github.com/ocurrent/opam-repo-ci/issues/449): jobs that should take a few minutes are now timing out after 60 minutes. My first instinct was that ZFS was acting strangely.</p>

<p>I checked the classic ZFS performance indicators:</p>

<ul>
  <li>Pool health: <code class="language-plaintext highlighter-rouge">zpool status</code> - ONLINE, no errors</li>
  <li>ARC hit ratio: <code class="language-plaintext highlighter-rouge">sysctl kstat.zfs.misc.arcstats.hits kstat.zfs.misc.arcstats.misses</code> - 98.8% (excellent!)</li>
  <li>Fragmentation: <code class="language-plaintext highlighter-rouge">zpool list</code> - 53% (high but not catastrophic)</li>
  <li>I/O latency: <code class="language-plaintext highlighter-rouge">zpool iostat -v 1 3</code> and <code class="language-plaintext highlighter-rouge">iostat -x 1 3</code> - 1ms read/write (actually pretty good)</li>
</ul>

<p>But the <code class="language-plaintext highlighter-rouge">sync</code> command was taking 70-160ms when it should be under 10ms for an SSD. We don’t need <code class="language-plaintext highlighter-rouge">sync</code> as the disk has disposable CI artefacts, so why not try:</p>

<div class="language-bash highlighter-rouge"><div class="highlight"><pre class="highlight"><code>zfs <span class="nb">set sync</span><span class="o">=</span>disabled obuilder
</code></pre></div></div>

<p>The sync times improved to 40-50ms, but the CI jobs were still crawling.</p>

<p>I applied some ZFS tuning to try to improve things:</p>

<div class="language-bash highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="c"># Crank up those queue depths</span>
sysctl vfs.zfs.vdev.async_read_max_active<span class="o">=</span>32
sysctl vfs.zfs.vdev.async_write_max_active<span class="o">=</span>32
sysctl vfs.zfs.vdev.sync_read_max_active<span class="o">=</span>32
sysctl vfs.zfs.vdev.sync_write_max_active<span class="o">=</span>32

<span class="c"># Speed up transaction groups</span>
sysctl vfs.zfs.txg.timeout<span class="o">=</span>1
sysctl vfs.zfs.dirty_data_max<span class="o">=</span>8589934592

<span class="c"># Optimize for metadata</span>
zfs <span class="nb">set </span><span class="nv">atime</span><span class="o">=</span>off obuilder
zfs <span class="nb">set </span><span class="nv">primarycache</span><span class="o">=</span>metadata obuilder
sysctl vfs.zfs.arc.meta_balance<span class="o">=</span>1000
</code></pre></div></div>

<p>However, these changes were making no measurable difference to the actual performance.</p>

<p>For comparison, I ran one of the CI steps on an identical machine, which was running Ubuntu with BTRFS:-</p>

<div class="language-bash highlighter-rouge"><div class="highlight"><pre class="highlight"><code>opam <span class="nb">install </span>astring.0.8.5 base-bigarray.base base-domains.base base-effects.base base-nnp.base base-threads.base base-unix.base base64.3.5.1 bechamel.0.5.0 camlp-streams.5.0.1 cmdliner.1.3.0 cppo.1.8.0 csexp.1.5.2 dune.3.20.0 either.1.0.0 fmt.0.11.0 gg.1.0.0 jsonm.1.0.2 logs.0.9.0 mdx.2.5.0 ocaml.5.3.0 ocaml-base-compiler.5.3.0 ocaml-compiler.5.3.0 ocaml-config.3 ocaml-options-vanilla.1 ocaml-version.4.0.1 ocamlbuild.0.16.1 ocamlfind.1.9.8 optint.0.3.0 ounit2.2.2.7 re.1.13.2 repr.0.7.0 result.1.5 seq.base stdlib-shims.0.3.0 topkg.1.1.0 uutf.1.0.4 vg.0.9.5
</code></pre></div></div>

<p>This took &lt; 3 minutes, but the worker logs showed the same step took 35 minutes. What could cause such a massive difference on identical hardware?</p>

<p>On macOS, I’ve previously seen problems when the number of mounted filesystems got to around 1000. <code class="language-plaintext highlighter-rouge">mount</code> would take t minutes to complete. I wondered, how many file systems are mounted?</p>

<div class="language-bash highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="c"># mount | grep obuilder | wc -l</span>
    33787
</code></pre></div></div>

<p>Now, that’s quite a few file systems.  Historically, our FreeBSD workers had tiny SSDs, circa 128GB, but with the move to a new server with a 1.7TB SSD disk and using the same 25% prune threshold, the number of mounted file systems has become quite large.</p>

<p>I gradually increased the prune threshold and waited for <a href="https://github.com/ocurrent/ocluster">ocurrent/ocluster</a> to prune jobs. With the threshold at 90% the number of file systems was down to ~5,000, and performance was restored.</p>

<p>It’s not really a bug; it’s just an unexpected side effect of having a large number of mounted file systems. On macOS, the resolution was to unmount all the file systems at the end of each job, but that’s easy when the concurrency is limited to one and more tricky when the concurrency is 20 jobs.</p>
