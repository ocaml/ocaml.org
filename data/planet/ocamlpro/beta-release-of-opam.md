---
title: Beta Release of OPAM
description: OPAM is a source-based package manager for OCaml. It supports multiple
  simultaneous compiler installations, flexible package constraints, and a Git-friendly
  development workflow. I have recently announced the beta-release of OPAM on the
  caml-list, and this blog post introduces the basics to new OPAM...
url: https://ocamlpro.com/blog/2013_01_17_beta_release_of_opam
date: 2013-01-17T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    Louis Gesbert\n  "
source:
---

<p>OPAM is a source-based package manager for OCaml. It supports
multiple simultaneous compiler installations, flexible package
constraints, and a Git-friendly development workflow. I have recently
announced the beta-release of OPAM on the <a href="https://sympa.inria.fr/sympa/arc/caml-list/2013-01/msg00073.html">caml-list</a>, and this blog post introduces the basics to new OPAM users.</p>
<h3>Why OPAM</h3>
<p>We have decided to start writing a brand new package manager for
OCaml in the beginning of 2012, after looking at the state of affairs in
the OCaml community and not being completely satisfied with the
existing solutions, especially regarding the management of dependency
constraints between packages. Existing technologies such as GODI, oasis,
odb and ocamlbrew did contain lots of good ideas that we shamelessly
stole but the final user-experience was not so great &mdash; and we disagreed
with some of the architectural choices, so it wasn&rsquo;t so easy to
contribute to fix the existing flaws. Thus we started to discuss the
specification of a new package manager with folks from <a href="https://www.janestreet.com/">Jane Street</a> who decided to fund the project and from the <a href="https://www.mancoosi.org/">Mancoosi project</a>
to integrate state-of-the-art dependency management technologies. We
then hired an engineer to do the initial prototyping work &mdash; and this
effort finally gave birth to OPAM!</p>
<h3>Installing OPAM</h3>
<p>OPAM packages are already available for homebrew, macports and
arch-linux. Debian and Ubuntu packages should be available quite soon.
In any cases, you can either use a <a href="https://github.com/ocaml/opam/blob/master/shell/opam_installer.sh">binary installer</a> or simply install it from <a href="https://github.com/OCamlPro/opam/archive/0.9.1.tar.gz">sources</a>. To learn more about the installation process, read the <a href="https://opam.ocamlpro.com/doc/Quick_Install.html">installation instructions</a>.</p>
<h3>Initializing OPAM</h3>
<p>Once you&rsquo;ve installed OPAM, you have to initialize it. OPAM will store all its state under <code>~/.opam</code>,
so if you want to reset your OPAM configuration, simply remove that
directory and restart from scratch. OPAM can either use the compiler
installed on your system or it can also install a fresh version of the
compiler:</p>
<pre><code class="language-shell-session">$ opam init # Use the system compiler&lt;br&gt;
$ opam init &ndash;comp 4.00.1 # Use OCaml 4.00.1&lt;br&gt;
</code></pre>
<p>OPAM will prompt you to add a shell script fragment to your <code>.profile</code>.
It is highly recommended to follow these instructions, as it let OPAM
set-up correctly the environment variables it needs to compile and
configure the packages.</p>
<h3>Getting help</h3>
<p>OPAM user manual is integrated:</p>
<pre><code class="language-shell-session">$ opam &ndash;help # Get help on OPAM itself
$ opam init &ndash;help # Get help on the init sub-command
</code></pre>
<h3>Basic commands</h3>
<p>Once OPAM is initialized, you can ask it to list the available
packages, get package information and search for a given pattern in
package descriptions:</p>
<pre><code class="language-shell-session">$ opam list *foo* # list all the package containing &lsquo;foo&rsquo; in their name
$ opam info foo # Give more information on the &lsquo;foo&rsquo; package
$ opam search foo # search for the string &lsquo;foo&rsquo; in all package descriptions
</code></pre>
<p>Once you&rsquo;ve found a package you would like to install, just run the usual <code>install</code> command.</p>
<pre><code class="language-shell-session">$ opam install lwt # install lwt and its dependencies
$ opam remove lwt # remove lwt and its dependencies
</code></pre>
<p>Later on, you can check whether new packages are available and you can upgrade your package installation.</p>
<pre><code class="language-shell-session">$ opam update # check if new packages are available
$ opam upgrade # upgrade your packages to the latest version
</code></pre>
<p>Casual users of OCaml won&rsquo;t need to know more about OPAM. Simply
remind to update and upgrade OPAM regularly to keep your system
up-to-date.</p>
<h3>Use-case 1: Managing Multiple Compilers</h3>
<p>A new release of OCaml is available and you want to be able to use it. How to do this in OPAM ? This is as simple as:</p>
<pre><code class="language-shell-session">$ opam update # pick-up the latest compiler descriptions
$ opam switch 4.00.2 # switch to the new 4.00.2 release
$ opam switch export &ndash;switch=system | opam switch import -y
</code></pre>
<p>The first line will get the latest package and compiler descriptions,
and will tell you if new packages or new compilers are available.
Supposing that 4.00.2 is now available, you can then <code>switch</code>
to that version using the second command. The last command imports all
the packages installed by OPAM for the OCaml compiler installed on your
system (if any).</p>
<p>You can also easily use the latest unstable version of OCaml if you want to give it a try:</p>
<pre><code class="language-shell-session">$ opam switch 4.01.0dev+trunk # install trunk
$ opam switch reinstall 4.01.0dev+trunk # reinstall trunk
</code></pre>
<p>Reinstalling trunk means getting the latest changesets and recompiling the packages already installed for that compiler switch.</p>
<h3>Use-case 2: Managing Multiple Repositories</h3>
<p>Sometimes, you want to let people use a new version of your software
early. Or you are working in a company and expose internal libraries to
your coworkers but you don&rsquo;t want them to be available to anybody using
OPAM. How can you do that with OPAM? It&rsquo;s easy! You can set-up your own
repository (see for instance <a href="https://github.com/xen-org/opam-repo-dev/">xen-org</a>&lsquo;s development packages) and add it to your OPAM configuration:</p>
<pre><code class="language-shell-session">$ opam repository list # list the repositories available in your config
$ opam repository add xen-org git://github.com/xen-org/opam-repo-dev.git
$ opam repository list # new xen-org repository available
</code></pre>
<p>This will add the repository to your OPAM configuration and it will display the newly available packages. The next time you run <code>opam update</code> OPAM will then scan for any change in the remote git repository.</p>
<p>Repositories can either be local (e.g. on your filesystem), remote (available through HTTP) and stored in git or darcs.</p>
<h3>Use-case 3: Using Development Packages</h3>
<p>You want to try the latest version of a package which have not yet
been released, or you have a patched version of a package than you want
to try. How could you do it? OPAM has a <code>pin</code> sub-command which let you do that easily:</p>
<pre><code class="language-shell-session">$ opam pin lwt /local/path/
$ opam install lwt # install the version of lwt stored in /local/path
</code></pre>
<p>You can also use a given branch in a given git repository. For instance, if you want the library <code>re</code> to be compiled with the code in the <code>experimental</code> branch of its development repository you can do:</p>
<pre><code class="language-shell-session">$ opam pin re git://github.com/ocaml/ocaml-re.git#experimental
$ opam install re
</code></pre>
<p>When building the packages, OPAM will use the path set-up with the
pin command instead of using the upstream archives. Also, on the next
update, OPAM will automatically check whether some changes happened and
if the packages needs to be recompiled:</p>
<pre><code class="language-shell-session">$ opam update lwt # check for changes in /local/path
$ opam update re # check for change in the remote git branch
$ opam upgrade lwt re # upgrade re and lwt if necessary
</code></pre>
<h3>Conclusion</h3>
<p>I&rsquo;ve briefly explained some of the main features of OPAM. If you want to go further, I would advise to read the <a href="https://opam.ocamlpro.com/doc/Advanced_Usage.html">user</a> and <a href="https://opam.ocamlpro.com/doc/Packaging.html">packager</a> tutorials. If you really want to understand the internals of OPAM, you can also read the <a href="https://github.com/OCamlPro/opam/blob/master/doc/dev-manual/dev-manual.pdf?raw=true">developer manual</a>.</p>

