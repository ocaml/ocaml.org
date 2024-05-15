---
title: OPAM 1.1.0 released
description: After a while staged as RC, we are proud to announce the final release
  of OPAM 1.1.0! Thanks again to those who have helped testing and fixing the last
  few issues. Important note The repository format has been improved with incompatible
  new features; to account for this, the new repository is now ho...
url: https://ocamlpro.com/blog/2013_11_08_opam_1.1.0_released
date: 2013-11-08T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    Thomas Gazagnaire\n  "
source:
---

<p>After a while staged as RC, we are proud to announce the final release of
<em>OPAM 1.1.0</em>!</p>
<p>Thanks again to those who have helped testing and fixing the last few issues.</p>
<h2>Important note</h2>
<p>The repository format has been improved with incompatible new features; to
account for this, the <em>new</em> repository is now hosted at <a href="https://opam.ocaml.org">opam.ocaml.org</a>,
and the legacy repository at <a href="https://opam.ocamlpro.com">opam.ocamlpro.com</a> is kept to support OPAM
1.0 installations, but is unlikely to benefit from many package updates.
Migration to <a href="https://opam.ocaml.org">opam.ocaml.org</a> will be done automatically as soon as you
upgrade your OPAM version.</p>
<p>You're still free, of course, to use any third-party repositories instead or
in addition.</p>
<h2>Installing</h2>
<p>NOTE: When switching from 1.0, the internal state will need to be upgraded.
THIS PROCESS CANNOT BE REVERTED. We have tried hard to make it fault-
resistant, but failures might happen. In case you have precious data in your
<code>~/.opam</code> folder, it is advised to <strong>backup that folder before you upgrade
to 1.1.0</strong>.</p>
<p>Using the binary installer:</p>
<ul>
<li>download and run <code>https://github.com/ocaml/opam/blob/master/shell/opam_installer.sh</code>
</li>
</ul>
<p>Using the .deb packages from Anil's PPA (binaries are <a href="https://launchpad.net/~avsm/+archive/ppa/+builds?build_state=pending">currently syncing</a>):
add-apt-repository ppa:avsm/ppa
apt-get update
sudo apt-get install opam</p>
<p>For OSX users, the homebrew package will be updated shortly.</p>
<p>or build it from sources at :</p>
<ul>
<li><code>https://github.com/ocaml/opam/releases/tag/1.1.0</code>
</li>
</ul>
<h2>For those who haven't been paying attention</h2>
<p>OPAM is a source-based package manager for OCaml. It supports multiple
simultaneous compiler installations, flexible package constraints, and
a Git-friendly development workflow. OPAM is edited and
maintained by OCamlPro, with continuous support from OCamlLabs and the
community at large (including its main industrial users such as
Jane-Street and Citrix).</p>
<p>The 'official' package repository is now hosted at <a href="https://opam.ocaml.org">opam.ocaml.org</a>,
synchronised with the Git repository at
<a href="https://github.com/ocaml/opam-repository">http://github.com/ocaml/opam-repository</a>, where you can contribute
new packages descriptions. Those are under a CC0 license, a.k.a. public
domain, to ensure they will always belong to the community.</p>
<p>Thanks to all of you who have helped build this repository and made OPAM
such a success.</p>
<h2>Changes</h2>
<p>Too many to list here, see
<a href="https://raw.github.com/OCamlPro/opam/1.1.0/CHANGES">https://raw.github.com/OCamlPro/opam/1.1.0/CHANGES</a></p>
<p>For packagers, some new fields have appeared in the OPAM description format:</p>
<ul>
<li><code>depexts</code> provides facilities for dealing with system (non ocaml) dependencies
</li>
<li><code>messages</code>, <code>post-messages</code> can be used to notify the user eg. of licensing information,
or help her  troobleshoot at package installation.
</li>
<li><code>available</code> supersedes <code>ocaml-version</code> and <code>os</code> constraints, and can contain
more expressive formulas
</li>
</ul>
<p>Also, we have integrated the main package repository with Travis, which will
help us to improve the quality of contributions (see <a href="https://anil.recoil.org/2013/09/30/travis-and-ocaml.html">Anil's post</a>).</p>

