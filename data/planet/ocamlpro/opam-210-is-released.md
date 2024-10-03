---
title: opam 2.1.0 is released!
description: Feedback on this post is welcomed on Discuss! We are happy to announce
  the release of opam 2.1.0. Many new features made it in (see the pre-release changelogs
  or release notes for the details), but here are a few highlights. What's new in
  opam 2.1? Integration of system dependencies (formerly the op...
url: https://ocamlpro.com/blog/2021_08_04_opam_2.1.0_is_released
date: 2021-08-04T13:19:46-00:00
preview_image: URL_de_votre_image
authors:
- "\n    David Allsopp (OCamlLabs)\n  "
source:
---

<p><em>Feedback on this post is welcomed on <a href="https://discuss.ocaml.org/t/ann-opam-2-1-0/8255">Discuss</a>!</em></p>
<p>We are happy to announce the release of opam 2.1.0.</p>
<p>Many new features made it in (see the <a href="https://github.com/ocaml/opam/blob/2.1.0/CHANGES">pre-release
changelogs</a> or <a href="https://github.com/ocaml/opam/releases">release
notes</a> for the details),
but here are a few highlights.</p>
<h2>What's new in opam 2.1?</h2>
<ul>
<li>Integration of system dependencies (formerly the opam-depext plugin),
increasing their reliability as it integrates the solving step
</li>
<li>Creation of lock files for reproducible installations (formerly the opam-lock
plugin)
</li>
<li>Switch invariants, replacing the &quot;base packages&quot; in opam 2.0 and allowing for
easier compiler upgrades
</li>
<li>Improved options configuration (see the new <code>option</code> and expanded <code>var</code> sub-commands)
</li>
<li>CLI versioning, allowing cleaner deprecations for opam now and also
improvements to semantics in future without breaking backwards-compatibility
</li>
<li>opam root readability by newer and older versions, even if the format changed
</li>
<li>Performance improvements to opam-update, conflict messages, and many other
areas
</li>
</ul>
<h3>Seamless integration of System dependencies handling (a.k.a. &quot;depexts&quot;)</h3>
<p>opam has long included the ability to install system dependencies automatically
via the <a href="https://github.com/ocaml-opam/opam-depext">depext plugin</a>. This plugin
has been promoted to a native feature of opam 2.1.0 onwards, giving the
following benefits:</p>
<ul>
<li>You no longer have to remember to run <code>opam depext</code>, opam always checks
depexts (there are options to disable this or automate it for CI use).
Installation of an opam package in a CI system is now as easy as <code>opam install .</code>, without having to do the dance of <code>opam pin add -n/depext/install</code>. Just
one command now for the common case!
</li>
<li>The solver is only called once, which both saves time and also stabilises the
behaviour of opam in cases where the solver result is not stable. It was
possible to get one package solution for the <code>opam depext</code> stage and a
different solution for the <code>opam install</code> stage, resulting in some depexts
missing.
</li>
<li>opam now has full knowledge of depexts, which means that packages can be
automatically selected based on whether a system package is already installed.
For example, if you have <em>neither</em> MariaDB nor MySQL dev libraries installed,
<code>opam install mysql</code> will offer to install <code>conf-mysql</code> and <code>mysql</code>, but if you
have the MariaDB dev libraries installed, opam will offer to install
<code>conf-mariadb</code> and <code>mysql</code>.
</li>
</ul>
<p><em>Hint: You can set <code>OPAMCONFIRMLEVEL=unsafe-yes</code> or
<code>--confirm-level=unsafe-yes</code> to launch non interactive system package commands.</em></p>
<h3>opam lock files and reproducibility</h3>
<p>When opam was first released, it had the mission of gathering together
scattered OCaml source code to build a <a href="https://github.com/ocaml/opam-repository">community
repository</a>. As time marches on, the
size of the opam repository has grown tremendously, to over 3000 unique
packages with over 19500 unique versions. opam looks at all these packages and
is designed to solve for the best constraints for a given package, so that your
project can keep up with releases of your dependencies.</p>
<p>While this works well for libraries, we need a different strategy for projects
that need to test and ship using a fixed set of dependencies. To satisfy this
use-case, opam 2.0.0 shipped with support for <em>using</em> <code>project.opam.locked</code>
files. These are normal opam files but with exact versions of dependencies. The
lock file can be used as simply as <code>opam install . --locked</code> to have a
reproducible package installation.</p>
<p>With opam 2.1.0, the creation of lock files is also now integrated into the
client:</p>
<ul>
<li><code>opam lock</code> will create a <code>.locked</code> file for your current switch and project,
that you can check into the repository.
</li>
<li><code>opam switch create . --locked</code> can be used by users to reproduce your
dependencies in a fresh switch.
</li>
</ul>
<p>This lets a project simultaneously keep up with the latest dependencies
(without lock files) while providing a stricter set for projects that need it
(with lock files).</p>
<p><em>Hint: You can export the full configuration of a switch with <code>opam switch export</code> new options, <code>--full</code> to have all packages metadata included, and
<code>--freeze</code> to freeze all VCS to their current commit.</em></p>
<h3>Switch invariants</h3>
<p>In opam 2.0, when a switch is created the packages selected are put into the
&ldquo;base&rdquo; of the switch. These packages are not normally considered for upgrade,
in order to ease pressure on opam's solver. This was a much bigger concern
early on in opam 2.0's development, but is less of a problem with the default
mccs solver.</p>
<p>However, it's a problem for system compilers. opam would detect that your
system compiler version had changed, but be unable to upgrade the ocaml-system
package unless you went through a slightly convoluted process with
<code>--unlock-base</code>.</p>
<p>In opam 2.1, base packages have been replaced by switch invariants. The switch
invariant is a package formula which must be satisfied on every upgrade and
install. All existing switches' base packages could just be expressed as
<code>package1 &amp; package2 &amp; package3</code> etc. but opam 2.1 recognises many existing
patterns and simplifies them, so in most cases the invariant will be
<code>&quot;ocaml-base-compiler&quot; {= &quot;4.11.1&quot;}</code>, etc. This means that <code>opam switch create my_switch ocaml-system</code> now creates a <em>switch invariant</em> of <code>&quot;ocaml-system&quot;</code>
rather than a specific version of the <code>ocaml-system</code> package. If your system
OCaml package is updated, <code>opam upgrade</code> will seamlessly switch to the new
package.</p>
<p>This also allows you to have switches which automatically install new point
releases of OCaml. For example:</p>
<pre><code class="language-shell-session">opam switch create ocaml-4.11 --formula='&quot;ocaml-base-compiler&quot; {&gt;= &quot;4.11.0&quot; &amp; &lt; &quot;4.12.0~&quot;}' --repos=old=git+https://github.com/ocaml/opam-repository#a11299d81591
opam install utop
</code></pre>
<p>Creates a switch with OCaml 4.11.0 (the <code>--repos=</code> was just to select a version
of opam-repository from before 4.11.1 was released). Now issue:</p>
<pre><code class="language-shell-session">opam repo set-url old git+https://github.com/ocaml/opam-repository
opam upgrade
</code></pre>
<p>and opam 2.1 will automatically offer to upgrade OCaml 4.11.1 along with a
rebuild of the switch. There's not yet a clean CLI for specifying the formula,
but we intend to iterate further on this with future opam releases so that
there is an easier way of saying &ldquo;install OCaml 4.11.x&rdquo;.</p>
<p><em>Hint: You can set up a default invariant that will apply for all new switches,
via a specific <code>opamrc</code>. The default one is <code>ocaml &gt;= 4.05.0</code></em></p>
<h3>Configuring opam from the command-line</h3>
<p>Configuring opam is not a simple task: you need to use an <code>opamrc</code> at init
stage, or hack global/switch config file, or use <code>opam config var</code> for
additional variables. To ease that step, and permit a more consistent opam
config tweaking, a new command was added : <code>opam option</code>.</p>

<p>For example:</p>
<ul>
<li><code>opam option download-jobs</code> gives the global <code>download-jobs</code> value (as it
exists only in global configuration)
</li>
<li><code>opam option jobs=6 --global</code> will set the number of parallel build
jobs opam is allowed to run (along with the associated <code>jobs</code> variable)
</li>
<li><code>opam option depext-run-commands=false</code> disables the use of <code>sudo</code> for
handling system dependencies; it will be replaced by a prompt to run the
installation commands
</li>
<li><code>opam option depext-bypass=m4 --global</code> bypass <code>m4</code> system package check
globally, while <code>opam option depext-bypass=m4 --switch myswitch</code> will only
bypass it in the selected switch
</li>
</ul>
<p>The command <code>opam var</code> is extended with the same format, acting on switch and
global variables.</p>
<p><em>Hint: to revert your changes use <code>opam option &lt;field&gt;=</code>, it will take its
default value.</em></p>
<h3>CLI Versioning</h3>
<p>A new <code>--cli</code> switch was added to the first beta release, but it's only now
that it's being widely used. opam is a complex enough system that sometimes bug
fixes need to change the semantics of some commands. For example:</p>
<ul>
<li><code>opam show --file</code> needed to change behaviour
</li>
<li>The addition of new controls for setting global variables means that the
<code>opam config</code> was becoming cluttered and some things want to move to <code>opam var</code>
</li>
<li><code>opam switch install 4.11.1</code> still works in opam 2.0, but it's really an OPAM
1.2.2 syntax.
</li>
</ul>
<p>Changing the CLI is exceptionally painful since it can break scripts and tools
which themselves need to drive <code>opam</code>. CLI versioning is our attempt to solve
this. The feature is inspired by the <code>(lang dune ...)</code> stanza in <code>dune-project</code>
files which has allowed the Dune project to rename variables and alter
semantics without requiring every single package using Dune to upgrade their
<code>dune</code> files on each release.</p>
<p>Now you can specify which version of opam you expected the command to be run
against. In day-to-day use of opam at the terminal, you wouldn't specify it,
and you'll get the latest version of the CLI. For example: <code>opam var --global</code>
is the same as <code>opam var --cli=2.1 --global</code>. However, if you issue <code>opam var --cli=2.0 --global</code>, you will told that <code>--global</code> was added in 2.1 and so is
not available to you. You can see similar things with the renaming of <code>opam upgrade --unlock-base</code> to <code>opam upgrade --update-invariant</code>.</p>
<p>The intention is that <code>--cli</code> should be used in scripts, user guides (e.g. blog
posts), and in software which calls opam. The only decision you have to take is
the <em>oldest</em> version of opam which you need to support. If your script is using
a new opam 2.1 feature (for example <code>opam switch create --formula=</code>) then you
simply don't support opam 2.0. If you need to support opam 2.0, then you can't
use <code>--formula</code> and should use <code>--packages</code> instead. opam 2.0 does not have the
<code>--cli</code> option, so for opam 2.0 instead of <code>--cli=2.0</code> you should set the
environment variable <code>OPAMCLI</code> to <code>2.0</code>. As with <em>all</em> opam command line
switches, <code>OPAMCLI</code> is simply the equivalent of <code>--cli</code> which opam 2.1 will
pick-up but opam 2.0 will quietly ignore (and, as with other options, the
command line takes precedence over the environment).</p>
<p>Note that opam 2.1 sets <code>OPAMCLI=2.0</code> when building packages, so on the rare
instances where you need to use the <code>opam</code> command in a <em>package</em> <code>build:</code>
command (or in your build system), you <em>must</em> specify <code>--cli=2.1</code> if you're
using new features.</p>
<p>Since 2.1.0~rc2, CLI versioning applies to opam environment variables. The
previous behavior was to ignore unknown or wrongly set environment variable,
while now you will have a warning to let you know that the environment variable
won't be handled by this version of opam.</p>
<p>To ensure not breaking compatibility of some widely used deprecated options,
a <em>default</em> CLI is introduced: when no CLI is specified, those deprecated
options are accepted. It concerns <code>opam exec</code> and <code>opam var</code> subcommands.</p>
<p>There's even more detail on this feature <a href="https://github.com/ocaml/opam/wiki/Spec-for-opam-CLI-versioning">in our
wiki</a>. We're
hoping that this feature will make it much easier in future releases for opam
to make required changes and improvements to the CLI without breaking existing
set-ups and tools.</p>
<p><em>Note: For opam libraries users, since 2.1 environment variable are no more
loaded by the libraries, only by opam client. You need to load them explicitly.</em></p>
<h3>opam root portability</h3>
<p>opam root format changes during opam life-cycle, new field are added or
removed, new files are added ; an older opam version sometimes can no longer
read an upgraded or newly created opam root. opam root format has been updated
to allow new versions of opam to indicate that the root may still be read by
older versions of the opam libraries. A plugin compiled against the 2.0.9 opam
libraries will therefore be able to read information about an opam 2.1 root
(plugins and tools compiled against 2.0.8 are unable to load opam 2.1.0 roots).
It is a <em>read-only</em> best effort access, any attempt to modify the opam root
fails.</p>
<p><em>Hint: for opam libraries users, you can safely load states with
<a href="https://github.com/ocaml/opam/blob/master/src/state/opamStateConfig.mli"><code>OpamStateConfig</code></a>
load functions.</em></p>

<p><strong>Tremendous thanks to all involved people, who've developed, tested &amp; retested,
helped with issue reports, comments, feedback...</strong></p>
<h2>Try it!</h2>
<p>In case you plan a possible rollback, you may want to first backup your
<code>~/.opam</code> directory.</p>
<p>The upgrade instructions are unchanged:</p>
<ol>
<li>Either from binaries: run
</li>
</ol>
<pre><code class="language-shell-session">bash -c &quot;sh &lt;(curl -fsSL https://opam.ocaml.org/install.sh) --version 2.1.0&quot;
</code></pre>
<p>or download manually from <a href="https://github.com/ocaml/opam/releases/tag/2.1.0">the Github &quot;Releases&quot; page</a> to your PATH.</p>
<ol start="2">
<li>Or from source, manually: see the instructions in the <a href="https://github.com/ocaml/opam/tree/2.1.0#compiling-this-repo">README</a>.
</li>
</ol>
<p>You should then run:</p>
<pre><code class="language-shell-session">opam init --reinit -ni
</code></pre>

