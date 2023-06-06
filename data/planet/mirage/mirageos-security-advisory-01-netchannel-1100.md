---
title: 'MirageOS security advisory 01: netchannel 1.10.0'
description:
url: https://mirage.io/blog/MSA01
date: 2019-03-21T00:00:00-00:00
preview_image:
featured:
authors:
- Mindy Preston
---


        <h2>MirageOS Security Advisory 01 - memory disclosure in mirage-net-xen</h2>
<ul>
<li>Module:       netchannel
</li>
<li>Announced:    2019-03-21
</li>
<li>Credits:      Thomas Leonard, Hannes Mehnert, Mindy Preston
</li>
<li>Affects:      netchannel = 1.10.0
</li>
<li>Corrected:    2019-03-20 1.10.1 release
</li>
</ul>
<p>For general information regarding MirageOS Security Advisories,
please visit <a href="https://mirage.io/security">https://mirage.io/security</a>.</p>
<h3>Background</h3>
<p>MirageOS is a library operating system using cooperative multitasking, which can
be executed as a guest of the Xen hypervisor.  Virtual devices, such as a
network device, share memory between MirageOS and the hypervisor.  To maintain
adequate performance, the virtual device managing network communication between
MirageOS and the Xen hypervisor maintains a shared pool of pages and reuses
them for write requests.</p>
<h3>Problem Description</h3>
<p>In version 1.10.0 of netchannel, the API for handling network requests
changed to provide higher-level network code with an interface for writing into
memory directly.  As part of this change, code paths which exposed memory taken
from the shared page pool did not ensure that previous data had been cleared
from the buffer.  This error resulted in memory which the user did not
overwrite staying resident in the buffer, and potentially being sent as part of
unrelated network communication.</p>
<p>The mirage-tcpip library, which provides interfaces for higher-level operations
like IPv4 and TCP header writes, assumes that buffers into which it writes have
been zeroed, and therefore may not explicitly write some fields which are always
zero.  As a result, some packets written with netchannel v1.10.0 which were
passed to mirage-tcpip with nonzero data will have incorrect checksums
calculated and will be discarded by the receiver.</p>
<h3>Impact</h3>
<p>This issue discloses memory intended for another recipient and corrupts packets.
Only version 1.10.0 of netchannel is affected.  Version 1.10.1 fixes this issue.</p>
<p>Version 1.10.0 was available for less than one month and many upstream users
had not yet updated their own API calls to use it.  In particular, no version of
qubes-mirage-firewall or its dependency mirage-nat compatible with version
1.10.0 was released.</p>
<h3>Workaround</h3>
<p>No workaround is available.</p>
<h3>Solution</h3>
<p>Transmitting corrupt data and disclosing memory is fixed in version 1.10.1.</p>
<p>The recommended way to upgrade is:</p>
<pre><code class="language-bash">opam update
opam upgrade netchannel
</code></pre>
<p>Or, explicitly:</p>
<pre><code class="language-bash">opam upgrade
opam reinstall netchannel=1.10.1
</code></pre>
<p>Affected releases (version 1.10.0 of netchannel and mirage-net-xen) have been marked uninstallable in the opam repository.</p>
<h3>Correction details</h3>
<p>The following list contains the correction revision numbers for each
affected branch.</p>
<p>Memory disclosure on transmit:</p>
<p>master: <a href="https://github.com/mirage/mirage-net-xen/commit/6c7a13a5dae0f58dcc0653206a73fa3d8174b6d2">6c7a13a5dae0f58dcc0653206a73fa3d8174b6d2</a></p>
<p>1.10.0: <a href="https://github.com/mirage/mirage-net-xen/commit/bd0382eabe17d0824c8ba854ec935d8a2e5f7489">bd0382eabe17d0824c8ba854ec935d8a2e5f7489</a></p>
<h3>References</h3>
<p><a href="https://github.com/mirage/mirage-net-xen">netchannel</a></p>
<p>You can find the latest version of this advisory online at
<a href="https://mirage.io/blog/MSA01">https://mirage.io/blog/MSA01</a>.</p>
<p>This advisory is signed using OpenPGP, you can verify the signature
by downloading our public key from a keyserver (<code>gpg --recv-key 4A732D757C0EDA74</code>),
downloading the raw markdown source of this advisory from <a href="https://raw.githubusercontent.com/mirage/mirage-www/master/tmpl/advisories/01.txt.asc">GitHub</a>
and executing <code>gpg --verify 01.txt.asc</code>.</p>

      
