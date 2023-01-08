---
title: 'Engineer Spotlight: Jules Aguillon'
description: "In celebration of the OCaml 5 release, we decided to interview a few
  of our talented engineers about OCaml. While it isn't a well-known\u2026"
url: https://tarides.com/blog/2022-12-29-engineer-spotlight-jules-aguillon
date: 2022-12-29T00:00:00-00:00
preview_image: https://tarides.com/static/a61d6759d838bc618680795eecdc2a88/c030c/image4Jules.jpg
featured:
---

<p>In celebration of the OCaml 5 release, we decided to interview a few of our talented engineers about OCaml. While it isn't a well-known language outside of the functional programming community, we're striving to get the word out about the great benefits of OCaml and why it's worth your time to try it out, especially with the introduction of <a href="https://tarides.com/blog/2022-12-19-ocaml-5-with-multicore-support-is-here">Multicore support in OCaml 5</a>.</p>
<p>KC Sivaramakrishnan's inspiring <a href="https://www.youtube.com/watch?v=zJ4G0TKwzVc">keynote address</a> is a great introduction to OCaml 5 and all it offers. Check out the <a href="https://speakerdeck.com/kayceesrk/retrofitting-concurrency-lessons-from-the-engine-room">speaker deck</a> as well.</p>
<p>Today our engineer Jules Aguillon, who works primarily on our OCaml Platform tooling project, talks about his journey to OCaml, what he enjoys about the language, and why he thinks you should learn it! Take it away Jules!</p>
<hr/>
<p><strong>Christine: How did you start programming?</strong></p>
<p>Jules: My programming journey began with learning C in school, but I soon realised I wanted more abstraction. It felt like the C code was always talking about low-level stuff instead of what I wanted to express. In C, translations are a lot of work and get harder as the algorithm becomes more complex. Things like ASTs and polymorphic datastructures are also really hard to write in C.</p>
<p>Some of the ways C works are not so innocent, it supports the kinds of dangerous memory operations that <a href="https://www.zdnet.com/article/microsoft-70-percent-of-all-security-bugs-are-memory-safety-issues/">famously cause 70% of all security bugs</a> in some big corporations.</p>
<p><strong>C: What did you do to get that abstraction that you were looking for?</strong></p>
<p>J: I decided to learn C++, which is C but with classes (grouping code and data together), abstracted memory operations (making them safer by default), and more type checking.</p>
<p>But I quickly found that C++ also wasn't a good fit, mainly due to its use of boilerplate. Boilerplate refers to pieces of code that must be repeated in various places without significant change, wrapping around every concept you try to express in C++. They are used to represent several complicated concepts, and any mistake in the boilerplate could bring things like memory unsafety back. I wanted to abstract this away, too.</p>
<p><strong>C: What did you do next?</strong></p>
<p>J: To finally write shorter and safe code, I tried Python. It was a joy to use compared to the previous unsafe and verbose C and C++. The garbage collector solved the memory-unsafety problems, and the built-in datastructures and idioms allowed me to write many complex algorithms using only a small amount of code.</p>
<p>But Python has a dark side: it entirely lacks static type checking. This means that it requires considerable effort to find a type-related mistake. The only way is to run the program with different inputs and wait until it crashes. This gets really annoying as the program grows.</p>
<p>Furthermore, this kind of mistake happens all the time (sometimes once in every line of code!) and could be entirely solved by a type checker.</p>
<blockquote>
<p>&quot;For me, this is already the perfect language and it doesn't stop there!&quot;</p>
</blockquote>
<p><strong>C: Is this where OCaml comes in?</strong></p>
<p>J: Yes! Then I learned OCaml! It's unconditionally memory-safe, has a garbage collector, the code is concise, many kinds of abstractions are possible, and most importantly, it has well-defined and powerful type checking.</p>
<p>For me, this is already the perfect language and it doesn't stop there! Modules, polymorphism, and higher-order functions all add deep abstraction possibilities, and there's even a more important feature. Variant types allow types to have different shapes and write tree-looking things like ASTs (abstract syntax trees) that are impossibly hard to express in all the languages above and many others that I have tried.</p>
<p>Theoreticians talk about algebra of types, and this is the &quot;plus&quot; operation. Now that I've used it in OCaml, I could never go back to a language that doesn't have the &quot;plus&quot; operation!</p>
<hr/>
<p>A big thank you to Jules for taking the time to speak about his experience with OCaml. Getting a personal account of why he chose OCaml gives great insight into the strengths and features of the language from someone who uses it every day.</p>
<p>If you're interested in learning more about OCaml you can learn from <a href="https://ocaml.org/docs">tutorials</a>, the <a href="https://www.cambridge.org/core/books/real-world-ocaml-functional-programming-for-the-masses/052E4BCCB09D56A0FE875DD81B1ED571">Real World OCaml book</a>, and contribute <a href="https://github.com/ocaml/ocaml">on Github</a>. We look forward to seeing you in the community!</p>
