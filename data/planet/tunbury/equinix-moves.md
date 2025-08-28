---
title: Equinix Moves
description: The moves of registry.ci.dev, opam-repo-ci, and get.dune.build have followed
  the template of OCaml-CI. Notable differences have been that I have hosted get.dune.build
  in a VM, as the services required very little disk space or CPU/RAM. For opam-repo-ci,
  the rsync was pretty slow, so I tried running multiple instances using GNU parallel
  with marginal gains.
url: https://www.tunbury.org/2025/04/29/equinix-moves/
date: 2025-04-29T00:00:00-00:00
preview_image: https://www.tunbury.org/images/equinix.png
authors:
- Mark Elvers
source:
ignore:
---

<p>The moves of registry.ci.dev, opam-repo-ci, and get.dune.build have followed the template of <a href="https://www.tunbury.org/ocaml-ci/">OCaml-CI</a>. Notable differences have been that I have hosted <code class="language-plaintext highlighter-rouge">get.dune.build</code> in a VM, as the services required very little disk space or CPU/RAM. For opam-repo-ci, the <code class="language-plaintext highlighter-rouge">rsync</code> was pretty slow, so I tried running multiple instances using GNU parallel with marginal gains.</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="nb">cd</span> /var/lib/docker/volumes2/opam-repo-ci_data/_data/var/job
<span class="nb">ls</span> <span class="nt">-d</span> <span class="k">*</span> | parallel <span class="nt">-j</span> 5 rsync <span class="nt">-azh</span> c2-4.equinix.ci.dev:/var/lib/docker/volumes/opam-repo-ci_data/_data/var/job/<span class="o">{}</span>/ <span class="o">{}</span>/
</code></pre></div></div>

<p>The Ansible configuration script for OCaml-CI is misnamed as it configures the machine and deploys infrastructure: Caddy, Grafana, Prometheus and Docker secrets, but not the Docker stack. The Docker stack for OCaml-CI is deployed by <code class="language-plaintext highlighter-rouge">make deploy-stack</code> from <a href="https://github.com/ocurrent/ocaml-ci">ocurrent/ocaml-ci</a>. Conversely, opam-repo-ci <em>is</em> deployed from the Ansible playbook, but there is a <code class="language-plaintext highlighter-rouge">Makefile</code> and an outdated <code class="language-plaintext highlighter-rouge">stack.yml</code> in <a href="https://github.com/ocurrent/opam-repo-ci">ocurrent/opam-repo-ci</a>.</p>

<p>As part of the migration away from Equinix, these services have been merged into a single large machine <code class="language-plaintext highlighter-rouge">chives.caelum.ci.dev</code>. With this change, I have moved the Docker stack configuration for opam-repo-ci back to the repository <a href="https://github.com/ocurrent/opam-repo-ci/pull/428">PR#428</a> and merged and renamed the machine configuration <a href="https://github.com/mtelvers/ansible/pull/44">PR#44</a>.</p>

<p>We want to thank Equinix for supporting OCaml over the years.</p>
