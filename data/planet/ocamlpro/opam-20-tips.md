---
title: opam 2.0 tips
description: This blog post looks back on some of the improvements in opam 2.0, and
  gives tips on the new workflows available. Package development environment management
  Opam 2.0 has been vastly improved to handle locally defined packages. Assuming you
  have a project ~/projects/foo, defining two packages foo-lib...
url: https://ocamlpro.com/blog/2019_03_12_opam_2.0_tips
date: 2019-03-12T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    Louis Gesbert\n  "
source:
---

<p>This blog post looks back on some of the improvements in opam 2.0, and gives
tips on the new workflows available.</p>
<h2>Package development environment management</h2>
<p>Opam 2.0 has been vastly improved to handle locally defined packages. Assuming
you have a project <code>~/projects/foo</code>, defining two packages <code>foo-lib</code> and
<code>foo-bin</code>, you would have:</p>
<pre><code class="language-shell-session">~/projects/foo
|-- foo-lib.opam
|-- foo-bin.opam
`-- src/ ...
</code></pre>
<p>(See also about
<a href="https://ocamlpro.com/opam-extended-dependencies/#Computed-versions">computed dependency constraints</a>
for handling multiple package definitions with mutual constraints)</p>
<h3>Automatic pinning</h3>
<p>The underlying mechanism is the same, but this is an interface improvement that
replaces most of the opam 1.2 workflows based on <code>opam pin</code>.</p>
<p>The usual commands (<code>install</code>, <code>upgrade</code>, <code>remove</code>, etc.) have been extended to
support specifying a directory as argument. So when working on project <code>foo</code>,
just write:</p>
<pre><code class="language-shell-session">cd ~/projects/foo
opam install .
</code></pre>
<p>and both <code>foo-lib</code> and <code>foo-bin</code> will get automatically pinned to the current
directory (using git if your project is versioned), and installed. You may
prefer to use:</p>
<pre><code class="language-shell-session">opam install . --deps-only
</code></pre>
<p>to just get the package dependencies ready before you start hacking on it.
<a href="https://ocamlpro.com/blog/feed#Reproducing-build-environments">See below</a> for details on how to reproduce a
build environment more precisely. Note that <code>opam depext .</code> will not work at the
moment, which will be fixed in the next release when the external dependency
handling is integrated (opam will still list you the proper packages to install
for your OS upon failure).</p>
<p>If your project is versioned and you made changes, remember to either commit, or
add <code>--working-dir</code> so that your uncommitted changes are taken into account.</p>
<h2>Local switches</h2>
<blockquote>
<p>Opam 2.0 introduced a new feature called &quot;local switches&quot;. This section
explains what it is about, why, when and how to use them.</p>
</blockquote>
<p>Opam <em>switches</em> allow to maintain several separate development environments,
each with its own set of packages installed. This is particularly useful when
you need different OCaml versions, or for working on projects with different
dependency sets.</p>
<p>It can sometimes become tedious, though, to manage, or remember what switch to
use with what project. Here is where &quot;local switches&quot; come in handy.</p>
<h3>How local switches are handled</h3>
<p>A local switch is simply stored inside a <code>_opam/</code> directory, and will be
selected automatically by opam whenever your current directory is below its
parent directory.</p>
<blockquote>
<p>NOTE: it's highly recommended that you enable the new <em>shell hooks</em> when using
local switches. Just run <code>opam init --enable-shell-hook</code>: this will make sure
your PATH is always set for the proper switch.</p>
<p>You will otherwise need to keep remembering to run <code>eval $(opam env)</code> every
time you <code>cd</code> to a directory containing a local switch. See also
<a href="http://opam.ocaml.org/doc/Tricks.html#Display-the-current-quot-opam-switch-quot-in-the-prompt">how to display the current switch in your prompt</a></p>
</blockquote>
<p>For example, if you have <code>~/projects/foo/_opam</code>, the switch will be selected
whenever in project <code>foo</code>, allowing you to tailor what it has installed for the
needs of your project.</p>
<p>If you remove the switch dir, or your whole project, opam will forget about it
transparently. Be careful not to move it around, though, as some packages still
contain hardcoded paths and don't handle relocation well (we're working on
that).</p>
<h3>Creating a local switch</h3>
<p>This can generally start with:</p>
<pre><code class="language-shell-session">cd ~/projects/foo
opam switch create . --deps-only
</code></pre>
<p>Local switch handles are just their path, instead of a raw name. Additionally,
the above will detect package definitions present in <code>~/projects/foo</code>, pick a
compatible version of OCaml (if you didn't explicitely mention any), and
automatically install all the local package dependencies.</p>
<p>Without <code>--deps-only</code>, the packages themselves would also get installed in the
local switch.</p>
<h3>Using an existing switch</h3>
<p>If you just want an already existing switch to be selected automatically,
without recompiling one for each project, you can use <code>opam switch link</code>:</p>
<pre><code class="language-shell-session">cd ~/projects/bar
opam switch link 4.07.1
</code></pre>
<p>will make sure that switch <code>4.07.1</code> is chosen whenever you are in project <code>bar</code>.
You could even link to <code>../foo</code> here, to share <code>foo</code>'s local switch between the
two projects.</p>
<h2>Reproducing build environments</h2>
<h4>Pinnings</h4>
<p>If your package depends on development versions of some dependencies (e.g. you
had to push a fix upstream), add to your opam file:</p>
<pre><code class="language-shell-session">depends: [ &quot;some-package&quot; ] # Remember that pin-depends are depends too
pin-depends: [
  [ &quot;some-package.version&quot; &quot;git+https://gitfoo.com/blob.git#mybranch&quot; ]
]
</code></pre>
<p>This will have no effect when your package is published in a repository, but
when it gets pinned to its dev version, opam will first make sure to pin
<code>some-package</code> to the given URL.</p>
<h4>Lock-files</h4>
<p>Dependency contraints are sometimes too wide, and you don't want to explore all
the versions of your dependencies while developing. For this reason, you may
want to reproduce a known-working set of dependencies. If you use:</p>
<pre><code class="language-shell-session">opam lock .
</code></pre>
<p>opam will check what version of the dependencies are installed in your current
switch, and explicit them in <code>*.opam.locked</code> files. <code>opam lock</code> is a plugin at
the moment, but will get automatically installed when needed.</p>
<p>Then, assuming you checked these files into version control, any user can do</p>
<pre><code class="language-shell-session">opam install . --deps-only --locked
</code></pre>
<p>to instruct opam to reproduce the same build environment (the <code>--locked</code> option
is also available to <code>opam switch create</code>, to make things easier).</p>
<p>The generated lock-files will also contain added constraints to reproduce the
presence/absence of optional dependencies, and reproduce the appropriate
dependency pins using <code>pin-depends</code>. Add the <code>--direct-only</code> option if you don't
want to enforce the versions of all recursive dependencies, but only direct
ones.</p>

