---
title: 'MirageOS 1.1.0: the eat-your-own-dogfood release'
description:
url: https://mirage.io/blog/mirage-1.1-released
date: 2014-02-11T00:00:00-00:00
preview_image:
featured:
authors:
- Anil Madhavapeddy
---


        <p>We've just released <a href="https://github.com/ocaml/opam-repository/pull/1655">MirageOS 1.1.0</a> into OPAM.  Once the
live site updates, you should be able to run <code>opam update -u</code> and get the latest
version.  This release is the &quot;<a href="http://en.wikipedia.org/wiki/Eating_your_own_dog_food">eat our own
dogfood</a>&quot; release; as I
mentioned earlier in January, a number of the MirageOS developers have decided to
shift our own personal homepages onto MirageOS.  There's nothing better than
using our own tools to find all the little annoyances and shortcomings, and so
MirageOS 1.1.0 contains some significant usability and structural improvements
for building unikernels.</p>
<h4>Functional combinators to build device drivers</h4>
<p>MirageOS separates the
application logic from the concrete backend in use by writing the application
as an <a href="https://realworldocaml.org/v1/en/html/functors.html">OCaml functor</a>
that is parameterized over module types that represent the device driver
signature.  All of the module types used in MirageOS can be browsed in <a href="https://github.com/mirage/mirage/blob/1.1.0/types/V1.mli">one
source file</a>.</p>
<p>In MirageOS 1.1.0, <a href="http://gazagnaire.org/">Thomas Gazagnaire</a> implemented a
a <a href="https://github.com/mirage/mirage/blob/1.1.0/lib/mirage.mli#L28">combinator library</a>
that makes it easy to separate the definition of application logic from the details
of the device drivers that actually execute the code (be it a Unix binary or a
dedicated Xen kernel).  It lets us write code of this form
(taken from <a href="https://github.com/mirage/mirage-skeleton/tree/master/block">mirage-skeleton/block</a>):</p>
<pre><code class="language-ocaml">let () =
  let main = foreign &quot;Unikernel.Block_test&quot; (console @-&gt; block @-&gt; job) in
  let img = block_of_file &quot;disk.img&quot; in
  register &quot;block_test&quot; [main $ default_console $ img]
</code></pre>
<p>In this configuration fragment, our unikernel is defined as a functor over a
console and a block device by using <code>console @-&gt; block @-&gt; job</code>.  We then
define a concrete version of this job by applying the functor (using the <code>$</code>
combinator) to a default console and a file-backed disk image.</p>
<p>The combinator approach lets us express complex assemblies of device driver
graphs by writing normal OCaml code, and the <code>mirage</code> command line tool
parses this at build-time and generates a <code>main.ml</code> file that has all the
functors applied to the right device drivers. Any mismatches in module signatures
will result in a build error, thus helping to spot nonsensical combinations
(such as using a Unix network socket in a Xen unikernel).</p>
<p>This new feature is walked through in the <a href="https://mirage.io/docs/hello-world">tutorial</a>, which
now walks you through several skeleton examples to explain all the different
deployment scenarios.  It's also followed by the <a href="https://mirage.io/docs/mirage-www">website tutorial</a>
that explains how this website works, and how our <a href="https://mirage.io/docs/deploying-via-ci">Travis autodeployment</a>
throws the result onto the public Internet.</p>
<p>Who will win the race to get our website up and running first?  Sadly for Anil,
<a href="http://www.cs.nott.ac.uk/~rmm/">Mort</a> is currently <a href="https://github.com/mor1/mort-www">in the
lead</a> with an all-singing, all-dancing shiny
new website.  Will he finish in the lead though? Stay tuned!</p>
<h4>Less magic in the build</h4>
<p>Something that's more behind-the-scenes, but important for easier development,
is a simplication in how we build libraries.  In MirageOS 1.0, we had several
packages that couldn't be simultaneously installed, as they had to be compiled
in just the right order to ensure dependencies.</p>
<p>With MirageOS 1.1.0, this is all a thing of the past.  All the libraries can
be installed fully in parallel, including the network stack.  The 1.1.0
<a href="https://github.com/mirage/mirage-tcpip">TCP/IP stack</a> is now built in the
style of the venerable <a href="http://www.cs.cmu.edu/~fox/foxnet.html">FoxNet</a> network
stack, and is parameterized across its network dependencies.  This means
that once can quickly assemble a custom network stack from modular components,
such as this little fragment below from <a href="https://github.com/mirage/mirage-skeleton/blob/master/ethifv4/unikernel.ml">mirage-skeleton/ethifv4/</a>:</p>
<pre><code class="language-ocaml">module Main (C: CONSOLE) (N: NETWORK) = struct

  module E = Ethif.Make(N)
  module I = Ipv4.Make(E)
  module U = Udpv4.Make(I)
  module T = Tcpv4.Flow.Make(I)(OS.Time)(Clock)(Random)
  module D = Dhcp_clientv4.Make(C)(OS.Time)(Random)(E)(I)(U)
  
</code></pre>
<p>This functor stack starts with a <code>NETWORK</code> (i.e. Ethernet) device, and then applies
functors until it ends up with a UDPv4, TCPv4 and DHCPv4 client.  See the <a href="https://github.com/mirage/mirage-skeleton/blob/master/ethifv4/unikernel.ml">full
file</a>
to see how the rest of the logic works, but this serves to illustrate how
MirageOS makes it possible to build custom network stacks out of modular
components.  The functors also make it easier to embed the network stack in
non-MirageOS applications, and the <code>tcpip</code> OPAM package installs pre-applied Unix
versions for your toplevel convenience.</p>
<p>To show just how powerful the functor approach is, the same stack can also
be mapped onto a version that uses kernel sockets simply by abstracting the
lower-level components into an equivalent that uses the Unix kernel to provide
the same functionality.  We explain how to swap between these variants in
the <a href="https://mirage.io/wiki/hello-world">tutorials</a>.</p>
<h4>Lots of library releases</h4>
<p>While doing the 1.1.0 release in January, we've also released quite a few libraries
into <a href="https://opam.ocaml.org">OPAM</a>.  Here are some of the highlights.</p>
<p>Low-level libraries:</p>
<ul>
<li><a href="https://github.com/samoht/ocaml-mstruct/">mstruct</a> is a streaming layer for handling lists of memory buffers with a simpler read/write interface.
</li>
<li><a href="https://github.com/xapi-project/nbd/">nbd</a> is an implementation of the <a href="http://en.wikipedia.org/wiki/Network_block_device">Network Block Device</a> protocol for block drivers.
</li>
</ul>
<p>Networking and web libraries:</p>
<ul>
<li><a href="https://github.com/mirage/ocaml-ipaddr">ipaddr</a> now has IPv6 parsing support thanks to <a href="https://github.com/hhugo/">Hugo Heuzard</a> and David Sheets.  This is probably the hardest bit of adding IPv6 support to our network stack!
</li>
<li><a href="https://github.com/mirage/cowabloga">cowabloga</a> is slowly emerging as a library to handle the details of rendering Zurb Foundation websites.  It's still in active development, but being used for a few of our <a href="https://github.com/mor1/mort-www">personal websites</a> as well as this website.
</li>
<li><a href="https://github.com/avsm/ocaml-cohttp">cohttp</a> has had several releases thanks to external contributions, particular from <a href="https://github.com/rgrinberg">Rudy Grinberg</a> who added s-expression support and several <a href="https://github.com/avsm/ocaml-cohttp/blob/master/CHANGES">other improvements</a>.
</li>
<li><a href="https://github.com/avsm/ocaml-uri">uri</a> features performance improvements and the elimination of Scanf (considered <a href="http://www.lexifi.com/blog/note-about-performance-printf-and-format">rather slow</a> by OCaml standards).
</li>
<li><a href="https://github.com/mirage/ocaml-cow">cow</a> continues its impossible push to make coding HTML and CSS a pleasant experience, with better support for Markdown now.
</li>
<li>The <a href="https://github.com/avsm/ocaml-github">github</a> bindings are now also in use as part of an experiment to make <a href="http://gallium.inria.fr/blog/patch-review-on-github/">upstream OCaml development</a> easier for newcomers, thanks to Gabriel Scherer.
</li>
</ul>
<p><a href="http://dave.recoil.org">Dave Scott</a> led the splitting up of several low-level Xen libraries as part of the build simplication.  These now compile on both Xen (using the direct hypercall interface) and Unix (using the dom0 <code>/dev</code> devices) where possible.</p>
<ul>
<li><a href="https://github.com/xapi-project/ocaml-evtchn">xen-evtchn</a> for the event notification mechanism. There are a couple of wiki posts that explain how <a href="https://mirage.io/wiki/xen-events">event channels</a> and <a href="https://mirage.io/wiki/xen-suspend">suspend/resume</a> work in MirageOS/Xen guests.
</li>
<li><a href="https://github.com/xapi-project/ocaml-gnt">xen-gnt</a> for the grant table mechanism that controls inter-process memory.
</li>
<li>The <a href="https://github.com/mirage/io-page">io-page</a> library no longer needs Unix and Xen variants, as the interface has been standardized to work in both.
</li>
</ul>
<p>All of Dave's hacking on Xen device drivers is showcased in this <a href="https://mirage.io/docs/xen-synthesize-virtual-disk">xen-disk wiki post</a> that
explains how you can synthesize your own virtual disk backends using MirageOS.  Xen uses a <a href="https://www.usenix.org/legacy/event/usenix05/tech/general/full_papers/short_papers/warfield/warfield.pdf">split device</a> model,
and now MirageOS lets us build <em>backend</em> device drivers that service VMs as well as the frontends!</p>
<p>Last, but not least, <a href="http://gazagnaire.org">Thomas Gazagnaire</a> has been building a brand new storage system for MirageOS guests that uses git-style branches under the hood to help coordinate clusters of unikernels.  We'll talk about how this works in a future update, but there are some cool libraries and prototypes available on OPAM for the curious.</p>
<ul>
<li><a href="https://github.com/samoht/ocaml-lazy-trie/">lazy-trie</a> is a lazy version of the Trie data structure, useful for exposing Git graphs.
</li>
<li><a href="https://github.com/samoht/ocaml-git">git</a> is a now-fairly complete implementation of the Git protocol in pure OCaml, which can interoperate with normal Git servers via the <code>ogit</code> command-line tool that it installs.
</li>
<li><a href="https://github.com/mirage/irmin">irmin</a> is the main library that abstracts Git DAGs into an OCaml programming API.  The homepage has <a href="https://github.com/mirage/irmin/wiki/Getting-Started">instructions</a> on how to play with the command-line frontend to experiment with the database.
</li>
<li><a href="https://github.com/samoht/git2fat">git2fat</a> converts a Git checkout into a FAT block image, useful when bundling up unikernels.
</li>
</ul>
<p>We'd also like to thank several conference organizers for giving us the opportunity to demonstrate MirageOS.  The talk video from <a href="http://www.infoq.com/presentations/mirage-os">QCon SF</a> is now live, and we also had a <em>great</em> time at <a href="http://fosdem.org">FOSDEM</a> recently (summarized by Amir <a href="http://nymote.org/blog/2014/fosdem-summary/">here</a>).
So lots of activities, and no doubt little bugs lurking in places (particularly around installation).  As always, please do let us know of any problem by <a href="https://github.com/mirage/mirage/issues">reporting bugs</a>, or feel free to <a href="https://mirage.io/community">contact us</a> via our e-mail lists or IRC.  Next stop: our unikernel homepages!</p>

      
