---
title: OpenBSD C2K5 thoughts
description: Reflections on OpenBSD C2K5 hackathon projects and progress.
url: https://anil.recoil.org/notes/c2k5-thoughts
date: 2005-06-04T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
ignore: true
---

<p>Finally had some time to get back from the OpenBSD hackathon and take
stock of what I worked on. It was pretty interesting one this year, as I
went without having much idea of what to work on (unlike last year, when
I had a mad backlog to catch up on).</p>
<p>Some stuff I did during the week included:</p>
<ul>
<li>Clean up the <a href="http://www.openbsd.org/cgi-bin/cvsweb.cgi/src/usr.bin/ssh/atomicio.c">atomicio</a>
interface used in <a href="http://www.openssh.com">OpenSSH</a> and
<em><a href="http://www.openbsd.org/cgi-bin/man.cgi?query=nc">nc(1)</a></em> to
provide simpler semantics. Error checking from read/write functions
are a real headache in C, as the functions return <code>-1</code> on error,
which means a signed <code>ssize_t</code> is returned. However, they accept an
unsigned value as the size of the buffer to process, which means
they could potentially return a value outside the range of the
return value. This means you have to check if the return is <code>-1</code>,
which indicates an error, and otherwise cast to a <code>size_t</code> to
correctly get the buffer size back. With the new atomicio, it always
returns a <code>size_t</code>, and returns <code>0</code> to signal an error (with <code>errno</code>
containing the error, and <code>EPIPE</code> being set for an <code>EOF</code> condition).</li>
<li>Start looking at the Bluetooth stack to get L2CAP and RFCOMM
support. We are half-way through un-netgraphing the FreeBSD stack
and having a more traditional <code>netbt</code> socket interface (much like
<code>netinet</code> or <code>netinet6</code>) to Bluetooth.</li>
<li>Use <a href="http://cil.sf.net/">CIL</a> to implement a few fun kernel
source-&gt;source transforms. <code>kerneltrace</code> just accepts a regular
expression and inserts a <code>printf</code> in the function prologue which
outputs the function name and any arguments passed into it. Had this
idea when chatting with <a href="http://www.monkey.org/~marius/">Marius</a>,
and it turned out to be very useful when trying to figure out
dataflow in the Bluetooth stack (just compile with
<code>make CC="/usr/local/bin/cilly --dokerneltrace --trace-regexp='ubt|ng_blue'"</code>).
The second one was even simpler; <code>randomvars</code> assigns a non-zero
value to every local variable in a function call to help track down
uninitialized-local-variable bugs. Heres
<a href="http://www.openbsd.org/cgi-bin/cvsweb.cgi/src/usr.bin/mg/search.c.diff?r1=1.15&amp;r2=1.16">one</a>
Chad Loder found in
<em><a href="http://www.openbsd.org/cgi-bin/man.cgi?query=mg">mg(1)</a></em>.</li>
<li>Other random <a href="http://marc.theaimsgroup.com/?l=openbsd-cvs&amp;m=111689009724884&amp;w=2">signed/unsigned cleanups</a>
in OpenSSH. Boring but important I guess...</li>
</ul>
<p>All in all, the hackathon re-motivated me to continue work on the
OCaml-based daemons that <a href="https://github.com/djs55" class="contact">Dave Scott</a> and I have been
hacking on. I don't want to be fixing random buffer or integer overflows
in an OpenBSD hackathon 5 years from now; we need to move on to more
high-level issues.</p>

