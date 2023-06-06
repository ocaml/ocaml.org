---
title: 'Vchan: Low-latency inter-VM communication channels'
description:
url: https://mirage.io/blog/update-on-vchan
date: 2014-07-16T00:00:00-00:00
preview_image:
featured:
authors:
- Jon Ludlam
---


        <p><em>Today's post is an update to <a href="https://github.com/vbmithr">Vincent Bernardoff's</a>
<a href="https://mirage.io/blog/introducing-vchan">introducing vchan</a> blog
post, updated to use the modern build scheme for Mirage.</em></p>
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
-- in order to achieve its aims. The term <em>datagram-based interface</em> simply
means that the
<a href="http://xenbits.xen.org/gitweb/?p=xen.git%3Ba=blob%3Bf=tools/libvchan/libxenvchan.h%3Bh=6365d36a06f8c8f56454724cefc4c2f1d39beba2%3Bhb=HEAD">interface</a>
resembles UDP, although there is support for stream based communication (like
TCP) as well.</p>
<p>The <code>vchan</code> protocol is an important feature in MirageOS 2.0 since it
forms the foundational communication mechanism for <strong>building distributed
clusters of unikernels</strong> that cooperate to solve problems that are beyond
the power of a single node.  Instead of forcing communication between
nodes via a conventional wire protocol like TCP, it permits highly efficient
low-overhead communication to nodes that are colocated on the same Xen
host machine.</p>
<p>Before diving into vchan, I thought I'd also take the opportunity to describe the
<a href="http://releases.ubuntu.com/14.04/">Ubuntu-Trusty</a> environment for developing
and running <a href="http://www.xenproject.org/">Xen</a> unikernels.</p>
<h3>Installing Xen on Ubuntu</h3>
<p>Ubuntu 14.04 has good support for running Xen 4.4, the most recent release (at time of writing).
For running VMs it's a good idea to install Ubuntu on an LVM volume rather than directly on a
partition, which allows the use of LVs as the virtual disks for your VMs. On my system I have
a 40 Gig partition for '/', an 8 Gig swap partition and the rest is free for my VMs:</p>
<pre><code class="language-console">$ sudo lvs
   LV     VG      Attr      LSize  Pool Origin Data%  Move Log Copy%  Convert
   root   st28-vg -wi-ao--- 37.25g
   swap_1 st28-vg -wi-ao---  7.99g
</code></pre>
<p>In this particular walkthough I won't be using disks, but later posts will.
Install Xen via the meta-package. This brings in all you will need to run VMs:</p>
<pre><code class="language-console">$ sudo apt-get install xen-system-amd64
</code></pre>
<p>It used to be necessary to reorder the grub entries to make sure Xen was started
by default, but this is no longer necessary. Once the machine has rebooted, you
should be able to verify you're running virtualized by invoking 'xl':</p>
<pre><code class="language-console">$ sudo xl list
Name                                        ID   Mem VCPUs      State   Time(s)
Domain-0                                     0  7958     6     r-----       9.7
</code></pre>
<p>My machine has 8 Gigs of memory, and this list shows that it's all being used by
my dom0, so I'll need to either balloon down dom0 or reboot with a lower maximum
memory. Ballooning is the most straightfoward:</p>
<pre><code class="language-console">$ sudo xenstore-write /local/domain/0/memory/target 4096000
$ sudo xl list
Name                                        ID   Mem VCPUs      State   Time(s)
Domain-0                                     0  4000     6     r-----      12.2
</code></pre>
<p>This is handy for quick testing, but is <a href="http://wiki.xenproject.org/wiki/Xen_Project_Best_Practices">discouraged</a> by the Xen folks. So alternatively, change the xen command line by
editing <code>/etc/default/grub</code> and add the line:</p>
<pre><code class="language-console">GRUB_CMDLINE_XEN_DEFAULT=&quot;dom0_mem=4096M,max:4096M&quot;
</code></pre>
<p>Once again, update-grub and reboot.</p>
<h3>Mirage</h3>
<p>Now lets get Mirage up and running. Install ocaml, opam and set up the opam environment:</p>
<pre><code class="language-console">$ sudo apt-get install ocaml opam ocaml-native-compilers camlp4-extra
...
$ opam init
...
$ eval `opam config env`
</code></pre>
<p>Don't forget the <code>ocaml-native-compilers</code>, as without this we can't
compile the unikernels. Now we are almost ready to install Mirage; we
need two more dependencies, and then we're good to go.</p>
<pre><code class="language-console">$ sudo apt-get install m4 libxen-dev
$ opam install mirage mirage-xen mirage-unix vchan
</code></pre>
<p>Where <code>m4</code> is for ocamlfind, and <code>libxen-dev</code> is required to compile the
unix variants of the <code>xen-evtchn</code> and <code>xen-gnt</code> libraries. Without these
installing vchan will complain that there is no <code>xen-evtchn.lwt</code>
library installed.</p>
<p>This second line installs the various Mirage and vchan libraries, but
doesn't build the demo unikernel and Unix CLI.  To get them, clone
the ocaml-vchan repository:</p>
<pre><code class="language-console">$ git clone https://github.com/mirage/ocaml-vchan
</code></pre>
<p>The demo unikernel is a very straightforward capitalizing echo server.
The <a href="https://github.com/mirage/ocaml-vchan/blob/master/test/echo.ml#L13">main function</a> simply consists of</p>
<pre><code class="language-ocaml">let (&gt;&gt;=) = Lwt.bind

let (&gt;&gt;|=) m f = m &gt;&gt;= function
| `Ok x -&gt; f x
| `Eof -&gt; Lwt.fail (Failure &quot;End of file&quot;)
| `Error (`Not_connected state) -&gt;
    Lwt.fail (Failure (Printf.sprintf &quot;Not in a connected state: %s&quot;
      (Sexplib.Sexp.to_string (Node.V.sexp_of_state state))))

let rec echo vch =
  Node.V.read vch &gt;&gt;|= fun input_line -&gt;
  let line = String.uppercase (Cstruct.to_string input_line) in
  let buf = Cstruct.create (String.length line) in
  Cstruct.blit_from_string line 0 buf 0 (String.length line);
  Node.V.write vch buf &gt;&gt;|= fun () -&gt;
  echo vch
</code></pre>
<p>where we've defined an error-handling monadic bind (<code>&gt;&gt;|=</code>) which
is then used to sequence the read and write operations.</p>
<p>Building the CLI is done simply via <code>make</code>.</p>
<pre><code class="language-console">$ make
...
$ ls -l node_cli.native
lrwxrwxrwx 1 jludlam jludlam 52 Jul 14 14:56 node_cli.native -&gt; /home/jludlam/ocaml-vchan/_build/cli/node_cli.native
</code></pre>
<p>Building the unikernel is done via the <code>mirage</code> tool:</p>
<pre><code class="language-console">$ cd test
$ mirage configure --xen
...
$ make depend
...
$ make
...
$ ls -l mir-echo.xen echo.xl
-rw-rw-r-- 1 jludlam jludlam     596 Jul 14 14:58 echo.xl
-rwxrwxr-x 1 jludlam jludlam 3803982 Jul 14 14:59 mir-echo.xen
</code></pre>
<p>This make both the unikernel binary (the mir-echo.xen file) and a convenient
xl script to run it. To run, we use the xl tool, passing '-c' to connect
directly to the console so we can see what's going on:</p>
<pre><code class="language-console">$ sudo xl create -c echo.xl
Parsing config from echo.xl
kernel.c: Mirage OS!
kernel.c:   start_info: 0x11cd000(VA)
kernel.c:     nr_pages: 0x10000
kernel.c:   shared_inf: 0xdf2f6000(MA)
kernel.c:      pt_base: 0x11d0000(VA)
kernel.c: nr_pt_frames: 0xd
kernel.c:     mfn_list: 0x114d000(VA)
kernel.c:    mod_start: 0x0(VA)
kernel.c:      mod_len: 0
kernel.c:        flags: 0x0
kernel.c:     cmd_line:
x86_setup.c:   stack:      0x144f40-0x944f40
mm.c: MM: Init
x86_mm.c:       _text: 0x0(VA)
x86_mm.c:      _etext: 0xb8eec(VA)
x86_mm.c:    _erodata: 0xde000(VA)
x86_mm.c:      _edata: 0x1336f0(VA)
x86_mm.c: stack start: 0x144f40(VA)
x86_mm.c:        _end: 0x114d000(VA)
x86_mm.c:   start_pfn: 11e0
x86_mm.c:     max_pfn: 10000
x86_mm.c: Mapping memory range 0x1400000 - 0x10000000
x86_mm.c: setting 0x0-0xde000 readonly
x86_mm.c: skipped 0x1000
mm.c: MM: Initialise page allocator for 0x1256000 -&gt; 0x10000000
mm.c: MM: done
x86_mm.c: Pages to allocate for p2m map: 2
x86_mm.c: Used 2 pages for map
x86_mm.c: Demand map pfns at 10001000-2010001000.
Initialising timer interface
Initializing Server domid=0 xs_path=data/vchan
gnttab_stubs.c: gnttab_table mapped at 0x10001000
Server: right_order = 13, left_order = 13
allocate_buffer_locations: gntref = 9
allocate_buffer_locations: gntref = 10
allocate_buffer_locations: gntref = 11
allocate_buffer_locations: gntref = 12
Writing config into the XenStore
Shared page is:

00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0d 00 0d 00 02 01 01 00 09 00 00 00 0a 00 00 00
0b 00 00 00 0c 00 00 00
Initialization done!
</code></pre>
<p>Vchan is domain-to-domain communication, and relies on Xen's grant
tables to share the memory. The entries in the grant tables have
domain-level access control, so we need to know the domain ID of the
client and server in order to set up the communications. The test
unikernel server is hard-coded to talk to domain 0, so we only need to
know the domain ID of our echo server. In another terminal,</p>
<pre><code class="language-console">$ sudo xl list
Name                                        ID   Mem VCPUs      State   Time(s)
Domain-0                                     0  4095     6     r-----    1602.9
echo                                         2   256     1     -b----       0.0
</code></pre>
<p>In this case, the domain ID is 2, so we invoke the CLI as follows:</p>
<pre><code class="language-console">$ sudo ./node_cli.native 2
Client initializing: Received gntref = 8, evtchn = 4
Mapped the ring shared page:

00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0d 00 0d 00 02 01 01 00 09 00 00 00 0a 00 00 00
0b 00 00 00 0c 00 00 00
Correctly bound evtchn number 71
</code></pre>
<p>We're now connected via vchan to the Mirage domain. The test server
is simply a capitalisation service:</p>
<pre><code class="language-console">hello from dom0
HELLO FROM DOM0
</code></pre>
<p>Ctrl-C to get out of the CLI, and destroy the domain with an <code>xl destroy</code>:</p>
<pre><code class="language-console">$ sudo xl destroy test
</code></pre>
<p><code>vchan</code> is a very low-level communication mechanism, and so our next post on
this topic will address how to use it in combination with a name resolver
to intelligently map connection requests to use <code>vchan</code> if available, and
otherwise fall back to normal TCP or TCP+TLS.</p>

      
