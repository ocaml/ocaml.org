---
title: Java Concurrency Annotations
description: "I\u2019ve been reading a series of papers by Chandrasekhar Boyapati
  on extensions to the Java type system. I found his papers on ensuring race-free
  programs by specifying that objects are either i\u2026"
url: https://mcclurmc.wordpress.com/2010/02/12/java-concurrency-annotations/
date: 2010-02-12T20:21:54-00:00
preview_image: https://s0.wp.com/i/blank.jpg
featured:
authors:
- mcclurmc
---

<p>I&rsquo;ve been reading a series of papers by <a href="http://www.citeulike.org/user/mcclurmc/author/Boyapati:C">Chandrasekhar Boyapati</a> on extensions to the Java type system. I found his papers on ensuring race-free programs by specifying that objects are either immutable thread local, or referenced by a unique pointer. There&rsquo;s also the paper <a href="http://www.citeulike.org/user/mcclurmc/article/6658634">A Type and Effect System for Deterministic Parallel Java</a>, from OOPSLA 2009. I&rsquo;m fascinated by the idea of creating a type system that could ease the burden of writing threaded program, and this seems like a really promising idea to me.</p>
<p>I&rsquo;d like to combine this approach to concurrency with <a href="http://www.citeulike.org/user/mcclurmc/article/6658568">Hybrid Type Checking</a>. While I&rsquo;d prefer to do as much at compile time as possible, I have a suspicion that we&rsquo;ll always need to do some locking and unlocking at compile time, and that a system using both static types and runtime contracts might be our best bet.</p>
<p>I&rsquo;m taking a stab at implementing these ideas in Java &mdash; but instead of modifying the compiler itself, I&rsquo;ll be writing an annotation processor that will run before the compiler. The idea is that we could extend the Java type system using annotations. We could even go so far as to generate code at compile time that could do either runtime contract checking, or even lock and thread management. This is similar to the project <a href="http://sourceforge.net/projects/jdefprog/">Java Defensive Programming</a>. If I can get this project off the ground, I&rsquo;ll have to see if Federico would like to incorporate some of my code in his project.</p>

