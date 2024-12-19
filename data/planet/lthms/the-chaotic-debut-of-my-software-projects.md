---
title: The Chaotic Debut of My Software Projects
description: "I am no stranger to the exciting feeling of starting new projects. By
  dint of repeating this \u201Cexercise\u201D over the years, I have come to build
  an intuitive process which \u201Cworks for me.\u201D"
url: https://soap.coffee/~lthms/posts/ChaoticDebut.html
date: 2023-05-29T00:00:00-00:00
preview_image: https://soap.coffee/~lthms/img/thinking.png
authors:
- "Thomas Letan\u2019s Blog"
source:
---


        
        <h1>The Chaotic Debut of My Software Projects</h1><div><span class="icon"><svg><use href="/~lthms/img/icons.svg#tag"></use></svg></span>&nbsp;<a href="https://soap.coffee/~lthms/tags/opinions.html" marked="" class="tag">opinions</a> </div>
<p>I am no stranger to the exciting feeling of starting new projects. By dint of
repeating this “exercise” over the years, I have come to build an intuitive
process which works for me. In this write-up, I want to give a try at
describing it, both for future references and in the hope that this might start
interesting conversations. I am curious to know whether or not my personal
“process” is shared with some of my fellow developers, though I would be
surprised if it weren’t the case, since there is nothing particularly clever or
revolutionary with what I am about to write.</p>
<h2>A Story in Two Acts</h2>
<p>In a nutshell, I can often divide the early days of my software projects into
two phases: the <em>exploration phase</em> and the <em>rationalization phase</em>.</p>
<p>The starting point of the exploration phase is a <em>need</em>, and a direction I want
to take to address this need. For instance, the starting point of the
<a href="https://ocaml.org/p/data-encoding/latest/doc/Data_encoding/V1/Encoding/Compact/" marked=""><code class="hljs">Compact</code> module of
<code class="hljs">data-encoding</code>&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a>
was the need to encode in bytes arbitrary values, and the direction was to do
that with <code class="hljs">data-encoding</code>. For <a href="https://github.com/lthms/spatial-shell" marked="">Spatial
Shell&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a>, I wanted badly to enjoy
<a href="https://material-shell.com/" marked="">Material Shell&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a>’s user experience without having
to switch to Gnome 3 and the direction was set when I discovered <a href="https://man.archlinux.org/man/sway-ipc.7.en" marked="">sway’s RPC
protocol&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a>.</p>
<p>The goal of the exploration phase is for me to turn the direction into a
destination, so to speak. When I start, my knowledge of both the problem I want
to solve and the solution I am trying to build is vague, and needs refinement.
There are intuitions I need to challenge, APIs I need to learn, boilerplate I
need to understand. More often than not, this phase is messy. Commits are not
nice, standalone units of changes: it is way too early for that. I use Git
merely as a way to throw away a dead-end, and resume exploring down another
path from a reasonable save point. I put most if not all my code into one file,
I don’t write comments, encapsulation and abstraction become foreign words I
forget about for a while. My goal is to come up with a prototype which captures
the key features I am looking for, and to learn as much as possible in the
process. This exploration phase shouldn’t last too long, because it is very
context sensitive. If I am interrupted long enough, I am likely to lose the
mental map of my messy code, and to forget the key insights I was learning
while navigating it.</p>
<p>I want to emphasis that the exploration phase should definitely touch to the
mundane, boring things like the CLI, the decoding of configuration files, the
encoding of persistent states, etc. These things tend to have a pervasive
impact on the rest of a software development if they are not taken into account
early. Because I am confronting myself to these forbidding parts, I am forced to understand the
pain points they will bring, and to plan for them.</p>
<p>At some point, most of my questions have found their answers, and I am starting
to tackle features which go beyond the scope of the minimal set of features I
was initially after. When this time comes, friction is starting to appear
because of the bad quality of the codebase. All the shortcuts are coming back
to bite me and slow me down, while wild bugs enjoy the lack of invariant
enforcement and multiply.</p>
<p>This is actually a good sign: the exploration is over, and before going any
further, it is time for me to take a step back and <em>rationalize</em>.</p>
<p>The rationalization phase is the unique opportunity to “learn what I have
learned,” by revisiting every line of the code you have written, challenge it,
and hopefully come up with a solution for its most outstanding issues. I do
that by splitting up the monolithic that came out of the exploration phase into
a sane, navigable hierarchy of modules with clear, manageable APIs. This allows
me to fine-tune the design, to tweak the parts of the API exposed to the users
(the “boring parts” I mention for the exploration phase), and to remove any
dead code I thought might be useful or needed, but actually didn't cut it to the
prototype.</p>
<p>This second phase often feels like a sprint. The second I am throwing myself at
it, the project stops working, and most of the time, it won’t even fully
compile before I’m actually done. This sometimes feels a bit overwhelming,
though the use of strongly typed programming language like OCaml or Rust has
proven to be of tremendous help, at least as long as I stick to moving code
around, and only amending it at the margin. Clearly, types and compile-time type
checking are my allies during what I often experience as a long snorkeling
session.</p>
<p>When I’m done, I get my prototype working again, except it does not feel like a
prototype anymore. The feature set is the same, as is the user experience. But
the developer experience is totally different. I can now enjoy a codebase where
separation of concerns, encapsulation and abstraction play their rightful
roles, and allow me to reason about my software project more easily. This is
also the moment where I can slow down a bit, since it is no longer required for
me to keep the whole project architecture in my head. To a large extent, the
module hierarchy does that for me.</p>
<h2>Random Thoughts</h2>
<p>To me, this process feels a bit like a craft. I think I have become better at going
through it after every project I successfully bring at the end of the
rationalization phase. And I often feel a bit at lost when I am involved in a
project which does not follow this general approach.</p>
<p>That being said, I have to admit it does not scale very well. If the whole
process does not fit in something like a week, then I will likely run out of
motivation before reaching stable grounds. For instance, the rationalization
phase often one to two days, during which I am basically stuck to my computer
for long hours.</p>
<p>Finally, this process does not leave a lot of room for collaborating with other
developers. This is true both for the exploration phase (the “codebase” is
still a monolithic file that is partially rewritten over and over) and for the
rationalization phase (sometimes it feels like I am “discovering” the correct
way to organize the codebase while I organize it). However, collaboration
becomes possible (and even very rewarding) after the fact, when the codebase
“makes sense.”</p>
<p>I guess it depends on the tradeoffs one is willing to make when starting a
project, the size and scale of the project, and the software developers and
entities involved.</p>
        
      
