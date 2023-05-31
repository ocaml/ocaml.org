---
title: Implementing the PowerPC backend for BAP - Part 0
description: The Binary Analysis Platform Blog
url: http://binaryanalysisplatform.github.io/powerpc-intro
date: 2017-10-13T00:00:00-00:00
preview_image:
featured:
authors:
- bap
---

<p>On this week we started to work on the PowerPC backend. We are
planning a series of blog posts that will describe the process and
probably will help others, who will pursue the task of implementing a
backend for BAP, by either suggesting the right way or discouraging by
showing an example of how one shouldn&rsquo;t do this.</p>

<p>As you may know, BAP is a platform for program analysis that works
with compiled binaries. In a sense, BAP is dual to a compiler, since
we move in the opposite direction &ndash; we start with the binary code,
and then go to the Intermediate Representation (IR). The same as in
compilers we perform analysis on the IR level, and we also need a
backend support that will connect IR with the actual instruction set
(ISA). The only difference, is that compiler developers need to
implement the translation from IR to assembler, while we need the
translation in the opposite direction. Its actually a little bit
harder, as IR is usually smaller than the instruction set and a
compiler developer has a benefit of choosing the subset of ISA on
which he will map IR instructions. We do not have this luxury as we
are required to support all instructions. Even those that are not
emitted by any compiler, can still be encoded manually (especially
someone with malicious intensions). Another source of complexity, is
that we need to implement the translation that is much more precise,
in fact it should be totally precise, as we need to represent all
effects that occur in a CPU. So we need to represent all updates to
the status registers and other side effects, that are usually of no
interest to compiler developers.</p>

<p>In BAP we actually do not use the &ldquo;backend&rdquo; word, when we referring a
piece of code, that implements the support for a particular
instruction set. We use the word &ldquo;lifter&rdquo;, since we are lifting
assembly instructions into the intermediate representation. So, from
now on we will use term lifter. Basically, a lifter is a function,
that takes the assembly instruction and returns a list of BIL
statements that describe the semantics of the instruction. The BIL
language is a very simple register transfer language, that is explicit
and self contained, with the <a href="https://github.com/BinaryAnalysisPlatform/bil">formally specified semantics</a>. We
will not go deep into the discussion of BIL here (maybe we should
dedicate a separate post to BIL), but if you want to read more about
intermediate representations that are used in binary analysis and
reverse engineering, then the <a href="https://softsec.kaist.ac.kr/~soomink/paper/ase17main-mainp491-p.pdf">this paper</a> has a nice
overview. It also emphasizes how hard it is to write a lifter.</p>

<p>So far, we have three lifters in BAP &ndash; the legacy x86 lifter, that
was written long time ago, the modern x86 lifter, and the ARM
lifter. And we would like to admit, the we are not happy with all of
them. Neither of them satisfy our goals - to be easily extensible,
readable, and fixable. Whenever we find an error in the lifter it is a
disaster for our team, not only because it means that our testing
infrastructure missed the bug, but because fixing the bug is a
nightmare. So the question, that we are asking ourselves is: should it
be that bad? Is the task of emitting the BIL pseudocode that hard, so
that the code complexity is inevitable? We are approaching the new
lifter with the strong opinion that it is not that hard. That the code
can be simple and understandable even by someone who is not fluent in
OCaml. So keep in touch and feel free to join the discussion on our
<a href="https://gitter.im/BinaryAnalysisPlatform/bap">Gitter channel</a> or even to contribute the code.</p>


