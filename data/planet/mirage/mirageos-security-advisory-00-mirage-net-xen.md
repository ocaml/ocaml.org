---
title: 'MirageOS security advisory 00: mirage-net-xen'
description:
url: https://mirage.io/blog/MSA00
date: 2016-05-03T00:00:00-00:00
preview_image:
featured:
authors:
- Hannes Mehnert
---


        <h2>MirageOS Security Advisory 00 - memory disclosure in mirage-net-xen</h2>
<ul>
<li>Module:       mirage-net-xen
</li>
<li>Announced:    2016-05-03
</li>
<li>Credits:      Enguerrand Decorne, Thomas Leonard, Hannes Mehnert, Mindy Preston
</li>
<li>Affects:      mirage-net-xen &lt;1.4.2
</li>
<li>Corrected:    2016-01-08 1.5.0 release, 2016-05-03 1.4.2 release
</li>
</ul>
<p>For general information regarding MirageOS Security Advisories,
please visit <a href="https://mirage.io/security">https://mirage.io/security</a>.</p>
<p>Hannes published a <a href="https://hannes.nqsb.io/Posts/BadRecordMac">blog article</a> about
the analysis of this issue.</p>
<h3>Background</h3>
<p>MirageOS is a library operating system using cooperative multitasking, which can
be executed as a guest of the Xen hypervisor.  Virtual devices, such as a
network device, share memory between MirageOS and the hypervisor.  MirageOS
allocates and grants the hypervisor access to a ringbuffer containing pages to
be sent on the network device, and another ringbuffer with pages to be filled
with received data.  A write on the MirageOS side consists of filling the page
with the packet data, submitting a write request to the hypervisor, and awaiting
a response from the hypervisor.  To correlate the request with the response, a
16bit identifier is used.</p>
<h3>Problem Description</h3>
<p>Generating this 16bit identifier was not done in a unique manner.  When multiple
pages share an identifier, and are requested to be transmitted via the wire, the
first successful response will mark all pages with this identifier free, even
those still waiting to be transmitted.  Once marked free, the MirageOS
application fills the page for another chunk of data.  This leads to corrupted
packets being sent, and can lead to disclosure of memory intended for another
recipient.</p>
<h3>Impact</h3>
<p>This issue discloses memory intended for another recipient.  All versions before
mirage-net-xen 1.4.2 are affected.  The receiving side uses a similar mechanism,
which may lead to corrupted incoming data (eventually even mutated while being
processed).</p>
<p>Version 1.5.0, released on 8th January, already assigns unique identifiers for
transmission.  Received pages are copied into freshly allocated buffers before
passed to the next layer.  When 1.5.0 was released, the impact was not clear to
us.  Version 1.6.1 now additionally ensures that received pages have a unique
identifier.</p>
<h3>Workaround</h3>
<p>No workaround is available.</p>
<h3>Solution</h3>
<p>The unique identifier is now generated in a unique manner using a monotonic
counter.</p>
<p>Transmitting corrupt data and disclosing memory is fixed in versions 1.4.2 and
above.</p>
<p>The recommended way to upgrade is:</p>
<pre><code class="language-bash">opam update
opam upgrade mirage-net-xen
</code></pre>
<p>Or, explicitly:</p>
<pre><code class="language-bash">opam upgrade
opam reinstall mirage-net-xen=1.4.2
</code></pre>
<p>Affected releases have been marked uninstallable in the opam repository.</p>
<h3>Correction details</h3>
<p>The following list contains the correction revision numbers for each
affected branch.</p>
<p>Memory disclosure on transmit:</p>
<p>master: <a href="https://github.com/mirage/mirage-net-xen/commit/47de2edfad9c56110d98d0312c1a7e0b9dcc8fbf">47de2edfad9c56110d98d0312c1a7e0b9dcc8fbf</a></p>
<p>1.4: <a href="https://github.com/mirage/mirage-net-xen/commit/ec9b1046b75cba5ae3473b2d3b223c3d1284489d">ec9b1046b75cba5ae3473b2d3b223c3d1284489d</a></p>
<p>Corrupt data while receiving:</p>
<p>master: <a href="https://github.com/mirage/mirage-net-xen/commit/0b1e53c0875062a50e2d5823b7da0d8e0a64dc37">0b1e53c0875062a50e2d5823b7da0d8e0a64dc37</a></p>
<p>1.4: <a href="https://github.com/mirage/mirage-net-xen/commit/6daad38af2f0b5c58d6c1fb24252c3eed737ede4">6daad38af2f0b5c58d6c1fb24252c3eed737ede4</a></p>
<h3>References</h3>
<p><a href="https://github.com/mirage/mirage-net-xen">mirage-net-xen</a></p>
<p>You can find the latest version of this advisory online at
<a href="https://mirage.io/blog/MSA00">https://mirage.io/blog/MSA00</a>.</p>
<p>This advisory is signed using OpenPGP, you can verify the signature
by downloading our public key from a keyserver (<code>gpg --recv-key 4A732D757C0EDA74</code>),
downloading the raw markdown source of this advisory from <a href="https://raw.githubusercontent.com/mirage/mirage-www/master/tmpl/advisories/00.txt.asc">GitHub</a>
and executing <code>gpg --verify 00.md.asc</code>.</p>

      
