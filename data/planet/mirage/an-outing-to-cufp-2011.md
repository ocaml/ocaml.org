---
title: An Outing to CUFP 2011
description:
url: https://mirage.io/blog/an-outing-to-cufp
date: 2011-09-29T00:00:00-00:00
preview_image:
featured:
authors:
- Anil Madhavapeddy
---


        <p>The team signed up to do a tutorial at <a href="http://cufp.org">CUFP</a> on the topic of <a href="http://cufp.org/conference/sessions/2011/t3-building-functional-os">Building a Functional OS</a>, which meant zooming off to Tokyo!  This was the first public show of the project, and resulted in a furious <a href="https://github.com/avsm/mirage/graphs/impact">flurry of commits</a> from the whole team to get it ready. The 45-strong crowd at the tutorial were really full of feedback, and particular thanks to <a href="http://www.deinprogramm.de/sperber/">Michael</a> for organising the event, and <a href="http://ocaml.janestreet.com/?q=blog/5">Yaron</a>, <a href="http://monkey.org/~marius/">Marius</a>, <a href="https://twitter.com/#!/stevej">Steve</a>, <a href="https://twitter.com/wil">Wil</a>, <a href="https://twitter.com/#!/adoemon">Adrian</a> and the rest for shouting out questions regularly!</p>
<ul>
<li>
<p><em>The tutorial</em> is <a href="http://github.com/avsm/mirage-tutorial">a Mirage application</a>, so you can clone it and view it locally through your web browser. The content is mirrored at <a href="http://tutorial.openmirage.org">tutorial.openmirage.org</a>, although it does require cleanup to make it suitable to an online audience. The SVG integration is awkward and it only works on Chrome/Safari, so I will probably rewrite it using <a href="http://imakewebthings.github.com/deck.js/">deck.js</a> soon. The tutorial is a good showcase of Mirage, as it compiles to Xen, UNIX (both kernel sockets and direct tuntap) with a RAMdisk or external filesystem, and is a good way to mess around with application synthesis (look at the <code>Makefile</code> targets in <code>slides/</code>).</p>
</li>
<li>
<p><em>Installation</em>: <a href="https://mirage.io/wiki/install">instructions</a> have been simplified, and we now only require OCaml on the host and include everything else in-tree. Thomas has also made Emacs and Vim plugins that are compatible with the ocamlbuild layout.</p>
</li>
<li>
<p><em>Lwt</em>: a <a href="https://mirage.io/wiki/tutorial-lwt">new tutorial</a> which walks you through the cooperative threading library we use, along with exercises (all available in <a href="http://github.com/avsm/mirage-tutorial">mirage-tutorial</a>). Raphael and Balraj are looking for feedback on this, so get in touch!</p>
</li>
<li>
<p><em>Javascript</em>: via <a href="http://nodejs.org">node.js</a> did not work in time for the tutorial, as integrating I/O is a tangled web that will take some time to sort out. Raphael is working on this in a <a href="https://github.com/raphael-proust/nodejs_of_ocaml">separate tree</a> for now.  As part of this effort though, he integrated a pure OCaml <a href="https://mirage.io/blog/ocaml-regexp">regular expression library</a> that does not require C bindings, and is surprisingly fast.</p>
</li>
<li>
<p><em>Devices</em>: we can now synthesise binaries that share common code but have very different I/O interfaces. This is due to a new device manager, and David also heroically wrote a complete <a href="http://github.com/avsm/mirage/tree/master/lib/fs">FAT12/16/32 library</a> that we demonstrated.  Yaron Minsky suggested a <a href="https://gist.github.com/1245418">different approach</a> to the device manager using <a href="http://caml.inria.fr/pub/docs/manual-ocaml/extn.html#sec245">first-class modules</a> instead of objects, so I am experimentally trying this before writing documentation on it.</p>
</li>
<li>
<p><em>TCP</em>: the notorious Mirage stack is far more robust due to our resident networking guru Balraj hunting down last-minute bugs. Although it held together with sticky tape during the tutorial, he is now adding retransmission and congestion control to make it actually standards-compliant.  Still, if you dont have any packet loss, the <a href="http://xen.openmirage.org/">unikernel version</a> of this website does actually serve pages.</p>
</li>
<li>
<p><em>OpenFlow</em>: is a new <a href="http://www.openflow.org/wk/index.php/OpenFlow_v1.0">standard</a> for <a href="http://networkheresy.wordpress.com/">Software Defined Networking</a>, and Haris and Mort have been hacking away at a complete implementation directly in Mirage!  We will be giving a tutorial on this at the <a href="http://changeofelia.info.ucl.ac.be/">OFELIA summer school</a> in November (it is summer somewhere, I guess). The prospect of a high-speed unikernel switching fabric for the cloud, programmed in a functional style, is something I am really looking forward to seeing!</p>
</li>
<li>
<p><em>Jane Street Core</em>: preceeding us was Yaron's <a href="http://cufp.org/conference/sessions/2011/t2-janestreets-ocaml-core-library">Core</a> tutorial. Since Mirage provides it own complete standard library, we can adopt portions of Core that do not require OS threads or UNIX-specific features.  I really like the idea that Mirage enforces a discipline on writing portable interfaces, as dependencies on OS-specific features do sneak in insiduously and make switching to different platforms very difficult (e.g. Windows support). Incidentally, Yaron's <a href="http://queue.acm.org/detail.cfm?id=2038036&amp;ref=fullrss">ACM Queue</a> article is a great introduction to OCaml.</p>
</li>
</ul>
<p>So as you can see, it has been a busy few months!  Much of the core of Mirage is settling down now, and we are writing a paper with detailed performance benchmarks of our various backends.  Keep an eye on the <a href="https://github.com/avsm/mirage/issues?milestone=2&amp;state=open">Github milestone</a> for the preview release, join our <a href="https://lists.cam.ac.uk/mailman/listinfo/cl-mirage">new mailing list</a>, or follow the newly sentient <a href="http://twitter.com/openmirage">openmirage on twitter</a>!</p>

      
