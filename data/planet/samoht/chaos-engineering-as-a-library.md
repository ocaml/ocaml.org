---
title: Chaos engineering as a library
description: Testing what a program does when the power goes out or the network drops,
  from an ordinary unit test that hands it a simulated disk and network.
url: https://gazagnaire.org/blog/2026-11-23-eio-fs-net.html
date: 2026-11-23T00:00:00-00:00
preview_image: https://gazagnaire.org/blog/og/2026-11-23-eio-fs-net.png?v=546329435b
authors:
- Thomas Gazagnaire
source:
ignore:
keywords:
- chaos
- config
- disk
- eio
- eio-fs
- eio-net
- eio_fs_chaos
- mutex
- sync
- sync_dir
---

<p>Netflix's <a href="https://netflix.github.io/chaosmonkey/">Chaos Monkey</a> shuts
down machines at random in the production fleet. While I like the idea
of finding out how a service copes with losing a machine when someone is
around to watch, I can't quite bring myself to unplug a
<a href="https://gazagnaire.org/blog/2026-02-25-satellite-software.html">satellite</a> running
<a href="https://parsimoni.co/">SpaceOS</a> to see what its software does next :-)
So, I'd like to know what happens when the radio link drops halfway
through a transfer, or the power goes out just after my software says
it has saved a file. My tests usually run on a laptop, where I can
save the file a thousand times and never exercise the recovery code.
I could write a test for each place I think a write might fail, but
then I'd have to do it all again for the next application, with much
the same disk underneath.</p>
<p>One answer is <a href="https://antithesis.com/">Antithesis</a>, which gets control
of the disk, the network and the clock by running the whole operating system in a
deterministic hypervisor. It can run unmodified software that way and
replay the sequence of events that broke it. In
<a href="https://mirageos.org/">MirageOS</a>, though, I'm already writing
<a href="https://gazagnaire.org/blog/2026-02-23-asplos-unikernels.html">operating-system code in user space</a>,
with OCaml libraries for
<a href="https://tarides.com/blog/2024-11-27-irmin-on-mirageos-introducing-the-notafs-file-system/">storage</a>
and
<a href="https://tarides.com/blog/2024-01-24-mirageos-designing-a-more-resilient-networking-stack-with-tcp/">networking</a>.
So the natural next step is to turn the chaos into a library too, and
run these experiments from an ordinary unit test.
<a href="https://github.com/samoht/ocaml-eio-chaos">eio-chaos</a>,
<a href="https://github.com/samoht/ocaml-eio-fs">eio-fs</a> and
<a href="https://github.com/samoht/ocaml-eio-net">eio-net</a> now do something close for an
<a href="https://github.com/ocaml-multicore/eio">Eio</a> application, for
everything it reaches through Eio:</p>
<pre><code>$ opam install eio-chaos eio-fs eio-net hermetic
</code></pre>
<pre><code class="language-ocaml">let () =
  Eio_chaos.run [ Eio_fs_chaos.disk (); Eio_net_chaos.network () ]
  @@ fun env -&gt; My_app.main env
</code></pre>
<p>There is no test script here telling a particular write to fail.
Instead, <code>My_app.main</code> runs several times with a different history each time.
In one run the disk might lose power, in another the client might lose
a TCP handshake. The test then restarts the application on what survived.
If that goes badly, the report ends with a line of OCaml to paste
into the test to run that one case again.</p>
<h2>Capabilities</h2>
<p>The reason this fits in a unit test is the <code>env</code> argument that
<code>My_app.main</code> takes anyway. Nowadays, most of my applications use
<a href="https://tarides.com/blog/2024-03-20-eio-1-0-release-introducing-a-new-effects-based-i-o-library-for-ocaml/">Eio</a>,
which gives them a filesystem, a network and clocks as ordinary OCaml
values.
In Eio's terminology, a
<a href="https://github.com/ocaml-multicore/eio#design-note-capabilities">capability</a>
is a value that grants access to a resource. If a function saves a config
file, it can be given just the directory where the file belongs. It can
open a file there and pass the open file to another function that knows
how to write the config. That second function doesn't need access to the
directory at all.</p>
<p>Usually that directory is on the host's disk. In the test above, <code>env</code>
holds a directory on a simulated disk instead, and the function saves
its config in exactly the same way. So what happens when the disk loses
power is written once, and reused in every application that takes its
directory as an argument.</p>
<p>Nothing stops the application from calling <code>open_in</code> and reading a
file on the host by mistake. That's an <em>ambient</em> capability. <code>open_in</code>
takes just a filename, so even when the test passes a simulated
directory, the read goes straight to the host filesystem. To catch those
calls, I wrote and released
<a href="https://github.com/samoht/ocaml-hermetic">hermetic</a>. With
<code>open! Hermetic</code> at the top of a file, calls such as <code>open_in</code> and
<code>Unix.gettimeofday</code> no longer compile, and the error points to the
corresponding Eio capability. <a href="https://aryx.github.io/">Yoann Padioleau</a>'s
<a href="https://github.com/aryx/ocaml-caps">caps</a>, presented at this year's
<a href="https://www.youtube.com/watch?v=4t_2wLz9EOo">OCaml Workshop</a>, takes the
opposite approach: it keeps those calls, but makes each one ask for a
capability token.</p>
<p>The chaos itself comes from three new libraries.
<a href="https://github.com/samoht/ocaml-eio-chaos">eio-chaos</a> chooses the faults
and runs the application on a scheduler and virtual clock adapted from
<a href="https://github.com/ocaml-multicore/eio/tree/main/lib_eio/mock">Eio_mock</a>.
<a href="https://github.com/samoht/ocaml-eio-fs">eio-fs</a> and
<a href="https://github.com/samoht/ocaml-eio-net">eio-net</a> supply the devices.
A scripted mock has to be told what each operation returns. Here,
instead, the simulated disk keeps track of writes, renames and syncs, so
it knows what would survive a power cut.</p>
<h2>A rename is not durable until its directory is synced</h2>
<p>Suppose an application keeps its settings in a file called <code>config</code>,
which holds the string <code>"old"</code>, and wants to replace it with <code>"new"</code>.
The classic way is to write <code>"new"</code> to a temporary file, sync that file
and rename it over <code>config</code>. As the rename is atomic, readers opening
<code>config</code> see one complete version or the other. But the rename changes
an entry in the parent directory, so syncing the file alone does not
make it durable. On Linux, the application therefore also has to sync
the directory before it tells the user the new config is safe on disk.</p>
<p>To check that, the <code>sync_dir</code> flag below runs the save both ways. The
setup first writes a durable copy of <code>"old"</code>. The test then saves
<code>"new"</code> and calls <code>ack</code> to record what <code>config</code> must hold after a
restart.</p>
<div class="grid grid-cols-1 sm:grid-cols-2 gap-4 my-8 items-start">
<div class="min-w-0 *:mt-0">
<pre><code class="language-ocaml">let save ~sync_dir dir v =
  let tmp = Eio.Path.(dir / "config.tmp") in
  let create = `Or_truncate 0o644 in
  Eio.Path.with_open_out ~create tmp (fun f -&gt;
      Eio.Flow.copy_string v f;
      Eio.File.sync f);
  Eio.Path.rename tmp Eio.Path.(dir / "config");
  if sync_dir then Eio.Path.sync_dir dir

let test ~sync_dir () =
  Eio_fs_chaos.run
    ~setup:(fun env -&gt; save ~sync_dir:true env#fs "old")
    (fun env -&gt;
      save ~sync_dir env#fs "new";
      Eio_fs_chaos.ack env Eio.Path.(env#fs / "config"))
</code></pre>
</div>
<figure class="m-0 not-prose min-w-0">
  <a href="https://gazagnaire.org/blog/images/eio-fs-crash.svg"><img src="https://gazagnaire.org/blog/images/eio-fs-crash.svg" class="w-full rounded-lg" alt="An animated terminal recording: the test passes with the directory sync, then, without it, Eio_fs_chaos.run reports that a power cut lost an acknowledged file. The power went out at the end, the create and the rename were lost, the config holds old again, and the last line replays that case."></a>
  <figcaption class="text-xs text-gray-500 mt-2 leading-tight">The test with the directory sync, then without it, recorded by <a href="https://gazagnaire.org/blog/2026-10-26-k7.html">k7</a>.</figcaption>
</figure>
</div>
<p>With the directory sync, the test passes. Without it, the recording
shows a power cut just after the acknowledgement. The temporary file's
contents had reached the disk, but neither its directory entry nor the
rename survived. When the application restarted, <code>config</code> held <code>"old"</code>
again.</p>
<p>To find that cut, <code>Eio_fs_chaos.run</code> first records a run without faults. At each
operation in that run it tries the individual faults the model allows,
then uses a fixed seed to try pairs of faults. It checks for hangs,
unexpected exceptions and failed restarts. After a restart it also
checks the contents of each acknowledged file.</p>
<p>Like <a href="https://github.com/dsrhaslab/lazyfs">LazyFS</a>, which does it with
FUSE, the simulated disk drops the writes that were not synced. The
restart check is the one
<a href="https://www.usenix.org/conference/osdi14/technical-sessions/presentation/pillai">ALICE</a>
runs on applications and
<a href="https://www.usenix.org/conference/osdi18/presentation/mohan">CrashMonkey</a>
on filesystems. The disk model is checked against
<a href="https://doi.org/10.1145/2872362.2872406">Ferrite</a>'s models of ext4,
ported with their litmus tests, and allows a little more: what ext4
mounted with <code>data=writeback</code> may lose, beyond the default
<code>data=ordered</code>. The macOS model keeps those rules and changes
only what each kind of sync makes durable on APFS. Under both models,
unsynced writes can survive out of order, and in the ext4 model even
individual 512-byte sectors of a page can survive while others still
hold the old data.</p>
<p>And as a failed check raises <code>Failure</code> with the report, the test runs
directly in <a href="https://github.com/mirage/alcotest">Alcotest</a>, which
<a href="https://gazagnaire.org/blog/2026-11-09-alcotest-dune-release.html">points each failure at its test</a>.</p>
<pre><code class="language-ocaml">Alcotest.test_case "power cut" `Quick (test ~sync_dir:true)
</code></pre>
<h2>Failed syncs and silent peers</h2>
<p>There's a wrinkle in the config example on macOS. Even with both
syncs, <code>fsync</code> can return while the data is still in the drive's cache.
Flushing that cache as well takes <code>F_FULLFSYNC</code> (the reason SQLite has a
<a href="https://www.sqlite.org/pragma.html#pragma_fullfsync"><code>fullfsync</code> pragma</a>).
This has always been convoluted to test, but with eio-fs it is just
<code>Eio_fs_chaos.run ~os:`Macos</code>. <code>Eio_fs_unix.sync_file</code> and
<code>Eio_fs_unix.sync_dir</code> issue the stronger barrier when the program runs
on macOS.</p>
<p>Another example of a contrived failure mode is a failed sync on Linux.
The kernel may already have dropped the pages it couldn't write, so a
retried sync succeeds because there's nothing left to flush. The PostgreSQL developers ran into this in 2018
(<a href="https://wiki.postgresql.org/wiki/Fsync_Errors">fsyncgate</a>).
It's one of the cases <code>Eio_fs_chaos.run</code> tries, and a good example of
why returning an error from a mock isn't quite enough. What the next
call sees depends on what the disk did during the failed one.</p>
<p>On the network, news of a failure can take a long time to arrive. When a satellite goes out of range at the end of
a pass, the <a href="https://gazagnaire.org/blog/2026-04-15-ccsds-protocol-stack.html">radio link</a> can disappear without the peer sending a FIN or
a RST. A client waiting for a reply can sit there until its timeout
expires. The <a href="https://github.com/samoht/ocaml-eio-net">eio-net README</a>
has a test for just such a client. With a virtual clock, the test
lets the timeout expire without waiting that long.</p>
<h2>Does the simulated device behave like the real one?</h2>
<p>All of this assumes the simulated devices are right. If the disk
quietly makes every rename durable, for example, a save without the
directory sync passes every time. The code on the other side of the
capability needs testing too.</p>
<p>Even without a power cut, filesystems disagree about fairly ordinary
things. On macOS's default volume, a file written as <code>a</code> opens as <code>A</code>.
On a typical Linux filesystem the lookup fails.
Earlier work from <a href="https://www.cl.cam.ac.uk/~pes20/">Peter Sewell</a>'s group, such as
<a href="https://sibylfs.github.io/">SibylFS</a> for filesystems and
<a href="https://www.cl.cam.ac.uk/~pes20/Netsem/">Netsem</a> for TCP, checked real
systems against a specification. eio-fs has the systems it imitates at
hand, so it checks its model against them. Short sequences of operations run on each OS, the
recordings keep what Eio sees, and the in-memory implementation is
checked against them on every commit.</p>
<p>The test takes a function that builds the filesystem to check. Here
the in-memory filesystem stays in its default Linux mode, and
<code>conformance</code> compares it with the macOS recordings. The first three
differences all come from what happens to a name after a change of
case.</p>
<pre><code class="language-ocaml">let () =
  Eio_fs_chaos.conformance ~os:`Macos (fun ~sw:_ _env -&gt; Eio_fs_mem.v ())
</code></pre>
<pre><code>Eio_fs_chaos.conformance: 42 of 101 scenarios differ from macOS
  scenario                  operations                    expected  got
  ------------------------------------------------------------------------------
  case lookup               write a x; stat A             file 1    ENOENT
  case exclusive create     write a x; open A x           EEXIST    ok
  case non-ascii            write é x; stat É             file 1    ENOENT
  ...
  59 passed, 42 differed, 14 left out: 11 that need ~user, 3 that need a native
  path
</code></pre>
<p>The first row is the lookup above. macOS found a one-byte file, but
the in-memory filesystem returned <code>ENOENT</code>. With <code>Eio_fs_mem.v ~os:`Macos ()</code>
instead, the check passes. <code>Eio_net_chaos.conformance</code> does the same for network
devices, with scenarios drawn in part from
<a href="https://github.com/google/gvisor/tree/master/test/syscalls/linux">gVisor's socket tests</a>.</p>
<p>These checks also run on a device that depends on another device.
For example, the eio-fs tests include a <a href="https://github.com/samoht/ocaml-eio-fs/blob/main/test/chaos/remote.ml">remote filesystem</a>.
Passing <code>~under:[ Eio_net_chaos.network () ]</code> lets the test interrupt
its network. A filesystem operation may then return a disk error, but
it still has to finish.</p>
<p>One option that turned out surprisingly effective is <code>~os:`Windows</code>. For
historical reasons, a good development setup is
<a href="https://tarides.com/blog/2024-05-22-launching-the-first-class-windows-project/">harder to get on Windows</a>
than on Linux or macOS, so code rarely gets tested there. With this
option, a chaos test on a Mac answers as Windows does: if the code
renames a file it still holds open, the test catches it before Windows
does. The Windows answers were recorded through Eio's backend on
GitHub's Windows runners. Each time a recording differed from the model,
there was a short sequence of operations to look at, and several times
the bug was not in the model.
I opened issues for Eio's Windows backend
(<a href="https://github.com/ocaml-multicore/eio/issues/986" title="WSAEMSGSIZE from Net.recv instead of a truncated datagram">eio#986</a>,
<a href="https://github.com/ocaml-multicore/eio/issues/987" title="Raw Unix_error from pread/pwrite and Unix datagram sockets on Windows">eio#987</a>,
<a href="https://github.com/ocaml-multicore/eio/issues/988" title="UDP receive raises Connection_reset on Windows after a send to a closed port?">eio#988</a>,
<a href="https://github.com/ocaml-multicore/eio/issues/989" title="Open files can't be renamed or deleted with eio_windows">eio#989</a>,
<a href="https://github.com/ocaml-multicore/eio/issues/990" title="Is NUL a device through the unrestricted fs?">eio#990</a>,
<a href="https://github.com/ocaml-multicore/eio/issues/991" title="abstract Unix addresses are accepted by eio_windows">eio#991</a>,
<a href="https://github.com/ocaml-multicore/eio/issues/992" title="getaddrinfo errors are all NONAME on Windows">eio#992</a>,
<a href="https://github.com/ocaml-multicore/eio/issues/993" title="eio_windows: connect to a closed port never returns">eio#993</a> and
<a href="https://github.com/ocaml-multicore/eio/issues/994" title="eio_windows: reads and writes after a shutdown">eio#994</a>) and for
OCaml's <code>Unix</code> library
(<a href="https://github.com/ocaml/ocaml/issues/15335" title="Unix: SO_RCVTIMEO and SO_SNDTIMEO don't round-trip on Windows">ocaml#15335</a> and
<a href="https://github.com/ocaml/ocaml/issues/15336" title="Unix.stat raises ENOENT on a Unix-domain socket file on Windows">ocaml#15336</a>).
Since then, <a href="https://anil.recoil.org/">Anil Madhavapeddy</a> has moved Eio's
Windows backend to IO completion ports in
<a href="https://github.com/ocaml-multicore/eio/pull/996" title="Switch Eio_windows over to IO completion ports">eio#996</a>, which fixes
most of the Eio ones.</p>
<p>The <a href="https://github.com/samoht/ocaml-eio-fs/blob/main/lib/mem/eio_fs_mem.mli">model</a>
still has gaps. In particular, Eio's Windows backend doesn't sync
directories, and there are no recordings of what survives a power cut
on NTFS, so the Windows model uses the Linux crash behaviour.</p>
<h2>Using the devices on their own</h2>
<p>For tests that just need a disposable directory, <code>eio-fs.mem</code> works
without the fault injector. It started as <a href="https://github.com/patricoferris">Patrick Ferris</a>'s
<a href="https://git.sirref.org/eio_mem">eio_mem</a>, and <code>Eio_fs.Path</code> adapts
eio_mem's POSIX-only version of
<a href="https://github.com/dbuenzli">Daniel Bünzli</a>'s
<a href="https://github.com/dbuenzli/fpath">fpath</a>.
Likewise, <code>eio-net.mem</code> runs a client and a server in the same test
without picking a free port on the host.</p>
<p>If a test needs a whole tree of fixtures, <code>eio-fs-crunch</code> can embed the
tree in the executable. A Dune rule regenerates the OCaml module when
the files change, and <code>Eio_fs_mem.Crunch.load</code> turns it back into a
filesystem the test can read through <code>Eio.Path</code>. Much the same trick
gives a unikernel somewhere to keep its static files when it has no
disk, as <a href="https://github.com/mirage/ocaml-crunch">ocaml-crunch</a> does in
MirageOS.</p>
<p>As the config example shows, the file synchronisation dance is hard to
get right, and Eio could not even sync a directory before
<a href="https://github.com/ocaml-multicore/eio/pull/943" title="Add Path.sync_dir"><code>Eio.Path.sync_dir</code></a>
arrived in Eio 1.7. <code>Eio_fs.Sync</code> does the whole dance, with the barrier
you give it (<code>Eio_fs_unix.barrier</code> on macOS), and its tests run it
through power cuts and I/O errors. <code>eio-fs.unix</code> also has bindings for
file locks and the full sync calls above.
I'd be happy to contribute those upstream if others need them.</p>
<p>On the network side, the frame channels in <code>eio-net</code> read one protocol
message at a time, however many reads it takes, over datagram sockets
and byte streams, with a length-prefix codec in <code>Eio_net.Framing</code>. Their
tests found that eio_linux refused to send a datagram to a Unix-domain
address (<a href="https://github.com/ocaml-multicore/eio/issues/963" title="eio_linux: EINVAL sending a datagram to a Unix-domain address">eio#963</a>).
<code>Eio_net.Accept</code> bounds the connections a server's accept loop serves
and, when the loop is full or out of file descriptors, drops the
connection whose request has made the least progress. Its tests found
that a second listener whose bind failed on a Unix socket path already
in use could delete the first listener's socket file
(<a href="https://github.com/ocaml-multicore/eio/issues/970" title="Failed listen on a Unix path deletes the socket of the listener already there">eio#970</a>). Both are
fixed in Eio 1.7, whose release in turn crashed eio-net's tests on
Alpine, where the GC freeing a locked mutex corrupts musl's memory
(<a href="https://github.com/ocaml/ocaml/issues/15392" title="A locked Mutex.t freed by the GC crashes on musl">ocaml#15392</a>).</p>
<h2>Trying it out</h2>
<p>If you try this on an Eio application, I'd like to hear what breaks.
I'm especially interested in failures you can replay in the simulator
but can't explain on a real machine. I may have got the model wrong.
You can report those on the trackers for
<a href="https://github.com/samoht/ocaml-eio-chaos/issues">eio-chaos</a>,
<a href="https://github.com/samoht/ocaml-eio-fs/issues">eio-fs</a>,
<a href="https://github.com/samoht/ocaml-eio-net/issues">eio-net</a> and
<a href="https://github.com/samoht/ocaml-hermetic/issues">hermetic</a>.
I'd also like to hear whether upstreaming hermetic's alerts to the OCaml
standard library would even be a good idea :-)</p>
