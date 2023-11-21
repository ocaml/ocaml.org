---
title: Last stretch! Repository upgrade and opam 2.0.0 roadmap
description: A few days ago, we released opam 2.0.0~rc4, and explained that this final
  release candidate was expected be promoted to 2.0.0, in sync with an upgrade to
  the opam package repository. So here are the details about this! If you are an opam
  user, and don't maintain opam packages You are encouraged to u...
url: https://ocamlpro.com/blog/2018_08_02_last_stretch_repository_upgrade_and_opam_2.0.0_roadmap
date: 2018-08-02T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    Raja Boujbel\n  "
source:
---

<p>A few days ago, we released <a href="https://opam.ocaml.org/blog/opam-2-0-0-rc4/">opam 2.0.0~rc4</a>, and explained that this final release candidate was expected be promoted to 2.0.0, in sync with an upgrade to the <a href="https://github.com/ocaml/opam-repository">opam package repository</a>. So here are the details about this!</p>
<h2>If you are an opam user, and don't maintain opam packages</h2>
<ul>
<li>
<p>You are encouraged to <a href="https://opam.ocaml.org/blog/opam-2-0-0-rc4/">upgrade</a>) as soon as comfortable, and get used to the <a href="http://opam.ocaml.org/2.0-preview/doc/Upgrade_guide.html">changes and new features</a></p>
</li>
<li>
<p>All packages installing in opam 1.2.2 should exist and install fine on 2.0.0~rc4 (if you find one that doesn't, <a href="https://github.com/ocaml/opam/issues">please report</a>!)</p>
</li>
<li>
<p>If you haven't updated by <strong>September 17th</strong>, the amount of updates and new packages you receive may become limited<a href="https://ocamlpro.com/blog/feed#foot-1">&sup1;</a>.</p>
</li>
</ul>
<h2>So what will happen on September 17th ?</h2>
<ul>
<li>
<p>Opam 2.0.0~rc4 gets officially released as 2.0.0</p>
</li>
<li>
<p>On the <code>ocaml/opam-repository</code> Github repository, a 1.2 branch is forked, and the 2.0.0 branch is merged into the master branch</p>
</li>
<li>
<p>From then on, pull-requests to <code>ocaml/opam-repository</code> need to be in 2.0.0 format. Fixes to the 1.2 repository can be merged if important: pulls need to be requested against the 1.2 branch in that case.</p>
</li>
<li>
<p>The opam website shows the 2.0.0 repository by default (https://opam.ocaml.org/2.0-preview/ becomes https://opam.ocaml.org/)</p>
</li>
<li>
<p>The http repositories for 1.2 and 2.0 (as used by <code>opam update</code>) are accordingly moved, with proper redirections put in place</p>
</li>
</ul>
<h2>Advice for package maintainers</h2>
<ul>
<li>
<p>Until September 17th, pull-requests filed to the master branch of <code>ocaml/opam-repository</code> need to be in 1.2.2 format</p>
</li>
<li>
<p>The CI checks for all PRs ensure that the package passes on both 1.2.2 and 2.0.0. After the 17th of september, only 2.0.0 will be checked (and 1.2.2 only if relevant fixes are required).</p>
</li>
<li>
<p>The 2.0.0 branch of the repository will contain the automatically updated 2.0.0 version of your package definitions</p>
</li>
<li>
<p>You can publish 1.2 packages while using opam 2.0.0 by installing <code>opam-publish.0.3.5</code> (running <code>opam pin opam-publish 0.3.5</code> is recommended)</p>
</li>
<li>
<p>You should only need to keep an opam 1.2 installation for more complex setups (multiple packages, or if you need to be able to test the 1.2 package installations locally). In this case you might want to use an alias, <em>e.g.</em> <code>alias opam.1.2=&quot;OPAMROOT=$HOME/.opam.1.2 ~/local/bin/opam.1.2</code>. You should also probably disable opam 2.0.0's automatic environment update in that case (<code>opam init --disable-shell-hook</code>)</p>
</li>
<li>
<p><code>opam-publish.2.0.0~beta</code> has a fully revamped interface, and many new features, like filing a single PR for multiple packages. It files pull-request <strong>in 2.0 format only</strong>, however. At the moment, it will file PR only to the 2.0.0 branch of the repository, but pushing 1.2 format packages to master is still preferred until September 17th.</p>
</li>
<li>
<p>It is also advised to keep in-source opam files in 1.2 format until that date, so as not to break uses of <code>opam pin add --dev-repo</code> by opam 1.2 users. The small <code>opam-package-upgrade</code> plugin can be used to upgrade single 1.2 <code>opam</code> files to 2.0 format.</p>
</li>
<li>
<p><a href="https://github.com/ocaml/ocaml-ci-scripts"><code>ocaml-ci-script</code></a> already switched to opam 2.0.0. To keep testing opam 1.2.2, you can set the variable <code>OPAM_VERSION=1.2.2</code> in the <code>.travis.yml</code> file.</p>
</li>
</ul>
<h2>Advice for custom repository maintainers</h2>
<ul>
<li>
<p>The <code>opam admin upgrade</code> command can be used to upgrade your repository to 2.0.0 format. We recommand using it, as otherwise clients using opam 2.0.0 will do the upgrade locally every time. Add the option <code>--mirror</code> to continue serving both versions, with automatic redirects.</p>
</li>
<li>
<p>It's your place to decide when/if you want to switch your base repository to 2.0.0 format. You'll benefit from many new possibilities and safety features, but that will exclude users of earlier opam versions, as there is no backwards conversion tool.</p>
</li>
</ul>
<p><a>&sup1;</a> Sorry for the inconvenience. We'd be happy if we could keep maintaining the 1.2.2 repository for more time; repository maintainers are doing an awesome job, but just don't have the resources to maintain both versions in parallel.</p>

