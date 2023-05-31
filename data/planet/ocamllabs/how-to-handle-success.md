---
title: How to handle success
description:
url: http://ocamllabs.github.com/compiler-hacking/2014/02/04/handler-case
date: 2014-02-04T16:05:05-00:00
preview_image:
featured:
authors:
- ocamllabs
---

<p>(Update (2014-05-28): Added notes on <a href="http://ocamllabs.io/compiler-hacking/rss.xml#delimcc">delimcc</a> and <a href="http://ocamllabs.io/compiler-hacking/rss.xml#catch-me">Catch me if you can</a> to the <em>Discoveries</em> section.)</p>

<p>(Update (2014-05-05): The <a href="http://ocamllabs.io/compiler-hacking/rss.xml#match-exception"><code>match/exception</code></a> variant of this proposal has been <a href="https://github.com/ocaml/ocaml/commit/0f1fb19cbe48918c5d070e475c39052875623a85">merged into OCaml trunk</a>, ready for release in 4.02.)</p>

<p>(Update: there's a <a href="http://caml.inria.fr/mantis/view.php?id=6318">Mantis issue open</a> to discuss this proposal.)</p>

<p>OCaml's <code>try</code> construct is good at dealing with exceptions, but not so good at handling the case where no exception is raised.  This post describes a simple extension to <code>try</code> that adds support for handling the &quot;success&quot; case.</p>

<p>Here's an example of code that benefits from the extension.  On a recent <a href="http://caml.inria.fr/resources/forums.en.html">caml-list</a> thread, <a href="http://cedeela.fr/~simon/">Simon Cruanes</a> posted <a href="https://sympa.inria.fr/sympa/arc/caml-list/2014-01/msg00113.html">the following function</a> for iterating over a stream:</p>

<blockquote>
<div class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span></span><span class="k">let</span> <span class="k">rec</span> <span class="n">iter_stream</span> <span class="n">f</span> <span class="n">s</span> <span class="o">=</span>
  <span class="k">match</span> <span class="o">(</span><span class="k">try</span> <span class="nc">Some</span> <span class="o">(</span><span class="nn">MyStream</span><span class="p">.</span><span class="n">get</span> <span class="n">s</span><span class="o">)</span> <span class="k">with</span> <span class="nc">End_of_stream</span> <span class="o">-&gt;</span> <span class="nc">None</span><span class="o">)</span> <span class="k">with</span>
  <span class="o">|</span> <span class="nc">None</span> <span class="o">-&gt;</span> <span class="bp">()</span>
  <span class="o">|</span> <span class="nc">Some</span> <span class="o">(</span><span class="n">x</span><span class="o">,</span> <span class="n">s'</span><span class="o">)</span> <span class="o">-&gt;</span>
      <span class="n">f</span> <span class="n">x</span><span class="o">;</span>
      <span class="n">iter_stream</span> <span class="n">f</span> <span class="n">s'</span>
</code></pre></div></blockquote>

<p>For each element of a stream, <code>iter_stream</code> wraps the element with <code>Some</code>, then unwraps it again and passes it to <code>f</code>.  At first glance, wrapping and immediately unwrapping in this way seems like needless obfuscation.  However, moving the last two lines out of the body of the <code>try</code> in this way serves two essential purposes: it turns the recursive call to <code>iter_stream</code> into a tail call, and it allows exceptions raised by <code>f</code> to propagate.  More generally, this use of options makes it easy to specify the <em>success continuation</em> of a <code>try</code> expression, i.e. the piece of code that receives the value of the body when no exception is raised.</p>

<p>As Simon notes, the <code>match (try Some ...)</code> idiom is widely used in OCaml code.  Examples can be found in the source of <a href="https://github.com/ocsigen/lwt/blob/b63b2a/src/unix/lwt_unix.ml#L118-L125">lwt</a>, <a href="https://github.com/ocaml-batteries-team/batteries-included/blob/92ea390c/benchsuite/bench_nreplace.ml#L45-L48">batteries</a>, <a href="https://github.com/savonet/liquidsoap/blob/a81cd8b6/src/decoder/metadata_decoder.ml#L53-L55">liquidsoap</a>, <a href="https://github.com/janestreet/sexplib/blob/f9bd413/lib/conv.ml#L256-L259">sexplib</a>, <a href="https://github.com/MLstate/opalang/blob/0802728/compiler/opalang/opaParser.ml#L127-L135">opa</a>, <a href="https://github.com/avsm/ocaml-uri/blob/35af64db/lib/uri.ml#L250-L255">uri</a>, <a href="https://github.com/coq/coq/blob/724c9c9f/tools/coqdoc/tokens.ml#L36-L41">coq</a>, <a href="https://github.com/pascal-bach/Unison/blob/4788644/src/ubase/prefs.ml#L97-L106">unison</a>, and many other packages.  </p>

<p>In response to Simon's message, <a href="http://okmij.org/ftp">Oleg</a> pointed out <a href="https://sympa.inria.fr/sympa/arc/caml-list/2014-01/msg00146.html">a solution</a>: the 2001 paper <a href="http://research.microsoft.com/~akenn/sml/exceptionalsyntax.pdf">Exceptional Syntax</a>  (<a href="http://research.microsoft.com/~nick/">Benton</a> and <a href="http://research.microsoft.com/~akenn/">Kennedy</a>) extends <code>try</code> with a <code>let</code>-like binding construct that supports the success continuation idiom directly without the need for the option value.</p>



<p>This post describes a patch to OCaml that implements a variant of Benton and Kennedy's design called <em>handler case</em>.  Like Exceptional Syntax, handler case extends <code>try</code> with explicit success continuation handling.  However, unlike Exceptional syntax, handler case uses <code>match</code> binding for both the success continuation and the exception-handling clauses.  Here's the extended <code>try</code> syntax:</p>
<div class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span></span><span class="k">try</span> <span class="n">expr</span>
<span class="k">with</span> <span class="n">pattern_1</span> <span class="o">-&gt;</span> <span class="n">expr_1</span>
   <span class="o">|</span> <span class="o">...</span>
   <span class="o">|</span> <span class="n">pattern_n</span> <span class="o">-&gt;</span> <span class="n">expr_n</span>
   <span class="o">|</span> <span class="k">val</span> <span class="n">pattern_1'</span> <span class="o">-&gt;</span> <span class="n">expr_1'</span>
   <span class="o">|</span> <span class="o">...</span>
   <span class="o">|</span> <span class="k">val</span> <span class="n">pattern_n'</span> <span class="o">-&gt;</span> <span class="n">expr_n'</span>
</code></pre></div>
<p>As in <a href="http://caml.inria.fr/pub/docs/manual-ocaml-4.00/expr.html#@manual.kwd50">current OCaml</a>, the clauses <code>pattern_1 -&gt; expr_1</code> ... <code>pattern_n -&gt; expr_n</code> handle exceptions raised during the evaluation of <code>expr</code>.  The clauses  <code>val pattern_1' -&gt; expr_1'</code> ... <code>val pattern_n' -&gt; expr_n'</code> handle the case where no exception is raised; in this case the value of <code>expr</code> is matched against <code>pattern_1'</code> ... <code>pattern_n'</code> to select the expression to evaluate to produce the result value.  (The actual syntax is implemented slightly more permissively: it allows value-matching and exception-matching clauses to be freely interleaved.)</p>

<p>Using handler case we can rewrite <code>iter_stream</code> to remove the extraneous option value:</p>
<div class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span></span><span class="k">let</span> <span class="k">rec</span> <span class="n">iter_stream</span> <span class="n">f</span> <span class="n">s</span> <span class="o">=</span>
  <span class="k">try</span> <span class="nn">MyStream</span><span class="p">.</span><span class="n">get</span> <span class="n">s</span>
  <span class="k">with</span> <span class="nc">End_of_stream</span> <span class="o">-&gt;</span> <span class="bp">()</span>
     <span class="o">|</span> <span class="k">val</span> <span class="o">(</span><span class="n">x</span><span class="o">,</span> <span class="n">s'</span><span class="o">)</span> <span class="o">-&gt;</span> <span class="n">f</span> <span class="n">x</span><span class="o">;</span>
                      <span class="n">iter_stream</span> <span class="n">f</span> <span class="n">s'</span>
</code></pre></div>
<p>We don't need to look far to find other code that benefits from the new construct.  Here's a function from the <a href="https://github.com/ocaml/ocaml/blob/6a296a02/otherlibs/num/big_int.ml#L323-L328">Big_int</a> module in the standard library: </p>
<div class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span></span><span class="k">let</span> <span class="n">int_of_big_int</span> <span class="n">bi</span> <span class="o">=</span>
  <span class="k">try</span> <span class="k">let</span> <span class="n">n</span> <span class="o">=</span> <span class="n">int_of_nat</span> <span class="n">bi</span><span class="o">.</span><span class="n">abs_value</span> <span class="k">in</span>
    <span class="k">if</span> <span class="n">bi</span><span class="o">.</span><span class="n">sign</span> <span class="o">=</span> <span class="o">-</span><span class="mi">1</span> <span class="k">then</span> <span class="o">-</span> <span class="n">n</span> <span class="k">else</span> <span class="n">n</span>
  <span class="k">with</span> <span class="nc">Failure</span> <span class="o">_</span> <span class="o">-&gt;</span>
    <span class="k">if</span> <span class="n">eq_big_int</span> <span class="n">bi</span> <span class="n">monster_big_int</span> <span class="k">then</span> <span class="n">monster_int</span>
    <span class="k">else</span> <span class="n">failwith</span> <span class="s2">&quot;int_of_big_int&quot;</span>
</code></pre></div>
<p>The core of the function --- the call to <code>int_of_nat</code> --- is rather buried in the complex control flow.  There are two <code>if</code>-<code>then</code>-<code>else</code> constructs, a <code>let</code> binding, and a <code>try</code> expression with a complex body.  Using handler case we can disentangle the code to make the four possible outcomes from the call to <code>int_of_nat</code> explicit:</p>
<div class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span></span><span class="k">let</span> <span class="n">int_of_big_int</span> <span class="n">bi</span> <span class="o">=</span>
  <span class="k">try</span> <span class="n">int_of_nat</span> <span class="n">bi</span><span class="o">.</span><span class="n">abs_value</span> <span class="k">with</span>
  <span class="o">|</span> <span class="k">val</span> <span class="n">n</span> <span class="k">when</span> <span class="n">bi</span><span class="o">.</span><span class="n">sign</span> <span class="o">=</span> <span class="o">-</span><span class="mi">1</span> <span class="o">-&gt;</span>
     <span class="o">-</span><span class="n">n</span>
  <span class="o">|</span> <span class="k">val</span> <span class="n">n</span> <span class="o">-&gt;</span>
     <span class="n">n</span>
  <span class="o">|</span> <span class="nc">Failure</span> <span class="o">_</span> <span class="k">when</span> <span class="n">eq_big_int</span> <span class="n">bi</span> <span class="n">monster_big_int</span> <span class="o">-&gt;</span>
     <span class="n">monster_int</span>
  <span class="o">|</span> <span class="nc">Failure</span> <span class="o">_</span> <span class="o">-&gt;</span>
     <span class="n">failwith</span> <span class="s2">&quot;int_of_big_int&quot;</span>
</code></pre></div>
<p>Here's a simpler example from <a href="https://github.com/ocaml/ocaml/blob/6a296a02/stdlib/string.ml#L195">the String module</a>, which also involves code that cannot raise an exception in the body of a <code>try</code> block:</p>
<div class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span></span><span class="k">try</span> <span class="n">ignore</span> <span class="o">(</span><span class="n">index_rec</span> <span class="n">s</span> <span class="n">l</span> <span class="n">i</span> <span class="n">c</span><span class="o">);</span> <span class="bp">true</span> <span class="k">with</span> <span class="nc">Not_found</span> <span class="o">-&gt;</span> <span class="bp">false</span>
</code></pre></div>
<p>Using handler case we can separate the code that may raise an exception (the call to <code>index_rec</code>) from the expression that produces the result:</p>
<div class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span></span><span class="k">try</span> <span class="n">index_rec</span> <span class="n">s</span> <span class="n">l</span> <span class="n">i</span> <span class="n">c</span> <span class="k">with</span> <span class="k">val</span> <span class="o">_</span> <span class="o">-&gt;</span> <span class="bp">true</span> <span class="o">|</span> <span class="nc">Not_found</span> <span class="o">-&gt;</span> <span class="bp">false</span>
</code></pre></div>
<h3>Trying it out</h3>

<p>Using <a href="http://opam.ocaml.org/">opam</a> you can install an OCaml compiler extended with handler case as follows:</p>
<div class="highlight"><pre><code class="language-text" data-lang="text"><span></span>$ opam remote add ocamllabs git@github.com:ocamllabs/opam-repo-dev.git
ocamllabs Fetching git@github.com:ocamllabs/opam-repo-dev.git
[...]
$ opam switch 4.02.0dev+handler-syntax
# To complete the configuration of OPAM, you need to run:
eval `opam config env`
$ eval `opam config env`
</code></pre></div>
<h4>js<em>of</em>ocaml</h4>

<p>You can also try out the handler case construct in your browser, using the following modified version of <a href="http://www.ocamlpro.com/">OCamlPro</a>'s <a href="http://try.ocamlpro.com/">Try OCaml</a> application:</p>

<h3>The discoveries of success continuations</h3>

<p>As <a href="http://homepages.inf.ed.ac.uk/wadler">Philip Wadler</a> <a href="http://wadler.blogspot.co.uk/2008/02/great-minds-think-alike.html">notes</a>, constructs for handling success continuations have been independently discovered multiple times.  In fact, the history goes back even further than described in Wadler's blog; constructs like handler case date back over thirty years and have been introduced, apparently independently, into at least four languages.  Curiously, all the languages use <code>let</code>-binding for success continuations and <code>match</code> binding for failure continuations.</p>

<h4>Lisp</h4>

<p>In <a href="http://www.lispworks.com/documentation/HyperSpec/Front/">Common Lisp</a> the construct analogous to <code>try</code> is <a href="http://clhs.lisp.se/Body/m_hand_1.htm"><code>handler-case</code></a> (from which the construct discussed here borrows its name).  A <code>handler-case</code> expression has a body and a sequence of clauses which specify how various conditions (exceptions) should be handled.  The special condition specification <code>:no-error</code> specifies the code to run when no condition is signalled.  The <code>iter_stream</code> function might be written as follows in Common Lisp:</p>
<div class="highlight"><pre><code class="language-common-lisp" data-lang="common-lisp"><span></span><span class="p">(</span><span class="nb">defun</span> <span class="nv">iter-stream</span> <span class="p">(</span><span class="nv">f</span> <span class="nv">s</span><span class="p">)</span>
   <span class="p">(</span><span class="nb">handler-case</span> <span class="p">(</span><span class="nv">get-stream</span> <span class="nv">s</span><span class="p">)</span>
      <span class="p">(</span><span class="nv">end-of-stream</span> <span class="p">(</span><span class="nv">_</span><span class="p">)</span> <span class="no">nil</span><span class="p">)</span>
      <span class="p">(</span><span class="ss">:no-error</span> <span class="p">(</span><span class="nv">x</span> <span class="nv">|s'|</span><span class="p">)</span>
         <span class="p">(</span><span class="nb">funcall</span> <span class="nv">f</span> <span class="nv">x</span><span class="p">)</span>
         <span class="p">(</span><span class="nv">iter-stream</span> <span class="nv">f</span> <span class="nv">|s'|</span><span class="p">))))</span>
</code></pre></div>
<p>The Common Lisp specification was completed in 1994 but the <code>handler-case</code> construct and its <code>:no-error</code> clause were present in some of Common Lisp's progenitors.  The construct was apparently introduced to Symbolics Lisp some time around 1982: it appears in the <a href="http://bitsavers.informatik.uni-stuttgart.de/pdf/mit/cadr/chinual_5thEd_Jan83/chinualJan83_27_Errors.pdf">5th edition</a> of the Lisp Machine manual (January 1983) but not the <a href="http://bitsavers.trailing-edge.com/pdf/mit/cadr/chinual_4thEd_Jul81.pdf">4th edition</a> from 18 months earlier (July 1981).</p>

<h4>Python</h4>

<p>Python has supported success continuations in exception handlers since May 1994, when the <code>else</code> clause was added to <code>try</code> blocks.  The <a href="http://hg.python.org/cpython/file/36214c861144/Grammar/Grammar#l9">Changelog in old versions of the Grammar/Grammar file</a> has an entry</p>

<blockquote>
<div class="highlight"><pre><code class="language-text" data-lang="text"><span></span># 3-May-94:
#Added else clause to try-except
</code></pre></div></blockquote>

<p>introduced in a <a href="http://hg.python.org/cpython/rev/6c0e11b94009">commit from August 1994</a>:</p>

<blockquote>
<div class="highlight"><pre><code class="language-text" data-lang="text"><span></span>changeset:   1744:6c0e11b94009
branch:      legacy-trunk
user:        Guido van Rossum &lt;guido@python.org&gt;
date:        Mon Aug 01 11:00:20 1994 +0000
summary:     Bring alpha100 revision back to mainline
</code></pre></div></blockquote>

<p>Unlike the <code>:no-error</code> clause in Lisp's <code>handler-case</code>, Python's <code>else</code> clause doesn't bind variables.  Since Python variables have function scope, not block scope, bindings in the body of the try block are visible throughout the function.  In Python we might write <code>iter_stream</code> as follows:</p>
<div class="highlight"><pre><code class="language-python" data-lang="python"><span></span><span class="k">def</span> <span class="nf">iter_stream</span><span class="p">(</span><span class="n">f</span><span class="p">,</span> <span class="n">s</span><span class="p">):</span>
   <span class="k">try</span><span class="p">:</span>
      <span class="p">(</span><span class="n">x</span><span class="p">,</span> <span class="n">s_</span><span class="p">)</span> <span class="o">=</span> <span class="n">MyStream</span><span class="o">.</span><span class="n">get</span><span class="p">(</span><span class="n">s</span><span class="p">)</span>
   <span class="k">except</span> <span class="n">End_of_stream</span><span class="p">:</span>
      <span class="k">pass</span>
   <span class="k">else</span><span class="p">:</span>
      <span class="n">f</span><span class="p">(</span><span class="n">x</span><span class="p">)</span>
      <span class="n">iter_stream</span><span class="p">(</span><span class="n">f</span><span class="p">,</span> <span class="n">s_</span><span class="p">)</span>
</code></pre></div>
<p>The provenance of the <code>else</code> clause is unclear, but it doesn't seem to derive from Lisp's <code>handler-case</code>.  The design of Python's exception handling constructs <a href="http://docs.python.org/3/faq/general.html#why-was-python-created-in-the-first-place">comes from Modula-3</a>, but the exception handling construct described in the <a href="http://www.hpl.hp.com/techreports/Compaq-DEC/SRC-RR-52.pdf">Modula-3 report</a> does not include a way of specifying the success continuation.  The syntax of the Modula-3 <code>TRY</code>/<code>EXCEPT</code> statement (found on p21 of the report) does include an <code>ELSE</code> clause:</p>
<div class="highlight"><pre><code class="language-text" data-lang="text"><span></span>   TRY    
     Body
   EXCEPT
     id1 (v1) =&gt; Handler1
   | ...
   | idn (vn) =&gt; Handlern
   ELSE Handler0
   END
</code></pre></div>
<p>However, whereas Python's <code>else</code> handles the case where no exception is raised, Modula-3's <code>ELSE</code> handles the case where an exception not named in one of the <code>EXCEPT</code> clauses is raised: it is equivalent to Python's catch-all <code>except:</code>.</p>

<p>Python also adds success handlers to other constructs.  Both the <a href="http://docs.python.org/2/reference/compound_stmts.html#the-for-statement"><code>for</code></a> and the <a href="http://docs.python.org/2/reference/compound_stmts.html#the-while-statement"><code>while</code></a> statements have an optional <code>else</code> clause which is executed unless the loop terminates prematurely with an exception or <code>break</code>.</p>

<p><a name="exceptional-syntax"></a></p>

<h4>Exceptional Syntax</h4>

<p>The 2001 paper <a href="http://research.microsoft.com/~akenn/sml/exceptionalsyntax.pdf">Exceptional Syntax</a> (<a href="http://research.microsoft.com/~nick/">Benton</a> and <a href="http://research.microsoft.com/~akenn/">Kennedy</a>) proposed the following construct for handling exceptions in Standard ML:</p>
<div class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span></span><span class="k">let</span> <span class="k">val</span> <span class="n">pattern_1</span> <span class="o">&lt;=</span> <span class="n">expr_1</span>
    <span class="o">...</span>
    <span class="k">val</span> <span class="n">pattern_n</span> <span class="o">&lt;=</span> <span class="n">expr_n</span>
 <span class="k">in</span>
    <span class="n">expr</span>
<span class="n">unless</span>
    <span class="n">pattern_1'</span> <span class="o">=&gt;</span> <span class="n">expr_1'</span>
  <span class="o">|</span> <span class="o">...</span>
  <span class="o">|</span> <span class="n">pattern_n'</span> <span class="o">=&gt;</span> <span class="n">expr_n'</span>
<span class="k">end</span>
</code></pre></div>
<p>Evaluation of the <code>let</code> binding proceeds as normal, except that if any of <code>expr_1</code> to <code>expr_n</code> raises an exception, control is transferred to the right hand side of the first of the clauses after <code>unless</code> whose left hand side matches the exception.  The construct is largely similar to our proposed variation, except that the bindings used in the success continuation are based on <code>let</code>, so scrutinising the values requires a separate <code>case</code> (i.e. <code>match</code>) expression.</p>

<p>Using the Exceptional Syntax construct we might write <code>iter_stream</code> as follows:</p>
<div class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span></span><span class="k">fun</span> <span class="n">iter_stream</span> <span class="n">f</span> <span class="n">s</span> <span class="o">=</span>
 <span class="k">let</span> <span class="k">val</span> <span class="o">(</span><span class="n">x</span><span class="o">,</span> <span class="n">s'</span><span class="o">)</span> <span class="o">&lt;=</span> <span class="nn">MyStream</span><span class="p">.</span><span class="n">get</span> <span class="n">s</span> <span class="k">in</span>
     <span class="n">f</span> <span class="n">x</span><span class="o">;</span>
     <span class="n">iter_stream</span> <span class="n">f</span> <span class="n">s'</span>
 <span class="n">unless</span> <span class="nc">End_of_stream</span> <span class="o">=&gt;</span> <span class="bp">()</span>
 <span class="k">end</span>
</code></pre></div>
<p>Exceptional Syntax has been implemented in the SML-to-Java compiler <a href="http://www.dcs.ed.ac.uk/home/mlj/">MLj</a>.</p>

<h4>Erlang</h4>

<p>The 2004 paper <a href="http://erlang.se/workshop/2004/exception.pdf">Erlang's Exception Handling Revisited</a> (Richard Carlsson, Bj&ouml;rn Gustavsson and Patrik Nyblom) proposed an exception-handling construct for Erlang along the same lines as exceptional syntax, although apparently developed independently.  In the proposed extension to Erlang we might write <code>iter_stream</code> as follows:</p>
<div class="highlight"><pre><code class="language-erlang" data-lang="erlang"><span></span><span class="nf">iter_stream</span><span class="p">(</span><span class="nv">F</span><span class="p">,</span> <span class="nv">S</span><span class="p">)</span> <span class="o">-&gt;</span>
   <span class="k">try</span> <span class="nv">Mystream</span><span class="p">:</span><span class="nb">get</span><span class="p">(</span><span class="nv">S</span><span class="p">)</span> <span class="k">of</span>
      <span class="p">{</span><span class="nv">X</span><span class="p">,</span> <span class="nv">S_</span><span class="p">}</span> <span class="o">-&gt;</span>
        <span class="p">_</span> <span class="o">=</span> <span class="nv">F</span><span class="p">(</span><span class="nv">X</span><span class="p">),</span>
        <span class="n">iter_stream</span><span class="p">(</span><span class="nv">F</span><span class="p">,</span> <span class="nv">S_</span><span class="p">)</span>
   <span class="n">with</span>
    <span class="nv">End_of_stream</span> <span class="o">-&gt;</span> <span class="p">{}</span>
</code></pre></div>
<h4>Eff</h4>

<p><a href="http://homepages.inf.ed.ac.uk/gdp/">Plotkin</a> and <a href="http://matija.pretnar.info/">Pretnar</a>'s work on <a href="http://matija.pretnar.info/pdf/handling-algebraic-effects.pdf">handlers for algebraic effects</a> generalises Exceptional Syntax to support effects other than exceptions.  The programming language <a href="http://math.andrej.com/eff/">eff</a> implements a design based on this work, and supports Exceptional Syntax, again with <code>let</code> binding for the success continuation.  (Although the success continuation is incorporated into the exception matching construct, only a single success continuation pattern is allowed.)  In eff we might write <code>iter_stream</code> as follows:</p>
<div class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span></span><span class="k">let</span> <span class="k">rec</span> <span class="n">iter_stream</span> <span class="n">f</span> <span class="n">s</span> <span class="o">=</span>
  <span class="n">handle</span> <span class="n">my_stream_get</span> <span class="n">s</span>
  <span class="k">with</span> <span class="n">exn</span><span class="o">#</span><span class="n">end_of_stream</span> <span class="o">_</span> <span class="o">_</span> <span class="o">-&gt;</span> <span class="bp">()</span>
     <span class="o">|</span> <span class="k">val</span> <span class="o">(</span><span class="n">x</span><span class="o">,</span> <span class="n">s'</span><span class="o">)</span> <span class="o">-&gt;</span> <span class="n">f</span> <span class="n">x</span><span class="o">;</span>
                      <span class="n">iter_stream</span> <span class="n">f</span> <span class="n">s'</span>
</code></pre></div>
<p>The second argument in the <code>end_of_stream</code> clauses binds the continuation of the effect, allowing handling strategies other than the usual stack unwinding.  Since we ignore the continuation argument the behaviour is the same as for a regular exception handler.</p>

<p>The <a href="https://github.com/matijapretnar/eff/blob/2a9a36cc/src/parser.mly#L4-L7">eff implementation</a> uses the term &quot;handler case&quot; for the clauses of the <code>handle</code> construct.</p>

<h4>OCaml</h4>

<p>Several OCaml programmers have proposed or implemented constructs related to handler case.</p>

<p><a name="delimcc"></a>
Oleg's <a href="http://okmij.org/ftp/continuations/implementations.html">delimcc</a> library for delimited continuations provides the operations needed to support the success continuation style.  The programmer can use <code>push_prompt</code> to establish a context, then call <code>shift</code> or <code>shift0</code> to return control to that context later, much as <code>try</code> establishes a context to which <code>raise</code> can transfer control.  If <code>shift</code> is not called then control returns normally from the continuation argument to <code>push_prompt</code>.  Using delimcc we might implement <code>iter_stream</code> as follows:</p>
<div class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span></span><span class="k">let</span> <span class="k">rec</span> <span class="n">iter_stream</span> <span class="n">f</span> <span class="n">s</span> <span class="o">=</span>
    <span class="k">let</span> <span class="n">p</span> <span class="o">=</span> <span class="n">new_prompt</span> <span class="bp">()</span> <span class="k">in</span>
    <span class="k">match</span> <span class="n">push_prompt</span> <span class="n">p</span> <span class="o">(</span><span class="k">fun</span> <span class="bp">()</span> <span class="o">-&gt;</span> <span class="o">`</span><span class="nc">Val</span> <span class="o">(</span><span class="n">my_stream_get</span> <span class="n">s</span> <span class="n">p</span><span class="o">))</span> <span class="k">with</span>
  <span class="o">|</span> <span class="o">`</span><span class="nc">Val</span> <span class="o">(</span><span class="n">x</span><span class="o">,</span> <span class="n">s'</span><span class="o">)</span> <span class="o">-&gt;</span> <span class="n">f</span> <span class="n">x</span><span class="o">;</span> <span class="n">iter_stream</span> <span class="n">f</span> <span class="n">s'</span>
  <span class="o">|</span> <span class="o">`</span><span class="nc">End_of_stream</span> <span class="o">-&gt;</span> <span class="bp">()</span>
</code></pre></div>
<p><a href="http://mjambon.com/">Martin Jambon</a> has <a href="http://mjambon.com/mikmatch-manual.html#htoc16">implemented</a> a construct equivalent to Exceptional Syntax for OCaml as part of the <a href="http://mjambon.com/micmatch.html">micmatch extension</a>.  His implementation allows us to write <code>iter_stream</code> in much the same way as Benton and Kennedy's proposal:</p>
<div class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span></span><span class="k">let</span> <span class="k">rec</span> <span class="n">iter_stream</span> <span class="n">f</span> <span class="n">s</span> <span class="o">=</span>
  <span class="k">let</span> <span class="k">try</span> <span class="o">(</span><span class="n">x</span><span class="o">,</span> <span class="n">s'</span><span class="o">)</span> <span class="o">=</span> <span class="n">my_stream_get</span> <span class="n">s</span>
   <span class="k">in</span> <span class="n">f</span> <span class="n">x</span><span class="o">;</span>
      <span class="n">iter_stream</span> <span class="n">f</span> <span class="n">s'</span>
  <span class="k">with</span> <span class="nc">End_of_stream</span> <span class="o">-&gt;</span> <span class="bp">()</span>
</code></pre></div>
<p>The details of the implementation are discussed in <a href="https://twitter.com/jakedonham">Jake Donham</a>'s <a href="http://ambassadortothecomputers.blogspot.co.uk/2010/09/reading-camlp4-part-11-syntax.html">articles on Camlp4</a>.  The micmatch implementation has a novel feature: the <code>let</code> binding associated with the success continuation may be made recursive.</p>

<p><a href="http://alain.frisch.fr/">Alain Frisch</a> has proposed and implemented a more powerful extension to OCaml, <a href="http://www.lexifi.com/blog/static-exceptions">Static Exceptions</a>, which allow transfer of control to lexically-visible handlers (along the lines of Common Lisp's <a href="http://clhs.lisp.se/Body/s_block.htm#block"><code>block</code></a> and <a href="http://clhs.lisp.se/Body/s_ret_fr.htm#return-from"><code>return-from</code></a>).  Static exceptions are based on an equivalent feature in OCaml's intermediate language.</p>

<p>There is a straightforward translation from OCaml extended with handler case into OCaml extended with static exceptions by wrapping the body of each <code>try</code> expression in <code>raise (`Val (...))</code>, and changing the <code>val</code> keyword in the binding section to <code>`Val</code>.  For example, <code>iter_stream</code> can be written using static exceptions as follows:</p>
<div class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span></span><span class="k">let</span> <span class="k">rec</span> <span class="n">iter_stream</span> <span class="n">f</span> <span class="n">s</span> <span class="o">=</span>
  <span class="k">try</span> <span class="k">raise</span> <span class="o">(`</span><span class="nc">Val</span> <span class="o">(</span><span class="nn">MyStream</span><span class="p">.</span><span class="n">get</span> <span class="n">s</span><span class="o">))</span>
  <span class="k">with</span> <span class="nc">End_of_stream</span> <span class="o">-&gt;</span> <span class="bp">()</span>
     <span class="o">|</span> <span class="o">`</span><span class="nc">Val</span> <span class="o">(</span><span class="n">x</span><span class="o">,</span> <span class="n">s'</span><span class="o">)</span> <span class="o">-&gt;</span> <span class="n">f</span> <span class="n">x</span><span class="o">;</span>
                       <span class="n">iter_stream</span> <span class="n">f</span> <span class="n">s'</span>
</code></pre></div>
<p>Of course, static exceptions allow many other programs to be expressed that are not readily expressible using handler case.</p>

<p><a name="catch-me"></a>
In their 2008 paper <a href="http://www.univ-orleans.fr/lifo/Members/David.Teller/publications/ml2008.pdf">Catch me if you can: Towards type-safe, hierarchical, lightweight, polymorphic and efficient error management in OCaml</a> David Teller Arnaud Spiwack and Till Varoquaux added an <code>attempt</code> keyword to OCaml that extends <code>match</code>-style pattern matching with both a single optional value case and an optional <code>finally</code> clause.</p>

<p>Finally, I discovered while writing this article that Christophe Raffalli proposed the handler case design fifteen years ago in a <a href="http://caml.inria.fr/pub/ml-archives/caml-list/1999/12/a6d3ce9671b16a33530035c2b42df011.en.html">message to caml-list</a>!  Christophe's proposal wasn't picked up back then, but perhaps the time has now come to give OCaml programmers a way to handle success.</p>

<p><a name="match-exception"></a></p>

<h3>Postscript: a symmetric extension</h3>

<p>The <code>try</code> construct in current OCaml supports matching against raised exceptions but not against the value produced when no exception is raised.  Contrariwise, the <code>match</code> construct supports matching against the value produced when no exception is raised, but does not support matching against raised exceptions.  As implemented, the patch addresses this asymmetry, extending <code>match</code> with clauses that specify the &quot;failure continuation&quot;:</p>
<div class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span></span><span class="k">match</span> <span class="n">expr</span>
<span class="k">with</span> <span class="n">pattern_1</span> <span class="o">-&gt;</span> <span class="n">expr_1</span>
   <span class="o">|</span> <span class="o">...</span>
   <span class="o">|</span> <span class="n">pattern_n</span> <span class="o">-&gt;</span> <span class="n">expr_n</span>
   <span class="o">|</span> <span class="k">exception</span> <span class="n">pattern_1'</span> <span class="o">-&gt;</span> <span class="n">expr_1'</span>
   <span class="o">|</span> <span class="o">...</span>
   <span class="o">|</span> <span class="k">exception</span> <span class="n">pattern_n'</span> <span class="o">-&gt;</span> <span class="n">expr_n'</span>
</code></pre></div>
<p>With this additional extension the choice between <code>match</code> and <code>try</code> becomes purely stylistic.  We might optimise for succinctness, and use <code>try</code> in the case where exceptions are expected (for example, where they're used for control flow), reserving <code>match</code> for the case where exceptions are truly exceptional.</p>

<p>For the sake of completeness, here's <code>iter_stream</code> written with the extended <code>match</code> construct:</p>
<div class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span></span><span class="k">let</span> <span class="k">rec</span> <span class="n">iter_stream</span> <span class="n">f</span> <span class="n">s</span> <span class="o">=</span>
  <span class="k">match</span> <span class="nn">MyStream</span><span class="p">.</span><span class="n">get</span> <span class="n">s</span> <span class="k">with</span>
     <span class="o">(</span><span class="n">x</span><span class="o">,</span> <span class="n">s'</span><span class="o">)</span> <span class="o">-&gt;</span> <span class="n">f</span> <span class="n">x</span><span class="o">;</span>
                <span class="n">iter_stream</span> <span class="n">f</span> <span class="n">s'</span>
   <span class="o">|</span> <span class="k">exception</span> <span class="nc">End_of_stream</span> <span class="o">-&gt;</span> <span class="bp">()</span>
</code></pre></div>
<p>Since both <code>val</code> and <code>exception</code> are existing keywords, the extensions to both <code>try</code> and <code>match</code> are fully backwards compatible. </p>

