---
title: Building a "Xenstore stub domain" with MirageOS
description:
url: https://mirage.io/blog/xenstore-stub-domain
date: 2012-09-12T00:00:00-00:00
preview_image:
featured:
authors:
- Dave Scott
---


        <p>[ <em>Due to continuing development, some of the details in this blog post are now out-of-date. It is archived here.</em> ]</p>
<p>On all hosts running <a href="http://www.xen.org/">Xen</a>, there is a critical service called <a href="http://wiki.xen.org/wiki/XenStore">xenstore</a>.
Xenstore is used to allow <em>untrusted</em> user VMs to communicate with <em>trusted</em> system VMs, so that</p>
<ul>
<li>virtual disk and network connections can be established
</li>
<li>performance statistics and OS version information can be shared
</li>
<li>VMs can be remotely power-cycled, suspended, resumed, snapshotted and migrated.
</li>
</ul>
<p>If the xenstore service fails then at best the host cannot be controlled (i.e. no VM start or shutdown)
and at worst VM isolation is compromised since an untrusted VM will be able to gain unauthorised access to disks or networks.
This blog post examines how to disaggregate xenstore from the monolithic domain 0, and run it as an independent <a href="http://www.cl.cam.ac.uk/~dgm36/publications/2008-murray2008improving.pdf">stub domain</a>.</p>
<p>Recently in the Xen community, Daniel De Graaf and Alex Zeffertt have added support for
<a href="http://lists.xen.org/archives/html/xen-devel/2012-01/msg02349.html">xenstore stub domains</a>
where the xenstore service is run directly as an OS kernel in its own isolated VM. In the world of Xen,
a running VM is a &quot;domain&quot; and a &quot;stub&quot; implies a single-purpose OS image rather than a general-purpose
machine.
Previously if something bad happened in &quot;domain 0&quot; (the privileged general-purpose OS where xenstore traditionally runs)
such as an out-of-memory event or a performance problem, then the critical xenstore process might become unusable
or fail altogether. Instead if xenstore is run as a &quot;stub domain&quot; then it is immune to such problems in
domain 0. In fact, it will even allow us to <em>reboot</em> domain 0 in future (along with all other privileged
domains) without incurring any VM downtime during the reset!</p>
<p>The new code in <a href="http://xenbits.xensource.com/xen-unstable.hg">xen-unstable.hg</a> lays the necessary groundwork
(Xen and domain 0 kernel changes) and ports the original C xenstored to run as a stub domain.</p>
<p>Meanwhile, thanks to <a href="http://tab.snarc.org">Vincent Hanquez</a> and <a href="http://gazagnaire.org">Thomas Gazagnaire</a>, we also have an
<a href="http://gazagnaire.org/pub/SSGM10.pdf">OCaml implementation of xenstore</a> which, as well as the offering
memory-safety, also supports a high-performance transaction engine, necessary for surviving a stressful
&quot;VM bootstorm&quot; event on a large server in the cloud. Vincent and Thomas' code is Linux/POSIX only.</p>
<p>Ideally we would have the best of both worlds:</p>
<ul>
<li>a fast, memory-safe xenstored written in OCaml,
</li>
<li>running directly as a Xen stub domain i.e. as a specialised kernel image without Linux or POSIX
</li>
</ul>
<p>We can now do both, using Mirage!  If you're saying, &quot;that sounds great! How do I do that?&quot; then read on...</p>
<p><em>Step 1: remove dependency on POSIX/Linux</em></p>
<p>If you read through the existing OCaml xenstored code, it becomes obvious that the main uses of POSIX APIs are for communication
with clients, both Unix sockets and for a special Xen inter-domain shared memory interface. It was a fairly
painless process to extract the required socket-like IO signature and turn the bulk of the server into
a <a href="http://caml.inria.fr/pub/docs/manual-ocaml-4.00/manual004.html">functor</a>. The IO signature ended up looking approximately like:</p>
<pre><code class="language-ocaml">    type t
    val read: t -&gt; string -&gt; int -&gt; int -&gt; int Lwt.t
    val write: t -&gt; string -&gt; int -&gt; int -&gt; unit Lwt.t
    val destroy: t -&gt; unit Lwt.t
</code></pre>
<p>For now the dependency on <a href="http://ocsigen.org/lwt/">Lwt</a> is explicit but in future I'll probably make it more abstract so we
can use <a href="https://ocaml.janestreet.com/?q=node/100">Core Async</a> too.</p>
<p><em>Step 2: add a Mirage Xen IO implementation</em></p>
<p>In a stub-domain all communication with other domains is via shared memory pages and &quot;event channels&quot;.
Mirage already contains extensive support for using these primitives, and uses them to create fast
network and block virtual device drivers. To extend the code to cover the Xenstore stub domain case,
only a few tweaks were needed to add the &quot;server&quot; side of a xenstore ring communication, in addition
to the &quot;client&quot; side which was already present.</p>
<p>In Xen, domains share memory by a system of explicit &quot;grants&quot;, where a client (called &quot;frontend&quot;)
tells the hypervisor to allow a server (called &quot;backend&quot;) access to specific memory pages. Mirage
already had code to create such grants, all that was missing was a few simple functions to receive
grants from other domains.</p>
<p>These changes are all in the current <a href="https://github.com/mirage/mirage-platform">mirage-platform</a>
tree.</p>
<p><em>Step 3: add a Mirage Xen &quot;main&quot; module and Makefile</em></p>
<p>The Mirage &quot;main&quot; module necessary for a stub domain looks pretty similar to the normal Unix
userspace case except that it:</p>
<ul>
<li>arranges to log messages via the VM console (rather than a file or the network, since a disk or network device cannot be created without a working xenstore, and it's important not to introduce a bootstrap
problem here)
</li>
<li>instantiates the server functor with the shared memory inter-domain IO module.
</li>
</ul>
<p>The Makefile looks like a regular Makefile, invoking ocamlbuild. The whole lot is built with
<a href="http://oasis.forge.ocamlcore.org/">OASIS</a> with a small extension added by <a href="http://anil.recoil.org/">Anil</a> to set a few options
required for building Xen kernels rather than regular binaries.</p>
<p>... and it all works!</p>
<p>The code is in two separate repositories:</p>
<ul>
<li><a href="https://github.com/djs55/ocaml-xenstore">ocaml-xenstore</a>: contains all the generic stuff
</li>
<li><a href="https://github.com/djs55/ocaml-xenstore-xen">ocaml-xenstore-xen</a>: contains the unix userspace
and xen stub domain IO modules and &quot;main&quot; functions
</li>
<li>(optional) To regenerate the OASIS file, grab the <code>add-xen</code> branch from this <a href="http://github.com/avsm/oasis">OASIS fork</a>.
</li>
</ul>
<p><em>Example build instructions</em></p>
<p>If you want to try building it yourself, try the following on a modern 64-bit OS. I've tested these
instructions on a fresh install of Debian Wheezy.</p>
<p>First install OCaml and the usual build tools:</p>
<pre><code>    apt-get install ocaml build-essential git curl rsync
</code></pre>
<p>Then install the OCamlPro <code>opam</code> package manager to simplify the installation of extra packages</p>
<pre><code>    git clone https://github.com/OCamlPro/opam.git
    cd opam
    make
    make install
    cd ..
</code></pre>
<p>Initialise OPAM with the default packages:</p>
<pre><code>    opam --yes init
    eval `opam config -env`
</code></pre>
<p>Add the &quot;mirage&quot; development package source (this step will not be needed once the package definitions are upstreamed)</p>
<pre><code>    opam remote -add dev https://github.com/mirage/opam-repo-dev
</code></pre>
<p>Switch to the special &quot;mirage&quot; version of the OCaml compiler</p>
<pre><code>    opam --yes switch -install 3.12.1+mirage-xen
    opam --yes switch 3.12.1+mirage-xen
    eval `opam config -env`
</code></pre>
<p>Install the generic Xenstore protocol libraries</p>
<pre><code>    opam --yes install xenstore
</code></pre>
<p>Install the Mirage development libraries</p>
<pre><code>    opam --yes install mirage
</code></pre>
<p>If this fails with &quot;+ runtime/dietlibc/lib/atof.c:1: sorry, unimplemented: 64-bit mode not compiled in&quot; it means you need a 64-bit build environment.
Next, clone the xen stubdom tree</p>
<pre><code>    git clone https://github.com/djs55/ocaml-xenstore-xen
</code></pre>
<p>Build the Xen stubdom</p>
<pre><code>    cd ocaml-xenstore-xen
    make
</code></pre>
<p>The binary now lives in <code>xen/_build/src/server_xen.xen</code></p>
<p><em>Deploying on a Xen system</em></p>
<p>Running a stub Xenstored is a little tricky because it depends on the latest and
greatest Xen and Linux PVops kernel. In the future it'll become much easier (and probably
the default) but for now you need the following:</p>
<ul>
<li>xen-4.2 with XSM (Xen Security Modules) turned on
</li>
<li>A XSM/FLASK policy which allows the stubdom to call the &quot;domctl getdomaininfo&quot;. For the moment it's safe to skip this step with the caveat that xenstored will leak connections when domains die.
</li>
<li>a Xen-4.2-compatible toolstack (either the bundled xl/libxl or xapi with <a href="http://github.com/djs55/xen-api/tree/xen-4.2">some patches</a>)
</li>
<li>Linux-3.5 PVops domain 0 kernel
</li>
<li>the domain builder binary <code>init-xenstore-domain</code> from <code>xen-4.2/tools/xenstore</code>.
</li>
</ul>
<p>To turn the stub xenstored on, you need to edit whichever <code>init.d</code> script is currently starting xenstore and modify it to call</p>
<pre><code>    init-xenstore-domain /path/to/server_xen.xen 256 flask_label
</code></pre>

      
