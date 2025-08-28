---
title: Moving OCaml-CI
description: As noted on Thursday, the various OCaml services will need to be moved
  away from Equinix. Below are my notes on moving OCaml-CI.
url: https://www.tunbury.org/2025/04/27/ocaml-ci/
date: 2025-04-27T00:00:00-00:00
preview_image: https://www.tunbury.org/images/ocaml-logo.png
authors:
- Mark Elvers
source:
ignore:
---

<p>As noted on Thursday, the various OCaml services will need to be moved away from Equinix. Below are my notes on moving OCaml-CI.</p>

<p>Generate an SSH key on the new server <code class="language-plaintext highlighter-rouge">chives</code> using <code class="language-plaintext highlighter-rouge">ssh-keygen -t ed25519</code>. Copy the public key to <code class="language-plaintext highlighter-rouge">c2-3.equinix.ci.dev</code> and save it under <code class="language-plaintext highlighter-rouge">~/.ssh/authorized_keys</code>.</p>

<p>Use <code class="language-plaintext highlighter-rouge">rsync</code> to mirror the Docker volumes. <code class="language-plaintext highlighter-rouge">-z</code> did improve performance as there appears to be a rate limiter somewhere in the path.</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>rsync <span class="nt">-azvh</span> <span class="nt">--progress</span> c2-3.equinix.ci.dev:/var/lib/docker/volumes/ /var/lib/docker/volumes/
</code></pre></div></div>

<p>After completing the copy, I waited for a quiet moment, and then scaled all of the Docker services to 0. I prefer to scale the services rather than remove them, as the recovery is much easier.</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>docker service scale <span class="nv">infra_grafana</span><span class="o">=</span>0
docker service scale <span class="nv">infra_prometheus</span><span class="o">=</span>0
docker service scale ocaml-ci_ci<span class="o">=</span>0
docker service scale ocaml-ci_gitlab<span class="o">=</span>0
docker service scale ocaml-ci_web<span class="o">=</span>0
</code></pre></div></div>

<p>For the final copy, I used <code class="language-plaintext highlighter-rouge">--checksum</code> and also added <code class="language-plaintext highlighter-rouge">--delete</code>, as the Prometheus database creates segment files that are periodically merged into the main database.</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>rsync <span class="nt">-azvh</span> <span class="nt">--checksum</span> <span class="nt">--delete</span> <span class="nt">--progress</span> c2-3.equinix.ci.dev:/var/lib/docker/volumes/ /var/lib/docker/volumes/
</code></pre></div></div>

<p>The machine configuration is held in an Ansible Playbook, which includes the Docker stack for Grafana and Prometheus. It can be easily applied to the new machine:</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>ansible-playbook <span class="nt">-e</span> @secrets/ocaml.ci.dev.yml <span class="nt">--vault-password-file</span> secrets/vault-password ocaml.ci.dev.yml
</code></pre></div></div>

<p>OCaml-CI’s Docker stack is held on GitHub <a href="https://github.com/ocurrent/ocaml-ci">ocurrent/ocaml-ci</a> and can be deployed with:</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code>make deploy-stack
</code></pre></div></div>
