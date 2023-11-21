---
title: opam 2.1.3 is released!
description: 'Feedback on this post is welcomed on Discuss! We are pleased to announce
  the minor release of opam 2.1.3. This opam release consists of backported fixes:
  Fix opam init and opam init --reinit when the jobs variable has been set in the
  opamrc or the current config. (#5056)

  opam var no longer fails if ...'
url: https://ocamlpro.com/blog/2022_08_12_opam_2.1.3_release
date: 2022-08-12T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    Raja Boujbel\n  "
source:
---

<p><em>Feedback on this post is welcomed on <a href="https://discuss.ocaml.org/t/ann-opam-2-1-3/10299">Discuss</a>!</em></p>
<p>We are pleased to announce the minor release of <a href="https://github.com/ocaml/opam/releases/tag/2.1.3">opam 2.1.3</a>.</p>
<p>This opam release consists of <a href="https://github.com/ocaml/opam/issues/5000">backported</a> fixes:</p>
<ul>
<li>Fix <code>opam init</code> and <code>opam init --reinit</code> when the <code>jobs</code> variable has been set in the opamrc or the current config. (<a href="https://github.com/ocaml/opam/issues/5056">#5056</a>)
</li>
<li><code>opam var</code> no longer fails if no switch is set (<a href="https://github.com/ocaml/opam/issues/5025">#5025</a>)
</li>
<li>Setting a variable with option <code>--switch &lt;sw&gt;</code> fails instead of writing an invalid <code>switch-config</code> file (<a href="https://github.com/ocaml/opam/issues/5027">#5027</a>)
</li>
<li>Handle external dependencies when updating switch state pin status (all pins), instead as a post pin action (only when called with <code>opam pin</code> (<a href="https://github.com/ocaml/opam/issues/5046">#5046</a>)
</li>
<li>Remove windows double printing on commands and their output (<a href="https://github.com/ocaml/opam/issues/4940">#4940</a>)
</li>
<li>Stop Zypper from upgrading packages on updates on OpenSUSE (<a href="https://github.com/ocaml/opam/issues/4978">#4978</a>)
</li>
<li>Clearer error message if a command doesn't exist (<a href="https://github.com/ocaml/opam/issues/4112">#4112</a>)
</li>
<li>Actually allow multiple state caches to co-exist (<a href="https://github.com/ocaml/opam/issues/4554">#4554</a>)
</li>
<li>Fix some empty conflict explanations (<a href="https://github.com/ocaml/opam/issues/4373">#4373</a>)
</li>
<li>Fix an internal error on admin repository upgrade from OPAM 1.2 (<a href="https://github.com/ocaml/opam/issues/4965">#4965</a>)
</li>
</ul>
<p>and improvements:</p>
<ul>
<li>When inferring a 2.1+ switch invariant from 2.0 base packages, don't filter out pinned packages as that causes very wide invariants for pinned compiler packages (<a href="https://github.com/ocaml/opam/issues/4501">#4501</a>)
</li>
<li>Some optimisations to <code>opam list --installable</code> queries combined with other filters (<a href="https://github.com/ocaml/opam/issues/4311">#4311</a>)
</li>
<li>Improve performance of some opam list combinations (e.g. <code>--available</code>, <code>--installable</code>) (<a href="https://github.com/ocaml/opam/issues/4999">#4999</a>)
</li>
<li>Improve performance of <code>opam list --conflicts-with</code> when combined with other filters (<a href="https://github.com/ocaml/opam/issues/4999">#4999</a>)
</li>
<li>Improve performance of <code>opam show</code> by as much as 300% when the package to show is given explicitly or is unique (<a href="https://github.com/ocaml/opam/issues/4997">#4997</a>)(<a href="https://github.com/ocaml/opam/issues/4172">#4172</a>)
</li>
<li>When a field is defined in switch and global scope, try to determine the scope also by checking switch selection (<a href="https://github.com/ocaml/opam/issues/5027">#5027</a>)
</li>
</ul>
<p>You can also find API changes in the <a href="https://github.com/ocaml/opam/releases/tag/2.1.3">release note</a>.</p>
<hr/>
<p>Opam installation instructions (unchanged):</p>
<ol>
<li>
<p>From binaries: run</p>
<pre><code class="language-shell-session">$ bash -c &quot;sh &lt;(curl -fsSL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh) --version 2.1.3&quot;
</code></pre>
<p>or download manually from <a href="https://github.com/ocaml/opam/releases/tag/2.1.3">the Github &quot;Releases&quot; page</a> to your PATH. In this case, don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed or to update you sandbox script.</p>
</li>
<li>
<p>From source, using opam:</p>
<pre><code class="language-shell-session">$ opam update; opam install opam-devel
</code></pre>
<p>(then copy the opam binary to your PATH as explained, and don't forget to run <code>opam init --reinit -ni</code> to enable sandboxing if you had version 2.0.0~rc manually installed or to update your sandbox script)</p>
</li>
<li>
<p>From source, manually: see the instructions in the <a href="https://github.com/ocaml/opam/tree/2.1.3#compiling-this-repo">README</a>.</p>
</li>
</ol>
<p>We hope you enjoy this new minor version, and remain open to <a href="https://github.com/ocaml/opam/issues">bug reports</a> and <a href="https://github.com/ocaml/opam/issues">suggestions</a>.</p>

