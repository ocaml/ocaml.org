---
title: Announcing MirageOS 3.6.0
description:
url: https://mirage.io/blog/announcing-mirage-36-release
date: 2019-10-18T00:00:00-00:00
preview_image:
featured:
authors:
- Martin Lucina
---


        <p>We are pleased to announce the release of MirageOS 3.6.0. This release updates MirageOS to support <a href="https://github.com/Solo5/solo5">Solo5</a> 0.6.0 and later.</p>
<p>New features:</p>
<ul>
<li>Support for the Solo5 <code>spt</code> (sandboxed process tender) target via <code>mirage configure -t spt</code>. The <code>spt</code> target runs MirageOS unikernels in a minimal strict seccomp sandbox on Linux <code>x86_64</code>, <code>aarch64</code> and <code>ppc64le</code> hosts.
</li>
<li>Support for the Solo5 <em>application manifest</em>, enabling support for multiple network and block storage devices on the <code>hvt</code>, <code>spt</code> and <code>muen</code> targets. The <code>genode</code> and <code>virtio</code> targets are still limited to using a single network or block storage device.
</li>
<li>Several notable security enhancements to Solo5 targets, such as enabling stack smashing protection throughout the toolchain by default and improved page protections on some targets.  For details, please refer to the Solo5 0.6.0 <a href="https://github.com/Solo5/solo5/releases/tag/v0.6.0">release notes</a>.
</li>
</ul>
<p>Additional user-visible changes:</p>
<ul>
<li>Solo5 0.6.0 has removed the compile-time specialization of the <code>solo5-hvt</code> tender. As a result, a <code>solo5-hvt</code> binary is no longer built at <code>mirage build</code> time. Use the <code>solo5-hvt</code> binary installed in your <code>$PATH</code> by OPAM to run the unikernel.
</li>
<li><code>mirage build</code> now produces silent <code>ocamlbuild</code> output by default. To get the old behaviour, run with <code>--verbose</code> or set the log level to <code>info</code> or <code>debug</code>.
</li>
<li>New functions <code>Mirage_key.is_solo5</code> and <code>Mirage_key.is_xen</code>, analogous to <code>Mirage_key.is_unix</code>.
</li>
</ul>
<p>Thanks to Hannes Mehnert for help with the release engineering for MirageOS 3.6.0.</p>

      
