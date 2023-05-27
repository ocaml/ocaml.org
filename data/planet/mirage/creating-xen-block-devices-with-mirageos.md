---
title: Creating Xen block devices with MirageOS
description:
url: https://mirage.io/blog/xen-block-devices-with-mirage
date: 2013-07-18T00:00:00-00:00
preview_image:
featured:
authors:
- Dave Scott
---


        <p><a href="https://mirage.io/">MirageOS</a> is a
<a href="http://anil.recoil.org/papers/2013-asplos-mirage.pdf">unikernel</a>
or &quot;library operating system&quot; that allows us to build applications
which can be compiled to very diverse environments: the same code can be linked
to run as a regular Unix app, relinked to run as a <a href="https://github.com/pgj/mirage-kfreebsd">FreeBSD kernel module</a>,
and even linked into a
self-contained kernel which can run on the <a href="http://www.xenproject.org/">Xen
hypervisor</a>.</p>
<p>Mirage has access to an extensive suite of pure OCaml <a href="https://github.com/mirage">libraries</a>,
covering everything from Xen <a href="https://github.com/mirage/ocaml-xen-block-driver">block</a> and <a href="https://github.com/mirage/mirage-platform/blob/master/xen/lib/netif.ml">network</a> virtual device drivers,
a <a href="https://github.com/mirage/mirage-net">TCP/IP stack</a>, OpenFlow learning switches and controllers, to
SSH and <a href="https://github.com/mirage/ocaml-cohttp">HTTP</a> server implementations.</p>
<p>I normally use Mirage to deploy applications as kernels on top of
a <a href="http://www.xenserver.org/">XenServer</a> hypervisor. I start by
first using the Mirage libraries within a normal Unix userspace
application -- where I have access to excellent debugging tools --
and then finally link my app as a high-performance Xen kernel for
production.</p>
<p>However Mirage is great for more than simply building Xen kernels.
In this post I'll describe how I've been using Mirage to create
experimental virtual disk devices for existing Xen VMs (which may
themselves be Linux, *BSD, Windows or even Mirage kernels).
The Mirage libraries let me easily
experiment with different backend file formats and protocols, all while
writing only type-safe OCaml code thats runs in userspace in a normal
Linux domain 0.</p>
<p><em>Disk devices under Xen</em></p>
<p>The protocols used by Xen disk and network devices are designed to
permit fast and efficient software implementations, avoiding the
inefficiencies inherent in emulating physical hardware in software.
The protocols are based on two primitives:</p>
<ul>
<li><em>shared memory pages</em>: used for sharing both data and metadata
</li>
<li><em>event channels</em>: similar to interrupts, these allow one side to signal the other
</li>
</ul>
<p>In the disk block protocol, the protocol starts with the client
(&quot;frontend&quot; in Xen jargon) sharing a page with the server (&quot;backend&quot;).
This single page will contain the request/response metadata, arranged
as a circular buffer or &quot;ring&quot;. The client (&quot;frontend&quot;) can then start
sharing pages containing disk blocks with the backend and pushing request
structures to the ring, updating shared pointers as it goes. The client
will give the server end a kick via an event channel signal and then both
ends start running simultaneously. There are no locks in the protocol so
updates to the shared metadata must be handled carefully, using write
memory barriers to ensure consistency.</p>
<p><em>Xen disk devices in MirageOS</em></p>
<p>Like everything else in Mirage, Xen disk devices are implemented as
libraries. The ocamlfind library called &quot;xenctrl&quot; provides support for
manipulating blocks of raw memory pages, &quot;granting&quot; access to them to
other domains and signalling event channels. There are two implementations
of &quot;xenctrl&quot;:
<a href="https://github.com/mirage/mirage-platform/tree/master/xen/lib">one that invokes Xen &quot;hypercalls&quot; directly</a>
and one which uses the <a href="https://github.com/xapi-project/ocaml-xen-lowlevel-libs">Xen userspace library libxc</a>.
Both implementations satisfy a common signature, so it's easy to write
code which will work in both userspace and kernelspace.</p>
<p>The ocamlfind library
<a href="https://github.com/mirage/shared-memory-ring">shared-memory-ring</a>
provides functions to create and manipulate request/response rings in shared
memory as used by the disk and network protocols. This library is a mix of
99.9% OCaml and 0.1% asm, where the asm is only needed to invoke memory
barrier operations to ensure that metadata writes issued by one CPU core
appear in the same order when viewed from another CPU core.</p>
<p>Finally the ocamlfind library
<a href="https://github.com/mirage/ocaml-xen-block-driver">xenblock</a>
provides functions to hotplug and hotunplug disk devices, together with an
implementation of the disk block protocol itself.</p>
<p><em>Making custom virtual disk servers with MirageOS</em></p>
<p>Let's experiment with making our own virtual disk server based on
the Mirage example program, <a href="https://github.com/mirage/xen-disk">xen-disk</a>.</p>
<p>First, install <a href="http://www.xen.org/">Xen</a>, <a href="http://www.ocaml.org/">OCaml</a>
and <a href="http://opam.ocamlpro.com/">OPAM</a>. Second initialise your system:</p>
<pre><code>  opam init
  eval `opam config env`
</code></pre>
<p>At the time of writing, not all the libraries were released as upstream
OPAM packages, so it was necessary to add some extra repositories. This
should not be necessary after the Mirage developer preview at
<a href="http://www.oscon.com/oscon2013/public/schedule/detail/28956">OSCON 2013</a>.</p>
<pre><code>  opam remote add mirage-dev https://github.com/mirage/opam-repo-dev
  opam remote add xapi-dev https://github.com/xapi-project/opam-repo-dev
</code></pre>
<p>Install the unmodified <code>xen-disk</code> package, this will ensure all the build
dependencies are installed:</p>
<pre><code>  opam install xen-disk
</code></pre>
<p>When this completes it will have installed a command-line tool called
<code>xen-disk</code>. If you start a VM using your Xen toolstack of choice
(&quot;xl create ...&quot; or &quot;xe vm-install ...&quot; or &quot;virsh create ...&quot;) then you
should be able to run:</p>
<pre><code>  xen-disk connect &lt;vmname&gt;
</code></pre>
<p>which will hotplug a fresh block device into the VM &quot;<code>&lt;vmname&gt;</code>&quot; using the
&quot;discard&quot; backend, which returns &quot;success&quot; to all read and write requests,
but actually throws all data away. Obviously this backend should only be
used for basic testing!</p>
<p>Assuming that worked ok, clone and build the source for <code>xen-disk</code> yourself:</p>
<pre><code>  git clone https://github.com/mirage/xen-disk
  cd xen-disk
  make
</code></pre>
<p><em>Making a custom virtual disk implementation</em></p>
<p>The <code>xen-disk</code> program has a set of simple built-in virtual disk implementations.
Each one satisifies a simple signature, contained in
<a href="https://github.com/mirage/xen-disk/blob/master/src/storage.mli">src/storage.mli</a>:</p>
<pre><code class="language-ocaml">type configuration = {
  filename: string;      (** path where the data will be stored *)
  format: string option; (** format of physical data *)
}
(** Information needed to &quot;open&quot; a disk *)

module type S = sig
  (** A concrete mechanism to access and update a virtual disk. *)

  type t
  (** An open virtual disk *)

  val open_disk: configuration -&gt; t option Lwt.t
  (** Given a configuration, attempt to open a virtual disk *)

  val size: t -&gt; int64
  (** [size t] is the size of the virtual disk in bytes. The actual
      number of bytes stored on media may be different. *)

  val read: t -&gt; Cstruct.t -&gt; int64 -&gt; int -&gt; unit Lwt.t
  (** [read t buf offset_sectors len_sectors] copies [len_sectors]
      sectors beginning at sector [offset_sectors] from [t] into [buf] *)

  val write: t -&gt; Cstruct.t -&gt; int64 -&gt; int -&gt; unit Lwt.t
  (** [write t buf offset_sectors len_sectors] copies [len_sectors]
      sectors from [buf] into [t] beginning at sector [offset_sectors]. *)
end
</code></pre>
<p>Let's make a virtual disk implementation which uses an existing disk
image file as a &quot;gold image&quot;, but uses copy-on-write so that no writes
persist.
This is a common configuration in Virtual Desktop Infrastructure deployments
and is generally handy when you want to test a change quickly, and
revert it cleanly afterwards.</p>
<p>A useful Unix technique for file I/O is to &quot;memory map&quot; an existing file:
this associates the file contents with a range of virtual memory addresses
so that reading and writing within this address range will actually
read or write the file contents.
The &quot;mmap&quot; C function has a number of flags, which can be used to request
&quot;copy on write&quot; behaviour. Reading the
<a href="http://caml.inria.fr/pub/docs/manual-ocaml/libref/Bigarray.Genarray.html">OCaml manual Bigarray.map_file</a>
it says:</p>
<blockquote>
<p>If shared is true, all modifications performed on the array are reflected
in the file. This requires that fd be opened with write permissions. If
shared is false, modifications performed on the array are done in memory
only, using copy-on-write of the modified pages; the underlying file is
not affected.</p>
</blockquote>
<p>So we should be able to make a virtual disk implementation which memory
maps the image file and achieves copy-on-write by setting &quot;shared&quot; to false.
For extra safety we can also open the file read-only.</p>
<p>Luckily there is already an
<a href="https://github.com/mirage/xen-disk/blob/master/src/backend.ml#L63">&quot;mmap&quot; implementation</a>
in <code>xen-disk</code>; all we need to do is tweak it slightly.
Note that the <code>xen-disk</code> program uses a co-operative threading library called
<a href="http://ocsigen.org/lwt/">lwt</a>
which replaces functions from the OCaml standard library which might block
with non-blocking variants. In
particular <code>lwt</code> uses <code>Lwt_bytes.map_file</code> as a wrapper for the
<code>Bigarray.Array1.map_file</code> function.
In the &quot;open-disk&quot; function we simply need to set &quot;shared&quot; to &quot;false&quot; to
achieve the behaviour we want i.e.</p>
<pre><code class="language-ocaml">  let open_disk configuration =
    let fd = Unix.openfile configuration.filename [ Unix.O_RDONLY ] 0o0 in
    let stats = Unix.LargeFile.fstat fd in
    let mmap = Lwt_bytes.map_file ~fd ~shared:false () in
    Unix.close fd;
    return (Some (stats.Unix.LargeFile.st_size, Cstruct.of_bigarray mmap))
</code></pre>
<p>The read and write functions can be left as they are:</p>
<pre><code class="language-ocaml">  let read (_, mmap) buf offset_sectors len_sectors =
    let offset_sectors = Int64.to_int offset_sectors in
    let len_bytes = len_sectors * sector_size in
    let offset_bytes = offset_sectors * sector_size in
    Cstruct.blit mmap offset_bytes buf 0 len_bytes;
    return ()

  let write (_, mmap) buf offset_sectors len_sectors =
    let offset_sectors = Int64.to_int offset_sectors in
    let offset_bytes = offset_sectors * sector_size in
    let len_bytes = len_sectors * sector_size in
    Cstruct.blit buf 0 mmap offset_bytes len_bytes;
    return () 
</code></pre>
<p>Now if we rebuild and run something like:</p>
<pre><code>  dd if=/dev/zero of=disk.raw bs=1M seek=1024 count=1
  losetup /dev/loop0 disk.raw
  mkfs.ext3 /dev/loop0
  losetup -d /dev/loop0

  dist/build/xen-disk/xen-disk connect &lt;myvm&gt; --path disk.raw
</code></pre>
<p>Inside the VM we should be able to do some basic speed testing:</p>
<pre><code>  # dd if=/dev/xvdb of=/dev/null bs=1M iflag=direct count=100
  100+0 records in
  100+0 records out
  104857600 bytes (105 MB) copied, 0.125296 s, 837 MB/s
</code></pre>
<p>Plus we should be able to mount the filesystem inside the VM, make changes and
then disconnect (send SIGINT to xen-disk by hitting Control+C on your terminal)
without disturbing the underlying disk contents.</p>
<p><em>So what else can we do?</em></p>
<p>Thanks to Mirage it's now really easy to experiment with custom storage types
for your existing VMs. If you have a cunning scheme where you want to hash block contents,
and use the hashes as keys in some distributed datastructure -- go ahead, it's
all easy to do. If you have ideas for improving the low-level block access protocol
then Mirage makes those experiments very easy too.</p>
<p>If you come up with a cool example with Mirage, then send us a
<a href="https://github.com/mirage">pull request</a> or send us an email to the
<a href="https://mirage.io/about/">Mirage mailing list</a> -- we'd
love to hear about it!</p>

      
