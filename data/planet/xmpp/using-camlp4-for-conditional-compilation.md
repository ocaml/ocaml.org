---
title: Using Camlp4 for conditional compilation
description:
url: http://ox.tuxfamily.org/2011/03/27/using-camlp4-for-conditional-compilation/
date: 2011-03-26T17:55:07-00:00
preview_image:
featured:
authors:
- xmpp
---

<p>Hi,</p>
<p>so I have been wondering for quite some time: <strong>how to do conditional compilation in Ocaml as simple as in C?</strong></p>
<p>As a reader of a library development log, you probably know that one would typically use preprocessing to modify a code before it gets compiled. There are a few cases in particular when one wishes to do so:</p>
<ol>
<li>When code on various platform would differ: a typical OCaml example would be the use of the <a href="http://caml.inria.fr/pub/docs/manual-ocaml/manual035.html">Unix</a> module which is not fully implemented in Win32 OSes. Hence we might want to have an alternative implementation on Win32 but keep the simpler or faster <em>Unix</em> implementation when relevant.</li>
<li>When optimization is more important than genericity of code, in particular if we can use material specificities of the underlining architecture: for instance by having specialized 32 bits or 64 bits version, more generally direct access to a material interface, and so on.</li>
<li>To create environment-specific behavior. This is mostly used during implementation where we might want to have a &ldquo;debug mode&rdquo; providing development information, disabling it for release without having to edit the code</li>
<li>To provide options, in particular if this prevents from linking some non-mandatory or problematic library.</li>
</ol>
<p>Unfortunately though C/C++ make it easy, Objective Caml preprocessing feature (<a href="http://caml.inria.fr/pub/docs/manual-camlp4/index.html" title="Camlp4 Reference Manual">Camlp4</a>) wants us to make our own grammar! Actually the various documentation and tutorial found on the subject compares Camlp4 rather to <a href="http://dinosaur.compilertools.net/">lex/yacc</a> (flex/bison in the Free Software world) lexer and parser, than to the C preprocessor.</p>
<p>Though it is most certainly nice and powerful (I admit, I didn&rsquo;t read the whole Camlp4&prime;s documentation), I only needed a very simple conditional compilation for my current use case.</p>
<p>I&rsquo;ll discuss below how I did it for people needing this kind of feature as well as the limitation of this &ldquo;simple&rdquo; method.<br/>
Then I&rsquo;ll discuss more generally on conditional compilation, why it can be a good idea; yet why we should be careful about this; and finally alternatives.</p>
<h2>OCaml and simple conditional compilation</h2>
<h3>Documentation Flaws</h3>
<p>Let&rsquo;s admit, while OCaml is great, and has a good enough <a href="http://caml.inria.fr/pub/docs/manual-ocaml/">official documentation</a> and a few <a href="http://caml.inria.fr/pub/docs/oreilly-book/html/">great alternative ones</a> out there, most of it is rather outdated, or very limited and imprecise. Camlp4 follows the rule. The official manual and <a href="http://caml.inria.fr/pub/docs/tutorial-camlp4/index.html">tutorial</a> both date from 2003, Ocaml version 3.07 (we are in 2011 and version 3.12 has been published for 7 months now!) and all other information I found were in similar state. Moreover documentation really focuses on extensive use of Camlp4, barely explaining how to use the easy pre-implemented grammars.</p>
<h3>Default Preprocessing Grammar for Macros</h3>
<p>There is indeed one grammar for macro support, written with Camlp4 and provided with the official OCaml release, which one can optionally load during compilation: <strong>pa_macro</strong>. That is what I got interested into. Sadly the best documentation to see how to use it and the full range of possibilities was&hellip; comments in the compiler source code.<br/>
Not to clutter this log anymore, I uploaded the relevant comment in a <a href="http://download.tuxfamily.org/ocamlxmpp/Camlp4MacroParser_doc.txt">separate file</a> for people to easily check on this.</p>
<h4>What it can do</h4>
<p>It allows to:</p>
<ol>
<li>define MACROs to be tested for existence or to be replaced by code;</li>
<li>compile some code depending on the existence of macros.</li>
</ol>
<p>And that&rsquo;s basically all (nearly).</p>
<h4>What it cannot do</h4>
<p>In particular it cannot do these very basic uses of macros:</p>
<dl>
<dt>Test values of macros.</dt>
<dd>You cannot test the value of a macro and run some code depending on it. The only testable condition is existence/absence.<br/>
In my case for instance, I wanted to use a different type in a module depending whether I was on a 32 bits or a 64 bits platform. My first idea was to run:<br/>
<code>ARCH=`uname -m`</code><br/>
in the Makefile, then add this as a macro and check value while preprocessing. That&rsquo;s not possible.<br/>
Instead I had to make the test in the Makefile:<br/>
<code>ifeq(`uname -m`,x86_64)</code><br/>
and depending on this condition, I set or not the ARCH_64 macro. Then I test its existence.
</dd>
<dt>Replace macros with nothing</dt>
<dd>On C, you could have macros set to nothing so that would simply disappear when embedded in the code. This is impossible with <em>pa_macro</em>.<br/>
If I try <code>DEFINE MY_MACRO=</code>, it would raise a preprocessing error.<br/>
If I simply define the macro (without &lsquo;=&rsquo;), and try to use it in the code, it would not be replaced, hence this time, the compiler raises a constructor error.<br/>
There is a predefined macro called <em>NOTHING</em> but apparently it can be used only as a function argument that you want to erase (and I did not really understand the use case for it). I cannot set:<br/>
<code>DEFINE MY_MACRO=NOTHING</code>
<p>Hence my solution was this:<br/>
<code>DEFINE MY_MACRO(x)=x</code></p>
<p>You could say: but why would I want this? In my code, I have a TO_INT macro. On a 32 bits architecture, I want it to be <code>Int32.to_int</code> whereas on 64 bits, I would use the int type, then TO_INT is the identity function (and if I can avoid a useless function call&hellip;).
</p></dd>
<dt>Flawed check on constants</dt>
<dd>In the algorithm I implemented (SHA1), there are some constants. Some of them are very big and are over <code>max_int</code> on a 32 bits platform.<br/>
But as I said, in such a case, I use Int32, so all is fine. So I had this kind of test:
<pre>
IFNDEF ARCH_64 THEN
    0x8F1BBCDCl
ELSE
    0x8F1BBCDC
ENDIF
</pre>
<p>The problem I encountered was that camlp4o was raising an error while compiling on a 32 bits machine, telling me that 0x8F1BBCDC was bigger than max_int!<br/>
I don&rsquo;t know why it tried to check the validity of the constant while this code was not going to be compiled. In my opinion, it should stick to its &ldquo;syntax work&rdquo;, then pass the result to the compiler. This one will check validity of constants and if I made an error (which I did not), it would tell me. No need to make this check twice, especially when the check is flawed! That&rsquo;s a clear limitation in pa_macro that I could only work around by making this constant as a macro that I pass from my Makefile. That&rsquo;s not clean, clearly, but I did not find a better solution.
</p></dd>
<dt>&ldquo;parser&rdquo; is a keyword</dt>
<dd>I had a class called <code>XML.parser</code>. I had to rename it because &mdash;&nbsp;when using Camlp4&nbsp;&mdash; <code>parser</code> becomes a keyword (used to filter streams) and cannot be used anymore to name entities. This is not an error, but just so that you know that <code>camlp4o</code> can cause this kind of issues. Yet it does not change the original syntax. On the other hand, <code>camlp4r</code> (&lsquo;<strong>r</strong>&lsquo; as &ldquo;revised&rdquo;) does change the basic syntax. So use only camlp4o if you wish to continue using the original OCaml!</dd>
</dl>
<h4>How it looks</h4>
<p>So in the end, my file has this kind of code:</p>
<pre>
IFNDEF ARCH_64 THEN
  DEFINE LOGAND=Int32.logand
  DEFINE LOGOR=Int32.logor
  DEFINE TO_INT=Int32.to_int
  DEFINE OCTET=0xFFl
<em>[&hellip;]</em>
ELSE
  DEFINE LOGAND=(land)
  DEFINE LOGOR=(lor)
  DEFINE TO_INT(i)= i
  DEFINE OCTET=0xFF
<em>[&hellip;]</em>
ENDIF
<em>[&hellip;]</em>
let rem = TO_INT (LOGAND div OCTET) in
  w.[i] &lt;- Char.unsafe_chr rem;
<em>[&hellip;]</em>
</pre>
<h3>How to compile this</h3>
<p>And my Makefile contains such code:</p>
<pre>
ARCH64_PP_FLAGS=-DARCH_64 -DHEX_8F1BBCDC=0x8F1BBCDC
# You remember the ugly workaround I told about because
# Camlp4 was forbidding me to write big integers? Here it is.

ifeq ($(shell uname -m),x86_64)
PP_FLAGS=$(ARCH64_PP_FLAGS)
else ifeq ($(shell uname -m),ia64)
PP_FLAGS=$(ARCH64_PP_FLAGS)
<em>[&hellip;]</em>
else
PP_FLAGS=-UARCH_64
endif

all:
    ocamlopt -pp &quot;camlp4o pa_macro.cmo $(PP_FLAGS)&quot; sha1.mli sha1.ml
</pre>
<p>Here we simply tell the compiler to use camlp4o as a preprocessor (-pp) with the grammar pa_macro.cmo and we set (or unset) a few macros.</p>
<h2>Conditional Compilation: when should it be used?</h2>
<p>Here are a few examples of bad and good use of conditional compilation.</p>
<h3>Creates parallel Code versions</h3>
<p>In particular, it generate &ldquo;logical&rdquo; code versions (not the physical code, as I will show, when well done, it can in fact factorize it, which is good) which makes as though you had several different programs to maintain. Indeed in my example, I already have 2 versions of my code: 32 and 64 bits. What it means in particular is that my code compiling on a 32 bits architecture does not mean anymore it compiles on a 64 bits one (and reciprocally) because the compiler is not given anymore the whole code at once but a part which has been &ldquo;dumped&rdquo; by Camlp4 (hence &ldquo;<strong>pre</strong>-processing&rdquo;).</p>
<p>Here that&rsquo;s still ok because I have only 2 versions. But when a software multiplies conditional compilations instead of writing generic code, it can easily end up with dozens of outputs depending on platforms or user options (and many software out there are this way).</p>
<h3>Pass through files</h3>
<p>Variables, constants&hellip; they all have limitations imposed by the language: they cannot get out of a file, a module, a class, etc. That&rsquo;s good. That&rsquo;s one reason why we use a strict language: to have better control of what we want in and out.</p>
<p>Macros on the other hand are not controlled by the language. They have their own syntax and are managed by the preprocessor. It means they usually pass files. As I could not find any documentation on this point for Camlp4, I made some tests and I can gladly say <em>pa_macro</em> hasn&rsquo;t got this issue, but I will explain it as general information about macros.</p>
<p>Let&rsquo;s suppose that I create a ZERO macro (which I did) to be worth either the integer <em>0</em> or the Int32 <em>0l</em>. In a further file, I might make some day another ZERO, which is actually not a macro, but some constructor and I completely forgot that I had this macro set. Then it is replaced at compilation time by the macro value and fails; or worse, for some reason the replacement is a correct or possible type, it compiles, but later it fails at runtime making it difficult to diagnose.</p>
<p>Fortunately <em>pa_macro</em>&lsquo;s macros do not get out of files (external files of macros must be explicitly INCLUDEd). But the issue can still occur from command-line macros.</p>
<p>So if some of them are supposed to be global with specific name (like ARCH_64), it is usually ok. But if ever you were passing macros on the command line with very generic names, that you wanted to be used only in a single module, it might become a problem.</p>
<h3> Comparison to Runtime tests</h3>
<p>Some people oppose the macro solution to in-code conditional tests.<br/>
But this has flaws too:</p>
<h4>Code forbidden</h4>
<p>I told it, sometimes some code is forbidden on some platform. For instance if my very big integer constant was to make it up to the compiler, it would fail to compile (and this time, with a good reason). In such cases, runtime tests are impossible.</p>
<h4>Performance</h4>
<p>Why I made a conditional compilation was because logical computation on int was faster than on Int32, but I could not use int on a 32 bits platform (Ocaml has 31 bits int on 32 bits). So even supposing it were possible to do runtime condition tests (but it&rsquo;s not as I demonstrated in the previous point), doing so would impact performance for no reason while I was doing it for the opposite reason! Fully interpreted language have no other solutions, whereas we use a compiled language. So let&rsquo;s make good use of the tools we are given.</p>
<h4>Code clarity</h4>
<p>Sometimes heavy use and/or bad use of macros can lead to very obscure code. But it can also lead to clearer code when well used.</p>
<p>For instance my example above avoids any code duplication with many conditional everywhere.<br/>
I think we will agree that having only this:<br/>
<code>let rem = TO_INT (LOGAND div OCTET) in</code><br/>
is far nicer than something like this:</p>
<pre>
let rem =
  if arch_64
  then
    div land 0xFFFFFFFF
  else
    Int32.to_int (Int32.logand div 0xFFFFFFFFl)
  in
</pre>
<p>The first code is factorized and the whole logics of conditional is hidden in the macros which are simply switched at compilation time. Moreover if I change my code, I need to change only one line instead of 2 (code duplication is a common source of bug when we fix something only at one place while the same code is copied over somewhere else).</p>
<h2>Alternate Solutions</h2>
<p>Other solutions exist to run different piece of code in different cases. Nearly none of them are all good or all bad, they may depend mostly on use case.</p>
<h3>Again runtime tests</h3>
<p>Yes it strikes again! Though I seem to have said a lot of bad things of it, it is still a pretty good solution in many cases.<br/>
In particular, if you want to be able to switch behavior as often as you wish, it is far better to make it runtime.</p>
<p>Debug for instance is a common feature which you can see either set as a compilation option or a runtime. Making it runtime allows you to never have debug but when you want it, you just switch a &ldquo;-debug&rdquo; option.<br/>
Note that if you have a lot of debug set in your program, it means there will be a lot of useless tests on the boolean value of some debug variable (<code>if debug then</code>). I told that&rsquo;s a slight performance issue maybe not suitable for all use. A common solution is then to have debug both compilation AND runtime. At compilation, you can decide whether or not you have the &ldquo;-debug&rdquo; option, and if not, all tests won&rsquo;t be compiled.</p>
<h3>Makefile</h3>
<p>The Makefile can deal with selecting between 2 files which have a different implementation of a single feature. Then depending on the platform, it can compile against one or the other implementation.<br/>
The advantage is obvious: 2 files completely not encumbered with macros or conditional code of anysort (neither preprocessing code, nor runtime code). The drawback is that you may have code duplication (unless the 2 implementations are actually very different logics, which can happen).</p>
<h3>Code generation</h3>
<p>Another solution is code generation, which is often some kind of code completion. This is actually a logic close to the macro logic. A common tool is <strong>autoconf</strong>, which replaces variables on the fly. You can often see some code with <code>@VERSION@</code> in it. These are usually variables replaced by autoconf before compilation (check for AC_SUBST and AC_CONFIG_FILES in autoconf documentation). Though this is a pretty useless example, this kind of behavior can be pretty well extended to generate conditional code depending on a platform in a way similar to what the macros did in my example.</p>
<p>To get the full power of autoconf, think of how it generates a full Makefile from some very basic template.</p>
<h3>Camlp4</h3>
<p>I described the easy way with Camlp4, which is using the existing pa_macro. But of course if that&rsquo;s not enough for you, you can write your own macro grammar.</p>
<h2>Conclusion</h2>
<p>So we saw that conditional compilation can be good for several reason, among them optimization, or even portability when no common code exist to do a single action between 2 platforms.<br/>
But as all good things, it must be used parsimoniously. In particular:</p>
<ul>
<li>Is optimization always necessary? My example was a cryptographic example, the kind of code which can be run thousands of time every seconds in some kind of software and where the gain of speed can be from 1 to 1000 depending on the implementation. Optimization can be critical on cryptography algorithms.<br/>
On other kind of feature, <strong>when you have a piece of code that you will run only once in a while, it is unconditionally better to have a very readable code than a fast and complicated one</strong>, even more if the gain in time you would obtain with optimization is so small that none will make the difference when it is run once every hour.</li>
<li>When portability is the goal, <strong>aim rather for generic code than for conditional compilation</strong>. So your current code is platform specific? Before looking for the equivalent platform-specific code in that other platform you support, try to look if there does not exist a generic code which works on both.</li>
<li>So there is no generic code possible? Optimization is too critical here? Or else the generic code exists but makes thing more ugly/complicated or bring other issues? Fine, conditional compilation is for you. But try to <strong>encapsulate it</strong> in a single file. If this is for a function you&rsquo;ll want to use in many places, then place this function in its own file and hide any conditional compilation there so that it is seen as a black box. Once done, you won&rsquo;t have to worry a single bit anymore about how it actually works. Doing this makes the &ldquo;parallel logical code&rdquo; much less an issue.</li>
</ul>
<p>It is sad Ocaml does not advertize better some &ldquo;easy&rdquo; solution for this kind of use case. But multiple solutions still exist and they are not that difficult, as long as there is some documentation.<br/>
So I hope my little ticket here will help other people to write great program in Ocaml (or whatever other language, as long as your program is great&hellip; and Free&hellip; as in Free Speech!).</p>

