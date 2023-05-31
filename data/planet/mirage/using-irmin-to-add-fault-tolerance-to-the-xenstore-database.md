---
title: Using Irmin to add fault-tolerance to the Xenstore database
description:
url: https://mirage.io/blog/introducing-irmin-in-xenstore
date: 2014-07-21T00:00:00-00:00
preview_image:
featured:
authors:
- Dave Scott
---


        <p><em>This is the second in a series of posts that introduces the <a href="https://github.com/mirage/irmin">Irmin</a> distributed storage engine.
You might like to begin with the <a href="https://mirage.io/blog/introducing-irmin">introductory post</a>.</em></p>
<p><a href="http://wiki.xen.org/wiki/XenStore">Xenstore</a> is a critical service found on all hosts
running <a href="http://www.xen.org/">Xen</a>. Xenstore is necessary to</p>
<ul>
<li>configure all VM I/O devices such as disk controllers and network interface cards;
</li>
<li>share performance statistics and OS version information; and
</li>
<li>signal VMs during shutdown, suspend, resume, migrate etc.
</li>
</ul>
<p>Xenstore must be <strong>reliable</strong>: if it fails then the host is unmanageable and must be rebooted.</p>
<p>Xenstore must be <strong>secure</strong>: if it is compromised by a VM then that VM can access data belonging
to other VMs.</p>
<p>The current version of Xenstore is <a href="http://xenbits.xen.org/gitweb/?p=xen.git%3Ba=tree%3Bf=tools/ocaml/xenstored%3Bh=0d762f2a61de098c0100814e0c140575b51688a3%3Bhb=stable-4.4">already written in OCaml</a>
and documented in the paper
<a href="http://gazagnaire.org/pub/GH09.pdf">OXenstored: an efficient hierarchical and transactional database using functional programming with reference cell comparisons</a> presented at ICFP 2009.
The existing code works very reliably, but there is always room for improvement
for debuggability of such a complex system component. This is where Irmin, the
storage layer of Mirage 2.0, can help.</p>
<p>But first, a quick Xenstore primer:</p>
<h3>Xen and Xenstore in 30 seconds</h3>
<p>The Xen hypervisor focuses on isolating VMs from each-other; the hypervisor provides a virtual CPU scheduler
and a memory allocator but does not perform I/O on behalf of guest VMs.
On a Xen host, privileged server VMs perform I/O on behalf of client VMs.
The configuration for calculating which server VM services requests for which client VMs is stored in Xenstore, as
key/value pairs.</p>
<p>The following diagram shows a Xen host with a single client and server VM, with
a single virtual device in operation.  Disk blocks and network packets flow via
shared memory between Xen-aware drivers in the VMs, shown in the lower-half.
The control-plane, shown in the upper-half, contains the metadata about the
datapath: how the device should appear in the client VM; where the I/O should
go in the server VM; where the shared memory control structures are etc.</p>
<img src="https://mirage.io/graphics/xenstore-diagram.png" alt="Device configuration is stored in Xenstore as key=value pairs."/>
<p>The Xenstore device attach protocol insists that all device keys are added
through atomic transactions, i.e. partial updates are never visible to clients and transactions
cannot interfere with each other.
A Xenstore server must abort transactions whose operations were not successfully
isolated from other transactions. After an abort, the client is expected to retry.
Each key=value write is communicated to the server as a single request/response, so transactions
comprising multiple writes are open for multiple round-trip times.
This protocol is baked into guest VM kernels (including Linux, FreeBSD, Mirage, ...)
and won't change anytime soon.</p>
<p>Xenstore is used heavily when lots of VMs are starting in parallel. Each VM typically
has several devices, each of these devices is added in a parallel transaction and therefore
many transactions are open at once. If the server aborts too many of these transactions,
causing the clients to retry, the system will make little progress and may appear to live-lock.
The challenge for a Xenstore implementation is to minimise the number of aborted
transactions and retries, without compromising on the isolation guarantee.</p>
<h3>Irmin Xenstore design goals</h3>
<p>The design goals of the Irmin-based Mirage Xenstore server are:</p>
<ol>
<li>safely restart after a crash;
</li>
<li>make system debugging easy; and
</li>
<li>go really fast!
</li>
</ol>
<p>How does Irmin help achieve these goals?</p>
<h3>Restarting after crashes</h3>
<p>The Xenstore service is a reliable component and very rarely crashes. However,
if a crash does occur, the impact is severe on currently running virtual
machines. There is no protocol for a running VM to close its connection to a
Xenstore and open a new one, so if Xenstore crashes then running VMs are simply
left orphaned. VMs in this state are impossible to manage properly: there is no
way to shut them down cleanly, to suspend/resume or migrate, or to configure
any disk or network interfaces. If Xenstore crashes, the host must be rebooted
shortly after.</p>
<p>Irmin helps make Xenstore recoverable after a crash, by providing a library
that applications can use to persist and synchronise distributed data
structures on disk and in memory. By using Irmin to persist all our state
somewhere sensible and taking care to manage our I/O carefully, then the server
process becomes stateless and can be restarted at will.</p>
<p>To make Xenstore use Irmin,
the first task is to enumerate all the different kinds of state in the running process.
This includes the obvious key-value pairs used for VM configuration
as well as data currently hidden away in the OCaml heap:
the addresses in memory of established communication rings,
per-domain quotas, pending watch events and watch registrations etc etc.
Once the state has been enumerated it must be mapped onto key-value pairs which can
be stored in Irmin. Rather than using ad-hoc mappings everywhere, the Mirage Irmin
server has
<a href="https://github.com/mirage/ocaml-xenstore-server/blob/blog/introducing-irmin-in-xenstore/server/pMap.mli">persistent Maps</a>,
<a href="https://github.com/mirage/ocaml-xenstore-server/blob/blog/introducing-irmin-in-xenstore/server/pSet.ml">persistent Sets</a>,
<a href="https://github.com/mirage/ocaml-xenstore-server/blob/blog/introducing-irmin-in-xenstore/server/pQueue.ml">persistent Queues</a>
and
<a href="https://github.com/mirage/ocaml-xenstore-server/blob/blog/introducing-irmin-in-xenstore/server/pRef.ml">persistent reference cells</a>.</p>
<p>Irmin applications are naturally written as functors, with the details of the persistence kept
abstract.
The following <a href="https://github.com/mirage/irmin/blob/0.8.3/lib/core/irminView.mli">Irmin-inspired</a> signature represents what Xenstore needs
from Irmin:</p>
<pre><code class="language-ocaml">module type VIEW = sig
  type t

  val create: unit -&gt; t Lwt.t
  (** Create a fresh VIEW from the current state of the store.
      A VIEW tracks state queries and updates and acts like a branch
      which has an explicit [merge]. *)

  val read: t -&gt; Protocol.Path.t -&gt; 
    [ `Ok of Node.contents | `Enoent of Protocol.Path.t ] Lwt.t
  (** Read a single key *)

  val list: t -&gt; Protocol.Path.t -&gt; 
    [ `Ok of string list | `Enoent of Protocol.Path.t ] Lwt.t
  (** List all the children of a key *)

  val write: t -&gt; Protocol.Path.t -&gt; Node.contents -&gt; 
    [ `Ok of unit ] Lwt.t
  (** Update a single key *)

  val mem: t -&gt; Protocol.Path.t -&gt; bool Lwt.t
  (** Check whether a key exists *)

  val rm: t -&gt; Protocol.Path.t -&gt; [ `Ok of unit ] Lwt.t
  (** Remove a key *)

  val merge: t -&gt; string -&gt; bool Lwt.t
  (** Merge this VIEW into the current state of the store *)
end
</code></pre>
<p>The main 'business logic' of Xenstore can then be functorised over this signature relatively easily.
All we need is to instantiate the functor using Irmin to persist the data somewhere sensible.
Eventually we will need two instantiations: one which runs as a userspace application and which
writes to the filesystem; and a second which will run as a
native Xen kernel (known as a <a href="https://mirage.io/blog/xenstore-stub-domain">xenstore stub domain</a>)
and which will write to a fixed memory region (like a ramdisk).
The choice of which to use is left to the system administrator. Currently most (if not all)
distribution packagers choose to run Xenstore in userspace. Administrators who wish to
further secure their hosts are encouraged to run the kernelspace version to isolate Xenstore
from other processes (where a VM offers more isolation than a container, which offers more
isolation than a chroot). Note this choice is invisible to the guest VMs.</p>
<p>So far in the Irmin Xenstore integration only the userspace instantiation has been implemented.
One of the most significant user-visible features is that all of the operations done through
Irmin can be inspected using the standard <code>git</code> command line tool.
The runes to configure Irmin to write
<a href="http://git-scm.com">git</a> format data to the filesystem are as follows:</p>
<pre><code class="language-ocaml">    let open Irmin_unix in
    let module Git = IrminGit.FS(struct
      let root = Some filename
      let bare = true
    end) in
    let module DB = Git.Make(IrminKey.SHA1)(IrminContents.String)(IrminTag.String) in
    DB.create () &gt;&gt;= fun db -&gt;
</code></pre>
<p>where keys and values will be mapped into OCaml <code>strings</code>, and our
<code>VIEW.t</code> is simply an Irmin <code>DB.View.t</code>. All that remains is to implement
<code>read</code>, <code>list</code>, <code>write</code>, <code>rm</code> by</p>
<ol>
<li>mapping Xenstore <code>Protocol.Path.t</code> values onto Irmin keys; and
</li>
<li>mapping Xenstore <code>Node.contents</code> records onto Irmin values.
</li>
</ol>
<p>As it happens Xenstore and Irmin have similar notions of &quot;paths&quot; so the first mapping is
easy. We currently use <a href="https://github.com/janestreet/sexplib">sexplib</a> to map Node.contents
values onto strings for Irmin.</p>
<p>The resulting <a href="https://github.com/mirage/ocaml-xenstore-server/blob/blog/introducing-irmin-in-xenstore/userspace/main.ml#L101">Irmin glue module</a> looks like:</p>
<pre><code class="language-ocaml">    let module V = struct
      type t = DB.View.t
      let create = DB.View.create
      let write t path contents =
        DB.View.update t (value_of_filename path) (Sexp.to_string (Node.sexp_of_contents contents))
      (* omit read,list,write,rm for brevity *)
      let merge t origin =
        let origin = IrminOrigin.create &quot;%s&quot; origin in
        DB.View.merge_path ~origin db [] t &gt;&gt;= function
        | `Ok () -&gt; return true
        | `Conflict msg -&gt;
          info &quot;Conflict while merging database view: %s&quot; msg;
          return false
    end in
</code></pre>
<p>The <code>write</code> function simply calls through to Irmin's <code>update</code> function, while the <code>merge</code> function
calls Irmin's <code>merge_path</code>. If Irmin cannot merge the transaction then our <code>merge</code> function will
return <code>false</code> and this will be signalled to the client, which is expected to retry the high-level
operation (e.g. hotplugging or unplugging a device).</p>
<p>Now all that remains is to carefully adjust the I/O code so that effects (reading and writing packets
along the persistent connections) are interleaved properly with persisted state changes and
voil&agrave;, we now have a xenstore which can recover after a restart.</p>
<h3>Easy system debugging with Git</h3>
<p>When something goes wrong on a Xen system it's standard procedure to</p>
<ol>
<li>take a snapshot of the current state of Xenstore; and
</li>
<li>examine the log files for signs of trouble.
</li>
</ol>
<p>Unfortunately by the
time this is done, interesting Xenstore state has usually been deleted. Unfortunately the first task
of the human operator is to evaluate by-hand the logged actions in reverse to figure out what the state
actually was when the problem happened. Obviously this is tedious, error-prone and not always
possible since the log statements are ad-hoc and don't always include the data you need to know.</p>
<p>In the new Irmin-powered Xenstore the history is preserved in a git-format repository, and can
be explored using your favourite git viewing tool. Each store
update has a compact one-line summary, a more verbose multi-line explanation and (of course)
the full state change is available on demand.</p>
<p>For example you can view the history in a highly-summarised form with:</p>
<pre><code class="language-console">$ git log --pretty=oneline --abbrev-commit --graph
* 2578013 Closing connection -1 to domain 0
* d4728ba Domain 0: rm /bench/local/domain/0/backend/vbd/10 = ()
* 4b55c99 Domain 0: directory /bench/local/domain/0/backend = [ vbd ]
* a71a903 Domain 0: rm /bench/local/domain/10 = ()
* f267b31 Domain 0: rm /bench/vss/uuid-10 = ()
* 94df8ce Domain 0: rm /bench/vm/uuid-10 = ()
* 0abe6b0 Domain 0: directory /bench/vm/uuid-10/domains = [  ]
* 06ddd3b Domain 0: rm /bench/vm/uuid-10/domains/10 = ()
* 1be2633 Domain 0: read /bench/local/domain/10/vss = /bench/vss/uuid-10
* 237a8e4 Domain 0: read /bench/local/domain/10/vm = /bench/vm/uuid-10
* 49d70f6 Domain 0: directory /bench/local/domain/10/device = [  ]
*   ebf4935 Merge view to /
|\\
| * e9afd9f Domain 0: read /bench/local/domain/10 =
* | c4e0fa6 Domain 0: merging transaction 375
|/
</code></pre>
<p>The summarised form shows both individual operations as well as isolated transactions which
are represented as git branches.
You can then 'zoom in' and show the exact state change with commands like:</p>
<pre><code>$ git show bd44e03
commit bd44e0388696380cafd048eac49474f68d41bd3a
Author: 448 &lt;irminsule@openmirage.org&gt;
Date:   Thu Jan 1 00:09:26 1970 +0000

    Domain 0: merging transaction 363

diff --git a/*0/bench.dir/local.dir/domain.dir/7.dir/control.dir/shutdown.value b/*0/bench.dir/local.dir/domain.dir/7.dir/control.dir/shutdown.value
new file mode 100644
index 0000000..aa38106
--- /dev/null
+++ b/*0/bench.dir/local.dir/domain.dir/7.dir/control.dir/shutdown.value
@@ -0,0 +1 @@
+((creator 0)(perms((owner 7)(other NONE)(acl())))(value halt))
</code></pre>
<p>Last but not least, you can <code>git checkout</code> to the exact time the problem occurred and examine
the state of the store.</p>
<h3>Going really fast</h3>
<p>Xenstore is part of the control-plane of a Xen system and is most heavily stressed when lots
of VMs are being started in parallel. Each VM has multiple devices and each device is added in a
separate transaction. These transactions remain open for multiple client-server round-trips, as
each individual operation is sent to Xenstore as a separate RPC.
To provide isolation, each Xenstore transaction is represented by an Irmin <code>VIEW.t</code> which
is persisted on disk as a git branch.
When starting lots of VMs in
parallel, lots of branches are created and must be merged back together. If a branch cannot
be merged then an abort signal is sent to the client and it must retry.</p>
<p>Earlier versions of Xenstore had naive transaction merging algorithms
which aborted many of these transactions, causing the clients to re-issue them.This led to a live-lock
where clients were constantly reissuing the same transactions again and again.</p>
<p>Happily Irmin's default merging strategy is much better: by default Irmin
records the results of every operation and replays the operations on merge
(similar to <code>git rebase</code>). Irmin will only generate a <code>Conflict</code> and signal an
abort if the client would now see different results to those it has already
received (imagine reading a key twice within an isolated transaction and seeing
two different values). In the case of parallel VM starts, the keys are disjoint
by construction so all transactions are merged trivially; clients never receive
abort signals; and therefore the system makes steady, predictable progress
starting the VMs.</p>
<h3>Trying it out</h3>
<p>The Irmin Xenstore is under <a href="https://github.com/mirage/ocaml-xenstore-server">active development</a>
but you can try it by:</p>
<p>Install basic development tools along with the xen headers and xenstore tools (NB you don't
actually have to run Xen):</p>
<pre><code>  sudo apt-get install libxen-dev xenstore-utils opam build-essential m4
</code></pre>
<p>Initialise opam (if you haven't already). Make sure you have OCaml 4.01:</p>
<pre><code>  opam init
  opam update
  opam switch 4.01.0
</code></pre>
<p>Install the OCaml build dependencies:</p>
<pre><code>  opam install lwt irmin git sexplib cstruct uri sexplib cmdliner xen-evtchn shared-memory-ring io-page ounit
</code></pre>
<p>Clone the code and build it:</p>
<pre><code>  git clone https://github.com/mirage/ocaml-xenstore-server
  cd ocaml-xenstore-server
  make
</code></pre>
<p>Run a server (as a regular user):</p>
<pre><code>  ./main.native --database /tmp/db --enable-unix --path /tmp/xenstored
</code></pre>
<p>In a separate terminal, perform some operations:</p>
<pre><code>  export XENSTORED_PATH=/tmp/xenstored
  xenstore-write -s /one/two/three 4 /five/six/seven 8
  xenstore-ls -s /
</code></pre>
<p>Next check out the git repo generated by Irmin:</p>
<pre><code>  cd /tmp/db
  git log
</code></pre>
<p>Comments and/or contributions are welcome: join the <a href="http://lists.xenproject.org/cgi-bin/mailman/listinfo/mirageos-devel">Mirage email list</a> and say hi!</p>

      
