---
title: OPAM 1.1.0 release candidate out
description: OPAM 1.1.0 is ready, and we are shipping a release candidate for packagers
  and all interested to try it out. This version features several bug-fixes over the
  September beta release, and quite a few stability and usability improvements. Thanks
  to all beta-testers who have taken the time to file repor...
url: https://ocamlpro.com/blog/2013_10_14_opam_1.1.0_release_candidate_out
date: 2013-10-14T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    Louis Gesbert\n  "
source:
---

<p><strong>OPAM 1.1.0 is ready</strong>, and we are shipping a release candidate for
packagers and all interested to try it out.</p>
<p>This version features several bug-fixes over the September beta release, and
quite a few stability and usability improvements. Thanks to all beta-testers
who have taken the time to file reports, and helped a lot tackling the
remaining issues.</p>
<h3>Repository change to opam.ocaml.org</h3>
<p>This release is synchronized with the migration of the main repository from
ocamlpro.com to ocaml.org. A redirection has been put in place, so that all
up-to-date installation of OPAM should be redirected seamlessly.
OPAM 1.0 instances will stay on the old repository, so that they won't be
broken by incompatible package updates.</p>
<p>We are very happy to see the impressive amount of contributions to the OPAM
repository, and this change, together with the licensing of all metadata under
CC0 (almost pubic domain), guarantees that these efforts belong to the
community.</p>
<h2>If you are upgrading from 1.0</h2>
<p>The internal state will need to be upgraded at the first run of OPAM 1.1.0.
THIS PROCESS CANNOT BE REVERTED. We have tried hard to make it fault-
resistant, but failures might happen. In case you have precious data in your
<code>~/.opam folder</code>, it is advised to <strong>backup that folder before you upgrade to 1.1.0</strong>.</p>
<h3>Installing</h3>
<p>Using the binary installer:</p>
<ul>
<li>download and run <code>https://github.com/ocaml/opam/blob/master/shell/opam_installer.sh</code>
</li>
</ul>
<p>You can also get the new version either from Anil's unstable PPA:</p>
<pre><code class="language-shell-session">add-apt-repository ppa:avsm/ppa-testing
apt-get update
sudo apt-get install opam
</code></pre>
<p>or build it from sources at :</p>
<ul>
<li><code>https://github.com/OCamlPro/opam/releases/tag/1.1.0-RC</code>
</li>
</ul>
<h3>Changes</h3>
<p>Too many to list here, see
<a href="https://raw.github.com/OCamlPro/opam/1.1.0-RC/CHANGES">https://raw.github.com/OCamlPro/opam/1.1.0-RC/CHANGES</a></p>
<p>For packagers, some new fields have appeared in the OPAM description format:</p>
<ul>
<li><code>depexts</code> provides facilities for dealing with system (non ocaml)
dependencies
</li>
<li><code>messages</code>, <code>post-messages</code> can be used to notify the user or help her troubleshoot at package installation.
</li>
<li><code>available</code> supersedes <code>ocaml-version</code> and <code>os</code> constraints, and can contain
more expressive formulas
</li>
</ul>

