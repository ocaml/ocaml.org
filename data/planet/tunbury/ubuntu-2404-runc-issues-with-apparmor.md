---
title: Ubuntu 24.04 runc issues with AppArmor
description: Patrick reported issues with OCaml-CI running tests on ocaml-ppx.
url: https://www.tunbury.org/2025/05/13/ubuntu-apparmor/
date: 2025-05-13T12:00:00-00:00
preview_image: https://www.tunbury.org/images/ubuntu.png
authors:
- Mark Elvers
source:
ignore:
---

<p>Patrick reported issues with OCaml-CI running tests on <code class="language-plaintext highlighter-rouge">ocaml-ppx</code>.</p>

<blockquote>
  <p>Fedora seems to be having some issues: https://ocaml.ci.dev/github/ocaml-ppx/ppxlib/commit/0d6886f5bcf22287a66511817e969965c888d2b7/variant/fedora-40-5.3_opam-2.3</p>
  <div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>sudo: PAM account management error: Authentication service cannot retrieve authentication info
sudo: a password is required
"/usr/bin/env" "bash" "-c" "sudo dnf install -y findutils" failed with exit status 1
2025-05-12 08:55.09: Job failed: Failed: Build failed
</code></pre></div>  </div>
</blockquote>

<p>I took this problem at face value and replied that the issue would be related to Fedora 40, which is EOL. I created <a href="https://github.com/ocurrent/ocaml-ci/pull/1011">PR#1011</a> for OCaml-CI and deployed it. However, the problem didn’t go away. We were now testing Fedora 42, but jobs were still failing. I created a minimal obuilder job specification:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>((from ocaml/opam:fedora-42-ocaml-4.14@sha256:475a852401de7d578efec2afce4384d87b505f5bc610dc56f6bde3b87ebb7664)
(user (uid 1000) (gid 1000))
(run (shell "sudo ln -f /usr/bin/opam-2.3 /usr/bin/opam")))
</code></pre></div></div>

<p>Submitting the job to the cluster showed it worked on all machines except for <code class="language-plaintext highlighter-rouge">bremusa</code>.</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="nv">$ </span>ocluster-client submit-obuilder <span class="nt">--connect</span> mtelvers.cap  <span class="nt">--pool</span> linux-x86_64 <span class="nt">--local-file</span> fedora-42.spec
Tailing log:
Building on bremusa.ocamllabs.io

<span class="o">(</span>from ocaml/opam:fedora-42-ocaml-4.14@sha256:475a852401de7d578efec2afce4384d87b505f5bc610dc56f6bde3b87ebb7664<span class="o">)</span>
2025-05-12 16:55.42 <span class="nt">---</span><span class="o">&gt;</span> using <span class="s2">"aefb7551cd0db7b5ebec7e244d5637aef02ab3f94c732650de7ad183465adaa0"</span> from cache

/: <span class="o">(</span>user <span class="o">(</span>uid 1000<span class="o">)</span> <span class="o">(</span>gid 1000<span class="o">))</span>

/: <span class="o">(</span>run <span class="o">(</span>shell <span class="s2">"sudo ln -f /usr/bin/opam-2.3 /usr/bin/opam"</span><span class="o">))</span>
<span class="nb">sudo</span>: PAM account management error: Authentication service cannot retrieve authentication info
<span class="nb">sudo</span>: a password is required
<span class="s2">"/usr/bin/env"</span> <span class="s2">"bash"</span> <span class="s2">"-c"</span> <span class="s2">"sudo ln -f /usr/bin/opam-2.3 /usr/bin/opam"</span> failed with <span class="nb">exit </span>status 1
Failed: Build failed.
</code></pre></div></div>

<p>Changing the image to <code class="language-plaintext highlighter-rouge">opam:debian-12-ocaml-4.14</code> worked, so the issue only affects Fedora images and only on <code class="language-plaintext highlighter-rouge">bremusa</code>. I was able to reproduce the issue directly using <code class="language-plaintext highlighter-rouge">runc</code>.</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="c"># runc run test</span>
<span class="nb">sudo</span>: PAM account management error: Authentication service cannot retrieve authentication info
<span class="nb">sudo</span>: a password is required
</code></pre></div></div>

<p>Running <code class="language-plaintext highlighter-rouge">ls -l /etc/shadow</code> in the container showed that the permissions on <code class="language-plaintext highlighter-rouge">/etc/shadow</code> are 000. If these are changed to <code class="language-plaintext highlighter-rouge">640</code>, then <code class="language-plaintext highlighter-rouge">sudo</code> works correctly. Permissions are set 000 for <code class="language-plaintext highlighter-rouge">/etc/shadow</code> in some distributions as access is limited to processes with the capability <code class="language-plaintext highlighter-rouge">DAC_OVERRIDE</code>.</p>

<p>Having seen a permission issue with <code class="language-plaintext highlighter-rouge">runc</code> and <code class="language-plaintext highlighter-rouge">libseccomp</code> compatibility <a href="https://github.com/ocaml/infrastructure/issues/121">before</a>, I went down a rabbit hole investigating that. Ultimately, I compiled <code class="language-plaintext highlighter-rouge">runc</code> without <code class="language-plaintext highlighter-rouge">libseccomp</code> support, <code class="language-plaintext highlighter-rouge">make MAKETAGS=""</code>, and this still had the same issue.</p>

<p>All the machines in the <code class="language-plaintext highlighter-rouge">linux-x86_64</code> pool are running Ubuntu 22.04 except for <code class="language-plaintext highlighter-rouge">bremusa</code>. I configured a spare machine with Ubuntu 24.04 and tested. The problem appeared on this machine as well.</p>

<p>Is there a change in Ubuntu 24.04?</p>

<p>I temporarily disabled AppArmor by editing <code class="language-plaintext highlighter-rouge">/etc/default/grub</code> and added <code class="language-plaintext highlighter-rouge">apparmor=0</code> to <code class="language-plaintext highlighter-rouge">GRUB_CMDLINE_LINUX</code>, ran <code class="language-plaintext highlighter-rouge">update-grub</code> and rebooted. Disabling AppArmor entirely like this can create security vulnerabilities, so this isn’t recommended, but it did clear the issue.</p>

<p>After enabling AppArmor again, I disabled the configuration for <code class="language-plaintext highlighter-rouge">runc</code> by running:</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="nb">ln</span> <span class="nt">-s</span> /etc/apparmor.d/runc /etc/apparmor.d/disable/
apparmor_parser <span class="nt">-R</span> /etc/apparmor.d/runc
</code></pre></div></div>

<p>This didn’t help - in fact, this was worse as now <code class="language-plaintext highlighter-rouge">runc</code> couldn’t run at all.  I restored the configuration and added <code class="language-plaintext highlighter-rouge">capability dac_override</code>, but this didn’t help either.</p>

<p>Looking through the profiles with <code class="language-plaintext highlighter-rouge">grep shadow -r /etc/apparmor.d</code>, I noticed <code class="language-plaintext highlighter-rouge">unix-chkpwd</code>, which could be the source of the issue. I disabled this profile and the issue was resolved.</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="nb">ln</span> <span class="nt">-s</span> /etc/apparmor.d/unix-chkpwd /etc/apparmor.d/disable
apparmor_parser <span class="nt">-R</span> /etc/apparmor.d/unix-chkpwd
</code></pre></div></div>

<p>Armed with the answer, it’s pretty easy to find other people with related issues:</p>
<ul>
  <li>https://github.com/docker/build-push-action/issues/1302</li>
  <li>https://github.com/moby/moby/issues/48734</li>
</ul>
