---
title: 'MirageOS security advisory 02: mirage-xen < 3.3.0'
description:
url: https://mirage.io/blog/MSA02
date: 2019-04-26T00:00:00-00:00
preview_image:
featured:
authors:
- Thomas Leonard
---


        <h2>MirageOS Security Advisory 02 - grant unshare vulnerability in mirage-xen</h2>
<ul>
<li>Module:       mirage-xen
</li>
<li>Announced:    2019-04-25
</li>
<li>Credits:      Thomas Leonard, Mindy Preston
</li>
<li>Affects:      mirage-xen &lt; 3.3.0,
mirage-block-xen &lt; 1.6.1,
mirage-net-xen &lt; 1.10.2,
mirage-console &lt; 2.4.2,
ocaml-vchan &lt; 4.0.2,
ocaml-gnt (no longer supported)
</li>
<li>Corrected:    2019-04-22: mirage-xen 3.4.0,
2019-04-05: mirage-block-xen 1.6.1,
2019-04-02: mirage-net-xen 1.10.2,
2019-03-27: mirage-console 2.4.2,
2019-03-27: ocaml-vchan 4.0.2
</li>
</ul>
<p>For general information regarding MirageOS Security Advisories,
please visit <a href="https://mirage.io/security">https://mirage.io/security</a>.</p>
<h3>Background</h3>
<p>MirageOS is a library operating system using cooperative multitasking, which can
be executed as a guest of the Xen hypervisor. Virtual machines running on a Xen
host can communicate by sharing pages of memory. For example, when a Mirage VM
wants to use a virtual network device provided by a Linux dom0:</p>
<ol>
<li>The Mirage VM reserves some of its memory for this purpose and writes an entry
to its <em>grant table</em> to say that dom0 should have access to it.
</li>
<li>The Mirage VM tells dom0 (via XenStore) about the grant.
</li>
<li>dom0 asks Xen to map the memory into its address space.
</li>
</ol>
<p>The Mirage VM and dom0 can now communicate using this shared memory.
When dom0 has finished with the memory:</p>
<ol>
<li>dom0 tells Xen to unmap the memory from its address space.
</li>
<li>dom0 tells the Mirage VM that it no longer needs the memory.
</li>
<li>The Mirage VM removes the entry from its grant table.
</li>
<li>The Mirage VM may reuse the memory for other purposes.
</li>
</ol>
<h3>Problem Description</h3>
<p>Mirage removes the entry by calling the <a href="https://github.com/mirage/mini-os/blob/94cb25eb73e58e5c825c1ad5f6cf3d2647603a50/gnttab.c#L98">gnttab_end_access</a> function in Mini-OS.
This function checks whether the remote domain still has the memory mapped. If so,
it returns 0 to indicate that the entry cannot be removed yet. To make this function
available to OCaml code, the <a href="https://github.com/mirage/mirage-xen/blob/v3.2.0/bindings/gnttab_stubs.c#L227">stub_gntshr_end_access</a> C stub in mirage-xen wrapped this
with the OCaml calling conventions. Unfortunately, it ignored the return code and reported
success in all cases.</p>
<h3>Impact</h3>
<p>A malicious VM can tell a MirageOS unikernel that it has finished using some
shared memory while it is still mapped. The Mirage unikernel will think that
the unshare operation has succeeded and may reuse the memory, or allow it to be
garbage collected. The malicious VM will still have access to the memory.</p>
<p>In many cases (such as in the example above) the remote domain will be dom0,
which is already fully trusted. However, if a unikernel shares memory with an
untrusted domain then there is a problem.</p>
<h3>Workaround</h3>
<p>No workaround is available.</p>
<h3>Solution</h3>
<p>Returning the result from the C stub required changes to the OCaml grant API to
deal with the result. This turned out to be difficult because, for historical
reasons, the OCaml part of the API was in the ocaml-gnt package while the C stubs
were in mirage-xen, and because the C stubs are also shared with the Unix backend.</p>
<p>We instead created a <a href="https://github.com/mirage/mirage-xen/pull/9">new grant API</a> in mirage-xen, migrated all existing
Mirage drivers to use it, and then dropped support for the old API.
mirage-xen 3.3.0 added support for the new API and 3.4.0 removed support for the
old one.</p>
<p>The recommended way to upgrade is:</p>
<pre><code class="language-bash">opam update
opam upgrade mirage-xen
</code></pre>
<h3>Correction details</h3>
<p>The following PRs were part of the fix:</p>
<ul>
<li><a href="https://github.com/mirage/mirage-xen/pull/9">mirage-xen/pull/9</a> - Add grant-handling code to OS.Xen
</li>
<li><a href="https://github.com/mirage/mirage-net-xen/pull/85">mirage-net-xen/pull/85</a> - Use new OS.Xen API for grants
</li>
<li><a href="https://github.com/mirage/ocaml-vchan/pull/125">ocaml-vchan/pull/125</a> - Update to new OS.Xen grant API
</li>
<li><a href="https://github.com/mirage/mirage-block-xen/pull/79">mirage-block-xen/pull/79</a> - Port to new grant interface provided by mirage-xen
</li>
<li><a href="https://github.com/mirage/mirage-console/pull/75">mirage-console/pull/75</a> - Use new grant interface in mirage-xen
</li>
<li><a href="https://github.com/mirage/mirage-xen/pull/12">mirage-xen/pull/12</a> - Drop support for old ocaml-gnt package
</li>
</ul>
<h3>References</h3>
<p>You can find the latest version of this advisory online at
<a href="https://mirage.io/blog/MSA02">https://mirage.io/blog/MSA02</a>.</p>
<p>This advisory is signed using OpenPGP, you can verify the signature
by downloading our public key from a keyserver (<code>gpg --recv-key 4A732D757C0EDA74</code>),
downloading the raw markdown source of this advisory from
<a href="https://raw.githubusercontent.com/mirage/mirage-www/master/tmpl/advisories/02.txt.asc">GitHub</a>
and executing <code>gpg --verify 02.txt.asc</code>.</p>

      
