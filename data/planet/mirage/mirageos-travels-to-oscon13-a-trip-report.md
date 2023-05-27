---
title: 'MirageOS travels to OSCON''13: a trip report'
description:
url: https://mirage.io/blog/oscon13-trip-report
date: 2013-08-08T00:00:00-00:00
preview_image:
featured:
authors:
- Richard Mortier
---


        <p>Now that Mirage OS is rapidly converging on a
<a href="http://github.com/avsm/mirage/issues/102">Developer Preview Release 1</a>, we
took it for a first public outing at
<a href="http://www.oscon.com/oscon2013/">OSCON'13</a>, the O'Reilly Open Source
Conference. OSCON is in its 15th year now, and is a meeting place for
developers, business people and investors. It was a great opportunity to show
MirageOS off to some of the movers and shakers in the OSS world.</p>
<p>Partly because MirageOS is about synthesising extremely specialised guest
kernels from high-level code, and partly because both Anil and I are
constitutionally incapable of taking the easy way out, we self-hosted the
slide deck on Mirage: after some last-minute hacking -- on content not Mirage
I should add! -- we built a self-contained unikernel of the talk.</p>
<p>This was what you might call a &quot;full stack&quot; presentation: the custom
unikernel (flawlessly!) ran a type-safe
<a href="https://github.com/mirage/mirage-platform/blob/master/xen/lib/netif.ml">network device driver</a>,
OCaml <a href="http://github.com/mirage/mirage-net">TCP/IP stack</a> supporting an OCaml
<a href="http://github.com/mirage/ocaml-cohttp">HTTP</a> framework that served slides
rendered using <a href="http://lab.hakim.se/reveal-js/">reveal.js</a>. The slide deck,
including the turbo-boosted
<a href="http://www.youtube.com/watch?v=2Mx8Bd5JYyo">screencast</a> of the slide deck
compilation, is hosted as another MirageOS virtual machine at
<a href="http://decks.openmirage.org/">decks.openmirage.org</a>. We hope to add more
slide decks there soon, including resurrecting the tutorial! The source code
for all this is in the <a href="http://github.com/mirage/mirage-decks">mirage-decks</a>
GitHub repo.</p>
<h3>The Talk</h3>
<p>The talk went down pretty well -- given we were in a graveyard slot on Friday
after many people had left, attendance was fairly high (around 30-40), and the
<a href="http://www.oscon.com/oscon2013/public/schedule/detail/28956">feedback scores</a>
have been positive (averaging 4.7/5) with comments including &quot;excellent
content and well done&quot; and &quot;one of the most excited projects I heard about&quot;
(though we are suspicious that just refers to Anil's usual high-energy
presentation style...).</p>
<iframe align="right" style="margin-left: 10px;" width="420" height="235" src="//www.youtube-nocookie.com/embed/2Mx8Bd5JYyo" frameborder="0" allowfullscreen="1"> </iframe>
<p>Probably the most interesting chat after the talk was with the Rust authors
at Mozilla (<a href="http://twitter.com/pcwalton">@pcwalton</a> and
<a href="https://github.com/brson">@brson</a>) about combining the Mirage
<a href="http://anil.recoil.org/papers/2013-asplos-mirage.pdf">unikernel</a> techniques
with the <a href="http://www.rust-lang.org">Rust</a> runtime. But perhaps the most
surprising feedback was when Anil and I were stopped in the street while
walking back from some well-earned sushi, by a cyclist who loudly declared
that he'd really enjoyed the talk and thought it was a really exciting project
-- never done something that achieved public acclaim from the streets before
:)</p>
<h3>Book Signing and Xen.org</h3>
<p>Anil also took some time to sit in a book signing for his forthcoming
<a href="http://realworldocaml.org">Real World OCaml</a> O'Reilly book.  This is
really important to making OCaml easier to learn, especially given that
all the Mirage libraries are using it.  Most of the dev team (and especially
thanks to <a href="https://twitter.com/heidiann360">Heidi Howard</a> who bravely worked
through really early alpha revisions) have been giving
us feedback as the book is written, using the online commenting system.</p>
<p>The Xen.org booth was also huge, and we spent quite a while plotting the
forthcoming Mirage/Xen/ARM backend. We're pretty much just waiting for the
<a href="http://cubieboard.org">Cubieboard2</a> kernel patches to be upstreamed (keep an
eye <a href="http://linux-sunxi.org/Main_Page">here</a>) so that we can boot Xen/ARM VMs
on tiny ARM devices.  There's a full report about this on the
<a href="http://blog.xen.org/index.php/2013/07/31/the-xen-project-at-oscon/">xen.org</a>
blog post about OSCon.</p>
<h3>Galois and HalVM</h3>
<p>We also stopped by the <a href="http://galois.com">Galois</a> to chat with <a href="https://twitter.com/acwpdx">Adam
Wick</a>, who is the leader of the
<a href="https://galois.com/project/halvm/">HalVM</a> project at Galois. This is a similar
project to Mirage, but, since it's written in Haskell, has more of a focus
on elegant compositional semantics rather than the more brutal performance
and predictability that Mirage currently has at its lower levels.</p>
<p>The future of all this ultimately lies in making it easier for these
multi-lingual unikernels to be managed and for all of them to communicate more
easily, so we chatted about code sharing and common protocols (such as
<a href="https://github.com/vbmithr/ocaml-vchan">vchan</a>) to help interoperability.
Expect to see more of this once our respective implementations get more
stable.</p>
<p>All-in-all OSCON'13 was a fun event and definitely one that we look forward
returning to with a more mature version of MirageOS, to build on the momentum
begun this year!  Portland was an amazing host city too, but what happens in
Portland, stays in Portland...</p>

      
