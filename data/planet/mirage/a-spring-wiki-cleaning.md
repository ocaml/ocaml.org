---
title: A Spring Wiki Cleaning
description:
url: https://mirage.io/blog/spring-cleaning
date: 2011-04-11T00:00:00-00:00
preview_image:
featured:
authors:
- Anil Madhavapeddy
---


        <p>We've been plugging away on Mirage for the last few months, and things are starting to take shape nicely. As the older blog entries were out-of-date, we have shifted the descriptive material to a new <a href="https://mirage.io/wiki">wiki</a> section instead. What else has been happening?</p>
<ul>
<li>The Xen unikernel backend is fully event-driven (no interrupts) and very stable under stress testing now. The TCP stack is also complete enough to self-host this website, and you can try it out by navigating to <a href="http://xen.openmirage.org">xen.openmirage.org</a>. The stack doesnt actually do retransmissions yet, so your user experience may &quot;vary&quot;. Check out the <a href="https://mirage.io/wiki/install">installation</a> and <a href="https://mirage.io/wiki/hello-world">hello world</a> guides to try it out for yourself.
</li>
<li><a href="http://www.cs.nott.ac.uk/~rmm/">Richard Mortier</a> has put together a performance testing framework that lets us analyse the performance of Mirage applications on different backends (e.g. UNIX vs Xen), and against other conventional applications (e.g. BIND for DNS serving). Read more in the wiki <a href="https://mirage.io/wiki/performance">here</a>.
</li>
<li><a href="http://gazagnaire.org">Thomas Gazagnaire</a> has rewritten the website to use the COW syntax extensions. He has also started a new job with <a href="http://www.ocamlpro.com/">OCamlPro</a> doing consultancy on OCaml, so congratulations are in order!
</li>
<li>Thomas has also started integrating experimental Node.js support to fill in our buzzword quota for the year (and more seriously, to explore alternative VM backends for Mirage applications).
</li>
<li>The build system (often a bugbear of such OS projects) now fully uses <a href="https://github.com/ocaml/ocamlbuild">ocamlbuild</a> for all OCaml and C dependencies, and so the whole OS can be rebuilt with different compilers (e.g. LLVM) or flags with a single invocation.
</li>
</ul>
<p>There are some exciting developments coming up later this year too!</p>
<ul>
<li><a href="https://github.com/raphael-proust">Raphael Proust</a> will be joining the Mirage team in Cambridge over the summer in an internship.
</li>
<li>Anil Madhavapeddy will be giving several <a href="https://mirage.io/wiki/talks">tech talks</a> on Mirage: at the <a href="https://forge.ocamlcore.org/plugins/mediawiki/wiki/ocaml-meeting/index.php/OCamlMeeting2011">OCaml User's Group</a> in Paris this Friday, at <a href="http://acunu.com">Acunu</a> in London on May 31st, and at Citrix Cambridge on June 3rd. If you are interested, please do drop by and say hi.
</li>
<li>Verisign has supported the project with an <a href="http://www.marketwire.com/press-release/Verisign-Announces-Winners-of-Grants-Aimed-at-Strengthening-Internet-Infrastructure-NASDAQ-VRSN-1412893.htm">Internet Infrastructure Grant</a>.
</li>
<li><a href="http://dave.recoil.org">David Scott</a> (chief architect of the Xen Cloud Platform) and <a href="http://anil.recoil.org">Anil Madhavapeddy</a> will give a joint tutorial on constructing functional operating systems at the <a href="http://cufp.org">Commercial Users of Functional Programming</a> workshop in Tokyo, Japan in September.
</li>
</ul>

      
