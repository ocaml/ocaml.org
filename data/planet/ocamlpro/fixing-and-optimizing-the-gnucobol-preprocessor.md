---
title: Fixing and Optimizing the GnuCOBOL Preprocessor
description: In this post, I will present some work that we did on the GnuCOBOL compiler,
  the only fully-mature open-source compiler for COBOL. It all started with a bug
  issued by one of our customers that we fixed by improving the preprocessing pass
  of the compiler. We later went on and optimised it to get bett...
url: https://ocamlpro.com/blog/2024_04_30_fixing_and_optimizing_gnucobol
date: 2024-04-30T11:42:34-00:00
preview_image: https://ocamlpro.com/blog/assets/img/craiyon-gnucobol-optimization.webp
featured:
authors:
- "\n    Fabrice Le Fessant\n  "
source:
---

<p></p>
<p>In this post, I will present some work that we did on the GnuCOBOL
compiler, the only fully-mature open-source compiler for COBOL. It all started
with a bug issued by one of our customers that we fixed by
improving the preprocessing pass of the compiler. We later went on and
optimised it to get better performances than the initial version.</p>
<blockquote>
<p>Supporting the GnuCOBOL compiler has become one of our commercial
activities. If you are interested in this project, we have a
dedicated website on our <a href="https://get-superbol.com">SuperBOL offer</a>, a
set of tools and services to ease deploying GnuCOBOL in a company to
replace proprietary COBOL environments.</p>
</blockquote>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/craiyon-gnucobol-optimization.webp">
      <img src="https://ocamlpro.com/blog/assets/img/craiyon-gnucobol-optimization.webp" alt="At
OCamlPro, we often favor correctness over performance. But at the
end, our software is correct AND often faster than its competitors!
Optimizing software is an art, that often contradicts popular
beliefs."/>
    </a>
    </p><div class="caption">
      At
OCamlPro, we often favor correctness over performance. But at the
end, our software is correct AND often faster than its competitors!
Optimizing software is an art, that often contradicts popular
beliefs.
    </div>
  
</div>

<p></p><div>
<strong>Table of contents</strong>
<ul>
<li><a href="https://ocamlpro.com/blog/feed#replacing">Preprocessing and Replacements in COBOL</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#gnucobol">Preprocessing in the GnuCOBOL Compiler</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#standard">Conformance to the ISO Standard</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#automata">Preprocessing with Automata on Streams</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#issues">Some Performance Issues</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#allocations">Optimising Allocations</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#fastpaths">What about Fast Paths ?</a>
</li>
<li><a href="https://ocamlpro.com/blog/feed#conclusion">Conclusion</a>

</li>
</ul>
<h2>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#replacing" class="anchor-link">Preprocessing and Replacements in COBOL</a>
          </h2>
<p>COBOL was born in 1959, at a time where the science of programming
languages was just starting. If you had to design a new language for
the same purpose today, the result would be very different, you would
do different mistakes, but maybe not fewer. Actually, COBOL has shown
to be particularly resilient to time, as it is still used, 70
years later! Though it has evolved over the years (the <a href="https://www.iso.org/fr/standard/74527.html">last ISO
standard for COBOL</a> was
released in January 2023), the kernel of the language is still the
same, showing that most of the initial design choices were not perfect, but
still got the job done.</p>
<p>One of these choices, which would sure scare off young developers, is how COBOL
favors code reusability and sharing, through replacements done
in its preprocessor.</p>
<p>Let's consider this COBOL code, this will be our example for the rest of this
article:</p>
<pre><code class="language-COBOL">DATA DIVISION.
WORKING-STORAGE SECTION.
  01 VAL1.
    COPY MY-RECORD REPLACING ==:XXX:== BY ==VAL1==.
  01 VAL2.
    COPY MY-RECORD REPLACING ==:XXX:== BY ==VAL2==.
  01 COUNTERS.
     05 COUNTER-NAMES  PIC 999 VALUE 0.
     05 COUNTER-VALUES PIC 999 VALUE 0.
</code></pre>
<p>We are using the <em>free</em> format, a modern way of formatting code, the
older <em>fixed</em> format would require to leave a margin of 7 characters
on the left. We are in the <code>DATA</code> division, the part of the program
that defines the format of data, and specifically, in the
<code>WORKING-STORAGE</code> section, where global variables are defined. In
<em>standard</em> COBOL, there are no local variables, so the
<code>WORKING-STORAGE</code> section usually contains all the variables of the
program, even temporary ones.</p>
<p>In COBOL, there are variables of basic types (integers and strings
with specific lengths), and composite types (arrays and
records). Records are defined using levels: global variables are at
level <code>01</code> (such as <code>VAL1</code>, <code>VAL2</code> and <code>COUNTERS</code> in our example),
whereas most other levels indicate inner fields: here,
<code>COUNTER-NAMES</code> and <code>COUNTER-VALUES</code> are two direct fields of
<code>COUNTERS</code>, as shown by their lower level <code>05</code> (both are actually
integers of 3 digits as specified by <code>PIC 999</code>). Moreover, COBOL
programmers like to be able to access fields directly, by making them
unique in the program: it is thus possible to use <code>COUNTER-NAMES</code>
everywhere in the program, without refering to <code>COUNTERS</code> itself
(note that if the field wasn't assigned a unique name, it would be possible
to use <code>COUNTER-NAMES OF COUNTERS</code> to disambiguate them).</p>
<p>On the other hand, in older versions of COBOL, there were no type definitions.</p>
<p><strong>So how would one create two record variables with the same content?</strong></p>
<p>One
would use the preprocessor to include the same file several times,
describing the structure of the record into your program. One would
also use that same file to describe the format of some
data files storing such records. Actually, COBOL developers use
external tools that are used to manage data files and generate the
descriptions, that are then included into COBOL programs in order to manipulate the files
(<code>pacbase</code> for example is one such tool).</p>
<p>In our example, there would be a file <code>MY-RECORD.CPY</code> (usually called
a <em>copybook</em>), containing something like the following somewhere in the
filesystem:</p>
<pre><code class="language-COBOL">05 :XXX:-USERNAME PIC X(30).
05 :XXX:-BIRTHDATE.
  10 :XXX:-BIRTHDATE-YEAR PIC 9999.
  10 :XXX:-BIRTHDATE-MONTH PIC 99.
  10 :XXX:-BIRTHDATE-MDAY PIC 99.
05 :XXX:-ADDRESS PIC X(100).
</code></pre>
<p>This code except is actually not really correct COBOL code because
identifiers cannot contain a <code>:XXX:</code> part:. It was written
instead for it to be included <strong>and modified</strong> in other COBOL programs.</p>
<p>Indeed, the following line will include the file and perform a replacement of a
<code>:XXX:</code> partial token by <code>VAL1</code>:</p>
<pre><code class="language-COBOL">COPY MY-RECORD REPLACING ==:XXX:== BY ==VAL1==.
</code></pre>
<p>So, in our main example, we now have two global record variables
<code>VAL1</code> and <code>VAL2</code>, of the same format, but containing fields with
unique names such as <code>VAL1-USERNAME</code> and <code>VAL2-USERNAME</code>.</p>
<p>Allow me to repeat that, despite pecular nature, these features <strong>have</strong> stood
the test of the time.</p>
<p>The journey continues. Suppose now that you are in a specific part
of your program, and that wish to manipulate longer names, say, you
would like the <code>:XXX:-USERNAME</code> variable to be of size <code>60</code> instead of <code>30</code>.</p>
<p>Here is how you could do it:</p>
<pre><code class="language-COBOL">  [...]
REPLACE ==PIC X(30)== BY ==PIC X(60)==.
  01 VAL1.
    COPY [...]
REPLACE OFF.
  01 COUNTERS.
  [...]
</code></pre>
<p>Here, we can replace a list of consecutive tokens <code>PIC X(30)</code> by
another list of tokens <code>PIC X(60)</code>. The result is that the fields
<code>VAL1-USERNAME</code> and <code>VAL2-USERNAME</code> are now <code>60</code> bytes long.</p>
<p><code>REPLACE</code> and <code>COPY REPLACING</code> can both perform the same kind of
replacements on both parts of tokens (using <code>LEADING</code> or <code>TRAILING</code>
keywords) and lists of tokens. COBOL programmers combine them to
perform their daily job of building consistent software, by sharing
formats using shared copybooks.</p>
<p>Let's see now how GnuCOBOL can deal with that.</p>
<h2>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#gnucobol" class="anchor-link">Preprocessing in the GnuCOBOL Compiler</a>
          </h2>
<p>The GnuCOBOL compiler is a transpiler: it translates COBOL source code
into C89 source code, that can then be compiled to executable code by
a C compiler. It has two main benefits: <strong>high portability</strong>, as
GnuCOBOL will work on any platform with any C compiler, including very
old hardware and mainframes, and <strong>simplicity</strong>, as code generation is
reduced to its minimum, most of the code of the compiler is its
parser... Which is actually still huge as COBOL is a particularly rich
language.</p>
<p>GnuCOBOL implements many dialects, (i.e.: extensions of COBOL available on
proprietary compilers such as IBM, MicroFocus, etc.), in order to provide a
solution to the migration issues posed by proprietary platforms.</p>
<blockquote>
<p>The support of dialects is one of the most interesting features of
GnuCOBOL: by supporting natively many extensions of proprietary
compilers, it is possible to migrate applications from these
compilers to GnuCOBOL without modifying the sources, allowing to run
the same code on the old platform and the new one during all the
migration.</p>
<p>One of OCamlPro's main contributions to GnuCOBOL has been
to create such a dialect for GCOS7, a former Bull mainframe still in
use in some places.</p>
</blockquote>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/bull-dps7-gcos7.jpg">
      <img src="https://ocamlpro.com/blog/assets/img/bull-dps7-gcos7.jpg" alt="This is a Bull DPS-7
mainframe around 1980, running the GCOS7 operating system. Such
systems are still used to run COBOL critical applications in some
companies, though running on software emulators on PCs. GnuCOBOL is a
mature solution to migrate such applications to modern Linux
computers."/>
    </a>
    </p><div class="caption">
      This is a Bull DPS-7
mainframe around 1980, running the GCOS7 operating system. Such
systems are still used to run COBOL critical applications in some
companies, though running on software emulators on PCs. GnuCOBOL is a
mature solution to migrate such applications to modern Linux
computers.
    </div>
  
</div>

<p>To perform its duty, GnuCOBOL processes COBOL source files in two
passes: it preprocesses them during the first phase, generating a new
temporary COBOL file with all inclusions and replacement done, and
then parses this file and generates the corresponding C code.</p>
<p>To do that, GnuCOBOL includes two pairs of lexers and parsers, one for each
phase. The first pair only recognises a very limited set of constructions, such
as <code>COPY... REPLACING</code>, <code>REPLACE</code>, but also some
other ones like compiler directives.</p>
<p>The lexer/parser for preprocessing directly works on the input file,
and performed all these operations in a single pass before version
<code>3.2</code>.</p>
<p>The output can be seen using the <code>-E</code> argument:</p>
<pre><code class="language-shell">$ cobc -E --free foo.cob
#line 1 &quot;foo.cob&quot;
DATA DIVISION.
WORKING-STORAGE SECTION.
 
 01 VAL1.
 
#line 1 &quot;MY-RECORD.CPY&quot;
05 VAL1-USERNAME PIC X(60).
05 VAL1-BIRTHDATE.
 10 VAL1-BIRTHDATE-YEAR PIC 9999.
 10 VAL1-BIRTHDATE-MONTH PIC 99.
 10 VAL1-BIRTHDATE-MDAY PIC 99.
05 VAL1-ADDRESS PIC X(100).
#line 5 &quot;foo.cob&quot;

 01 VAL2.
 
#line 1 &quot;MY-RECORD.CPY&quot;
05 VAL2-USERNAME PIC X(60).
05 VAL2-BIRTHDATE.
 10 VAL2-BIRTHDATE-YEAR PIC 9999.
 10 VAL2-BIRTHDATE-MONTH PIC 99.
 10 VAL2-BIRTHDATE-MDAY PIC 99.
05 VAL2-ADDRESS PIC X(100).
#line 7 &quot;foo.cob&quot;

 
 01 COUNTERS.
 05 COUNTER-NAMES PIC 999 VALUE 0.
 05 COUNTER-VALUES PIC 999 VALUE 0.
</code></pre>
<p>The <code>-E</code> option is particularly useful if you want to understand the
final code that GnuCOBOL will compile. You can also get access to this
information using the option <code>--save-temps</code> (save intermediate files),
in which case <code>cobc</code> will generate a file with extension <code>.i</code> (<code>foo.i</code>
in our case) containing the preprocessed COBOL code.</p>
<p>You can see that <code>cobc</code> successfully performed both the <code>REPLACE</code> and
<code>COPY REPLACING</code> instructions.</p>
<p>The <a href="https://github.com/OCamlPro/gnucobol/blob/5ab722e656a25dc95ab99705ee1063562f2e5be5/cobc/pplex.l#L2049">corresponding code in version
3.1.2</a>
is in file <code>cobc/pplex.l</code>, function <code>ppecho</code>. Fully understanding it
is left as an exercice for the motivated reader.</p>
<p>The general idea is that replacements defined by <code>COPY REPLACING</code> and <code>REPLACE</code>
are added to the same list of active replacements.</p>
<p>We show in the next section that such an implementation does not
conform to the ISO standard.</p>
<h2>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#standard" class="anchor-link">Conformance to the ISO Standard</a>
          </h2>
<p>You may wonder if it is possible for <code>REPLACE</code> statements to perform
replacements that would change a <code>COPY</code> statement, such as :</p>
<pre><code class="language-COBOL">REPLACE ==COPY MY-RECORD== BY == COPY OTHER-RECORD==.
COPY MY-RECORD.
</code></pre>
<p>You may also wonder what happens if we try to combine replacements by
<code>COPY</code> and <code>REPLACE</code> on the same tokens, for example:</p>
<pre><code class="language-COBOL">REPLACE ==VAL1-USERNAME PIC X(30)== BY ==VAL1-USERNAME PIC X(60)==
</code></pre>
<p>Such a statement only makes sense if we assume the <code>COPY</code> replacements
have been performed before the <code>REPLACE</code> replacements are performed.</p>
<p>Such ambiguities have been resolved in the ISO Standard for COBOL: in
section <code>7.2.1. Text Manipulation &gt;&gt; General</code>, it is specified that
preprocessing is executed in 4 phases on the streams of tokens:</p>
<pre><code class="language-shell-session">1. `COPY` statements are performed, and the corresponding `REPLACING`
   replacements too;
2. Conditional compiler directives are then performed;
3. `REPLACE` statements are performed;
4. `COBOL-WORDS` statements are performed (allowing to enabled/disable
   some keywords)
</code></pre>
<p>So, a <code>REPLACE</code> cannot modify a <code>COPY</code> statement (and the opposite is
also impossible, as <code>REPLACE</code> are not allowed in copybooks), but it
can modify the same set of tokens that are being modified by the
<code>REPLACING</code> part of a <code>COPY</code>.</p>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/standard-iso-cobol.jpg">
      <img src="https://ocamlpro.com/blog/assets/img/standard-iso-cobol.jpg" alt="The ISO standard
specifies the different steps to preprocess COBOL files and perform
replacements in a specific order."/>
    </a>
    </p><div class="caption">
      The ISO standard
specifies the different steps to preprocess COBOL files and perform
replacements in a specific order.
    </div>
  
</div>

<p>As described in the previous section, GnuCOBOL implements all phases
1, 2 and 3 in a single one, even mixing replacements defined by
<code>COPY</code> and by <code>REPLACE</code> statements. Fortunately, this behavior is good
enough for most programs. Unfortunately, there are still programs
that combine <code>COPY</code> and <code>REPLACE</code> on the same tokens, leading to hard
to debug errors, as the compiler does not conform to the
specification.</p>
<p>A difficult situation which happened to one of our customers and that we
prompty addressed by patching a part of the compiler.</p>
<h2>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#automata" class="anchor-link">Preprocessing with Automata on Streams</a>
          </h2>
<p>Correctly implementing the specification written in the standard would
make the preprocessing phase quite complicated. Indeed, we would have
to implement a small parser for every one of the four steps of
preprocessing. That's actually what we did for our <a href="https://github.com/OCamlPro/superbol-studio-oss/tree/master/src/lsp/cobol_preproc">COBOL parser in
OCaml</a>
used by the LSP (<a href="https://microsoft.github.io/language-server-protocol/">Language Server
Protocol</a>) of
our <a href="https://marketplace.visualstudio.com/items?itemName=OCamlPro.SuperBOL">SuperBOL
Studio</a>
COBOL plugin for VSCode.</p>
<p>However, doing the same in GnuCOBOL is much harder: GnuCOBOL is
written in C, and such a change would require a complete rewriting of
the preprocessor, something that would take more time than we
had on our hands. Instead, we opted for rewriting the replacement function, to
split <code>COPY REPLACING</code> and <code>REPLACE</code> into two different replacement phases.</p>
<p>The <a href="https://github.com/OCamlPro/gnucobol/blob/gnucobol-3.2/cobc/replace.c">corresponding C
code</a>
has been moved into a file <code>cobc/replace.c</code>. It implements an
automaton that applies a list of replacements on a stream of tokens,
returning another stream of tokens. The preprocessor is thus composed
of two instances of this automaton, one for <code>COPY REPLACING</code>
statements and another one for <code>REPLACE</code> statements.</p>
<p>The second instance takes the stream of tokens produced by the first one as
input. The automaton is implemented using recursive functions, which is particularly
suitable to allow reasoning about its correctness. Actually, several bugs were
found in the former C implementation while designing this
automaton. Each automaton has an internal state, composed of a set of
tokens which are queued (and waiting for a potential match) and a list
of possible replacements of these tokens.</p>
<p>Thanks to this design, it was possible to provide a working implementation in a
very short delay, considering the complexity of that part of the compiler.</p>
<p>We added several tests to the testsuite of the compiler for all the bugs that
had been detected in the process to prevent regressions in the future, and the
<a href="https://github.com/OCamlPro/gnucobol/pull/75">corresponding pull request</a> was
reviewed by Simon Sobisch, the GnuCOBOL project leader, and later upstreamed.</p>
<h3>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#issues" class="anchor-link">Some Performance Issues</a>
          </h3>
<p>Unfortunately, it was not the end of the work: Simon performed some
performance evaluations on this new implementation, and although it
had improved the conformance of GnuCOBOL to the standard, it did affect the performance negatively.</p>
<p>Compiler performance is not always critical for most applications, as
long as you compile only individual COBOL source files. However, some
source files can become very big, especially when part of the code is
auto-generated. In COBOL, a typical case of that is the use of a
pre-compiler, typically for SQL. Such programs contain <code>EXEC SQL</code>
statements, that are translated by the SQL pre-compiler into much
longer COBOL code, consisting mostly of <code>CALL</code> statements calling C
functions into the SQL library to build and execute SQL requests.</p>
<p>For such a generated program, of a whopping 700 kLines, Simon noticed an important
degradation in compilation time, and profiling tools concluded that
the new preprocessor implementation was responsible for it, as shown
in the flamegraph below:</p>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/cobc-callgraph-pplex1.png">
      <img src="https://ocamlpro.com/blog/assets/img/cobc-callgraph-pplex1.png" alt="A flamegraph
generated by &lt;code&gt;perf&lt;/code&gt; stats visualised on &lt;code&gt;hotspot&lt;/code&gt;: the horizontal axis
is the total duration. We can see that &lt;code&gt;ppecho&lt;/code&gt;, the function for
replacements, takes most of the preprocessing time, with the
two-automata replacement phases. Credit: Simon Sobisch"/>
    </a>
    </p><div class="caption">
      A flamegraph
generated by <code>perf</code> stats visualised on <code>hotspot</code>: the horizontal axis
is the total duration. We can see that <code>ppecho</code>, the function for
replacements, takes most of the preprocessing time, with the
two-automata replacement phases. Credit: Simon Sobisch
    </div>
  
</div>

<p>So we started investigating to fix the problem in <a href="https://github.com/OCamlPro/gnucobol/pull/142">a new
pull-request</a>.</p>
<h3>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#allocations" class="anchor-link">Optimizing Allocations</a>
          </h3>
<p>Our first intuition was that the main difference with the previous
implementation came from allocating too many lists in the temporary
state of the two automatons. This intuition was only partially right,
as we will see.</p>
<p>Mutable lists were used in the automaton (and also in the former
implementation) to store a small part of the stream of tokens, while
they were being matched with a replacement source. On a partial match,
the list had to wait for additionnal tokens to check for a full
match. Actually, these <strong>lists</strong> were used as <strong>queues</strong>, as tokens
were always added at the end, while matched or un-matched tokens were
removed from the top. Also, the size of these lists was bounded by the
maximal replacement that was defined in the code, that would unlikely
be more than a few dozen tokens.</p>
<p>Our first idea was to replace these lists by real queues, that can be
efficiently implemented using <a href="https://github.com/OCamlPro/gnucobol/blob/82100d64de35c89ad5980d1b2c8d1ffdd3563570/cobc/replace.c#L89">circular buffers and
arrays</a>.
Each and every allocation of a new list element would then be replaced by the
single allocation of a circular buffer, granted with a few possible
reallocations further down the road if the list of replacements was to grow
bigger.</p>
<p>The results were a bit disappointing: on the flamegraph, there was
some improvement, but the replacement phase still took a lot of time:</p>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/cobc-callgraph-pplex2.png">
      <img src="https://ocamlpro.com/blog/assets/img/cobc-callgraph-pplex2.png" alt="The flamegraph is
better, as shown by the disappearance of calls to &lt;code&gt;token_list_add&lt;/code&gt;. But our work is not yet finished! Credit: Simon Sobisch"/>
    </a>
    </p><div class="caption">
      The flamegraph is
better, as shown by the disappearance of calls to <code>token_list_add</code>. But our work is not yet finished! Credit: Simon Sobisch
    </div>
  
</div>

<p>Another intuition we had was that we had been a bit naive
about allocating tokens: in the initial implementation of version
<code>3.1.2</code>, tokens were allocated when copied from the lexer into the
single queue for replacement; in our implementation, that job was also
done, but twice, as they were allocated in both automata. So, we
modified our implementation to only allocate tokens when they are
first entered in the <code>COPY REPLACING</code> stream, and not anymore when
entering the <code>REPLACE</code> stream. A simple idea, that reduced again the
remaining allocations by a factor of 2.</p>
<p>Yet, the new optimised implementation still didn't match the
performance of the former <code>3.1.2</code> version, and we were running out of
ideas on how the allocations performed by the automata could again be
improved:</p>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/cobc-valgrind-pplex1.png">
      <img src="https://ocamlpro.com/blog/assets/img/cobc-valgrind-pplex1.png" alt="Using circular
buffers instead of mutable lists for queues decreased allocations by a
factor of 3. Removing the re-allocations between the two streams would
also improve it by a factor of 2. A nice improvement, but not yet the
performances of version 3.1.2"/>
    </a>
    </p><div class="caption">
      Using circular
buffers instead of mutable lists for queues decreased allocations by a
factor of 3. Removing the re-allocations between the two streams would
also improve it by a factor of 2. A nice improvement, but not yet the
performances of version 3.1.2
    </div>
  
</div>

<h3>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#fastpaths" class="anchor-link">What about Fast Paths ?</a>
          </h3>
<p>So we decided to study some of the code from <code>3.1.2</code> to understand what
could cause such a difference, and it became immediately obvious: the
former version had two fast paths, that we had left out of our own
implementation!</p>
<p>The two fast paths that completely shortcut the replacement mechanisms are the
following:</p>
<p>The first one is when there are no replacements defined in the source. In
COBOL, most replacements are only performed in the <code>DATA DIVISION</code>, and
moreover, <code>COPY REPLACING</code> ones are only performed during copies. This means
that a large part of the code that did not need to go through our two automata
still did!</p>
<p>The second fast path is for spaces: replacements always start and finish by a
non-space token in COBOL, so, if we check that we are not in the middle of
partial match (i.e. both internal token queues are empty), we can safely make
the space token skip the automata. Again, given the frequency of space tokens
(about half, as there are very few other separators), this fast path is
likely to be used very, very frequently.</p>
<p>Implementing them was straigthforward, and the results were the one
expected:</p>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/cobc-callgraph-pplex3.png">
      <img src="https://ocamlpro.com/blog/assets/img/cobc-callgraph-pplex3.png" alt="After implementing
the same fast paths as in 3.1.2, the flamegraph is back to normal,
with the time spent in the replacement function being almost not
noticeable. Credit: Simon Sobisch"/>
    </a>
    </p><div class="caption">
      After implementing
the same fast paths as in 3.1.2, the flamegraph is back to normal,
with the time spent in the replacement function being almost not
noticeable. Credit: Simon Sobisch
    </div>
  
</div>

<h3>
<a class="anchor"></a><a href="https://ocamlpro.com/blog/feed#conclusion" class="anchor-link">Conclusion</a>
          </h3>
<p>As often with optimisations, intuitions do not always lead to the
expected improvements: in our case, the real improvement came not with
improving the algorithm, but from shortcutting it!</p>
<p>Yet, we are still very pleased by the results: the new optimised
implementation of replacements in GnuCOBOL makes it more conformant to the
standard, and also more efficient than the former <code>3.1.2</code> version, as shown by
the final results sent to us by Simon:</p>
<p>
</p><div class="figure">
  <p>
    <a href="https://ocamlpro.com/blog/assets/img/cobc-valgrind-pplex2.png">
      <img src="https://ocamlpro.com/blog/assets/img/cobc-valgrind-pplex2.png" alt="These results show that the new implementation is now a little better than 3.1.2. It comes from using the circular buffers instead of the mutable lists for queues, but the optimisation only happens when replacements are defined, which is a very small part of the code source."/>
    </a>
    </p><div class="caption">
      These results show that the new implementation is now a little better than 3.1.2. It comes from using the circular buffers instead of the mutable lists for queues, but the optimisation only happens when replacements are defined, which is a very small part of the code source.
    </div>
  
</div>

</div>
