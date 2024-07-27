---
title: Introducing tree-sitter-dune
description:
url: http://blog.emillon.org/posts/2024-07-26-introducing-tree-sitter-dune.html
date: 2024-07-26T00:00:00-00:00
preview_image:
authors:
- Etienne Millon
source:
---

<p>I made a <a href="https://tree-sitter.github.io/tree-sitter/">tree-sitter</a> plugin for
<code>dune</code> files. It is available <a href="https://github.com/emillon/tree-sitter-dune">on
GitHub</a>.</p>
<p>Tree-sitter is a parsing system that can be used in text editors.
<a href="https://dune.build/">Dune</a> is a build system for OCaml projects.
Its configuration language lives in <code>dune</code> files which use a s-expression
syntax.</p>
<p>This makes highlighting challenging: the lexing part of the language is very
simple (atoms, strings, parentheses), but it is not enough to make a good
highlighter.</p>
<p>In the following example, <code>with-stdout-to</code> and <code>echo</code> are &ldquo;actions&rdquo; that we
could highlight in a special way, but these names can also appear in places
where they are not interpreted as actions, and doing so would be confusing (for
example, we could write to a file named <code>echo</code> instead of <code>foo.txt</code>.</p>
<div class="sourceCode"><pre class="sourceCode scheme"><code class="sourceCode scheme"><span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb1-1" aria-hidden="true" tabindex="-1"></a>(rule</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb1-2" aria-hidden="true" tabindex="-1"></a> (action</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb1-3" aria-hidden="true" tabindex="-1"></a>  (with-stdout-to</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb1-4" aria-hidden="true" tabindex="-1"></a>   foo.txt</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb1-5" aria-hidden="true" tabindex="-1"></a>   (echo <span class="st">&quot;testing&quot;</span>))))</span></code></pre></div>
<p>Tree-sitter solves this, because it creates an actual parser that goes beyond
lexing.</p>
<p>In this example, I created grammar rules that parse the contents of <code>(action ...)</code> as an action, recognizing the various constructs of this DSL.</p>
<p>The output of the parser is this syntax tree with location information (for
some reason, line numbers start at 0 which is normal and unusual at the same
time).</p>
<pre><code>(source_file [0, 0] - [5, 0]
  (stanza [0, 0] - [4, 22]
    (stanza_name [0, 1] - [0, 5])
    (field_name [1, 2] - [1, 8])
    (action [2, 2] - [4, 20]
      (action_name [2, 3] - [2, 17])
      (file_name_target [3, 3] - [3, 10]
        (file_name [3, 3] - [3, 10]))
      (action [4, 3] - [4, 19]
        (action_name [4, 4] - [4, 8])
        (quoted_string [4, 9] - [4, 18])))))</code></pre>
<p>The various strings are annotated with their type: we have stanza names
(<code>rule</code>), field names (<code>action</code>), action names (<code>with-stdout-to</code>, <code>echo</code>), file
names (<code>foo.txt</code>), and plain strings (<code>&quot;testing&quot;</code>).</p>
<p>By itself, that is not useful, but it&rsquo;s possible to write <em>queries</em> to make
this syntax tree do interesting stuff.</p>
<p>The first one is highlighting: we can set styles for various &ldquo;patterns&rdquo; (in
practice, I only used node names) by defining queries:</p>
<div class="sourceCode"><pre class="sourceCode scheme"><code class="sourceCode scheme"><span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb3-1" aria-hidden="true" tabindex="-1"></a>(stanza_name) @function</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb3-2" aria-hidden="true" tabindex="-1"></a>(field_name) @property</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb3-3" aria-hidden="true" tabindex="-1"></a>(quoted_string) @string</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb3-4" aria-hidden="true" tabindex="-1"></a>(multiline_string) @string</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb3-5" aria-hidden="true" tabindex="-1"></a>(action_name) @keyword</span></code></pre></div>
<p>The parts with <code>@</code> map to &ldquo;highlight groups&rdquo; used in text editors.</p>
<p>Another type of query is called &ldquo;injections&rdquo;. It is used to link different
types of grammars together. For example, <code>dune</code> files can start with a special
comment that indicates that the rest of the file is an OCaml program. In that
case, the parser emits a single <code>ocaml_syntax</code> node and the following injection
indicates that this file should be parsed using an OCaml parser:</p>
<div class="sourceCode"><pre class="sourceCode scheme"><code class="sourceCode scheme"><span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb4-1" aria-hidden="true" tabindex="-1"></a>((ocaml_syntax) @injection.content</span>
<span><a href="http://blog.emillon.org/feeds/ocaml.xml#cb4-2" aria-hidden="true" tabindex="-1"></a> (#<span class="kw">set!</span> injection.language <span class="st">&quot;ocaml&quot;</span>))</span></code></pre></div>
<p>Another use case for this is <code>system</code> actions: these strings in <code>dune</code> files
could be interpreted using a shell parser.</p>
<p>In the other direction, it is possible to inject <code>dune</code> files into another
document. For example, a markdown parser can use injections to highlight code
blocks.</p>
<p>I&rsquo;m happy to have explored this technology. The toolchain seemed complex at
first: there&rsquo;s a compiler which seems to be a mix of node and rust, which
generates C, which is compiled into a dynamically loaded library; but this is
actually pretty well integrated in nix and neovim to the details are made
invisible.</p>
<p>The testing mechanism is similar to the cram tests we use in Dune, but I was a
bit confused with the colors at first: when the output of a test changes, Dune
considers that the new output is a <code>+</code> in the diff, and highlights it in green;
while tree-sitter considers that the &ldquo;expected output&rdquo; is green.</p>
<p>There are many ways to improve this prototype: either by adding queries (it&rsquo;s
possible to define text objects, folding expressions, etc), or by improving
coverage for <code>dune</code> files (in most cases, the parser uses a s-expression
fallback). I&rsquo;m also curious to see if it&rsquo;s possible to use this parser to
provide a completion source. Since the strings are tagged with their type (are
we expecting a library name, a module name, etc), I think we could use that to
provide context-specific completions, but that&rsquo;s probably difficult to do.</p>
<p>Thanks <a href="https://x.com/teej_dv">teej</a> for the initial idea and the useful
resources.</p>
