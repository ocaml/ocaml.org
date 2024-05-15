---
title: 'new opam features: local switches'
description: Among the areas we wanted to improve on for opam 2.0 was the handling
  of switches. In opam 1.2, they are simply accessed by a name (the OCaml version
  by default), and are always stored into ~/.opam/<name>. This is fine, but can get
  a bit cumbersome when many switches are in presence, as there is no ...
url: https://ocamlpro.com/blog/2017_04_27_new_opam_features_local_switches
date: 2017-04-27T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    Louis Gesbert\n  "
source:
---

<p>Among the areas we wanted to improve on for opam 2.0 was the handling of
<em>switches</em>. In opam 1.2, they are simply accessed by a name (the OCaml version
by default), and are always stored into <code>~/.opam/&lt;name&gt;</code>. This is fine, but can
get a bit cumbersome when many switches are in presence, as there is no way to
sort them or associate them with a given project.</p>
<blockquote>
<h3>A reminder about <em>switches</em></h3>
<p>For those unfamiliar with it, switches, in opam, are independent prefixes with
their own compiler and set of installed packages. The <code>opam switch</code> command
allows to create and remove switches, as well as select the currently active
one, where operations like <code>opam install</code> will operate.</p>
<p>Their uses include easily juggling between versions of OCaml, or of a library,
having incompatible packages installed separately but at the same time, running
tests without damaging your &quot;main&quot; environment, and, quite often, separation of
environment for working on different projects.</p>
<p>You can also select a specific switch for a single command, with</p>
<pre><code>opam install foo --switch other
</code></pre>
<p>or even for a single shell session, with</p>
<pre><code>eval $(opam env --switch other)
</code></pre>
</blockquote>
<p>What opam 2.0 adds to this is the possibility to create so-called <em>local
switches</em>, stored below a directory of your choice. This gets users back in
control of how switches are organised, and wiping the directory is a safe way to
get rid of the switch.</p>
<h3>Using within projects</h3>
<p>This is the main intended use: the user can define a switch within the source of
a project, for use specifically in that project. One nice side-effect to help
with this is that, if a &quot;local switch&quot; is detected in the current directory or a
parent, opam will select it automatically. Just don't forget to run <code>eval $(opam env)</code> to make the environment up-to-date before running <code>make</code>.</p>
<h3>Interface</h3>
<p>The interface simply overloads the <code>switch-name</code> arguments, wherever they were
present, allowing directory names instead. So for example:</p>
<pre><code class="language-shell-session">cd ~/src/project
opam switch create ./
</code></pre>
<p>will create a local switch in the directory <code>~/src/project</code>. Then, it is for
example equivalent to run <code>opam list</code> from that directory, or <code>opam list --switch=~/src/project</code> from anywhere.</p>
<p>Note that you can bypass the automatic local-switch selection if needed by using
the <code>--switch</code> argument, by defining the variable <code>OPAMSWITCH</code> or by using <code>eval $(opam env --switch &lt;name&gt;)</code></p>
<h3>Implementation</h3>
<p>In practice, the switch contents are placed in a <code>_opam/</code> subdirectory. So if
you create the switch <code>~/src/project</code>, you can browse its contents at
<code>~/src/project/_opam</code>. This is the direct prefix for the switch, so e.g.
binaries can be found directly at <code>_opam/bin/</code>: easier than searching the opam
root! The opam metadata is placed below that directory, in a <code>.opam-switch/</code>
subdirectory.</p>
<p>Local switches still share the opam root, and in particular depend on the
repositories defined and cached there. It is now possible, however, to select
different repositories for different switches, but that is a subject for another
post.</p>
<p>Finally, note that removing that <code>_opam</code> directory is handled transparently by
opam, and that if you want to share a local switch between projects, symlinking
the <code>_opam</code> directory is allowed.</p>
<h3>Current status</h3>
<p>This feature has been present in our dev builds for a while, and you can already
use it in the
<a href="https://github.com/ocaml/opam/releases/tag/2.0.0-beta2">current beta</a>.</p>
<h3>Limitations and future extensions</h3>
<p>It is not, at the moment, possible to move a local switch directory around,
mainly due to issues related to relocating the OCaml compiler.</p>
<p>Creating a new switch still implies to recompile all the packages, and even the
compiler itself (unless you rely on a system installation). The projected
solution is to add a build cache, avoiding the need to recompile the same
package with the same dependencies. This should actually be possible with the
current opam 2.0 code, by leveraging the new hooks that are made available. Note
that relocation of OCaml is also an issue for this, though.</p>
<p>Editing tools like <code>ocp-indent</code> or <code>merlin</code> can also become an annoyance with
the multiplication of switches, because they are not automatically found if not
installed in the current switch. But the <code>user-setup</code> plugin (run <code>opam user-setup install</code>) already handles this well, and will access <code>ocp-indent</code> or
<code>tuareg</code> from their initial switch, if not found in the current one. You will
still need to install tools that are tightly bound to a compiler version, like
<code>merlin</code> and <code>ocp-index</code>, in the switches where you need them, though.</p>
<blockquote>
<p>NOTE: this article is cross-posted on
<a href="https://opam.ocaml.org/blog/">opam.ocaml.org</a> and
<a href="https://ocamlpro.com/blog">ocamlpro.com</a>.</p>
</blockquote>
<h1>Comments</h1>
<p>Jeremie Dimino (11 May 2017 at 8 h 27 min):</p>
<blockquote>
<p>Thanks, that seems like a useful feature. Regarding relocation of the compiler, shouldn&rsquo;t it be enough to set the environment variable OCAMLLIB? AFAIK the stdlib directory is the only hardcoded path on the compiler.</p>
</blockquote>
<p>Louis Gesbert (11 May 2017 at 8 h 56 min):</p>
<blockquote>
<p>Last I checked, there were a few more problematic points, in particular generated bytecode executables statically referring to their interpreter; but yes, in any case, it&rsquo;s worth experimenting in that direction using the new hooks, to see how it works in practice.</p>
</blockquote>
<p>Jeremie Dimino (12 May 2017 at 9 h 13 min):</p>
<blockquote>
<p>Indeed, I remember that we had a similar problem in the initial setup to test the public release of Jane Street packages: we were using long paths for the opam roots and the generated #! where too long for the OS&hellip; What I did back then is write a program that scanned the tree and rewrote the #! to use &ldquo;#!/usr/bin/env ocamlrun&rdquo;.</p>
<p>That could be an option here. The rewriting only need to be done once, since the compiler uses <code>ocamlc -where</code>/camlheader when generating a bytecode executable.</p>
</blockquote>

