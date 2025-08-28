---
title: ZFS Send Streams
description: We often say that ZFS is an excellent replicated file system, but not
  the best local filesystem. This led me to think that if we run zfs send on one machine,
  we might want to write that out as a different filesystem. Is that even possible?
url: https://www.tunbury.org/2025/05/02/zfs-send-streams/
date: 2025-05-02T20:00:00-00:00
preview_image: https://www.tunbury.org/images/openzfs.png
authors:
- Mark Elvers
source:
ignore:
---

<p>We often say that ZFS is an excellent replicated file system, but not the best <em>local</em> filesystem. This led me to think that if we run <code class="language-plaintext highlighter-rouge">zfs send</code> on one machine, we might want to write that out as a different filesystem. Is that even possible?</p>

<p>What is in a ZFS stream?</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>fallocate <span class="nt">-l</span> 10G temp.zfs
zpool create tank <span class="sb">`</span><span class="nb">pwd</span><span class="sb">`</span>/temp.zfs 
zfs create tank/home
<span class="nb">cp </span>README.md /tank/home
zfs snapshot tank/home@send
zfs send tank/home@send | hexdump
</code></pre></div></div>

<p>I spent a little time writing an OCaml application to parse the record structure before realising that there already was a tool to do this: <code class="language-plaintext highlighter-rouge">zstreamdump</code>. Using the <code class="language-plaintext highlighter-rouge">-d</code> flag shows the contents; you can see your file in the dumped output.</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>zfs send tank/home@send | zstreamdump <span class="nt">-d</span>
</code></pre></div></div>

<p>However, this is <em>not</em> like a <code class="language-plaintext highlighter-rouge">tar</code> file. It is not a list of file names and their content. It is a list of block changes. ZFS is a tree structure with a snapshot and a volume being tree roots. The leaves of the tree may be unchanged between two snapshots. <code class="language-plaintext highlighter-rouge">zfs send</code> operates at the block level below the file system layer.</p>

<p>To emphasise this point, consider a <code class="language-plaintext highlighter-rouge">ZVOL</code> formatted as XFS. The structure of the send stream is the same: a record of block changes.</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>zfs create <span class="nt">-V</span> 1G tank/vol
mkfs.xfs /dev/zvol/tank/vol
zfs snapshot tank/vol@send
zfs send tank/vol@send | zstreamdump <span class="nt">-d</span>
</code></pre></div></div>

<p>ZVOLs are interesting as they give you a snapshot capability on a file system that doesn’t have one. However, some performance metrics I saw posted online showed disappointing results compared with creating a file and using a loopback device. Furthermore, the snapshot would only be in a crash-consistent state as it would be unaware of the underlying snapshot. XFS does have <code class="language-plaintext highlighter-rouge">xfsdump</code> and <code class="language-plaintext highlighter-rouge">xfsrestore</code>, but they are pretty basic tools.</p>

<p>[1] See also <a href="https://openzfs.org/wiki/Documentation/ZfsSend">ZfsSend Documentation</a></p>
