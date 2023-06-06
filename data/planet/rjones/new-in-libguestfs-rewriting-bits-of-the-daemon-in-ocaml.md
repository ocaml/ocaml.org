---
title: 'New in libguestfs: Rewriting bits of the daemon in OCaml'
description: "libguestfs is a C library for creating and editing disk images. In the
  most common (but not the only) configuration, it uses KVM to sandbox access to disk
  images. The C library talks to a separate \u2026"
url: https://rwmj.wordpress.com/2017/06/04/new-in-libguestfs-rewriting-bits-of-the-daemon-in-ocaml/
date: 2017-06-04T13:14:17-00:00
preview_image: https://s0.wp.com/i/blank.jpg
featured:
authors:
- rjones
---

<p><a href="http://libguestfs.org/">libguestfs</a> is a C library for creating and editing disk images.  In the most common (but not the only) configuration, it uses KVM to sandbox access to disk images.  The C library talks to a separate daemon running inside a KVM appliance, as in this Unicode-art diagram taken from the <a href="http://libguestfs.org/guestfs-internals.1.html#architecture">fine manual</a>:</p>
<pre>
 &#9484;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9488;
 &#9474; main program      &#9474;
 &#9474;                   &#9474;
 &#9474;                   &#9474;           child process / appliance
 &#9474;                   &#9474;          &#9484;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9488;
 &#9474;                   &#9474;          &#9474; qemu                     &#9474;
 &#9500;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9508;   RPC    &#9474;      &#9484;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9488; &#9474;
 &#9474; libguestfs  &#9664;&#9549;&#9549;&#9549;&#9549;&#9549;&#9549;&#9549;&#9549;&#9549;&#9549;&#9549;&#9549;&#9549;&#9549;&#9549;&#9549;&#9549;&#9549;&#9549;&#9549;&#9549;&#9549;&#9549;&#9654; guestfsd        &#9474; &#9474;
 &#9474;                   &#9474;          &#9474;      &#9500;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9508; &#9474;
 &#9492;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9496;          &#9474;      &#9474; Linux kernel    &#9474; &#9474;
                                &#9474;      &#9492;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9516;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9496; &#9474;
                                &#9492;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9474;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9496;
                                                &#9474;
                                                &#9474; virtio-scsi
                                         &#9484;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9524;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9488;
                                         &#9474;  Device or  &#9474;
                                         &#9474;  disk image &#9474;
                                         &#9492;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9496;
</pre>
<p>The library has to be written in C because it needs to be linked to any main program.  The daemon (<code>guestfsd</code> in the diagram) is also written in C.  But there&rsquo;s not so much a specific reason for that, except that&rsquo;s what we did historically.</p>
<p><a href="https://github.com/libguestfs/libguestfs/tree/master/daemon">The daemon is essentially a big pile of functions</a>, most corresponding to a libguestfs API.  Writing the daemon in C is painful to say the least.  Because it&rsquo;s a long-running process running in a memory-constrained environment, we have to be very careful about memory management, religiously checking every return from <code>malloc</code>, <code>strdup</code> etc., making even the simplest task non-trivial and full of untested code paths.</p>
<p>So last week I modified libguestfs so you can now write APIs in <a href="https://ocaml.org/">OCaml</a> if you want to.  OCaml is a high level language that compiles down to object files, and it&rsquo;s entirely possible to link the daemon from a mix of C object files and OCaml object files.  Another advantage of OCaml is that you can call from C <img src="https://s0.wp.com/wp-content/mu-plugins/wpcom-smileys/twemoji/2/72x72/2194.png" alt="&harr;" class="wp-smiley" style="height: 1em; max-height: 1em;"/> OCaml with relatively little glue code (although a <i>dis</i>advantage is that you still need to write that glue mostly by hand).  Most <a href="https://camltastic.blogspot.co.uk/2008/08/tip-calling-c-functions-directly-with.html">simple calls turn into direct CALL instructions</a> with just a simple bitshift required to convert between ints and bools on the C and OCaml sides.  More complex calls passing strings and structures are not too difficult either.</p>
<p>OCaml also turns memory errors into a single exception, which unwinds the stack cleanly, so we don&rsquo;t litter the code with memory handling.  We can still run the mixed C/OCaml binary under valgrind.</p>
<p>Code gets quite a bit shorter.  For example the <a href="http://libguestfs.org/guestfs.3.html#guestfs_case_sensitive_path">case_sensitive_path</a> API &mdash; all string handling and directory lookups &mdash; <a href="https://www.redhat.com/archives/libguestfs/2017-June/msg00019.html">goes from 183 lines of C code to 56 lines of OCaml code</a> (and much easier to understand too).</p>
<p>I&rsquo;m reimplementing a few APIs in OCaml, but the plan is definitely not to convert them all.  I think we&rsquo;ll have C and OCaml APIs in the daemon for a very long time to come.</p>

