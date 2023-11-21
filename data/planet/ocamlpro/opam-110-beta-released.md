---
title: OPAM 1.1.0 beta released
description: We are very happy to announce the beta release of OPAM version 1.1.0!
  OPAM is a source-based package manager for OCaml. It supports multiple simultaneous
  compiler installations, flexible package constraints, and a Git-friendly development
  workflow which. OPAM is edited and maintained by OCamlPro, wi...
url: https://ocamlpro.com/blog/2013_09_20_opam_1.1.0_beta_released
date: 2013-09-20T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    Thomas Gazagnaire\n  "
source:
---

<p>We are very happy to announce the <strong>beta release</strong> of OPAM version 1.1.0!</p>
<p>OPAM is a source-based package manager for OCaml. It supports multiple
simultaneous compiler installations, flexible package constraints, and
a Git-friendly development workflow which. OPAM is edited and
maintained by OCamlPro, with continuous support from OCamlLabs and the
community at large (including its main industrial users such as
Jane-Street and Citrix).</p>
<p>Since its first official release <a href="https://ocamlpro.com/blog/2013_03_15_opam_1.0.0_released">last March</a>, we have fixed many
bugs and added lots of <a href="https://github.com/OCamlPro/opam/issues?milestone=17&amp;page=1&amp;state=closed">new features and stability improvements</a>. New
features go from more metadata to the package and compiler
descriptions, to improved package pin workflow, through a much faster
update algorithm. The full changeset is included below.</p>
<p>We are also delighted to see the growing number of contributions from
the community to both OPAM itself (35 contributors) and to its
metadata repository (100+ contributors, 500+ unique packages, 1500+
packages). It is really great to also see alternative metadata
repositories appearing in the wild (see for instance the repositories
for <a href="https://github.com/vouillon/opam-android-repository">Android</a>, <a href="https://github.com/vouillon/opam-windows-repository">Windows</a> and <a href="https://github.com/search?q=opam-repo&amp;type=Repositories&amp;ref=searchresults">so on</a>). To be sure that the
community efforts will continue to benefit to everyone and to
underline our committment to OPAM, we are rehousing it at
<code>http://opam.ocaml.org</code> and switching the license to CC0 (see <a href="https://github.com/OCamlPro/opam-repository/issues/955">issue #955</a>,
where 85 people are commenting on the thread).</p>
<p>The binary installer has been updated for OSX and x86_64:</p>
<ul>
<li><code>https://github.com/ocaml/opam/blob/master/shell/opam_installer.sh</code>
</li>
</ul>
<p>You can also get the new version either from Anil's unstable PPA:
add-apt-repository ppa:avsm/ppa-testing
apt-get update
sudo apt-get install opam</p>
<p>or build it from sources at :</p>
<ul>
<li><code>https://github.com/OCamlPro/opam/releases/tag/1.1.0-beta</code>
</li>
</ul>
<p>NOTE: If you upgrade from OPAM 1.0, the first time you will run the
new <code>opam</code> binary it will upgrade its internal state in an incompatible
way: THIS PROCESS CANNOT BE REVERTED. We have tried hard to make this
process fault-resistant, but failures might happen. In case you have
precious data in your <code>~/.opam</code> folder, it is advised to <strong>backup that
folder before you upgrade to 1.1</strong>.</p>
<h2>Changes</h2>
<ul>
<li>Automatic backup before any operation which might alter the list of installed packages
</li>
<li>Support for arbitrary sub-directories for metadata repositories
</li>
<li>Lots of colors
</li>
<li>New option <code>opam update -u</code> equivalent to <code>opam update &amp;&amp; opam upgrade --yes</code>
</li>
<li>New <code>opam-admin</code> tool, bundling the features of <code>opam-mk-repo</code> and
<code>opam-repo-check</code> + new 'opam-admin stats' tool
</li>
<li>New <code>available</code>: field in opam files, superseding <code>ocaml-version</code> and <code>os</code> fields
</li>
<li>Package names specified on the command-line are now understood
case-insensitively (#705)
</li>
<li>Fixed parsing of malformed opam files (#696)
</li>
<li>Fixed recompilation of a package when uninstalling its optional dependencies (#692)
</li>
<li>Added conditional post-messages support, to help users when a package fails to
install for a known reason (#662)
</li>
<li>Rewrite the code which updates pin et dev packages to be quicker and more reliable
</li>
<li>Add {opam,url,desc,files/} overlay for all packages
</li>
<li><code>opam config env</code> now detects the current shell and outputs a sensible default if
no override is provided.
</li>
<li>Improve <code>opam pin</code> stability and start display information about dev revisions
</li>
<li>Add a new <code>man</code> field in <code>.install</code> files
</li>
<li>Support hierarchical installation in <code>.install</code> files
</li>
<li>Add a new <code>stublibs</code> field in <code>.install</code> files
</li>
<li>OPAM works even when the current directory has been deleted
</li>
<li>speed-up invocation of <code>opam config var VARIABLE</code> when variable is simple
(eg. <code>prefix</code>, <code>lib</code>, ...)
</li>
<li><code>opam list</code> now display only the installed packages. Use <code>opam list -a</code> to get
the previous behavior.
</li>
<li>Inverse the depext tag selection (useful for <code>ocamlot</code>)
</li>
<li>Add a <code>--sexp</code> option to <code>opam config env</code> to load the configuration under emacs
</li>
<li>Purge <code>~/.opam/log</code> on each invocation of OPAM
</li>
<li>System compiler with versions such as <code>version+patches</code> are now handled as if this
was simply <code>version</code>
</li>
<li>New <code>OpamVCS</code> functor to generate OPAM backends
</li>
<li>More efficient <code>opam update</code>
</li>
<li>Switch license to LGPL with linking exception
</li>
<li><code>opam search</code> now also searches through the tags
</li>
<li>minor API changes for <code>API.list</code> and <code>API.SWITCH.list</code>
</li>
<li>Improve the syntax of filters
</li>
<li>Add a <code>messages</code> field
</li>
<li>Add a <code>--jobs</code> command line option and add <code>%{jobs}%</code> to be used in OPAM files
</li>
<li>Various improvements in the solver heuristics
</li>
<li>By default, turn-on checking of certificates for downloaded dependency archives
</li>
<li>Check the md5sum of downloaded archives when compiling OPAM
</li>
<li>Improved <code>opam info</code> command (more information, non-zero error code when no patterns match)
</li>
<li>Display OS and OPAM version on internal errors to ease error reporting
</li>
<li>Fix <code>opam reinstall</code> when reinstalling a package wich is a dependency of installed packages
</li>
<li>Export and read <code>OPAMSWITCH</code> to be able to call OPAM in different switches
</li>
<li><code>opam-client</code> can now be used in a toplevel
</li>
<li><code>-n</code> now means <code>--no-setup</code> and not <code>--no-checksums</code> anymore
</li>
<li>Fix support of FreeBSD
</li>
<li>Fix installation of local compilers with local paths endings with <code>../ocaml/</code>
</li>
<li>Fix the contents of <code>~/.opam/opam-init/variable.sh</code> after a switch
</li>
</ul>

