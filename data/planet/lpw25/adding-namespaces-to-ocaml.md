---
title: Adding namespaces to OCaml
description:
url: http://lpw25.net/2013/03/10/ocaml-namespaces
date: 2013-03-10T00:00:00-00:00
preview_image:
featured:
authors:
- lpw25
---

<div class="well well-small">
  <h4>
Contents
</h4>
<ul>
  <li><a href="http://lpw25.net/rss.xml#problems-with-pack">Problems with pack</a></li>
  <li><a href="http://lpw25.net/rss.xml#formal-semantics">Formal semantics</a></li>
  <li><a href="http://lpw25.net/rss.xml#design-goals">Design goals</a></li>
  <li><a href="http://lpw25.net/rss.xml#design-choices">Design choices</a>    <ul>
      <li><a href="http://lpw25.net/rss.xml#flat-or-hierarchical">Flat or hierarchical?</a></li>
      <li><a href="http://lpw25.net/rss.xml#should-namespaces-be-opened-explicitly-in-source-code">Should namespaces be opened explicitly in source code?</a></li>
      <li><a href="http://lpw25.net/rss.xml#how-should-the-compiler-find-modules-in-the-presence-of-namespaces">How should the compiler find modules in the presence of namespaces?</a></li>
      <li><a href="http://lpw25.net/rss.xml#how-should-namespaces-specified">How should namespaces specified?</a></li>
      <li><a href="http://lpw25.net/rss.xml#how-rich-should-a-description-language-be">How rich should a description language be?</a></li>
      <li><a href="http://lpw25.net/rss.xml#should-namespaces-support-automatically-opened-members">Should namespaces support automatically opened members?</a></li>
    </ul>
  </li>
  <li><a href="http://lpw25.net/rss.xml#proposal">Proposal</a>    <ul>
      <li><a href="http://lpw25.net/rss.xml#simple-namespaces-through-filenames">Simple namespaces through filenames</a></li>
      <li><a href="http://lpw25.net/rss.xml#an-alternative-to-search-paths">An alternative to search paths</a></li>
      <li><a href="http://lpw25.net/rss.xml#the--name-argument">The &ldquo;-name&rdquo; argument</a></li>
      <li><a href="http://lpw25.net/rss.xml#the--open-argument">The &ldquo;-open&rdquo; argument</a></li>
    </ul>
  </li>
</ul>

</div>

<p>Recently there has been a lot of discussion on
<a href="http://lists.ocaml.org/listinfo/platform">platform@lists.ocaml.org</a> about
proposals for adding namespaces to OCaml. I&rsquo;ve written this post to summarise
the design decisions for such a proposal and to make my own proposal.</p>

<p>Before discussing what namespaces are and the issues surrounding their
implementation, it is important to explain why they are needed in the first
place.</p>

<p>The most important reason for adding namespaces is to provide some means for
grouping the components of a library together. Up to now this has been
achieved using the OCaml module system. Since the components of an OCaml
library are modules, a module can be created that contains all the components
of the library as sub-modules. The &ldquo;-pack&rdquo; option for the compiler was created
to allow this module to be created while still keeping each component of the
library in its own file.</p>

<h3>Problems with pack</h3>

<p>There are some critical problems with using &ldquo;-pack&rdquo; to create a single module
containing the whole library:</p>

<ul>
  <li>
    <p>The packed module is a single unit that has to be linked or not as a
unit. This means that any program using part of the library must include the
entire library.</p>
  </li>
  <li>
    <p>The packed module is a choke-point in the dependency graph.  If a file
depends on one thing in the packed module then it needs to be recompiled if
anything in the packed module changes.</p>
  </li>
  <li>
    <p>Opening a large packed module is very slow and can seriously affect build
performance.</p>
  </li>
</ul>

<p>These problems are all caused by the fact that pack creates an OCaml
module. To understand this consider the run-time semantics of the module
system.</p>

<p>At run-time a module is a record. Initialising a module involves initialising
every component of the module and placing them in this record.  Initialising
these components can involve executing arbitrary code; in fact the execution
of an OCaml program is simply the initialisation of all its modules.</p>

<p>The problems with pack are related to these dynamic semantics. In order to
be a module pack must create a record to represent this module. This means
that it must initialise all of its components. It is this (rather than any
detail of pack&rsquo;s implementation) that causes the problems identified above.</p>

<p>Access to the components of a top-level module could proceed without the
existence of this record. However, the record is required in order to &ldquo;alias&rdquo;
the module, use the module as a first-class value or use it as the argument to
a functor.</p>

<p>Any attempt to overcome the problems with pack, whilst still maintaining
the illusion that the &ldquo;pack&rdquo; is a normal module, would result (at the very
least) in one of the following unhealthy situations:</p>

<ul>
  <li>
    <p>The module type of the &ldquo;packed module&rdquo; would depend on which of its
components were accessed by the program.</p>
  </li>
  <li>
    <p>Any use of the &ldquo;packed module&rdquo; other than as a simple container
(e.g.
<span class="highlight"><code><span class="k">module</span>
<span class="nc">CS</span>
<span class="o">=</span>
<span class="nn">Core</span><span class="p">.</span><span class="nc">Std</span></code></span> 
) could have a dramatic effect on what was
linked into the program and potentially on the semantics of the program.</p>
  </li>
</ul>

<p>Namespaces are basically modules that can only be used as a simple
container. This means that they do not need a corresponding record at
run-time (or any other run-time representation). This avoids the problems
with pack as well as enabling other useful features.</p>

<h3>Formal semantics</h3>

<p>Following the semantics and description language for namespaces described by
<a href="http://gallium.inria.fr/~scherer/namespaces/spec.pdf">Gabriel Scherer et al</a>,
I will consider namespaces to be name-labelled trees whose leaves are
compilation units. I will use 
<span class="highlight"><code><span class="o">#</span></code></span> 
to represent projection on namespaces, so the 
<span class="highlight"><code><span class="nc">Bar</span></code></span>
member of the 
<span class="highlight"><code><span class="nc">Foo</span></code></span>
namespace will be referred to as 
<span class="highlight"><code><span class="nc">Foo</span><span class="o">#</span><span class="nc">Bar</span></code></span>.</p>

<h3>Design goals</h3>

<p>Some design goals that we might want from a proposal for adding namespaces to
OCaml include:</p>

<ul>
  <li>
    <p><strong>Allow library components to be grouped together without creating a module
containing them.</strong></p>
  </li>
  <li>
    <p><strong>Allow users to group together modules from different libraries as they see
fit.</strong> This means letting people change which namespace a library module is
in.</p>
  </li>
  <li>
    <p><strong>Allow library components to be given multiple names.</strong> For example
<span class="highlight"><code><span class="nc">Lib</span><span class="o">#</span><span class="nc">Foo</span></code></span>
and 
<span class="highlight"><code><span class="nc">Lib</span><span class="o">#</span><span class="nc">Stable</span><span class="o">#</span><span class="nc">Foo</span></code></span>
, where 
<span class="highlight"><code><span class="nc">Lib</span><span class="o">#</span><span class="nc">Stable</span></code></span>
is a namespace containing only those components whose interfaces are stable.</p>
  </li>
  <li>
    <p><strong>Be simple and easy to explain to beginners.</strong></p>
  </li>
  <li>
    <p><strong>Allow multiple source files to share the same filename.</strong> Each module that
is linked into an OCaml program must have a unique name. Currently, a
module&rsquo;s name is completely determined by its filename. This forces library
developers to either use pack (which gives its components new long names) or
give their source files long names like &ldquo;libName_Foo.ml&rdquo;. A namespaces
proposal may be able to alleviate this problem.</p>
  </li>
  <li>
    <p><strong>Allow libraries to control which modules are open by default.</strong> By default
OCaml opens the standard library&rsquo;s 
<span class="highlight"><code><span class="nc">Pervasives</span></code></span>
module. Libraries that wish to replace the standard library may also wish to
provide their own
<span class="highlight"><code><span class="nc">Pervasives</span></code></span>
module and have it opened by default.</p>
  </li>
  <li>
    <p><strong>Support libraries that wish to remain compatible with versions of OCaml
without namespaces.</strong></p>
  </li>
  <li>
    <p><strong>Require minimal changes to existing build systems.</strong> Since a namespace
proposal changes how a library&rsquo;s components are named, it may require
changes to some build systems. If these changes are too invasive then users
of some build systems will probably be unable to use namespaces in the near
future.</p>
  </li>
</ul>

<h3>Design choices</h3>

<h4>Flat or hierarchical?</h4>

<p>In order to replace pack, namespaces must be able to contain modules. It is
not clear, however, whether they need to be able to contain other
namespaces. We call namespaces that can contain other namespaces
<em>hierarchical</em>, as opposed to <em>flat</em>.</p>

<p>In favour of flat namespaces:</p>

<ul>
  <li>
    <p>Hierarchical namespaces might lead to arbitrary categorising of components
(e.g.<br/>
<span class="highlight"><code><span class="nc">Data</span><span class="o">#</span><span class="nc">Array</span></code></span>
). These add syntactic clutter and do not bring any real benefit.</p>
  </li>
  <li>
    <p>Hierarchical namespaces might lead to deep java-style hierarchies
(e.g.<br/>
<span class="highlight"><code><span class="nc">Com</span><span class="o">#</span><span class="nc">Janestreet</span><span class="o">#</span><span class="nc">Core</span><span class="o">#</span><span class="nc">Std</span></code></span>
). These add syntactic clutter without adding any actual information.</p>
  </li>
</ul>

<p>In favour of hierarchical namespaces:</p>

<ul>
<li>
A library may wish to provide multiple versions of some of its components. For
example:

<ul>
<li>    
<span class="highlight"><code><span class="nc">Http</span><span class="o">#</span><span class="nc">Async</span><span class="o">#</span><span class="nc">IO</span></code></span>
 and 
<span class="highlight"><code><span class="nc">Http</span><span class="o">#</span><span class="nc">Lwt</span><span class="o">#</span><span class="nc">IO</span></code></span>
</li>
<li>
<span class="highlight"><code><span class="nc">File</span><span class="o">#</span><span class="nc">Windows</span><span class="o">#</span><span class="nc">Directories</span></code></span>
and 
<span class="highlight"><code><span class="nc">File</span><span class="o">#</span><span class="nc">Unix</span><span class="o">#</span><span class="nc">Directories</span></code></span>
</li>
<li>
<span class="highlight"><code><span class="nc">Core</span><span class="o">#</span><span class="nc">Mutex</span></code></span>
and 
<span class="highlight"><code><span class="nc">Core</span><span class="o">#</span><span class="nc">Testing</span><span class="o">#</span><span class="nc">Mutex</span></code></span>
</li>
</ul>

In such situations it is useful to be able to write both


<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="k">open</span> <span class="nc">Core</span>
<span class="o">[...]</span>
<span class="nc">Testing</span><span class="p">#</span><span class="nn">Mutex</span><span class="p">.</span><span class="n">lock</span> <span class="n">x</span></code></pre></figure>


and


<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="k">open</span> <span class="nc">Core</span><span class="p">#</span><span class="nc">Testing</span>
<span class="o">[...]</span>
<span class="nn">Mutex</span><span class="p">.</span><span class="n">lock</span> <span class="n">x</span></code></pre></figure>

</li>
<li>
None of the systems of namespaces that have been proposed have any
additional cost for supporting hierarchical namespaces.
</li>
</ul>

<h4>Should namespaces be opened explicitly in source code?</h4>

<p>There was some debate on the platform mailing list about whether to support
opening namespaces explicitly in source code. This means allowing a syntax
like:</p>

<div class="highlight">
<pre><code class="ocaml"><span class="k">open</span> <span class="k">namespace</span> <span class="nc">Foo</span></code></pre>
</div>

<p>that allows the members of namespace 
<span class="highlight"><code><span class="nc">Foo</span></code></span>
to be referenced directly (i.e.
<span class="highlight"><code><span class="nc">Foo</span><span class="o">#</span><span class="nc">Bar</span></code></span>
can be referred to as 
<span class="highlight"><code><span class="nc">Bar</span></code></span>).</p>

<p>The alternative would be to only support opening namespaces through a
command-line argument.</p>

<p>In favour of supporting explicit opens:</p>

<ul>
  <li>
    <p>If you open two namespaces with commonly named sub-components then the order
of those opens matters. If the opens are command-line arguments then the
order of those command-line arguments (often determined by build systems and
other tools) matters. This is potentially very fragile.</p>
  </li>
  <li>
    <p>Explicit opens in a source file give valuable information about which
libraries are being used by that source file. If a file contains &ldquo;open
namespace Core&rdquo; then you know it uses the Core library.</p>
  </li>
  <li>
    <p>Local namespace opens provide users more precise control over their naming
environment.</p>
  </li>
</ul>

<p>Against supporting explicit opens:</p>

<ul>
  <li>They require a new syntactic construct.</li>
</ul>

<h4>How should the compiler find modules in the presence of namespaces?</h4>

<p>Currently, when looking for a module 
<span class="highlight"><code><span class="nc">Bar</span></code></span>
that is not in the current environment, the OCaml compiler will search the
directories in its search path for a file called &ldquo;bar.cmi&rdquo;.</p>

<p>In the presence of namespaces this becomes more complicated: how does the
compiler find the module 
<span class="highlight"><code><span class="nc">Foo</span><span class="o">#</span><span class="nc">Bar</span></code></span>
?</p>

<p>The suggested possible methods for finding modules in the presence of
namespaces fall into four categories.</p>

<h5>Using filenames</h5>

<p>By storing the interface for 
<span class="highlight"><code><span class="nc">Foo</span><span class="o">#</span><span class="nc">Bar</span></code></span>
in a file named &ldquo;foo-bar.cmi&rdquo; the compiler can continue to simply look-up
modules in its search path.</p>

<p>Note that &ldquo;-&ldquo; is an illegal character in module names so there is no risk of
<span class="highlight"><code><span class="nc">Foo</span><span class="o">#</span><span class="nc">Bar</span></code></span>
being confused with a module called 
<span class="highlight"><code><span class="nc">Foo-bar</span></code></span>.</p>

<p>This simple scheme does not support placing a module within multiple
namespaces or allowing users to put existing modules in a new namespace.</p>

<h5>Checking multiple &ldquo;.cmi&rdquo; files</h5>

<p>The name of the namespace containing a compilation unit could be included in
the &ldquo;.cmi&rdquo; file of that unit. Then, when looking for a module 
<span class="highlight"><code><span class="nc">Foo</span><span class="o">#</span><span class="nc">Bar</span></code></span>
, the compiler would try every &ldquo;bar.cmi&rdquo; file in its search path until it
found one that was part of the &ldquo;Foo&rdquo; namespace. This may require the compiler
to open all the &ldquo;bar.cmi&rdquo; files on its search path, which could be expensive
on certain operating systems.</p>

<p>This scheme does not support allowing users to put existing modules in a new
namespace, but can support placing a module in multiple namespaces.</p>

<p>It is difficult to detect typos in namespace open statements using this
scheme. For example, detecting that
<span class="highlight"><code><span class="k">open</span>
<span class="k">namespace</span>
<span class="nc">Core</span><span class="o">#</span><span class="nc">Sdt</span></code></span> 
should have been
<span class="highlight"><code><span class="k">open</span>
<span class="k">namespace</span>
<span class="nc">Core</span><span class="o">#</span><span class="nc">Std</span></code></span>
would require the compiler to check every file in its search path for one that
was part of namespace
<span class="highlight"><code><span class="nc">Core</span><span class="o">#</span><span class="nc">Sdt</span></code></span>.</p>

<h5>Using namespace description files</h5>

<p>The compiler could find a member of a namespace by consulting a file that
describes the members of that namespace.</p>

<p>For example, if namespace 
<span class="highlight"><code><span class="nc">Foo</span></code></span>
was described by a file &ldquo;foo.ns&rdquo; that was on the compiler&rsquo;s search path then
the compiler could find
<span class="highlight"><code><span class="nc">Foo</span><span class="o">#</span><span class="nc">Bar</span></code></span>
by locating &ldquo;foo.ns&rdquo; and using it to look-up the location of the &ldquo;.cmi&rdquo; file
for
<span class="highlight"><code><span class="nc">Bar</span></code></span>.</p>

<p>These namespace description files could be created automatically by some
tool. However, they must be produced before detecting dependencies with
OCamlDep, which could complicate the build process.</p>

<h5>Using environment description files</h5>

<p>The compiler could find a member of a namespace by consulting a file that
describes a mapping between module names and &ldquo;.cmi&rdquo; files.</p>

<p>For example, if a file &ldquo;foo.mlpath&rdquo; included the mapping &ldquo;Foo#Bar:
foo/bar.cmi&rdquo; then that file could be passed as a command-line argument to the
compiler and used to look up the &ldquo;bar.cmi&rdquo; file directly.</p>

<p>Looking up modules using this scheme may speed up compilation by avoiding the
need to scan directories for files.</p>

<h4>How should namespaces specified?</h4>

<p>Perhaps the most important question for any namespaces proposal is how
namespaces are specified. It is closely related to the above question of how
the compiler finds modules in the presence of namespaces.</p>

<p>The suggested possible methods for specifying namespaces fall into five
categories.</p>

<h5>Explicitly in the source files</h5>

<p>Namespaces could be specified by adding a line like:</p>

<div class="highlight">
<pre><code class="ocaml"><span class="k">namespace</span> <span class="nc">Foo</span></code></pre>
</div>

<p>to the beginning of each compilation unit that is part of the 
<span class="highlight"><code><span class="nc">Foo</span></code></span> 
namespace.</p>

<p>This has the benefit of making namespaces explicitly part of the language
itself, however it does mean that the full name of a module is specified in
two locations: partly in the filename and partly within the file itself.</p>

<h5>Through command-line arguments</h5>

<p>Namespaces could be specified by passing a command-line argument to the
compiler. For example, 
<span class="highlight"><code><span class="nc">Foo</span><span class="o">#</span><span class="nc">Bar</span></code></span> 
could be compiled with the command-line:</p>

<figure class="highlight"><pre><code class="language-sh" data-lang="sh">ocamlc -c -namespace Foo bar.ml </code></pre></figure>

<p>This scheme also means that the full name of a module is specified in two
locations: partly in the build system and partly in the filename.</p>

<h5>Through filenames</h5>

<p>Namespaces could be specified using the filenames of source files. For
example, 
<span class="highlight"><code><span class="nc">Foo</span><span class="o">#</span><span class="nc">Bar</span></code></span> 
would be created by compiling a file &ldquo;foo-bar.ml&rdquo;</p>

<p>This scheme is simple and very similar to how modules are currently named, but
it would require all source files to have long unique names.</p>

<h5>Through namespace description files</h5>

<p>Namespaces could be specified using namespace description files. The 
<span class="highlight"><code><span class="nc">Foo</span></code></span>
namespace would be specified by a file &ldquo;foo.ns&rdquo; that described the members of
<span class="highlight"><code><span class="nc">Foo</span></code></span>:</p>

<div class="highlighter-rouge"><pre class="highlight"><code>module Bar = &quot;foo_bar.cmi&quot;
namespace Testing = &quot;testing.ns&quot;
</code></pre>
</div>

<h5>Through environment description files</h5>

<p>Namespaces could be specified using environment description files. A namespace
<span class="highlight"><code><span class="nc">Foo</span></code></span>
would be defined by passing an environment description file to the compiler
that included mappings for each of the members of
<span class="highlight"><code><span class="nc">Foo</span></code></span>. For example:</p>

<div class="highlighter-rouge"><pre class="highlight"><code>Foo#Bar: &quot;foo_bar.cmi&quot;
Foo#Testing#Bar: &quot;foo_testing_bar.cmi&quot;
Baz: &quot;baz.cmi&quot;
</code></pre>
</div>

<p>In addition to specifying namespaces, this system allows users (or a tool like
OCamlFind) to have complete control the naming environment of a program.</p>

<h4>How rich should a description language be?</h4>

<p>For namespace proposals that use namespace or environment description files,
they must decide how rich their description language should be.</p>

<p>For example, <a href="http://gallium.inria.fr/~scherer/namespaces/spec.pdf">Gabriel Scherer et
al</a> describe a very rich
environment description language including many different operations that can
be performed on namespaces.</p>

<p>A rich description language can produce shorter descriptions. However, the
more operations a language supports the more syntax that users must understand
in order to read description files. The majority of description files are
unlikely to require complex operations.</p>

<h4>Should namespaces support automatically opened members?</h4>

<p>A feature of namespaces that has been proposed on the mailing list is to allow
some modules within a namespace to be automatically opened when the namespace
is also opened. This makes it seem that the namespace has values and types as
members.</p>

<p>This feature is based on the current design of Jane Street&rsquo;s Core
library. Users of the Core library are expected to open the
<span class="highlight"><code><span class="nc">Core<span class="p">.</span>Std</span></code></span>
 module before using the library. Opening this module provides access to all
the other modules of the library (much like opening a namespace), but it also
provides types and values similar to those provided by the standard library&rsquo;s
<span class="highlight"><code><span class="nc">Pervasives</span></code></span> module.</p>

<p>Supporting auto-opened modules would allow 
<span class="highlight"><code><span class="nc">Core<span class="p">.</span>Std</span></code></span>
to be directly replaced by a namespace. However, the semantics of this feature
could be awkward due to potential conflicts between members of the namespace
and sub-modules of the auto-opened modules. It also increases the overlap
between namespaces and modules.</p>

<h3>Proposal</h3>

<p>In the last section of this post I will outline a namespaces proposal that I
think satisfies the design goals set out earlier.</p>

<p>I think that satisfying these design goals requires a combination of
extensions to OCaml. My proposal is made up of four such extensions. To keep
things simple for users to understand, I have tried to keep each of these
extensions completely independent of the others and with a clearly defined
goal.</p>

<h4>Simple namespaces through filenames</h4>

<p>Currently, the name of a module is completely defined by its filename, and
modules are looked up using a simple search path. While it has some problems,
this simple paradigm has served OCaml well and I think that it is important to
provide some support for namespaces within this paradigm.</p>

<p>This means allowing simple namespaces to be specified using source file
names. For example, to create a module 
<span class="highlight"><code><span class="nc">Bar</span></code></span>
within the namespace 
<span class="highlight"><code><span class="nc">Foo</span></code></span>
developers can simply create an implementation file &ldquo;foo-bar.ml&rdquo; and an
interface file &ldquo;foo-bar.mli&rdquo;. This interface file would be compiled to a
&ldquo;foo-bar.cmi&rdquo; file. Hierarchical namespaces would be created by files with
names like &ldquo;foo-bar-baz.ml&rdquo;.</p>

<p>These namespaced modules can be referred to using the syntax 
<span class="highlight"><code><span class="nc">Foo</span><span class="o">#</span><span class="nc">Bar</span></code></span>. 
This syntax simply causes the compiler to look in its search path for a
&ldquo;foo-bar.cmi&rdquo; file.</p>

<p>I also propose supporting a namespace opening syntax like:</p>
<div class="highlight">
<pre><code class="ocaml"><span class="k">open</span> <span class="k">namespace</span> <span class="nc">Foo</span>
[...]
<span class="nc">Bar</span></code></pre>
</div>

<h4>An alternative to search paths</h4>

<p>Forcing the name of a module to be completely defined by its (compiled)
filename makes it easy to look-up modules in a search path. However, it
prevents modules from being given multiple names or being renamed by users. So
I propose supporting an alternative look-up mechanism.</p>

<p>I propose supporting environment description files called <em>search path
files</em>. These files would have a syntax like:</p>

<div class="highlighter-rouge"><pre class="highlight"><code>Foo#Bar : &quot;other_bar.cmi&quot;
Foo#Baz : Foo#Bar
</code></pre>
</div>

<p>This file can be given to the &ldquo;-I&rdquo; command-line argument instead of a
directory and used to look-up the locations of &ldquo;.cmi&rdquo; files for given module
names.</p>

<p>These search path files can be used to alias modules and to create new
namespaces. They also allow a module to be available under multiple namespaces.</p>

<p>I envisage two particular modes of use:</p>

<ul>
  <li>
    <p>Library authors can write &ldquo;.mlpath&rdquo; files and tell OCamlFind to use that
file as its search path instead of a list of directories.</p>
  </li>
  <li>
    <p>A user (or potentially OCamlFind) can create search path files to define
their entire naming environment as they see fit.</p>
  </li>
</ul>

<h4>The &ldquo;-name&rdquo; argument</h4>

<p>While the hard link between a module&rsquo;s name and the name of its source file
makes life easier for build systems (&ldquo;list.cmi&rdquo; can only be produced by
compiling &ldquo;list.ml&rdquo;), it forces library authors to give their source files long
unique names.</p>

<p>I propose adding a &ldquo;-name&rdquo; command-line argument to the OCaml compiler. This
would be used as follows:</p>

<figure class="highlight"><pre><code class="language-sh" data-lang="sh">ocamlc -c -name Foo#Bar other.ml</code></pre></figure>

<p>This command would produce a &ldquo;foo-bar.cmi&rdquo; file defining a module named
<span class="highlight"><code><span class="nc">Foo</span><span class="o">#</span><span class="nc">Bar</span></code></span>
. This means that &ldquo;.cmi&rdquo; files would still be expected to be unique, but
source files could be named however the developer wants.</p>

<p>Obviously, any tools that assume that a module 
<span class="highlight"><code><span class="nc">Bar</span></code></span>
must be compiled from a file called &ldquo;bar.ml&rdquo; will not work in this
situation. However, the only OCaml tool that absolutely relies on this
assumption is &ldquo;OCamlDep&rdquo; when it is producing makefile formatted output.</p>

<p>Build systems would not be required to support the &ldquo;-name&rdquo; argument, however
it would make it easy for them to provide features such as:</p>

<ul>
  <li>
    <p>Creating namespaces to reflect a directory structure (e.g. &ldquo;foo/bar.mli&rdquo; becomes &ldquo;foo-bar.cmi&rdquo;).</p>
  </li>
  <li>
    <p>Placing all the modules of a library under a common namespace (e.g. &ldquo;bar.mli&rdquo; becomes &ldquo;foo-bar.cmi&rdquo;)</p>
  </li>
</ul>

<p>This would mean that the names of source files could be kept conveniently
short.</p>

<h4>The &ldquo;-open&rdquo; argument</h4>

<p>My proposals do not include support for automatically opened modules within
namespaces. I feel that this feature conflates two separate issues and it
would be better to solve the problem of automatically opened modules elsewhere.</p>

<p>Auto-opened modules are meant to allow libraries to provide their own
equivalent of the standard library&rsquo;s 
<span class="highlight"><code><span class="nc">Pervasives</span></code></span>
module. I think that it would be more appropriate to have these &ldquo;pervasive&rdquo;
modules opened by default in any program compiled using one of these
libraries.</p>

<p>I propose adding a command-line argument &ldquo;-open&rdquo; that could be used to open a
module by default:</p>

<figure class="highlight"><pre><code class="language-sh" data-lang="sh">ocamlc -c -open core-pervasives.cmi foo.ml</code></pre></figure>

<p>By adding support for this feature to OCamlFind, libraries could add this
argument to every program compiled using them. This amounts to having
automatically opened modules as part of the package system rather than part of
the namespace system.</p>

