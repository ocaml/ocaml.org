---
title: 'opam 101: the first steps'
description: Welcome, dear reader, to a new series of blog posts! This series will
  be about everything opam. Each article will cover a specific aspect of the package
  manager, and make sure to dissipate any confusion or misunderstandings on this keystone
  of the OCaml distribution! Each technical article will be t...
url: https://ocamlpro.com/blog/2024_01_23_opam_101_the_first_steps
date: 2024-01-23T14:15:10-00:00
preview_image: https://ocamlpro.com/assets/img/logo_ocp_icon.svg
authors:
- "\n    Dario Pinto\n  "
source:
---

<p></p>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/opam-banniere-e1600868011587.png">
      <img src="https://ocamlpro.com/blog/assets/img/opam-banniere-e1600868011587.png" alt="Opam is like a magic box that allows people to be tidy when they share their work with the world, thus making the environment stable and predictable for everybody!"/>
    </a>
    </p><div class="caption">
      Opam is like a magic box that allows people to be tidy when they share their work with the world, thus making the environment stable and predictable for everybody!
    </div>
  
</div>

<p>Welcome, dear reader, to a new series of blog posts!</p>
<p>This series will be about everything <code>opam</code>. Each article will cover a specific
aspect of the package manager, and make sure to dissipate any confusion or
misunderstandings on this keystone of the OCaml distribution!</p>
<p>Each technical article will be tailored for specific levels of engineering --
everyone, be they beginners, intermediate or advanced in the <em>OCaml Arts</em> will
find answers to some questions about <code>opam</code> right here.</p>
<blockquote>
<p>Checkout each article's <code>tags</code> to get an idea of the entry level required for
the smoothest read possible!</p>
</blockquote>
<p></p><div>
<strong>Table of contents</strong>
<ul>
<li><a href="https://ocamlpro.com/blog/feed#onboarding">Walking the path of opam, treading on solid ground</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#install">First step: installing opam</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#opaminit">Second step: initialisation</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#opamenv">Acclimating to the environment</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#switch">Switches, tailoring your workspace to your vision</a>
<ul>
<li><a href="https://ocamlpro.com/blog/feed#createaswitch">Creating a global switch</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#switchlocal">Creating a local switch</a>
</li>
</ul>
</li>
<li><a href="https://ocamlpro.com/blog/feed#opamrepo">The official opam-repository, the safe for all your packages</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#packages">Installing packages in your current switch</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#conclusion">Conclusion</a>

</li>
</ul>
<blockquote>
<p>New to the expansive OCaml sphere? As said on the official OCaml website,
<a href="https://opam.ocaml.org/about.html#A-little-bit-of-History">Opam</a> has been a
game changer for the OCaml distribution, since it first saw the day of light
here, almost a decade ago.</p>
</blockquote>
<h2>
<a class="anchor"></a>Walking the path of opam, treading on solid ground<a href="https://ocamlpro.com/blog/feed#onboarding">&#9875;</a>
          </h2>
<p>We are aware that it can be quite a daunting task to get on-board with the
OCaml distribution. Be it because of its decentralised characteristics:
plethora of different tools, a variety of sometimes clashing <em>modi operandi</em>
and practices, usually poorly documented edge use-cases, the variety of ways to
go about having a working environment or many a different reason...</p>
<p>We have been thinking about making it easier for everyone, even the more
confirmed Cameleers, by releasing a set of blogposts progressively detailing
the depths at which <code>opam</code> can go.</p>
<p>Be sure to read these articles from the start if you are new to the beautiful
world of OCaml and, if you are already familiar, use it as a trust-worthy
documentation on speed-dial... You never know when you will have to setup an
opam installation while off-the-grid, do you ?</p>
<p>Are you ready to dive in ?</p>
<h2>
<a class="anchor"></a>First step: installing opam<a href="https://ocamlpro.com/blog/feed#install">&#9875;</a>
          </h2>
<p>First, let's talk about installing opam.</p>
<blockquote>
<p>DISCLAIMER:
In this tutorial, we will only be addressing a fresh install of <code>opam</code> on
Linux and Mac. For more information about a Windows installation, stay tuned
with this blog!</p>
</blockquote>
<p>One would expect to have to interact with the package manager of one's
favourite distribution in order to install <code>opam</code>, and, to some extent, one
would be correct. However, we cannot guarantee that the version of opam you
have at your disposal through these means is indeed the one expected by this
tutorial, and every subsequent one for that matter.</p>
<p>You can check that <a href="https://opam.ocaml.org/doc/Distribution.html">here</a>, make
sure the version available to you is <code>2.1.5</code> or above.</p>
<p>Thus, in order for us to guarantee that we are on the same version, we will use
the installation method found <a href="https://opam.ocaml.org/doc/Install.html">here</a>
and add an option to specify the version of opam we will be working with from
now on.</p>
<p>Note that if you <strong>don't</strong> add the <code>--version 2.1.5</code> option to the following
command line, the script will download and install the <strong>latest</strong> opam release.
The cli of <code>opam</code> is made to remain consistent between versions so, unless you
have a very old version, or if you read this article in the very distant
future, you should not have problems by not using the <strong>exact</strong> same version as
we do. For the sake of consistency though, I will use this specific version.</p>
<pre><code class="language-shell-session">$ bash -c &quot;sh &lt;(curl -fsSL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh) --version 2.1.5&quot;
</code></pre>
<p>This script will download the necessary binaries for a proper installation of
<code>opam</code>. Once done, you can move on to the nitty gritty of having a working
<code>opam</code> environment with <code>opam init</code>.</p>
<h2>
<a class="anchor"></a>Second step: initialisation<a href="https://ocamlpro.com/blog/feed#opaminit">&#9875;</a>
          </h2>
<p>The first command to launch, after the initial <code>opam</code> binaries have been
downloaded and <code>opam</code> has been installed on your system, is <code>opam init</code>.</p>
<p>This is when you step into the OCaml distribution for the first time.</p>
<p><code>opam init</code> does several crucial things for you when you launch it, and the
rest of this article will detail what exactly these crucial things are and what
they mean:</p>
<ul>
<li>it checks some required and recommended tools;
</li>
<li>it syncs with the official OCaml <strong>opam-repository</strong>, which you can find
<a href="https://github.com/ocaml/opam-repository">here</a>;
</li>
<li>it sets up the <strong>opam environment</strong> in your <code>*rc</code> files;
</li>
<li>it creates a <strong>switch</strong> and installs an <strong>ocaml-compiler</strong> for you;
</li>
</ul>
<p>Lets take a step-by-step look at the output of that command:</p>
<pre><code class="language-shell-session">$ opam init
No configuration file found, using built-in defaults.
Checking for available remotes: rsync and local, git, mercurial, darcs.
Perfect!

&lt;&gt;&lt;&gt; Fetching repository information &gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;
[default] Initialised

&lt;&gt;&lt;&gt; Required setup - please read &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;

  In normal operation, opam only alters files within ~/.opam.

  However, to best integrate with your system, some environment
  variables should be set. If you allow it to, this initialisation
  step will update your bash configuration by adding the following
  line to ~/.profile:

    test -r ~/.opam/opam-init/init.sh &amp;&amp; . ~/.opam/opam-init/init.sh &gt; /dev/null 2&gt; /dev/null || true

  Otherwise, every time you want to access your opam installation,
  you will need to run:

    eval $(opam env)

  You can always re-run this setup with 'opam init' later.

Do you want opam to modify ~/.profile? [N/y/f]
(default is 'no', use 'f' to choose a different file) y

User configuration:
  Updating ~/.profile.
[NOTE] Make sure that ~/.profile is well sourced in your ~/.bashrc.


&lt;&gt;&lt;&gt; Creating initial switch 'default' (invariant [&quot;ocaml&quot; {&gt;= &quot;4.05.0&quot;}] - initially with ocaml-base-compiler)

&lt;&gt;&lt;&gt; Installing new switch packages &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;
Switch invariant: [&quot;ocaml&quot; {&gt;= &quot;4.05.0&quot;}]

&lt;&gt;&lt;&gt; Processing actions &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;
&lowast; installed base-bigarray.base
&lowast; installed base-threads.base
&lowast; installed base-unix.base
&lowast; installed ocaml-options-vanilla.1
&#11015; retrieved ocaml-base-compiler.5.1.0  (https://opam.ocaml.org/cache)
&lowast; installed ocaml-base-compiler.5.1.0
&lowast; installed ocaml-config.3
&lowast; installed ocaml.5.1.0
&lowast; installed base-domains.base
&lowast; installed base-nnp.base
Done.
</code></pre>
<p>The main result for an <code>opam init</code> call is to setup what is called your <code>opam root</code>. It does so by creating a <code>~/.opam</code> directory to operate inside of.
<code>opam</code> modifies and writes in this location <strong>only</strong> as a default.</p>
<hr/>
<p>First, <code>opam</code> checks that there is at least one required tool for syncing to
the <code>opam-repository</code>. Then it checks what backends are available in your
system. Here all are available: <code>rsync, git, mercurial, and darcs</code>. They will
be used to sync repositories or packages.</p>
<pre><code class="language-shell-session">$ opam init
No configuration file found, using built-in defaults.
Checking for available remotes: rsync and local, git, mercurial, darcs.
Perfect!
</code></pre>
<p>Then, <code>opam</code> fetches the default opam repository: <code>opam.ocaml.org</code>.</p>
<pre><code class="language-shell-session">&lt;&gt;&lt;&gt; Fetching repository information &gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;
[default] Initialised
</code></pre>
<hr/>
<p>Secondly, <code>opam</code> requires your input in order to configure your shell for the
smoothest possible experience. For more details about the opam environment,
refer to the next section.</p>
<blockquote>
<p>Something interesting to remember for later is, in the excerpt below, we
grant opam with the permission to edit the <code>~/.profile</code> file. This part of
the Quality of Life features for an everyday use an <code>opam</code> environment and we
will detail how so below.</p>
</blockquote>
<pre><code class="language-shell-session">&lt;&gt;&lt;&gt; Required setup - please read &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;

  In normal operation, opam only alters files within ~/.opam.

  However, to best integrate with your system, some environment
  variables should be set. If you allow it to, this initialisation
  step will update your bash configuration by adding the following
  line to ~/.profile:

    test -r ~/.opam/opam-init/init.sh &amp;&amp; . ~/.opam/opam-init/init.sh &gt; /dev/null 2&gt; /dev/null || true

  Otherwise, every time you want to access your opam installation,
  you will need to run:

    eval $(opam env)

  You can always re-run this setup with 'opam init' later.

Do you want opam to modify ~/.profile? [N/y/f]
(default is 'no', use 'f' to choose a different file) y

User configuration:
  Updating ~/.profile.
[NOTE] Make sure that ~/.profile is well sourced in your ~/.bashrc.

</code></pre>
<hr/>
<p>The next action is the installation of your very first <code>switch</code> alongside a
version of the OCaml compiler, by default a compiler &gt;= <code>4.05.0</code> to be exact.</p>
<p>For more information about what is a <code>switch</code> be sure to read <a href="https://ocamlpro.com/blog/feed#switch">the rest of the
article</a>.</p>
<pre><code class="language-shell-session">&lt;&gt;&lt;&gt; Creating initial switch 'default' (invariant [&quot;ocaml&quot; {&gt;= &quot;4.05.0&quot;}] - initially with ocaml-base-compiler)

&lt;&gt;&lt;&gt; Installing new switch packages &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;
Switch invariant: [&quot;ocaml&quot; {&gt;= &quot;4.05.0&quot;}]

&lt;&gt;&lt;&gt; Processing actions &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;
&lowast; installed base-bigarray.base
&lowast; installed base-threads.base
&lowast; installed base-unix.base
&lowast; installed ocaml-options-vanilla.1
&#11015; retrieved ocaml-base-compiler.5.1.0  (https://opam.ocaml.org/cache)
&lowast; installed ocaml-base-compiler.5.1.0
&lowast; installed ocaml-config.3
&lowast; installed ocaml.5.1.0
&lowast; installed base-domains.base
&lowast; installed base-nnp.base
Done.
</code></pre>
<p><strong>Great! So let's focus on the actions performed by the <code>opam init</code> call!</strong></p>
<h2>
<a class="anchor"></a>Acclimating to the environment<a href="https://ocamlpro.com/blog/feed#opamenv">&#9875;</a>
          </h2>
<p>Well, as said previously, the first action was to setup an <code>opam root</code> in your
<code>$HOME</code> directory, (i.e: <code>~/.opam</code>). This is where <code>opam</code> will operate. <code>opam</code>
will never modify other locations in your filesystem without notifying you
first.</p>
<p>An <code>opam</code> root is made to resemble a linux-like architecture. You will find
inside it directories such as <code>/usr</code>, <code>/etc</code>, <code>/bin</code> and so on. This is by
default where <code>opam</code> will store everything relative to your system-wide
installation. Config files, packages and their configurations, and also
binaries.</p>
<p>This leads us to the need for an <code>eval $(opam env)</code> call.</p>
<p>Indeed, in order to make your binaries and such accessible as system-wide
tools, you need to update all the relevant environment variables (<code>PATH</code>,
<code>MANPATH</code>, etc.) with all the locations for all of your everyday OCaml tools.</p>
<p>To see what variables are exported when evaluating the <code>opam env</code> command, you
can check the following codeblock:</p>
<pre><code class="language-shell-session">$ opam env
OPAM_SWITCH_PREFIX='~/.opam/default'; export OPAM_SWITCH_PREFIX;
CAML_LD_LIBRARY_PATH='~/.opam/default/lib/stublibs:~/.opam/default/lib/ocaml/stublibs:~/.opam/default/lib/ocaml'; export CAML_LD_LIBRARY_PATH;
OCAML_TOPLEVEL_PATH='~/.opam/default/lib/toplevel'; export OCAML_TOPLEVEL_PATH;
MANPATH=':~/.opam/default/man'; export MANPATH;
PATH='~/.opam/default/bin:$PATH'; export PATH;
</code></pre>
<p>Remember when we granted <code>opam init</code> with the permission to edit the <code>~/.profile</code>
file, earlier in this tutorial ? That comes in handy now: it keeps us from
having to use the <code>eval $(opam env)</code> more than necessary.</p>
<p>Indeed, you would otherwise have to call it every time you launch a new shell
among other things. What it does instead is adding hook at prompt level that
keeps <code>opam</code> environment synced, updating it every time the user presses
<code>Enter</code>. Very handy indeed.</p>
<h2>
<a class="anchor"></a>Switches, tailoring your workspace to your vision<a href="https://ocamlpro.com/blog/feed#switch">&#9875;</a>
          </h2>
<p>The second task accomplished by <code>opam init</code> was installing the first <code>switch</code>
inside your fresh installation.</p>
<p>A <code>switch</code> is one of opam's core operational concepts, it's definition can vary
depending on your exact use-case but in the case of OCaml, a <code>switch</code> is a
<strong>named pair</strong>:</p>
<ul>
<li>an arbitrary version of the OCaml compiler
</li>
<li>a list of packages available for that specific version of the compiler.
</li>
</ul>
<p>In our example, we see that the only packages installed in the process were the
dependencies for the OCaml compiler version <code>5.1.0</code> inside the <code>switch</code> named
<code>default</code>.</p>
<pre><code class="language-shell-session">&lt;&gt;&lt;&gt; Creating initial switch 'default' (invariant [&quot;ocaml&quot; {&gt;= &quot;4.05.0&quot;}] - initially with ocaml-base-compiler)

&lt;&gt;&lt;&gt; Installing new switch packages &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;
Switch invariant: [&quot;ocaml&quot; {&gt;= &quot;4.05.0&quot;}]

&lt;&gt;&lt;&gt; Processing actions &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;
&lowast; installed base-bigarray.base
&lowast; installed base-threads.base
&lowast; installed base-unix.base
&lowast; installed ocaml-options-vanilla.1
&#11015; retrieved ocaml-base-compiler.5.1.0  (https://opam.ocaml.org/cache)
&lowast; installed ocaml-base-compiler.5.1.0
&lowast; installed ocaml-config.3
&lowast; installed ocaml.5.1.0
&lowast; installed base-domains.base
&lowast; installed base-nnp.base
Done.
</code></pre>
<p>You can create an arbitrary amount of parallel <code>switches</code> in opam. This allows
users to manage parallel, independent OCaml environments for their
developments.</p>
<p>There are two types of <code>switches</code>:</p>
<ul>
<li><code>global switches</code> have their packages, binaries and tools available
anywhere on your computer. They are useful when you consider a given <code>switch</code>
to be your default and most adequate environment for your everyday use of
<code>opam</code> and OCaml.
</li>
<li><code>local switches</code> on the other hand are only available in a given directory.
Their packages and binaries are local to that <strong>specific</strong> directory. This
allows users to make specific projects have their own self-contained
working environments. The local switch is automatically selected by <code>opam</code> as
the current one when you are located inside the appropriate directory. More
details on local switches below.
</li>
</ul>
<p>The default behaviour for <code>opam</code> when creating a <code>switch</code> at init-time is to
make it global and name it <code>default</code>.</p>
<pre><code class="language-shell-session">$ opam switch show
default
$ opam switch
#  switch   compiler     description
&rarr;  default  ocaml.5.1.0  default
</code></pre>
<p>Now that you have a general understanding of what exactly is a <code>switch</code> and how
it is used, let's get into how you can go about manually creating your first
<code>switch</code>.</p>
<h3>
<a class="anchor"></a>Creating a global switch<a href="https://ocamlpro.com/blog/feed#createaswitch">&#9875;</a>
          </h3>
<blockquote>
<p>NB:
Remember that <code>opam</code>'s command-line interface is beginner friendly. You can,
at any point of your exploration, use the <code>--help</code> option to have every
command and subcommand explained. You may also checkout the <a href="https://ocamlpro.github.io/ocaml-cheat-sheets/ocaml-opam.pdf">opam
cheat-sheet</a> that was released a while ago and might still hold some
precious insights on opam's cli.</p>
</blockquote>
<p>So how does one create a <code>switch</code> ? The short answer is bafflingly
straightforward:</p>
<pre><code class="language-shell-session"># Installs a switch named &quot;my-switch&quot; based OCaml compiler version &gt; 4.05.0
# Here 4.05 is the default lower compiler version opam selects when unspecified
$ opam switch create my-switch
</code></pre>
<p>Easy, right? Now let's imagine that you would like to specify a <strong>later</strong> version
of the OCaml compiler. The first thing you would want to know is which version
are available for you to specify, and you can use <code>opam list</code> for that.</p>
<p>Other commands can be used to the same effect but we prefer introducing you to
this specific one as it may also be used for any other package available via
<code>opam</code>.</p>
<p>So, as for any other package than <code>ocaml</code> itself, <code>opam list</code> will give you all
available versions of that package for your currently active <code>switch</code>. Since we
don't yet have an OCaml compiler installed, it will list all of them so that we
may pick and choose our favourite to use for the <code>switch</code> we are making.</p>
<pre><code class="language-shell-session">$ opam list ocaml
# Packages matching: name-match(ocaml) &amp; (installed | available)
# Package    # Installed # Synopsis
ocaml.3.07   --          The OCaml compiler (virtual package)
ocaml.3.07+1 --          The OCaml compiler (virtual package)
ocaml.3.07+2 --          The OCaml compiler (virtual package)
ocaml.3.08.0 --          The OCaml compiler (virtual package)
(...)
ocaml.4.13.1 --          The OCaml compiler (virtual package)
ocaml.4.13.2 --          The OCaml compiler (virtual package)
(...)
ocaml.5.2.0  --          The OCaml compiler (virtual package)
</code></pre>
<p>Let's use it for a switch:</p>
<pre><code class="language-shell-session"># Installs a switch named &quot;my-switch&quot; based OCaml compiler version = 4.13.1
$ opam switch create my-switch ocaml.4.13.1
</code></pre>
<p>That's it, for the first time, you have manually created your own <code>global switch</code> tailored to your specific needs, congratulations!</p>
<blockquote>
<p>NB:
Creating a switch can be a fairly time-consuming task depending on whether or
not the compiler version you have queried from <code>opam</code> is already installed on
your machine, typically in a previously created <code>switch</code>.
Every time you ask <code>opam</code> to install a version of the compiler, it will first
scour your installation for a locally available version of that compiler to
save you the time necessary for downloading, compiling and installing a brand
new one.</p>
</blockquote>
<p>Now, onto <code>local switches</code>.</p>
<h3>
<a class="anchor"></a>Creating a local switch<a href="https://ocamlpro.com/blog/feed#switchlocal">&#9875;</a>
          </h3>
<p>As said previously, the use of a <code>local switch</code> is to constrain a specific
OCaml environment to a specific location on your workstation.</p>
<p>Let's imagine you are about to start a new development called <code>my-project</code>.</p>
<p>While preparing all necessary pre-requisites for it, you notice something
problematic: your global <code>default</code> switch is drastically incompatible with the
dependencies of your project.
In this imaginary situation, you have a <code>default</code> global switch that is useful
for most of your other tasks but now have only one project that differs from
your usual usage of OCaml.</p>
<p>To remedy this situation, you could go about creating another global switch
for your upcoming dev requirements on <code>my-project</code> and proceed to install all
relevant packages and remake a full <code>switch</code> from scratch for that specific
project. However this would require you to always keep track of which one is
your currently active <code>switch</code>, while possibly having to regularly oscillate
between your global <code>default</code> switch and your alternative global <code>my-project</code>
switch which you could understandably find to be suboptimal and tedious to
incorporate to your workflow on the long run.</p>
<p>That's when <code>local switches</code> come in handy because they allow you to leave the
rest of your OCaml dev environment unaffected by whatever out-of-bounds or
specific workload you're undertaking. Additionally, the fact that <code>opam</code>
automatically selects your <code>local switch</code> as your current active one as soon as
you step inside the relevant directory makes the developers's context switch
seemless.</p>
<p>Let's examine how you can create such a <code>switch</code>:</p>
<pre><code class="language-shell-session"># Hop inside the directory of your project
$ cd my-project
# We consider your project already has an opam file describing only
# its main dependency: ocaml.4.14.1
$ opam switch create .

&lt;&gt;&lt;&gt; Installing new switch packages &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;
Switch invariant: [&quot;ocaml&quot; {&gt;= &quot;4.05.0&quot;}]

&lt;&gt;&lt;&gt; Processing actions &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;
&lowast; installed base-bigarray.base
&lowast; installed base-threads.base
&lowast; installed base-unix.base
&lowast; installed ocaml-system.4.14.1
&lowast; installed ocaml-config.2
&lowast; installed ocaml.4.14.1
Done.
$ opam switch
#  switch                   compiler      description
&rarr;  /home/ocp/my-project     ocaml.4.14.1  /home/ocp/my-project
   default                  ocaml.5.1.0   default
   my-switch                ocaml.4.13.1  my-switch

[NOTE] Current switch has been selected based on the current directory.
       The current global system switch is default.
</code></pre>
<p>Here it is, you can now hop into your local switch <code>/home/ocp/my-project</code>
whenever you have time to deviate from your global environment.</p>
<h2>
<a class="anchor"></a>The official opam-repository, the safe for all your packages<a href="https://ocamlpro.com/blog/feed#opamrepo">&#9875;</a>
          </h2>
<p>Among all the things that <code>opam init</code> did when it was executed, there is still
one detail we have yet to explain and that's the first action of the process:
retrieving packages specification from the official OCaml <code>opam-repository</code>.</p>
<p>Explaining what exactly an <code>opam-repository</code> is requires the recipient to have
a slightly deeper understanding of how <code>opam</code> works than the average reader
this article was written for might have; so you will have to wait for us to go
deeper into that subject in another blogpost when the time is ripe.</p>
<p>What we <strong>will</strong> do now though is explain what the official OCaml
<code>opam-repository</code> is and how it relates to our use of <code>opam</code> in this blog post.</p>
<p><a href="https://github.com/ocaml/opam-repository">The Official OCaml opam-repository</a>
is an open-source project where all released software of the OCaml
distributions are <strong>referenced</strong>. It holds different compilers, basic tools,
thousands of libraries, approximatively 4500 packages in total as of today and
is configured to be the default repository for <code>opam</code> to sync to. You may add
your own repositories for your own use of <code>opam</code>, but again, that's a subject
for another time.</p>
<p>In case the repository itself is not what you are looking for, know that all
packages available throughout the entire OCaml distribution may be browsed
directly on <a href="https://ocaml.org/packages">ocaml.org</a>.</p>
<p>It is essentially a collection of <code>opam packages</code> described in <code>opam file</code>
format. Checkout <a href="https://opam.ocaml.org/doc/Manual.html#opam">the manual</a> for
more information about the <code>opam file</code> format.</p>
<p>A short explanation for it is that an <code>opam package</code> file holds every
information necessary for <code>opam</code> to operate and provide. The file lists all of
the packages direct dependencies, where to find its source code, the names and
emails of maintainers and authors, different checksums for each archive release and the
list goes on.</p>
<p>Here's a quick example for you to have an idea of what it looks like:</p>
<pre><code class="language-shell-session">opam-version: &quot;2.0&quot;
synopsis: &quot;OCaml bindings to Zulip API&quot;
maintainer: [&quot;Dario Pinto &lt;dario.pinto@ocamlpro.com&gt;&quot;]
authors: [&quot;Mohamed Hernouf &lt;mohamed.hernouf@ocamlpro.com&gt;&quot;]
license: &quot;LGPL-2.1-only WITH OCaml-LGPL-linking-exception&quot;
homepage: &quot;https://github.com/OCamlPro/ozulip&quot;
doc: &quot;https://ocamlpro.github.io/ozulip&quot;
bug-reports: &quot;https://github.com/OCamlPro/ozulip/issues&quot;
dev-repo: &quot;git+https://github.com/OCamlPro/ozulip.git&quot;
tags: [&quot;zulip&quot; &quot;bindings&quot; &quot;api&quot;]
depends: [
  &quot;ocaml&quot; {&gt;= &quot;4.10&quot;}
  &quot;dune&quot; {&gt;= &quot;2.0&quot;}
  &quot;ez_api&quot; {&gt;= &quot;2.0.0&quot;}
  &quot;re&quot;
  &quot;base64&quot;
  &quot;json-data-encoding&quot; {&gt;= &quot;1.0.0&quot;}
  &quot;logs&quot;
  &quot;lwt&quot; {&gt;= &quot;5.4.0&quot;}
  &quot;ez_file&quot; {&gt;= &quot;0.3.0&quot;}
  &quot;cohttp-lwt-unix&quot;
  &quot;yojson&quot;
  &quot;logs&quot;
]
build: [ &quot;dune&quot; &quot;build&quot; &quot;-p&quot; name &quot;-j&quot; jobs &quot;@install&quot; ]
url {
  src: &quot;https://github.com/OCamlPro/ozulip/archive/refs/tags/0.1.tar.gz&quot;
  checksum: [
    &quot;md5=4173fefee440773dd0f8d7db5a2e01e5&quot;
    &quot;sha512=cb53870eb8d41f53cf6de636d060fe1eee6c39f7c812eacb803b33f9998242bfb12798d4922e7633aa3035cf2ab98018987b380fb3f380f80d7270e56359c5d8&quot;
  ]
}
</code></pre>
<p>Okay so now, how do we go about populating a <code>switch</code> with packages and really get started?</p>
<h2>
<a class="anchor"></a>Installing packages in your current switch<a href="https://ocamlpro.com/blog/feed#packages">&#9875;</a>
          </h2>
<p>It's elementary. This simple command will do the trick of <em>trying</em> to install a
package, <strong>and its dependencies</strong>, in your currently active <code>switch</code>.</p>
<pre><code class="language-shell-session">$ opam install my-package
</code></pre>
<p>I say <em>trying</em> because <code>opam</code> will notify you if the current package version
and its dependencies you are querying are or not compatible with the current
state of your <code>switch</code>. It will also offer you solutions for the compatibility
constraints between packages to be satisfiable: it may suggest to upgrade some
of your packages, or even to remove them entirely.</p>
<p>The key thing about this process is that <code>opam</code> is designed to solve
compatibility constraints in the global graph of dependencies that the OCaml
packages form. This design is what makes <code>opam</code> the average Cameleer's best
friend. It will highlight inconsistencies within dependencies, it will figure
out a way for your specific query to be satisfiable somehow and save you <strong>a
lot</strong> of headscratching, that is, if you are willing to accommodate a bit of
<em>getting-used to</em>.</p>
<p>The next command allows you to uninstall a package from your currently active
<code>switch</code> <strong>as well as</strong> the packages that depend on it:</p>
<pre><code class="language-shell-session">$ opam remove my-package
</code></pre>
<p>And the two following will <code>update</code> the state of the repositories <code>opam</code> is
synchronised with and <code>upgrade</code> the packages installed while <strong>always</strong> keeping
package compatibility in mind.</p>
<pre><code class="language-shell-session">$ opam update
$ opam upgrade
</code></pre>
<h2>
<a class="anchor"></a>Conclusion<a href="https://ocamlpro.com/blog/feed#conclusion">&#9875;</a>
          </h2>
<p>Here it is, you should now be knowledgeable enough about Opam to jump right in
the OCaml discovery!</p>
<p>Today we learned everything elementary about <code>opam</code>.</p>
<p>From installation, to initialisation and explanations about the core concepts
of the <code>opam</code> environment, <code>switches</code>, packages and the Official OCaml
<code>opam-repository</code>.</p>
<p>Be sure to stay tuned with our blog, the journey into the rabbit hole has only
started and <code>opam</code> is a deep one indeed!</p>
<hr/>
<p>Thank you for reading,</p>
<p>From 2011, with love,</p>
<p>The OCamlPro Team</p>
</div>
