---
title: opam 2.0.0 Release Candidate 1 is out!
description: We are pleased to announce a first release candidate for the long-awaited
  opam 2.0.0. A lot of polishing has been done since the last beta, including tweaks
  to the built-in solver, allowing in-source package definitions to be gathered in
  an opam/ directory, and much more. With all of the 2.0.0 featu...
url: https://ocamlpro.com/blog/2018_02_02_opam_2.0.0_release_candidate_1_is_out
date: 2018-02-02T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    Louis Gesbert\n  "
source:
---

<p>We are pleased to announce a first release candidate for the long-awaited opam 2.0.0.</p>
<p>A lot of polishing has been done since the <a href="https://opam.ocaml.org/blog/opam-2-0-beta5/">last beta</a>, including tweaks to the built-in solver, allowing in-source package definitions to be gathered in an <code>opam/</code> directory, and much more.</p>
<p>With all of the 2.0.0 features getting pretty solid, we are now focusing on bringing all the guides up-to-date<a href="https://ocamlpro.com/blog/feed#foot-1">&sup1;</a>, updating the tools and infrastructure, making sure there are no usability issues with the new workflows, and being future-proof so that further updates break as little as possible.</p>
<p>You are invited to read the <a href="https://opam.ocaml.org/blog/opam-2-0-beta5/">beta5 announcement</a> for details on the 2.0.0 features. Installation instructions haven't changed:</p>
<ol>
<li>From binaries: run
</li>
</ol>
<pre><code class="language-shell-session">sh &lt;(curl -sL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)
</code></pre>
<p>or download manually from <a href="https://github.com/ocaml/opam/releases/tag/2.0.0-rc">the Github &quot;Releases&quot; page</a> to your PATH.</p>
<ol start="2">
<li>From source, using opam:
</li>
</ol>
<pre><code class="language-shell-session">opam update; opam install opam-devel
</code></pre>
<p>(then copy the opam binary to your PATH as explained)</p>
<ol start="3">
<li>From source, manually: see the instructions in the <a href="https://github.com/ocaml/opam/tree/2.0.0-rc#opam---a-package-manager-for-ocaml">README</a>.
</li>
</ol>
<p>Thanks a lot for testing out the RC and <a href="https://github.com/ocaml/opam/issues">reporting</a> any issues you may find. See <a href="https://opam.ocaml.org/blog/opam-2-0-beta5/#What-we-need-tested">what we need tested</a> for more detail.</p>
<hr/>
<p><a>&sup1;</a> You can at the moment rely on the <a href="http://opam.ocaml.org/doc/2.0/man/opam.html">manpages</a>, the <a href="http://opam.ocaml.org/doc/2.0/Manual.html">Manual</a>, and of course the <a href="http://opam.ocaml.org/doc/2.0/api/">API</a>, but other pages might be outdated.</p>

