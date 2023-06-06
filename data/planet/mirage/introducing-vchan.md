---
title: Introducing vchan
description:
url: https://mirage.io/blog/introducing-vchan
date: 2013-08-23T00:00:00-00:00
preview_image:
featured:
authors:
- Vincent Bernardoff
---


        <p><em>Editor</em>: Note that some of the toolchain details of this blog post are
now out-of-date with Mirage 1.1, so we will update this shortly.</p>
<p>Unless you are familiar with Xen's source code, there is little chance
that you've ever heard of the <em>vchan</em> library or
protocol. Documentation about it is very scarce: a description can be
found on vchan's
<a href="http://xenbits.xen.org/gitweb/?p=xen.git%3Ba=blob%3Bf=xen/include/public/io/libxenvchan.h%3Bhb=HEAD">public header file</a>,
that I quote here for convenience:</p>
<blockquote>
<p>Originally borrowed from the
<a href="http://www.qubes-os.org">Qubes OS Project</a>, this code (i.e. libvchan)
has been substantially rewritten [...]
This is a library for inter-domain communication.  A standard Xen ring
buffer is used, with a datagram-based interface built on top.  The
grant reference and event channels are shared in XenStore under a
user-specified path.</p>
</blockquote>
<p>This protocol uses shared memory for inter-domain communication,
i.e. between two VMs residing in the same Xen host, and uses Xen's
mechanisms -- more specifically,
<a href="http://www.informit.com/articles/article.aspx?p=1160234&amp;seqNum=3">ring buffers</a>
and
<a href="http://xenbits.xen.org/gitweb/?p=xen.git%3Ba=blob%3Bf=tools/libxc/xenctrl.h%3Bh=f2cebafc9ddd4815ffc73fcf9e0d292b1d4c91ff%3Bhb=HEAD#l934">event channels</a>
-- in order to achieve its aims. <em>Datagram-based interface</em> simply
means that the
<a href="http://xenbits.xen.org/gitweb/?p=xen.git%3Ba=blob%3Bf=tools/libvchan/libxenvchan.h%3Bh=6365d36a06f8c8f56454724cefc4c2f1d39beba2%3Bhb=HEAD">interface</a>
resembles UDP, although there is support for stream based communication (like
TCP) as well.</p>
<p>Over the last two months or so, I worked on a <a href="http://github.com/mirage/ocaml-vchan">pure OCaml
implementation</a> of this library, meaning
that Mirage-based unikernels can now take full advantage of <em>vchan</em> to
communicate with neighboring VMs! If your endpoint -- a Linux VM or another
unikernel -- is on the same host, it is much faster and more efficient to use
vchan rather than the network stack (although unfortunately, it is currently
incompatible with existing programs written against the <code>socket</code> library under
UNIX or the <code>Flow</code> module of Mirage, although this will improve). It also
provides a higher level of security compared to network sockets as messages
will never leave the host's shared memory.</p>
<p><em>Building the vchan echo domain</em></p>
<p>Provided that you have a Xen-enabled machine, do the following from
dom0:</p>
<pre><code>    opam install mirari mirage-xen mirage vchan
</code></pre>
<p>This will install the library and its dependencies. <code>mirari</code> is
necessary to build the <em>echo unikernel</em>:</p>
<pre><code>    git clone https://github.com/mirage/ocaml-vchan
    cd test
    mirari configure --xen --no-install
    mirari build --xen
    sudo mirari run --xen
</code></pre>
<p>This will boot a <code>vchan echo domain</code> for dom0, with connection
parameters stored in xenstore at <code>/local/domain/&lt;domid&gt;/data/vchan</code>,
where <code>&lt;domid&gt;</code> is the domain id of the vchan echo domain. The echo
domain is simply an unikernel hosting a vchan server accepting
connections from dom0, and echo'ing everything that is sent to it.</p>
<p>The command <code>xl list</code> will give you the domain id of the echo
server.</p>
<p><em>Building the vchan CLI from Xen's sources</em></p>
<p>You can try it using a vchan client that can be found in Xen's sources
at <code>tools/libvchan</code>: Just type <code>make</code> in this directory. It will
compile the executable <code>vchan-node2</code> that you can use to connect to
our freshly created echo domain:</p>
<pre><code>    ./vchan-node2 client &lt;domid&gt;/local/domain/&lt;domid&gt;/data/vchan
</code></pre>
<p>If everything goes well, what you type in there will be echoed.</p>
<p>You can obtain the full API documentation for <em>ocaml-vchan</em> by doing a
<code>cd ocaml-vchan &amp;&amp; make doc</code>. If you are doing network programming
under UNIX, vchan's interface will not surprise you. If you are
already using vchan for a C project, you will see that the OCaml API
is nearly identical to what you are used to.</p>
<p>Please let us know if you use or plan to use this library in any way!
If you need tremedous speed or more security, this might fit your
needs.</p>

      
