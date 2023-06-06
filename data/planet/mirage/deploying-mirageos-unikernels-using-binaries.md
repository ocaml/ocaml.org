---
title: Deploying MirageOS unikernels using binaries
description:
url: https://mirage.io/blog/deploying-mirageos-robur
date: 2022-03-08T00:00:00-00:00
preview_image:
featured:
authors:
- Rand
---


        <p>We are pleased to announce that the EU <a href="https://pointer.ngi.eu">NGI Pointer</a> funding received by <a href="https://robur.coop">robur</a> in 2021 lead to improved operations for MirageOS unikernels.</p>
<p>Our main achievement are <a href="https://builds.robur.coop">reproducible binary builds</a> of opam packages, including MirageOS unikernels and system packages. The infrastructure behind it, <a href="https://github.com/roburio/orb">orb</a>, <a href="https://github.com/roburio/builder">builder</a>, <a href="https://github.com/roburio/builder-web">builder-web</a> is itself reproducible and delivered as packages by <a href="https://builds.robur.coop">builds.robur.coop</a>.</p>
<p>The documentation how to get started <a href="https://robur.coop/Projects/Reproducible_builds">installing MirageOS unikernels and albatross from packages</a> is available online, further documentation on <a href="https://hannes.robur.coop/Posts/Monitoring">monitoring</a> is available as well.</p>
<p>The funding proposal covered the parts (as outlined in <a href="https://hannes.robur.coop/Posts/NGI">an earlier post from 2020</a>):</p>
<ul>
<li>reproducible binary releases of MirageOS unikernels,
</li>
<li>monitoring (and other devops features: profiling) and integration into existing infrastructure,
</li>
<li>and further documentation and advertisement.
</li>
</ul>
<p>We <a href="https://discuss.ocaml.org/t/ann-robur-reproducible-builds/8827">announced the web interface earlier</a> and also <a href="https://hannes.robur.coop/Posts/Deploy">posted about deployment</a> possibilities.</p>
<p>At the heart of our infrastructure is <a href="https://github.com/roburio/builder-web">builder-web</a>, a database that receives binary builds and provides a web interface and binary package repositories (<a href="https://apt.robur.coop">apt.robur.coop</a> and <a href="https://pkg.robur.coop">pkg.robur.coop</a>). Reynir discusses the design and implementation of <a href="https://github.com/roburio/builder-web">builder-web</a> in <a href="https://reyn.ir/posts/2022-03-08-builder-web.html">his blogpost</a>.</p>
<p>There we <a href="https://builds.robur.coop/job/tlstunnel/build/7f0afdeb-0a52-4de1-b96f-00f654ce9249/">visualize</a> the opam dependencies of an opam package:</p>
<iframe src="../graphics/tlstunnel-deps.html" title="Opam dependencies" style="width: 45em; height: 45.4em; max-width: 100%; max-height: 49vw; min-width: 38em; min-height: 40em;"></iframe>
<p>We also visualize the contributing modules and their sizes to the binary:</p>
<iframe src="../graphics/tlstunnel-treemap.html" title="Binary dissection" style="width: 46em; height: 48.4em; max-width: 100%; max-height: 52vw; min-width: 38em; min-height: 43em;"></iframe>
<p>Rand wrote a more in-depth explanation about the <a href="https://builds.robur.coop/job/tlstunnel/build/7f0afdeb-0a52-4de1-b96f-00f654ce9249/">visualizations</a> <a href="https://r7p5.earth/blog/2022-3-7/Builder-web%20visualizations%20at%20Robur">on his blog</a>.</p>
<p>If you've comments or are interested in deploying MirageOS unikernels at your organization, <a href="https://robur.coop/Contact">get in touch with us</a>.</p>

      
