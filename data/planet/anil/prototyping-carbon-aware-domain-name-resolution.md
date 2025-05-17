---
title: Prototyping carbon-aware domain name resolution
description:
url: https://anil.recoil.org/news/2024-loco-carbonres-1
date: 2024-12-01T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<p><a href="https://ryan.freumh.org" class="contact">Ryan Gibb</a> and I have been thinking about how the current Internet architecture fails to treat the carbon emissions
associated with networked services as a first-class metric. So when the <a href="https://locos.codeberg.page/loco2024/">LOCO</a> conference came up, we tried extending the DNS with load balancing techniques to consider the carbon cost of scheduling decisions. A next step was then to build a custom <a href="https://github.com/RyanGibb/eon">DNS server written in OCaml</a> to actively wake machines running networked services as a side effect of the name
resolution.</p>
<p>Extending DNS means that we maintain compatibility with existing Internet
infrastructure, unlocking the ability for existing applications to be
carbon-aware. This is very much a spiritual follow on to the
<a href="https://anil.recoil.org/papers/2013-foci-signposts">Signposts</a> project that I worked on back in 2013, and
have always wanted to return to!</p>

<blockquote class="paper noquote">
  <div class="paper-info">
  
  <p><a href="https://ryan.freumh.org"><span style="text-wrap:nowrap">Ryan Gibb</span></a>, <a href="https://patrick.sirref.org"><span style="text-wrap:nowrap">Patrick Ferris</span></a> and <a href="https://anil.recoil.org"><span style="text-wrap:nowrap">Anil Madhavapeddy</span></a>.</p>
  <p>Abstract in the <a href="https://www.sicsa.ac.uk/wp-content/uploads/2024/11/LOCO2024_paper_28.pdf">1st International Workshop on Low Carbon Computing</a>.</p>
  <p><a href="https://www.sicsa.ac.uk/wp-content/uploads/2024/11/LOCO2024_paper_28.pdf">URL</a> <i style="color: #666666">(sicsa.ac.uk)</i>
 &nbsp; <a href="https://anil.recoil.org/papers/2024-loco-carbonres.bib">BIB</a>
 &nbsp; <a href="https://anil.recoil.org/papers/2024-loco-carbonres.pdf"><span class="nobreak">PDF<img src="https://anil.recoil.org/assets/pdf.svg" alt="pdf" class="inline-icon"></span></a>
</p>
  </div>
</blockquote>




