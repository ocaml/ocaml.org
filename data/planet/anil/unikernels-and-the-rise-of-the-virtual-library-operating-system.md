---
title: Unikernels, and the Rise of the Virtual Library Operating System
description: Unikernels and virtual library operating systems are on the rise, changing
  the face of cloud computing.
url: https://anil.recoil.org/notes/unikernels-in-cacm
date: 2014-01-13T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<p>The Communications of the ACM have just published an article that <a href="https://github.com/djs55" class="contact">Dave Scott</a> and I wrote providing a broader background on the concept of <a href="http://anil.recoil.org/papers/2013-asplos-mirage.pdf">Unikernels</a> that we’ve been working on since about 2003, when we started building <a href="http://anil.recoil.org/papers/2007-eurosys-melange.pdf">Melange</a> and the <a href="http://anil.recoil.org/papers/2010-icfp-xen.pdf">Xen toolstack</a>. You can read either the <a href="http://cacm.acm.org/magazines/2014/1/170866-unikernels">print article</a> (requires an ACM subscription) or the <a href="http://queue.acm.org/detail.cfm?id=2566628">open access version</a> on the ACM Queue.</p>
<p></p><figure class="image-right"><img src="https://anil.recoil.org/images/acm-queue-unikernels-ss.webp" loading="lazy" class="content-image" alt="" srcset="/images/acm-queue-unikernels-ss.1024.webp 1024w,/images/acm-queue-unikernels-ss.320.webp 320w,/images/acm-queue-unikernels-ss.480.webp 480w,/images/acm-queue-unikernels-ss.640.webp 640w,/images/acm-queue-unikernels-ss.768.webp 768w" title="" sizes="(max-width: 768px) 100vw, 33vw"><figcaption></figcaption></figure>

There's been some interesting discussion about it already online:<p></p>
<ul>
<li>On <a href="http://www.reddit.com/r/programming/comments/1upy41/mirage_os_10_released_last_december/">Reddit</a>, a number of queries about how it fits into the space of containers, microkernels, and other experimental operating systems.</li>
<li>Coverage from <a href="http://www.eweek.com/cloud/xen-project-builds-its-own-cloud-os-mirage.html">eWeek</a>, <a href="http://www.infoworld.com/t/operating-systems/xen-mirage-the-less-more-cloud-os-233823">InfoWorld</a>, and <a href="http://www.linux.com/news/enterprise/cloud-computing/751156-are-cloud-operating-systems-the-next-big-thing">Linux.com</a>, and a couple of interviews on InfoQ covering <a href="http://www.infoq.com/news/2013/12/mirageos">Mirage</a> and my <a href="http://www.infoq.com/articles/real-world-ocaml-interview">book on OCaml</a> that give more background on the project.</li>
</ul>
<p>Two of the most interesting bits of feedback for me personally came from <a href="http://en.wikipedia.org/wiki/Butler_Lampson">Butler Lampson</a> (via Jon Crowcroft) and <a href="http://www.cs.cmu.edu/~rwh/">Robert Harper</a>, two computer scientists who have made key contributions to operating systems and programming languages and provided some broader perspective.</p>
<p>Butler Lampson points out (edited for the web):</p>
<blockquote>
<p>I found the Mirage work quite interesting: a 21st-century version of things that we did at Xerox in the 1970s. Of course, the application domain is quite different, and so is the whole-program optimization. And we couldn’t afford garbage collection, so freeing storage was not type-safe. But there are lots of interesting parallels.</p>
<p>The “OS as libraries” idea was what made it possible to fit big applications into the Alto’s 128k bytes of memory:</p>
<p><em>Lampson and Sproull</em>, <a href="http://research.microsoft.com/pubs/68223/acrobat.pdf">An open operating system for a single-user machine</a>, ACM Operating Systems Rev. 11, 5 (Dec. 1979), pp 98-105. <a href="http://dl.acm.org/citation.cfm?id=800215.806575">ACM</a>.</p>
<p>The use of strong type-checking and interfaces for an OS was pioneered in [Mesa](http://en.wikipedia.org/wiki/Mesa_(programming_language%29) and [Pilot](http://en.wikipedia.org/wiki/Pilot_(operating_system%29):</p>
<p><em>Lauer and Satterthwaite</em>, <a href="http://dl.acm.org/citation.cfm?id=802937">The impact of Mesa on system design</a>, Proc. 4th ICSE, Munich, Sep. 1979, pp 174-182.</p>
<p><em>Redell et al</em>, <a href="http://web.cs.wpi.edu/~cs502/s06/Papers/Redell,%20Pilot%20Operating%20System.pdf">Pilot: An Operating System for a Personal Computer</a>, Comm. ACM 23, 2 (Feb 1980), pp 81-92 (from 7th SOSP, 1979). <a href="http://dl.acm.org/citation.cfm?id=358818.358822&amp;coll=DL&amp;dl=ACM&amp;CFID=396678249&amp;CFTOKEN=51329799">ACM</a>.</p>
</blockquote>
<p>Robert Harper correctly points out some related work that was missing from our CACM article:</p>
<ul>
<li><a href="http://www.cs.cmu.edu/~fox/foxnet.html">FoxNet</a> is an implementation of the standard TCP/IP networking protocol stack using the <a href="http://en.wikipedia.org/wiki/Standard_ML">Standard ML</a> (SML) language. It was part of a wide-reaching project at CMU in the 1990s that made seminal contributions in <a href="http://www.cs.cmu.edu/~fox/pcc.html">proof-carrying code</a> and <a href="http://www.cs.cmu.edu/~fox/til.html">typed intermediate languages</a>, among <a href="http://www.cs.cmu.edu/~fox/publications.html">many other things</a>. The FoxNet stack was actually one of my big inspirations for wanting to build Mirage since the elegance of using functors as a form of dependency injection into a system as complex as an OS and application stack is very desirable and the reason we chose to build Mirage in ML instead of another, less modular, language.</li>
<li>Ensemble (website now offline but here’s a <a href="http://www.cs.uni-potsdam.de/ti/kreitz/PDF/99sosp-fastpath.pdf">SOSP 1999 paper</a>) is a group communication system written in OCaml, developed at Cornell and the Hebrew University. For an application builder, Ensemble provides a library of protocols that can be used for quickly building complex distributed applications. For a distributed systems researcher, Ensemble is a highly modular and reconfigurable toolkit: the high-level protocols provided to applications are really stacks of tiny protocol “layers,” each of whose can be modified or rebuilt to experiment.</li>
</ul>
<p>Both Ensemble and FoxNet made strong echoes throughout the design of Mirage (and its precursor software such as <a href="http://anil.recoil.org/papers/2007-eurosys-melange.pdf">Melange</a> in 2007). The <a href="http://openmirage.org/wiki/hello-world">Mirage command-line tool</a> uses staged computation to build a concrete application out of functors, and we are making this even more programmable via a new <a href="https://github.com/mirage/mirage/pull/178">combinator-based functor types</a> library that <a href="http://gazagnaire.org/">Thomas Gazagnaire</a> built, and also experimenting with <a href="https://github.com/ocamllabs/higher">higher kinded polymorphic</a> abstractions.</p>
<p>My thanks to Butler Lampson and Robert Harper for making me go re-read their papers again, and I’d like to leave you with Malte Schwarzkopf’s <a href="http://www.cl.cam.ac.uk/~ms705/netos/os-reading-group.html">OS Reading Group</a> papers for other essential reading in this space. Many more citations immediately relevant to Mirage can also be found in our <a href="http://anil.recoil.org/papers/2013-asplos-mirage.pdf">ASPLOS 2013</a> paper.</p>

