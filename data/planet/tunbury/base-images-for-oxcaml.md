---
title: Base images for OxCaml
description: As @dra27 suggested, I first added support in ocurrent/ocaml-version.
  I went with the name flambda2, which matched the name in the opam package.
url: https://www.tunbury.org/2025/06/10/oxcaml-base-images/
date: 2025-06-10T00:00:00-00:00
preview_image: https://www.tunbury.org/images/ocaml-logo.png
authors:
- Mark Elvers
source:
ignore:
---

<p>As @dra27 suggested, I first added support in <a href="https://github.com/ocurrent/ocaml-version.git">ocurrent/ocaml-version</a>. I went with the name <code class="language-plaintext highlighter-rouge">flambda2</code>, which matched the name in the <code class="language-plaintext highlighter-rouge">opam</code> package.</p>

<p>Wherever I found the type <code class="language-plaintext highlighter-rouge">Flambda</code>, I added <code class="language-plaintext highlighter-rouge">Flambda2</code>. I added a list of OxCaml versions in the style of the unreleased betas and a function <code class="language-plaintext highlighter-rouge">is_oxcaml</code> to test if the variant is of type <code class="language-plaintext highlighter-rouge">Flambda2</code>, closely following the <code class="language-plaintext highlighter-rouge">is_multicore</code> design! The final change was to <code class="language-plaintext highlighter-rouge">additional_packages</code> concatenated <code class="language-plaintext highlighter-rouge">ocaml-options-only-</code> to <code class="language-plaintext highlighter-rouge">flambda2</code> - again, this change was also needed for multicore.</p>

<p>It was a relatively minor change to the base-image-builder, adding <code class="language-plaintext highlighter-rouge">Ocaml_version.Releases.oxcaml</code> to the available switches on AMD64 and ARM64. Following the precedent set by <code class="language-plaintext highlighter-rouge">maybe_add_beta</code> and <code class="language-plaintext highlighter-rouge">maybe_add_multicore</code>, I added <code class="language-plaintext highlighter-rouge">maybe_add_jst</code>, which added the Jane Street opam repository for these builds.</p>

<p>The builds mostly failed because they depended on <code class="language-plaintext highlighter-rouge">autoconf,</code> which isn’t included by default on most distributions. Looking in the <code class="language-plaintext highlighter-rouge">dockerfile</code>, there is a function called <code class="language-plaintext highlighter-rouge">ocaml_depexts</code>, which includes <code class="language-plaintext highlighter-rouge">zstd</code> for OCaml &gt; 5.1.0. I extended this function to include <code class="language-plaintext highlighter-rouge">autoconf</code> when building OxCaml.</p>

<p>The Arch Linux builds failed due to missing <code class="language-plaintext highlighter-rouge">which</code>, so I added this as I did for <code class="language-plaintext highlighter-rouge">autoconf</code></p>

<p>The following are working:</p>

<ul>
  <li>Ubuntu 24.10, 24.04, 22.04</li>
  <li>OpenSUSE Tumbleweed</li>
  <li>Fedora 42, 41</li>
  <li>Debian Unstable, Testing, 12</li>
  <li>Arch</li>
</ul>

<p>Failures</p>

<ul>
  <li>Alpine 3.21
    <ul>
      <li>missing <code class="language-plaintext highlighter-rouge">linux/auxvec.h</code> header</li>
    </ul>
  </li>
  <li>OpenSUSE 15.6
    <ul>
      <li>autoconf is too old in the distribution</li>
    </ul>
  </li>
  <li>Debian 11
    <ul>
      <li>autoconf is too old in the distribution</li>
    </ul>
  </li>
  <li>Oracle Linux 9, 8
    <ul>
      <li>autoconf is too old in the distribution</li>
    </ul>
  </li>
</ul>

<p>There is some discussion about whether building these with the <a href="https://images.ci.ocaml.org">base image builder</a> is the best approach, so I won’t create PRs at this time. My branches are:</p>
<ul>
  <li><a href="https://github.com/mtelvers/ocaml-version.git">https://github.com/mtelvers/ocaml-version.git</a></li>
  <li><a href="https://github.com/mtelvers/ocaml-dockerfile.git#oxcaml">https://github.com/mtelvers/ocaml-dockerfile.git#oxcaml</a></li>
  <li><a href="https://github.com/mtelvers/docker-base-images#oxcaml">https://github.com/mtelvers/docker-base-images#oxcaml</a></li>
</ul>
