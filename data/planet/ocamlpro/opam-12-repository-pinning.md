---
title: 'OPAM 1.2: Repository Pinning'
description: Most package managers support some pin functionality to ensure that a
  given package remains at a particular version without being upgraded. The stable
  OPAM 1.1 already supported this by allowing any existing package to be pinned to
  a target, which could be a specific released version, a local filesy...
url: https://ocamlpro.com/blog/2014_08_19_opam_1.2_repository_pinning
date: 2014-08-19T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    Louis Gesbert\n  "
source:
---

<p><img src="https://ocamlpro.com/blog/assets/img/picture_camel_pin.jpg"/></p>
<p>Most package managers support some <em>pin</em> functionality to ensure that a given
package remains at a particular version without being upgraded.
The stable OPAM 1.1 already supported this by allowing any existing package to be
pinned to a <em>target</em>, which could be a specific released version, a local filesystem
path, or a remote version-controlled repository.</p>
<p>However, the OPAM 1.1 pinning workflow only lets you pin packages that <em>already exist</em> in your OPAM
repositories. To declare a new package, you had to go through creating a
local repository, registering it in OPAM, and adding your package definition there.
That workflow, while reasonably clear, required the user to know about the repository
format and the configuration of an internal repository in OPAM before actually getting to
writing a package. Besides, you were on your own for writing the package
definition, and the edit-test loop wasn't as friendly as it could have been.</p>
<p>A natural, simpler workflow emerged from allowing users to <em>pin</em> new package
names that don't yet exist in an OPAM repository:</p>
<ol>
<li>choose a name for your new package
</li>
<li><code>opam pin add</code> in the development source tree
</li>
<li>the package is created on-the-fly and registered locally.
</li>
</ol>
<p>To make it even easier, OPAM can now interactively help you write the
package definition, and you can test your updates with a single command.
This blog post explains this new OPAM 1.2 functionality in more detail;
you may also want to check out the new <a href="https://opam.ocaml.org/doc/1.2/Packaging.html" title="OPAM 1.2 doc preview, packaging guide">Packaging tutorial</a>
relying on this workflow.</p>
<h3>From source to package</h3>
<p>For illustration purposes in this post I'll use a tiny tool that I wrote some time ago and
never released: <a href="https://github.com/OCamlPro/ocp-reloc" title="ocp-reloc repo on Github">ocp-reloc</a>.  It's a simple binary that fixes up the
headers of OCaml bytecode files to make them relocatable, which I'd like
to release into the public OPAM repository.</p>
<h4>&quot;opam pin add&quot;</h4>
<p>The command <code>opam pin add &lt;name&gt; &lt;target&gt;</code> pins package <code>&lt;name&gt;</code> to
<code>&lt;target&gt;</code>. We're interested in pinning the <code>ocp-reloc</code> package
name to the project's source directory.</p>
<pre><code>cd ocp-reloc
opam pin add ocp-reloc .
</code></pre>
<p>If <code>ocp-reloc</code> were an existing package, the metadata would be fetched from
the package description in the OPAM repositories. Since the package doesn't yet exist,
OPAM 1.2 will instead prompt for on-the-fly creation:</p>
<pre><code>Package ocp-reloc does not exist, create as a NEW package ? [Y/n] y
ocp-reloc is now path-pinned to ~/src/ocp-reloc
</code></pre>
<blockquote>
<p>NOTE: if you are using <strong>beta4</strong>, you may get a <em>version-control</em>-pin instead,
because we added auto-detection of version-controlled repos. This turned out to
be confusing (<a href="https://github.com/ocaml/opam/issues/1582">issue #1582</a>),
because your changes wouldn't be reflected until you commit, so
this has been reverted in favor of a warning. Add the <code>--kind path</code> option to
make sure that you get a <em>path</em>-pin.</p>
</blockquote>
<h4>OPAM Package Template</h4>
<p>Now your package still needs some kind of definition for OPAM to acknowledge it;
that's where templates kick in, the above triggering an editor with a pre-filled
<code>opam</code> file that you just have to complete. This not only saves time in
looking up the documentation, it also helps getting consistent package
definitions, reduces errors, and promotes filling in optional but recommended
fields (homepage, etc.).</p>
<pre><code class="language-shell-session">opam-version: &quot;1.2&quot;
name: &quot;ocp-reloc&quot;
version: &quot;0.1&quot;
maintainer: &quot;Louis Gesbert &lt;louis.gesbert@ocamlpro.com&gt;&quot;
authors: &quot;Louis Gesbert &lt;louis.gesbert@ocamlpro.com&gt;&quot;
homepage: &quot;&quot;
bug-reports: &quot;&quot;
license: &quot;&quot;
build: [
  [&quot;./configure&quot; &quot;--prefix=%{prefix}%&quot;]
  [make]
]
install: [make &quot;install&quot;]
remove: [&quot;ocamlfind&quot; &quot;remove&quot; &quot;ocp-reloc&quot;]
depends: &quot;ocamlfind&quot; {build}
</code></pre>
<p>After adding some details (most importantly the dependencies and
build instructions), I can just save and exit.  Much like other system tools
such as <code>visudo</code>, it checks for syntax errors immediately:</p>
<pre><code>[ERROR] File &quot;/home/lg/.opam/4.01.0/overlay/ocp-reloc/opam&quot;, line 13, character 35-36: '.' is not a valid token.
Errors in /home/lg/.opam/4.01.0/overlay/ocp-reloc/opam, retry editing ? [Y/n]
</code></pre>
<h4>Installation</h4>
<p>You probably want to try your brand new package right away, so
OPAM's default action is to try and install it (unless you specified <code>-n</code>):</p>
<pre><code class="language-shell-session">ocp-reloc needs to be installed.
The following actions will be performed:
 - install   cmdliner.0.9.5                        [required by ocp-reloc]
 - install   ocp-reloc.0.1*
=== 1 to install ===
Do you want to continue ? [Y/n]
</code></pre>
<p>I usually don't get it working the first time around, but <code>opam pin edit ocp-reloc</code> and <code>opam install ocp-reloc -v</code> can be used to edit and retry until
it does.</p>
<h4>Package Updates</h4>
<p>How do you keep working on your project as you edit the source code, now that
you are installing through OPAM? This is as simple as:</p>
<pre><code>opam upgrade ocp-reloc
</code></pre>
<p>This will pick up changes from your source repository and reinstall any packages
that are dependent on <code>ocp-reloc</code> as well, if any.</p>
<p>So far, we've been dealing with the metadata locally used by your OPAM
installation, but you'll probably want to share this among developers of your
project even if you're not releasing anything yet. OPAM takes care of this
by prompting you to save the <code>opam</code> file back to your source tree, where
you can commit it directly into your code repository.</p>
<pre><code class="language-shell-session">cd ocp-reloc
git add opam
git commit -m 'Add OPAM metadata'
git push
</code></pre>
<h3>Publishing your New Package</h3>
<p>The above information is sufficient to use OPAM locally to integrate new code
into an OPAM installation.  Let's look at how other developers can share this
metadata.</p>
<h4>Picking up your development package</h4>
<p>If another developer wants to pick up <code>ocp-reloc</code>, they can directly use
your existing metadata by cloning a copy of your repository and issuing their
own pin.</p>
<pre><code class="language-shell-session">git clone git://github.com/OCamlPro/ocp-reloc.git
opam pin add ocp-reloc/
</code></pre>
<p>Even specifying the package name is optional since this is documented in
<code>ocp-reloc/opam</code>. They can start hacking, and if needed use <code>opam pin edit</code> to
amend the opam file too. No need for a repository, no need to share anything more than a
versioned <code>opam</code> file within your project.</p>
<h4>Cloning already existing packages</h4>
<p>We have been focusing on an unreleased package, but the same
functionality is also of great help in handling existing packages, whether you
need to quickly hack into them or are just curious.  Let's consider how to
modify the <a href="https://github.com/ocaml/omd" title="OMD page on Github"><code>omd</code> Markdown library</a>.</p>
<pre><code class="language-shell-session">opam source omd --pin
cd omd.0.9.7
...patch...
opam upgrade omd
</code></pre>
<p>The new <code>opam source</code> command will clone the source code of the library you
specify, and the <code>--pin</code> option will also pin it locally to ensure it is used
in preference to all other versions.  This will also take care of recompiling
any installed packages that are dependent on <code>omd</code> using your patched version
so that you notice any issues right away.</p>
<blockquote>
<p>There's a new OPAM field available in 1.2 called <code>dev-repo</code>.  If you specify
this in your metadata, you can directly pin to the upstream repository via
<code>opam source --dev-repo --pin</code>.</p>
</blockquote>
<p>If the upstream repository for the package contains an <code>opam</code> file, that file will be picked up
in preference to the one from the OPAM repository as soon as you pin the package.
The idea is to have:</p>
<ul>
<li>a <em>development</em> <code>opam</code> file that is versioned along with your source code
(and thus accurately tracks the latest dependencies for your package).
</li>
<li>a <em>release</em> <code>opam</code> file that is published on the OPAM repository and can
be updated independently without making a new release of the source code.
</li>
</ul>
<p>How to get from the former to the latter will be the subject of another post!
In the meantime, all users of the <a href="https://ocamlpro.com/opam-1-2-0-beta4" title="OPAM 1.2.0 beta4 announcement">beta</a> are welcome to share their
experience and thoughts on the new workflow on the <a href="https://github.com/ocaml/opam/issues" title="OPAM bug-tracker on Github">bug tracker</a>.</p>

