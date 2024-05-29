---
title: OPAM 1.2.0 public beta released
description: It has only been 18 months since the first release of OPAM, but it is
  already difficult to remember a time when we did OCaml development without it.  OPAM
  has helped bring together much of the open-source code in the OCaml community under
  a single umbrella, making it easier to discover, depend on, a...
url: https://ocamlpro.com/blog/2014_08_14_opam_1.2.0_public_beta_released
date: 2014-08-14T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    OCaml Platform Team\n  "
source:
---

<p>It has only been 18 months since the first release of OPAM, but it is already
difficult to remember a time when we did OCaml development without it.  OPAM
has helped bring together much of the open-source code in the OCaml community
under a single umbrella, making it easier to discover, depend on, and maintain
OCaml applications and libraries.  We have seen steady growth in the number
of new packages, updates to existing code, and a diverse group of contributors.
<img src="https://ocamlpro.com/blog/assets/img/graph_opam1.2_packages.png"/></p>
<p>OPAM has turned out to be more than just another package manager. It is also
increasingly central to the demanding workflow of industrial OCaml development,
since it supports multiple simultaneous (patched) compiler installations,
sophisticated package version constraints that ensure statically-typed code can
be recompiled without conflict, and a distributed workflow that integrates
seamlessly with Git, Mercurial or Darcs version control.  OPAM tracks multiple
revisions of a single package, thereby letting packages rely on older
interfaces if they need to for long-term support. It also supports multiple
package repositories, letting users blend the global stable package set with
their internal revisions, or building completely isolated package universes for
closed-source products.</p>
<p>Since its initial release, we have been learning from the extensive feedback
from our users about how they use these features as part of their day-to-day
workflows.  Larger projects like <a href="http://wiki.xen.org/wiki/XAPI">XenAPI</a>, the <a href="http://ocsigen.org">Ocsigen</a> web suite,
and the <a href="http://openmirage.org">Mirage OS</a> publish OPAM <a href="https://opam.ocaml.org/doc/Advanced_Usage.html#Handlingofrepositories">remotes</a> that build
their particular software suites.
Complex applications such as the <a href="https://github.com/facebook/pfff/wiki/Main">Pfff</a> static analysis tool and <a href="https://code.facebook.com/posts/264544830379293/hack-a-new-programming-language-for-hhvm/">Hack</a>
language from Facebook, the <a href="https://github.com/frenetic-lang/frenetic">Frenetic</a> SDN language and the <a href="http://arakoon.org">Arakoon</a>
distributed key store have all appeared alongside these libraries.
<a href="https://www.janestreet.com">Jane Street</a> pushes regular releases of their
production <a href="http://janestreet.github.io/">Core/Async</a> suite every couple
of weeks.</p>
<p>One pleasant side-effect of the growing package database has been the
contribution of tools from the community that make the day-to-day use of OCaml
easier.  These include the <a href="https://github.com/diml/utop">utop</a> interactive toplevel, the <a href="https://github.com/andrewray/iocaml">IOCaml</a>
browser notebook, and the <a href="https://github.com/the-lambda-church/merlin">Merlin</a> IDE extension.  While these tools are an
essential first step, there's still some distance to go to make the OCaml
development experience feel fully integrated and polished.</p>
<p>Today, we are kicking off the next phase of evolution of OPAM and starting the
journey towards building an <em>OCaml Platform</em> that combines the OCaml compiler
toolchain with a coherent workflow for build, documentation, testing and IDE
integration. As always with OPAM, this effort has been a collaborative effort,
coordinated by the <a href="https://www.cl.cam.ac.uk/projects/ocamllabs/">OCaml Labs</a> group in Cambridge and
<a href="https://ocamlpro.com/">OCamlPro</a> in France.
The OCaml Platform builds heavily on OPAM, since it forms the substrate that
pulls together the tools and facilitates a consistent development workflow.
We've therefore created this blog on <a href="https://opam.ocaml.org">opam.ocaml.org</a> to chart its progress,
announce major milestones, and eventually become a community repository of all
significant activity.</p>
<p>Major points:</p>
<ul>
<li>
<p><strong>OPAM 1.2 beta available</strong>:
Firstly, we're announcing <strong>the availability of the OPAM 1.2 beta</strong>,
which includes a number of new features, hundreds of bug fixes, and pretty
new colours in the CLI.  We really need your feedback to ensure a polished
release, so please do read the release notes below.</p>
</li>
<li>
<p>In the coming weeks, we will provide an overview of what the OCaml Platform is
(and is not), and describe an example workflow that the Platform can enable.</p>
</li>
<li>
<p><strong>Feedback</strong>: If you have questions or comments as you read these posts,
then please do join the <a href="https://lists.ocaml.org/listinfo/platform">platform@lists.ocaml.org</a> and make
them known to us.</p>
</li>
</ul>
<h2>Releasing the OPAM 1.2 beta4</h2>
<p>We are proud to announce the latest beta of OPAM 1.2.  It comes packed with
<a href="https://github.com/ocaml/opam/issues?q=label:%22Feature%20Wish%22%20milestone:1.2%20is:closed" title="Features added in 1.2 from the tracker on Github">new features</a>, stability and usability improvements. Here the
highlights.</p>
<h3>Binary RPMs and DEBs!</h3>
<p>We now have binary packages available for Fedora 19/20, CentOS 6/7, RHEL7,
Debian Wheezy and Ubuntu!  You can see the full set at the <a href="https://build.opensuse.org/package/show/home:ocaml/opam#">OpenSUSE Builder</a> site and
<a href="http://software.opensuse.org/download.html?project=home:ocaml&amp;package=opam">download instructions</a> for your particular platform.</p>
<p>An OPAM binary installation doesn't need OCaml to be installed on the system, so you
can initialize a fresh, modern version of OCaml on older systems without needing it
to be packaged there.
On CentOS 6 for example:</p>
<pre><code class="language-shell-session">cd /etc/yum.repos.d/
wget http://download.opensuse.org/repositories/home:ocaml/CentOS_6/home:ocaml.repo
yum install opam
opam init --comp=4.01.0
</code></pre>
<h3>Simpler user workflow</h3>
<p>For this version, we focused on improving the user interface and workflow. OPAM
is a complex piece of software that needs to handle complex development
situations. This implies things might go wrong, which is precisely when good
support and error messages are essential.  OPAM 1.2 has much improved stability
and error handling: fewer errors and more helpful messages plus better state backups
when they happen.</p>
<p>In particular, a clear and meaningful explanation is extracted from the solver
whenever you are attempting an impossible action (unavailable package,
conflicts, etc.):</p>
<pre><code class="language-shell-session">$ opam install mirage-www=0.3.0
The following dependencies couldn't be met:
  - mirage-www -&gt; cstruct &lt; 0.6.0
  - mirage-www -&gt; mirage-fs &gt;= 0.4.0 -&gt; cstruct &gt;= 0.6.0
Your request can't be satisfied:
  - Conflicting version constraints for cstruct
</code></pre>
<p>This sets OPAM ahead of many other package managers in terms of
user-friendliness.  Since this is made possible using the tools from
<a href="https://www.irill.org" title="IRILL">irill</a> (which are also used for <a href="https://qa.debian.org/dose/debcheck/testing_main/" title="Debian Weather Service">Debian</a>), we hope that
this work will find its way into other package managers.
The extra analyses in the package solver interface are used to improve the
health of the central package repository, via the <a href="http://ows.irill.org" title="The OPAM Weather Service">OPAM Weather service</a>.</p>
<p>And in case stuff does go wrong, we added the <code>opam upgrade --fixup</code>
command that will get you back to the closest clean state.</p>
<p>The command-line interface is also more detailed and convenient, polishing and
documenting the rough areas.  Just run <code>opam &lt;subcommand&gt; --help</code> to see the
manual page for the below features.</p>
<ul>
<li>More expressive queries based on dependencies.
</li>
</ul>
<pre><code class="language-shell-session">$ opam list --depends-on cow --rec
# Available packages recursively depending on cow.0.10.0 for 4.01.0:
cowabloga   0.0.7  Simple static blogging support.
iocaml      0.4.4  A webserver for iocaml-kernel and iocamljs-kernel.
mirage-www  1.2.0  Mirage website (written in Mirage)
opam2web    1.3.1 (pinned)  A tool to generate a website from an OPAM repository
opium       0.9.1  Sinatra like web toolkit based on Async + Cohttp
stone       0.3.2  Simple static website generator, useful for a portfolio or documentation pages
</code></pre>
<ul>
<li>Check on existing <code>opam</code> files to base new packages from.
</li>
</ul>
<pre><code class="language-shell-session">$ opam show cow --raw
opam-version: &quot;1&quot;
name: &quot;cow&quot;
version: &quot;0.10.0&quot;
[...]
</code></pre>
<ul>
<li>Clone the source code for any OPAM package to modify or browse the interfaces.
</li>
</ul>
<pre><code class="language-shell-session">$ opam source cow
Downloading archive of cow.0.10.0...
[...]
$ cd cow.0.10.0
</code></pre>
<p>We've also improved the general speed of the tool to cope with the much bigger
size of the central repository, which will be of importance for people building
on low-power ARM machines, and added a mechanism that will let you install
newer releases of OPAM directly from OPAM if you choose so.</p>
<h3>Yet more control for the packagers</h3>
<p>Packaging new libraries has been made as straight-forward as possible.
Here is a quick overview, you may also want to check the <a href="https://ocamlpro.com/blog/2014_08_19_opam_1.2_repository_pinning" title="Blog post on OPAM Pin">OPAM 1.2 pinning</a> post.</p>
<pre><code class="language-shell-session">opam pin add &lt;name&gt; &lt;sourcedir&gt;
</code></pre>
<p>will generate a new package on the fly by detecting the presence of an <code>opam</code>
file within the source repository itself.  We'll do a followup post next week
with more details of this extended <code>opam pin</code> workflow.</p>
<p>The package description format has also been extended with some new fields:</p>
<ul>
<li><code>bug-reports:</code> and <code>dev-repo:</code> add useful URLs
</li>
<li><code>install:</code> allows build and install commands to be split,
</li>
<li><code>flags:</code> is an entry point for several extensions that can affect your package.
</li>
</ul>
<p>Packagers can limit dependencies in scope by adding one
of the keywords <code>build</code>, <code>test</code> or <code>doc</code> in front of their constraints:</p>
<pre><code class="language-shell-session">depends: [
  &quot;ocamlfind&quot; {build &amp; &gt;= 1.4.0}
  &quot;ounit&quot; {test}
]
</code></pre>
<p>Here you don't specifically require <code>ocamlfind</code> at runtime, so changing it
won't trigger recompilation of your package. <code>ounit</code> is marked as only required
for the package's <code>build-test:</code> target, <em>i.e.</em> when installing with
<code>opam install -t</code>.  This will reduce the amount of (re)compilation required
in day-to-day use.</p>
<p>We've also made optional dependencies more consistent by <em>removing</em> version
constraints from the <code>depopts:</code> field: their meaning was <a href="https://github.com/ocaml/opam/issues/200">unclear</a> and confusing.
The <code>conflicts</code> field is used to indicate versions of the optional dependencies
that are incompatible with your package to remove all ambiguity:</p>
<pre><code class="language-shell-session">depopts: [ &quot;async&quot; {&gt;= &quot;109.15.00&quot;} &amp; &quot;async_ssl&quot; {&gt;= &quot;111.06.00&quot;} ]
</code></pre>
<p>becomes:</p>
<pre><code class="language-shell-session">depopts: [ &quot;async&quot; &quot;async_ssl&quot; ]
conflicts: [ &quot;async&quot; {&lt; &quot;109.15.00&quot;}
             &quot;async_ssl&quot; {&lt; &quot;111.06.00&quot;} ]
</code></pre>
<p>There is an <a href="https://github.com/ocaml/opam/pull/1325" title="PR for preliminary 'features' feature on Github">upcoming <code>features</code> field</a> that will give more
flexibility in a clearer and consistent way for such complex cases.</p>
<h3>Easier to package and install</h3>
<p>Efforts were made on the build of OPAM itself as well to make it as easy as possible
to compile, bootstrap or install.  There is no more dependency on camlp4 (which has
been moved out of the core distribution in OCaml 4.02.0), and the build process
is more conventional (get the source, run <code>./configure</code>, <code>make lib-ext</code> to get the few
internal dependencies, <code>make</code> and <code>make install</code>).  Packagers can use <code>make cold</code>
to build OPAM with a locally compiled version of OCaml (useful for platforms where
it isn't packaged), and also use <code>make download-ext</code> to store all the external archives
within the source tree (for automated builds which forbid external net access).</p>
<p>The <a href="https://opam.ocaml.org/doc" title="Preview of documentation for OPAM 1.2">whole documentation</a> has been rewritten as well, to be better focused and
easier to browse.  Please leave any feedback or changes on the documentation on the
<a href="https://github.com/ocaml/opam/issues">issue tracker</a>.</p>
<h3>Try it out !</h3>
<p>The <a href="https://github.com/ocaml/opam/releases/tag/1.2.0-beta4" title="Opam 1.2-beta4 release">public beta of OPAM 1.2</a> is just out. You're welcome to give it a try and
give us feedback before we roll out the release!</p>
<p>We'd be most interested on feedback on how easily you can work with the new
pinning features, on how the new metadata works for you... and on any errors you
may trigger that aren't followed by informative messages or clean behaviour.</p>
<p>If you are hosting a repository, the <a href="https://github.com/ocaml/opam/tree/master/admin-scripts" title="Opam admin scripts directory on Github">administration scripts</a> may help you quickly update all your packages to
benefit from the new features.</p>

