---
title: opam 2.1.0~rc2 released
description: Feedback on this post is welcomed on Discuss! The opam team has great
  pleasure in announcing opam 2.1.0~rc2! The focus since beta4 has been preparing
  for a world with more than one released version of opam (i.e. 2.0.x and 2.1.x).
  The release candidate extends CLI versioning further and, under the ho...
url: https://ocamlpro.com/blog/2021_06_23_opam_2.1.0_rc2_released
date: 2021-06-23T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    David Allsopp (OCamlLabs)\n  "
source:
---

<p><em>Feedback on this post is welcomed on <a href="https://discuss.ocaml.org/t/ann-opam-2-1-0-rc2/8042">Discuss</a>!</em></p>
<p>The opam team has great pleasure in announcing opam 2.1.0~rc2!</p>
<p>The focus since beta4 has been preparing for a world with more than one released version of opam (i.e. 2.0.x and 2.1.x). The release candidate extends CLI versioning further and, under the hood, includes a big change to the opam root format which allows new versions of opam to indicate that the root may still be read by older versions of the opam libraries. A plugin compiled against the 2.0.9 opam libraries will therefore be able to read information about an opam 2.1 root (plugins and tools compiled against 2.0.8 are unable to load opam 2.1.0 roots).</p>
<p>Please do take this release candidate for a spin! It is available in the Docker images at ocaml/opam on <a href="https://hub.docker.com/r/ocaml/opam/tags">Docker Hub</a> as the opam-2.1 command (or you can <code>sudo ln -f /usr/bin/opam-2.1 /usr/bin/opam</code> in your <code>Dockerfile</code> to switch to it permanently). The release candidate can also be tested via our installation script (see the <a href="https://github.com/ocaml/opam/wiki/How-to-test-an-opam-feature#from-a-tagged-release-including-pre-releases">wiki</a> for more information).</p>
<p>Thank you to anyone who noticed the unannounced first release candidate and tried it out. Between tagging and what would have been announcing it, we discovered an issue with upgrading local switches from earlier alpha/beta releases, and so fixed that for this second release candidate.</p>
<p>Assuming no showstoppers, we plan to release opam 2.1.0 next week. The improvements made in 2.1.0 will allow for a much faster release cycle, and we look forward to posting about the 2.2.0 plans soon!</p>
<h2>Try it!</h2>
<p>In case you plan a possible rollback, you may want to first backup your
<code>~/.opam</code> directory.</p>
<p>The upgrade instructions are unchanged:</p>
<ol>
<li>Either from binaries: run
</li>
</ol>
<pre><code class="language-shell-session">bash -c &quot;sh &lt;(curl -fsSL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh) --version 2.1.0~rc2&quot;
</code></pre>
<p>or download manually from <a href="https://github.com/ocaml/opam/releases/tag/2.1.0-rc2">the Github &quot;Releases&quot; page</a> to your PATH.</p>
<ol start="2">
<li>Or from source, manually: see the instructions in the <a href="https://github.com/ocaml/opam/tree/2.1.0-rc2#compiling-this-repo">README</a>.
</li>
</ol>
<p>You should then run:</p>
<pre><code class="language-shell-session">opam init --reinit -ni
</code></pre>
<p>We hope there won't be any, but please report any issues to <a href="https://github.com/ocaml/opam/issues">the bug-tracker</a>.
Thanks for trying it out, and hoping you enjoy!</p>

