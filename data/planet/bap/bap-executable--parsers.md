---
title: BAP Executable  Parsers
description: The Binary Analysis Platform Blog
url: http://binaryanalysisplatform.github.io/bap_executable_parsers
date: 2014-12-04T00:00:00-00:00
preview_image:
featured:
authors:
- bap
---

<p>One of the fundamental tasks in binary analysis is parsing executable
formats on disk.  Popular executable formats include ELF (Linux),
Mach-O (OS X), and PE (Windows). In IDA Pro, this parsing is done by
what they call loaders.</p>

<p>When designing the BAP architecture, we had two goals:</p>

<ol>
  <li>Enable the use of existing and third-party parsing libraries.</li>
  <li>Provide a unified front-end view and set of routines to downstream
code that is agnostic to the particular parsing format.</li>
</ol>

<p>Our approach to meeting these goals was to design a plugin
architecture. The plugin architecture consists of two logical pieces
of code:</p>

<ol>
  <li>
    <p>A parser-specific backend plugin that presents a simplified view on
data stored in a particular binary container. This representation
is minimized and simplified, in order to make it easier to write
plugins in languages other then OCaml. The representation is
described in a
<a href="https://github.com/BinaryAnalysisPlatform/bap/blob/master/lib/bap_image/image_backend.ml">Image_backend</a>
module.</p>
  </li>
  <li>
    <p>A frontend module
<a href="https://github.com/BinaryAnalysisPlatform/bap/blob/master/lib/bap_image/bap_image.ml">Image</a>
that provides access to the data in executable container formats
while abstracting away the specific details of that
container. Example functions include creating an <code class="language-plaintext highlighter-rouge">image</code> from a
filename or data string, getting attributes such as the
architecture and address size, etc. And, of course, it provides
methods to access the actual data, like sections, symbols and
memory.</p>
  </li>
</ol>

<p><strong>Opening up BAP.</strong> In the rest of this article we go through the
plugin architecture using the OCaml-native ELF plugin as our running
example. We assume, that <code class="language-plaintext highlighter-rouge">Bap.Std</code> has been opened:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="o">$</span> <span class="n">baptop</span>
<span class="o">&lt;...</span> <span class="n">utop</span> <span class="n">initialization</span> <span class="n">output</span> <span class="o">...&gt;</span>
<span class="n">utop</span> <span class="o">#</span> <span class="k">open</span> <span class="nn">Bap</span><span class="p">.</span><span class="nc">Std</span><span class="p">;;</span></code></pre></figure>

<p>We will refer to all definitions using their short aliases. If it
is no stated otherwise, all types and definitions are belong to a
<code class="language-plaintext highlighter-rouge">Bap.Std</code> hierarchy.</p>

<h2>Backend Plugin</h2>

<p>The ELF backend code&rsquo;s job is to abstract away the ELF and DWARF
specific details into a unified <code class="language-plaintext highlighter-rouge">image</code> type.  Our Elf backend plugin
is divided into two libraries:</p>

<ul>
  <li>
    <p><code class="language-plaintext highlighter-rouge">bap.elf</code> for parsing and converting Elf binaries to an executable
 format-agnostic data structure.</p>

    <ul>
      <li>The <code class="language-plaintext highlighter-rouge">bap.elf</code> module in turn uses an Elf parser for most of the
heavy lifting. The Elf parser is implemented in a
<a href="https://github.com/BinaryAnalysisPlatform/bap/blob/master/lib/bap_elf/bap_elf.ml">Elf</a>
module. <a href="https://github.com/BinaryAnalysisPlatform/bap/blob/master/lib/bap_elf/elf_types.ml">Elf.Types</a>
submodule exposes a rich set of type definitions, and
<a href="https://github.com/BinaryAnalysisPlatform/bap/blob/master/lib/bap_elf/elf_parse.ml">Elf.Parse</a>
provides an interface to the parser proper. The parser is
inspired from Jyun-Yan You&rsquo;s parser, but modified to avoid
unnecessary copies of data for efficiency. As such, the parser
does not typically return actual data, but offsets to queried
data.  Of course you can always retrieve the data when needed
using the utility functions <code class="language-plaintext highlighter-rouge">Elf.section_name</code> and
<code class="language-plaintext highlighter-rouge">Elf.string_of_section</code>.</li>
    </ul>
  </li>
  <li>
    <p><code class="language-plaintext highlighter-rouge">bap.dwarf</code> that allows one to lookup dwarf symbols in a file. At
the time of this writing, our elf parsing library doesn&rsquo;t support
symtable reading.</p>
  </li>
</ul>

<h2>Frontend</h2>

<p>The frontend provides an abstraction over executables formats, and is
agnostic to the particular backend. Thus, end users should not have to
change their code as new backends are added.</p>

<p>The frontend provides the
<a href="https://github.com/BinaryAnalysisPlatform/bap/blob/master/lib/bap_image/bap_image.ml">Image</a>
module, which provides functions and data structures such as finding
entry points (<code class="language-plaintext highlighter-rouge">Image.entry_point</code>), architecture (<code class="language-plaintext highlighter-rouge">Image.arch</code>), and
so on.  The <code class="language-plaintext highlighter-rouge">Image</code> module exposes two key types:
<code class="language-plaintext highlighter-rouge">Image.Sec.t</code> for sections, and <code class="language-plaintext highlighter-rouge">Image.Sym.t</code> for symbols. For each
type there are utilities for efficient comparison, iteration, building
hash tables, and so on.</p>

<h2>Creating and Using New Plugins</h2>

<p>New plugins can be added by anyone, and need not be incorporated into
the BAP tree itself. Recall that
<a href="https://binaryanalysisplatform.github.io/bap_plugins">BAP plugins</a> are found via the
<code class="language-plaintext highlighter-rouge">META</code> file, and are of the form:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>plugin_system = &quot;bap.subsystem&quot;
</code></pre></div></div>

<p>In order to add a new executable image backend, you should attach your
plugin to the  <code class="language-plaintext highlighter-rouge">image</code> subystem, i.e.,:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>plugin_system = &quot;bap.image&quot;
</code></pre></div></div>

<p>We recommend you do so by adding the above command as part of your
oasis build.  Please see our
<a href="https://binaryanalysisplatform.github.io/bap_plugins">BAP plugin blog post</a> on plugins for more information.</p>

<p><strong>Note:</strong> We adhere to the principle functions in BAP do not
occasionally throw exceptions. Instead, if function can fail, then it
will specify it explicitly in its type, by returning a value of type
<a href="https://blogs.janestreet.com/ocaml-core/110.01.00/doc/core_kernel/#Or_error">&lsquo;a Or_error.t</a>,
that is described in their
<a href="https://blogs.janestreet.com/how-to-fail-introducing-or-error-dot-t/">blog</a>
as well as in the Real World OCaml
<a href="https://realworldocaml.org/v1/en/html/error-handling.html">Chapter 7</a>. We
encourage you to follow this convention in your own plugins.</p>

<h2>Summary</h2>

<p>BAP provides a neat plugin architecture for adding new backends that
parse executable formats.  In order to support a new format, you
should write (or find an existing) parser, and then write a small
set of functions as a plugin that translate whatever the parser code
outputs into the BAP data structures.  Our plugin system allows third
parties to add plugins at any time without changing BAP.  The plugin
system also means end users do not have to change any of their code
when a new plugin is added.</p>

<p>One elephant in the room we did not address is why we do not simply
use BFD, as we did in previous versions of BAP.  One reason is BFD is
a large library, and therefore may be more than most people
need. While a large library may seem attractive at first blush (after
all, features!), remember that if you get the functionality, you also
get all the bugs, vulnerabilities, and support issues as well.  A
second reason is BFD is GPL, which would mean BAP is GPL if we
included it as a core component.  GPL poses a barrier for adoption in
some practical scenarios, which we wish to avoid.</p>

<p>Overall, by abstracting to a plugin architecture in this release of
BAP, we believe we hit a nice middle ground where people can use
whatever backends they want for parsing, while providing a useful set
of features to front-end users.</p>

