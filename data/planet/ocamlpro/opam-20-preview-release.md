---
title: opam 2.0 preview release!
description: We are pleased to announce a preview release for opam 2.0, with over
  700 patches since 1.2.2. Version 2.0~alpha4 has just been released, and is ready
  to be more widely tested. This version brings many new features and changes, the
  most notable one being that OCaml compiler packages are no longer spe...
url: https://ocamlpro.com/blog/2016_09_20_opam_2.0_preview_release
date: 2016-09-20T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    Louis Gesbert\n  "
source:
---

<p>We are pleased to announce a preview release for <code>opam</code> 2.0, with over 700
patches since <a href="https://opam.ocaml.org/blog/opam-1-2-2-release/">1.2.2</a>. Version
<a href="https://github.com/ocaml/opam/releases/2.0-alpha4">2.0~alpha4</a> has just been
released, and is ready to be more widely tested.</p>
<p>This version brings many new features and changes, the most notable one being
that OCaml compiler packages are no longer special entities, and are replaced
by standard package definition files. This in turn means that <code>opam</code> users have
more flexibility in how switches are managed, including for managing non-OCaml
environments such as <a href="http://coq.io/opam/">Coq</a> using the same familiar tools.</p>
<h2>A few highlights</h2>
<p>This is just a sample, see the full
<a href="https://github.com/ocaml/opam/blob/2.0-alpha4/CHANGES">changelog</a> for more:</p>
<ul>
<li>
<p><strong>Sandboxed builds:</strong> Command wrappers can be configured to, for example,
restrict permissions of the build and install processes using Linux
namespaces, or run the builds within Docker containers.</p>
</li>
<li>
<p><strong>Compilers as packages:</strong> This brings many advantages for <code>opam</code> workflows,
such as being able to upgrade the compiler in a given switch, better tooling for
local compilers, and the possibility to define <code>coq</code> as a compiler or even
use <code>opam</code> as a generic shell scripting engine with dependency tracking.</p>
</li>
<li>
<p><strong>Local switches:</strong> Create switches within your projects for easier
management. Simply run <code>opam switch create &lt;directory&gt; &lt;compiler&gt;</code> to get
started.</p>
</li>
<li>
<p><strong>Inplace build:</strong> Use <code>opam</code> to build directly from
your source directory. Ensure the package is pinned locally then run <code>opam install --inplace-build</code>.</p>
</li>
<li>
<p><strong>Automatic file tracking:</strong>: <code>opam</code> now tracks the files installed by packages
and is able to cleanly remove them when no existing files were modified.
The <code>remove:</code> field is now optional as a result.</p>
</li>
<li>
<p><strong>Configuration file:</strong> This can be used to direct choices at <code>opam init</code>
automatically (e.g. specific repositories, wrappers, variables, fetch
commands, or the external solver). This can be used to override all of <code>opam</code>'s
OCaml-related settings.</p>
</li>
<li>
<p><strong>Simpler library:</strong> the OCaml API is completely rewritten and should make it
much easier to write external tools and plugins. Existing tools will need to be
ported.</p>
</li>
<li>
<p><strong>Better error mitigation:</strong> Through clever ordering of the shell actions and
separation of <code>build</code> and <code>install</code>, most build failures can keep your current
installation intact, not resulting in removed packages anymore.</p>
</li>
</ul>
<h2>Roll out</h2>
<p>You are very welcome to try out the alpha, and report any issues. The repository
at <code>opam.ocaml.org</code> will remain in 1.2 format (with a 2.0 mirror at
<code>opam.ocaml.org/2.0~dev</code> in sync) until after the release is out, which means
the extensions can not be used there yet, but you are welcome to test on local
or custom repositories, or package pinnings. The reverse translation (2.0 to
1.2) is planned, to keep supporting 1.2 installations after that date.</p>
<p>The documentation for the new version is available at
http://opam.ocaml.org/doc/2.0/. This is still work in progress, so please do ask
if anything is unclear.</p>
<h2>Interface changes</h2>
<p>Commands <code>opam switch</code> and <code>opam list</code> have been rehauled for more consistency
and flexibility: the former won't implicitly create new switches unless called
with the <code>create</code> subcommand, and <code>opam list</code> now allows to combine filters and
finely specify the output format. They may not be fully backwards compatible, so
please check your scripts.</p>
<p>Most other commands have also seen fixes or improvements. For example, <code>opam</code>
doesn't forget about your set of installed packages on the first error, and the
new <code>opam install --restore</code> can be used to reinstall your selection after a
failed upgrade.</p>
<h2>Repository changes</h2>
<p>While users of <code>opam</code> 1.2 should feel at home with the changes, the 2.0 repository
and package formats are not compatible. Indeed, the move of the compilers to
standard packages implies some conversions, and updates to the relationships
between packages and their compiler. For example, package constraints like</p>
<pre><code class="language-shell-session">available: [ ocaml-version &gt;= &quot;4.02&quot; ]
</code></pre>
<p>are now written as normal package dependencies:</p>
<pre><code class="language-shell-session">depends: [ &quot;ocaml&quot; {&gt;= &quot;4.02&quot;} ]
</code></pre>
<p>To make the transition easier,</p>
<ul>
<li>upgrade of a custom repository is simply a matter of running <code>opam-admin upgrade-format</code> at its root;
</li>
<li>the official repository at <code>opam.ocaml.org</code> already has a 2.0 mirror, to which
you will be automatically redirected;
</li>
<li>packages definition are automatically converted when you pin a package.
</li>
</ul>
<p>Note that the <code>ocaml</code> package on the official repository is actually a wrapper
that depends on one of <code>ocaml-base-compiler</code>, <code>ocaml-system</code> or
<code>ocaml-variants</code>, which contain the different flavours of the actual compiler.
It is expected that it may only get picked up when requested by package
dependencies.</p>
<h2>Package format changes</h2>
<p>The <code>opam</code> package definition format is very similar to before, but there are
quite a few extensions and some changes:</p>
<ul>
<li>it is now mandatory to separate the <code>build:</code> and <code>install:</code> steps (this allows
tracking of installed files, better error recovery, and some optional security
features);
</li>
<li>the url and description can now optionally be included in the <code>opam</code> file
using the section <code>url {}</code> and fields <code>synopsis:</code> and <code>description:</code>;
</li>
<li>it is now possible to have dependencies toggled by globally-defined <code>opam</code>
variables (<em>e.g.</em> for a dependency needed on some OS only), or even rely on
the package information (<em>e.g.</em> have a dependency at the same version);
</li>
<li>the new <code>setenv:</code> field allows packages to export updates to environment
variables;
</li>
<li>custom fields <code>x-foo:</code> can be used for extensions and external tools;
</li>
<li>allow <code>&quot;&quot;&quot;</code> delimiters around unescaped strings
</li>
<li><code>&amp;</code> is now parsed with higher priority than <code>|</code>
</li>
<li>field <code>ocaml-version:</code> can no longer be used
</li>
<li>the <code>remove:</code> field should not be used anymore for simple cases (just removing
files)
</li>
</ul>
<h2>Let's go then -- how to try it ?</h2>
<p>First, be aware that you'll be prompted to update your <code>~/.opam</code> to 2.0 format
before anything else, so if you value it, make a backup. Or just export
<code>OPAMROOT</code> to test the alpha on a temporary opam root.</p>
<p>Packages for opam 2.0 are already in the opam repository, so if you have a
working opam installation of opam (at least 1.2.1), you can bootstrap as easily
as:</p>
<pre><code class="language-shell-session">opam install opam-devel
</code></pre>
<p>This doesn't install the new opam to your PATH within the current opam root for
obvious reasons, so you can manually install it as e.g. &quot;opam2&quot; using:</p>
<pre><code class="language-shell-session">sudo cp $(opam config var &quot;opam-devel:lib&quot;)/opam /usr/local/bin/opam2
</code></pre>
<p>You can otherwise install as usual:</p>
<ul>
<li>
<p>Using pre-built binaries (available for OSX and Linux x86, x86_64, armhf) and
our install script:</p>
<p>wget https://raw.github.com/ocaml/opam/2.0-alpha4-devel/shell/opam_installer.sh -O - | sh -s /usr/local/bin</p>
<p>Equivalently,
<a href="https://github.com/ocaml/opam/releases/2.0-alpha4">pick your version</a> and
download it to your PATH;</p>
</li>
<li>
<p>Building from our inclusive source tarball:
<a href="https://github.com/ocaml/opam/releases/download/2.0-alpha4/opam-full-2.0-alpha4.tar.gz">download here</a>
and build using <code>./configure &amp;&amp; make lib-ext &amp;&amp; make &amp;&amp; make install</code> if you
have OCaml &gt;= 4.01 already available, <code>make cold &amp;&amp; make install</code> otherwise;</p>
</li>
<li>
<p>Or from <a href="https://github.com/ocaml/opam/tree/2.0-alpha4">source</a>, following the
included instructions from the README. Some files have been moved around, so
if your build fails after you updated an existing git clone, try to clean it
up (<code>git clean -fdx</code>).</p>
</li>
</ul>

