---
title: OCaml 5 performance problems
description:
url: https://roscidus.com/blog/blog/2024/07/22/performance/
date: 2024-07-22T10:00:00-00:00
preview_image:
authors:
- Thomas Leonard
source:
---

<p>Linux and OCaml provide a huge range of tools for investigating performance problems.
In this post I try using some of them to understand a network performance problem.
In <a href="https://roscidus.com/blog/blog/2024/07/22/performance-2/">part 2</a>, I'll investigate a problem in a CPU-intensive multicore program.</p>

<p><strong>Table of Contents</strong></p>
<ul>
<li><a href="https://roscidus.com/#the-problem">The problem</a>
</li>
<li><a href="https://roscidus.com/#time">time</a>
</li>
<li><a href="https://roscidus.com/#eio-trace">eio-trace</a>
</li>
<li><a href="https://roscidus.com/#strace">strace</a>
</li>
<li><a href="https://roscidus.com/#bpftrace">bpftrace</a>
</li>
<li><a href="https://roscidus.com/#tcpdump">tcpdump</a>
</li>
<li><a href="https://roscidus.com/#ss">ss</a>
</li>
<li><a href="https://roscidus.com/#offwaketime">offwaketime</a>
</li>
<li><a href="https://roscidus.com/#magic-trace">magic-trace</a>
</li>
<li><a href="https://roscidus.com/#summary-script">Summary script</a>
</li>
<li><a href="https://roscidus.com/#fixing-it">Fixing it</a>
</li>
<li><a href="https://roscidus.com/#conclusions">Conclusions</a>
</li>
</ul>
<h2>The problem</h2>
<p>While porting <a href="https://github.com/mirage/capnp-rpc">capnp-rpc</a> from <a href="https://github.com/ocsigen/lwt/">Lwt</a> to <a href="https://github.com/ocaml-multicore/eio">Eio</a>,
to take advantage of OCaml 5's new effects system,
I tried running the benchmark to see if it got any faster:</p>
<pre><code>$ ./echo_bench.exe
echo_bench.exe: [INFO] rate = 44933.359573 # The old Lwt version
echo_bench.exe: [INFO] rate = 511.963565   # The (buggy) Eio version
</code></pre>
<p>The benchmark records the number of echo RPCs per second.
Clearly, something is very wrong here!
In fact, the new version was so slow I had to reduce the number of iterations so it would finish.</p>
<h2>time</h2>
<p>The old <code>time</code> command can immediately give us a hint:</p>
<pre><code>$ /usr/bin/time ./echo_bench.exe
1.85user 0.42system 0:02.31elapsed 98%CPU  # Lwt
0.16user 0.05system 0:01.95elapsed 11%CPU  # Eio (buggy)
</code></pre>
<p>(many shells provide their own <code>time</code> built-in with different output formats; I'm using <code>/usr/bin/time</code> here)</p>
<p><code>time</code>'s output shows time spent in user-mode (running the application's code on the CPU),
time spent in the kernel, and the total wall-clock time.
Both versions ran for around 2 seconds (doing a different number of iterations),
but the Lwt version was using the CPU 98% of the time, while the Eio version was mostly sleeping.</p>
<h2>eio-trace</h2>
<p><a href="https://github.com/ocaml-multicore/eio-trace">eio-trace</a> can be used to see what an Eio program is doing.
Tracing is always available (you don't need to recompile the program to get it).</p>
<pre><code>$ eio-trace run -- ./echo_bench.exe
</code></pre>
<p><code>eio-trace run</code> runs the command and displays the trace in a window.
You can also use <code>eio-trace record</code> to save a trace and examine it later.</p>
<p><a href="https://roscidus.com/blog/images/perf/capnp-eio-slow-many.png"><span class="caption-wrapper center"><img src="https://roscidus.com/blog/images/perf/capnp-eio-slow-many.png" title="Trace of slow benchmark (12 concurrent requests)" class="caption"/><span class="caption-text">Trace of slow benchmark (12 concurrent requests)</span></span></a></p>
<p>The benchmark runs 12 test clients at once, making it a bit noisy.
To simplify thing, I set it to run only one client:</p>
<p><a href="https://roscidus.com/blog/images/perf/capnp-eio-slow.png"><span class="caption-wrapper center"><img src="https://roscidus.com/blog/images/perf/capnp-eio-slow.png" title="Trace of slow benchmark (one request at a time)" class="caption"/><span class="caption-text">Trace of slow benchmark (one request at a time)</span></span></a></p>
<p>I've zoomed the image to show the first four iterations.
The first is so quick it's not really visible, but the next three take about 40ms each.
The yellow regions labelled &quot;suspend-domain&quot; show when the program is sleeping, waiting for an event from Linux.
Each horizontal bar is a fiber (a light-weight thread). From top to bottom they are:</p>
<ul>
<li>Three rows for the test client:
<ul>
<li>The main application fiber performing the RPC call (mostly awaiting responses).
</li>
<li>The network's write fiber, sending outgoing messages (mostly waiting for something to send).
</li>
<li>The network's read fiber, reading incoming messages (mostly waiting to something to read).
</li>
</ul>
</li>
<li>Four rows for the server:
<ul>
<li>A loop accepting new incoming TCP connections.
</li>
<li>A short-lived fiber that accepts the new connection, then short-lived fibers each handling one request.
</li>
<li>The server's network write fiber.
</li>
<li>The server's network read fiber.
</li>
</ul>
</li>
<li>One fiber owned by Eio itself (used to wake up the event loop in some situations).
</li>
</ul>
<p>This trace immediately raises a couple of questions:</p>
<ul>
<li>
<p>Why is there a 40ms delay in each iteration of the test loop?</p>
</li>
<li>
<p>Why does the program briefly wake up in the middle of the first delay, do nothing, and return to sleep?
(notice the extra &quot;suspend-domain&quot; at the top)</p>
</li>
</ul>
<p>Zooming in on a section between the delays, let's see what it's doing when it's not sleeping:</p>
<p><a href="https://roscidus.com/blog/images/perf/capnp-eio-slow-zoom1.png"><span class="caption-wrapper center"><img src="https://roscidus.com/blog/images/perf/capnp-eio-slow-zoom1.png" title="Zoomed in on the active part" class="caption"/><span class="caption-text">Zoomed in on the active part</span></span></a></p>
<p>After a 40ms delay, the server's read fiber receives the next request (the running fiber is shown in green).
The read fiber spawns a fiber to handle the request, which finishes quickly, starts the next read,
and then the write fiber transmits the reply.</p>
<p>The client's read fiber gets the reply, the write fiber outputs a message, then the application fiber runs
and another message is sent.
The server reads something (presumably the first message, though it happens after the client had sent both),
then there is another long 40ms delay, then (far off the right of the image) the pattern repeats.</p>
<p>To get more context in the trace,
I <a href="https://ocaml-multicore.github.io/eio/eio/Eio/Private/Trace/index.html#val-log">configured</a>
the logging library to write the (existing) debug-level log messages to the trace buffer too:</p>
<p><a href="https://roscidus.com/blog/images/perf/capnp-eio-slow-zoom1-debug.png"><span class="caption-wrapper center"><img src="https://roscidus.com/blog/images/perf/capnp-eio-slow-zoom1-debug.png" title="With log messages" class="caption"/><span class="caption-text">With log messages</span></span></a></p>
<p>Log messages tend to be a bit long for the trace display, so they overlap and you have to zoom right in to read them,
but they do help navigate.
With this, I can see that the first client write is &quot;Send finish&quot; and the second is &quot;Calling Echo.ping&quot;.</p>
<p>Looks like we're not buffering the output, so it's doing two separate writes rather than combining them.
That's a little inefficient, and if you've done much network programming,
you also probably already know why this might cause a 40ms delay,
but let's pretend we don't know so we can play with a few more tools...</p>
<h2>strace</h2>
<p><a href="https://github.com/strace/strace">strace</a> can be used to trace interactions between applications and the Linux kernel
(<code>-tt -T</code> shows when each call was started and how long it took):</p>
<pre><code>$ strace -tt -T ./echo_bench.exe
...
11:38:58.079200 write(2, &quot;echo_bench.exe: [INFO] Accepting&quot;..., 73) = 73 &lt;0.000008&gt;
11:38:58.079253 io_uring_enter(4, 4, 0, 0, NULL, 8) = 4 &lt;0.000032&gt;
11:38:58.079341 io_uring_enter(4, 2, 0, 0, NULL, 8) = 2 &lt;0.000020&gt;
11:38:58.079408 io_uring_enter(4, 2, 0, 0, NULL, 8) = 2 &lt;0.000021&gt;
11:38:58.079471 io_uring_enter(4, 2, 0, 0, NULL, 8) = 2 &lt;0.000018&gt;
11:38:58.079525 io_uring_enter(4, 2, 0, 0, NULL, 8) = 2 &lt;0.000019&gt;
11:38:58.079580 io_uring_enter(4, 2, 0, 0, NULL, 8) = 2 &lt;0.000013&gt;
11:38:58.079611 io_uring_enter(4, 1, 0, 0, NULL, 8) = 1 &lt;0.000009&gt;
11:38:58.079637 io_uring_enter(4, 0, 1, IORING_ENTER_GETEVENTS|IORING_ENTER_EXT_ARG, 0x7ffc1661a480, 24) = -1 ETIME (Timer expired) &lt;0.018913&gt;
11:38:58.098669 futex(0x5584542b767c, FUTEX_WAKE_PRIVATE, 1) = 1 &lt;0.000105&gt;
11:38:58.098889 futex(0x5584542b7690, FUTEX_WAKE_PRIVATE, 1) = 1 &lt;0.000059&gt;
11:38:58.098976 io_uring_enter(4, 0, 1, IORING_ENTER_GETEVENTS, NULL, 8) = 0 &lt;0.021355&gt;
</code></pre>
<p>On Linux, Eio defaults to using the <a href="https://github.com/axboe/liburing">io_uring</a> mechanism for submitting work to the kernel.
<code>io_uring_enter(4, 2, 0, 0, NULL, 8) = 2</code> means we asked to submit 2 new operations to the ring on FD 4,
and the kernel accepted them.</p>
<p>The call at <code>11:38:58.079637</code> timed out after 19ms.
It then woke up some <a href="https://www.man7.org/linux/man-pages/man2/futex.2.html">futexes</a> and then waited again, getting woken up after a further 21ms (for a total of 40ms).</p>
<p>Futexes are used to coordinate between system threads.
<code>strace -f</code> will follow all spawned threads (and processes), not just the main one:</p>
<pre><code>$ strace -T -f ./echo_bench.exe
...
[pid 48451] newfstatat(AT_FDCWD, &quot;/etc/resolv.conf&quot;, {st_mode=S_IFREG|0644, st_size=40, ...}, 0) = 0 &lt;0.000011&gt;
...
[pid 48451] futex(0x561def43296c, FUTEX_WAIT_BITSET_PRIVATE|FUTEX_CLOCK_REALTIME, 0, NULL, FUTEX_BITSET_MATCH_ANY &lt;unfinished ...&gt;
...
[pid 48449] io_uring_enter(4, 0, 1, IORING_ENTER_GETEVENTS|IORING_ENTER_EXT_ARG, 0x7ffe1d5d1c90, 24) = -1 ETIME (Timer expired) &lt;0.018899&gt;
[pid 48449] futex(0x561def43296c, FUTEX_WAKE_PRIVATE, 1) = 1 &lt;0.000106&gt;
[pid 48451] &lt;... futex resumed&gt;)        = 0 &lt;0.019981&gt;
[pid 48449] io_uring_enter(4, 0, 1, IORING_ENTER_GETEVENTS, NULL, 8 &lt;unfinished ...&gt;
...
[pid 48451] exit(0)                     = ?
[pid 48451] +++ exited with 0 +++
[pid 48449] &lt;... io_uring_enter resumed&gt;) = 0 &lt;0.021205&gt;
...
</code></pre>
<p>The benchmark connects to <code>&quot;127.0.0.1&quot;</code> and Eio uses <code>getaddrinfo</code> to look up addresses (we can't use uring for this).
Since <code>getaddrinfo</code> can block for a long time, Eio creates a new system thread (pid 48451) to handle it
(we can guess this thread is doing name resolution because we see it read <code>resolv.conf</code>).</p>
<p>As creating system threads is a little slow, Eio keeps the thread around for a bit after it finishes in case it's needed again.
The timeout is when Eio decides that the thread isn't needed any longer and asks it to exit.
So this isn't relevant to our problem (and only happens on the first 40ms delay, since we don't look up any further addresses).</p>
<p>However, strace doesn't tell us what the uring operations were, or their return values.
One option is to switch to the <code>posix</code> backend (which is the default on Unix systems).
In fact, it's a good idea with any performance problem to check if it still happens with a different backend:</p>
<pre><code>$ EIO_BACKEND=posix strace -T -tt ./echo_bench.exe
...
11:53:52.935976 writev(7, [{iov_base=&quot;\0\0\0\0\4\0\0\0\0\0\0\0\1\0\1\0\4\0\0\0\0\0\0\0\0\0\0\0\1\0\0\0&quot;..., iov_len=40}], 1) = 40 &lt;0.000170&gt;
11:53:52.936308 ppoll([{fd=-1}, {fd=-1}, {fd=-1}, {fd=-1}, {fd=4, events=POLLIN}, {fd=-1}, {fd=6, events=POLLIN}, {fd=7, events=POLLIN}, {fd=8, events=POLLIN}], 9, {tv_sec=0, tv_nsec=0}, NULL, 8) = 1 ([{fd=8, revents=POLLIN}], left {tv_sec=0, tv_nsec=0}) &lt;0.000044&gt;
11:53:52.936500 writev(7, [{iov_base=&quot;\0\0\0\0\20\0\0\0\0\0\0\0\1\0\1\0\2\0\0\0\0\0\0\0\0\0\0\0\3\0\3\0&quot;..., iov_len=136}], 1) = 136 &lt;0.000055&gt;
11:53:52.936831 readv(8, [{iov_base=&quot;\0\0\0\0\4\0\0\0\0\0\0\0\1\0\1\0\4\0\0\0\0\0\0\0\0\0\0\0\1\0\0\0&quot;..., iov_len=4096}], 1) = 40 &lt;0.000056&gt;
11:53:52.937516 ppoll([{fd=-1}, {fd=-1}, {fd=-1}, {fd=-1}, {fd=4, events=POLLIN}, {fd=-1}, {fd=6, events=POLLIN}, {fd=7, events=POLLIN}, {fd=8, events=POLLIN}], 9, NULL, NULL, 8) = 1 ([{fd=8, revents=POLLIN}]) &lt;0.038972&gt;
11:53:52.977751 readv(8, [{iov_base=&quot;\0\0\0\0\20\0\0\0\0\0\0\0\1\0\1\0\2\0\0\0\0\0\0\0\0\0\0\0\3\0\3\0&quot;..., iov_len=4096}], 1) = 136 &lt;0.000398&gt;
</code></pre>
<p>(to reduce clutter, I removed calls that returned <code>EAGAIN</code> and <code>ppoll</code> calls that returned 0 ready descriptors)</p>
<p>The problem still occurs, and now we can see the two writes:</p>
<ul>
<li>The client writes 40 bytes to its end of the socket (FD 7), after which the server's end (FD 8) is ready for reading (<code>revents=POLLIN</code>).
</li>
<li>The client then writes another 136 bytes.
</li>
<li>The server reads 40 bytes and then uses <code>ppoll</code> to await further data.
</li>
<li>After 39ms, <code>ppoll</code> says FD 8 is now ready, and the server reads the other 136 bytes.
</li>
</ul>
<h2>bpftrace</h2>
<p>Alternatively, we can trace uring operations using <a href="https://github.com/bpftrace/bpftrace">bpftrace</a>.
bpftrace is a little scripting language similar to awk,
except that instead of editing a stream of characters,
it live-patches the running Linux kernel.
Apparently this is safe to run in production
(and I haven't managed to crash my kernel with it yet).</p>
<p>Here is a list of uring tracepoints we can probe:</p>
<pre><code>$ sudo bpftrace -l 'tracepoint:io_uring:*'
tracepoint:io_uring:io_uring_complete
tracepoint:io_uring:io_uring_cqe_overflow
tracepoint:io_uring:io_uring_cqring_wait
tracepoint:io_uring:io_uring_create
tracepoint:io_uring:io_uring_defer
tracepoint:io_uring:io_uring_fail_link
tracepoint:io_uring:io_uring_file_get
tracepoint:io_uring:io_uring_link
tracepoint:io_uring:io_uring_local_work_run
tracepoint:io_uring:io_uring_poll_arm
tracepoint:io_uring:io_uring_queue_async_work
tracepoint:io_uring:io_uring_register
tracepoint:io_uring:io_uring_req_failed
tracepoint:io_uring:io_uring_short_write
tracepoint:io_uring:io_uring_submit_req
tracepoint:io_uring:io_uring_task_add
tracepoint:io_uring:io_uring_task_work_run
</code></pre>
<p><code>io_uring_complete</code> looks promising:</p>
<pre><code>$ sudo bpftrace -vl tracepoint:io_uring:io_uring_complete
tracepoint:io_uring:io_uring_complete
    void * ctx
    void * req
    u64 user_data
    int res
    unsigned cflags
    u64 extra1
    u64 extra2
</code></pre>
<p>Here's a script to print out the time, process, operation name and result for each completion:</p>
<figure class="code"><figcaption><span>uringtrace.bt</span></figcaption><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
<span class="line-number">6</span>
<span class="line-number">7</span>
<span class="line-number">8</span>
<span class="line-number">9</span>
<span class="line-number">10</span>
<span class="line-number">11</span>
<span class="line-number">12</span>
<span class="line-number">13</span>
<span class="line-number">14</span>
<span class="line-number">15</span>
<span class="line-number">16</span>
<span class="line-number">17</span>
<span class="line-number">18</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="nc">BEGIN</span> <span class="o">{</span>
</span><span class="line">  <span class="o">@</span><span class="n">op</span><span class="o">[</span><span class="nc">IORING_OP_NOP</span><span class="o">]</span> <span class="o">=</span> <span class="s2">&quot;NOP&quot;</span><span class="o">;</span>
</span><span class="line">  <span class="o">@</span><span class="n">op</span><span class="o">[</span><span class="nc">IORING_OP_READV</span><span class="o">]</span> <span class="o">=</span> <span class="s2">&quot;READV&quot;</span><span class="o">;</span>
</span><span class="line">  <span class="o">...</span>
</span><span class="line"><span class="o">}</span>
</span><span class="line">
</span><span class="line"><span class="n">tracepoint</span><span class="o">:</span><span class="n">io_uring</span><span class="o">:</span><span class="n">io_uring_complete</span> <span class="o">{</span>
</span><span class="line">  <span class="o">$</span><span class="n">req</span> <span class="o">=</span> <span class="o">(</span><span class="k">struct</span> <span class="n">io_kiocb</span> <span class="o">*)</span> <span class="n">args</span><span class="o">-&gt;</span><span class="n">req</span><span class="o">;</span>
</span><span class="line">  <span class="n">printf</span><span class="o">(</span><span class="s2">&quot;%dms: %s: %s %d</span><span class="se">\n</span><span class="s2">&quot;</span><span class="o">,</span>
</span><span class="line">    <span class="n">elapsed</span> <span class="o">/</span> <span class="mf">1e6</span><span class="o">,</span>
</span><span class="line">    <span class="n">comm</span><span class="o">,</span>
</span><span class="line">    <span class="o">@</span><span class="n">op</span><span class="o">[$</span><span class="n">req</span><span class="o">-&gt;</span><span class="n">opcode</span><span class="o">],</span>
</span><span class="line">    <span class="n">args</span><span class="o">-&gt;</span><span class="n">res</span><span class="o">);</span>
</span><span class="line"><span class="o">}</span>
</span><span class="line">
</span><span class="line"><span class="nc">END</span> <span class="o">{</span>
</span><span class="line">  <span class="n">clear</span><span class="o">(@</span><span class="n">op</span><span class="o">);</span>
</span><span class="line"><span class="o">}</span>
</span></code></pre></td></tr></tbody></table></div></figure><pre><code>$ sudo bpftrace uringtrace.bt
Attaching 3 probes...
...
1743ms: echo_bench.exe: WRITE_FIXED 40
1743ms: echo_bench.exe: READV 40
1743ms: echo_bench.exe: WRITE_FIXED 136
1783ms: echo_bench.exe: READV 136
</code></pre>
<p>In this output, the order is slightly different:
we see the server's read get the 40 bytes before the client sends the rest,
but we still see the 40ms delay between the completion of the second write and the corresponding read.
The change in order is because we're seeing when the kernel knew the read was complete,
not when the application found out about it.</p>
<h2>tcpdump</h2>
<p>An obvious step with any networking problem is the look at the packets going over the network.
<a href="https://www.tcpdump.org/">tcpdump</a> can be used to capture packets, which can be displayed on the console or in a GUI with <a href="https://www.wireshark.org/">wireshark</a>.</p>
<pre><code>$ sudo tcpdump -n -ttttt -i lo
...
...041330 IP ...37640 &gt; ...7000: Flags [P.], ..., length 40
...081975 IP ...7000 &gt; ...37640: Flags [.], ..., length 0
...082005 IP ...37640 &gt; ...7000: Flags [P.], ..., length 136
...082071 IP ...7000 &gt; ...37640: Flags [.], ..., length 0
</code></pre>
<p>Here we see the client (on port 37640) sending 40 bytes to the server (port 7000),
and the server replying with an ACK (with no payload) 40ms later.
After getting the ACK, the client socket sends the remaining 136 bytes.</p>
<p>Here we can see that while the application made the two writes in quick succession,
TCP waited before sending the second one.
Searching for &quot;delayed ack 40ms&quot; will turn up an explanation.</p>
<h2>ss</h2>
<p><a href="https://www.man7.org/linux/man-pages/man8/ss.8.html">ss</a> displays socket statistics.
<code>ss -tin</code> shows all TCP sockets (<code>-t</code>) with internals (<code>-i</code>):</p>
<pre><code>$ ss -tin 'sport = 7000 or dport = 7000'
State   Recv-Q   Send-Q  Local Address:Port  Peer Address:Port
ESTAB   0        0       127.0.0.1:7000      127.0.0.1:56224
 ato:40 lastsnd:34 lastrcv:34 lastack:34
ESTAB   0        176     127.0.0.1:56224     127.0.0.1:7000
 ato:40 lastsnd:34 lastrcv:34 lastack:34 unacked:1 notsent:136
</code></pre>
<p>There's a lot of output here; I've removed the irrelevant bits.
<code>ato:40</code> says there's a 40ms timeout for &quot;delay ack mode&quot;.
<code>lastsnd</code>, etc, say that nothing had happened for 34ms when this information was collected.
<code>unacked</code> and <code>notsent</code> aren't documented in the man-page,
but I guess it means that the client (now port 56224) is waiting for 1 packet to be ack'd and has 136 bytes waiting until then.</p>
<p>The client socket still has both messages (176 bytes total) in its queue;
it can't forget about the first message until the server confirms receiving it,
since the client might need to send it again if it got lost.</p>
<p>This doesn't quite lead us to the solution, though.</p>
<h2>offwaketime</h2>
<p><a href="https://www.brendangregg.com/FlameGraphs/offcpuflamegraphs.html">offwaketime</a> records why a program stopped using the CPU, and what caused it to resume:</p>
<pre><code>$ sudo offwaketime-bpfcc -f -p (pgrep echo_bench.exe) &gt; wakes
$ flamegraph.pl --colors=chain wakes &gt; wakes.svg
</code></pre>
<p><a href="https://roscidus.com/blog/images/perf/wakes.svg"><span class="caption-wrapper center"><img src="https://roscidus.com/blog/images/perf/wakes.svg" title="Time spent suspended along with wakeup reason" class="caption"/><span class="caption-text">Time spent suspended along with wakeup reason</span></span></a></p>
<p><code>offwaketime</code> records a stack-trace when a process is suspended (shown at the bottom and going up)
and pairs it with the stack-trace of the thread that caused it to be resumed (shown above it and going down).</p>
<p>The taller column on the right shows Eio being woken up due to TCP data being received from the network,
confirming that it was the TCP ACK that got things going again.</p>
<p>The shorter column on the left was unexpected, and the <code>[UNKNOWN]</code> in the stack is annoying
(probably C code compiled without frame pointers).
<code>gdb</code> gets a better stack trace.
It turned out to be OCaml's tick thread, which wakes every 50ms to prevent one sys-thread from hogging the CPU:</p>
<pre><code>$ strace -T -e pselect6 -p (pgrep echo_bench.exe) -f
strace: Process 20162 attached with 2 threads
...
[pid 20173] pselect6(0, NULL, NULL, NULL, {tv_sec=0, tv_nsec=50000000}, NULL) = 0 (Timeout) &lt;0.050441&gt;
[pid 20173] pselect6(0, NULL, NULL, NULL, {tv_sec=0, tv_nsec=50000000}, NULL) = 0 (Timeout) &lt;0.050318&gt;
</code></pre>
<p>Having multiple threads shown on the same diagram is a bit confusing.
I should probably have used <code>-t</code> to focus only on the main one.</p>
<p>Also, note that when using profiling tools that record the OCaml stack,
it's useful to compile with frame pointers enabled.
To install e.g. OCaml 5.2.0 with frame pointers enabled, use:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
</pre></td><td class="code"><pre><code class="sh"><span class="line">$<span class="w"> </span>opam<span class="w"> </span>switch<span class="w"> </span>create<span class="w"> </span><span class="m">5</span>.2.0-fp<span class="w"> </span>ocaml-variants.5.2.0+options<span class="w"> </span>ocaml-option-fp
</span></code></pre></td></tr></tbody></table></div></figure><h2>magic-trace</h2>
<p><a href="https://magic-trace.org/">magic-trace</a> allows capturing a short trace of everything the CPUs were doing just before some event.
It uses Intel Processor Trace to have the CPU record all control flow changes (calls, branches, etc) to a ring-buffer,
with fairly low overhead (2% to 10%, due to extra memory bandwidth needed).
When something interesting happens, we save the buffer and use it to reconstruct the recent history.</p>
<p>Normally we'd need to set up a trigger to grab the buffer at the right moment,
but since this program is mostly idle it doesn't record much
and I just attached at a random point and immediately pressed Ctrl-C to grab a snapshot and detach:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
</pre></td><td class="code"><pre><code class="sh"><span class="line">$<span class="w"> </span>sudo<span class="w"> </span>magic-trace<span class="w"> </span>attach<span class="w"> </span>-multi-thread<span class="w"> </span>-trace-include-kernel<span class="w"> </span><span class="se">\</span>
</span><span class="line"><span class="w">    </span>-p<span class="w"> </span><span class="o">(</span>pgrep<span class="w"> </span>echo_bench.exe<span class="o">)</span>
</span><span class="line"><span class="o">[</span><span class="w"> </span>Attached.<span class="w"> </span>Press<span class="w"> </span>Ctrl-C<span class="w"> </span>to<span class="w"> </span>stop<span class="w"> </span>recording.<span class="w"> </span><span class="o">]</span>
</span><span class="line">^C
</span></code></pre></td></tr></tbody></table></div></figure><p>As before, we see 40ms periods of waiting, with bursts of activity between them:</p>
<p><a href="https://roscidus.com/blog/images/perf/capnp-magic-1.png"><span class="caption-wrapper center"><img src="https://roscidus.com/blog/images/perf/capnp-magic-1.png" title="Magic trace showing 40ms delays" class="caption"/><span class="caption-text">Magic trace showing 40ms delays</span></span></a></p>
<p>The output is a bit messed up because magic-trace doesn't understand that there are multiple OCaml fibers here,
each with their own stack. It also doesn't seem to know that exceptions unwind the stack.</p>
<p>In each 40ms column, <code>Eio_posix.Flow.single_read</code> (3rd line from top) tried to do a read
with <code>readv</code>, which got <code>EAGAIN</code> and called <code>Sched.next</code> to switch to the next fiber.
Since there was nothing left to run, the Eio scheduler called <code>ppoll</code>.
Linux didn't have anything ready for this process,
and called the <code>schedule</code> kernel function to switch to another process.</p>
<p>I recorded an eio-trace at the same time, to see the bigger picture.
Here's the eio-trace zoomed in to show the two client writes (just before the 40ms wait),
with the relevant bits of the magic-trace stack pasted below them:</p>
<p><a href="https://roscidus.com/blog/images/perf/capnp-magic-2.png"><span class="caption-wrapper center"><img src="https://roscidus.com/blog/images/perf/capnp-magic-2.png" title="Zoomed in on the two client writes, showing eio-trace and magic-trace output together" class="caption"/><span class="caption-text">Zoomed in on the two client writes, showing eio-trace and magic-trace output together</span></span></a></p>
<p>We can see the OCaml code calling <code>writev</code>, entering the kernel, <code>tcp_write_xmit</code> being called to handle it,
writing the IP packet to the network and then, because this is the loopback interface, the network receive logic
handling the packet too.
The second call is much shorter; <code>tcp_write_xmit</code> returns quickly without sending anything.</p>
<p>Note: I used the <code>eio_posix</code> backend here so it's easier to correlate the kernel operations to the application calls
(uring queues them up and runs them later).
The <a href="https://github.com/koonwen/uring-trace">uring-trace</a> project should make this easier in future, but doesn't integrate with eio-trace yet.</p>
<p>Zooming in further, it's easy to see the difference between the two calls to <code>tcp_write_xmit</code>:</p>
<p><a href="https://roscidus.com/blog/images/perf/tcp_write_xmit.png"><span class="caption-wrapper center"><img src="https://roscidus.com/blog/images/perf/tcp_write_xmit.png" title="The start of the first tcp_write_xmit and the whole of the second" class="caption"/><span class="caption-text">The start of the first tcp_write_xmit and the whole of the second</span></span></a>
Looking at the source for <a href="https://github.com/torvalds/linux/blob/v6.6/net/ipv4/tcp_output.c#L2727-L2731"><code>tcp_write_xmit</code></a>,
we finally find the magic word &quot;<a href="https://en.wikipedia.org/wiki/Nagle's_algorithm">nagle</a>&quot;!</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
</pre></td><td class="code"><pre><code class="c"><span class="line"><span class="k">if</span><span class="w"> </span><span class="p">(</span><span class="n">unlikely</span><span class="p">(</span><span class="o">!</span><span class="n">tcp_nagle_test</span><span class="p">(</span><span class="n">tp</span><span class="p">,</span><span class="w"> </span><span class="n">skb</span><span class="p">,</span><span class="w"> </span><span class="n">mss_now</span><span class="p">,</span>
</span><span class="line"><span class="w">			     </span><span class="p">(</span><span class="n">tcp_skb_is_last</span><span class="p">(</span><span class="n">sk</span><span class="p">,</span><span class="w"> </span><span class="n">skb</span><span class="p">)</span><span class="w"> </span><span class="o">?</span>
</span><span class="line"><span class="w">			      </span><span class="nl">nonagle</span><span class="w"> </span><span class="p">:</span><span class="w"> </span><span class="n">TCP_NAGLE_PUSH</span><span class="p">))))</span>
</span><span class="line"><span class="w">	</span><span class="k">break</span><span class="p">;</span>
</span></code></pre></td></tr></tbody></table></div></figure><h2>Summary script</h2>
<p>Having identified a load of interesting events
I wrote <a href="https://roscidus.com/blog/data/perf/summary-posix.bt">summary-posix.bt</a>, a bpftrace script to summarise them.
This includes log messages written by the application (by tracing <code>write</code> calls to stderr),
reads and writes on the sockets,
and various probed kernel functions seen in the magic-trace output and when reading the kernel source.</p>
<p>The output is specialised to this application (for example, TCP segments sent to port 7000
are displayed as &quot;to server&quot;, while others are &quot;to client&quot;).
I think this is a useful way to double-check my understanding, and any fix:</p>
<pre><code>$ sudo bpftrace summary-posix.bt
[...]
844ms: server: got ping request; sending reply
844ms: server reads from socket (EAGAIN)
844ms: server: writev(96 bytes)
844ms:   tcp_write_xmit (to client, nagle-on, packets_out=0)
844ms:   tcp_v4_send_check: sending 96 bytes to client
844ms: tcp_v4_rcv: got 96 bytes
844ms:   timer_start (tcp_delack_timer, 40 ms)
844ms: client reads 96 bytes from socket
844ms: client: enqueue finish message
844ms: client: enqueue ping call
844ms: client reads from socket (EAGAIN)
844ms: client: writev(40 bytes)
844ms:   tcp_write_xmit (to server, nagle-on, packets_out=0)
844ms:   tcp_v4_send_check: sending 40 bytes to server
845ms: tcp_v4_rcv: got 40 bytes
845ms:   timer_start (tcp_delack_timer, 40 ms)
845ms: client: writev(136 bytes)
845ms:   tcp_write_xmit (to server, nagle-on, packets_out=1)
845ms: server reads 40 bytes from socket
845ms: server reads from socket (EAGAIN)
885ms: tcp_delack_timer_handler (ACK to client)
885ms:   tcp_v4_send_check: sending 0 bytes to client
885ms: tcp_delack_timer_handler (ACK to server)
885ms: tcp_v4_rcv: got 0 bytes
885ms:   tcp_write_xmit (to server, nagle-on, packets_out=0)
885ms:   tcp_v4_send_check: sending 136 bytes to server
</code></pre>
<ol>
<li>The server replies to a ping request, sending a 96 byte reply.
Nagle is on, but nothing is awaiting an ACK (<code>packets_out=0</code>) so it gets sent immediately.
</li>
<li>The client receives the data. It starts a 40ms timer to send an ACK for it.
</li>
<li>The client enqueues a &quot;finish&quot; message, followed by another &quot;ping&quot; request.
</li>
<li>The client's write fiber sends the 40 byte &quot;finish&quot; message.
Nothing is awaiting an ACK (<code>packets_out=0</code>) so the kernel sends it immediately.
</li>
<li>The client sends the 136 byte ping request. As the last message hasn't been ACK'd, it isn't sent yet.
</li>
<li>The server receives the 40 byte finish message.
</li>
<li>40ms pass. The server's delayed ACK timer fires and it sends the ACK to the client.
</li>
<li>The client's delayed ACK timer fires, but there's nothing to do (it sent the ACK with the &quot;finish&quot;).
</li>
<li>The client socket gets the ACK for its &quot;finish&quot; message and sends the delayed ping request.
</li>
</ol>
<h2>Fixing it</h2>
<p>The problem seemed clear: while porting from Lwt to Eio I'd lost the output buffering.
So I looked at the Lwt code to see how it did it and... it doesn't! So how was it working?</p>
<p>As I did with Eio, I set the Lwt benchmark's concurrency to 1 to simplify it for tracing,
and discovered that Lwt with 1 client thread has exactly the same problem as the Eio version.
Well, that's embarrassing!
But why is Lwt fast with 12 client threads?</p>
<p>With only minor changes (e.g. <code>write</code> vs <code>writev</code>), the summary script above also worked for tracing the Lwt version.
With 1 or 2 client threads, Lwt is slow, but with 3 it's fairly fast.
The delay only happens if the client sends a &quot;finish&quot; message when the server has no replies queued up
(otherwise the finish message unblocks the replies, which carry the ACK to the client immediately).
So, it works mostly by fluke!
Lwt just happens to schedule the threads in such a way that Nagle's algorithm mostly doesn't trigger with 12 concurrent requests.</p>
<p>Anyway, adding buffering to the Eio version fixed the problem:</p>
<p><a href="https://roscidus.com/blog/images/perf/capnp-before.png"><span class="caption-wrapper center"><img src="https://roscidus.com/blog/images/perf/capnp-before.png" title="Before" class="caption"/><span class="caption-text">Before</span></span></a>
<a href="https://roscidus.com/blog/images/perf/capnp-after.png"><span class="caption-wrapper center"><img src="https://roscidus.com/blog/images/perf/capnp-after.png" title="After (same scale)" class="caption"/><span class="caption-text">After (same scale)</span></span></a></p>
<p>An interesting thing to notice here is that not only did the long delay go away,
but the CPU operations while it was active were faster too!
I think the reason is that the CPU goes into power-saving mode during the long delays.
<code>cpupower monitor</code> shows my CPUs running at around 1 GHz with the old code and
around 4.7 GHz when running the new version.</p>
<p>Here are the results for the fixed version:</p>
<pre><code>$ ./echo_bench.exe
echo_bench.exe: [INFO] rate = 44425.962625 # The old Lwt version
echo_bench.exe: [INFO] rate = 59653.451934 # The fixed Eio version
</code></pre>
<p>60k RPC requests per second doesn't seem that impressive, but at least it's faster than the old version,
which is good enough for now! There's clearly scope for improvement here (for example, the buffering I
added is quite inefficient, making two extra copies of every message, as the framing library copies it from
a cstruct to a string, and then I have to copy the string back to a cstruct for the kernel).</p>
<h2>Conclusions</h2>
<p>There are lots of great tools available to help understand why something is running slowly (or misbehaving),
and since programmers usually don't have much time for profiling,
a little investigation will often turn up something interesting!
Even when things are working correctly, these tools are a good way to learn more about how things work.</p>
<p><code>time</code> will quickly tell you if the program is taking lots of time in application code, in the kernel, or just sleeping.
If the problem is sleeping, <code>offcputime</code> and <code>offwaketime</code> can tell you why it was waiting and what woke it in the end.
My own <code>eio-trace</code> tool will give a quick visual overview of what an Eio application is doing.
<code>strace</code> is great for tracing interactions between applications and the kernel,
but it doesn't help much when the application is using uring.
To fix that, you can either switch to the <code>eio_posix</code> backend or use <code>bpftrace</code> with the uring tracepoints.
<code>tcpdump</code>, <code>wireshark</code> and <code>ss</code> are all useful to examine network problems specifically.</p>
<p>I've found <code>bpftrace</code> to be really useful for all kinds of tasks.
Being able to write quick one-liners or short scripts gives it great flexibility.
Since the scripts run in the kernel you can also filter and aggregate data efficiently
without having to pass it all to userspace, and you can examine any kernel data structures.
We didn't need that here because the program was running so slowly, but it's great for many problems.
In addition to using well-defined tracepoints,
it can also probe any (non-inlined) function in the kernel or the application.
I also think using it to create a &quot;summary script&quot; to confirm a problem and its solution seems useful,
though this is the first time I've tried doing that.</p>
<p><code>magic-trace</code> is great for getting really detailed function-by-function tracing through the application and kernel.
Its ability to report the last few ms of activity after you notice a problem is extremely useful
(though not needed in this example).
It would be really useful if you could trigger magic-trace from a bpftrace script, but I didn't see a way to do that.</p>
<p>However, it was surprisingly difficult to get any of the tools to point directly
at the combination of Nagle's algorithm with delayed ACKs as the cause of this common problem!</p>
<p>This post was mainly focused on what was happening in the kernel.
In <a href="https://roscidus.com/blog/blog/2024/07/22/performance-2/">part 2</a>, I'll investigate a CPU-intensive problem instead.</p>

