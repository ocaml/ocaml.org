---
title: 'OCaml now has type recovery: when type checking goes wrong, but keeps going'
description: In this article, we'll look at how we migrated the Typing Recovery mechanism,
  previously part of Merlin's vendored front end, directly into OCaml.
url: https://tarides.com/blog/2026-10-15-ocaml-now-has-type-recovery-when-type-checking-goes-wrong-but-keeps-going
date: 2026-10-15T00:00:00-00:00
preview_image: https://tarides.com/blog/images/recovering_typedtree-1360w.webp
authors:
- Tarides
source:
ignore:
keywords:
- compiler
- errors
- merlin
- parser
- pattern matching
- recovery
- type checker
- type inference
- type-checker
- typing
---

<p><strong>Merlin</strong>, the foundational library that underpins the reference
implementation of the OCaml <a href="https://en.wikipedia.org/wiki/Language_Server_Protocol">Language Server
Protocol</a>
provides a wide range of practical features, including commands, code
completion, and much more. It also implements more subtle mechanisms
that are essential to delivering a smooth and responsive editing
experience. Indeed, the editing environment for a programming language
closely resembles the front-end of its compiler. However, whereas a
compiler operates on complete, syntactically valid programs, an editor
must continuously cope with programs that are incomplete, temporarily
inconsistent, and often ill-typed.</p>
<p>To handle these transient states, Merlin vendors a modified version of
the OCaml compiler front-end (primarily the parser and the type
checker), extending it with two recovery mechanisms:</p>
<ul>
<li>
<p><strong>Parsing Recovery</strong>, which synthesises AST nodes to allow parsing
to continue even in the presence of syntax errors.</p>
</li>
<li>
<p><strong>Typing Recovery</strong>, which synthesises typed AST nodes, allowing
type checking to continue even when type errors are encountered.</p>
</li>
</ul>
<p>This article  will focus specifically on the second mechanism, typing recovery, and how we upstreamed this feature to the mainline OCaml compiler.</p>
<h2>Typing Recovery in Action</h2>
<p>The recovery mechanisms' behaviour is easy to
observe in practice. Consider, for example, the following OCaml
program:</p>
<pre><code><span class="ocaml-keyword">let</span><span class="ocaml-source"> </span><span class="ocaml-entity-name-function-binding">x</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> </span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-string-quoted-double">ten</span><span class="ocaml-string-quoted-double">"</span><span class="ocaml-source">
</span><span class="ocaml-keyword">let</span><span class="ocaml-source"> </span><span class="ocaml-entity-name-function-binding">y</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> </span><span class="ocaml-source">x</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">+</span><span class="ocaml-source"> </span><span class="ocaml-constant-numeric-decimal-integer">20</span><span class="ocaml-source">
</span><span class="ocaml-keyword">let</span><span class="ocaml-source"> </span><span class="ocaml-entity-name-function-binding">z</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> </span><span class="ocaml-source">(</span><span class="ocaml-source">y</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">+</span><span class="ocaml-source"> </span><span class="ocaml-source">(</span><span class="ocaml-constant-numeric-decimal-integer">2</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">*</span><span class="ocaml-source"> </span><span class="ocaml-source">x</span><span class="ocaml-source">)</span><span class="ocaml-source">)</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">&amp;&amp;</span><span class="ocaml-source"> </span><span class="ocaml-constant-language-boolean">true</span><span class="ocaml-source">
</span></code></pre>
<p>Here, we are faced with three type errors. First, we attempt to add
<code>x</code> and <code>20</code>, which makes no sense since <code>x</code> has type <code>string</code>.  Next,
we attempt to multiply <code>x</code> (once again) by <code>2</code>, which is also
invalid. Finally, the expression <code>(y + (2 * x))</code>, which is expected to
have type <code>int</code>, is instead used as a boolean value.</p>
<p>When compiling this program, the OCaml compiler reports only the first
type error in the compilation unit:</p>
<pre><code>File "lib/test.ml", line 2, characters 8-9:
2 | let y = x + 20
            ^
Error: The value x has type string but an expression was expected of type int
</code></pre>
<p>This is a very sensible design choice. Although OCaml has a highly
sophisticated type system, the language's pervasive type inference
means that a single mistake can easily trigger a cascade of secondary
errors, obscuring the compiler's primary goal: ensuring <em>correctness</em>.</p>
<p>However, applying the same strategy in a code editor raises two major
(and closely related) issues:</p>
<ul>
<li>
<p>An editor that reported errors one at a time would provide a rather
poor user experience.</p>
</li>
<li>
<p>More importantly, if type checking or parsing stopped at the first
syntax or type error, every feature provided by Merlin that relies
on compiler structures – namely the <em>parsetree</em> and the
<em>typedtree</em> – would immediately become unavailable. This would be
particularly frustrating because, <em>while actively editing a file</em>,
the program is almost always in a temporarily invalid state, whether
syntactically, semantically, or both.</p>
</li>
</ul>
<p>For these reasons, the modified version of the OCaml compiler
front-end embedded in Merlin always produces valid ASTs (<em>Parsing
Recovery</em>) and typed ASTs (<em>Typing Recovery</em>), allowing the subsequent
analysis phases to continue operating on programs that are still
<em>being written</em>, whilst collecting errors:</p>
<p align="center">
<img src="https://tarides.com/blog/images/tyrec~yAwGkf5IAH8as-ak5EvI_A.gif" alt="An IDE session with Merlin">
</p><p>
</p><p>These two <em>recovery</em> mechanisms, although arguably among the most
interesting features of the language server, are also one of the main
reasons why upgrading Merlin to support a new OCaml release is such a
challenging process. This effort is known as <a href="https://tarides.com/blog/2026-10-07-an-overview-of-ocaml-release-readiness-how-does-the-ocaml-ecosystem-stay-up-to-date-with-the-compiler/"><em>OCaml Release
Readiness</em></a>. For
now, let's take a closer look at why this is the case by focussing
specifically on <em>Typing Recovery</em>.</p>
<h2>Adapting <em>Typing Recovery</em> Across OCaml Versions</h2>
<p>Without going into too much detail, upgrading Merlin to a new OCaml
version involves applying patches coming from two different sources:</p>
<ul>
<li>Compiler patches, corresponding to the various changes made to OCaml
over time;</li>
<li>Merlin patches, which introduce the <em>recoveries</em>.</li>
</ul>
<p>Because Typing Recovery is deeply intertwined with the various modules
involved in OCaml's type-checking process, applying patches from two
different sources (with different development cycles) makes version
upgrades particularly tedious and introduces two major challenges:</p>
<ul>
<li>
<p>Each upgrade <strong>takes time</strong>, because the vendored version of the
compiler front-end must be adapted while preserving all recovery
information and fixing the analysis issues naturally introduced by
the evolution of OCaml;</p>
</li>
<li>
<p>Handling new recovery cases can be tedious for the people
responsible for the upgrade process. Indeed, it is common to apply
patches from the compiler side without having a complete
understanding of their underlying rationale. For example, OCaml
<code>5.5</code> recently introduced a new feature that was highly anticipated
by the community: <a href="https://ocaml.org/manual/5.5/firstclassmodules.html#ss:fst-mod-intro">module dependent
functions</a>.
This addition changes how function parameters are handled and
requires careful consideration of how recovery should behave in
these new situations.</p>
</li>
</ul>
<p>For these reasons, Typing Recovery could become unstable (within
reasonable scenarios, of course), sometimes introducing small
regressions and sometimes lacking support for newly introduced
features.</p>
<h3>Reducing the Differences Between Merlin and OCaml</h3>
<p>Reducing the differences between Merlin's vendored version of the
front-end and the one maintained by OCaml is therefore a crucial task.
It not only helps reduce Merlin's maintenance burden, but also gives
OCaml maintainers more control over <strong>how they want recovery to be
handled</strong> within the type checker.</p>
<p>Of course, this represents an additional responsibility for the
maintainers (another one!), but in practice, developers introducing
new features in the type checker usually have both a deep
understanding of their implementation and a good intuition about how
recovery should behave in the presence of errors.</p>
<h2>Integrating <em>Typing Recovery</em> into the Compiler</h2>
<p>At the time of writing this blog post, the Typing Recovery mechanism
has <a href="https://github.com/ocaml/ocaml/pull/14241">been merged into the
compiler</a>. In this section,
we will briefly describe its <em>re</em>-design and <em>direct integration</em> into
the compiler's type checker.</p>
<p>Typing Recovery has been part of Merlin since its very beginning.
Although its implementation relies on very clever encoding, it has
aged over time, and its underlying design has become increasingly
difficult to understand. Integrating it into the compiler, therefore,
provided an opportunity to rethink the mechanism, clean it up, and
make its behaviour easier to understand. The goal was to enable a
non-intrusive integration, giving maintainers the tools they need to
confidently evolve and maintain it in the future.</p>
<h3>How Recovery Works, at a High Level</h3>
<p>The core of the OCaml type-checker is implemented as a set of
recursive functions responsible for typing the different syntactic
categories of the language, notably expressions, patterns, type
declarations, modules, and classes. When a type error is encountered,
these functions propagate an exception that interrupts the
construction of the typing derivation. As mentioned above, the compiler adopts a
<em>first-failure reporting</em> strategy, reporting
only the first encountered error.</p>
<p>To go beyond the <em>first-failure reporting</em> strategy, Merlin
instruments the main recursive functions of the type-checker in order
to intercept typing exceptions. When an exception is raised, it is
caught so that it can be recorded (logged), and typing then resumes at the
recursive call level (locally) on the other independent subterms of
the program. Thus, even if the typing of a subexpression fails,
independent subtrees can still be analysed, which makes it possible to
report multiple typing errors within a single analysis.</p>
<p>Resuming recursion allows new errors to be discovered, but it is not
sufficient to produce an exploitable <code>Typedtree</code>. When a
sub-derivation fails, Merlin synthesises an artificial <code>Typedtree</code>
node whose typing judgment is that expected by the context in which it
is inserted, while also preserving the fragments of the derivation
that could be constructed before the typing failure, even if their
attachment to the rest of the tree is no longer known. These nodes
help preserve the structure of the <code>Typedtree</code> returned by the
type-checker and maintain language server functionality despite the
presence of errors.</p>
<p>However, these generic mechanisms are not sufficient to cover all
language constructs. Some phases of the type-checker perform
preliminary checks before recursively typing their subterms. When
these checks fail, recursion is never engaged, and no partial
derivation is produced. For example, record expressions:</p>
<pre><code><span class="ocaml-source">{</span><span class="ocaml-source"> </span><span class="ocaml-source">my_fst_field</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> </span><span class="ocaml-source">e1</span><span class="ocaml-keyword-other-ocaml punctuation-separator-terminator punctuation-separator">;</span><span class="ocaml-source">
</span><span class="ocaml-source">  </span><span class="ocaml-source">my_snd_field</span><span class="ocaml-source"> </span><span class="ocaml-keyword-operator">=</span><span class="ocaml-source"> </span><span class="ocaml-source">e2</span><span class="ocaml-source"> </span><span class="ocaml-source">}</span><span class="ocaml-source">
</span></code></pre>
<p>The type-checker first attempts to resolve <code>my_fst_field</code> and
<code>my_snd_field</code>. If, for instance, <code>my_fst_field</code> does not exist, it
gives up without attempting to type <code>e1</code> and <code>e2</code>. This strategy is
suboptimal: subexpressions are never analysed even though they could
contain useful information or independent errors. To address this
issue, Merlin delays the error by assuming that the field exists.</p>
<p>Merlin then temporarily adapts the type-checker by considering that an
unknown label is not necessarily a fatal error, but may correspond to
a field that will be added later. Typing then proceeds under this
assumption, which makes it possible to produce partial derivations for
subexpressions and to improve the quality of diagnostics.</p>
<h3>Another API for Raising Type Errors</h3>
<p>As the purpose of Typing Recovery is essentially to be managed by
Merlin, we do not want to make it the default behaviour; it can
therefore be enabled using a
<a href="https://ocaml.org/manual/5.5/native.html#s:native-options">flag</a>
(<code>-typing-recovery</code>) passed to the compiler (which will be enabled by
default by Merlin).</p>
<p>In order to make error handling explicit, we introduce two functions
intended to replace direct calls to <code>raise</code> in the type-checker. When
the <code>-typing-recovery</code> flag is not enabled, these functions behave
exactly like <code>raise</code>. In Typing Recovery mode, they record the
exception in a dedicated structure, which will then be processed by
the recovery handler.</p>
<ul>
<li>
<p><code>Typing_recovery.log_and_raise</code> records the exception before
re-raising it. It is used when processing cannot continue locally
and captures the general case;</p>
</li>
<li>
<p><code>Typing_recovery.log_or_raise</code> records the exception without
re-raising it when the context is able to perform local recovery,
for example, by synthesising an artificial node or by continuing the
typing of other subterms; it captures more fine-grained cases.</p>
</li>
</ul>
<p>This distinction makes explicit the points where recovery is possible
and those where the exception must necessarily be propagated. The API
guides the implementation of the type-checker and makes recovery
decisions visible when adding or modifying typing rules.</p>
<p>Today, we do not have a formal criterion to systematically determine
which function to use. The integration into the OCaml type-checker was
therefore guided by a large set of unit tests and empirical
validation. In practice, the choice between the two functions depends
on the expected behaviour of recovery, and is validated by observing the
produced diagnostics. This lack of a general criterion aligns with the
observations of the paper <a href="https://arxiv.org/pdf/1807.06702">Merlin: A Language Server for OCaml
(Experience Report)</a>, which notes that
recovery policies would benefit from a more systematic theoretical
framework.</p>
<h3>Forcing User-Facing Error Reporting</h3>
<p>In Merlin’s historical implementation, the selection of exceptions
eligible to trigger a Typing Recovery scenario was mainly based on an
empirical approach. The reimplementation in the compiler made it
possible to identify a simple design invariant: only exceptions
intended to be reported to the user (<em>user-facing errors</em>) should be
recorded by the recovery mechanism. Conversely, internal type-checker
exceptions, as well as simply re-raised exceptions (<em>reraise</em>), must
not be captured.</p>
<p>To introduce recovery as a systematic approach, we aim to channel
<em>user-facing</em> exceptions so that they are always handled through a
pair of functions <code>log_and_raise</code> and <code>log_or_raise</code>. To achieve this,
we rely on a property of the OCaml language: exceptions are
represented by the extensible type
<a href="https://ocaml.org/manual/5.5/extensiblevariants.html"><code>exn</code></a>. This
representation makes it possible to control the introduction of new
exception constructors via module interfaces. By making certain
exception constructors private in a module signature, it becomes
possible to forbid their construction outside this module, while still
allowing them to be deconstructed through pattern matching or
exception handlers. This technique makes it possible to structure
the flow of <em>user-facing</em> errors and to enforce a systematic passage
through the associated logging functions.</p>
<pre><code><span class="diff-punctuation-definition-deleted">-</span><span class="diff-markup-deleted"> exception Error of error
</span><span class="diff-punctuation-definition-inserted">+</span><span class="diff-markup-inserted"> module Error : sig 
</span><span class="diff-punctuation-definition-inserted">+</span><span class="diff-markup-inserted">   type exn += private In_context of error
</span><span class="diff-punctuation-definition-inserted">+</span><span class="diff-markup-inserted"> end = struct
</span><span class="diff-punctuation-definition-inserted">+</span><span class="diff-markup-inserted">   type exn += In_context of error
</span><span class="diff-punctuation-definition-inserted">+</span><span class="diff-markup-inserted">
</span><span class="diff-punctuation-definition-inserted">+</span><span class="diff-markup-inserted">   let log_or_raise err = 
</span><span class="diff-punctuation-definition-inserted">+</span><span class="diff-markup-inserted">     Type_recovery.log_or_raise (In_context err)
</span><span class="diff-punctuation-definition-inserted">+</span><span class="diff-markup-inserted">
</span><span class="diff-punctuation-definition-inserted">+</span><span class="diff-markup-inserted">   let log_and_raise err = 
</span><span class="diff-punctuation-definition-inserted">+</span><span class="diff-markup-inserted">     Type_recovery.log_and_raise (In_context err)
</span><span class="diff-punctuation-definition-inserted">+</span><span class="diff-markup-inserted"> end
</span></code></pre>
<p>This transformation also makes it straightforward to rely on the
compiler to guide the implementation by identifying and handling every
possible recovery case individually and provide a precise API to
handle recovery with or without resumption.</p>
<h2>Closing Words and Acknowledgements</h2>
<p>Although there are still some differences between Merlin's vendored
front-end and the one maintained by OCaml, this change has already
significantly reduced the number of Merlin patches that need to be
applied. In the future, this will greatly simplify the process of
upgrading to new OCaml versions. We recently provided a <a href="https://github.com/ocaml/merlin/tree/506">Merlin
branch</a> that anticipates the
<code>5.6</code> release and relies on the new Typing Recovery mechanism!</p>
<p>Although the next version of OCaml will expose the <code>-typing-recovery</code>
flag to enable this mechanism, <strong>the goal is not for developers to use
it directly</strong>, but rather for it to be leveraged by tools such as
Merlin.</p>
<p>Historically, Typing Recovery was designed and maintained by Merlin's
two creators, <a href="https://def.lakaban.net/">Frédéric Bour</a> and <a href="https://github.com/trefis">Thomas
Refis</a>. It was also maintained over the
years by <a href="https://github.com/voodoos">Ulysse Gérard</a>. The integration
into the compiler was funded by <a href="https://www.janestreet.com/">Jane
Street</a>. The review, conducted by Thomas
Refis (who contributed greatly to knowledge transfer and design
discussions), was funded by <a href="https://ocaml-sf.org/">The OCaml Software
Foundation</a>. We would also like to thank
<a href="https://github.com/Octachron">Florian Angeletti</a> for his quick
review, guidance, and detailed explanations.</p>
<p>This work is part of the broader effort to reduce the gap between
OCaml and Merlin, and it is one of the most significant steps
in that direction. We believe that the integration was carried out in
a smooth and non-intrusive way, minimising the impact on maintenance
work while drastically reducing the difficulty of future version
upgrades. This will allow us to focus on delivering the best possible
experience and continuously improve the OCaml code editing
experience.</p>
<p><em>Stay Tuned</em>.</p>
<h2>Stay In Touch!</h2>
<p>Tried out the new update? Connect with us on
<a href="https://bsky.app/profile/tarides.com">Bluesky</a>,
<a href="https://mastodon.social/@tarides">Mastodon</a>,
<a href="https://www.threads.net/@taridesltd">Threads</a>, and
<a href="https://www.linkedin.com/company/tarides">LinkedIn</a> or sign up for
our mailing list to stay updated on our latest projects. You can also
connect with other OCaml users on
<a href="https://discuss.ocaml.org/">Discuss</a>. We look forward to hearing your
thoughts!</p>
