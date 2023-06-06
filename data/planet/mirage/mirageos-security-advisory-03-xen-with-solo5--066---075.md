---
title: 'MirageOS security advisory 03: xen with solo5 >= 0.6.6 & < 0.7.5'
description:
url: https://mirage.io/blog/MSA03
date: 2022-12-07T00:00:00-00:00
preview_image:
featured:
authors:
- Hannes Mehnert
---


        <h2>MirageOS Security Advisory 03 - infinite loop in console output on xen</h2>
<ul>
<li>Module:       solo5
</li>
<li>Announced:    2022-12-07
</li>
<li>Credits:      Krzysztof Burghardt, Pierre Alain, Thomas Leonard, Hannes Mehnert
</li>
<li>Affects:      solo5 &gt;= 0.6.6 &amp; &lt; 0.7.5,
qubes-mirage-firewall &gt;= 0.8.0 &amp; &lt; 0.8.4
</li>
<li>Corrected:    2022-12-07: solo5 0.7.5,
2022-12-07: qubes-mirage-firewall 0.8.4
</li>
<li>CVE:          CVE-2022-46770
</li>
</ul>
<p>For general information regarding MirageOS Security Advisories,
please visit <a href="https://mirage.io/security">https://mirage.io/security</a>.</p>
<h3>Background</h3>
<p>MirageOS is a library operating system using cooperative multitasking, which can
be executed as a guest of the Xen hypervisor. Output on the console is performed
via the Xen console protocol.</p>
<h3>Problem Description</h3>
<p>Since MirageOS moved from PV mode to PVH, and thus replacing Mini-OS with solo5,
there was an issue in the solo5 code which failed to properly account the
already written bytes on the console. This only occurs if the output to be
performed does not fit in a single output buffer (2048 bytes on Xen).</p>
<p>The code in question set the number of bytes written to the last written count
(written = output_some(buf)), instead of increasing the written count
(written += output_some(buf)).</p>
<h3>Impact</h3>
<p>Console output may lead to an infinite loop, endlessly printing data onto the
console.</p>
<p>A prominent unikernel is the Qubes MirageOS firewall, which prints some input
packets onto the console. This can lead to a remote denial of service
vulnerability, since any client could send a malformed and sufficiently big
network packet.</p>
<h3>Workaround</h3>
<p>No workaround is available.</p>
<h3>Solution</h3>
<p>The solution is to fix the console output code in solo5, as done in
https://github.com/Solo5/solo5/pull/538/commits/099be86f0a17a619fcadbb970bb9e511d28d3cd8</p>
<p>For the qubes-mirage-firewall, update to a solo5 release (0.7.5) which has the
issue fixed. This has been done in the release 0.8.4 of qubes-mirage-firewall.</p>
<p>The recommended way to upgrade is:</p>
<pre><code class="language-bash">opam update
opam upgrade solo5
</code></pre>
<h3>Correction details</h3>
<p>The following PRs were part of the fix:</p>
<ul>
<li><a href="https://github.com/Solo5/solo5/pull/538">solo5/pull/538</a> - xen console: update the &quot;to be written&quot; count
</li>
<li><a href="https://github.com/mirage/qubes-mirage-firewall/pull/167">qubes-mirage-firewall/pull/167</a> - update opam repository commit
</li>
</ul>
<h3>Timeline</h3>
<ul>
<li>2022-12-04: initial report by Krzysztof Burghardt https://github.com/mirage/qubes-mirage-firewall/issues/166
</li>
<li>2022-12-04: investigation by Hannes Mehnert and Pierre Alain
</li>
<li>2022-12-05: initial fix by Pierre Alain https://github.com/Solo5/solo5/pull/538
</li>
<li>2022-12-05: review of fix by Thomas Leonard
</li>
<li>2022-12-07: release of fixed packages and security advisory
</li>
</ul>
<h3>References</h3>
<p>You can find the latest version of this advisory online at
<a href="https://mirage.io/blog/MSA03">https://mirage.io/blog/MSA03</a>.</p>
<p>This advisory is signed using OpenPGP, you can verify the signature
by downloading our public key from a keyserver (<code>gpg --recv-key 4A732D757C0EDA74</code>),
downloading the raw markdown source of this advisory from
<a href="https://raw.githubusercontent.com/mirage/mirage-www/master/tmpl/advisories/03.txt.asc">GitHub</a>
and executing <code>gpg --verify 03.txt.asc</code>.</p>

      
