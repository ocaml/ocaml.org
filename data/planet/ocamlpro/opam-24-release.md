---
title: opam 2.4 release
description: Feedback on this post is welcomed on Discuss! We are extremely happy
  to announce the release of opam 2.4.0 and encourage all users to upgrade. Please
  read on for installation and upgrade instructions. Major changes On opam init the
  compiler chosen for the default switch will no longer be ocaml-syste...
url: https://ocamlpro.com/blog/2025_07_23_opam_2_4_release
date: 2025-07-23T15:25:34-00:00
preview_image: https://ocamlpro.com/assets/img/og_image_ocp_the_art_of_prog.png
authors:
- "\n    Raja Boujbel (OCamlPro)\n  "
source:
ignore:
---

<p><em>Feedback on this post is welcomed on <a href="https://discuss.ocaml.org/t/ann-opam-2-4-0-is-out/16989">Discuss</a>!</em></p>
<p>We are extremely happy to announce the release of opam 2.4.0 and encourage all users to upgrade.
Please read on for installation and upgrade instructions.</p>
<h2>Major changes</h2>
<ul>
<li>
<p>On <code>opam init</code> the compiler chosen for the default switch will no longer be <code>ocaml-system</code> (<a href="https://github.com/ocaml/opam/issues/3509">#3509</a>)
This was done because the system compiler (as-is your ocaml installed system wide, e.g. /usr/bin/ocaml) is known to be under-tested and prone to a variety of bugs and configuration issues.
Removing it from the default compiler allows new-comers a more smooth experience.
<em>Note: if you wish to use it anyway, you are always able to do it explicitly using <code>opam init --compiler=ocaml-system</code></em></p>
</li>
<li>
<p>GNU <code>patch</code> and the <code>diff</code> command are no longer runtime dependencies. Instead the OCaml <code>patch</code> library is used (<a href="https://github.com/ocaml/opam/issues/6019">#6019</a>, <a href="https://github.com/ocaml/opam/issues/6052">#6052</a>, <a href="https://github.com/ocaml/opam/issues/3782">#3782</a>, <a href="https://github.com/ocaml/setup-ocaml/pull/933">ocaml/setup-ocaml#933</a>)
Doing this we've removed some rarely used features of GNU Patch such as the support of <a href="https://www.gnu.org/software/diffutils/manual/html_node/Example-Context.html">Context diffs</a>.
The new implementation only supports <a href="https://www.gnu.org/software/diffutils/manual/html_node/Example-Unified.html">Unified diffs</a> including the <a href="https://git-scm.com/docs/diff-format">git extended headers</a>, however file permission changes via said extended headers have no effect.</p>
</li>
<li>
<p>Add Nix support for external dependencies (depexts) by adding support for stateless package managers (<a href="https://github.com/ocaml/opam/issues/5982">#5982</a>). <em>Thanks to <a href="https://github.com/RyanGibb">@RyanGibb</a> for this contribution</em></p>
</li>
<li>
<p>Fix <code>opam install &lt;local_dir&gt;</code> with and without options like <code>--deps-only</code> or <code>--show-action</code> having unexpected behaviours (<a href="https://github.com/ocaml/opam/issues/6248">#6248</a>, <a href="https://github.com/ocaml/opam/issues/5567">#5567</a>) such as:</p>
<ul>
<li>reporting <code>Nothing to do</code> despite dependencies or package not being up-to-date
</li>
<li>asking to install the wrong dependencies
</li>
</ul>
</li>
</ul>
<h2>UI changes</h2>
<ul>
<li>
<p><code>opam show</code> now displays the version number of packages flagged with <code>avoid-version</code>/<code>deprecated</code> gray (<a href="https://github.com/ocaml/opam/issues/6354">#6354</a>)</p>
</li>
<li>
<p><code>opam upgrade</code>: Do not show the message about packages "not up-to-date" when the package is tagged with <code>avoid-version</code>/<code>deprecated</code> (<a href="https://github.com/ocaml/opam/issues/6271">#6271</a>)</p>
</li>
<li>
<p>Fail when trying to pin a package whose definition could not be found instead of forcing interactive edition (e.g. this could happen when making a typo in the package name of a pin-depends) (<a href="https://github.com/ocaml/opam/issues/6322">#6322</a>)</p>
</li>
</ul>
<h2>New commands / options</h2>
<ul>
<li>
<p>Add <code>opam admin compare-versions</code> to compare package versions for sanity checks. <em>Thanks to <a href="https://github.com/mbarbin">@mbarbin</a> for this contribution</em></p>
</li>
<li>
<p>Add <code>opam lock --keep-local</code> to keep local pins url in <code>pin-depends</code> field (<a href="https://github.com/ocaml/opam/issues/4897">#4897</a>)</p>
</li>
<li>
<p>Add <code>opam admin migrate-extrafiles</code> which moves all <code>extra-files</code> of an existing opam repository into <code>extra-sources</code>. <em>Thanks to <a href="https://github.com/hannesm">@hannesm</a> for this contribution</em></p>
</li>
<li>
<p>The <code>-i</code>/<code>--ignore-test-doc</code> argument has been removed from <code>opam admin check</code> (<a href="https://github.com/ocaml/opam/issues/6335">#6335</a>)</p>
</li>
</ul>
<h2>Other noteworthy changes</h2>
<ul>
<li>
<p><code>opam pin</code>/<code>opam pin list</code> now displays the current revision of a pinned repository in a new column. <em>Thanks to <a href="https://github.com/desumn">@desumn</a> for this contribution</em></p>
</li>
<li>
<p>Symlinks in repositories are no longer supported (<a href="https://github.com/ocaml/opam/issues/5892">#5892</a>)</p>
</li>
<li>
<p>Fix sandboxing support in NixOS (<a href="https://github.com/ocaml/opam/issues/6333">#6333</a>)</p>
</li>
<li>
<p>Add the <code>OPAMSOLVERTOLERANCE</code> environment variable to allow users to fix solver timeouts for good (<a href="https://github.com/ocaml/opam/issues/3230">#3230</a>)</p>
</li>
<li>
<p>Fix a regression on <code>opam upgrade &lt;package&gt;</code> upgrading unrelated packages (<a href="https://github.com/ocaml/opam/issues/6373">#6373</a>). <em>Thanks to <a href="https://github.com/AltGr">@AltGr</a> for this contribution</em></p>
</li>
<li>
<p>Fix <code>pin-depends</code> for <code>with-*</code> dependencies when creating a lock file (<a href="https://github.com/ocaml/opam/issues/5428">#5428</a>)</p>
</li>
<li>
<p><code>opam admin check</code> now sets <code>with-test</code> and <code>with-doc</code> to <code>false</code> instead of <code>true</code></p>
</li>
<li>
<p>Add <code>apt-rpm</code>/ALTLinux family support for depexts. <em>Thanks to <a href="https://github.com/RiderALT">@RiderALT</a> for this contribution</em></p>
</li>
<li>
<p>Fix the detection of installed external packages on OpenBSD to not just consider manually installed packages (<a href="https://github.com/ocaml/opam/issues/6362">#6362</a>). <em>Thanks to <a href="https://github.com/semarie">@semarie</a> for this contribution</em></p>
</li>
<li>
<p>Disable the detection of available system packages on SUSE-based distributions (<a href="https://github.com/ocaml/opam/issues/6426">#6426</a>)</p>
</li>
</ul>
<p>ystem,dune,beginner,dev,new project</p>
<h2>Changes</h2>
<ul>
<li><code>opam switch create [name] &lt;version&gt;</code> will not include compiler packages flagged with <code>avoid-version</code>/<code>deprecated</code> in the generated invariant anymore (<a href="https://github.com/ocaml/opam/pull/6494">#6494</a>). This will allow opam to avoid the use of the <code>ocaml-system</code> package unless actually explicitly requested by the user. The opam experience when the <code>ocaml-system</code> compiler is used is known to be prone to a variety of bugs and configuration issues.
</li>
<li>Cygwin: Fallback to the existing <code>setup-x86_64.exe</code> if its upgrade failed to be fetched (<a href="https://github.com/ocaml/opam/issues/6495">#6495</a>, partial fix for <a href="https://github.com/ocaml/opam/issues/6474">#6474</a>)
</li>
<li>Fix a memory leak happening when running large numbers of commands or opening large number of opam files (<a href="https://github.com/ocaml/opam/issues/6484">#6484</a>). <em>Thanks to <a href="https://github.com/hannesm">@hannesm</a> for this contribution</em>
</li>
<li>Remove handling of the <code>OPAMSTATS</code> environment variable (<a href="https://github.com/ocaml/opam/pull/6485">#6485</a>). <em>Thanks to <a href="https://github.com/hannesm">@hannesm</a> for this contribution</em>
</li>
</ul>
<h2>Changes</h2>
<ul>
<li>Fixed some bugs in <code>opam install --deps-only</code> (and other commands simulating package pins, such as <code>--depext-only</code>) more visible in 2.4:
<ul>
<li>When a package <code>pkg</code> is already installed and <code>opam install ./pkg --deps</code> is called, if there is a conflict between the installed <code>pkg</code> dependencies and the definition of the local <code>pkg</code>, the conflict was not seen and the already installed <code>pkg</code> was kept (<a href="https://github.com/ocaml/opam/issues/6529">#6529</a>)
</li>
<li>No longer fetch and write the sources when simulating packages that were already pinned (<a href="https://github.com/ocaml/opam/issues/6532">#6532</a>)
</li>
<li>opam was triggering the reinstall of the package based on the already pinned packages instead of the expected newly simulated pinned packages (<a href="https://github.com/ocaml/opam/issues/6501">#6501</a>)
</li>
<li>opam was using the opam description of the wrong package in some cases (<a href="https://github.com/ocaml/opam/issues/6535">#6535</a>)
</li>
</ul>
</li>
<li>Change the behaviour of <code>--deps-only</code>, where it no longer requires unicity of package version between the request and the installed packages. In other words, if you have <code>pkg.1</code> installed, installing dependencies of <code>pkg.2</code> no longer removes <code>pkg.1</code>. This also allows to install dependencies of conflicting packages when their dependencies are compliant. (<a href="https://github.com/ocaml/opam/issues/6520">#6520</a>)
</li>
</ul>
<h3>Windows binary</h3>
<ul>
<li>Improve the prebuilt Windows binaries by including Cygwin's <code>setup-x86_64.exe</code> in the binary itself as fallback, in case <code>cygwin.com</code> is inaccessible (<a href="https://github.com/ocaml/opam/issues/6538">#6538</a>)
</li>
</ul>
<blockquote>
<p>NOTE: this article is cross-posted on opam.ocaml.org and ocamlpro.com.</p>
</blockquote>

