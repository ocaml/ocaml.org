---
title: opam-lib 1.3 available
description: opam-lib 1.3 The package for opam-lib version 1.3 has just been released
  in the official opam repository. There is no release of opam with version 1.3, but
  this is an intermediate version of the library that retains compatibility of the
  file formats with 1.2.2. The purpose of this release is twofold...
url: https://ocamlpro.com/blog/2016_11_20_opam_lib_1.3_available
date: 2016-11-20T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    Louis Gesbert\n  "
source:
---

<h2>opam-lib 1.3</h2>
<p>The package for opam-lib version 1.3 has just been released in the official
<code>opam</code> repository. There is no release of
<code>opam</code> with version 1.3, but this is an intermediate
version of the library that retains compatibility of the file formats with
1.2.2.</p>
<p>The purpose of this release is twofold:</p>
<ul>
<li><strong>provide some fixes and enhancements over opam-lib 1.2.2.</strong> For example, 1.3
has an enhanced <code>lint</code> function
</li>
<li><strong>be a step towards migration to opam-lib 2.0.</strong>
</li>
</ul>
<p><strong>This version is compatible with the current stable release of opam (1.2.2)</strong>,
but dependencies have been updated so that you are not (e.g.) stuck on an old
version of ocamlgraph.</p>
<p>Therefore, I encourage all maintainers of tools based on opam-lib to migrate to
1.3.</p>
<p>The respective APIs are available in html for
<a href="https://opam.ocaml.org/doc/1.2/api">1.2</a> and <a href="https://opam.ocaml.org/doc/1.3/api">1.3</a>.</p>
<blockquote>
<p><strong>A note on plugins</strong>: when you write opam-related tools, remember that by
setting <code>flags: plugin</code> in their definition and installing a binary named
<code>opam-toolname</code>, you will enable the users to install package <code>toolname</code> and
run your tool with a single <code>opam toolname</code> command.</p>
</blockquote>
<h3>Architectural changes</h3>
<p>If you need to migrate from 1.2 to 1.3, these tips may help:</p>
<ul>
<li>
<p>there are now 6 different ocamlfind sub-libraries instead of just 4: <code>format</code>
contains the handlers for opam types and file formats, has been split out from
the core library, while <code>state</code> handles the state of a given opam root and
switch and has been split from the <code>client</code> library.</p>
</li>
<li>
<p><code>OpamMisc</code> is gone and moved into the better organised <code>OpamStd</code>, with
submodules for <code>String</code>, <code>List</code>, etc.</p>
</li>
<li>
<p><code>OpamGlobals</code> is gone too, and its contents have been moved to:</p>
<ul>
<li><code>OpamConsole</code> for the printing, logging, and shell interface handling part
</li>
<li><code>OpamXxxConfig</code> modules for each of the libraries for handling the global
configuration variables. You should call the respective <code>init</code> functions,
with the options you want to set, for proper initialisation of the lib
options (and handling the <code>OPAMXXX</code> environment variables)
</li>
</ul>
</li>
<li>
<p><code>OpamPath.Repository</code> is now <code>OpamRepositoryPath</code>, and part of the
<code>repository</code> sub-library.</p>
</li>
</ul>
<h2>opam-lib 2.0 ?</h2>
<p>The development version of the opam-lib (<code>2.0~alpha5</code> as of writing) is already
available on opam. The name has been changed to provide a finer granularity, so
it can actually be installed concurrently -- but be careful not to confuse the
ocamlfind package names (<code>opam-lib.format</code> for 1.3 vs <code>opam-format</code> for 2.0).</p>
<p>The provided packages are:</p>
<ul>
<li><a href="https://opam.ocaml.org/packages/opam-file-format"><code>opam-file-format</code></a>: now
separated from the opam source tree, this has no dependencies and can be used
to parse and print the raw opam syntax.
</li>
<li><a href="https://opam.ocaml.org/packages/opam-core"><code>opam-core</code></a>: the basic toolbox
used by opam, which actually doesn't include the opam specific part. Includes
a tiny extra stdlib, the engine for running a graph of processes in parallel,
some system handling functions, etc. Depends on ocamlgraph and re only.
</li>
<li><a href="https://opam.ocaml.org/packages/opam-format"><code>opam-format</code></a>: defines opam
data types and their file i/o functions. Depends just on the two above.
</li>
<li><a href="https://opam.ocaml.org/packages/opam-core"><code>opam-solver</code></a>: opam's interface
with the <a href="https://opam.ocaml.org/packages/dose3">dose3</a> library and external
solvers.
</li>
<li><a href="https://opam.ocaml.org/packages/opam-repository"><code>opam-repository</code></a>: fetching
repositories and package sources from all handled remote types.
</li>
<li><a href="https://opam.ocaml.org/packages/opam-state"><code>opam-state</code></a>: handling of the
opam states, at the global, repository and switch levels.
</li>
<li><a href="https://opam.ocaml.org/packages/opam-client"><code>opam-client</code></a>: the client
library, providing the top-level operations (installing packages...), and CLI.
</li>
<li><a href="https://opam.ocaml.org/packages/opam-devel"><code>opam-devel</code></a>: this packages the
development version of the opam tool itself, for bootstrapping. You can
install it safely as it doesn't install the new <code>opam</code> in the PATH.
</li>
</ul>
<p>The new API can be also be <a href="https://opam.ocaml.org/doc/2.0/api">browsed</a> ;
please get in touch if you have trouble migrating.</p>

