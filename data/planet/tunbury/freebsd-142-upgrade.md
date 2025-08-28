---
title: FreeBSD 14.2 Upgrade
description: CI workers spring and summer run FreeBSD and need to be updated.
url: https://www.tunbury.org/2025/03/26/freebsd-14.2/
date: 2025-03-26T00:00:00-00:00
preview_image: https://www.tunbury.org/images/freebsd-logo.png
authors:
- Mark Elvers
source:
ignore:
---

<p>CI workers <code class="language-plaintext highlighter-rouge">spring</code> and <code class="language-plaintext highlighter-rouge">summer</code> run FreeBSD and need to be updated.</p>

<p>Check the current version of FreeBSD which we have with <code class="language-plaintext highlighter-rouge">uname -r</code>.</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>FreeBSD summer 14.1-RELEASE-p5 FreeBSD 14.1-RELEASE-p5 GENERIC amd64
</code></pre></div></div>

<p>Run <code class="language-plaintext highlighter-rouge">freebsd-update fetch</code> to download the latest versions of the system components, particularly the <code class="language-plaintext highlighter-rouge">freebsd-update</code> utility.  It even reported that it really is time to upgrade!</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="c"># freebsd-update fetch</span>
...
WARNING: FreeBSD 14.1-RELEASE-p5 is approaching its End-of-Life date.
It is strongly recommended that you upgrade to a newer
release within the next 5 days.
</code></pre></div></div>

<p>Install these updates.</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>freebsd-update <span class="nb">install</span>
</code></pre></div></div>

<p>Now use <code class="language-plaintext highlighter-rouge">freebsd-update</code> to fetch the 14.2-RELEASE and install it.</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="c"># freebsd-update upgrade -r 14.2-RELEASE</span>
...
<span class="c">#&nbsp;freebsd-update install</span>
src component not installed, skipped
Installing updates...
Kernel updates have been installed.  Please reboot and run
<span class="s1">'freebsd-update [options] install'</span> again to finish installing updates.
</code></pre></div></div>

<p>Reboot the system using <code class="language-plaintext highlighter-rouge">reboot</code> and then finish installing updates.</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="c"># freebsd-update install</span>
src component not installed, skipped
Installing updates...
Restarting sshd after upgrade
Performing sanity check on sshd configuration.
Stopping sshd.
Waiting <span class="k">for </span>PIDS: 707.
Performing sanity check on sshd configuration.
Starting sshd.
Scanning /usr/share/certs/untrusted <span class="k">for </span>certificates...
Scanning /usr/share/certs/trusted <span class="k">for </span>certificates...
Scanning /usr/local/share/certs <span class="k">for </span>certificates...
 <span class="k">done</span><span class="nb">.</span>
</code></pre></div></div>

<p>Now use <code class="language-plaintext highlighter-rouge">pkg</code> to upgrade any applications.</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="c"># pkg upgrade</span>
Updating FreeBSD repository catalogue...
Fetching data.pkg: 100%    7 MiB   7.5MB/s    00:01    
Processing entries: 100%
FreeBSD repository update completed. 35885 packages processed.
All repositories are up to date.
Checking <span class="k">for </span>upgrades <span class="o">(</span>28 candidates<span class="o">)</span>: 100%
Processing candidates <span class="o">(</span>28 candidates<span class="o">)</span>: 100%
The following 28 package<span class="o">(</span>s<span class="o">)</span> will be affected <span class="o">(</span>of 0 checked<span class="o">)</span>:

Installed packages to be UPGRADED:
	curl: 8.10.1 -&gt; 8.11.1_1
...
	xxd: 9.1.0764 -&gt; 9.1.1199

Number of packages to be upgraded: 28

The process will require 3 MiB more space.
77 MiB to be downloaded.

Proceed with this action? <span class="o">[</span>y/N]: y
</code></pre></div></div>

<p>Finally, reboot the system and check <code class="language-plaintext highlighter-rouge">uname -a</code>.</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="c"># uname -a</span>
FreeBSD spring 14.2-RELEASE-p1 FreeBSD 14.2-RELEASE-p1 GENERIC amd64
</code></pre></div></div>

<p>To update the the FreeBSD base images used by the CI services, I applied <a href="https://github.com/ocurrent/freebsd-infra/pull/13">PR#13</a> to <a href="https://github.com/ocurrent/freebsd-infra">ocurrent/freebsd-infra</a>.</p>

<p>This was followed up by <a href="https://github.com/ocurrent/ocaml-ci/pull/1007">PR#1007</a> on ocurrent/ocaml-ci and <a href="https://github.com/ocurrent/opam-repo-ci/pull/427">PR#427</a> to ocurrent/opam-repo-ci.</p>
