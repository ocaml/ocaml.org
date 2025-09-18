---
title: FreeBSD unionfs deadlock
description: FreeBSD Jails provide isolated system containers that are perfect for
  CI testing. Miod ported OBuilder to FreeBSD back in 2023. I have been looking at
  some different approaches using unionfs.
url: https://www.tunbury.org/2025/09/17/freebsd-unionfs/
date: 2025-09-17T12:00:00-00:00
preview_image: https://www.tunbury.org/images/freebsd-logo.png
authors:
- Mark Elvers
source:
ignore:
---

<p>FreeBSD Jails provide isolated system containers that are perfect for CI testing. Miod <a href="https://tarides.com/blog/2023-10-04-porting-obuilder-to-freebsd/">ported OBuilder</a> to FreeBSD back in 2023. I have been looking at some different approaches using unionfs.</p>

<p>I’d like to have a read-only base layer with the OS, a middle layer containing source code and system libraries, and a top writable layer for the build results. This is easily constructed in an <code class="language-plaintext highlighter-rouge">fstab</code> for the <code class="language-plaintext highlighter-rouge">jail</code> like this.</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>/home/opam/bsd-1402000-x86_64/base/fs /home/opam/temp-2b9f69/work nullfs ro 0 0
/home/opam/temp-2b9f69/lower /home/opam/temp-2b9f69/work unionfs ro 0 0
/home/opam/temp-2b9f69/fs /home/opam/temp-2b9f69/work unionfs rw 0 0
/home/opam/opam-repository /home/opam/temp-2b9f69/work/home/opam/opam-repository nullfs ro 0 0
</code></pre></div></div>

<p>Running <code class="language-plaintext highlighter-rouge">jail -c name=temp-2b9f69 path=/home/opam/temp-2b9f69/work mount.devfs mount.fstab=/home/opam/temp-7323b6/fstab ...</code> works as expected; it’s good enough to build OCaml, but it reliably deadlocks the entire machine when trying to build dune. This appears to be an old problem: <a href="https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=165087">165087</a>, <a href="https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=201677">201677</a> and <a href="https://people.freebsd.org/~daichi/unionfs">unionfs</a>. There is a <a href="https://freebsdfoundation.org/project/unionfs-stability-and-enhancement">project</a> aiming to improve unionfs for use in jails.</p>

<p>My workaround is to create a temporary layer that merges the base and lower layers together. Initially, I did this by mounting <code class="language-plaintext highlighter-rouge">tmpfs</code> to the lower mount point and using <code class="language-plaintext highlighter-rouge">cp</code> to copy the files. The performance was poor, so instead I created the layer on disk and used <code class="language-plaintext highlighter-rouge">cp -l</code> to hard link the files. The simplified <code class="language-plaintext highlighter-rouge">fstab</code> works successfully in my testing.</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>/home/opam/temp-2b9f69/lower /home/opam/temp-2b9f69/work nullfs ro 0 0
/home/opam/temp-2b9f69/fs /home/opam/temp-2b9f69/work unionfs rw 0 0
/home/opam/opam-repository /home/opam/temp-2b9f69/work/home/opam/opam-repository nullfs ro 0 0
</code></pre></div></div>

<p>FreeBSD protects key system files by marking them as immutable; this prevents hard links to the files. Therefore, I needed to remove these flags after the <code class="language-plaintext highlighter-rouge">bsdinstall</code> has completed. <code class="language-plaintext highlighter-rouge">chflags -R 0 basefs</code></p>
