---
title: Moving to opam 2.4
description: opam 2.4.0 was released on 18th July followed by opam 2.4.1 a few days
  later. This update needs to be propagated through the CI infrastructure. The first
  step is to update the base images for each OS.
url: https://www.tunbury.org/2025/07/30/opam-24/
date: 2025-07-30T00:00:00-00:00
preview_image: https://www.tunbury.org/images/opam.png
authors:
- Mark Elvers
source:
ignore:
---

<p><a href="https://opam.ocaml.org/blog/opam-2-4-0/">opam 2.4.0</a> was released on 18th July followed by <a href="https://opam.ocaml.org/blog/opam-2-4-1/">opam 2.4.1</a> a few days later. This update needs to be propagated through the CI infrastructure.  The first step is to update the base images for each OS.</p>

<h1>Linux</h1>

<h3><a href="https://github.com/ocurrent/docker-base-images">ocurrent/docker-base-images</a></h3>

<p>The Linux base images are created using the <a href="https://images.ci.ocaml.org">Docker base image builder</a>, which uses <a href="https://github.com/ocurrent/ocaml-dockerfile">ocurrent/ocaml-dockerfile</a> to know which versions of opam are available. Kate submitted <a href="https://github.com/ocurrent/ocaml-dockerfile/pull/235">PR#235</a> with the necessary changes to <a href="https://github.com/ocurrent/ocaml-dockerfile">ocurrent/ocaml-dockerfile</a>. This was released as v8.2.9 under <a href="https://github.com/ocaml/opam-repository/pull/28251">PR#28251</a>.</p>

<p>With v8.2.9 released, <a href="https://github.com/ocurrent/docker-base-images/pull/327">PR#327</a> can be opened to update the pipeline to build images which include opam 2.4. Rebuilding the base images takes a good deal of time, particularly as it’s marked as a low-priority task on the cluster.</p>

<h1>macOS</h1>

<h3><a href="https://github.com/ocurrent/macos-infra">ocurrent/macos-infra</a></h3>

<p>Including opam 2.4 in the macOS required <a href="https://github.com/ocurrent/macos-infra/pull/56">PR#56</a>, which adds <code class="language-plaintext highlighter-rouge">2.4.1</code> to the list of opam packages to download. There are Ansible playbooks that build the macOS base images and recursively remove the old images and their (ZFS) clones. They take about half an hour per machine. I run the Intel and Apple Silicon updates in parallel, but process each pool one at a time.</p>

<p>The Ansible command is:</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>ansible-playbook update-ocluster.yml
</code></pre></div></div>

<h1>FreeBSD (rosemary.caelum.ci.dev)</h1>

<h3><a href="https://github.com/ocurrent/freebsd-infra">ocurrent/freebsd-infra</a></h3>

<p>The FreeBSD update parallels the macOS update, requiring that <code class="language-plaintext highlighter-rouge">2.4.1</code> be added to the loop of available versions. <a href="https://github.com/ocurrent/freebsd-infra/pull/15">PR#15</a>.</p>

<p>The Ansible playbook for updating the machine is named <code class="language-plaintext highlighter-rouge">update.yml</code>. However, we have been suffering from some reliability issues with the FreeBSD worker, see <a href="https://github.com/ocurrent/opam-repo-ci/issues/449">issue#449</a>, so I took the opportunity to rebuild the worker from scratch.</p>

<p>The OS reinstallation is documented in this <a href="https://www.tunbury.org/2025/05/06/freebsd-uefi/">post</a>, and it’s definitely worth reading the <a href="https://github.com/ocurrent/freebsd-infra/blob/master/README.md">README.md</a> in the repo for the post-installation steps.</p>

<h1>Windows (thyme.caelum.ci.dev)</h1>

<h3><a href="https://github.com/ocurrent/obuilder">ocurrent/obuilder</a></h3>

<p>The Windows base images are built using a <code class="language-plaintext highlighter-rouge">Makefile</code> which runs unattended builds of Windows using QEMU virtual machines. The Makefile required <a href="https://github.com/ocurrent/obuilder/pull/198">PR#198</a> to The command is <code class="language-plaintext highlighter-rouge">make windows</code>.</p>

<p>Once the new images have been built, stop ocluster worker and move the new base images into place.
The next is to remove <code class="language-plaintext highlighter-rouge">results/*</code> as these layers will link to the old base images, and remove <code class="language-plaintext highlighter-rouge">state/*</code> so obuilder will create a new empty database on startup. Avoid removing <code class="language-plaintext highlighter-rouge">cache/*</code> as this is the download cache for opam objects.</p>

<p>The unattended installation can be monitored via VNC by connecting to localhost:5900.</p>

<h1>OpenBSD (oregano.caelum.ci.dev)</h1>

<h3><a href="https://github.com/ocurrent/obuilder">ocurrent/obuilder</a></h3>

<p>The OpenBSD base images are built using the same <code class="language-plaintext highlighter-rouge">Makefile</code> used for Windows. There is a seperate commit in <a href="https://github.com/ocurrent/obuilder/pull/198">PR#198</a> for the changes needed for OpenBSD, which include moving from OpenBSD 7.6 to 7.7. Run <code class="language-plaintext highlighter-rouge">make openbsd</code>.</p>

<p>Once the new images have been built, stop ocluster worker and move the new base images into place.
The next is to remove <code class="language-plaintext highlighter-rouge">results/*</code> as these layers will link to the old base images, and remove <code class="language-plaintext highlighter-rouge">state/*</code> so obuilder will create a new empty database on startup. Avoid removing <code class="language-plaintext highlighter-rouge">cache/*</code> as this is the download cache for opam objects.</p>

<p>As with Windows, the unattended installation can be monitored via VNC by connecting to localhost:5900.</p>

<h1>OCaml-CI</h1>

<p>OCaml-CI uses <a href="https://github.com/ocurrent/ocaml-dockerfile">ocurrent/ocaml-dockerfile</a> as a submodule, so the module needs to be updated to the released version. Edits are needed to <code class="language-plaintext highlighter-rouge">lib/opam_version.ml</code> to include <code class="language-plaintext highlighter-rouge">V2_4</code>, then the pipeline needs to be updated in <code class="language-plaintext highlighter-rouge">service/conf.ml</code> to use version 2.4 rather than 2.3 for all the different operating systems. Linux is rather more automated than the others</p>

<p>Lastly, since we now have OpenBSD 7.7, I have also updated references to OpenBSD 7.6. <a href="https://github.com/ocurrent/ocaml-ci/pull/1020">PR#1020</a>.</p>

<h1>opam-repo-ci</h1>

<p>opam-repo-ci tests using the latest <em>tagged</em> version of opam, which is called <code class="language-plaintext highlighter-rouge">opam-dev</code> within the base images. It also explicitly tests against the latest release in each of the 2.x series. With 2.4 being tagged, this will automatically become the used <em>dev</em> version once the base images are updated, but over time, 2.4 and the latest tagged version will diverge, so <a href="https://github.com/ocurrent/opam-repo-ci/pull/448">PR#448</a> is needed to ensure we continue to test with the released version of 2.4.</p>
