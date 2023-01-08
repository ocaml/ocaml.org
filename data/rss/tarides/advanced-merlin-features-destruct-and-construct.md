---
title: 'Advanced Merlin Features: Destruct and Construct'
description: "Merlin is one of the most important tools for OCaml users, but a lot
  of its\nadvanced feature often remain unknown. For OCaml newcomers who\u2026"
url: https://tarides.com/blog/2022-12-21-advanced-merlin-features-destruct-and-construct
date: 2022-12-21T00:00:00-00:00
preview_image: https://tarides.com/static/371712405081c46dba0f64c07c4d36da/0132d/merlin_construct.jpg
featured:
---

<p>Merlin is one of the most important tools for OCaml users, but a lot of its
advanced feature often remain unknown. For OCaml newcomers who might not know, Merlin is the server software that provides intelligence to code editors when working on OCaml documents. It allows one to easily navigate the code, get meaningful information (like type information), and perform code generation and refactoring tasks. Merlin installation and usage is documented on its <a href="https://ocaml.github.io/merlin/">official webpage</a>.</p>
<p>Merlin is distributed with both an Emacs and a Vim plugin. It can also be used in Vscode via the OCaml LSP Server and the corresponding plugin.</p>
<p>In this post, we will focus on two complementary features of Merlin: the venerable <code>destruct</code> and the younger <code>construct</code>. Both of these leverage OCaml's precise type information to destruct or create expressions.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#destruct" aria-label="destruct permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Destruct</h2>
<p>Destruct (sometimes called case-analysis) uses the type of an identifier to
perform multiple tasks related to pattern-matching. It can be called with the
following key bindings:</p>
<ul>
<li>Emacs: <kbd>C-d</kbd> or <kbd>M-x merlin-destruct</kbd></li>
<li>Vim: <kbd>:MerlinDestruct</kbd></li>
<li>VSCode: <kbd>Alt-d</kbd> or <kbd>&#128161; Destruct</kbd></li>
</ul>
<p>Destruct's behavior changes slightly depending on the context around the cursor. We are going to describe how it behaves in the next three sections.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#automatic-case-analysis" aria-label="automatic case analysis permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Automatic Case Analysis</h3>
<p>The primary use case for Destruct is to generate a pattern-matching for a
given value. Let's consider the following snippet:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">let f (x : int option) = x </code></pre></div>
<p>Calling <code>destruct</code> on the right-most occurrence of <code>x</code> will automatically generate the following pattern-matching with the two constructors of <code>x</code>'s' option type:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">let f (x : int option) = match x with
  | None -&gt; _
  | Some _ -&gt; _</code></pre></div>
<p>What happened is that Merlin looked at the type of <code>x</code> and generated a complete pattern-matching by enumerating its constructors.</p>
<p>Notice that Merlin used underscores on the right-handsides of the matching. We call these underscores <em>typed holes</em>. These holes are rejected by the compiler, but Merlin will provide type information for them. These holes should not be confused with the wildcard pattern appearing on the left handside <code>Some _</code>.</p>
<p>After calling <code>destruct</code>, the cursor should have jumped to the first hole. In
Emacs (resp. Vim), you can navigate between holes by using the commands <kbd>M-x merlin-next-hole</kbd> (resp. <kbd>:MerlinNextHole</kbd>) and <kbd>M-x merlin-previous-hole</kbd> (resp. <kbd>:MerlinPreviousHole</kbd>). In VSCode, you can use <kbd>Alt-y</kbd> to jump to the next typed hole.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#complete-a-matching" aria-label="complete a matching permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Complete a Matching</h3>
<p>Merlin can also add missing branches to an incomplete matching. Given
the following snippet:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">let f (x : int option) = match x with
  | None -&gt; _</code></pre></div>
<p>Calling <code>destruct</code> with the cursor on <code>None</code> will make the pattern-matching
exhaustive:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">let f (x : int option) = match x with
  | None -&gt; _
  | Some _ -&gt; _</code></pre></div>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#refine-the-cases" aria-label="refine the cases permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Refine the Cases</h3>
<p>Finally, Merlin can be used to make a pattern-matching more precise when called on a <em>wildcard</em> pattern <code>_</code>. Given the following snippet:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">let f (x : int option opton) = match x with
  | None -&gt; _
  | Some _ -&gt; _</code></pre></div>
<p>Calling <code>destruct</code> with the cursor on the <code>_</code> pattern in <code>Some _</code> will refine the matching:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">let f (x : int option option) = match x with
  | None -&gt; _
  | Some (None) | Some (Some _) -&gt; _</code></pre></div>
<p>Note that Destruct also works with other types, like records. Let's consider the following snippet:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">type t = { a : string option }
let f (x : t) = x</code></pre></div>
<p>Calling <code>destruct</code> on the last occurrence of <code>x</code> will yield:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">let f (x : t) = match x with 
  | { a } -&gt; _</code></pre></div>
<p>And we can refine it by calling <code>destruct</code> again on <code>a</code>, etc.</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">let f (x : t) = match x with 
  | { a = None } | { a = Some _ } -&gt; _</code></pre></div>
<p>That wraps our presentation for <code>destruct</code>. Generating and completing pattern-
matching cases can be very useful when working with large sum types !</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#construct" aria-label="construct permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Construct</h2>
<p>Construct can be considered as the dual of Destruct, as they work
complementarily. When called over a typed-hole <code>_</code>, Construct will suggest
values that can fill that hole. It can be called with the following key
bindings:</p>
<ul>
<li>Emacs: <kbd>M-x merlin-construct</kbd></li>
<li>Vim: <kbd>:MerlinConstruct</kbd></li>
<li>VSCode: <kbd>Alt-c</kbd> of <kbd>&#128161; Construct an expression</kbd> (the cursor must be right after the <code>_</code>)</li>
</ul>
<p>For example, given the following snippet:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">let x : int option = _</code></pre></div>
<p>Calling <code>construct</code> with the cursor on the <code>_</code> typed hole will suggest the following constructions:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">Some _
None</code></pre></div>
<p>Choosing the first one will replace the hole and place the cursor on the next hole:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">let x : int option = (Some _)</code></pre></div>
<p>Calling <code>construct</code> again will suggest <code>0</code> and result in:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">let x : int option = (Some 0)</code></pre></div>
<p>In the future, Construct might also suggest fitting values from the local
environment instead of solely rely on a type's constructors.</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#destruct-and-construct" aria-label="destruct and construct permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Destruct and Construct</h2>
<p>As stated previously calls to <code>destruct</code> and <code>construct</code> can be used in
collaboration. For example, after calling <code>destruct</code> on <code>x</code> in the following code snippet:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">type t = { a : unit; b : string option }
let f (x : int option) : t option = x</code></pre></div>
<p><code>x</code> is replaced by a matching on <code>x</code> with the cursor on the first hole:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">let f (x : int option) : t option = 
    match w with
    | None -&gt; _
    | Some _ -&gt; _</code></pre></div>
<p>One can immediately call <code>construct</code> and choose a construction for the first branch:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">let f (x : int option) : t option = 
    match w with
    | None -&gt; None
    | Some _ -&gt; _</code></pre></div>
<p>And again for the second branch:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">let f (x : int option) : t option = 
    match w with
    | None -&gt; None
    | Some _ -&gt; Some _</code></pre></div>
<p>Finally, like Destruct, Construct also works with records and most OCaml types:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">Some _ &rarr; Some { a = _; b = _ } &rarr; Some { a = (); b = None }</code></pre></div>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#conclusion" aria-label="conclusion permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Conclusion</h2>
<p>When put to good use, these complementary features can remove some of the burden of working with big variant types. We encourage you to try them and see if they help your everyday workflow! If you encounter any issues or have ideas for improvement, please communicate them to us <a href="https://github.com/ocaml/merlin/issues">via the issue tracker</a>.</p>
