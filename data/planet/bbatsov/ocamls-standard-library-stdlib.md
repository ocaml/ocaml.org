---
title: "OCaml\u2019s Standard Library (`Stdlib`)"
description: "Every programming language comes with some \u201Cbatteries\u201D included
  - mostly in the form of its standard library. That\u2019s typically all of the functionality
  that\u2019s available out-of-the-box, without the need to install additional libraries.
  (although the definition varies from language to language) Usually standard libraries
  are pretty similar, but I think that OCaml\u2019s a bit \u201Cweird\u201D and slightly
  surprising in some regards, so I decided to write down a few thoughts on it and
  how to make the best of it."
url: https://batsov.com/articles/2025/03/14/ocaml-s-standard-library/
date: 2025-03-14T09:18:00-00:00
preview_image: https://batsov.com/assets/images/bozhidar_avatar.jpg
authors:
- Bozhidar Batsov
source:
---

<p>Every programming language comes with some “batteries” included -
mostly in the form of its standard library. That’s typically all
of the functionality that’s available out-of-the-box, without the need
to install additional libraries. (although the definition varies from
language to language) Usually standard libraries are pretty similar,
but I think that OCaml’s a bit “weird” and slightly surprising in some
regards, so I decided to write down a few thoughts on it and how to
make the best of it.</p>

<p>OCaml’s standard library is called <code class="language-plaintext highlighter-rouge">Stdlib</code> and it’s the source of much
“controversy” in the OCaml community. Historically <code class="language-plaintext highlighter-rouge">Stdlib</code> was focused only the
needs of the OCaml compiler (many people called it “the compiler library” for
that reason) and it was very basic when it comes to the functionality that it
provided.  This is part of the reason why libraries like Jane Street’s <code class="language-plaintext highlighter-rouge">Base</code>
and <code class="language-plaintext highlighter-rouge">Core</code> (alternatives to <code class="language-plaintext highlighter-rouge">Stdlib</code>), and <code class="language-plaintext highlighter-rouge">OCaml Containers</code> (complementary
extensions to <code class="language-plaintext highlighter-rouge">Stdlib</code>) become so popular in the OCaml community.</p>

<p>From what I gathered, the compiler authors felt it was the responsibility of the
users of the language to find (or create) the right libraries for their
use-cases and preferred to keep the standard library as lean as possible.  I get
their reasoning, but I think this backfired to some extent, as it’s not
something that many newcomers to a language would expect. The standard library
was definitely a point of surprise and disappointment for me when playing with
OCaml for the first time. I still remember how surprised I was that the book
<a href="https://dev.realworldocaml.org/">Real World OCaml</a> began with the instructions
to replace the built-in standard library with the more full-featured <code class="language-plaintext highlighter-rouge">Base</code> and
<code class="language-plaintext highlighter-rouge">Core</code> libraries. I was used to fairly minimal standard library from my time
with Clojure, but OCaml really outdid Clojure in this regard!</p>

<p>These days, however, I’ve noticed an increased focus on aligning the <code class="language-plaintext highlighter-rouge">Stdlib</code>
functionality with the expectations of most programmers. That’s obvious when you
check the recent OCaml releases, that feature many additions to it:</p>

<ul>
  <li><a href="https://ocaml.org/releases/5.1.0#standard-library">OCaml 5.1</a>: 57 new standard library functions.</li>
  <li><a href="https://ocaml.org/releases/5.2.0#standard-library">OCaml 5.2</a>: Around 20 new functions added to the standard library.</li>
  <li><a href="https://ocaml.org/releases/5.3.0#standard-library">OCaml 5.3</a>: Around 20 new functions in the standard library (in the <code class="language-plaintext highlighter-rouge">Domain</code>, <code class="language-plaintext highlighter-rouge">Dynarray</code>, <code class="language-plaintext highlighter-rouge">Format</code>, <code class="language-plaintext highlighter-rouge">List</code>, <code class="language-plaintext highlighter-rouge">Queue</code>, <code class="language-plaintext highlighter-rouge">Sys</code>, and <code class="language-plaintext highlighter-rouge">Uchar</code> modules).</li>
</ul>

<p>I’ve written about some of those recent additions in the past - e.g. <a href="https://batsov.com/articles/2024/02/23/ocaml-adds-list-take-and-list-drop/"><code class="language-plaintext highlighter-rouge">List.take</code> and
<code class="language-plaintext highlighter-rouge">List.drop</code></a> and I
think they’ll be quite helpful for newcomers to the language.</p>

<p>I think the trend to extend <code class="language-plaintext highlighter-rouge">Stdlib</code> started somewhere around <a href="https://ocaml.org/releases/4.07.0">OCaml
4.07</a> and has accelerated recently.
That probably won’t surprise long-term users of OCaml, as the <code class="language-plaintext highlighter-rouge">Stdlib</code>
module didn’t even exist before. I’ll come back to this topic later in the article.</p>

<h2>Exploring Stdlib</h2>

<p>The <a href="https://ocaml.org/manual/5.3/api/Stdlib.html"><code class="language-plaintext highlighter-rouge">Stdlib</code> module</a> is
automatically opened at the beginning of each compilation. All components of
this module can therefore be referred by their short name, without prefixing
them by <code class="language-plaintext highlighter-rouge">Stdlib</code>.</p>

<p>In particular, it provides the basic operations over the built-in types
(numbers, booleans, byte sequences, strings, exceptions, references, lists,
arrays, input-output channels, …) and the standard library modules.
In OCaml 5.3 <code class="language-plaintext highlighter-rouge">Stdlib</code> consists of the following modules:</p>

<ul>
  <li><code class="language-plaintext highlighter-rouge">Arg</code>: parsing of command line arguments</li>
  <li><code class="language-plaintext highlighter-rouge">Array</code>: array operations</li>
  <li><code class="language-plaintext highlighter-rouge">ArrayLabels</code>: array operations (with labels)</li>
  <li><code class="language-plaintext highlighter-rouge">Atomic</code>: atomic references</li>
  <li><code class="language-plaintext highlighter-rouge">Bigarray</code>: large, multi-dimensional, numerical arrays</li>
  <li><code class="language-plaintext highlighter-rouge">Bool</code>: boolean values</li>
  <li><code class="language-plaintext highlighter-rouge">Buffer</code>: extensible buffers</li>
  <li><code class="language-plaintext highlighter-rouge">Bytes</code>: byte sequences</li>
  <li><code class="language-plaintext highlighter-rouge">BytesLabels</code>: byte sequences (with labels)</li>
  <li><code class="language-plaintext highlighter-rouge">Callback</code>: registering OCaml values with the C runtime</li>
  <li><code class="language-plaintext highlighter-rouge">Char</code>: character operations</li>
  <li><code class="language-plaintext highlighter-rouge">Complex</code>: complex numbers</li>
  <li><code class="language-plaintext highlighter-rouge">Condition</code>: condition variables to synchronize between threads</li>
  <li><code class="language-plaintext highlighter-rouge">Domain</code>: Domain spawn/join and domain local variables</li>
  <li><code class="language-plaintext highlighter-rouge">Digest</code>: MD5 message digest</li>
  <li><code class="language-plaintext highlighter-rouge">Dynarray</code>: Dynamic arrays</li>
  <li><code class="language-plaintext highlighter-rouge">Effect</code>: deep and shallow effect handlers</li>
  <li><code class="language-plaintext highlighter-rouge">Either</code>: either values</li>
  <li><code class="language-plaintext highlighter-rouge">Ephemeron</code>: Ephemerons and weak hash table</li>
  <li><code class="language-plaintext highlighter-rouge">Filename</code>: operations on file names</li>
  <li><code class="language-plaintext highlighter-rouge">Float</code>: floating-point numbers</li>
  <li><code class="language-plaintext highlighter-rouge">Format</code>: pretty printing</li>
  <li><code class="language-plaintext highlighter-rouge">Fun</code>: function values</li>
  <li><code class="language-plaintext highlighter-rouge">Gc</code>: memory management control and statistics; finalized values</li>
  <li><code class="language-plaintext highlighter-rouge">Hashtbl</code>: hash tables and hash functions</li>
  <li><code class="language-plaintext highlighter-rouge">In_channel</code>: input channels</li>
  <li><code class="language-plaintext highlighter-rouge">Int</code>: integers</li>
  <li><code class="language-plaintext highlighter-rouge">Int32</code>: 32-bit integers</li>
  <li><code class="language-plaintext highlighter-rouge">Int64</code>: 64-bit integers</li>
  <li><code class="language-plaintext highlighter-rouge">Lazy</code>: deferred computations</li>
  <li><code class="language-plaintext highlighter-rouge">Lexing</code>: the run-time library for lexers generated by ocamllex</li>
  <li><code class="language-plaintext highlighter-rouge">List</code>: list operations</li>
  <li><code class="language-plaintext highlighter-rouge">ListLabels</code>: list operations (with labels)</li>
  <li><code class="language-plaintext highlighter-rouge">Map</code>: association tables over ordered types</li>
  <li><code class="language-plaintext highlighter-rouge">Marshal</code>: marshaling of data structures</li>
  <li><code class="language-plaintext highlighter-rouge">MoreLabels</code>: include modules Hashtbl, Map and Set with labels</li>
  <li><code class="language-plaintext highlighter-rouge">Mutex</code>: locks for mutual exclusion</li>
  <li><code class="language-plaintext highlighter-rouge">Nativeint</code>: processor-native integers</li>
  <li><code class="language-plaintext highlighter-rouge">Oo</code>: object-oriented extension</li>
  <li><code class="language-plaintext highlighter-rouge">Option</code>: option values</li>
  <li><code class="language-plaintext highlighter-rouge">Out_channel</code>: output channels</li>
  <li><code class="language-plaintext highlighter-rouge">Parsing</code>: the run-time library for parsers generated by ocamlyacc</li>
  <li><code class="language-plaintext highlighter-rouge">Printexc</code>: facilities for printing exceptions</li>
  <li><code class="language-plaintext highlighter-rouge">Printf</code>: formatting printing functions</li>
  <li><code class="language-plaintext highlighter-rouge">Queue</code>: first-in first-out queues</li>
  <li><code class="language-plaintext highlighter-rouge">Random</code>: pseudo-random number generator (PRNG)</li>
  <li><code class="language-plaintext highlighter-rouge">Result</code>: result values</li>
  <li><code class="language-plaintext highlighter-rouge">Scanf</code>: formatted input functions</li>
  <li><code class="language-plaintext highlighter-rouge">Seq</code>: functional iterators</li>
  <li><code class="language-plaintext highlighter-rouge">Set</code>: sets over ordered types</li>
  <li><code class="language-plaintext highlighter-rouge">Semaphore</code>: semaphores, another thread synchronization mechanism</li>
  <li><code class="language-plaintext highlighter-rouge">Stack</code>: last-in first-out stacks</li>
  <li><code class="language-plaintext highlighter-rouge">StdLabels</code>: include modules Array, List and String with labels</li>
  <li><code class="language-plaintext highlighter-rouge">String</code>: string operations</li>
  <li><code class="language-plaintext highlighter-rouge">StringLabels</code>: string operations (with labels)</li>
  <li><code class="language-plaintext highlighter-rouge">Sys</code>: system interface</li>
  <li><code class="language-plaintext highlighter-rouge">Type</code>: type introspection</li>
  <li><code class="language-plaintext highlighter-rouge">Uchar</code>: Unicode characters</li>
  <li><code class="language-plaintext highlighter-rouge">Unit</code>: unit values</li>
  <li><code class="language-plaintext highlighter-rouge">Weak</code>: arrays of weak pointers</li>
</ul>

<p>Lots of good stuff here! Sure, it’s not anything like the standard libraries of
languages like <code class="language-plaintext highlighter-rouge">Ruby</code>, <code class="language-plaintext highlighter-rouge">Python</code> or <code class="language-plaintext highlighter-rouge">Java</code>, but you have the basics covered, at
least to some extent.</p>

<p>Note that unlike the core <code class="language-plaintext highlighter-rouge">Stdlib</code> module, sub-modules are not automatically
“opened” when compilation starts, or when the toplevel system (e.g. <code class="language-plaintext highlighter-rouge">ocaml</code> or
<code class="language-plaintext highlighter-rouge">utop</code>) is launched. Hence it is necessary to use qualified identifiers
(e.g. <code class="language-plaintext highlighter-rouge">List.map</code>) to refer to the functions provided by these modules, or to add
<code class="language-plaintext highlighter-rouge">open</code> directives.</p>

<p>One thing I found somewhat peculiar at first was the presence of two versions of
some standard library modules - e.g. <code class="language-plaintext highlighter-rouge">List</code> and <code class="language-plaintext highlighter-rouge">ListLabels</code>. Both of them have
the same functions, but the <code class="language-plaintext highlighter-rouge">ListLabels</code> module makes heavy use of labeled
parameters. I’m not sure what’s the reasoning behind this, but I’m guessing this
was influenced by the <code class="language-plaintext highlighter-rouge">Base</code> library, that’s using labels everywhere
pervasively. Here are a few examples:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="c">(* Using List module *)</span>
<span class="k">let</span> <span class="n">squares_list</span> <span class="o">=</span> <span class="nn">List</span><span class="p">.</span><span class="n">map</span> <span class="p">(</span><span class="k">fun</span> <span class="n">x</span> <span class="o">-&gt;</span> <span class="n">x</span> <span class="o">*</span> <span class="n">x</span><span class="p">)</span> <span class="p">[</span><span class="mi">1</span><span class="p">;</span> <span class="mi">2</span><span class="p">;</span> <span class="mi">3</span><span class="p">;</span> <span class="mi">4</span><span class="p">;</span> <span class="mi">5</span><span class="p">]</span>
<span class="c">(* Result: [1; 4; 9; 16; 25] *)</span>

<span class="c">(* Using ListLabels module *)</span>
<span class="k">let</span> <span class="n">squares_list_labels</span> <span class="o">=</span> <span class="nn">ListLabels</span><span class="p">.</span><span class="n">map</span> <span class="p">[</span><span class="mi">1</span><span class="p">;</span> <span class="mi">2</span><span class="p">;</span> <span class="mi">3</span><span class="p">;</span> <span class="mi">4</span><span class="p">;</span> <span class="mi">5</span><span class="p">]</span> <span class="o">~</span><span class="n">f</span><span class="o">:</span><span class="p">(</span><span class="k">fun</span> <span class="n">x</span> <span class="o">-&gt;</span> <span class="n">x</span> <span class="o">*</span> <span class="n">x</span><span class="p">)</span>
<span class="c">(* Result: [1; 4; 9; 16; 25] *)</span>

<span class="c">(* Using List module *)</span>
<span class="k">let</span> <span class="n">sum_list</span> <span class="o">=</span> <span class="nn">List</span><span class="p">.</span><span class="n">fold_left</span> <span class="p">(</span><span class="o">+</span><span class="p">)</span> <span class="mi">0</span> <span class="p">[</span><span class="mi">1</span><span class="p">;</span> <span class="mi">2</span><span class="p">;</span> <span class="mi">3</span><span class="p">;</span> <span class="mi">4</span><span class="p">;</span> <span class="mi">5</span><span class="p">]</span>
<span class="c">(* Result: 15 *)</span>

<span class="c">(* Using ListLabels module *)</span>
<span class="k">let</span> <span class="n">sum_list_labels</span> <span class="o">=</span> <span class="nn">ListLabels</span><span class="p">.</span><span class="n">fold_left</span> <span class="p">[</span><span class="mi">1</span><span class="p">;</span> <span class="mi">2</span><span class="p">;</span> <span class="mi">3</span><span class="p">;</span> <span class="mi">4</span><span class="p">;</span> <span class="mi">5</span><span class="p">]</span> <span class="o">~</span><span class="n">init</span><span class="o">:</span><span class="mi">0</span> <span class="o">~</span><span class="n">f</span><span class="o">:</span><span class="p">(</span><span class="o">+</span><span class="p">)</span>
<span class="c">(* Result: 15 *)</span>
</code></pre></div></div>

<p>The labeled arguments in <code class="language-plaintext highlighter-rouge">ListLabels</code> make it clear what each parameter means -
e.g. <code class="language-plaintext highlighter-rouge">~init</code> for the initial value and <code class="language-plaintext highlighter-rouge">~f</code> for the folding function. I’m not
sure how I feel about labeled arguments in general, as in most cases I don’t
think they are really needed, but you’ve got the option if you want it.</p>

<p>One notable omission from <code class="language-plaintext highlighter-rouge">Stdlib</code> is some module for dealing with regular
expressions. OCaml bundles the (controversial)
<a href="https://ocaml.org/manual/5.3/libstr.html">str</a> module, but it’s not part of
<code class="language-plaintext highlighter-rouge">Stdlib</code> and you have to link it to your applications manually:</p>

<div class="language-shell highlighter-rouge"><div class="highlight"><pre class="highlight"><code>ocamlc other options <span class="nt">-I</span> +str str.cma other files
ocamlopt other options  <span class="nt">-I</span> +str str.cmxa other files
</code></pre></div></div>

<p>Not to mention that you probably want to use something different instead. (e.g. <code class="language-plaintext highlighter-rouge">re</code>)</p>

<p><strong>Note:</strong> The <a href="https://ocaml.org/manual/5.3/stdlib.html">documentation of
<code class="language-plaintext highlighter-rouge">Stdlib</code></a> is excellent and I highly
recommend everyone to peruse it.</p>

<h2><code class="language-plaintext highlighter-rouge">Base</code> or <code class="language-plaintext highlighter-rouge">Stdlib</code>?</h2>

<p>A lot of people might be wondering whether to use Jane Street’s standard library
<code class="language-plaintext highlighter-rouge">Base</code> or <code class="language-plaintext highlighter-rouge">Stdlib</code>?  I’m guessing there was a time when <code class="language-plaintext highlighter-rouge">Base</code> offered bigger
advantages over <code class="language-plaintext highlighter-rouge">Stdlib</code>, but today it’s harder to recommend <code class="language-plaintext highlighter-rouge">Base</code> over
<code class="language-plaintext highlighter-rouge">Stdlib</code>. Especially when you factor in the library <a href="https://github.com/c-cube/ocaml-containers">OCaml
Containers</a> which provides numerous
extensions to <code class="language-plaintext highlighter-rouge">Stdlib</code>.</p>

<p>My advice for most newcomers would be to start with <code class="language-plaintext highlighter-rouge">Stdlib</code> and mix in Containers if
needed. If you deem they are not enough for you - feel free to explore <code class="language-plaintext highlighter-rouge">Base</code> at this point.</p>

<p>I think <code class="language-plaintext highlighter-rouge">Base</code> (and <code class="language-plaintext highlighter-rouge">Core</code>) are excellent and battle-tested libraries, but I still think
it’s a good idea for everyone to be familiar with OCaml’s “native” standard library. And for
all of us to be pushing to make it better, of course.</p>

<h2>A note about the core library</h2>

<p>Sometimes you might hear mentions of OCaml’s “core library” (not to be confused
with <code class="language-plaintext highlighter-rouge">Core</code> by Jane Street) and you might wonder what’s that exactly.</p>

<p>Well, the “core library” is composed of declarations for built-in types and
exceptions, plus the module Stdlib that provides basic operations on these
built-in types.</p>

<p>You can learn more about the core library <a href="https://ocaml.org/manual/5.3/core.html">here</a>.</p>

<h2>A note about <code class="language-plaintext highlighter-rouge">Pervasives</code></h2>

<p>Early on in my OCaml journey I’d find references here and there to a library
named <code class="language-plaintext highlighter-rouge">Pervasives</code>, that sounded more or less like a standard library.
Turns out that <code class="language-plaintext highlighter-rouge">Pervasives</code> got renamed to <code class="language-plaintext highlighter-rouge">Stdlib</code> in OCaml 4.07. Here are a few highlights
from the release notes of this quite important release:</p>

<ul>
  <li>The standard library is now packed into a module called <code class="language-plaintext highlighter-rouge">Stdlib</code>, which is
open by default. This makes it easier to add new modules to the standard
library without clashing with user-defined modules.</li>
  <li>The <code class="language-plaintext highlighter-rouge">Bigarray</code> module is now part of the standard library.</li>
  <li>The modules <code class="language-plaintext highlighter-rouge">Seq</code>, <code class="language-plaintext highlighter-rouge">Float</code> were added to the standard library.</li>
</ul>

<p>I know <code class="language-plaintext highlighter-rouge">Pervasives</code> was kept around for a while for backwards compatibility and it seems it’s no
longer present in OCaml 5.x.</p>

<h2>Epilogue</h2>

<p>OCaml’s <code class="language-plaintext highlighter-rouge">Stdlib</code> is often cited as a reason why the language is not popular, and
I think that’s a valid argument. Still, it seems to me that lately <code class="language-plaintext highlighter-rouge">Stdlib</code> has
been moving in the right direction, and the out-of-the-box OCaml experience got
improved because of this. I can only hope that this trend will continue and that
as a result OCaml will become more beginner-friendly and more useful out-of-the-box.</p>

<p>What improvements would you like to see there going forward?</p>

<p>That’s all I have for you today. Keep hacking!</p>
