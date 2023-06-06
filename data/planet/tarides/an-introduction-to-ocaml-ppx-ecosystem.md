---
title: An introduction to OCaml PPX ecosystem
description: "These last few months, I spent some time writing new OCaml PPX rewriters
  or contributing to existing\nones. It's a really fun experience\u2026"
url: https://tarides.com/blog/2019-05-09-an-introduction-to-ocaml-ppx-ecosystem
date: 2019-05-09T00:00:00-00:00
preview_image: https://tarides.com/static/0e8e776eb4ab9f596324bfe7e318b854/96c5f/circuit_boards.jpg
featured:
---

<p>These last few months, I spent some time writing new OCaml PPX rewriters or contributing to existing
ones. It's a really fun experience. Toying around with the AST taught me a lot about a language I
thought I knew really well. Turns out I actually had no idea what I was doing all these years.</p>
<p>All jokes aside, I was surprised that the most helpful tricks I learned while writing PPX rewriters
weren't properly documented. There already exist a few very good introduction articles on the
subject, like that
<a href="https://whitequark.org/blog/2014/04/16/a-guide-to-extension-points-in-ocaml/">2014's article from Whitequark</a>,
this <a href="http://rgrinberg.com/posts/extensions-points-update-1/">more recent one from Rudi Grinberg</a>
or even <a href="https://victor.darvariu.me/jekyll/update/2018/06/19/ppx-tutorial.html">this last one from Victor Darvariu</a>
I only discovered after I actually started writing my own. I still felt like they were slightly
outdated or weren't answering all the questions I had when I started playing with PPX and writing my
first rewriters.</p>
<p>I decided to share my PPX adventures in the hope that it can help others familiarize with this bit
of the OCaml ecosystem and eventually write their first rewriters. The scope of this article is not to
cover every single detail about the PPX internals but just to give a gentle introduction to
beginners to help them get settled. That also means I might omit things that I don't think are worth
mentioning or that might confuse the targetted audience but feel free to comment if you believe
this article missed an important point.</p>
<p>It's worth mentioning that a lot of the nice tricks mentioned in these lines were given to me by a
wonderful human being called &Eacute;tienne Millon, thanks &Eacute;tienne!</p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#what-is-a-ppx" aria-label="what is a ppx permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>What is a PPX?</h2>
<p>PPX rewriters or PPX-es are preprocessors that are applied to your code before passing it on to the
compiler. They don't operate on your code directly but on the Abstract Syntax Tree or AST resulting
from its parsing. That means that they can only be applied to syntactically correct OCaml code. You
can think of them as functions that take an AST and return a new AST.</p>
<p>That means that in theory you can do a lot of things with a PPX, including pretty bad and cryptic
things. You could for example replace every instance of <code>true</code> by <code>false</code>, swap the branches of any
<code>if-then-else</code> or randomize the order of every pattern-matching case.
Obviously that's not the kind of behaviour that we want as it would make it impossible to
understand the code since it would be so far from the actual AST the compiler would get.
In practice PPX-es have a well defined scope and only transform parts you explicitly annotated.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#understanding-the-ocaml-ast" aria-label="understanding the ocaml ast permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Understanding the OCaml AST</h3>
<p>First things first, what is an AST. An AST is an abstract representation of your code. As the name
suggests it has a tree-like structure where the root describes your entire file. It has children for
each bits such as a function declaration or a type definition, each of them having their own
children, for example for the function name, its argument and its body and that goes on until you
reach a leaf such as a literal <code>1</code>, <code>&quot;abc&quot;</code> or a variable for instance.
In the case of OCaml it's a set of recursive types allowing us to represent OCaml code as an OCaml
value. This value is what the parser passes to the compiler so it can type check and compile it to
native or byte code.
Those types are defined in OCaml's <code>Parsetree</code> module. The entry points there are the <code>structure</code>
type which describes the content of an <code>.ml</code> file and the <code>signature</code> type which describes the
content of an <code>.mli</code> file.</p>
<p>As mentionned above, a PPX can be seen as a function that transforms an AST. Writing a PPX thus
requires you to understand the AST, both to interpret the one you'll get as input and
to produce the right one as output. This is probably the trickiest part as unless you've already
worked on the OCaml compiler or written a PPX rewriter, that will probably be the first time you two
meet. Chances are also high that'll be a pretty bad first date and you will need some to time
to get to know each other.</p>
<p>The <code>Parsetree</code> module <a href="https://caml.inria.fr/pub/docs/manual-ocaml/compilerlibref/Parsetree.html">documentation</a>,
is a good place to start. The above mentioned <code>structure</code> and <code>signature</code> types are at the root of
the AST but some other useful types to look at at first are:</p>
<ul>
<li><code>expression</code> which describes anything in OCaml that evaluates to a value, the right hand side of a
<code>let</code> binding for instance.</li>
<li><code>pattern</code> which is what you use to deconstruct an OCaml value, the left hand side of a <code>let</code>
binding or a pattern-matching case for example.</li>
<li><code>core_type</code> which describes type expressions ie what you would find on the right hand side of a
value description in a <code>.mli</code>, ie <code>val f : &lt;what_goes_there&gt;</code>.</li>
<li><code>structure_item</code> and <code>signature_item</code> which describe the top level AST nodes you can find in a
<code>structure</code> or <code>signature</code> such as type definitions, value or module declarations.</li>
</ul>
<p>Thing is, it's a bit a rough and there's no detailed explanation about how a specific bit of code is
represented, just type definitions. Most of the time, the type, field, and variant names are
self-explanatory but it can get harder with some of the more advanced language features.
It turns out there are plenty of comments that are really helpful in the actual <code>parsetree.mli</code> file
and that aren't part of the generated documentation. You can find them on
<a href="https://github.com/ocaml/ocaml/blob/trunk/parsing/parsetree.mli">github</a> but I personally prefer to
have it opened in a VIM tab when I work on a PPX so I usually open
<code>~/.opam/&lt;current_working_switch&gt;/lib/ocaml/compiler-libs/parsetree.mli</code>.</p>
<p>This works well while exploring but you might also want a more straightforward approach to
discovering what the AST representation is for some specific OCaml code. The
<a href="https://github.com/ocaml-ppx/ppx_tools"><code>ppx_tools</code></a> opam package comes with a <code>dumpast</code> binary
that pretty prints the AST for any given piece of valid OCaml code. You can install it using opam:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">$opam install ppx_tools</code></pre></div>
<p>and then run it using <code>ocamlfind</code>:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">$ocamlfind ppx_tools/dumpast some_file.ml</code></pre></div>
<p>You can use it on <code>.ml</code> and <code>.mli</code> files or to quickly get the AST for an expression with the <code>-e</code>
option:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">$ocamlfind ppx_tools/dumpast -e &quot;1 + 1&quot;</code></pre></div>
<p>Similarly, you can use the <code>-t</code> or <code>-p</code> options to respectively pretty print ASTs from type
expressions or patterns.</p>
<p>Using <code>dumpast</code> to get both the ASTs of a piece of code using your future PPX and the resulting
preprocessed code is a good way to start and will help you figure out what are the steps required to
get there.</p>
<p>Note that you can use the compiler or <code>utop</code> have a similar feature with the <code>-dparsetree</code> flag.
Running <code>ocamlc/ocamlopt -dparsetree file.ml</code> will pretty print the AST of the given file while
running <code>utop -dparsetree</code> will pretty print the AST of the evaluated code alongside it's
evaluation.
I tend to prefer the pretty printed AST from <code>dumpast</code> but any of these tools will prove helpful
in understanding the AST representation of a given piece of OCaml code.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#language-extensions-interpreted-by-ppx-es" aria-label="language extensions interpreted by ppx es permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Language extensions interpreted by PPX-es</h3>
<p>OCaml 4.02 introduced syntax extensions meant to be used by external tools such as PPX-es. Knowing
their syntax and meaning is important to understand how most of the existing rewriters
work because they usually look for those language extensions in the AST to know which part of it
they need to modify.</p>
<p>The two language extensions we're interested in here are extension nodes and attributes. They are
defined in detail in the OCaml manual (see the
<a href="https://caml.inria.fr/pub/docs/manual-ocaml/attributes.html">attributes</a> and
<a href="https://caml.inria.fr/pub/docs/manual-ocaml/extensionnodes.html">extension nodes</a> sections) but I'll
try to give a good summary here.</p>
<p>Extension nodes are used in place of expressions, module expressions, patterns, type expressions or
module type expressions. Their syntax is <code>[%extension_name payload]</code>. We'll come back to the payload
part a little later.
You can also find extension nodes at the top level of modules or module signatures with the syntax
<code>[%%extension_name payload]</code>.
Hopefully the following cheatsheet can help you remember the basics of how and where you can use
them:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">type</span> t <span class="token operator">=</span>
  <span class="token punctuation">{</span> a <span class="token punctuation">:</span> int
  <span class="token punctuation">;</span> b <span class="token punctuation">:</span> <span class="token punctuation">[</span><span class="token operator">%</span>ext pl<span class="token punctuation">]</span>
  <span class="token punctuation">}</span>

<span class="token keyword">let</span> x <span class="token operator">=</span>
  <span class="token keyword">match</span> <span class="token number">1</span> <span class="token keyword">with</span>
  <span class="token operator">|</span> <span class="token number">0</span> <span class="token operator">-&gt;</span> <span class="token punctuation">[</span><span class="token operator">%</span>ext pl<span class="token punctuation">]</span>
  <span class="token operator">|</span> <span class="token punctuation">[</span><span class="token operator">%</span>ext pl<span class="token punctuation">]</span> <span class="token operator">-&gt;</span> <span class="token boolean">true</span>

<span class="token punctuation">[</span><span class="token operator">%%</span>ext pl<span class="token punctuation">]</span></code></pre></div>
<p>Because extension nodes stand where regular AST nodes should, the compiler won't accept them and
will give you an <code>Uninterpreted extension</code> error. Extension nodes have to be expanded by a PPX for
your code to compile.</p>
<p>Attributes are slightly different although their syntax is very close to extensions. Attributes
are attached to existing AST nodes instead of replacing them. That means that they don't necessarily
need to be transformed and the compiler will ignore unknown attributes by default.
They can come with a payload just like extensions and use <code>@</code> instead of <code>%</code>. The number of <code>@</code>
preceding the attribute name specifies which kind of node they are attached to:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> a <span class="token operator">=</span> <span class="token number">12</span> <span class="token punctuation">[</span><span class="token operator">@</span>attr pl<span class="token punctuation">]</span>

<span class="token keyword">let</span> b <span class="token operator">=</span> <span class="token string">&quot;some string&quot;</span> <span class="token punctuation">[</span><span class="token operator">@@</span>attr pl<span class="token punctuation">]</span>

<span class="token punctuation">[</span><span class="token operator">@@@</span>attr pl<span class="token punctuation">]</span></code></pre></div>
<p>In the first example, the attribute is attached to the expression <code>12</code> while in the second example
it is attached to the whole <code>let b = &quot;some string&quot;</code> value binding. The third one is of a slightly
different nature as it is a floating attribute. It's not attached to anything per-se and just ends
up in the AST as a structure item.
Because there is a wide variety of nodes to which you can attach attributes, I won't go too far into
details here but a good rule of thumb is that you use <code>@@</code> attributes when you want them attached to
structure or signature items, for anything deeper within the AST structure such as patterns,
expressions or core types, use the single <code>@</code> syntax. Looking at the <code>Parsetree</code> documentation can
help you figure out where you can find attributes.</p>
<p>Now let's talk about those payloads I mentioned earlier. You can think of them as &quot;arguments&quot; to
the extension points and attributes. You can pass different kinds of arguments and the syntax varies
for each of them:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> a <span class="token operator">=</span> <span class="token punctuation">[</span><span class="token operator">%</span>ext expr_or_str_item<span class="token punctuation">]</span> 
<span class="token keyword">let</span> b <span class="token operator">=</span> <span class="token punctuation">[</span><span class="token operator">%</span>ext<span class="token punctuation">:</span> type_expr_or_sig_item<span class="token punctuation">]</span>
<span class="token keyword">let</span> c <span class="token operator">=</span> <span class="token punctuation">[</span><span class="token operator">%</span>ext<span class="token operator">?</span> pattern<span class="token punctuation">]</span></code></pre></div>
<p>As suggested in the examples, you can pass expressions or structure items using a space character,
type expressions or signature items (anything you'd find at the top level of a module signature)
using a <code>:</code> or a pattern using a <code>?</code>.</p>
<p>Attributes' payload use the same syntax:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> a <span class="token operator">=</span> <span class="token string">'a'</span> <span class="token punctuation">[</span><span class="token operator">@</span>attr expr_or_str_item<span class="token punctuation">]</span>
<span class="token keyword">let</span> b <span class="token operator">=</span> <span class="token string">'b'</span> <span class="token punctuation">[</span><span class="token operator">@</span>attr<span class="token punctuation">:</span> type_expr_or_sig_item<span class="token punctuation">]</span>
<span class="token keyword">let</span> a <span class="token operator">=</span> <span class="token string">'a'</span> <span class="token punctuation">[</span><span class="token operator">@</span>attr<span class="token operator">?</span> pattern<span class="token punctuation">]</span></code></pre></div>
<p>Some PPX-es rely on other language extensions such as the suffix character you can attach to <code>int</code>
and <code>float</code> literals (<code>10z</code> could be used by a PPX to turn it into <code>Z.of_string &quot;10&quot;</code> for instance)
or quoted strings with a specific identifier (<code>{ppx_name|some quoted string|ppx_name}</code> can be used
if you want your PPX to operate on arbitrary strings and not only syntactically correct OCaml) but
attributes and extensions are the most commonly used ones.</p>
<p>Attributes and extension points can be expressed using an infix syntax. The attribute version is
barely used but some forms of the infix syntax for extension points are used by popular PPX-es and
it is likely you will encounter some of the following:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> infix_let_extension <span class="token operator">=</span>
  <span class="token keyword">let</span><span class="token operator">%</span>ext x <span class="token operator">=</span> <span class="token number">2</span> <span class="token keyword">in</span>
  <span class="token punctuation">.</span><span class="token punctuation">.</span><span class="token punctuation">.</span>

<span class="token keyword">let</span> infix_match_extension <span class="token operator">=</span>
  <span class="token keyword">match</span><span class="token operator">%</span>ext y <span class="token keyword">with</span> <span class="token punctuation">.</span><span class="token punctuation">.</span><span class="token punctuation">.</span>

<span class="token keyword">let</span> infix_try_extension <span class="token operator">=</span>
  <span class="token keyword">try</span><span class="token operator">%</span>ext f z <span class="token keyword">with</span> <span class="token punctuation">_</span> <span class="token operator">-&gt;</span> <span class="token punctuation">.</span><span class="token punctuation">.</span><span class="token punctuation">.</span></code></pre></div>
<p>which are syntactic sugar for:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> infix_let_extension <span class="token operator">=</span>
  <span class="token punctuation">[</span><span class="token operator">%</span>ext <span class="token keyword">let</span> x <span class="token operator">=</span> <span class="token number">2</span> <span class="token keyword">in</span> <span class="token punctuation">.</span><span class="token punctuation">.</span><span class="token punctuation">.</span><span class="token punctuation">]</span>

<span class="token keyword">let</span> infix_match_extension <span class="token operator">=</span>
  <span class="token punctuation">[</span><span class="token operator">%</span>ext <span class="token keyword">match</span> y <span class="token keyword">with</span> <span class="token punctuation">.</span><span class="token punctuation">.</span><span class="token punctuation">.</span><span class="token punctuation">]</span>

<span class="token keyword">let</span> infix_try_extension <span class="token operator">=</span>
  <span class="token punctuation">[</span><span class="token operator">%</span>ext <span class="token keyword">try</span> f z <span class="token keyword">with</span> <span class="token punctuation">_</span> <span class="token operator">-&gt;</span> <span class="token punctuation">.</span><span class="token punctuation">.</span><span class="token punctuation">.</span><span class="token punctuation">]</span></code></pre></div>
<p>A good example of a PPX making heavy use of these if
<a href="http://ocsigen.org/lwt/4.1.0/api/Ppx_lwt"><code>lwt_ppx</code></a>. The OCaml manual also contains more examples
of the infix syntax in the Attributes and Extension points sections mentioned above.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#the-two-main-kind-of-ppx-es" aria-label="the two main kind of ppx es permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>The two main kind of PPX-es</h3>
<p>There is a wide variety of PPX rewriters but the ones you'll probably see the most are Extensions and
Derivers.</p>
<h4 style="position:relative;"><a href="https://tarides.com/feed.xml#extensions" aria-label="extensions permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Extensions</h4>
<p>Extensions will rewrite tagged parts of the AST, usually extension nodes of the form
<code>[%&lt;extension_name&gt; payload]</code>. They will replace them with a different AST node of the same nature ie
if the extension point was located where an expression should be, the rewriter will produce an
expression. Good examples of extensions are:</p>
<ul>
<li><a href="https://github.com/rgrinberg/ppx_getenv2"><code>ppx_getenv2</code></a> which replaces <code>[%getenv SOME_VAR]</code> with
the value of the environment variable <code>SOME_VAR</code> at compile time.</li>
<li><a href="https://github.com/NathanReb/ppx_yojson"><code>ppx_yojson</code></a> which allows you to write <code>Yojson</code> values
using OCaml syntax to mimic actual json. For instance you'd use <code>[%yojson {a = None; b = 1}]</code> to
represent <code>{&quot;a&quot;: null, &quot;b&quot;: 1}</code> instead of the <code>Yojson</code>'s notation:
<code>Assoc [(&quot;a&quot;, Null); (&quot;b&quot;, Int 1)]</code>.</li>
</ul>
<h4 style="position:relative;"><a href="https://tarides.com/feed.xml#derivers" aria-label="derivers permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Derivers</h4>
<p>Derivers or deriving plugins will &quot;insert&quot; new nodes derived from type definitions annotated with a
<code>[@@deriving &lt;deriver_name&gt;]</code> attribute. They have various applications but are particularly useful
to derive functions that are tedious and error prone to write by hand such as comparison functions,
pretty printers or serializers. It's really convenient as you don't have to update those functions
every time you update your type definitions. They were inspired by Haskell Type classes. Good
examples of derivers are:</p>
<ul>
<li><a href="https://github.com/ocaml-ppx/ppx_deriving"><code>ppx_deriving</code></a> itself comes with a bunch of deriving
plugins such as <code>eq</code>, <code>ord</code> or <code>show</code> which respectively derives, as you might have guessed,
equality, comparison and pretty-printing functions.</li>
<li><a href="https://github.com/ocaml-ppx/ppx_deriving_yojson"><code>ppx_deriving_yojson</code></a> which derives JSON
serializers and deserializers.</li>
<li><a href="https://github.com/janestreet/ppx_sexp_conv"><code>ppx_sexp_conv</code></a> which derives s-expressions
converters.</li>
</ul>
<p>Derivers often let you attach attributes to specify how some parts of the AST should be handled. For
example when using <code>ppx_deriving_yojson</code> you can use <code>[@default some_val]</code> to make a field of an
object optional:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">type</span> t <span class="token operator">=</span>
  <span class="token punctuation">{</span> a<span class="token punctuation">:</span> int
  <span class="token punctuation">;</span> b<span class="token punctuation">:</span> string <span class="token punctuation">[</span><span class="token operator">@</span>default <span class="token string">&quot;&quot;</span><span class="token punctuation">]</span>
  <span class="token punctuation">}</span>
<span class="token punctuation">[</span><span class="token operator">@@</span>deriving of_yojson<span class="token punctuation">]</span></code></pre></div>
<p>will derive a deserializer that will convert the JSON value <code>{&quot;a&quot;: 1}</code> to the OCaml
<code>{a = 1; b = &quot;&quot;}</code></p>
<h2 style="position:relative;"><a href="https://tarides.com/feed.xml#how-to-write-a-ppx-using-ppxlib" aria-label="how to write a ppx using ppxlib permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>How to write a PPX using <code>ppxlib</code></h2>
<p>Historically there was a few libraries used by PPX rewriter authors to write their PPX-es, including
<code>ppx_tools</code> and <code>ppx_deriving</code> but as the eco-system evolved, <code>ppxlib</code> emerged and is now the most
up-to-date and maintained library to write and handle PPX-es. It wraps the features of those
libraries in a single one.
I encourage you to use <code>ppxlib</code> to write new PPX-es as it is also easier to make various rewriters
work together if they are all registered through <code>ppxlib</code> and the PPX ecosystem would gain from
being unified around a single PPX library and driver.</p>
<p>It is also a great library and has some really powerful features to help you write your extensions
and derivers.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#writing-an-extension" aria-label="writing an extension permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Writing an extension</h3>
<p>The entry point of <code>ppxlib</code> for extensions is <code>Ppxlib.Extension.declare</code>. You have to use that
function to build an <code>Extension.t</code>, from which you can then build a <code>Context_free.Rule.t</code> before
registering your transformation so it's actually applied.</p>
<p>The typical <code>my_ppx_extension.ml</code> will look like:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">open</span> <span class="token module variable">Ppxlib</span>

<span class="token keyword">let</span> extension <span class="token operator">=</span>
  <span class="token module variable">Extension</span><span class="token punctuation">.</span>declare
    <span class="token string">&quot;my_extension&quot;</span>
    some_context
    some_pattern
    expand_function

<span class="token keyword">let</span> rule <span class="token operator">=</span> <span class="token module variable">Context_free</span><span class="token punctuation">.</span><span class="token module variable">Rule</span><span class="token punctuation">.</span>extension extension

<span class="token keyword">let</span> <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">=</span>
  <span class="token module variable">Driver</span><span class="token punctuation">.</span>register_transformation <span class="token label function">~rules</span><span class="token punctuation">:</span><span class="token punctuation">[</span>rule<span class="token punctuation">]</span> <span class="token string">&quot;my_transformation&quot;</span></code></pre></div>
<p>To compile it as PPX rewriter you'll need to put the following in your dune file:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">(library
 (public_name my_ppx)
 (kind ppx_rewriter)
 (libraries ppxlib))</code></pre></div>
<p>Now let's go back a little and look at the important part:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> extension <span class="token operator">=</span>
  <span class="token module variable">Extension</span><span class="token punctuation">.</span>declare
    <span class="token string">&quot;my_extension&quot;</span>
    some_context
    some_pattern
    expand_function</code></pre></div>
<p>Here <code>&quot;my_extension&quot;</code> is the name of your extension and that define how you're going to invoke it
in your extension point. In other words, to use this extension in our code we'll use a
<code>[%my_extension ...]</code> extension point.</p>
<p><code>some_context</code> is a <code>Ppxlib.Extension.Context.t</code> and describes where this extension can be found in
the AST, ie can you use <code>[%my_extension ...]</code> as an expression, a pattern, a core type. The
<code>Ppxlib.Extension.Context</code> module defines a constant for each possible extension context which you
can pass as <code>some_context</code>.
This obviously means that it also describes the type of AST node to which it must be converted and
this property is actually enforced by the <code>some_pattern</code> argument. But we'll come back to that
later.</p>
<p>Finally <code>expand_function</code> is our actual extension implementation, which basically takes the payload,
a <code>loc</code> argument which contains the location of the expanded extension point, a <code>path</code> argument
which is the fully qualified path to the expanded node (eg. <code>&quot;file.ml.A.B&quot;</code>) and returns the
generated code to replace the extension with.</p>
<h4 style="position:relative;"><a href="https://tarides.com/feed.xml#ast_pattern" aria-label="ast_pattern permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Ast_pattern</h4>
<p>Now let's get back to that <code>some_pattern</code> argument.</p>
<p>This is one of the trickiest parts of <code>ppxlib</code> to understand but it's also one its most
powerful features. The type for <code>Ast_pattern</code> is defined as <code>('a, 'b, 'c) t</code> where <code>'a</code> is
the type of AST nodes that are matched, <code>'b</code> is the type of the values you're extracting from the
node as a function type and <code>'c</code> is the return type of that last function. This sounded really
confusing to me at first and I'm guessing it might do to some of you too so let's give it a bit of
context.</p>
<p>Let's look at the type of <code>Extension.declare</code>:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">val</span> declare <span class="token punctuation">:</span>
  string <span class="token operator">-&gt;</span>
  <span class="token type-variable function">'context</span> <span class="token module variable">Context</span><span class="token punctuation">.</span>t <span class="token operator">-&gt;</span>
  <span class="token punctuation">(</span>payload<span class="token punctuation">,</span> <span class="token type-variable function">'a</span><span class="token punctuation">,</span> <span class="token type-variable function">'context</span><span class="token punctuation">)</span> <span class="token module variable">Ast_pattern</span><span class="token punctuation">.</span>t <span class="token operator">-&gt;</span>
  <span class="token punctuation">(</span>loc<span class="token punctuation">:</span><span class="token module variable">Location</span><span class="token punctuation">.</span>t <span class="token operator">-&gt;</span> path<span class="token punctuation">:</span>string <span class="token operator">-&gt;</span> <span class="token type-variable function">'a</span><span class="token punctuation">)</span> <span class="token operator">-&gt;</span>
  t</code></pre></div>
<p>Here, the expected pattern first type parameter is <code>payload</code> which means we want a pattern that
matches <code>payload</code> AST nodes. That makes perfect sense since it is used to describe what your
extension's payload should look like and what to do with it.
The last type parameter is <code>'context</code> which again seems logical. As I mentioned earlier our
<code>expand_function</code> should return the same kind of node as the one where the extension was found.
Now what about <code>'a</code>. As you can see, it describes what comes after the base <code>loc</code> and <code>path</code>
parameters of our <code>expand_function</code>. From the pattern point of view, <code>'a</code> describes the parts of the
matched AST node we wish to extract for later consumption, here by our expander.</p>
<p><code>Ast_pattern</code> contains a whole bunch of combinators to let you describe what your pattern should match
and a specific <code>__</code> pattern that you must use to capture the various parts of the matched nodes.
<code>__</code> has type <code>('a, 'a -&gt; 'b, 'b) Ast_pattern.t</code> which means that whenever it's used it changes the
type of consumer function in the returned pattern.</p>
<p>Let's consider a few examples to try wrapping our heads around this. Say I want to write an
extension that takes an expression as a payload and I want to pass this expression to my expander so
I can generate code based on its value. I can declare the extension like this:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> extension <span class="token operator">=</span>
  <span class="token module variable">Extension</span><span class="token punctuation">.</span>declare
    <span class="token string">&quot;my_extension&quot;</span>
    <span class="token module variable">Extension</span><span class="token punctuation">.</span><span class="token module variable">Context</span><span class="token punctuation">.</span>expression
    <span class="token module variable">Ast_pattern</span><span class="token punctuation">.</span><span class="token punctuation">(</span>single_expr_payload __<span class="token punctuation">)</span>
    expand_function</code></pre></div>
<p>In this example, <code>Extension.Context.expression</code> has type <code>expression Extension.Context.t</code>, the
pattern has type <code>(payload, expression -&gt; expression, expression) Ast_pattern.t</code>. The pattern says we
want to allow a single expression in the payload and capture it. If we decompose it a bit, we can
see that <code>single_expr_payload</code> has type
<code>(expression, 'a, 'b) Ast_pattern.t -&gt; (payload, 'a, 'b) Ast_pattern.t</code> and is passed <code>__</code> which
makes it a <code>(expression, expression -&gt; 'b, 'b) Ast_pattern.t</code> and that's exactly what we want here
as our expander will have type <code>loc: Location.t -&gt; path: string -&gt; expression -&gt; expression</code>!</p>
<p>It works similarly to <code>Scanf.scanf</code> when you think about it. Changing the pattern changes the type of the
consumer function the same way changing the format string does for <code>Scanf</code> functions.</p>
<p>This was a bit easy since we had a custom combinator just for that purpose so let's take a few more
complex examples. Now say we want to only allow pairs of integer and string constants expressions in
our payload. Instead of just capturing any expression and dealing with the error cases in the
<code>expand_function</code> we can let <code>Ast_pattern</code> deal with that and pass an <code>int</code> and <code>string</code> along to
our expander:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token module variable">Ast_pattern</span><span class="token punctuation">.</span><span class="token punctuation">(</span>single_expr_payload <span class="token punctuation">(</span>pexp_tuple <span class="token punctuation">(</span><span class="token punctuation">(</span>eint __<span class="token punctuation">)</span><span class="token operator">^::</span><span class="token punctuation">(</span>estring __<span class="token punctuation">)</span><span class="token operator">^::</span>nil<span class="token punctuation">)</span><span class="token punctuation">)</span><span class="token punctuation">)</span></code></pre></div>
<p>This one's a bit more elaborate but the idea is the same, we use <code>__</code> to capture the int and string
from the expression and use combinators to specify that the payload should be made of a pair and
that gives us a: <code>(payload, int -&gt; string -&gt; 'a, 'a) Ast_pattern.t</code> which should be used with a
<code>loc: Location.t -&gt; path: string -&gt; int -&gt; string -&gt; expression</code> expander.</p>
<p>We can also specify that our extension should take something else than an expression as a payload,
say a pattern with no <code>when</code> clause so that it's applied as <code>[%my_ext? some_pattern_payload]</code>:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token module variable">Ast_pattern</span><span class="token punctuation">.</span><span class="token punctuation">(</span>ppat __ none<span class="token punctuation">)</span></code></pre></div>
<p>or no payload at all and it should just be invoked as <code>[%my_ext]</code>:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token module variable">Ast_pattern</span><span class="token punctuation">.</span><span class="token punctuation">(</span>pstr nil<span class="token punctuation">)</span></code></pre></div>
<p>You should play with <code>Ast_pattern</code> a bit if you need to express complex patterns as I think it's
the only way to get the hang of it.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#writing-a-deriver" aria-label="writing a deriver permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Writing a deriver</h3>
<p>Registering a deriver is slightly different from registering an extension but in the end it remains
relatively simple and you will still have to provide the actual implementation in the form of an
<code>expand</code> function.</p>
<p>The typical <code>my_ppx_deriver.ml</code> will look like:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">open</span> <span class="token module variable">Ppxlib</span>

<span class="token keyword">let</span> str_type_decl_generator <span class="token operator">=</span>
  <span class="token module variable">Deriving</span><span class="token punctuation">.</span><span class="token module variable">Generator</span><span class="token punctuation">.</span>make_no_arg
    <span class="token label function">~attributes</span>
    expand_str

<span class="token keyword">let</span> sig_type_decl_generator <span class="token operator">=</span>
  <span class="token module variable">Deriving</span><span class="token punctuation">.</span><span class="token module variable">Generator</span><span class="token punctuation">.</span>make_no_arg
    <span class="token label function">~attributes</span>
    expand_sig

<span class="token keyword">let</span> my_deriver <span class="token operator">=</span>
  <span class="token module variable">Deriving</span><span class="token punctuation">.</span>add
    <span class="token label function">~str_type_decl</span><span class="token punctuation">:</span>str_type_decl_generator
    <span class="token label function">~sig_type_decl</span><span class="token punctuation">:</span>sig_type_decl_generator
    <span class="token string">&quot;my_deriver&quot;</span></code></pre></div>
<p>Which you'll need to compile with the following <code>library</code> stanza:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">(library
 (public_name my_ppx)
 (kind ppx_deriver)
 (libraries ppxlib))</code></pre></div>
<p>The <code>Deriving.add</code> function is declared as:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">val</span> add
  <span class="token punctuation">:</span>  <span class="token operator">?</span>str_type_decl<span class="token punctuation">:</span><span class="token punctuation">(</span>structure<span class="token punctuation">,</span> rec_flag <span class="token operator">*</span> type_declaration list<span class="token punctuation">)</span> <span class="token module variable">Generator</span><span class="token punctuation">.</span>t
  <span class="token operator">-&gt;</span> <span class="token operator">?</span>str_type_ext <span class="token punctuation">:</span><span class="token punctuation">(</span>structure<span class="token punctuation">,</span> type_extension                  <span class="token punctuation">)</span> <span class="token module variable">Generator</span><span class="token punctuation">.</span>t
  <span class="token operator">-&gt;</span> <span class="token operator">?</span>str_exception<span class="token punctuation">:</span><span class="token punctuation">(</span>structure<span class="token punctuation">,</span> extension_constructor           <span class="token punctuation">)</span> <span class="token module variable">Generator</span><span class="token punctuation">.</span>t
  <span class="token operator">-&gt;</span> <span class="token operator">?</span>sig_type_decl<span class="token punctuation">:</span><span class="token punctuation">(</span>signature<span class="token punctuation">,</span> rec_flag <span class="token operator">*</span> type_declaration list<span class="token punctuation">)</span> <span class="token module variable">Generator</span><span class="token punctuation">.</span>t
  <span class="token operator">-&gt;</span> <span class="token operator">?</span>sig_type_ext <span class="token punctuation">:</span><span class="token punctuation">(</span>signature<span class="token punctuation">,</span> type_extension                  <span class="token punctuation">)</span> <span class="token module variable">Generator</span><span class="token punctuation">.</span>t
  <span class="token operator">-&gt;</span> <span class="token operator">?</span>sig_exception<span class="token punctuation">:</span><span class="token punctuation">(</span>signature<span class="token punctuation">,</span> extension_constructor           <span class="token punctuation">)</span> <span class="token module variable">Generator</span><span class="token punctuation">.</span>t
  <span class="token operator">-&gt;</span> <span class="token operator">?</span>extension<span class="token punctuation">:</span><span class="token punctuation">(</span>loc<span class="token punctuation">:</span><span class="token module variable">Location</span><span class="token punctuation">.</span>t <span class="token operator">-&gt;</span> path<span class="token punctuation">:</span>string <span class="token operator">-&gt;</span> core_type <span class="token operator">-&gt;</span> expression<span class="token punctuation">)</span>
  <span class="token operator">-&gt;</span> string
  <span class="token operator">-&gt;</span> t</code></pre></div>
<p>It takes a mandatory string argument, here <code>&quot;my_deriver&quot;</code>, which defines how
user are going to invoke your deriver. In this case we'd need to add a <code>[@@deriving my_deriver]</code> to
a type declaration in a structure or a signature to use it.
Then there's just one optional argument per kind of node to which you can attach a <code>[@@deriving ...]</code>
attribute. <code>type_decl</code> correspond to <code>type = ...</code>, <code>type_ext</code> to <code>type += ...</code> and <code>exception</code> to
<code>exception My_exc of ...</code>.
You need to provide generators for the ones you wish your deriver to handle, <code>ppxlib</code>
will make sure users get a compile error if they try to use it elsewhere.
We can ignore the <code>extension</code> as it's just here for compatibility with <code>ppx_deriving</code>.</p>
<p>Now let's take a look at <code>Generator</code>. Its type is defined as <code>('output_ast, 'input_ast) t</code> where
<code>'input_ast</code> is the type of the node to which the <code>[@@deriving ...]</code> is attached and <code>'output_ast</code>
the type of the nodes it should produce, ie either a <code>structure</code> or a <code>signature</code>. The type of a
generator depends on the expand function it's built from when you use the smart constructor
<code>make_no_arg</code> meaning the expand function should have type
<code>loc: Location.t -&gt; path: string -&gt; 'input_ast -&gt; 'output_ast</code>. This function is the actual
implementation of your deriver and will generate the list of <code>structure_item</code> or <code>signature_item</code>
from the type declaration.</p>
<h4 style="position:relative;"><a href="https://tarides.com/feed.xml#compatibility-with-ppx_import" aria-label="compatibility with ppx_import permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Compatibility with <code>ppx_import</code></h4>
<p><a href="https://github.com/ocaml-ppx/ppx_import"><code>ppx_import</code></a> is a PPX rewriter that lets you import type
definitions and spares you the need to copy and update them every time they change upstream. The
main reason why you would want to do that is because you need to derive values from those types
using a deriver thus the importance of ensuring your deriving plugin is compatible.</p>
<p>Let's take an example to illustrate how <code>ppx_import</code> is used. I'm using a library called <code>blob</code>
which exposes a type <code>Blob.t</code>. For some reason I need to be able to serialize and deserialize
<code>Blob.t</code> values to JSON. I'd like to use a deriver to do that as I don't want to maintain that code
myself. Imagine <code>Blob.t</code> is defined as:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">type</span> t <span class="token operator">=</span>
  <span class="token punctuation">{</span> <span class="token keyword">value</span> <span class="token punctuation">:</span> string
  <span class="token punctuation">;</span> length <span class="token punctuation">:</span> int
  <span class="token punctuation">;</span> id <span class="token punctuation">:</span> int
  <span class="token punctuation">}</span></code></pre></div>
<p>Without <code>ppx_import</code> I would define somewhere a <code>serializable_blob</code> type as follows:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">type</span> serializable_blob <span class="token operator">=</span> <span class="token module variable">Blob</span><span class="token punctuation">.</span>t <span class="token operator">=</span>
  <span class="token punctuation">{</span> <span class="token keyword">value</span> <span class="token punctuation">:</span> string
  <span class="token punctuation">;</span> length <span class="token punctuation">:</span> int
  <span class="token punctuation">;</span> id <span class="token punctuation">:</span> int
  <span class="token punctuation">}</span>
<span class="token punctuation">[</span><span class="token operator">@@</span>deriving yojson<span class="token punctuation">]</span></code></pre></div>
<p>That works well especially because the type definition is simple but I don't really care about
having it here, what I really want is just the <code>to_yojson</code> and <code>of_yojson</code> functions. Also now, if
the type definition changes, I have to update it here manually. Maintaining many such imports can be
tedious and duplicates a lot of code unnecessarily.</p>
<p>What I can do instead, thanks to <code>ppx_import</code> is to write it like this:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">type</span> serializable_blob <span class="token operator">=</span> <span class="token punctuation">[</span><span class="token operator">%</span>import<span class="token punctuation">:</span> <span class="token module variable">Blob</span><span class="token punctuation">.</span>t<span class="token punctuation">]</span>
<span class="token punctuation">[</span><span class="token operator">@@</span>deriving yojson<span class="token punctuation">]</span></code></pre></div>
<p>which will ultimately be expanded into the above using <code>Blob</code>'s definition of the type <code>t</code>.</p>
<p>Now <code>ppx_import</code> works a bit differently from regular PPX rewriters as it needs a bit more information
than just the AST. We don't need to understand how it works but what it means is that if your
deriving plugin is used with <code>ppx_import</code>, it will be called twice:</p>
<ul>
<li>A first time with <code>ocamldep</code>. This is required to determine the dependencies of a module in terms
of other OCaml modules. PPX-es need to be applied here to find out about dependencies they may
introduce.</li>
<li>A second time before actually compiling the code.</li>
</ul>
<p>The issue here is that during the <code>ocamldep</code> pass, <code>ppx_import</code> doesn't have the information it
needs to import the type definition yet so it can't copy it and it expands:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">type</span> u <span class="token operator">=</span> <span class="token punctuation">[</span><span class="token operator">%</span>import A<span class="token punctuation">.</span>t<span class="token punctuation">]</span></code></pre></div>
<p>into:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">type</span> u <span class="token operator">=</span> A<span class="token punctuation">.</span>t</code></pre></div>
<p>Only during the second pass will it actually expand it to the copied type definition.</p>
<p>This may be a concern if your deriving plugin can't apply to abstract types because you will
probably raise an error when encountering one, meaning the first phase will fail and the whole
compilation will fail without giving your rewriter a chance to derive anything from the copied
type definition.</p>
<p>The right way to deal with this is to have different a behaviour in the context of <code>ocamldep</code>.
In this case you can ignore such type declaration or eventually, if you know you are going to
inject new dependencies in your generated code, to create dummy values referencing them and just
behave normally in any other context.</p>
<p><code>ppxlib</code> versions <code>0.6.0</code> and higher allow you to do so through the <code>Deriving.Generator.V2</code> API
which passes an abstract <code>ctxt</code> value to your <code>expand</code> function instead of a <code>loc</code> and a <code>path</code>.
You can tell whether it is the <code>ocamldep</code> pass from within the <code>expand</code> function like this:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">open</span> <span class="token module variable">Ppxlib</span>

<span class="token keyword">let</span> expand <span class="token label function">~ctxt</span> input_ast <span class="token operator">=</span>
  <span class="token keyword">let</span> omp_config <span class="token operator">=</span> <span class="token module variable">Expansion_context</span><span class="token punctuation">.</span><span class="token module variable">Deriver</span><span class="token punctuation">.</span>omp_config ctxt <span class="token keyword">in</span>
  <span class="token keyword">let</span> is_ocamldep_pass <span class="token operator">=</span> <span class="token module variable">String</span><span class="token punctuation">.</span>equal <span class="token string">&quot;ocamldep&quot;</span> omp_config<span class="token punctuation">.</span><span class="token module variable">Migrate_parsetree</span><span class="token punctuation">.</span><span class="token module variable">Driver</span><span class="token punctuation">.</span>tool_name <span class="token keyword">in</span>
  <span class="token punctuation">.</span><span class="token punctuation">.</span><span class="token punctuation">.</span></code></pre></div>
<h4 style="position:relative;"><a href="https://tarides.com/feed.xml#deriver-attributes" aria-label="deriver attributes permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Deriver attributes</h4>
<p>You'll have noted the <code>attributes</code> parameter in the examples. It's an optional parameter that lets
you define which attributes your deriver allows the user to attach to various bits of the type,
type extension or exception declaration it is applied to.</p>
<p><code>ppxlib</code> comes with a <code>Attribute</code> module that lets you to properly declare the attributes you want
to allow and make sure they are properly used: correctly spelled, placed and with the right
payload attached. This is especially useful since attributes are by default ignored by the compiler
meaning without <code>ppxlib</code>'s care, plugin users wouldn't get any errors if they misused an attribute
and it might take them a while to figure out they got it wrong and the generated code wasn't
impacted as they hoped.
The <code>Attribute</code> module offers another great feature: <code>Attribute.t</code> values can be used to extract the
attribute payload from an AST node if it is present. That will spare you the need for
inspecting attributes yourself which can prove quite tedious.</p>
<p><code>Ppxlib.Attribute.t</code> is defined as <code>('context, 'payload) t</code> where <code>'context</code> describes to which node
the attribute can be attached and <code>'payload</code>, the type of its payload.
To build such an attribute you must use <code>Ppxlib.Attribute.declare</code>:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">val</span> declare
  <span class="token punctuation">:</span>  string
  <span class="token operator">-&gt;</span> <span class="token type-variable function">'a</span> <span class="token module variable">Context</span><span class="token punctuation">.</span>t
  <span class="token operator">-&gt;</span> <span class="token punctuation">(</span>payload<span class="token punctuation">,</span> <span class="token type-variable function">'b</span><span class="token punctuation">,</span> <span class="token type-variable function">'c</span><span class="token punctuation">)</span> <span class="token module variable">Ast_pattern</span><span class="token punctuation">.</span>t
  <span class="token operator">-&gt;</span> <span class="token type-variable function">'b</span>
  <span class="token operator">-&gt;</span> <span class="token punctuation">(</span><span class="token type-variable function">'a</span><span class="token punctuation">,</span> <span class="token type-variable function">'c</span><span class="token punctuation">)</span> t</code></pre></div>
<p>Let's try to declare the <code>default</code> argument from <code>ppx_deriving_yojson</code> I mentioned earlier.</p>
<p>The first <code>string</code> argument is the attribute name. <code>ppxlib</code> support namespaces for the attributes so
that users can avoid conflicting attributes between various derivers applied to the same type
definitions. For instance here we could use <code>&quot;default&quot;</code>. It can prove helpful to use more qualified
name such as <code>&quot;ppx_deriving_yojson.of_yojson.default&quot;</code>. That means that our attribute can be used as
<code>[@@default ...]</code>, <code>[@@of_yojson.default ...]</code> or <code>[@@ppx_deriving.of_yojson.default ...]</code>.
Now if another deriver uses a <code>[@@default ...]</code>, users can apply both derivers and provide different
<code>default</code> values to the different derivers by writing:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">type</span> t <span class="token operator">=</span>
  <span class="token punctuation">{</span> a <span class="token punctuation">:</span> int
  <span class="token punctuation">;</span> b <span class="token punctuation">:</span> string <span class="token punctuation">[</span><span class="token operator">@</span>make<span class="token punctuation">.</span>default <span class="token string">&quot;abc&quot;</span><span class="token punctuation">]</span> <span class="token punctuation">[</span><span class="token operator">@</span>of_yojson<span class="token punctuation">.</span>default <span class="token string">&quot;&quot;</span><span class="token punctuation">]</span>
  <span class="token punctuation">}</span>
<span class="token punctuation">[</span><span class="token operator">@@</span>deriving make<span class="token punctuation">,</span>of_yojson<span class="token punctuation">]</span></code></pre></div>
<p>The context argument works very similarly to the one in <code>Extension.declare</code>. Here we want the
attribute to be attached to record field declarations so we'll use
<code>Attribute.Context.label_declaration</code> which has type <code>label_declaration Attribute.Context.t</code>.</p>
<p>The pattern argument is an <code>Ast_pattern.t</code>. Now that we know how to work with those this is pretty
easy. Here we need to accept any expression as a payload since we should be able to apply the
<code>default</code> attribute to any field, regardless of its type and we want to extract that expression from
the payload so we can use it in our deserializer so let's use
<code>Ast_pattern.(single_expr_payload __)</code>.</p>
<p>Finally the last <code>'b</code> argument has the same type as the pattern consumer function. We can use it to
transform what we extracted using the previous <code>Ast_pattern</code> but in this case we just want to
keep the expression as we got it so we'll just use the identity function here.</p>
<p>We end up with the following:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> default_attribute <span class="token operator">=</span>
  <span class="token module variable">Attribute</span><span class="token punctuation">.</span>declare
    <span class="token string">&quot;ppx_deriving_yojson.of_yojson.default&quot;</span>
    <span class="token module variable">Attribute</span><span class="token punctuation">.</span><span class="token module variable">Context</span><span class="token punctuation">.</span>label_declaration
    <span class="token module variable">Ast_pattern</span><span class="token punctuation">.</span><span class="token punctuation">(</span>single_expr_payload __<span class="token punctuation">)</span>
    <span class="token punctuation">(</span><span class="token keyword">fun</span> expr <span class="token operator">-&gt;</span> expr<span class="token punctuation">)</span></code></pre></div>
<p>and that gives us a <code>(label_declaration, expression) Attribute.t</code>.</p>
<p>You can then use it to collect the attribute payload from a label_declaration:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token module variable">Attribute</span><span class="token punctuation">.</span>get default_attribute label_decl</code></pre></div>
<p>which will return <code>Some expr</code> if the attribute was attached to <code>label_decl</code> or <code>None</code> otherwise.</p>
<p>Because of their polymorphic nature, attributes need to be packed, ie to be wrapped with a variant
to hide the type parameter, so if you want to pass it to <code>Generator.make_no_arg</code> you'll have to do
it like this:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> attributes <span class="token operator">=</span> <span class="token punctuation">[</span><span class="token module variable">Attribute</span><span class="token punctuation">.</span>T default_attribute<span class="token punctuation">]</span></code></pre></div>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#writing-your-expand-functions" aria-label="writing your expand functions permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Writing your expand functions</h3>
<p>In the two last sections I mentioned <code>expand</code> functions that would contain the actual <code>deriver</code> or
<code>extension</code> implementation but didn't actually said anything about how to write those. It will
depend a lot on the purpose of your PPX rewriter and what you're trying to achieve.</p>
<p>Before writing your PPX you should clearly specify what it should be applied to and what code it
should produce. That will help you declaring the right deriving or extension rewriter and from there
you'll know the type of the <code>expand</code> functions you have to write which should help.</p>
<p>A good way to proceed is to use the <code>dumpast</code> tool to pretty print the AST fragments of both the
input of your expander and the output, ie the code it should generate. To take a concrete example,
say you want to write a deriving plugin that generates an <code>equal</code> function from a type definition.
You can start by running <code>dumpast</code> on the following file:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">type</span> some_record <span class="token operator">=</span>
  <span class="token punctuation">{</span> a <span class="token punctuation">:</span> int64
  <span class="token punctuation">;</span> b <span class="token punctuation">:</span> string
  <span class="token punctuation">}</span>

<span class="token keyword">let</span> equal_some_record r r' <span class="token operator">=</span> <span class="token module variable">Int64</span><span class="token punctuation">.</span>equal r<span class="token punctuation">.</span>a r'<span class="token punctuation">.</span>a <span class="token operator">&amp;&amp;</span> <span class="token module variable">String</span><span class="token punctuation">.</span>equal r<span class="token punctuation">.</span>b r'<span class="token punctuation">.</span>b</code></pre></div>
<p>That will give you the AST representation of a record type definition and the equal function you
want to write so you can figure out how to deconstruct your expander's input to be able to generate
the right output.</p>
<p><code>ppxlib</code> exposes smart constructors in <code>Ppxlib.Ast_builder.Default</code> to help you build AST fragments
without having to care too much attributes and such fields as well as some convenience constructors
to keep your code concise and readable.</p>
<p>Another convenience tool <code>ppxlib</code> exposes to help you build AST fragments is <code>metaquot</code>. I recently
wrote a bit of documentation about it
<a href="https://ppxlib.readthedocs.io/en/latest/ppx-for-plugin-authors.html#metaquot">here</a> which you
should take a look at but to sum it up <code>metaquot</code> is a PPX extension allowing you to write AST nodes
using the OCaml syntax they describe instead of the AST types.</p>
<h4 style="position:relative;"><a href="https://tarides.com/feed.xml#handling-code-locations-in-a-ppx-rewriter" aria-label="handling code locations in a ppx rewriter permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Handling code locations in a PPX rewriter</h4>
<p>When building AST fragments you should keep in mind that you have to set their <code>location</code>. Locations
are part of the AST values that describes the position of the corresponding node in your source
file, including the file name and the line number and offset of both the beginning and the end the
code bit they represent.</p>
<p>Because your code was generated after the file was parsed, it doesn't have a location so you need to
set it yourself. One could think that it doesn't matter and we could use a dummy location but
locations are used by the compiler to properly report errors and that's why a PPX rewriter should care
about how it locates the generated code as it will help the end user to understand whether the error
comes from their code or generated code and how to eventually fix it.</p>
<p>Both <code>Ast_builder</code> and <code>metaquot</code> expect a location. The first explicitly takes it as a labelled
<code>loc</code> argument while the second relies on a <code>loc</code> value being available in the scope. It is
important to set those with care as errors in the generated code doesn't necessarily mean that your
rewriter is bugged. There are valid cases where your rewriter functioned as intended but the generated
code triggers an error. PPX-es often work on the assumption that some values are available in the
scope, if the user doesn't properly provide those it's their responsibility to fix the error. To
help them do so, it is important to properly locate the generated code to guide them as much as
possible.</p>
<p>When writing extensions, using the whole extension point location for the generated code makes
perfect sense as that's where the code will sit. That's fairly easy as this what <code>ppxlib</code> passes
to the expand function through the <code>loc</code> labelled argument. For deriving plugins it's a bit different
as the generated code doesn't replace an existing part of the parsed AST but generate a new one to insert.
Currently <code>ppxlib</code> gives you the <code>loc</code> of the whole type declaration, extension or exception
declaration your deriving plugin is applied to. Ideally it would be nice to be able to locate the
generated code on the plugin name in the <code>deriving</code> attribute payload, ie here:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">[@@deriving my_plugin,another_plugin]
            ^^^^^^^^^</code></pre></div>
<p>I'm currently working on making that location available to the <code>expand</code> function. In the meantime,
you should choose a convention. I personally locate all the generated code on the
type declaration. Some choose to locate the generated code on the part of the input AST they're
handling when generating it.</p>
<h4 style="position:relative;"><a href="https://tarides.com/feed.xml#reporting-errors-to-your-rewriter-users" aria-label="reporting errors to your rewriter users permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Reporting errors to your rewriter users</h4>
<p>You won't always be able to handle all the AST nodes passed to your expand functions, either because the
end user misused your rewriter or because there are some cases you simply can't deal with.</p>
<p>In those cases you can report the error to the user with <code>Ppxlib.Location.raise_errorf</code>. It works
similarly to <code>printf</code> and you can build your error message from a format string and extra
arguments. It will then raise an exception which will be caught and reported by the compiler.
A good practice is to prefix the error message with the name of your rewriter to help users understand
what's going on, especially with deriving plugin as they might use several of them on the same type
declaration.</p>
<p>Another point to take care of here is, again, locations. <code>raise_errorf</code> takes a labelled <code>loc</code>
arguments. It is used so that your error is reported as any compiler error. Having good locations in
those error messages is just as important as sending clear error messages. Keep in mind that both
the errors you report yourself or errors coming from your generated code will be highlighted by
merlin so when properly set they make it much easier to work with your PPX rewriter.</p>
<h3 style="position:relative;"><a href="https://tarides.com/feed.xml#testing-your-ppx" aria-label="testing your ppx permalink" class="anchor before"><svg aria-hidden="true" focusable="false" height="16" version="1.1" viewbox="0 0 16 16" width="16"><path fill-rule="evenodd" d="M4 9h1v1H4c-1.5 0-3-1.69-3-3.5S2.55 3 4 3h4c1.45 0 3 1.69 3 3.5 0 1.41-.91 2.72-2 3.25V8.59c.58-.45 1-1.27 1-2.09C10 5.22 8.98 4 8 4H4c-.98 0-2 1.22-2 2.5S3 9 4 9zm9-3h-1v1h1c1 0 2 1.22 2 2.5S13.98 12 13 12H9c-.98 0-2-1.22-2-2.5 0-.83.42-1.64 1-2.09V6.25c-1.09.53-2 1.84-2 3.25C6 11.31 7.55 13 9 13h4c1.45 0 3-1.69 3-3.5S14.5 6 13 6z"></path></svg></a>Testing your PPX</h3>
<p>Just as most pieces of code do, a PPX deserves to be tested and it has become easier over the years to
test rewriters.</p>
<p>I personally tend to write as many unit test as possible for my PPX-es internal libraries. I try to
extract helper functions that can easily be unit-tested but I can't test it all that way.
Testing the <code>ast -&gt; ast</code> functions would be tedious as <code>ppxlib</code> and <code>ocaml-migrate-parsetree</code>
don't provide comparison and pretty printing functions that you can use with <code>alcotest</code> or <code>oUnit</code>.
That means you'd have to import the AST types and derive them on your own. That would make a lot
of boiler plate and even if those functions were exposed, writing such tests would be really
tedious. There's a lot of things to take into account. How are you going to build the input AST values
for instance?  If you use <code>metaquot</code>, every node will share the same loc, making it hard to test
that your errors are properly located. If you don't, you will end up with insanely long and
unreadable test code or fixtures.
While that would allow extremely accurate testing for the generated code and errors, it will almost
certainly make your test code unmaintainable, at least given the current tooling.</p>
<p>Don't panic, there is a very good and simple alternative. <code>ppxlib</code> makes it very easy to build a
binary that will parse OCaml code, preprocess the AST with your rewriter and spit it out, formatted as
code again.</p>
<p>You just have to write the following <code>pp.ml</code>:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">=</span> <span class="token module variable">Ppxlib</span><span class="token punctuation">.</span><span class="token module variable">Driver</span><span class="token punctuation">.</span>standalone <span class="token punctuation">(</span><span class="token punctuation">)</span></code></pre></div>
<p>and build the binary with the following <code>dune</code> stanza, assuming your rewriter is called
<code>my_ppx_rewriter</code>:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">(executable
 (name pp)
 (modules pp)
 (libraries my_ppx_rewriter ppxlib))</code></pre></div>
<p>Because we're humans and the OCaml syntax is meant for us to write and read, it makes for much better
test input/output. You can now write your test input in a regular <code>.ml</code> file, use the <code>pp.exe</code>
binary to &quot;apply&quot; your preprocessor to it and compare the output with another <code>.ml</code> file containing
the code you expect it to generate. This kind of test pattern is really well supported by <code>dune</code>
thanks to the <code>diff</code> user action.</p>
<p>I usually have the following files in a <code>rewriter</code>/<code>deriver</code> folder within my test directory:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">test/rewriter/
&#9500;&#9472;&#9472; dune
&#9500;&#9472;&#9472; test.expected.ml
&#9500;&#9472;&#9472; pp.ml
&#9492;&#9472;&#9472; test.ml</code></pre></div>
<p>Where <code>pp.ml</code> is used to produce the rewriter binary, <code>test.ml</code> contains the input OCaml code and
<code>test.expected.ml</code> the result of preprocessing <code>test.ml</code>. The dune file content is generally similar
to this:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">(executable
 (name pp)
 (modules pp)
 (libraries my_ppx_rewriter ppxlib))

(rule
 (targets test.actual.ml)
 (deps (:pp pp.exe) (:input test.ml))
 (action (run ./%{pp} -deriving-keep-w32 both --impl %{input} -o %{targets})))

(alias
 (name runtest)
 (action (diff test.expected.ml test.actual.ml)))

(test
  (name test)
  (modules test)
  (preprocess (pps my_ppx_rewriter)))</code></pre></div>
<p>The first stanza is the one I already introduced above and specifies how to build the rewriter binary.</p>
<p>The <code>rule</code> stanza that comes after that indicates to <code>dune</code> how to produce the actual test output by
applying the rewriter binary to <code>test.ml</code>. You probably noticed the <code>-deriving-keep-w32 both</code> CLI
option passed to <code>pp.exe</code>. By default, <code>ppxlib</code> will generate values or add attributes so that your
generated code doesn't trigger a &quot;Unused value&quot; warning. This is useful in real life situation but
here it will just pollute the test output and make it harder to read so we disable that feature.</p>
<p>The following <code>alias</code> stanza is where all the magic happens. Running <code>dune runtest</code> will now
generate <code>test.actual.ml</code> and compare it to <code>test.expected.ml</code>. It will not only do that but show
you how they differ from each other in a diff format. You can then automatically update
<code>test.expected.ml</code> if you're happy with the results by running <code>dune promote</code>.</p>
<p>Finally the last <code>test</code> stanza is there to ensure that the generated code compiles without type
errors.</p>
<p>This makes a very convenient test setup to write your PPX-es TDD style. You can start by writing an
identity PPX, that will just return its input AST as it is. Then you add some OCaml code using your
soon to be PPX in <code>test.ml</code> and run <code>dune runtest --auto-promote</code> to prefill <code>test.expected.ml</code>.
From there you can start implementing your rewriter and run <code>dune runtest</code> to check on your progress
and update the expected result with <code>dune promote</code>.
Going pure TDD by writing the test works but it's tricky cause you'd have to format your code the
same way <code>pp.exe</code> will format the AST. It would be great to be able to specify how to format
the generated <code>test.actual.ml</code> so that this approach would be more viable and the diff more
readable. Being able to use ocamlformat with a very diff friendly configuration would be great
there. <code>pp.exe</code> seems to offer CLI options to change the code style such as <code>-styler</code> but I haven't
had the chance to experiment with those yet.</p>
<p>Now you can test successful rewriting this way but what about errors? There's a lot of value
ensuring you produce the right errors and on the right code location because that's the kind of
things you can get wrong when refactoring your rewriter code or when people try to contribute.
That isn't as likely to happen if your CI yells when you break the error reporting. So how do we do
that?</p>
<p>Well pretty much the exact same way! We write a file with an erroneous invocation of our rewriter,
run <code>pp.exe</code> on it and compare stderr with what we expect it to be.
There are two major differences here. First we want to collect the stderr output of the rewriter
binary instead of using it to generate a file. The second is that we cant write all of our test
cases in a single file since <code>pp.exe</code> will stop at the first error. That means we need one <code>.ml</code>
file per error test case.
Luckily for us, dune offers ways to do both.</p>
<p>For every error test file we will want to add the following stanzas:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">(rule
  (targets test_error.actual)
  (deps (:pp pp.exe) (:input test_error.ml)) 
  (action
    (with-stderr-to
      %{targets}
      (bash &quot;./%{pp} -no-color --impl %{input} || true&quot;)
    )
  )
)

(alias
  (name runtest)
  (action (diff test_error.expected test_error.actual))
)</code></pre></div>
<p>but obviously we don't want to do that by hand every time we add a new test case so we're gonna need
a script to generate those stanzas and then include them into our <code>dune</code> file using
<code>(include dune.inc)</code>.</p>
<p>To achieve that while keeping things as clean as possible I use the following directory structure:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">test/rewriter/
&#9500;&#9472;&#9472; errors
&#9474;   &#9500;&#9472;&#9472; dune
&#9474;   &#9500;&#9472;&#9472; dune.inc
&#9474;   &#9500;&#9472;&#9472; gen_dune_rules.ml
&#9474;   &#9500;&#9472;&#9472; pp.ml
&#9474;   &#9500;&#9472;&#9472; test_some_error.expected
&#9474;   &#9500;&#9472;&#9472; test_some_error.ml
&#9474;   &#9500;&#9472;&#9472; test_some_other_error.expected
&#9474;   &#9492;&#9472;&#9472; test_some_other_error.ml
&#9500;&#9472;&#9472; dune
&#9500;&#9472;&#9472; test.expected.ml
&#9500;&#9472;&#9472; pp.ml
&#9492;&#9472;&#9472; test.ml</code></pre></div>
<p>Compared to our previous setup, we only added the new <code>errors</code> folder. To keep things simple it has
its own <code>pp.ml</code> copy but in the future I'd like to improve it a bit and be able to use the same
<code>pp.exe</code> binary.</p>
<p>The most important files here are <code>gen_dune_rules.ml</code> and <code>dune.inc</code>. The first is just a simple
OCaml script to generate the above stanzas for each test cases in the <code>errors</code> directory. The second
is the file we'll include in the main <code>dune</code>. It's also the file to which we'll write the generated
stanza.</p>
<p>I personally use the following <code>gen_dune_rules.ml</code>:</p>
<div class="gatsby-highlight" data-language="ocaml"><pre class="language-ocaml"><code class="language-ocaml"><span class="token keyword">let</span> output_stanzas filename <span class="token operator">=</span>
  <span class="token keyword">let</span> base <span class="token operator">=</span> <span class="token module variable">Filename</span><span class="token punctuation">.</span>remove_extension filename <span class="token keyword">in</span>
  <span class="token module variable">Printf</span><span class="token punctuation">.</span>printf
    <span class="token punctuation">{</span><span class="token operator">|</span>
<span class="token punctuation">(</span>library
  <span class="token punctuation">(</span>name <span class="token operator">%</span>s<span class="token punctuation">)</span>
  <span class="token punctuation">(</span>modules <span class="token operator">%</span>s<span class="token punctuation">)</span>
  <span class="token punctuation">(</span>preprocess <span class="token punctuation">(</span>pps ppx_yojson<span class="token punctuation">)</span><span class="token punctuation">)</span>
<span class="token punctuation">)</span>

<span class="token punctuation">(</span>rule
  <span class="token punctuation">(</span>targets <span class="token operator">%</span>s<span class="token punctuation">.</span>actual<span class="token punctuation">)</span>
  <span class="token punctuation">(</span>deps <span class="token punctuation">(</span><span class="token punctuation">:</span>pp pp<span class="token punctuation">.</span>exe<span class="token punctuation">)</span> <span class="token punctuation">(</span><span class="token punctuation">:</span>input <span class="token operator">%</span>s<span class="token punctuation">.</span>ml<span class="token punctuation">)</span><span class="token punctuation">)</span>
  <span class="token punctuation">(</span>action
    <span class="token punctuation">(</span><span class="token keyword">with</span><span class="token operator">-</span>stderr<span class="token operator">-</span><span class="token keyword">to</span>
      <span class="token operator">%%</span><span class="token punctuation">{</span>targets<span class="token punctuation">}</span>
      <span class="token punctuation">(</span>bash <span class="token string">&quot;./%%{pp} -no-color --impl %%{input} || true&quot;</span><span class="token punctuation">)</span>
    <span class="token punctuation">)</span>
  <span class="token punctuation">)</span>
<span class="token punctuation">)</span>

<span class="token punctuation">(</span>alias
  <span class="token punctuation">(</span>name runtest<span class="token punctuation">)</span>
  <span class="token punctuation">(</span>action <span class="token punctuation">(</span>diff <span class="token operator">%</span>s<span class="token punctuation">.</span>expected <span class="token operator">%</span>s<span class="token punctuation">.</span>actual<span class="token punctuation">)</span><span class="token punctuation">)</span>
<span class="token punctuation">)</span>
<span class="token operator">|</span><span class="token punctuation">}</span>
    base
    base
    base
    base
    base
    base

<span class="token keyword">let</span> is_error_test <span class="token operator">=</span> <span class="token keyword">function</span>
  <span class="token operator">|</span> <span class="token string">&quot;pp.ml&quot;</span> <span class="token operator">-&gt;</span> <span class="token boolean">false</span>
  <span class="token operator">|</span> <span class="token string">&quot;gen_dune_rules.ml&quot;</span> <span class="token operator">-&gt;</span> <span class="token boolean">false</span>
  <span class="token operator">|</span> filename <span class="token operator">-&gt;</span> <span class="token module variable">Filename</span><span class="token punctuation">.</span>check_suffix filename <span class="token string">&quot;.ml&quot;</span>

<span class="token keyword">let</span> <span class="token punctuation">(</span><span class="token punctuation">)</span> <span class="token operator">=</span>
  <span class="token module variable">Sys</span><span class="token punctuation">.</span>readdir <span class="token string">&quot;.&quot;</span>
  <span class="token operator">|&gt;</span> <span class="token module variable">Array</span><span class="token punctuation">.</span>to_list
  <span class="token operator">|&gt;</span> <span class="token module variable">List</span><span class="token punctuation">.</span>sort <span class="token module variable">String</span><span class="token punctuation">.</span>compare
  <span class="token operator">|&gt;</span> <span class="token module variable">List</span><span class="token punctuation">.</span>filter is_error_test
  <span class="token operator">|&gt;</span> <span class="token module variable">List</span><span class="token punctuation">.</span>iter output_stanzas</code></pre></div>
<p>Nothing spectacular here, we just build the list of all the <code>.ml</code> files in the directory except
<code>pp.ml</code> and <code>gen_dune_rules.ml</code> itself and then generate the right stanzas for each of them. You'll
note the extra <code>library</code> stanza which I add to get dune to generate the right <code>.merlin</code> so that I
can see the error highlights when I edit the files by hand.</p>
<p>With that we're almost good, add the following to the <code>dune</code> file and you're all set:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">(executable
  (name pp)
  (modules pp)
  (libraries
    ppx_yojson
    ppxlib
  )
)

(include dune.inc)

(executable
  (name gen_dune_rules)
  (modules gen_dune_rules)
)

(rule
  (targets dune.inc.gen)
  (deps
    (:gen gen_dune_rules.exe)
    (source_tree .)
  )
  (action
    (with-stdout-to
      %{targets}
      (run %{gen})
    ) 
  )
)

(alias
  (name runtest)
  (action (diff dune.inc dune.inc.gen))
)</code></pre></div>
<p>The first stanza is here to specify how to build the rewriter binary, same as before, while the
second stanza just tells dune to include the content of <code>dune.inc</code> within this <code>dune</code> file.</p>
<p>The interesting part comes next. As you can guess the <code>executable</code> stanza builds our little OCaml
script into a <code>.exe</code>. The <code>rule</code> that comes after that specifies how to generate the new stanzas
by running <code>gen_dune_rules</code> and capturing its standard output into a <code>dune.inc.gen</code> file.
The last rule allows you to review the changes to the generated stanza and use promotion to accept
them. Once this is done, the new stanzas will be included to the <code>dune</code> file and the test will be
run for every test cases.</p>
<p>Adding a new test case is then pretty easy, you can simply run:</p>
<div class="gatsby-highlight" data-language="text"><pre class="language-text"><code class="language-text">$ touch test/rewriter/errors/some_explicit_test_case_name.{ml,expected} &amp;&amp; dune runtest --auto-promote</code></pre></div>
<p>That will create the new empty test case and update the <code>dune.inc</code> with the corresponding rules.
From there you can proceed the same way as with the successful rewriting tests, update the <code>.ml</code>,
run <code>dune runtest</code> to take a sneak peek at the output and <code>dune promote</code> once you're satisfied with
the result.</p>
<p>I've been pretty happy with this setup so far although there's room for improvement. It would be
nice to avoid duplicating <code>pp.ml</code> for errors testing. This also involves
quite a bit of boilerplate that I have to copy into all my PPX rewriters repositories every time.
Hopefully <a href="https://github.com/ocaml/dune/issues/1855">dune plugins</a> should help with that and I
can't wait for a first version to be released so that I can write a plugin to make this test
pattern more accessible and easier to set up.</p>
