---
title: MirageOS Summer 2016 hack retreat announcement, and talk roundup
description:
url: https://mirage.io/blog/2016-summer-hackathon
date: 2016-06-29T00:00:00-00:00
preview_image:
featured:
authors:
- Gemma Gordon
---


        <p>As summer starts to shine over an obstinately rainy England, we are organising
the second MirageOS hack retreat in Cambridge!  It will be held on <strong>Weds 13th
July</strong> at the lovely <a href="https://www.darwin.cam.ac.uk">Darwin College</a> from
9am-11pm, with snacks, teas, coffees and a servery lunch provided (thanks to
sponsorship from <a href="http://docker.com">Docker</a> and <a href="https://ocaml.io">OCaml Labs</a>).</p>
<p><strong>Anyone is welcome at all skill levels</strong>, but we'd appreciate you filling out the
<a href="http://doodle.com/poll/ngbbviwyb9e65uiw">Doodle</a> so that we can plan
refreshments.  We will be working on a variety of projects from improving ARM
support, to continuous integration tests, the new Solo5 backend and improving
the suite of protocol libraries.  If you have something in particular that
interests you, please drop a note to the <a href="https://mirage.io/community">mailing list</a> or check
out the full list of <a href="https://github.com/mirage/mirage-www/wiki/Pioneer-Projects">Pioneer Projects</a>.</p>
<p>Some other events of note recently:</p>
<ul>
<li>
<p>After several years of scribing awesome notes about our development, Amir has handed over the reigns to <a href="https://github.com/engil">Enguerrand</a>.
Enguerrand joined OCaml Labs as an intern, and has built an IRC-to-Git logging bot which records our meetings over IRC and commits them
directly to a <a href="https://github.com/hannesm/canopy-data">repository</a> which is <a href="http://canopy.mirage.io/irclogs">available online</a>.  Thanks Amir
and Enguerrand for all their hard work on recording the growing amount of development in MirageOS.  <a href="https://ocaml.io/w/User:GemmaG">Gemma Gordon</a>
has also joined the project and been coordinating the <a href="https://github.com/mirage/mirage-www/wiki/Call-Agenda">meetings</a>.  The next one is in a
few hours, so please join us on <code>#mirage</code> on Freenode IRC at 4pm British time if you would like to participate or are just curious!</p>
</li>
<li>
<p>Our participation in the <a href="https://wiki.gnome.org/Outreachy/2016/MayAugust">Outreachy</a> program for 2016 has begun, and the irrepressible
<a href="http://www.gina.codes">Gina Marie Maini</a> (aka <a href="http://twitter.com/wiredsis">wiredsister</a>) has been hacking on syslogd, mentored by <a href="http://somerandomidiot.com">Mindy Preston</a>.
She has already started blogging (<a href="http://www.gina.codes/ocaml/2016/06/06/syslog-a-tale-of-specifications.html">about syslog</a> and <a href="http://www.gina.codes/ocaml/2016/02/14/dear-ocaml-i-love-you.html">OCaml love</a>), as well as <a href="http://hanselminutes.com/531/living-functional-programming-with-ocaml-and-gina-marie-maini">podcasting with the stars</a>.  Welcome to the crew, Gina!</p>
</li>
<li>
<p>The new <a href="https://docs.docker.com/engine/installation/mac/">Docker for Mac</a> and <a href="https://docs.docker.com/engine/installation/windows/">Docker for Windows</a> products have entered open beta! They use a number of libraries from MirageOS (including most of the network stack) and provide a fast way of getting started with containers and unikernel builds on Mac and Windows.  You can find talks about it at the recent <a href="https://ocaml.io/w/Blog:News/FP_Meetup:_OCaml,_Facebook_and_Docker_at_Jane_Street">JS London meetup</a> and my <a href="http://www.slideshare.net/AnilMadhavapeddy/advanced-docker-developer-workflows-on-macos-x-and-windows">slides</a>  I also spoke at OSCON 2016 about it, but those videos aren't online yet.</p>
</li>
</ul>
<p>There have also been a number of talks in the past couple of months about MirageOS and its libraries:</p>
<ul>
<li><a href="http://researcher.watson.ibm.com/researcher/view.php?person=us-djwillia">Dan Williams</a> from IBM Research delivered a paper at <a href="https://www.usenix.org/conference/hotcloud16/workshop-program/presentation/williams">USENIX HotCloud 2016</a> about <a href="https://www.usenix.org/system/files/conference/hotcloud16/hotcloud16_williams.pdf">Unikernel Monitors</a>. This explains the basis of his work on <a href="https://mirage.io/blog/introducing-solo5">Solo5</a>, which we are currently integrating into MirageOS as a KVM-based boot backend to complement the Xen port.  You can also find his <a href="https://www.usenix.org/sites/default/files/conference/protected-files/hotcloud16_slides_williams.pdf">talk slides</a> online.
</li>
<li><a href="https://twitter.com/amirmc">Amir Chaudhry</a> has given several talks and demos recently: check out his slides and detailed
writeups about <a href="http://amirchaudhry.com/gluecon2016">GlueCon 2016</a> and <a href="http://amirchaudhry.com/craftconf2016">CraftConf 2016</a> in particular,
as they come with instructions on how to reproduce his Mirage/ARM on-stage demonstrations of unikernels.
</li>
<li><a href="https://twitter.com/sgrove">Sean Grove</a> is speaking at <a href="http://polyconf.com">Polyconf 2016</a> next week in Poland.  If you are in the region, he would love to meet up with you as well -- his talk abstract is below
</li>
</ul>
<blockquote>
<p>With libraries like Mirage, <code>js_of_ocaml</code>, &amp; ARM compiler output OCaml apps can operate at such a low level
we don't even need operating systems on the backend anymore (removing 15 <em>million</em> lines of memory-unsafe code)</p>
<ul>
<li>while at the same time, writing UI's is easier &amp; more reliable than ever before, with lightweight type-checked
code sharing between server, browser clients, &amp; native mobile apps. We'll look at what's enabled by new tech
like Unikernels, efficient JS/ARM output, &amp; easy host interop.
</li>
</ul>
</blockquote>

      
