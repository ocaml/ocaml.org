---
title: opam 2.1.0~beta4 released
description: "Feedback on this post is welcomed on Discuss! On behalf of the opam
  team, it gives me great pleasure to announce the third beta release of opam 2.1.
  Don\u2019t worry, you didn\u2019t miss beta3 - we had an issue with a configure
  script that caused beta2 to report as beta3 in some instances, so we skipped ..."
url: https://ocamlpro.com/blog/2021_01_13_opam_2.1.0_beta4_released
date: 2021-01-13T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    David Allsopp (OCamlLabs)\n  "
source:
---

<p><em>Feedback on this post is welcomed on <a href="https://discuss.ocaml.org/t/ann-opam-2-1-0-beta4/7252">Discuss</a>!</em></p>
<p>On behalf of the opam team, it gives me great pleasure to announce the third beta release of opam 2.1. Don&rsquo;t worry, you didn&rsquo;t miss beta3 - we had an issue with a configure script that caused beta2 to report as beta3 in some instances, so we skipped to beta4 to avoid any further confusion!</p>
<p>We encourage you to try out this new beta release: there are instructions for doing so in <a href="https://github.com/ocaml/opam/wiki/How-to-test-an-opam-feature">our wiki</a>. The instructions include taking a backup of your <code>~/.opam</code> root as part of the process, which can be restored in order to wind back. <em>Please note that local switches which are written to by opam 2.1 are upgraded and will need to be rebuilt if you go back to opam 2.0</em>. This can either be done by removing <code>_opam</code> and repeating whatever you use in your build process to create the switch, or you can use <code>opam switch export switch.export</code> to backup the switch to a file before installing new packages. Note that opam 2.1 <em>shouldn&rsquo;t</em> upgrade a local switch unless you upgrade the base packages (i.e. the compiler).</p>
<h2>What&rsquo;s new in opam 2.1?</h2>
<ul>
<li>Switch invariants
</li>
<li>Improved options configuration (see the new <code>option</code> and expanded <code>var</code> sub-commands)
</li>
<li>Integration of system dependencies (formerly the opam-depext plugin), increasing their reliability as it integrates the solving step
</li>
<li>Creation of lock files for reproducible installations (formerly the opam-lock plugin)
</li>
<li>CLI versioning, allowing cleaner deprecations for opam now and also improvements to semantics in future without breaking backwards-compatibility
</li>
<li>Performance improvements to opam-update, conflict messages, and many other areas
</li>
<li>New plugins: opam-compiler and opam-monorepo
</li>
</ul>
<h3>Switch invariants</h3>
<p>In opam 2.0, when a switch is created the packages selected are put into the &ldquo;base&rdquo; of the switch. These packages are not normally considered for upgrade, in order to ease pressure on opam&rsquo;s solver. This was a much bigger concern early on in opam 2.0&rsquo;s development, but is less of a problem with the default mccs solver.</p>
<p>However, it&rsquo;s a problem for system compilers. opam would detect that your system compiler version had changed, but be unable to upgrade the ocaml-system package unless you went through a slightly convoluted process with <code>--unlock-base</code>.</p>
<p>In opam 2.1, base packages have been replaced by switch invariants. The switch invariant is a package formula which must be satisfied on every upgrade and install. All existing switches&rsquo; base packages could just be expressed as <code>package1 &amp; package2 &amp; package3</code> etc. but opam 2.1 recognises many existing patterns and simplifies them, so in most cases the invariant will be <code>&quot;ocaml-base-compiler&quot; {= 4.11.1}</code>, etc. This means that <code>opam switch create my_switch ocaml-system</code> now creates a <em>switch invariant</em> of <code>&quot;ocaml-system&quot;</code> rather than a specific version of the <code>ocaml-system</code> package. If your system OCaml package is updated, <code>opam upgrade</code> will seamlessly switch to the new package.</p>
<p>This also allows you to have switches which automatically install new point releases of OCaml. For example:</p>
<pre><code class="language-shell-session">$~ opam switch create ocaml-4.11 --formula='&quot;ocaml-base-compiler&quot; {&gt;= &quot;4.11.0&quot; &amp; &lt; &quot;4.12.0~&quot;}' --repos=old=git+https://github.com/ocaml/opam-repository#a11299d81591
$~ opam install utop
</code></pre>
<p>Creates a switch with OCaml 4.11.0 (the <code>--repos=</code> was just to select a version of opam-repository from before 4.11.1 was released). Now issue:</p>
<pre><code class="language-shell-session">$~ opam repo set-url old git+https://github.com/ocaml/opam-repository
$~ opam upgrade
</code></pre>
<p>and opam 2.1 will automatically offer to upgrade OCaml 4.11.1 along with a rebuild of the switch. There&rsquo;s not yet a clean CLI for specifying the formula, but we intend to iterate further on this with future opam releases so that there is an easier way of saying &ldquo;install OCaml 4.11.x&rdquo;.</p>
<h3>opam depext integration</h3>
<p>opam has long included the ability to install system dependencies automatically via the <a href="https://github.com/ocaml-opam/opam-depext">depext plugin</a>. This plugin has been promoted to a native feature of opam 2.1.0 onwards, giving the following benefits:</p>
<ul>
<li>You no longer have to remember to run <code>opam depext</code>, opam always checks depexts (there are options to disable this or automate it for CI use). Installation of an opam package in a CI system is now as easy as <code>opam install .</code>, without having to do the dance of <code>opam pin add -n/depext/install</code>. Just one command now for the common case!
</li>
<li>The solver is only called once, which both saves time and also stabilises the behaviour of opam in cases where the solver result is not stable. It was possible to get one package solution for the <code>opam depext</code> stage and a different solution for the <code>opam install</code> stage, resulting in some depexts missing.
</li>
<li>opam now has full knowledge of depexts, which means that packages can be automatically selected based on whether a system package is already installed. For example, if you have <em>neither</em> MariaDB nor MySQL dev libraries installed, <code>opam install mysql</code> will offer to install <code>conf-mysql</code> and <code>mysql</code>, but if you have the MariaDB dev libraries installed, opam will offer to install <code>conf-mariadb</code> and <code>mysql</code>.
</li>
</ul>
<h3>opam lock files and reproducibility</h3>
<p>When opam was first released, it had the mission of gathering together scattered OCaml source code to build a <a href="https://github.com/ocaml/opam-repository">community repository</a>. As time marches on, the size of the opam repository has grown tremendously, to over 3000 unique packages with over 18000 unique versions. opam looks at all these packages and is designed to solve for the best constraints for a given package, so that your project can keep up with releases of your dependencies.</p>
<p>While this works well for libraries, we need a different strategy for projects that need to test and ship using a fixed set of dependencies. To satisfy this use-case, opam 2.0.0 shipped with support for <em>using</em> <code>project.opam.locked</code> files. These are normal opam files but with exact versions of dependencies. The lock file can be used as simply as <code>opam install . --locked</code> to have a reproducible package installation.</p>
<p>With opam 2.1.0, the creation of lock files is also now integrated into the client:</p>
<ul>
<li><code>opam lock</code> will create a <code>.locked</code> file for your current switch and project, that you can check into the repository.
</li>
<li><code>opam switch create . --locked</code> can be used by users to reproduce your dependencies in a fresh switch.
</li>
</ul>
<p>This lets a project simultaneously keep up with the latest dependencies (without lock files) while providing a stricter set for projects that need it (with lock files).</p>
<h3>CLI Versioning</h3>
<p>A new <code>--cli</code> switch was added to the first beta release, but it&rsquo;s only now that it&rsquo;s being widely used. opam is a complex enough system that sometimes bug fixes need to change the semantics of some commands. For example:</p>
<ul>
<li><code>opam show --file</code> needed to change behaviour
</li>
<li>The addition of new controls for setting global variables means that the <code>opam config</code> was becoming cluttered and some things want to move to <code>opam var</code>
</li>
<li><code>opam switch install 4.11.1</code> still works in opam 2.0, but it&rsquo;s really an OPAM 1.2.2 syntax.
</li>
</ul>
<p>Changing the CLI is exceptionally painful since it can break scripts and tools which themselves need to drive <code>opam</code>. CLI versioning is our attempt to solve this. The feature is inspired by the <code>(lang dune ...)</code> stanza in <code>dune-project</code> files which has allowed the Dune project to rename variables and alter semantics without requiring every single package using Dune to upgrade their <code>dune</code> files on each release.</p>
<p>Now you can specify which version of opam you expected the command to be run against. In day-to-day use of opam at the terminal, you wouldn&rsquo;t specify it, and you&rsquo;ll get the latest version of the CLI. For example: <code>opam var --global</code> is the same as <code>opam var --cli=2.1 --global</code>. However, if you issue <code>opam var --cli=2.0 --global</code>, you will told that <code>--global</code> was added in 2.1 and so is not available to you. You can see similar things with the renaming of <code>opam upgrade --unlock-base</code> to <code>opam upgrade --update-invariant</code>.</p>
<p>The intention is that <code>--cli</code> should be used in scripts, user guides (e.g. blog posts), and in software which calls opam. The only decision you have to take is the <em>oldest</em> version of opam which you need to support. If your script is using a new opam 2.1 feature (for example <code>opam switch create --formula=</code>) then you simply don&rsquo;t support opam 2.0. If you need to support opam 2.0, then you can&rsquo;t use <code>--formula</code> and should use <code>--packages</code> instead. opam 2.0 does not have the <code>--cli</code> option, so for opam 2.0 instead of <code>--cli=2.0</code> you should set the environment variable <code>OPAMCLI</code> to <code>2.0</code>. As with <em>all</em> opam command line switches, <code>OPAMCLI</code> is simply the equivalent of <code>--cli</code> which opam 2.1 will pick-up but opam 2.0 will quietly ignore (and, as with other options, the command line takes precedence over the environment).</p>
<p>Note that opam 2.1 sets <code>OPAMCLI=2.0</code> when building packages, so on the rare instances where you need to use the <code>opam</code> command in a <em>package</em> <code>build:</code> command (or in your build system), you <em>must</em> specify <code>--cli=2.1</code> if you&rsquo;re using new features.</p>
<p>There&rsquo;s even more detail on this feature <a href="https://github.com/ocaml/opam/wiki/Spec-for-opam-CLI-versioning">in our wiki</a>. We&rsquo;re still finalising some details on exactly how <code>opam</code> behaves when <code>--cli</code> is not given, but we&rsquo;re hoping that this feature will make it much easier in future releases for opam to make required changes and improvements to the CLI without breaking existing set-ups and tools.</p>
<h2>What&rsquo;s new since the last beta?</h2>
<ul>
<li>opam now uses CLI versioning (<a href="https://github.com/ocaml/opam/pull/4385">#4385</a>)
</li>
<li>opam now exits with code 31 if all failures were during fetch operations (<a href="https://github.com/ocaml/opam/issues/4214">#4214</a>)
</li>
<li><code>opam install</code> now has a <code>--download-only</code> flag (<a href="https://github.com/ocaml/opam/issues/4036">#4036</a>), allowing opam&rsquo;s caches to be primed
</li>
<li><code>opam init</code> now advises the correct shell-specific command for <code>eval $(opam env)</code> (<a href="https://github.com/ocaml/opam/pull/4427">#4427</a>)
</li>
<li><code>post-install</code> hooks are now allowed to modify or remove installed files (<a href="https://github.com/ocaml/opam/pull/4388">#4388</a>)
</li>
<li>New package variable <code>opamfile-loc</code> with the location of the installed package opam file (<a href="https://github.com/ocaml/opam/pull/4402">#4402</a>)
</li>
<li><code>opam update</code> now has <code>--depexts</code> flag (<a href="https://github.com/ocaml/opam/issues/4355">#4355</a>), allowing the system package manager to update too
</li>
<li>depext support NetBSD and DragonFlyBSD added (<a href="https://github.com/ocaml/opam/pull/4396">#4396</a>)
</li>
<li>The format-preserving opam file printer has been overhauled (<a href="https://github.com/ocaml/opam/issues/3993">#3993</a>, <a href="https://github.com/ocaml/opam/pull/4298">#4298</a> and <a href="https://github.com/ocaml/opam/pull/4302">#4302</a>)
</li>
<li>pins are now fetched in parallel (<a href="https://github.com/ocaml/opam/issues/4315">#4315</a>)
</li>
<li><code>os-family=ubuntu</code> is now treated as <code>os-family=debian</code> (<a href="https://github.com/ocaml/opam/pull/4441">#4441</a>)
</li>
<li><code>opam lint</code> now checks that strings in filtered package formulae are booleans or variables (<a href="https://github.com/ocaml/opam/issues/4439">#4439</a>)
</li>
</ul>
<p>and many other bug fixes as listed <a href="https://github.com/ocaml/opam/releases/tag/2.1.0-beta4">on the release page</a>.</p>
<h2>New Plugins</h2>
<p>Several features that were formerly plugins have been integrated into opam 2.1.0. We have also developed some <em>new</em> plugins that satisfy emerging workflows from the community and the core OCaml team. They are available for use with the opam 2.1 beta as well, and feedback on them should be directed to the respective GitHub trackers for those plugins.</p>
<h3>opam compiler</h3>
<p>The <a href="https://github.com/ocaml-opam/opam-compiler"><code>opam compiler</code></a> plugin can be used to create switches from various sources such as the main opam repository, the ocaml-multicore fork, or a local development directory. It can use Git tag names, branch names, or PR numbers to specify what to install.</p>
<p>Once installed, these are normal opam switches, and one can install packages in them. To iterate on a compiler feature and try opam packages at the same time, it supports two ways to reinstall the compiler: either a safe and slow technique that will reinstall all packages, or a quick way that will just overwrite the compiler in place.</p>
<h3>opam monorepo</h3>
<p>The <a href="https://github.com/ocamllabs/opam-monorepo"><code>opam monorepo</code></a> plugin lets you assemble standalone dune workspaces with your projects and all of their opam dependencies, letting you build it all from scratch using only Dune and OCaml. This satisfies the &ldquo;monorepo&rdquo; workflow which is commonly requested by large projects that need all of their dependencies in one place. It is also being used by projects that need global cross-compilation for all aspects of a codebase (including C stubs in packages), such as the MirageOS unikernel framework.</p>
<h2>Next Steps</h2>
<p>This is anticipated to be the final beta in the 2.1 series, and we will be moving to release candidate status after this. We could really use your help with testing this release in your infrastructure and projects and let us know if you run into any blockers. If you have feature requests, please also report them on <a href="https://github.com/ocaml/opam/issues">our issue tracker</a> -- we will be planning the next release cycle once we ship opam 2.1.0 shortly.</p>

