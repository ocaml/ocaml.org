---
title: opam-repo-ci Release Workflow
description: This is a high-level view of the steps required to update ocaml-repo-ci
  to use a new OCaml version.
url: https://www.tunbury.org/2025/06/02/update-opam-repo-ci/
date: 2025-06-02T00:00:00-00:00
preview_image: https://www.tunbury.org/images/opam.png
authors:
- Mark Elvers
source:
ignore:
---

<p>This is a high-level view of the steps required to update <a href="https://opam.ci.ocaml.org">ocaml-repo-ci</a> to use a new OCaml version.</p>

<p><a href="https://github.com/ocurrent/opam-repo-ci">ocaml-repo-ci</a> uses Docker images as the container’s root file system. The <a href="https://images.ci.ocaml.org">base image builder</a> creates and maintains these images using <a href="https://github.com/ocurrent/ocaml-dockerfile">ocurrent/ocaml-dockerfile</a>. Both applications use the <a href="https://github.com/ocurrent/ocaml-version">ocurrent/ocaml-version</a> library as the definitive list of OCaml versions.</p>

<p>1. Update <a href="https://github.com/ocurrent/ocaml-version">ocurrent/ocaml-version</a></p>

<p>Create a PR for changes to <a href="https://github.com/ocurrent/ocaml-version/blob/master/ocaml_version.ml">ocaml_version.ml</a> with the details of the new release.</p>

<p>2. Create and publish a new release of <code class="language-plaintext highlighter-rouge">ocurrent/ocaml-version</code></p>

<p>Create the new release on GitHub and publish it to <code class="language-plaintext highlighter-rouge">ocaml/opam-repository</code> using <code class="language-plaintext highlighter-rouge">opam</code>, e.g.</p>

<div class="language-shell highlighter-rouge"><div class="highlight"><pre class="highlight"><code>opam publish <span class="nt">--tag</span> v4.0.1 https://github.com/ocurrent/ocaml-version/releases/download/v4.0.1/ocaml-version-4.0.1.tbz
</code></pre></div></div>

<p>3. Update <a href="https://github.com/ocurrent/docker-base-images">ocurrent/docker-base-images</a></p>

<p>The change required is to update the opam repository SHA in the <a href="https://github.com/ocurrent/docker-base-images/blob/master/Dockerfile">Dockerfile</a> to pick up the latest version of <a href="https://github.com/ocurrent/ocaml-version">ocurrent/ocaml-version</a>.</p>

<p>Run <code class="language-plaintext highlighter-rouge">dune runtest --auto-promote</code> to update the <code class="language-plaintext highlighter-rouge">builds.expected</code> file. Create a PR for these changes.</p>

<p>When the PR is pushed to the <code class="language-plaintext highlighter-rouge">live</code> branch <a href="https://deploy.ci.ocaml.org/?repo=ocurrent/docker-base-images&amp;">ocurrent-deployer</a> will pick up the change and deploy the new version.</p>

<p>4. Wait for the base images to build</p>

<p>The <a href="https://images.ci.ocaml.org">base image builder</a> refreshes the base images every seven days. Wait for the cycle to complete and the new images to be pushed to Docker Hub.</p>

<p>5. Update <a href="https://github.com/ocurrent/opam-repo-ci">ocurrent/opam-repo-ci</a></p>

<p>Update the opam repository SHA in the <a href="https://github.com/ocurrent/opam-repo-ci/blob/master/Dockerfile">Dockerfile</a>. Update the <a href="https://github.com/ocurrent/opam-repo-ci/blob/master/doc/platforms.md">doc/platforms.md</a> and <a href="https://github.com/ocurrent/opam-repo-ci/blob/master/test/specs.expected">test/specs.expected</a> using the following two commands.</p>

<div class="language-shell highlighter-rouge"><div class="highlight"><pre class="highlight"><code>dune build @doc
dune runtest <span class="nt">--auto-promote</span>
</code></pre></div></div>

<p>Create a PR for this update. When the PR is pushed to the <code class="language-plaintext highlighter-rouge">live</code> branch <a href="https://deploy.ci.ocaml.org/?repo=ocurrent/opam-repo-ci">ocurrent-deployer</a> will pick up the change and deploy the new version.</p>
