---
title: 'Opam 102: Pinning Packages'
description: Welcome, dear reader, to a new opam blog post! Today we take an additional
  step down the metaphorical rabbit hole with opam pin, the easiest way to catch a
  ride on the development version of a package in opam. We are aware that our readers
  are eager to see these blog posts venture on the developer s...
url: https://ocamlpro.com/blog/2024_03_25_opam_102_pinning_packages
date: 2024-03-25T13:48:01-00:00
preview_image: https://ocamlpro.com/assets/img/logo_ocp_icon.svg
featured:
authors:
- "\n    Dario Pinto\n  "
source:
---

<p></p>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/opam102_pins.svg">
      <img src="https://ocamlpro.com/blog/assets/img/opam102_pins.svg" alt="Pins standout. They help us anchor interest points, thus helping us focus on what's important. They become the catalyst for experimentation and help us navigating the strong safety features that opam provides users with."/>
    </a>
    </p><div class="caption">
      Pins standout. They help us anchor interest points, thus helping us focus on what's important. They become the catalyst for experimentation and help us navigating the strong safety features that opam provides users with.
    </div>
  
</div>

<p>Welcome, dear reader, to a new opam blog post!</p>
<p>Today we take an additional step down the metaphorical rabbit hole with <code>opam pin</code>, the easiest way to catch a ride on the development version of a package
in <code>opam</code>.</p>
<p>We are aware that our readers are eager to see these blog posts venture on the
developer side of the <code>opam</code> experience, and so are we, but we need to spend
just a bit little more time on the beginner and user-side of it for now so
please, bear with us! &#128059;</p>
<blockquote>
<p>This tutorial is the second one in this on-going series about the OCaml
package manager <code>opam</code>.
Be sure to read <a href="https://ocamlpro.com/blog/2024_01_23_opam_101_the_first_steps/">the first one</a> to get
up to speed.
Also, check out each article's <code>tags</code> to get an idea of the entry level
required for the smoothest read possible!</p>
</blockquote>
<blockquote>
<p><strong>New to the expansive OCaml sphere?</strong>
As said on the official opam website,
<a href="https://opam.ocaml.org/about.html#A-little-bit-of-History"><code>opam</code></a> has been a
game changer for the OCaml distribution, since it first saw the day of light
here, almost a decade ago.</p>
</blockquote>
<p></p><div>
<strong>Table of contents</strong>
<ul>
<li><a href="https://ocamlpro.com/blog/feed#opampincontext">Tutorial context</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#opampinusecase">Use-case for <code>opam pin</code></a>
<ul>
<li><a href="https://ocamlpro.com/blog/feed#opampindev">Pinning a released package development version: <code>opam pin add --dev-repo</code></a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#opampinurl">Pinning an unreleased package development version: <code>opam pin add &lt;url&gt;</code></a>
</li>
</ul>
</li>
<li><a href="https://ocamlpro.com/blog/feed#opampinoptions">Dig into opam pin, find spicy features</a>
<ul>
<li><a href="https://ocamlpro.com/blog/feed#noaction">Add a pin without installing with <code>--no-action</code></a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#updatepins">Update your pinned packages</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#unpin">Unpin packages</a>
<ul>
<li><a href="https://ocamlpro.com/blog/feed#releasedpins">Released packages</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#unreleasedpins">Unreleased packages</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#unpinnoaction">Unpin but do no action</a>
</li>
</ul>
</li>
<li><a href="https://ocamlpro.com/blog/feed#multiple">One URL to pin them all: handling a multi-package repository</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#version">Setting arbitrary version numbers, toying with fire</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#morefire">Setting multiple arbitrary version numbers</a>
</li>
</ul>
</li>
<li><a href="https://ocamlpro.com/blog/feed#conclusion">Conclusion</a>

</li>
</ul>
<h2>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#opampincontext" class="anchor-link">Tutorial context and basis</a>
          </h2>
<p>As far as context goes for this article, we will consider that you already are
familiar with the concepts introduced in our tutorial <a href="https://ocamlpro.com/blog/2024_01_23_opam_101_the_first_steps/">opam
101</a>.</p>
<p>Your current environment should thus be somewhat similar to the one we had by
the end of that tutorial. Meaning: your version of <code>opam</code> is a least <code>2.1.5</code>
(all outputs were generated with this version), you have already launched <code>opam init</code>, created a global switch <code>my-switch</code> and, possibly, you have even
populated it with a few packages with a few calls to the <code>opam install</code>
command.</p>
<p>Furthermore, keep in mind that, in this blog post, we are approaching this
subject from the perspective of a developer who is looking into integrating new
packages to his current workload, not from the perspective of someone who is
looking into sharing a project or publishing a new software.</p>
<p><code>opam pin</code> is a feature that will quickly become necessary for you to use as
you continue your exploration of <code>opam</code>. It allows for the user to <strong>pin</strong> a
given package to a specific version, or even change the source from which said
package is pulled, installed, and synchronised with from within your currently
active <code>switch</code>.</p>
<p>This feature shines the most in contexts such as:</p>
<ul>
<li>when doing ordinary <code>switch</code> management;
</li>
<li>for incorporating external, <em>still under-construction</em>, libraries to your own
current workload;
</li>
<li>when designing a specific <code>switch</code>: pinning a specific package version
will make it the main compatibility constraint for that switch, thus
tailoring the environment around it in the process.
</li>
</ul>
<blockquote>
<p><strong>Reminder</strong></p>
<p>Remember that <code>opam</code>'s command-line interface is beginner friendly. You can,
at any point of your exploration, use the <code>--help</code> option to have every
command and subcommand explained. You may also check out the <a href="https://ocamlpro.github.io/ocaml-cheat-sheets/ocaml-opam.pdf">opam
cheat-sheet</a>
that was released a while ago and still holds some precious insights on
opam's CLI.</p>
</blockquote>
<h2>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#opampinusecase" class="anchor-link">Use-case for <code>opam pin</code></a>
          </h2>
<p>Now onto today's use-cases for <code>opam pin</code>, the premise is as follows:</p>
<p>The package on which your current development depends on has just had a major
update on its <em>development</em> branch. This package is available on the opam <code>repository</code>
and its name is <a href="https://ocaml.org/p/hc/latest"><code>hc</code></a>.</p>
<p>That update introduced a new feature that you would very much like to
experiment with for your own on-going project.</p>
<p>However, that feature is still very much a <em>work-in-progress</em> and the
maintainers of <code>hc</code> are <strong>not</strong> about to release their package anytime soon...</p>
<p>That's when <code>opam pin</code> comes in. In this article, we will cover two similar
use-cases for <code>opam pin</code>, namely the one dealing with pinning a version of a
package that is already available on the <a href="https://opam.ocaml.org/packages/">opam <code>repository</code></a>, and that of pinning
a version of an unreleased package, directly from its public URL.</p>
<p>After all the basics have been laid out, we will eventually cover some of the
more underground &#9935; and dangerous &#128293; features available when pinning packages.</p>
<blockquote>
<p><strong>Important Notice</strong></p>
<p>For the sake of convenience and brevity, we will breakdown the <code>opam pin</code>
command, and some of its options, by only dealing with addresses that obey
the classic definition of the word <strong>URL</strong>.</p>
<p>However do keep in mind that <code>opam</code> uses <a href="https://opam.ocaml.org/doc/Manual.html#URLs">a broader definition
</a> for that word, going as far as
to consider a filesystem path to be a valid string for a <strong>URL</strong> argument,
thus allowing all <code>opam pin</code> calls and options to be valid when manipulating
<code>opam</code> packages inside a local filesystem or local network instead of <strong>just</strong> on the web.</p>
</blockquote>
<h3>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#opampindev" class="anchor-link">Pinning the dev version of a released package: <code>opam pin add --dev-repo</code></a>
          </h3>
<p>Picking up from the base context: our project depends on <code>hc</code>, and <code>hc</code> has
just received an update. The first option available for us to access this fresh
update on the <code>hc</code> repository is to use <code>opam pin add --dev-repo &lt;pkg&gt;</code>
command.</p>
<pre><code class="language-shell-session">$ opam pin add --dev-repo hc
[hc.0.3] synchronised (git+https://git.zapashcanon.fr/zapashcanon/hc.git)
hc is now pinned to git+https://git.zapashcanon.fr/zapashcanon/hc.git (version 0.3)

The following actions will be performed:
  &lowast; install dune 3.14.0 [required by hc]
  &lowast; install hc   0.3*
===== &lowast; 2 =====
Do you want to continue? [Y/n] y

&lt;&gt;&lt;&gt; Processing actions &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;
&#11015; retrieved hc.0.3  (no changes)
&#11015; retrieved dune.3.14.0  (https://opam.ocaml.org/cache)
&lowast; installed dune.3.14.0
&lowast; installed hc.0.3
Done.
</code></pre>
<hr/>
<h2>So what exactly did <code>opam pin</code> do here?</h2>
<pre><code class="language-shell-session">$ opam pin add --dev-repo hc
[hc.0.3] synchronised (git+https://git.zapashcanon.fr/zapashcanon/hc.git)
</code></pre>
<p>When you feed a package name to the <code>opam pin add --dev-repo</code> command, it will
first retrieve the package definition found inside the <a href="https://github.com/ocaml/opam-repository/blob/master/packages/hc/hc.0.3/opam"><code>opam file</code></a>
in the directory of the corresponding package on the <a href="https://github.com/ocaml/opam-repository">the Official OCaml opam
<code>repository</code></a> or any other opam
<code>repositories</code> that your local <code>opam</code> installation happens to be synchronised
with.</p>
<p>You can inspect said package definition directly yourself with the <code>opam show &lt;pkg&gt;</code> command.</p>
<p>Let's take a look at the package definition for <code>hc</code>:</p>
<pre><code class="language-shell-session">$ opam show hc

&lt;&gt;&lt;&gt; hc: information on all versions &gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;
name         hc
all-versions 0.0.1  0.2  0.3

&lt;&gt;&lt;&gt; Version-specific details &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;
version      0.3
repository   default
url.src      &quot;https://git.zapashcanon.fr/zapashcanon/hc/archive/0.3.tar.gz&quot;
url.checksum
          &quot;sha256=61b443056adec3f71904c5775b8521b3ac8487df618a8dcea3f4b2c91bedc314&quot;
          &quot;sha512=a1d213971230e9c7362749d20d1bec6f5e23af191522a65577db7c0f9123ea4c0fc678e5f768418d6dd88c1f3689a49cf564b5c744995a9db9a304f4b6d2c68a&quot;
homepage     &quot;https://git.zapashcanon.fr/zapashcanon/hc&quot;
doc          &quot;https://doc.zapashcanon.fr/hc/&quot;
bug-reports  &quot;https://git.zapashcanon.fr/zapashcanon/hc/issues&quot;
dev-repo     &quot;git+https://git.zapashcanon.fr/zapashcanon/hc.git&quot;
authors      &quot;L&eacute;o Andr&egrave;s &lt;contact@ndrs.fr&gt;&quot;
maintainer   &quot;L&eacute;o Andr&egrave;s &lt;contact@ndrs.fr&gt;&quot;
license      &quot;ISC&quot;
depends      &quot;dune&quot; {&gt;= &quot;3.0&quot;} &quot;ocaml&quot; {&gt;= &quot;4.14&quot;} &quot;odoc&quot; {with-doc}
synopsis     Hashconsing library
description  hc is an OCaml library for hashconsing. It provides
             easy ways to use hashconsing, in a type-safe and
             modular way and the ability to get forgetful
             memo&iuml;zation.
</code></pre>
<p>Here, you can see the <code>dev-repo</code> field which contains the URL of the
development repository of that package. Opam will use that information to
retrieve package sources for you.</p>
<hr/>
<pre><code class="language-shell-session">hc is now pinned to git+https://git.zapashcanon.fr/zapashcanon/hc.git (version 0.3)
</code></pre>
<p>Once it has retrieved <code>hc</code> sources, opam will then store the status of the pin
internally, which is that <code>hc</code> is <em>git pinned</em> to url
<code>git.zapashcanon.fr/zapashcanon/hc</code> at version <code>0.3</code>.</p>
<pre><code class="language-shell-session">$ opam pin list
hc.0.3    git  git+https://git.zapashcanon.fr/zapashcanon/hc.git
</code></pre>
<blockquote>
<p><strong>Did you know?</strong>
The default behaviour for <code>opam pin</code> is the <code>list</code> option. The option to see
all pinned packages in the current active switch.</p>
<p>On the other hand, the default behaviour for <code>opam pin &lt;target&gt;</code> command is the
<code>add</code> option. Keep it in mind if you happen to grow tired of typing <code>opam pin add &lt;target&gt;</code> every time.</p>
</blockquote>
<hr/>
<p>Opam will then analyse <code>hc</code> dependencies and compute a solution that respects
the dependencies constraints and state of your current switch (i.e. the
compatibility constraints between the packages currently installed in your
switch).</p>
<p>If it manages to do so, it will come forth with a prompt to install the pinned
package and its dependencies.</p>
<pre><code class="language-shell-session">The following actions will be performed:
  &lowast; install dune 3.14.0 [required by hc]
  &lowast; install hc   0.3*
===== &lowast; 2 =====
Do you want to continue? [Y/n] y
</code></pre>
<p>Pressing <code>Enter</code> or <code>y + Enter</code> will perform the installation.</p>
<blockquote>
<p>Notice that sometimes a <code>*</code> character is found next to some package actions? It's
the shorthand signal that the package is pinned, you can get that information
at a quick glance when <code>opam</code> outputs the actions to perform for you if you know
what to look for.</p>
</blockquote>
<pre><code class="language-shell-session">&lt;&gt;&lt;&gt; Processing actions &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;
&#11015; retrieved hc.0.3  (no changes)
&#11015; retrieved dune.3.14.0  (https://opam.ocaml.org/cache)
&lowast; installed dune.3.14.0
&lowast; installed hc.0.3
Done.
</code></pre>
<p>Congratulations, you now have a pinned <em>development</em> version of the <code>hc</code> package. You
can now start exploring the neat feature you have been looking forward to!</p>
<h3>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#opampinurl" class="anchor-link">Pinning the dev version of an unreleased package: <code>opam pin add &lt;url&gt;</code></a>
          </h3>
<p>Every once in a while on your OCaml journey, you will come across unreleased
software.</p>
<p>These OCaml programs and libraries can still very much have active repositories
but their maintainers have not yet gone as far as to release them in order to
distribute their work through <code>opam</code> to the rest of the OCaml ecosystem.</p>
<p>Yet, you might still want to have seamless access to these software solutions
on your local <code>opam</code> installation for your own personal enjoyment and
developments. That's when <code>opam pin add &lt;url&gt;</code> comes in handy.</p>
<p>Modern OCaml projects will most often have one or several <code>opam files</code> in their
tree which <code>opam</code> can operate with.</p>
<pre><code class="language-shell-session">$ opam pin git+https://github.com/rjbou/opam-otopop
Package opam-otopop does not exist, create as a NEW package? [Y/n] y
opam-otopop is now pinned to git+https://github.com/rjbou/opam-otopop (version 0.1)

The following actions will be performed:
  &lowast; install opam-client 2.0.10 [required by opam-otopop]
  &lowast; install opam-otopop 0.1*
===== &lowast; 2 =====
Do you want to continue? [Y/n] y

&lt;&gt;&lt;&gt; Processing actions &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;
&#11015; retrieved opam-client.2.0.10  (https://opam.ocaml.org/cache)
&lowast; installed opam-client.2.0.10
&lowast; installed opam-otopop.0.1
Done.
</code></pre>
<p>As you can see, the course of an <code>opam pin add &lt;url&gt;</code> call is very close to
that of an <code>opam pin add --dev-repo &lt;pkg&gt;</code>, the only exception being the
following line:</p>
<pre><code class="language-shell-session">Package opam-otopop does not exist, create as a NEW package? [Y/n] y
</code></pre>
<p>Since the package is unavailable on the opam <code>repositories</code> that your <code>opam</code>
installation is synchronised with, <code>opam</code> doesn't know about it.</p>
<p>That's why it will ask you if you want to <code>create it as a NEW package</code>.</p>
<p>Once pinned, that package is available in your switch as any other ordinarily
available <code>repository</code> package.</p>
<hr/>
<p>You can see here that <code>opam</code> has pinned the <code>opam-otopop</code> package to a specific
<code>0.1</code> version.</p>
<pre><code class="language-shell-session">opam-otopop is now pinned to git+https://github.com/rjbou/opam-otopop (version 0.1)
</code></pre>
<p>The reason for that is found inside the <a href="https://github.com/rjbou/opam-otopop/blob/master/opam-otopop.opam#L2"><code>opam file</code></a> at
the root of the source repository for that package:</p>
<pre><code class="language-shell-session">version: &quot;0.1&quot;
</code></pre>
<p>In any instance where this specific field is not found in the <code>opam file</code>, the
version name would then be pinned to the verbatim <code>~dev</code> version.</p>
<h2>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#opampinoptions" class="anchor-link">Dig into opam pin, find spicy features</a>
          </h2>
<h3>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#noaction" class="anchor-link">Add a pin without installing with <code>--no-action</code></a>
          </h3>
<p>Here are the two main use-cases for a call to <code>opam pin</code> with the <code>--no-action</code>
option:</p>
<ul>
<li>You <strong>don't</strong> want to install a package immediately, but <strong>do</strong> want to
inform <code>opam</code> of its existence to allow <code>opam</code> to keep the compatibility
constraints of that specific package in the equation whenever you are
undertaking operations that would require such calculations;
</li>
<li>You just want to be assured that your package will be synchronised with the
right sources;
</li>
</ul>
<p><code>--no-action</code> will only perform the first actions of an <code>opam pin</code> call and
will quit <strong>before</strong> installing the package, it can be used with all pin
subcommands.</p>
<pre><code class="language-shell-session">$ opam pin add hc --dev-repo --no-action
[hc.0.3] synchronised (git+https://git.zapashcanon.fr/zapashcanon/hc.git)
hc is now pinned to git+https://git.zapashcanon.fr/zapashcanon/hc.git (version 0.3)
$
</code></pre>
<h3>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#updatepins" class="anchor-link">Update your pinned packages</a>
          </h3>
<p>There are two ways to go about updating and upgrading your pinned packages.
They are the same no matter if you used the <code>--dev-repo</code> option, or <code>&lt;url&gt;</code>
argument, or any other method for pinning them.</p>
<p>The first one you may consider is to either install, or reinstall the specific
package(s). The reason is that <code>opam</code> will always first synchronise with the
linked source, and then proceed to recompiling.</p>
<pre><code class="language-shell-session">$ opam install opam-otopop

&lt;&gt;&lt;&gt; Synchronising pinned packages &gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;
[opam-otopop.0.1] synchronised (git+https://github.com/rjbou/opam-otopop#master)

The following actions will be performed:
  &#8635; recompile opam-otopop 0.1*

&lt;&gt;&lt;&gt; Processing actions &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;
&#8856; removed   opam-otopop.0.1
&lowast; installed opam-otopop.0.1
Done.
</code></pre>
<p>In the above code block, <code>opam-otopop</code> has been upgraded by that <code>opam install</code>
call.</p>
<p>The second method is to use the specific <code>opam update</code> and <code>opam upgrade</code>
mechanisms. These commands are very common in an <code>opam</code> abiding workflow. Their
general usage was briefly mentioned in our article <a href="https://ocamlpro.com/blog/2024_01_23_opam_101_the_first_steps/#packages">opam
101</a>.</p>
<p>By default, <code>opam update</code> updates the state of your opam <code>repositories</code>, for
you to have access to the most recent version of your packages. If you add the
<code>--development</code> flag to it, it will also update the source code of your pinned
packages internally.</p>
<pre><code class="language-shell-session">$ opam update --development

&lt;&gt;&lt;&gt; Synchronising development packages &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;
[opam-otopop.0.1] synchronised (git+https://github.com/rjbou/opam-otopop#master)
Now run 'opam upgrade' to apply any package updates.
</code></pre>
<p>Then you run <code>upgrade</code> as you would in any other package upgrade scenario.</p>
<pre><code class="language-shell-session">$ opam upgrade
The following actions will be performed:
  &#8635; recompile opam-otopop 0.1* [upstream or system changes]

&lt;&gt;&lt;&gt; Processing actions &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;
&#8856; removed   opam-otopop.0.1
&lowast; installed opam-otopop.0.1
Done.
</code></pre>
<h3>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#unpin" class="anchor-link">Unpin packages</a>
          </h3>
<p>When you are done with your experimentation and wish to remove a pinned
package, you can simply call the <code>remove</code> subcommand.</p>
<blockquote>
<p>Keep in mind that <code>opam unpin</code> is an alias for <code>opam pin remove</code>.</p>
</blockquote>
<p>The behaviour of <code>opam unpin</code> is slightly different between released and
unreleased packages.</p>
<h4>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#releasedpins" class="anchor-link">Released packages</a>
          </h4>
<p>If the pinned package is released, by default, <code>opam</code> will retrieve and install
the released version of the package instead of removing that package
altogether.</p>
<pre><code class="language-shell-session">$ opam pin list
hc.0.3    git  git+https://git.zapashcanon.fr/zapashcanon/hc.git
</code></pre>
<pre><code class="language-shell-session">$ opam list hc
# Packages matching: name-match(hc) &amp; (installed | available)
# Package # Installed # Synopsis
hc.0.3    0.3         pinned to version 0.3 at git+https://git.zapashcanon.fr/zapashcanon/hc.git
</code></pre>
<pre><code class="language-shell-session">$ opam pin remove hc
Ok, hc is no longer pinned to git+https://git.zapashcanon.fr/zapashcanon/hc.git (version 0.3)
The following actions will be performed:
  &#8635; recompile hc 0.3
Do you want to continue? [Y/n] y

&lt;&gt;&lt;&gt; Processing actions &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;
&#11015; retrieved hc.0.3  (https://opam.ocaml.org/cache)
&#8856; removed   hc.0.3
&lowast; installed hc.0.3
Done.
</code></pre>
<pre><code class="language-shell-session">$ opam list hc
# Packages matching: name-match(hc) &amp; (installed | available)
# Package # Installed # Synopsis
hc.0.3    0.3         Hashconsing library
</code></pre>
<p>As we can see in the details:</p>
<pre><code class="language-shell-session">&#11015; retrieved hc.0.3  (https://opam.ocaml.org/cache)
</code></pre>
<p><code>opam</code> has retrieved the sources from the archive that is specified in the
<code>opam file</code> of the relevant opam <code>repository</code>, thus pulling <code>hc</code> back down to
its latest available, <em>current-switch compatible</em>, release.</p>
<blockquote>
<p>Notice the absence of the <code>*</code> character next to the package action? It
means the package is no longer pinned.</p>
</blockquote>
<h4>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#unreleasedpins" class="anchor-link">Unreleased packages</a>
          </h4>
<p>On the other hand, an unreleased package, since its only definition
source&mdash;meaning both the <strong>location of its source code</strong> as well as <strong>all
information required for <code>opam</code> to operate</strong>, found in the corresponding <code>opam file</code>&mdash;<strong>is</strong> the pin itself, <code>opam</code> will have no other choice than to offer to
remove it for you.</p>
<pre><code class="language-shell-session">$ opam pin list
opam-otopop.0.1    git  git+https://github.com/rjbou/opam-otopop#master
</code></pre>
<p>In this case, <code>opam unpin &lt;package-name&gt;</code> (or idempotently: <code>opam pin remove &lt;package-name&gt;</code>) launches an <code>opam remove</code> action:</p>
<pre><code class="language-shell-session">$ opam pin remove opam-otopop
Ok, opam-otopop is no longer pinned to git+https://github.com/rjbou/opam-otopop#master (version 0.1)
The following actions will be performed:
  &#8856; remove opam-otopop 0.1
Do you want to continue? [Y/n] y

&lt;&gt;&lt;&gt; Processing actions &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;
&#8856; removed   opam-otopop.0.1
Done.
</code></pre>
<h4>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#unpinnoaction" class="anchor-link">Unpin but do no action</a>
          </h4>
<p>Just like with the <code>opam pin add</code> command, the <code>--no-action</code> option is
available when removing pins. It will <strong>only</strong> unpin the package, without
removing it, or recompiling it.</p>
<pre><code class="language-shell-session">$ opam pin remove opam-otopop --no-action
Ok, opam-otopop is no longer pinned to git+https://github.com/rjbou/opam-otopop#master (version 0.1)

$ opam list opam-otopop
# Packages matching: name-match(opam-otopop) &amp; (installed | available)
# Package      # Installed # Synopsis
opam-otopop.0.1 0.1         An opam-otopop package
</code></pre>
<p>You may use it for removing the <code>pin</code> from a package while still keeping it
installed in your <code>switch</code>, or replacing it by its opam <code>repository</code> definition
version.</p>
<p>The resulting package remains linked to its URL, but it is not considered as
pinned, so there will be no update or automatic syncing to follow the changes
of the upstream branch.</p>
<p>You may also consider this feature to prepare a specific action, say, as a
temporary state. For example, you could unpin several packages in a row, and
then proceed to recompiling the whole batch in one go.</p>
<h3>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#multiple" class="anchor-link">One URL to pin them all: handling a multi-package repository</a>
          </h3>
<p>Every example seen so far had but one <code>opam file</code> at the root of their
respective work tree (sometimes in a specific <code>opam/</code> directory).</p>
<p>Yet it is possible for some projects to have several packages distributed by a
single repository. An example of this would be the
<a href="https://github.com/ocaml/opam">opam project source repository itself</a>. If
that is the case, and you pin that URL, the default behaviour is that all the
packages defined at that address will be pinned.</p>
<p>Let's take <a href="https://github.com/OCamlPro/ocp-index">this project</a>.</p>
<p>You can see that several packages are defined: <code>ocp-index</code> and  <code>ocp-browser</code>.</p>
<p>Here's how a <code>pin</code> action behaves when given that URL:</p>
<pre><code class="language-shell-session">$ opam pin add git+https://github.com/OCamlPro/ocp-index
This will pin the following packages: ocp-browser, ocp-index.
Continue? [Y/n] y
ocp-browser is now pinned to git+https://github.com/OCamlPro/ocp-index (version 1.3.6)
ocp-index is now pinned to git+https://github.com/OCamlPro/ocp-index (version 1.3.6)

The following actions will be performed:
  &lowast; install ocp-indent  1.8.1  [required by ocp-index]
  &lowast; install ocp-index   1.3.6*
  &lowast; install ocp-browser 1.3.6*
===== &lowast; 3 =====
Do you want to continue? [Y/n] y

&lt;&gt;&lt;&gt; Processing actions &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;
&#11015; retrieved ocp-indent.1.8.1  (https://opam.ocaml.org/cache)
&lowast; installed ocp-indent.1.8.1
&lowast; installed ocp-index.1.3.6
&lowast; installed ocp-browser.1.3.6
Done.
</code></pre>
<p>As you can see, this process is exactly the same as before, but with 3 packages
in one go.</p>
<p><strong>What if I do not want to pin every package in that repository?</strong></p>
<p>Easy: if you just need one of the packages found at that URL, you can just feed
that package name to the <code>opam pin add &lt;package-name&gt; &lt;url&gt;</code> CLI call, just
like we did at the beginning of this tutorial!</p>
<pre><code class="language-shell-session">$ opam pin add ocp-index git+https://github.com/OCamlPro/ocp-index
[ocp-index.1.3.6] synchronised (git+https://github.com/OCamlPro/ocp-index)
ocp-index is now pinned to git+https://github.com/OCamlPro/ocp-index (version 1.3.6)

The following actions will be performed:
  &lowast; install ocp-indent 1.8.1  [required by ocp-index]
  &lowast; install ocp-index  1.3.6*
===== &lowast; 2 =====
Do you want to continue? [Y/n] y

&lt;&gt;&lt;&gt; Processing actions &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;
&#11015; retrieved ocp-indent.1.8.1  (cached)
&lowast; installed ocp-indent.1.8.1
&lowast; installed ocp-index.1.3.6
Done.
</code></pre>
<p>If you do not know the exact names of these different packages, you may also
consider using the very handy <code>opam pin scan</code> command which will lookup the
contents repository at the URL and list its <code>opam</code> packages for you:</p>
<pre><code class="language-shell-session">$ opam pin scan git+https://github.com/OCamlPro/ocp-index
# Name       # Version  # Url
ocp-index    1.3.6      git+https://github.com/OCamlPro/ocp-index
ocp-browser  1.3.6      git+https://github.com/OCamlPro/ocp-index
</code></pre>
<h3>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#version" class="anchor-link">Setting arbitrary version numbers, toying with fire</a>
          </h3>
<p>As demonstrated <a href="https://ocamlpro.com/blog/feed#opampinurl">earlier</a>, <code>opam</code> will choose a version of the
pinned package according to the contents of the <code>opam file</code>.</p>
<p>The important thing to take away from that is, in most usual scenarios, the
contents of the <code>opam file</code> are paramount to how <code>opam</code> will calculate
compatibility constraints in a given <code>switch</code>.</p>
<p>It is <strong>from</strong> the information that is hardcoded <strong>inside</strong> the <code>opam file</code>
that <code>opam</code> will be able to take educated decisions whenever changes to the
state of your current <code>switch</code> are to be made. There is a way, however, to
circumvent that behaviour, that we want to inform you of, even if it entails a
bit of precaution.</p>
<blockquote>
<p>Naturally, directly tinkering with such a key stability feature like
<code>compatibility constraints solving</code> does require you to <strong>tread carefully</strong>.
We will see together some of the pitfalls and things to do that will keep you
from finding yourself in confusing situations in regards to the state of your
<code>switch</code> and the dependencies within it.</p>
</blockquote>
<p><strong>Ready? Lets get acquainted with our first slightly <em>dangerous</em> <code>opam</code>
feature:</strong></p>
<p>You are allowed to append an <strong>arbitrary</strong> version number to the name of the
pinned package for <code>opam</code> to incorporate in its calculations, as seen in the
following code block:</p>
<pre><code class="language-shell-session">$ opam pin add directories.1.0 git+https://github.com/ocamlpro/directories --no-action
[directories.1.0] synchronised (git+https://github.com/ocamlpro/directories)
directories is now pinned to git+https://github.com/ocamlpro/directories (version 1.0)
</code></pre>
<p>In this specific example, package
<a href="https://github.com/ocaml/opam-repository/blob/master/packages/directories/directories.0.5/opam"><code>directories</code></a>
is available in the opam
<a href="https://ocaml.org/p/directories/latest"><code>repository</code></a>, that our <code>opam</code>
installation is synchronised with. However, there is no such <code>1.0</code> version in
that <code>repository</code>. Not a single reference to such a version number can be found
at that address, neither in the <code>tags</code>, nor <code>releases</code> of the repository, and
not even in the <a href="https://github.com/OCamlPro/directories/blob/master/directories.opam"><code>opam file</code></a>.</p>
<pre><code class="language-shell-session">$ opam show directories --field all-versions
0.1  0.2  0.3  0.4  0.5
</code></pre>
<p>What we have done here is effectively telling <code>opam</code> that <code>directories</code> is at
a different version number than it <strong>actually</strong> is in the most purely technical
aspect...</p>
<p><strong>But why would we want to do such a thing?</strong></p>
<hr/>
<p>Let's consider a reasonable use-case for <code>opam pin add &lt;package&gt;.&lt;my-version-number&gt; &lt;url&gt;</code>:</p>
<p>You have been working on a project called <code>my-project</code> for some time and you
are using a package named <code>fst-dep</code> for your development.</p>
<p>Below, you will find an excerpt of the <code>fst-dep.opam</code> file, specifically its
dependencies:</p>
<pre><code class="language-shell-session">depends: [
  &quot;dep-to-try&quot; { &lt;= &quot;3.0.0&quot; }
  &quot;other-dep&quot;
]
</code></pre>
<p>All three packages (<code>fst-dep</code>,<code>dep-to-try</code> and <code>other-dep</code>) are
installed in your current switch and are available on your favourite opam
<code>repository</code>.</p>
<p>One day you go about checking the repository for each dependency, and you find
that <code>dep-to-try</code> has just had one of its main features <strong>reimplemented</strong>,
improved and optimised, they are preparing to release a <code>4.0.0</code> version soon.</p>
<p>See, these changes would have been available for you to fetch directly from
it's <em>development</em> repository had you been working with it directly, but you
are not. It is up to the maintainers of <code>fst-dep</code> to do that work.</p>
<p>Since you have no ownership over any of these dependencies. You have no way of
changing any of the version constraints in this tiny dependency tree that
ranges from <code>fst-dep</code> and upwards.</p>
<p><strong>Here are the three mainstream solutions to this problem:</strong></p>
<ul>
<li>Wait for both packages to publish new releases. A new official release from
the <code>dep-to-try</code> team, which would ship said reimplementation, and another
from the <code>fst-dep</code> team which would update its dependency tree to include
<code>dep-to-try</code>'s latest version. Needless to say that this could take an
arbitrary amount of time which is unsatisfying at best.
</li>
<li>Another suboptimal solution would be to copy the current state of the
entire opam <code>repository</code> relevant to your package distribution, go to the
corresponding directory for <code>fst-dep</code> inside that <code>repository</code>, relax the hard
dependency <code>&quot;dep-to-try&quot; { &lt;= &quot;3.0.0&quot; }</code> and reinstall all the packages that
are directly or indirectly affected by that change. A very time consuming
task for such a small edit to the global dependency tree.
</li>
<li>Last option would be to pin <code>fst-dep</code>, then go about manually editing the
dependencies of <code>fst-dep</code> with the <code>opam pin --edit</code> option to relax the
dependency. The only pitfall with this solution is that, in a context
where <code>dep-to-try</code> is a <strong>key</strong> package in the OCaml distribution, and many
other packages depend on it as well, you might have to do <strong>a lot</strong> of
editing to make your <code>switch</code> a stable environment with all dependency
constraints met...
</li>
</ul>
<p>So neither of these solutions fit our needs. They are all unsatisfactory at
best and even counter-productive at worst.</p>
<p><strong>That's when <code>arbitrary version pinning</code> shines.</strong></p>
<p>The main benefit of this feature is that it allows for added flexibility in
navigating and tweaking the compatibility tree of any opam <code>repository</code> at the
<code>switch</code>-level. It provides the user with ways to circumvent all tasks
pertaining to a larger operation on the global graph of packages.</p>
<pre><code class="language-shell-session">$ opam pin dep-to-try.3.0.0 git+https://github.com/OCamlPro/dep-to-try
[dep-to-try.3.0.0] synchronised (file:///home/rjbou/ocamlpro/opam_bps_examples/dep-to-try)
dep-to-try is now pinned to git+https://github.com/OCamlPro/dep-to-try#master (version 3.0.0)
</code></pre>
<p><code>opam</code> will still think that <code>dep-to-try</code>'s version is valid (<code>{ &lt;= &quot;3.0.0&quot;}</code>),
even if you are synchronised with the state of its <em>development</em> branch, thus giving
you access to the latest changes with the minimal amount of manual editing
required. Pretty neat, right?</p>
<p>Now, onto the pitfalls that you should keep in mind when tinkering with your
dependencies like that.</p>
<p><strong>What kind of predicament awaits you?</strong></p>
<ol>
<li>You could introduce unforeseen behaviours. This could be anything from
errors at compile-time, if <code>dep-to-try</code>'s interfaces have changed
significantly, to runtime crashes if you're unlucky.
</li>
<li>Another source of confusion could arise if you happen to use the <code>opam unpin dep-to-try --no-action</code> command on such a package. After unpinning it,
there's a chance that you would later forget it used to be pinned to a <em>development</em>
version. There would be little to no way for you to remember which package
it was that you had experimented with at some point. You would either have
to inspect all you installed packages or even remake a <code>switch</code> from scratch
which would not be affected by your reckless <code>arbitrary version pinning</code> and
would work just fine after that.
</li>
</ol>
<p>Our advice is rather simple: use this feature with discretion and try to avoid
unpinning packages if it's not to reinstall or remove them altogether. If you
follow these instructions, you <strong>should</strong> be safe...</p>
<h3>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#morefire" class="anchor-link">Setting multiple arbitrary version numbers</a>
          </h3>
<p>One last bit of black magic for you to play around with.</p>
<p>Instead of pinning <code>package-name.my-version-number</code>, you may use the
<code>--with-version</code> option to pin packages at that URL to an arbitrary version. A
key detail is that it is compatible with multiple opam file pinning... Just
keep in mind that all the pitfalls mentioned previously apply here too, only
with multiple packages at once, which could make it more confusing.</p>
<p>Below, you can see that we are setting <strong>all</strong> the packages found in that
repository to the same version:</p>
<pre><code class="language-shell-session">$ opam pin add git+https://github.com/OCamlPro/ocp-index --with-version 2.0.0
This will pin the following packages: ocp-browser, ocp-index.
Continue? [Y/n] y
ocp-browser is now pinned to git+https://github.com/OCamlPro/ocp-index (version 2.0.0)
ocp-index is now pinned to git+https://github.com/OCamlPro/ocp-index (version 2.0.0)

The following actions will be performed:
  &lowast; install ocp-indent  1.8.1  [required by ocp-index]
  &lowast; install ocp-index   2.0.0*
  &lowast; install ocp-browser 2.0.0*
===== &lowast; 3 =====
Do you want to continue? [Y/n] y

&lt;&gt;&lt;&gt; Processing actions &lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;&lt;&gt;
&#11015; retrieved ocp-indent.1.8.1  (cached)
&#11015; retrieved ocp-index.2.0.0  (no changes)
&#11015; retrieved ocp-browser.2.0.0  (no changes)
&lowast; installed ocp-indent.1.8.1
&lowast; installed ocp-index.2.0.0
&lowast; installed ocp-browser.2.0.0
Done.
</code></pre>
<p>You can see that all these packages are pinned to <code>2.0.0</code> now.</p>
<pre><code class="language-shell-session">$ opam pin list
ocp-browser.2.0.0    git  git+https://github.com/OCamlPro/ocp-index
ocp-index.2.0.0      git  git+https://github.com/OCamlPro/ocp-index
</code></pre>
<h2>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#conclusion" class="anchor-link">Conclusion</a>
          </h2>
<p>Here it is, the <code>opam pin</code> command in most of its glory.</p>
<p>If you have managed to stick this long to read this article, you should no
longer feel confused about pinning projects and should now have another of
<code>opam</code>'s most commonly used feature in your arsenal when tackling your own
development challenges!</p>
<p>So it is that we have learned about pinning both released and unreleased
packages. Additionally, we showcased several features for orthogonal use-cases:
from the more <em>quality of life</em>-oriented calls such as <code>opam show</code> and <code>opam pin scan</code>, to obscure features like arbitrary version pinning as well as
ordinary options like <code>--no-action</code>, <code>--dev-repo</code> and subcommands like <code>opam unpin</code>.</p>
<p>We are steadily approaching a level of familiarity with <code>opam</code> that will
allow us to get into some really neat features soon.</p>
<p>Be sure to stay tuned with our blog, the journey into the rabbit hole has only
started and <code>opam</code> is a deep one indeed!</p>
<hr/>
<p>Thank you for reading,</p>
<p>From 2011, with love,</p>
<p>The OCamlPro Team</p>
</div>
