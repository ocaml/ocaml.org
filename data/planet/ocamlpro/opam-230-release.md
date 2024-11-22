---
title: opam 2.3.0 release!
description: Feedback on this post is welcomed on Discuss! As mentioned in our talk
  at the OCaml Workshop 2024, we decided to switch to a time-based release cycle (every
  6 months), starting with opam 2.3. As promised, we are very pleased to announce
  the release of opam 2.3.0, and encourage all users to upgrade. ...
url: https://ocamlpro.com/blog/2024_11_13_opam_2_3_0_releases
date: 2024-11-13T13:56:36-00:00
preview_image: https://ocamlpro.com/assets/img/og_image_ocp_the_art_of_prog.png
authors:
- "\n    Raja Boujbel - OCamlPro\n  "
source:
---

<p><em>Feedback on this post is welcomed on <a href="https://discuss.ocaml.org/t/ann-opam-2-3-0-is-out/15609">Discuss</a>!</em></p>
<p>As mentioned in <a href="https://icfp24.sigplan.org/details/ocaml-2024-papers/10/Opam-2-2-and-beyond">our talk at the OCaml Workshop 2024</a>,
we decided to switch to a time-based release cycle (every 6 months), starting with opam 2.3.</p>
<p>As promised, we are very pleased to announce the release of opam 2.3.0, and encourage all users to upgrade. Please read on for installation and upgrade instructions.</p>
<h2>Try it!</h2>
<p>In case you plan a possible rollback, you may want to first backup your
<code>~/.opam</code> or <code>$env:LOCALAPPDATAopam</code> directory.</p>
<p>The upgrade instructions are unchanged:</p>
<ol>
<li>Either from binaries: run
</li>
</ol>
<p>For Unix systems</p>
<pre><code class="language-shell-session">$ bash -c "sh &lt;(curl -fsSL https://opam.ocaml.org/install.sh)"
</code></pre>
<p>or from PowerShell for Windows systems</p>
<pre><code class="language-shell-session">Invoke-Expression "&amp; { $(Invoke-RestMethod https://opam.ocaml.org/install.ps1) }"
</code></pre>
<p>or download manually from <a href="https://github.com/ocaml/opam/releases/tag/2.3.0">the Github "Releases" page</a> to your PATH.</p>
<ol start="2">
<li>Or from source, manually: see the instructions in the <a href="https://github.com/ocaml/opam/tree/2.3.0#compiling-this-repo">README</a>.
</li>
</ol>
<p>You should then run:</p>
<pre><code class="language-shell-session">opam init --reinit -ni
</code></pre>
<h2>Major breaking change: extra-files</h2>
<p>When loading a repository, opam now ignores files in packages' <code>files/</code> directories which aren't listed in the <code>extra-files</code> field of the opam file.
This was done to simplify the opam specification where we hope the opam file to be the only thing that you have to look at when reading a package specification. It being optional to list all files in the <code>extra-files:</code> field went against that principle. This change also reduces the surface area for potential file corruption as all extra-files must have checksums.</p>
<p>This is a breaking change and means that if you are using the <code>files/</code> directory without listing them in the <code>extra-files:</code> field, you need to make sure that all files in that directory are included in the <code>extra-files</code> field.
The resulting opam file remains compatible with all previous opam 2.x releases.</p>
<p>If you have an opam repository, you should make sure all files are listed so every packages continues to work without any issue, which can be done automatically using the <code>opam admin update-extrafiles</code> command.</p>
<h2>Major changes</h2>
<ul>
<li>
<p>Packages requiring an unsupported version of opam are now marked unavailable, instead of causing a repository error. This means an opam repository can now allow smoother upgrade in the future where some packages can require a newer version of opam without having to fork the repository to upgrade every package to that version as was done for the upgrade from opam 1.2 to 2.0</p>
</li>
<li>
<p>Add a new <code>opam list --latests-only</code> option to list only the latest versions of packages. Note that this option respects the order options were given on the command line. For example: <code>--available --latests-only</code> will first list all the available packages, then choose only the latest packages in that set; while <code>--latests-only --available</code> will first list all the latest packages, then only show the ones that are available in that set</p>
</li>
<li>
<p>Fix and improve <code>opam install --check</code>, which now checks if the whole dependency tree of the package is installed instead of only the root dependencies</p>
</li>
<li>
<p>Add a new <code>--verbose-on</code> option to enable verbose output for specified package names. <em>Thanks to <a href="https://github.com/desumn">@desumn</a> for this contribution</em></p>
</li>
<li>
<p>Add a new <code>opam switch import --deps-only</code> option to install only the dependencies of the root packages listed in the opam switch export file</p>
</li>
<li>
<p><code>opam switch list-available</code> no longer displays compilers flagged with <code>avoid-version</code>/<code>deprecated</code> unless <code>--all</code> is given, meaning that pre-release or unreleased OCaml packages no longer appear to be the latest version</p>
</li>
<li>
<p><code>opam switch create --repositories</code> now correctly infers <code>--kind=git</code> for URLs ending with <code>.git</code> rather than requiring the <code>git+https://</code> protocol. This is consistant with other commands such as <code>opam repository add</code>. <em>Thanks to <a href="https://github.com/Keryan-dev">@Keryan-dev</a> for this contribution</em></p>
</li>
<li>
<p><code>opam switch set-invariant</code> now displays the switch invariant using the same syntax as the <code>--formula</code> flag</p>
</li>
<li>
<p>The <code>builtin-0install</code> solver was improved and should now be capable of being your default solver instead of <code>builtin-mccs+glpk</code>. It was previously mostly only suited for automated tasks such as Continuous Integration. If you wish to give it a try, simply calling <code>opam option solver=builtin-0install</code> (call <code>opam option solver=</code> restores the default)</p>
</li>
<li>
<p>Most of the unhelpful conflict messages were fixed. (<a href="https://github.com/ocaml/opam/issues/4373">#4373</a>)</p>
</li>
<li>
<p>Fix an opam 2.1 regression where the initial pin of a local VCS directory would store untracked and ignored files.
Those files would usually be cleaned before building the package, however git submodules would not be cleaned and would cause issues when paired with the new behaviour added in 2.3.0~alpha1 which makes opam error when git submodules fail to update (it was previously a warning). (<a href="https://github.com/ocaml/opam/issues/5809">#5809</a>)</p>
</li>
<li>
<p>Fix the value of the <code>arch</code> variable when the current OS is 32bit on a 64bit machine (e.g. Raspberry Pi OS). (<a href="https://github.com/ocaml/opam/issues/5949">#5949</a>)</p>
</li>
<li>
<p>opam now fails when git submodules fail to update instead of ignoring the error and just showing a warning</p>
</li>
<li>
<p>opam's libraries now compile with OCaml &gt;= 5.0 on Windows</p>
</li>
<li>
<p>Fix the installed packages internal cache, which was storing the wrong version of the opam file after a build failure.
This could be triggered easily for users with custom repositories with non-populated extra-files. (<a href="https://github.com/ocaml/opam/pull/6213">#6213</a>)</p>
</li>
<li>
<p>Several improvements to the pre-built release binaries were made:</p>
<ul>
<li>The Linux binaries are now built on Alpine 3.20
</li>
<li>The FreeBSD binary is now built on FreeBSD 14.1
</li>
<li>The OpenBSD binary is now built on OpenBSD 7.6 and loses support for OpenBSD 7.5 and earlier
</li>
<li>Linux/riscv64 and NetBSD/x86_64 binaries are now available
</li>
</ul>
</li>
</ul>
<p>And many other general, performance and UI improvements were made and bugs were fixed.
You can take a look to previous blog posts.
API changes and a more detailed description of the changes are listed in:</p>
<ul>
<li><a href="https://github.com/ocaml/opam/releases/tag/2.3.0-alpha1">the release note for 2.3.0~alpha1</a>
</li>
<li><a href="https://github.com/ocaml/opam/releases/tag/2.3.0-beta1">the release note for 2.3.0~beta1</a>
</li>
<li><a href="https://github.com/ocaml/opam/releases/tag/2.3.0-beta2">the release note for 2.3.0~beta2</a>
</li>
<li><a href="https://github.com/ocaml/opam/releases/tag/2.3.0-rc1">the release note for 2.3.0~rc1</a>
</li>
<li><a href="https://github.com/ocaml/opam/releases/tag/2.3.0">the release note for 2.3.0</a>
</li>
</ul>
<p>This release also includes PRs improving the documentation and improving
and extending the tests.</p>
<p>Please report any issues to <a href="https://github.com/ocaml/opam/issues">the bug-tracker</a>.</p>
<p>We hope you will enjoy the new features of opam 2.3!</p>

