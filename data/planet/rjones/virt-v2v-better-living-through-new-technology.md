---
title: 'virt-v2v: better living through new technology'
description: "If you ever used the old version of virt-v2v, our software that converts
  guests to run on KVM, then you probably found it slow, but worse still it was slow
  and could fail at the end of the conversi\u2026"
url: https://rwmj.wordpress.com/2014/08/29/virt-v2v-better-living-through-new-technology/
date: 2014-08-29T21:26:08-00:00
preview_image: https://s0.wp.com/i/blank.jpg
featured:
authors:
- rjones
---

<p>If you ever used the old version of <a href="http://libguestfs.org/virt-v2v/">virt-v2v</a>, our software that converts guests to run on KVM, then you probably found it slow, but worse still it was slow and could fail at the end of the conversion (after possibly an hour or more).  No one liked that, least of all the developers and support people who had to help people use it.</p>
<p>A V2V conversion is intrinsically going to take a long time, because it always involves copying huge disk images around.  These can be gigabytes or even terabytes in size.</p>
<p>My main aim with the rewrite was to do all the work up front (and if the conversion is going to fail, then fail early), and leave the huge copy to the last step.  The second aim was to work much harder to minimize the amount of data that we need to copy, so the copy is quicker.  I achieved both of these aims using a lot of new technology that we developed for qemu in RHEL 7.</p>
<p>Virt-v2v works (now) by putting an overlay on top of the source disk.  This overlay protects the source disk from being modified.  All the writes done to the source disk during conversion (eg. modifying config files and adding device drivers) are saved into the overlay.  Then we <a href="http://linux.die.net/man/1/qemu-img">qemu-img convert</a> the overlay to the final target.  Although this sounds simple and possibly obvious, none of this could have been done when we wrote old virt-v2v.  It is possible now because:</p>
<ul>
<li> qcow2 overlays can now have virtual backing files that come from HTTPS or <a href="https://rwmj.wordpress.com/2013/03/21/qemu-ssh-block-device/#content">SSH</a> sources.  This allows us to place the overlay on top of (eg) a VMware vCenter Server source without having to copy the whole disk from the source first.
</li><li> qcow2 overlays can perform copy-on-read.  This means you only need to read each block of data from the source once, and then it is cached in the overlay, making things much faster.
</li><li> qemu now has excellent <a href="https://rwmj.wordpress.com/2014/03/13/new-in-virt-sparsify-in-place-sparsification/#content">discard and trim support</a>.  To minimize the amount of data that we copy, we first <a href="http://libguestfs.org/guestfs.3.html#guestfs_fstrim">fstrim the filesystems</a>.  This causes the overlay to remember which bits of the filesystem are used and only copy those bits.
</li><li> <a href="https://www.mail-archive.com/ntfs-3g-devel@lists.sourceforge.net/msg01060.html">I added support for fstrim to ntfs-3g</a> so this works for Windows guests too.
</li><li> <a href="http://libguestfs.org/guestfs.3.html#remote-storage">libguestfs has support for remote storage</a>, <a href="https://rwmj.wordpress.com/2013/09/02/new-in-libguestfs-allow-cache-mode-to-be-selected/#content">cachemode</a>, discard, copy-on-read and more, meaning we can use all these features in virt-v2v.
</li><li> We use OCaml &mdash; not C, and not type-unsafe languages &mdash; to ensure that the compiler is helping us to find bugs in the code that we write, and also to ensure that we end up with an optimized, standalone binary that requires no runtime support/interpreters and can be shipped everywhere.
</li></ul>

