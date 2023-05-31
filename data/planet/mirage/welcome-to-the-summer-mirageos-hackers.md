---
title: Welcome to the summer MirageOS hackers
description:
url: https://mirage.io/blog/welcome-to-our-summer-hackers
date: 2014-05-08T00:00:00-00:00
preview_image:
featured:
authors:
- Anil Madhavapeddy
---


        <p>Following our participation in the <a href="https://mirage.io/blog/applying-for-gsoc2014">Google Summer of Code</a> program, we've now finalised selections.  We've also got a number of other visitors joining us to hack on Mirage over the summer time, so here are introductions!</p>
<ul>
<li><strong>SSL support</strong>: <a href="https://github.com/hannesm">Hannes Mehnert</a> and <a href="https://github.com/pqwy">David Kaloper</a> have been working hard on a safe <a href="https://github.com/mirleft/ocaml-tls">OCaml TLS</a> implementation. They're going to hack on <a href="https://github.com/mirage/mirage/issues/242">integrating it all</a> into working under Xen so we can make HTTPS requests (and our Twitter bot will finally be able to tweet!).  Both are also interested in formal verification of the result, and several loooong conversations with <a href="http://www.cl.cam.ac.uk/~pes20/">Peter Sewell</a> will magically transform into machine specifications by summer's end, I'm reliably informed.
</li>
<li><strong>Cloud APIs</strong>: <a href="http://1000hippos.wordpress.com/">Jyotsna Prakash</a> will spend her summer break as part of <a href="http://www.google-melange.com/gsoc/org2/google/gsoc2014/xen_project">Google Summer of Code</a> working on improving cloud provider APIs in OCaml (modelled from her notes on how the <a href="https://github.com/avsm/ocaml-github">GitHub</a> bindings <a href="http://1000hippos.wordpress.com/2014/04/24/ocaml-github/">are built</a>).  This will let the <code>mirage</code> command-line tool have much more natural integration with remote cloud providers for executing the unikernels straight from a command-line.  If you see Jyotsna wandering around aimlessly muttering darkly about HTTP, JSON and REST, then the project is going well.
</li>
<li><strong>Network Stack fuzzing</strong>: <a href="http://www.somerandomidiot.com/">Mindy Preston</a> joins us for the summer after her <a href="https://www.hackerschool.com/">Hacker School</a> stay, courtesy of the <a href="https://opw.gnome.org">OPW</a> program.  She's been delving into the network stack running on EC2 and figuring out how to debug issues when the unikernel is running a cloud far, far away (see the post series here: <a href="http://www.somerandomidiot.com/blog/2014/03/14/its-a-mirage/">1</a>, <a href="http://www.somerandomidiot.com/blog/2014/03/24/advancing-toward-the-mirage/">2</a>, <a href="http://www.somerandomidiot.com/blog/2014/04/02/tying-the-knot/">3</a>, <a href="http://www.somerandomidiot.com/blog/2014/03/24/arriving-at-the-mirage/">4</a>).
</li>
<li><strong>Visualization</strong>: <a href="http://erratique.ch/contact.en">Daniel Buenzli</a> returns to Cambridge this summer to continue his work on extremely succinctly named graphics libaries.  His <a href="https://github.com/dbuenzli/vz">Vz</a>, <a href="https://github.com/dbuenzli/vg">Vg</a> and <a href="https://github.com/dbuenzli/gg">Gg</a> libaries build a set of primitives for 2D graphics programming.  Since the libraries compile to JavaScript, we're planning to use this as the basis for <a href="http://erratique.ch/software/vg/demos/rhtmlc">visualization</a> of Mirage applications via a built-in webserver.
</li>
<li><strong>Modular implicits</strong>: <a href="https://github.com/def-lkb">Frederic Bour</a>, author of the popular <a href="https://github.com/the-lambda-church/merlin">Merlin</a> IDE tool is also in Cambridge this summer working on adding modular implicits to the core OCaml language. Taking inspiration from <a href="http://www.mpi-sws.org/~dreyer/papers/mtc/main-long.pdf">Modular Type-classes</a> and Scala's <a href="http://twitter.github.io/scala_school/advanced-types.html">implicits</a>,  modular implcits allow functions to take implicit module arguments which will be filled-in by the compiler by searching the environment for a module with the appropriate type. This enables ad-hoc polymorphism in a very similar way to Haskell's type classes.
</li>
<li><strong>Irmin storage algorithms</strong>: Benjamin Farinier (from <a href="http://www.ens-lyon.eu/">ENS Lyon</a>) and Matthieu Journault (from <a href="http://www.ens-cachan.fr/">ENS Cachan</a>) will work on datastructures for the <a href="https://github.com/mirage/irmin/wiki/Getting-Started">Irmin</a> storage system that the next version of Mirage will use.  They'll be grabbing copies of the <a href="http://www.amazon.co.uk/Purely-Functional-Structures-Chris-Okasaki/dp/0521663504">Okasaki</a> classic text and porting some of them into a branch-consistent form.
</li>
</ul>
<p>Of course, work continues apace by the rest of the team as usual, with a <a href="https://mirage.io/releases">steady stream of releases</a> that are building up to some exciting new features.  We'll be blogging about ARM support, PVHVM, Irmin storage and SSL integration just as soon as they're pushed into the stable branches.  As always, <a href="https://mirage.io/community/">get in touch</a> via the IRC channel (<code>#mirage</code> on Freenode) or the mailing lists with questions.</p>

      
