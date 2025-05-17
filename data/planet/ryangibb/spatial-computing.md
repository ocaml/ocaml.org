---
title: Spatial Computing
description:
url: https://ryan.freumh.org/spatial-computing.html
date: 2025-04-21T00:00:00-00:00
preview_image:
authors:
- Ryan Gibb
source:
---

<article>
    <div class="container">
        
        <span>Published 21 Apr 2025.</span>
        
        
    </div>
    
        <div> Tags: <a href="https://ryan.freumh.org/research.html" title="All pages tagged 'research'." rel="tag">research</a>. </div>
    
    <section>
        <p><span>Following my undergraduate dissertation on network
support for resource-constrained highly mobile embedded devices, my <a href="https://ryan.freumh.org/papers.html#spatial-name-system">masters project</a> moved on to
the exact opposite scenario: supporting physically static devices. There
are a broad class of network-connected devices with a physical presence
to which location is an intrinsic part of their identity. A networked
speaker in, say, the Oval Office is defined by its location: it’s simply
the Oval Office Speaker. If the specific device moves location its
identity should change with its new location, and if the device is
replaced then the replacement should assume the function of its
predecessor.</span></p>
<p><span>My masters project explored how an augmented
reality interface for interacting with these devices could be built and
the systems support required for communicating with using the myriad of
addresses we use beyond IP. The Domain Name System, the standard for
both global and network-local naming, provides a registry for network
address that is compatible with the Internet protocol suite. We extended
the DNS with algorithms for geospatial queries on this database through
DNS resolutions, which we coined the `Spatial Name System`.</span></p>
<p><span>We wrote these ideas down in a paper ‘<a href="https://ryan.freumh.org/papers.html#where-on-earth-is-the-spatial-name-system">Where on
Earth is the Spatial Name System</a>’ in 2023 which was accepted to the
22nd ACM Workshop on Hot Topics in Networks.</span></p>
<p><span>Recent work in this area has included Roy Ang’s
work on `<a href="https://ryan.freumh.org/bigraphs-real-world.html">Bigraphs of the Real
World</a>`, taking Robin Milner’s <a href="https://en.wikipedia.org/wiki/Bigraph">Bigraphs</a> and
implementing models of OpenStreetMap with Glasgow’s <a href="https://bitbucket.org/uog-bigraph/bigraph-tools/src/master/bigrapher/">Bigrapher</a>
tool written in OCaml.</span></p>
<p><span>I’m interested in putting these ideas into practice
with <a href="https://j0shmillar.github.io/">Josh Millar</a>’s sensor
networks.</span></p>
    </section>
</article>

