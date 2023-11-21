---
title: 'new opam features: "opam install DIR"'
description: 'After the opam build feature was announced followed a lot of discussions,
  mainly having to do with its interface, and misleading name. The base features it
  offered, though, were still widely asked for: a way to work directly with the project
  in the current directory, assuming it contains definitions...'
url: https://ocamlpro.com/blog/2017_05_04_new_opam_features_opam_install_dir
date: 2017-05-04T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    Louis Gesbert\n  "
source:
---

<p>After the <a href="https://ocamlpro.com/blog/2017_03_16_new_opam_features_opam_build">opam build</a> feature was announced followed a lot of discussions, mainly having to do with its interface, and misleading name. The base features it offered, though, were still widely asked for:</p>
<ul>
<li>a way to work directly with the project in the current directory, assuming it contains definitions for one or more packages
</li>
<li>a way to copy the installed files of a package below a specified <code>destdir</code>
</li>
<li>an easier way to get started hacking on a project, even without an initialised opam
</li>
</ul>
<h3>Status of <code>opam build</code></h3>
<p><code>opam build</code>, as described in a <a href="https://ocamlpro.com/blog/2017_03_16_new_opam_features_opam_build">previous post</a> has been dropped. It will be absent from the next Beta, where the following replaces it.</p>
<h3>Handling a local project</h3>
<p>Consistently with what was done with local switches, it was decided, where meaningful, to overload the <code>&lt;packages&gt;</code> arguments of the commands, allowing directory names instead, and meaning &quot;all packages defined there&quot;, with some side-effects.</p>
<p>For example, the following command is now allowed, and I believe it will be extra convenient to many:</p>
<pre><code class="language-shell-session">opam install . --deps-only
</code></pre>
<p>What this does is find <code>opam</code> (or <code>&lt;pkgname&gt;.opam</code>) files in the current directory (<code>.</code>), resolve their installations, and install all required packages. That should be the single step before running the source build by hand.</p>
<p>The following is a little bit more complex:</p>
<pre><code class="language-shell-session">opam install .
</code></pre>
<p>This also retrieves the packages defined at <code>.</code>, <strong>pins them</strong> to the current source (using version-control if present), and installs them. Note that subsequent runs actually synchronise the pinnings, so that packages removed or renamed in the source tree are tracked properly (<em>i.e.</em> removed ones are unpinned, new ones pinned, the other ones upgraded as necessary).</p>
<p><code>opam upgrade</code>, <code>opam reinstall</code>, and <code>opam remove</code> have also been updated to handle directories as arguments, and will work on &quot;all packages pinned to that target&quot;, <em>i.e.</em> the packages pinned by the previous call to <code>opam install &lt;dir&gt;</code>. In addition, <code>opam remove &lt;dir&gt;</code> unpins the packages, consistently reverting the converse <code>install</code> operation.</p>
<p><code>opam show</code> already had a <code>--file</code> option, but has also been extended in the same way, for consistency and convenience.</p>
<p>This all, of course, works well with a local switch at <code>./</code>, but the two features can be used completely independently. Note also that the directory name must be made unambiguous with a possible package name, so make sure to use <code>./foo</code> rather than just <code>foo</code> for a local project in subdirectory <code>foo</code>.</p>
<h3>Specifying a destdir</h3>
<p>This relies on installed files tracking, but was actually independent from the other <code>opam build</code> features. It is now simply a new option to <code>opam install</code>:</p>
<pre><code class="language-shell-session">opam install foo --destdir ~/local/
</code></pre>
<p>will install <code>foo</code> normally (if it isn't installed already) and copy all its installed files, following the same hierarchy, into <code>~/local</code>. <code>opam remove --destdir</code> is also supported, to remove these files.</p>
<h3>Initialising</h3>
<p>Automatic initialisation has been dropped for the moment. It was only saving one command (<code>opam init</code>, that opam will kindly print out for you if you forget it), and had two drawbacks:</p>
<ul>
<li>some important details (like shell setup for opam) were skipped
</li>
<li>the initialisation options were much reduced, so you would often have to go back to <code>opam init</code> anyway. The other possibility being to duplicate <code>init</code> options to all commands, adding lots of noise. Keeping things separate has its merits.
</li>
</ul>
<p>Granted, another command, <code>opam switch create .</code>, was made implicit. But using a local switch is a user choice, and worse, in contradiction with the previous de facto opam default, so not creating one automatically seems safer: having to specify <code>--no-autoinit</code> to <code>opam build</code> in order to get the more simple behaviour was inconvenient and error-prone.</p>
<p>One thing is provided to help with initialisation, though: <code>opam switch create &lt;dir&gt;</code> has been improved to handle package definitions at <code>&lt;dir&gt;</code>, and will use them to choose a compatible compiler, as <code>opam build</code> did. This avoids the frustration of creating a switch, then finding out that the package wasn't compatible with the chosen compiler version, and having to start over with an explicit choice of a different compiler.</p>
<p>If you would really like automatic initialisation, and have a better interface to propose, your feedback is welcome!</p>
<h3>More related options</h3>
<p>A few other new options have been added to <code>opam install</code> and related commands, to improve the project-local workflows:</p>
<ul>
<li><code>opam install --keep-build-dir</code> is now complemented with <code>--reuse-build-dir</code>, for incremental builds within opam (assuming your build-system supports it correctly). At the moment, you should specify both on every upgrade of the concerned packages, or you could set the <code>OPAMKEEPBUILDDIR</code> and <code>OPAMREUSEBUILDDIR</code> environment variables.
</li>
<li><code>opam install --inplace-build</code> runs the scripts directly within the source dir instead of a dedicated copy. If multiple packages are pinned to the same directory, this disables parallel builds of these packages.
</li>
<li><code>opam install --working-dir</code> uses the working directory state of your project, instead of the state registered in the version control system. Don't worry, opam will warn you if you have uncommitted changes and forgot to specify <code>--working-dir</code>.
</li>
</ul>
<blockquote>
<p>NOTE: this article is cross-posted on <a href="https://opam.ocaml.org/blog/">opam.ocaml.org</a> and <a href="https://ocamlpro.com/blog">ocamlpro.com</a>.</p>
</blockquote>
<h1>Comments</h1>
<p>Hez Carty (4 May 2017 at 21 h 30 min):</p>
<blockquote>
<p>Would a command like &ldquo;opam init $DIR&rdquo; and &ldquo;opam init $DIR &ndash;deps-only&rdquo; work for an auto-intialization interface? Ideally creating the equivalent to a bare .opam/ using $DIR as $OPAMROOT + install a local switch + &ldquo;opam install .&rdquo; (with &ndash;deps-only if specified) under the newly created switch.</p>
</blockquote>
<p>Louis Gesbert (5 May 2017 at 7 h 50 min):</p>
<blockquote>
<p><code>opam init DIR</code> is currently used and means &ldquo;use DIR as your initial, default package repository&rdquo;.
Overloading <code>opam init</code> sounds like a good approach though, esp. since the default of the command is already to create an initial switch. But a new flag, e.g. <code>opam init &ndash;here</code>, could be used to mean: do <code>opam init &ndash;bare</code> (it&rsquo;s idempotent), <code>opam switch create .</code> and then <code>opam install .</code>.</p>
<p>The issue that remains is inherent to compound commands: we would have to port e.g. the <code>&ndash;deps-only</code> option to <code>opam init</code>, making the interface and doc heavier, and it would only make sense in this specific use-case ; either that or limit the expressivity of the compound command, requiring people to fallback to the individual ones when they need some more specific features.</p>
</blockquote>

