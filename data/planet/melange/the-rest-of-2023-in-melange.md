---
title: The rest of 2023 in Melange
description:
url: https://melange.re/blog/posts/the-rest-of-2023-in-melange
date: 2023-10-12T00:00:00-00:00
preview_image:
authors:
- Melange Blog
source:
---

<p>As October 2023 unfolds, we'd like to present what we're planning to work on
during what remains of 2023. Built upon the invaluable feedback of our users and
our vision for Melange, we are excited about what's next.</p>
<hr/>
<p><img src="https://substackcdn.com/image/fetch/w_1456,c_limit,f_auto,q_auto:good,fl_progressive:steep/https:%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F98530216-e8ed-478a-925e-e365ae5b2136_1792x1024.webp" alt=""/></p>
<h3 tabindex="-1">Melange v3 <a href="https://melange.re/blog/feed.rss#melange-v3" class="header-anchor" aria-label="Permalink to &quot;Melange v3&quot;"></a></h3>
<p>By the close of Q4 2023, we're set to launch Melange v3. Here's a breakdown of
our main focus for shipping a new major release:</p>
<ul>
<li>
<p><strong>Fast, Reliable Builds</strong>: We're fine-tuning Melange to ensure faster, more
reliable project builds. This work is spread across a few fronts:</p>
<ul>
<li>
<p>implementing some missing compiler and build system optimizations, improving
the associated dune rules, and honing the underlying artifact representation
for optimal performance.</p>
</li>
<li>
<p>improving the Melange core to be faster to build, run and evolve.</p>
</li>
</ul>
</li>
<li>
<p><strong>JavaScript Expressivity</strong>:</p>
<ul>
<li>
<p>we're aiming to make JavaScript idioms more intuitive in Melange. We're
implementing more supported interoperability attributes, exploring new ways
of writing bindings and surfacing their documentation and enriching the
existing sections in the Melange docs.</p>
</li>
<li>
<p>we're planning on unifying the Melange core APIs around an abstraction over
both&nbsp;<a href="https://melange.re/v2.0.0/communicate-with-javascript/#pipe-operators" target="_blank" rel="noreferrer">pipe
operators</a>&nbsp;<code>|&gt;</code>&nbsp;and&nbsp;<code>-&gt;</code>,
allowing us to remove some modules where standard library duplication
exists, ensuring a more consistent user experience, reducing confusion and
evolvability of the code.</p>
</li>
<li>
<p>from supporting React 18 to introducing async component support, we're
ensuring Melange stays up to date with the latest in React development. To
make is easier to add these, we're planning to safely type JavaScript
dynamic&nbsp;<code>import()</code>: this will make code more concise by removing the need
for verbose workarounds but also ensures safety, reducing runtime errors</p>
</li>
</ul>
</li>
<li>
<p><strong>Development &amp; Learning Experience</strong></p>
<ul>
<li>
<p>With an emphasis on user-friendliness, we're improving the Melange
Playground with a few requested features: by the end of the quarter it will
offer advanced code diagnostics, bundle the new Melange
v2&nbsp;<code>melange.dom</code>&nbsp;library, present errors and warnings in a more robust way
and test a new way of learning how to communicate with JavaScript from
Melange.</p>
</li>
<li>
<p>Until the end of 2023, we're going to design and start implementing a whole
new Melange website consolidated around a distinct, consistent brand.</p>
</li>
<li>
<p>We're planning to publish Melange for React Devs, a guided introduction for
developers with existing React.js knowledge, bridging the gap between React
and Melange, showcasing how some common React.js constructs are expressed in
OCaml / Reason and Melange.</p>
</li>
</ul>
</li>
</ul>
<h3 tabindex="-1">The Melange Legacy <a href="https://melange.re/blog/feed.rss#the-melange-legacy" class="header-anchor" aria-label="Permalink to &quot;The Melange Legacy&quot;"></a></h3>
<p>Having integrated with the OCaml Platform set of tools and ensured Melange
package availability in the OPAM repository, our previous releases have set the
stage for what's next: with Melange v3, we're striving for an even more robust,
expressive toolchain with an improved set of learning resources and an unmatched
in-browser learning experience on the Melange Playground.</p>
<p>The above is just a glimpse into what we're working on. Consult the&nbsp;<a href="https://docs.google.com/document/d/1q9NWiXun_Lqgv5iNNYm2SKzUGGJ02FpRawKUiTxnJPI/edit#heading=h.9je9ws3oydaz" target="_blank" rel="noreferrer">full
roadmap
document</a>&nbsp;for
more detail around what we'll be up to until the end of 2023.</p>
<p>Thank you for reading and happy hacking!</p>

