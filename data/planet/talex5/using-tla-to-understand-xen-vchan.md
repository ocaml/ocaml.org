---
title: Using TLA+ to understand Xen vchan
description:
url: https://roscidus.com/blog/blog/2019/01/01/using-tla-plus-to-understand-xen-vchan/
date: 2019-01-01T09:15:18-00:00
preview_image:
featured:
authors:
- Thomas Leonard
---

<p>The vchan protocol is used to stream data between virtual machines on a Xen host without needing any locks.
It is largely undocumented.
The TLA Toolbox is a set of tools for writing and checking specifications.
In this post, I'll describe my experiences using these tools to understand how the vchan protocol works.</p>

<p><strong>Table of Contents</strong></p>
<ul>
<li><a href="https://roscidus.com/#background">Background</a>
<ul>
<li><a href="https://roscidus.com/#qubes-and-the-vchan-protocol">Qubes and the vchan protocol</a>
</li>
<li><a href="https://roscidus.com/#tla">TLA+</a>
</li>
</ul>
</li>
<li><a href="https://roscidus.com/#is-tla-useful">Is TLA useful?</a>
</li>
<li><a href="https://roscidus.com/#basic-tla-concepts">Basic TLA concepts</a>
<ul>
<li><a href="https://roscidus.com/#variables-states-and-behaviour">Variables, states and behaviour</a>
</li>
<li><a href="https://roscidus.com/#actions">Actions</a>
</li>
<li><a href="https://roscidus.com/#correctness-of-spec">Correctness of Spec</a>
</li>
<li><a href="https://roscidus.com/#the-model-checker">The model checker</a>
</li>
</ul>
</li>
<li><a href="https://roscidus.com/#the-real-vchan">The real vchan</a>
<ul>
<li><a href="https://roscidus.com/#the-algorithm">The algorithm</a>
</li>
<li><a href="https://roscidus.com/#testing-the-full-spec">Testing the full spec</a>
</li>
<li><a href="https://roscidus.com/#some-odd-things">Some odd things</a>
</li>
<li><a href="https://roscidus.com/#why-does-vchan-work">Why does vchan work?</a>
</li>
<li><a href="https://roscidus.com/#proving-integrity">Proving Integrity</a>
</li>
<li><a href="https://roscidus.com/#availability">Availability</a>
</li>
</ul>
</li>
<li><a href="https://roscidus.com/#experiences-with-tlaps">Experiences with TLAPS</a>
</li>
<li><a href="https://roscidus.com/#the-final-specification">The final specification</a>
</li>
<li><a href="https://roscidus.com/#the-original-bug">The original bug</a>
</li>
<li><a href="https://roscidus.com/#conclusions">Conclusions</a>
</li>
</ul>
<p>( this post also appeared on <a href="https://www.reddit.com/r/tlaplus/comments/abi3oz/using_tla_to_understand_xen_vchan/">Reddit</a>, <a href="https://news.ycombinator.com/item?id=18814350">Hacker News</a>
and <a href="https://lobste.rs/s/a5zer2/using_tla_understand_xen_vchan">Lobsters</a> )</p>
<h2>Background</h2>
<h3>Qubes and the vchan protocol</h3>
<p>I run <a href="https://www.qubes-os.org/">QubesOS</a> on my laptop.
A QubesOS desktop environment is made up of multiple virtual machines.
A privileged VM, called dom0, provides the desktop environment and coordinates the other VMs.
dom0 doesn't have network access, so you have to use other VMs for doing actual work.
For example, I use one VM for email and another for development work (these are called &quot;application VMs&quot;).
There is another VM (called sys-net) that connects to the physical network, and
yet another VM (sys-firewall) that connects the application VMs to net-vm.</p>
<p><span class="caption-wrapper center"><img src="https://roscidus.com/blog/images/qubes/qubes-desktop.png" title="My QubesOS desktop. The windows with blue borders are from my Debian development VM, while the green one is from a Fedora VM, etc." class="caption"/><span class="caption-text">My QubesOS desktop. The windows with blue borders are from my Debian development VM, while the green one is from a Fedora VM, etc.</span></span></p>
<p>The default sys-firewall is based on Fedora Linux.
A few years ago, <a href="https://roscidus.com/blog/blog/2016/01/01/a-unikernel-firewall-for-qubesos/">I replaced sys-firewall with a MirageOS unikernel</a>.
MirageOS is written in OCaml, and has very little C code (unlike Linux).
It boots much faster and uses much less RAM than the Fedora-based VM.
But recently, a user reported that <a href="https://github.com/mirage/mirage-qubes/issues/25">restarting mirage-firewall was taking a very long time</a>.
The problem seemed to be that it was taking several minutes to transfer the information about the network configuration to the firewall.
This is sent over vchan.
The user reported that stracing the QubesDB process in dom0 revealed that it was sleeping for 10 seconds
between sending the records, suggesting that a wakeup event was missing.</p>
<p>The lead developer of QubesOS said:</p>
<blockquote>
<p>I'd guess missing evtchn trigger after reading/writing data in vchan.</p>
</blockquote>
<p>Perhaps <a href="https://github.com/mirage/ocaml-vchan">ocaml-vchan</a>, the OCaml implementation of vchan, wasn't implementing the vchan specification correctly?
I wanted to check, but there was a problem: there was no vchan specification.</p>
<p>The Xen wiki lists vchan under <a href="https://wiki.xenproject.org/wiki/Xen_Document_Days/TODO#Documentation_on_lib.28xen.29vchan">Xen Document Days/TODO</a>.
The <a href="https://xenbits.xen.org/gitweb/?p=xen.git%3Ba=commit%3Bh=1a16a3351ff2f2cf9f0cc0a27c89a0652eb8dfb4">initial Git commit</a> on 2011-10-06 said:</p>
<blockquote>
<p>libvchan: interdomain communications library</p>
<p>This library implements a bidirectional communication interface between
applications in different domains, similar to unix sockets. Data can be
sent using the byte-oriented <code>libvchan_read</code>/<code>libvchan_write</code> or the
packet-oriented <code>libvchan_recv</code>/<code>libvchan_send</code>.</p>
<p>Channel setup is done using a client-server model; domain IDs and a port
number must be negotiated prior to initialization. The server allocates
memory for the shared pages and determines the sizes of the
communication rings (which may span multiple pages, although the default
places rings and control within a single page).</p>
<p>With properly sized rings, testing has shown that this interface
provides speed comparable to pipes within a single Linux domain; it is
significantly faster than network-based communication.</p>
</blockquote>
<p>I looked in the xen-devel mailing list around this period in case the reviewers had asked about how it worked.</p>
<p>One reviewer <a href="https://lists.xenproject.org/archives/html/xen-devel/2011-08/msg00874.html">suggested</a>:</p>
<blockquote>
<p>Please could you say a few words about the functionality this new
library enables and perhaps the design etc? In particular a protocol
spec would be useful for anyone who wanted to reimplement for another
guest OS etc. [...]
I think it would be appropriate to add protocol.txt at the same time as
checking in the library.</p>
</blockquote>
<p>However, the submitter pointed out that this was unnecessary, saying:</p>
<blockquote>
<p>The comments in the shared header file explain the layout of the shared
memory regions; any other parts of the protocol are application-defined.</p>
</blockquote>
<p>Now, ordinarily, I wouldn't be much interested in spending my free time
tracking down race conditions in 3rd-party libraries for the benefit of
strangers on the Internet. However, I did want to have another play with TLA...</p>
<h3>TLA+</h3>
<p><a href="https://lamport.azurewebsites.net/tla/tla.html">TLA+</a> is a language for specifying algorithms.
It can be used for many things, but it is particularly designed for stateful parallel algorithms.</p>
<p>I learned about TLA while working at Docker.
Docker EE provides software for managing large clusters of machines.
It includes various orchestrators (SwarmKit, Kubernetes and Swarm Classic) and
a web UI.
Ensuring that everything works properly is very important, and to this end
a large collection of tests had been produced.
Part of my job was to run these tests.
You take a test from a list in a web UI and click whatever buttons it tells you to click,
wait for some period of time,
and then check that what you see matches what the test says you should see.
There were a lot of these tests, and they all had to be repeated on every
supported platform, and for every release, release candidate or preview release.
There was a lot of waiting involved and not much thinking required, so to keep
my mind occupied, I started reading the TLA documentation.</p>
<p>I read <a href="https://lamport.azurewebsites.net/tla/hyperbook.html">The TLA+ Hyperbook</a> and <a href="https://lamport.azurewebsites.net/tla/book.html">Specifying Systems</a>.
Both are by Leslie Lamport (the creator of TLA), and are freely available online.
They're both very easy to read.
The hyperbook introduces the tools right away so you can start playing, while
Specifying Systems starts with more theory and discusses the tools later.
I think it's worth reading both.</p>
<p>Once Docker EE 2.0 was released,
we engineers were allowed to spend a week on whatever fun (Docker-related) project we wanted.
I used the time to read the SwarmKit design documents and make a TLA model of that.
I felt that using TLA prompted useful discussions with the SwarmKit developers
(which can see seen in the <a href="https://github.com/docker/swarmkit/pull/2613">pull request</a> comments).</p>
<p>A specification document can answer questions such as:</p>
<ol>
<li>What does it do? (requirements / properties)
</li>
<li>How does it do it? (the algorithm)
</li>
<li>Does it work? (model checking)
</li>
<li>Why does it work? (inductive invariant)
</li>
<li>Does it <em>really</em> work? (proofs)
</li>
</ol>
<p>You don't have to answer all of them to have a useful document,
but I will try to answer each of them for vchan.</p>
<h2>Is TLA useful?</h2>
<p>In my (limited) experience with TLA, whenever I have reached the end of a specification
(whether reading it or writing it), I always find myself thinking &quot;Well, that was obvious.
It hardly seems worth writing a spec for that!&quot;.
You might feel the same after reading this blog post.</p>
<p>To judge whether TLA is useful, I suggest you take a few minutes to look at the code.
If you are good at reading C code then you might find, like the Xen reviewers,
that it is quite obvious what it does, how it works, and why it is correct.
Or, like me, you might find you'd prefer a little help.
You might want to jot down some notes about it now, to see whether you learn anything new.</p>
<p>To give the big picture:</p>
<ol>
<li>Two VMs decide to communicate over vchan. One will be the server and the other the client.
</li>
<li>The server allocates three chunks of memory: one to hold data in transit from the client to
the server, one for data going from server to client, and the third to track information about
the state of the system. This includes counters saying how much data has been written and how
much read, in each direction.
</li>
<li>The server tells Xen to grant the client access to this memory.
</li>
<li>The client asks Xen to map the memory into its address space.
Now client and server can both access it at once.
There are no locks in the protocol, so be careful!
</li>
<li>Either end sends data by writing it into the appropriate buffer and updating the appropriate counter
in the shared block. The buffers are <a href="https://en.wikipedia.org/wiki/Circular_buffer">ring buffers</a>, so after getting to the end, you
start again from the beginning.
</li>
<li>The data-written (producer) counter and the data-read (consumer) counter together
tell you how much data is in the buffer, and where it is.
When the difference is zero, the reader must stop reading and wait for more data.
When the difference is the size of the buffer, the writer must stop writing and wait for more space.
</li>
<li>When one end is waiting, the other can signal it using a <a href="https://wiki.xen.org/wiki/Event_Channel_Internals">Xen event channel</a>.
This essentially sets a pending flag to true at the other end, and wakes the VM if it is sleeping.
If a VM tries to sleep while it has an event pending, it will immediately wake up again.
Sending an event when one is already pending has no effect.
</li>
</ol>
<p>The <a href="http://xenbits.xen.org/gitweb/?p=xen.git%3Ba=blob%3Bf=xen/include/public/io/libxenvchan.h%3Bh=44284f437ab30f01049f280035dbb711103ca9b0%3Bhb=HEAD">public/io/libxenvchan.h</a> header file provides some information,
including the shared structures and comments about them:</p>
<figure class="code"><figcaption><span>xen/include/public/io/libxenvchan.h</span></figcaption><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
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
<span class="line-number">19</span>
<span class="line-number">20</span>
<span class="line-number">21</span>
<span class="line-number">22</span>
<span class="line-number">23</span>
<span class="line-number">24</span>
<span class="line-number">25</span>
<span class="line-number">26</span>
<span class="line-number">27</span>
<span class="line-number">28</span>
<span class="line-number">29</span>
<span class="line-number">30</span>
<span class="line-number">31</span>
<span class="line-number">32</span>
<span class="line-number">33</span>
<span class="line-number">34</span>
<span class="line-number">35</span>
<span class="line-number">36</span>
<span class="line-number">37</span>
<span class="line-number">38</span>
<span class="line-number">39</span>
<span class="line-number">40</span>
<span class="line-number">41</span>
<span class="line-number">42</span>
<span class="line-number">43</span>
<span class="line-number">44</span>
<span class="line-number">45</span>
<span class="line-number">46</span>
<span class="line-number">47</span>
<span class="line-number">48</span>
</pre></td><td class="code"><pre><code class="c"><span class="line"><span class="k">struct</span> <span class="nc">ring_shared</span> <span class="p">{</span>
</span><span class="line">    <span class="kt">uint32_t</span> <span class="n">cons</span><span class="p">,</span> <span class="n">prod</span><span class="p">;</span>
</span><span class="line"><span class="p">};</span>
</span><span class="line">
</span><span class="line"><span class="cp">#define VCHAN_NOTIFY_WRITE 0x1</span>
</span><span class="line"><span class="cp">#define VCHAN_NOTIFY_READ 0x2</span>
</span><span class="line">
</span><span class="line"><span class="cm">/**</span>
</span><span class="line"><span class="cm"> * vchan_interface: primary shared data structure</span>
</span><span class="line"><span class="cm"> */</span>
</span><span class="line"><span class="k">struct</span> <span class="nc">vchan_interface</span> <span class="p">{</span>
</span><span class="line">    <span class="cm">/**</span>
</span><span class="line"><span class="cm">     * Standard consumer/producer interface, one pair per buffer</span>
</span><span class="line"><span class="cm">     * left is client write, server read</span>
</span><span class="line"><span class="cm">     * right is client read, server write</span>
</span><span class="line"><span class="cm">     */</span>
</span><span class="line">    <span class="k">struct</span> <span class="nc">ring_shared</span> <span class="n">left</span><span class="p">,</span> <span class="n">right</span><span class="p">;</span>
</span><span class="line">    <span class="cm">/**</span>
</span><span class="line"><span class="cm">     * size of the rings, which determines their location</span>
</span><span class="line"><span class="cm">     * 10   - at offset 1024 in ring's page</span>
</span><span class="line"><span class="cm">     * 11   - at offset 2048 in ring's page</span>
</span><span class="line"><span class="cm">     * 12+  - uses 2^(N-12) grants to describe the multi-page ring</span>
</span><span class="line"><span class="cm">     * These should remain constant once the page is shared.</span>
</span><span class="line"><span class="cm">     * Only one of the two orders can be 10 (or 11).</span>
</span><span class="line"><span class="cm">     */</span>
</span><span class="line">    <span class="kt">uint16_t</span> <span class="n">left_order</span><span class="p">,</span> <span class="n">right_order</span><span class="p">;</span>
</span><span class="line">    <span class="cm">/**</span>
</span><span class="line"><span class="cm">     * Shutdown detection:</span>
</span><span class="line"><span class="cm">     *  0: client (or server) has exited</span>
</span><span class="line"><span class="cm">     *  1: client (or server) is connected</span>
</span><span class="line"><span class="cm">     *  2: client has not yet connected</span>
</span><span class="line"><span class="cm">     */</span>
</span><span class="line">    <span class="kt">uint8_t</span> <span class="n">cli_live</span><span class="p">,</span> <span class="n">srv_live</span><span class="p">;</span>
</span><span class="line">    <span class="cm">/**</span>
</span><span class="line"><span class="cm">     * Notification bits:</span>
</span><span class="line"><span class="cm">     *  VCHAN_NOTIFY_WRITE: send notify when data is written</span>
</span><span class="line"><span class="cm">     *  VCHAN_NOTIFY_READ: send notify when data is read (consumed)</span>
</span><span class="line"><span class="cm">     * cli_notify is used for the client to inform the server of its action</span>
</span><span class="line"><span class="cm">     */</span>
</span><span class="line">    <span class="kt">uint8_t</span> <span class="n">cli_notify</span><span class="p">,</span> <span class="n">srv_notify</span><span class="p">;</span>
</span><span class="line">    <span class="cm">/**</span>
</span><span class="line"><span class="cm">     * Grant list: ordering is left, right. Must not extend into actual ring</span>
</span><span class="line"><span class="cm">     * or grow beyond the end of the initial shared page.</span>
</span><span class="line"><span class="cm">     * These should remain constant once the page is shared, to allow</span>
</span><span class="line"><span class="cm">     * for possible remapping by a client that restarts.</span>
</span><span class="line"><span class="cm">     */</span>
</span><span class="line">    <span class="kt">uint32_t</span> <span class="n">grants</span><span class="p">[</span><span class="mi">0</span><span class="p">];</span>
</span><span class="line"><span class="p">};</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>You might also like to look at <a href="http://xenbits.xen.org/gitweb/?p=xen.git%3Ba=tree%3Bf=tools/libvchan%3Bh=44e5af5adacc92511f29d1ab3e1c1037c7ea60fa%3Bhb=HEAD">the vchan source code</a>.
Note that the <code>libxenvchan.h</code> file in this directory includes and extends
the above header file (with the same name).</p>
<p>For this blog post, we will ignore the Xen-specific business of sharing the memory
and telling the client where it is, and assume that the client has mapped the
memory and is ready to go.</p>
<h2>Basic TLA concepts</h2>
<p>We'll take a first look at TLA concepts and notation using a simplified version of vchan.
TLA comes with excellent documentation, so I won't try to make this a full tutorial,
but hopefully you will be able to follow the rest of this blog post after reading it.
We will just consider a single direction of the channel (e.g. client-to-server) here.</p>
<h3>Variables, states and behaviour</h3>
<p>A <em>variable</em> in TLA is just what a programmer expects: something that changes over time.
For example, I'll use <code>Buffer</code> to represent the data currently being transmitted.</p>
<p>We can also add variables that are just useful for the specification.
I use <code>Sent</code> to represent everything the sender-side application asked the vchan library to transmit,
and <code>Got</code> for everything the receiving application has received:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="kn">VARIABLES</span> <span class="n">Got</span><span class="p">,</span> <span class="n">Buffer</span><span class="p">,</span> <span class="n">Sent</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>A <em>state</em> in TLA represents a snapshot of the world at some point.
It gives a value for each variable.
For example, <code>{ Got: &quot;H&quot;, Buffer: &quot;i&quot;, Sent: &quot;Hi&quot;, ... }</code> is a state.
The <code>...</code> is just a reminder that a state also includes everything else in the world,
not just the variables we care about.</p>
<p>Here are some more states:</p>
<table class="table"><thead><tr><th> State </th><th> Got </th><th> Buffer </th><th> Sent </th></tr></thead><tbody><tr><td> s0    </td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr><tr><td> s1    </td><td>&nbsp;</td><td> H      </td><td> H    </td></tr><tr><td> s2    </td><td> H   </td><td>&nbsp;</td><td> H    </td></tr><tr><td> s3    </td><td> H   </td><td> i      </td><td> Hi   </td></tr><tr><td> s4    </td><td> Hi  </td><td>&nbsp;</td><td> Hi   </td></tr><tr><td> s5    </td><td> iH  </td><td>&nbsp;</td><td> Hi   </td></tr></tbody></table><p>A <em>behaviour</em> is a sequence of states, representing some possible history of the world.
For example, <code>&lt;&lt; s0, s1, s2, s3, s4 &gt;&gt;</code> is a behaviour.
So is <code>&lt;&lt; s0, s1, s5 &gt;&gt;</code>, but not one we want.
The basic idea in TLA is to specify precisely which behaviours we want and which we don't want.</p>
<p>A <em>state expression</em> is an expression that can be evaluated in the context of some state.
For example, this defines <code>Integrity</code> to be a state expression that is true whenever what we have got
so far matches what we wanted to send:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
<span class="line-number">6</span>
<span class="line-number">7</span>
<span class="line-number">8</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="cm">(* Take(m, i) is just the first i elements of message m. *)</span>
</span><span class="line"><span class="n">Take</span><span class="p">(</span><span class="n">m</span><span class="p">,</span> <span class="n">i</span><span class="p">)</span> <span class="ni">==</span> <span class="n">SubSeq</span><span class="p">(</span><span class="n">m</span><span class="p">,</span> <span class="m">1</span><span class="p">,</span> <span class="n">i</span><span class="p">)</span>
</span><span class="line">
</span><span class="line"><span class="cm">(* Everything except the first i elements of message m. *)</span>
</span><span class="line"><span class="n">Drop</span><span class="p">(</span><span class="n">m</span><span class="p">,</span> <span class="n">i</span><span class="p">)</span> <span class="ni">==</span> <span class="n">SubSeq</span><span class="p">(</span><span class="n">m</span><span class="p">,</span> <span class="n">i</span> <span class="o">+</span> <span class="m">1</span><span class="p">,</span> <span class="n">Len</span><span class="p">(</span><span class="n">m</span><span class="p">))</span>
</span><span class="line">
</span><span class="line"><span class="n">Integrity</span> <span class="ni">==</span>
</span><span class="line">  <span class="n">Take</span><span class="p">(</span><span class="n">Sent</span><span class="p">,</span> <span class="n">Len</span><span class="p">(</span><span class="n">Got</span><span class="p">))</span> <span class="ni">=</span> <span class="n">Got</span>
</span></code></pre></td></tr></tbody></table></div></figure><p><code>Integrity</code> is true for all the states above except for <code>s5</code>.
I added some helper operators <code>Take</code> and <code>Drop</code> here.
Sequences in TLA+ can be confusing because they are indexed from 1 rather than from 0,
so it is easy to make off-by-one errors.
These operators just use lengths, which we can all agree on.
In Python syntax, it would be written something like:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
</pre></td><td class="code"><pre><code class="python"><span class="line"><span class="k">def</span> <span class="nf">Integrity</span><span class="p">(</span><span class="n">s</span><span class="p">):</span>
</span><span class="line">    <span class="k">return</span> <span class="n">s</span><span class="o">.</span><span class="n">Sent</span><span class="o">.</span><span class="n">starts_with</span><span class="p">(</span><span class="n">s</span><span class="o">.</span><span class="n">Got</span><span class="p">)</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>A <em>temporal formula</em> is an expression that is evaluated in the context of a complete behaviour.
It can use the temporal operators, which include:</p>
<ul>
<li><code>[]</code> (that's supposed to look like a square) : &quot;always&quot;
</li>
<li><code>&lt;&gt;</code> (that's supposed to look like a diamond) : &quot;eventually&quot;
</li>
</ul>
<p><code>[] F</code> is true if the expression <code>F</code> is true at <em>every</em> point in the behaviour.
<code>&lt;&gt; F</code> is true if the expression <code>F</code> is true at <em>any</em> point in the behaviour.</p>
<p>Messages we send should eventually arrive.
Here's one way to express that:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="n">Availability</span> <span class="ni">==</span>
</span><span class="line">  <span class="s">\A</span> <span class="n">x</span> <span class="s">\in</span> <span class="n">Nat</span> <span class="p">:</span>
</span><span class="line">    <span class="p">[]</span> <span class="p">(</span><span class="n">Len</span><span class="p">(</span><span class="n">Sent</span><span class="p">)</span> <span class="ni">=</span> <span class="n">x</span> <span class="ni">=&gt;</span> <span class="ni">&lt;&gt;</span> <span class="p">(</span><span class="n">Len</span><span class="p">(</span><span class="n">Got</span><span class="p">)</span> <span class="o">&gt;=</span> <span class="n">x</span><span class="p">)</span> <span class="p">)</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>TLA syntax is a bit odd. It's rather like LaTeX (which is not surprising: Lamport is also the &quot;La&quot; in LaTeX).
<code>\A</code> means &quot;for all&quot; (rendered as an upside-down A).
So this says that for every number <code>x</code>, it is always true that if we have sent <code>x</code> bytes then
eventually we will have received at least <code>x</code> bytes.</p>
<p>This pattern of <code>[] (F =&gt; &lt;&gt;G)</code> is common enough that it has a shorter notation of <code>F ~&gt; G</code>, which
is read as &quot;F (always) leads to G&quot;. So, <code>Availability</code> can also be written as:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="n">Availability</span> <span class="ni">==</span>
</span><span class="line">  <span class="s">\A</span> <span class="n">x</span> <span class="s">\in</span> <span class="n">Nat</span> <span class="p">:</span>
</span><span class="line">    <span class="n">Len</span><span class="p">(</span><span class="n">Sent</span><span class="p">)</span> <span class="ni">=</span> <span class="n">x</span> <span class="o">~</span><span class="ni">&gt;</span> <span class="n">Len</span><span class="p">(</span><span class="n">Got</span><span class="p">)</span> <span class="o">&gt;=</span> <span class="n">x</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>We're only checking the lengths in <code>Availability</code>, but combined with <code>Integrity</code> that's enough to ensure
that we eventually receive what we want.
So ideally, we'd like to ensure that every possible behaviour of the vchan library will satisfy
the temporal formula <code>Properties</code>:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="n">Properties</span> <span class="ni">==</span>
</span><span class="line">  <span class="n">Availability</span> <span class="o">/\</span> <span class="p">[]</span><span class="n">Integrity</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>That <code>/\</code> is &quot;and&quot; by the way, and <code>\/</code> is &quot;or&quot;.
I did eventually start to be able to tell one from the other, though I still think <code>&amp;&amp;</code> and <code>||</code> would be easier.
In case I forget to explain some syntax, <a href="https://lamport.azurewebsites.net/tla/summary.pdf">A Summary of TLA</a> lists most of it.</p>
<h3>Actions</h3>
<p>It is hopefully easy to see that <code>Properties</code> defines properties we want.
A user of vchan would be happy to see that these are things they can rely on.
But they don't provide much help to someone trying to implement vchan.
For that, TLA provides another way to specify behaviours.</p>
<p>An <em>action</em> in TLA is an expression that is evaluated in the context of a pair of states,
representing a single atomic step of the system.
For example:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="n">Read</span> <span class="ni">==</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">Len</span><span class="p">(</span><span class="n">Buffer</span><span class="p">)</span> <span class="ni">&gt;</span> <span class="m">0</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">Got</span><span class="err">'</span> <span class="ni">=</span> <span class="n">Got</span> <span class="nb">\o</span> <span class="n">Buffer</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">Buffer</span><span class="err">'</span> <span class="ni">=</span> <span class="ni">&lt;&lt;</span> <span class="ni">&gt;&gt;</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">UNCHANGED</span> <span class="n">Sent</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>The <code>Read</code> action is true of a step if that step transfers all the data from <code>Buffer</code> to <code>Got</code>.
Unprimed variables (e.g. <code>Buffer</code>) refer to the current state and primed ones (e.g. <code>Buffer'</code>)
refer to the next state.
There's some more strange notation here too:</p>
<ul>
<li>We're using <code>/\</code> to form a bulleted list here rather than as an infix operator.
This is indentation-sensitive. TLA also supports <code>\/</code> lists in the same way.
</li>
<li><code>\o</code> is sequence concatenation (<code>+</code> in Python).
</li>
<li><code>&lt;&lt; &gt;&gt;</code> is the empty sequence (<code>[ ]</code> in Python).
</li>
<li><code>UNCHANGED Sent</code> means <code>Sent' = Sent</code>.
</li>
</ul>
<p>In Python, it might look like this:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
</pre></td><td class="code"><pre><code class="python"><span class="line"><span class="k">def</span> <span class="nf">Read</span><span class="p">(</span><span class="n">current</span><span class="p">,</span> <span class="nb">next</span><span class="p">):</span>
</span><span class="line">  <span class="k">return</span> <span class="n">Len</span><span class="p">(</span><span class="n">current</span><span class="o">.</span><span class="n">Buffer</span><span class="p">)</span> <span class="o">&gt;</span> <span class="mi">0</span> \
</span><span class="line">     <span class="ow">and</span> <span class="nb">next</span><span class="o">.</span><span class="n">Got</span> <span class="o">=</span> <span class="n">current</span><span class="o">.</span><span class="n">Got</span> <span class="o">+</span> <span class="n">current</span><span class="o">.</span><span class="n">Buffer</span> \
</span><span class="line">     <span class="ow">and</span> <span class="nb">next</span><span class="o">.</span><span class="n">Buffer</span> <span class="o">=</span> <span class="p">[]</span> \
</span><span class="line">     <span class="ow">and</span> <span class="nb">next</span><span class="o">.</span><span class="n">Sent</span> <span class="o">=</span> <span class="n">current</span><span class="o">.</span><span class="n">Sent</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>Actions correspond more closely to code than temporal formulas,
because they only talk about how the next state is related to the current one.</p>
<p>This action only allows one thing: reading the whole buffer at once.
In the C implementation of vchan the receiving application can provide a buffer of any size
and the library will read at most enough bytes to fill the buffer.
To model that, we will need a slightly more flexible version:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="n">Read</span> <span class="ni">==</span>
</span><span class="line">  <span class="s">\E</span> <span class="n">n</span> <span class="s">\in</span> <span class="m">1</span><span class="o">..</span><span class="n">Len</span><span class="p">(</span><span class="n">Buffer</span><span class="p">)</span> <span class="p">:</span>
</span><span class="line">    <span class="o">/\</span> <span class="n">Got</span><span class="err">'</span> <span class="ni">=</span> <span class="n">Got</span> <span class="nb">\o</span> <span class="n">Take</span><span class="p">(</span><span class="n">Buffer</span><span class="p">,</span> <span class="n">n</span><span class="p">)</span>
</span><span class="line">    <span class="o">/\</span> <span class="n">Buffer</span><span class="err">'</span> <span class="ni">=</span> <span class="n">Drop</span><span class="p">(</span><span class="n">Buffer</span><span class="p">,</span> <span class="n">n</span><span class="p">)</span>
</span><span class="line">    <span class="o">/\</span> <span class="n">UNCHANGED</span> <span class="n">Sent</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>This says that a step is a <code>Read</code> step if there is any <code>n</code> (in the range 1 to the length of the buffer)
such that we transferred <code>n</code> bytes from the buffer. <code>\E</code> means &quot;there exists ...&quot;.</p>
<p>A <code>Write</code> action can be defined in a similar way:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
<span class="line-number">6</span>
<span class="line-number">7</span>
<span class="line-number">8</span>
<span class="line-number">9</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="kn">CONSTANT</span> <span class="n">BufferSize</span>
</span><span class="line"><span class="n">Byte</span> <span class="ni">==</span> <span class="m">0</span><span class="o">..</span><span class="m">255</span>
</span><span class="line">
</span><span class="line"><span class="n">Write</span> <span class="ni">==</span>
</span><span class="line">  <span class="s">\E</span> <span class="n">m</span> <span class="s">\in</span> <span class="n">Seq</span><span class="p">(</span><span class="n">Byte</span><span class="p">)</span> <span class="o">\</span> <span class="ni">{&lt;&lt;</span> <span class="ni">&gt;&gt;}</span> <span class="p">:</span>
</span><span class="line">    <span class="o">/\</span> <span class="n">Buffer</span><span class="err">'</span> <span class="ni">=</span> <span class="n">Buffer</span> <span class="nb">\o</span> <span class="n">m</span>
</span><span class="line">    <span class="o">/\</span> <span class="n">Len</span><span class="p">(</span><span class="n">Buffer</span><span class="err">'</span><span class="p">)</span> <span class="o">&lt;=</span> <span class="n">BufferSize</span>
</span><span class="line">    <span class="o">/\</span> <span class="n">Sent</span><span class="err">'</span> <span class="ni">=</span> <span class="n">Sent</span> <span class="nb">\o</span> <span class="n">m</span>
</span><span class="line">    <span class="o">/\</span> <span class="n">UNCHANGED</span> <span class="n">Got</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>A <code>CONSTANT</code> defines a parameter (input) of the specification
(it's constant in the sense that it doesn't change between states).
A <code>Write</code> operation adds some message <code>m</code> to the buffer, and also adds a copy of it to <code>Sent</code>
so we can talk about what the system is doing.
<code>Seq(Byte)</code> is the set of all possible sequences of bytes,
and <code>\ {&lt;&lt; &gt;&gt;}</code> just excludes the empty sequence.</p>
<p>A step of the combined system is either a <code>Read</code> step or a <code>Write</code> step:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="n">Next</span> <span class="ni">==</span>
</span><span class="line">  <span class="n">Read</span> <span class="o">\/</span> <span class="n">Write</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>We also need to define what a valid starting state for the algorithm looks like:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="n">Init</span> <span class="ni">==</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">Sent</span> <span class="ni">=</span> <span class="ni">&lt;&lt;</span> <span class="ni">&gt;&gt;</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">Buffer</span> <span class="ni">=</span> <span class="ni">&lt;&lt;</span> <span class="ni">&gt;&gt;</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">Got</span> <span class="ni">=</span> <span class="ni">&lt;&lt;</span> <span class="ni">&gt;&gt;</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>Finally, we can put all this together to get a temporal formula for the algorithm:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="n">vars</span> <span class="ni">==</span> <span class="ni">&lt;&lt;</span> <span class="n">Got</span><span class="p">,</span> <span class="n">Buffer</span><span class="p">,</span> <span class="n">Sent</span> <span class="ni">&gt;&gt;</span> 
</span><span class="line">
</span><span class="line"><span class="n">Spec</span> <span class="ni">==</span>
</span><span class="line">  <span class="n">Init</span> <span class="o">/\</span> <span class="p">[][</span><span class="n">Next</span><span class="p">]</span><span class="n">_vars</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>Some more notation here:</p>
<ul>
<li><code>[Next]_vars</code> (that's <code>Next</code> in brackets with a subscript <code>vars</code>) means
<code>Next \/ UNCHANGED vars</code>.
</li>
<li>Using <code>Init</code> (a state expression) in a temporal formula means it must be
true for the <em>first</em> state of the behaviour.
</li>
<li><code>[][Action]_vars</code> means that <code>[Action]_vars</code> must be true for each step.
</li>
</ul>
<p>TLA syntax requires the <code>_vars</code> subscript here.
This is because other things can be going on in the world beside our algorithm,
so it must always be possible to take a step without our algorithm doing anything.</p>
<p><code>Spec</code> defines behaviours just like <code>Properties</code> does,
but in a way that makes it more obvious how to implement the protocol.</p>
<h3>Correctness of Spec</h3>
<p>Now we have definitions of <code>Spec</code> and <code>Properties</code>,
it makes sense to check that every behaviour of <code>Spec</code> satisfies <code>Properties</code>.
In Python terms, we want to check that all behaviours <code>b</code> satisfy this:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
</pre></td><td class="code"><pre><code class="python"><span class="line"><span class="k">def</span> <span class="nf">SpecOK</span><span class="p">(</span><span class="n">b</span><span class="p">):</span>
</span><span class="line">  <span class="k">return</span> <span class="n">Spec</span><span class="p">(</span><span class="n">b</span><span class="p">)</span> <span class="o">=</span> <span class="kc">False</span> <span class="ow">or</span> <span class="n">Properties</span><span class="p">(</span><span class="n">b</span><span class="p">)</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>i.e. either <code>b</code> isn't a behaviour that could result from the actions of our algorithm or,
if it is, it satisfies <code>Properties</code>. In TLA notation, we write this as:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="n">SpecOK</span> <span class="ni">==</span>
</span><span class="line">  <span class="n">Spec</span> <span class="ni">=&gt;</span> <span class="n">Properties</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>It's OK if a behaviour is allowed by <code>Properties</code> but not by <code>Spec</code>.
For example, the behaviour which goes straight from <code>Got=&quot;&quot;, Sent=&quot;&quot;</code> to
<code>Got=&quot;Hi&quot;, Sent=&quot;Hi&quot;</code> in one step meets our requirements, but it's not a
behaviour of <code>Spec</code>.</p>
<p>The real implementation may itself further restrict <code>Spec</code>.
For example, consider the behaviour <code>&lt;&lt; s0, s1, s2 &gt;&gt;</code>:</p>
<table class="table"><thead><tr><th> State </th><th> Got </th><th> Buffer </th><th> Sent </th></tr></thead><tbody><tr><td> s0    </td><td>&nbsp;</td><td> Hi     </td><td> Hi   </td></tr><tr><td> s1    </td><td> H   </td><td> i      </td><td> Hi   </td></tr><tr><td> s2    </td><td> Hi  </td><td>&nbsp;</td><td> Hi   </td></tr></tbody></table><p>The sender sends two bytes at once, but the reader reads them one at a time.
This <em>is</em> a behaviour of the C implementation,
because the reading application can ask the library to read into a 1-byte buffer.
However, it is <em>not</em> a behaviour of the OCaml implementation,
which gets to choose how much data to return to the application and will return both bytes together.</p>
<p>That's fine.
We just need to show that <code>OCamlImpl =&gt; Spec</code> and <code>Spec =&gt; Properties</code> and we can deduce that
<code>OCamlImpl =&gt; Properties</code>.
This is, of course, the key purpose of a specification:
we only need to check that each implementation implements the specification,
not that each implementation directly provides the desired properties.</p>
<p>It might seem strange that an implementation doesn't have to allow all the specified behaviours.
In fact, even the trivial specification <code>Spec == FALSE</code> is considered to be a correct implementation of <code>Properties</code>,
because it has no bad behaviours (no behaviours at all).
But that's OK.
Once the algorithm is running, it must have <em>some</em> behaviour, even if that behaviour is to do nothing.
As the user of the library, you are responsible for checking that you can use it
(e.g. by ensuring that the <code>Init</code> conditions are met).
An algorithm without any behaviours corresponds to a library you could never use,
not to one that goes wrong once it is running.</p>
<h3>The model checker</h3>
<p>Now comes the fun part: we can ask TLC (the TLA model checker) to check that <code>Spec =&gt; Properties</code>.
You do this by asking the toolbox to create a new model (I called mine <code>SpecOK</code>) and setting <code>Spec</code> as the
&quot;behaviour spec&quot;. It will prompt for a value for <code>BufferSize</code>. I used <code>2</code>.
There will be various things to fix up:</p>
<ul>
<li>To check <code>Write</code>, TLC first tries to get every possible <code>Seq(Byte)</code>, which is an infinite set.
I defined <code>MSG == Seq(Byte)</code> and changed <code>Write</code> to use <code>MSG</code>.
I then added an alternative definition for <code>MSG</code> in the model so that we only send messages of limited length.
In fact, my replacement <code>MSG</code> ensures that <code>Sent</code> will always just be an incrementing sequence (<code>&lt;&lt; 1, 2, 3, ... &gt;&gt;</code>).
That's enough to check <code>Properties</code>, and much quicker than checking every possible message.
</li>
<li>The system can keep sending forever. I added a state constraint to the model: <code>Len(Sent) &lt; 4</code>
This tells TLC to stop considering any execution once this becomes false.
</li>
</ul>
<p>With that, the model runs successfully.
This is a nice feature of TLA: instead of changing our specification to make it testable,
we keep the specification correct and just override some aspects of it in the model.
So, the specification says we can send any message, but the model only checks a few of them.</p>
<p>Now we can add <code>Integrity</code> as an invariant to check.
That passes, but it's good to double-check by changing the algorithm.
I changed <code>Read</code> so that it doesn't clear the buffer, using <code>Buffer' = Drop(Buffer, 0)</code>
(with <code>0</code> instead of <code>n</code>).
Then TLC reports a counter-example (&quot;Invariant Integrity is violated&quot;):</p>
<ol>
<li>The sender writes <code>&lt;&lt; 1, 2 &gt;&gt;</code> to <code>Buffer</code>.
</li>
<li>The reader reads one byte, to give <code>Got=1, Buffer=12, Sent=12</code>.
</li>
<li>The reader reads another byte, to give <code>Got=11, Buffer=12, Sent=12</code>.
</li>
</ol>
<p>Looks like it really was checking what we wanted.
It's good to be careful. If we'd accidentally added <code>Integrity</code> as a &quot;property&quot; to check rather than
as an &quot;invariant&quot; then it would have interpreted it as a temporal formula and reported success just because
it <em>is</em> true in the <em>initial</em> state.</p>
<p>One really nice feature of TLC is that (unlike a fuzz tester) it does a breadth-first search and therefore
finds minimal counter-examples for invariants.
The example above is therefore the quickest way to violate <code>Integrity</code>.</p>
<p>Checking <code>Availability</code> complains because of the use of <code>Nat</code> (we're asking it to check for every possible
length).
I replaced the <code>Nat</code> with <code>AvailabilityNat</code> and overrode that to be <code>0..4</code> in the model.
It then complains &quot;Temporal properties were violated&quot; and shows an example where the sender wrote
some data and the reader never read it.</p>
<p>The problem is, <code>[Next]_vars</code> always allows us to do nothing.
To fix this, we can specify a &quot;weak fairness&quot; constraint.
<code>WF_vars(action)</code>, says that we can't just stop forever with <code>action</code> being always possible but never happening.
I updated <code>Spec</code> to require the <code>Read</code> action to be fair:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="n">Spec</span> <span class="ni">==</span> <span class="n">Init</span> <span class="o">/\</span> <span class="p">[][</span><span class="n">Next</span><span class="p">]</span><span class="n">_vars</span> <span class="o">/\</span> <span class="n">WF_vars</span><span class="p">(</span><span class="n">Read</span><span class="p">)</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>Again, care is needed here.
If we had specified <code>WF_vars(Next)</code> then we would be forcing the sender to keep sending forever, which users of vchan are not required to do.
Worse, this would mean that every possible behaviour of the system would result in <code>Sent</code> growing forever.
Every behaviour would therefore hit our <code>Len(Sent) &lt; 4</code> constraint and
TLC wouldn't consider it further.
That means that TLC would <em>never</em> check any actual behaviour against <code>Availability</code>,
and its reports of success would be meaningless!
Changing <code>Read</code> to require <code>n \in 2..Len(Buffer)</code> is a quick way to see that TLC is actually checking <code>Availability</code>.</p>
<p>Here's the complete spec so far: <a href="https://roscidus.com/blog/images/tla/vchan1.pdf">vchan1.pdf</a> (<a href="https://github.com/talex5/spec-vchan/commit/75a846d5c83d86ba7be42b5c3b9f98635bcc544d">source</a>)</p>
<h2>The real vchan</h2>
<p>The simple <code>Spec</code> algorithm above has some limitations.
One obvious simplification is that <code>Buffer</code> is just the sequence of bytes in transit, whereas in the real system it is a ring buffer, made up of an array of bytes along with the producer and consumer counters.
We could replace it with three separate variables to make that explicit.
However, ring buffers in Xen are well understood and I don't feel that it would make the specification any clearer
to include that.</p>
<p>A more serious problem is that <code>Spec</code> assumes that there is a way to perform the <code>Read</code> and <code>Write</code> operations atomically.
Otherwise the real system would have behaviours not covered by the spec.
To implement the above <code>Spec</code> correctly, you'd need some kind of lock.
The real vchan protocol is more complicated than <code>Spec</code>, but avoids the need for a lock.</p>
<p>The real system has more shared state than just <code>Buffer</code>.
I added extra variables to the spec for each item of shared state in the C code, along with its initial value:</p>
<ul>
<li><code>SenderLive = TRUE</code> (sender sets to FALSE to close connection)
</li>
<li><code>ReceiverLive = TRUE</code> (receiver sets to FALSE to close connection)
</li>
<li><code>NotifyWrite = TRUE</code> (receiver wants to be notified of next write)
</li>
<li><code>DataReadyInt = FALSE</code> (sender has signalled receiver over event channel)
</li>
<li><code>NotifyRead = FALSE</code> (sender wants to be notified of next read)
</li>
<li><code>SpaceAvailableInt = FALSE</code> (receiver has notified sender over event channel)
</li>
</ul>
<p><code>DataReadyInt</code> represents the state of the receiver's event port.
The sender can make a Xen hypercall to set this and wake (or interrupt) the receiver.
I guess sending these events is somewhat slow,
because the <code>NotifyWrite</code> system is used to avoid sending events unnecessarily.
Likewise, <code>SpaceAvailableInt</code> is the sender's event port.</p>
<h3>The algorithm</h3>
<p>Here is my understanding of the protocol. On the sending side:</p>
<ol>
<li>The sending application asks to send some bytes.<br/>
We check whether the receiver has closed the channel and abort if so.
</li>
<li>We check the amount of buffer space available.
</li>
<li>If there isn't enough, we set <code>NotifyRead</code> so the receiver will notify us when there is more.<br/>
We also check the space again after this, in case it changed while setting the flag.
</li>
<li>If there is any space:
<ul>
<li>We write as much data as we can to the buffer.
</li>
<li>If the <code>NotifyWrite</code> flag is set, we clear it and notify the receiver of the write.
</li>
</ul>
</li>
<li>If we wrote everything, we return success.
</li>
<li>Otherwise, we wait to be notified of more space.
</li>
<li>We check whether the receiver has closed the channel.<br/>
If so we abort. Otherwise, we go back to step 2.
</li>
</ol>
<p>On the receiving side:</p>
<ol>
<li>The receiving application asks us to read up to some amount of data.
</li>
<li>We check the amount of data available in the buffer.
</li>
<li>If there isn't as much as requested, we set <code>NotifyWrite</code> so the sender will notify us when there is.<br/>
We also check the space again after this, in case it changed while setting the flag.
</li>
<li>If there is any data, we read up to the amount requested.<br/>
If the <code>NotifyRead</code> flag is set, we clear it and notify the sender of the new space.<br/>
We return success to the application (even if we didn't get as much as requested).
</li>
<li>Otherwise (if there was no data), we check whether the sender has closed the connection.
</li>
<li>If not (if the connection is still open), we wait to be notified of more data,
and then go back to step 2.
</li>
</ol>
<p>Either side can close the connection by clearing their &quot;live&quot; flag and signalling
the other side. I assumed there is also some process-local way that the close operation
can notify its own side if it's currently blocked.</p>
<p>To make expressing this kind of step-by-step algorithm easier,
TLA+ provides a programming-language-like syntax called PlusCal.
It then translates PlusCal into TLA actions.</p>
<p>Confusingly, there are two different syntaxes for PlusCal: Pascal style and C style.
This means that, when you search for examples on the web,
there is a 50% chance they won't work because they're using the other flavour.
I started with the Pascal one because that was the first example I found, but switched to C-style later because it was more compact.</p>
<p>Here is my attempt at describing the sender algorithm above in PlusCal:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
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
<span class="line-number">19</span>
<span class="line-number">20</span>
<span class="line-number">21</span>
<span class="line-number">22</span>
<span class="line-number">23</span>
<span class="line-number">24</span>
<span class="line-number">25</span>
<span class="line-number">26</span>
<span class="line-number">27</span>
<span class="line-number">28</span>
<span class="line-number">29</span>
<span class="line-number">30</span>
<span class="line-number">31</span>
<span class="line-number">32</span>
<span class="line-number">33</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line">  <span class="n">fair</span> <span class="n">process</span> <span class="p">(</span><span class="n">SenderWrite</span> <span class="ni">=</span> <span class="n">SenderWriteID</span><span class="p">)</span>
</span><span class="line">  <span class="n">variables</span> <span class="n">free</span> <span class="ni">=</span> <span class="m">0</span><span class="p">,</span>     <span class="c">\* Our idea of how much free space is available.</span>
</span><span class="line">            <span class="n">msg</span> <span class="ni">=</span> <span class="ni">&lt;&lt;</span> <span class="ni">&gt;&gt;</span><span class="p">,</span>  <span class="c">\* The data we haven't sent yet.</span>
</span><span class="line">            <span class="n">Sent</span> <span class="ni">=</span> <span class="ni">&lt;&lt;</span> <span class="ni">&gt;&gt;</span><span class="p">;</span> <span class="c">\* Everything we were asked to send.</span>
</span><span class="line">  <span class="ni">{</span>
</span><span class="line"><span class="n">sender_ready</span><span class="p">:</span><span class="o">-</span>        <span class="n">while</span> <span class="p">(</span><span class="bp">TRUE</span><span class="p">)</span> <span class="ni">{</span>
</span><span class="line">                        <span class="n">if</span> <span class="p">(</span><span class="o">~</span><span class="n">SenderLive</span> <span class="o">\/</span> <span class="o">~</span><span class="n">ReceiverLive</span><span class="p">)</span> <span class="n">goto</span> <span class="n">Done</span>
</span><span class="line">                        <span class="n">else</span> <span class="ni">{</span>
</span><span class="line">                          <span class="n">with</span> <span class="p">(</span><span class="n">m</span> <span class="s">\in</span> <span class="n">MSG</span><span class="p">)</span> <span class="ni">{</span> <span class="n">msg</span> <span class="o">:=</span> <span class="n">m</span> <span class="ni">}</span><span class="p">;</span>
</span><span class="line">                          <span class="n">Sent</span> <span class="o">:=</span> <span class="n">Sent</span> <span class="nb">\o</span> <span class="n">msg</span><span class="p">;</span>    <span class="c">\* Remember we wanted to send this</span>
</span><span class="line">                        <span class="ni">}</span><span class="p">;</span>
</span><span class="line"><span class="n">sender_write</span><span class="p">:</span>           <span class="n">while</span> <span class="p">(</span><span class="bp">TRUE</span><span class="p">)</span> <span class="ni">{</span>
</span><span class="line">                          <span class="n">free</span> <span class="o">:=</span> <span class="n">BufferSize</span> <span class="o">-</span> <span class="n">Len</span><span class="p">(</span><span class="n">Buffer</span><span class="p">);</span>
</span><span class="line"><span class="n">sender_request_notify</span><span class="p">:</span>    <span class="n">if</span> <span class="p">(</span><span class="n">free</span> <span class="o">&gt;=</span> <span class="n">Len</span><span class="p">(</span><span class="n">msg</span><span class="p">))</span> <span class="n">goto</span> <span class="n">sender_write_data</span>
</span><span class="line">                          <span class="n">else</span> <span class="n">NotifyRead</span> <span class="o">:=</span> <span class="bp">TRUE</span><span class="p">;</span>
</span><span class="line"><span class="n">sender_recheck_len</span><span class="p">:</span>       <span class="n">free</span> <span class="o">:=</span> <span class="n">BufferSize</span> <span class="o">-</span> <span class="n">Len</span><span class="p">(</span><span class="n">Buffer</span><span class="p">);</span>
</span><span class="line"><span class="n">sender_write_data</span><span class="p">:</span>        <span class="n">if</span> <span class="p">(</span><span class="n">free</span> <span class="ni">&gt;</span> <span class="m">0</span><span class="p">)</span> <span class="ni">{</span>
</span><span class="line">                            <span class="n">Buffer</span> <span class="o">:=</span> <span class="n">Buffer</span> <span class="nb">\o</span> <span class="n">Take</span><span class="p">(</span><span class="n">msg</span><span class="p">,</span> <span class="n">Min</span><span class="p">(</span><span class="n">Len</span><span class="p">(</span><span class="n">msg</span><span class="p">),</span> <span class="n">free</span><span class="p">));</span>
</span><span class="line">                            <span class="n">msg</span> <span class="o">:=</span> <span class="n">Drop</span><span class="p">(</span><span class="n">msg</span><span class="p">,</span> <span class="n">Min</span><span class="p">(</span><span class="n">Len</span><span class="p">(</span><span class="n">msg</span><span class="p">),</span> <span class="n">free</span><span class="p">));</span>
</span><span class="line">                            <span class="n">free</span> <span class="o">:=</span> <span class="m">0</span><span class="p">;</span>
</span><span class="line"><span class="n">sender_check_notify_data</span><span class="p">:</span>   <span class="n">if</span> <span class="p">(</span><span class="n">NotifyWrite</span><span class="p">)</span> <span class="ni">{</span>
</span><span class="line">                              <span class="n">NotifyWrite</span> <span class="o">:=</span> <span class="bp">FALSE</span><span class="p">;</span>   <span class="c">\* Atomic test-and-clear</span>
</span><span class="line"><span class="n">sender_notify_data</span><span class="p">:</span>           <span class="n">DataReadyInt</span> <span class="o">:=</span> <span class="bp">TRUE</span><span class="p">;</span>   <span class="c">\* Signal receiver</span>
</span><span class="line">                              <span class="n">if</span> <span class="p">(</span><span class="n">msg</span> <span class="ni">=</span> <span class="ni">&lt;&lt;</span> <span class="ni">&gt;&gt;</span><span class="p">)</span> <span class="n">goto</span> <span class="n">sender_ready</span>
</span><span class="line">                            <span class="ni">}</span> <span class="n">else</span> <span class="n">if</span> <span class="p">(</span><span class="n">msg</span> <span class="ni">=</span> <span class="ni">&lt;&lt;</span> <span class="ni">&gt;&gt;</span><span class="p">)</span> <span class="n">goto</span> <span class="n">sender_ready</span>
</span><span class="line">                          <span class="ni">}</span><span class="p">;</span>
</span><span class="line"><span class="n">sender_blocked</span><span class="p">:</span>           <span class="n">await</span> <span class="n">SpaceAvailableInt</span> <span class="o">\/</span> <span class="o">~</span><span class="n">SenderLive</span><span class="p">;</span>
</span><span class="line">                          <span class="n">if</span> <span class="p">(</span><span class="o">~</span><span class="n">SenderLive</span><span class="p">)</span> <span class="n">goto</span> <span class="n">Done</span><span class="p">;</span>
</span><span class="line">                          <span class="n">else</span> <span class="n">SpaceAvailableInt</span> <span class="o">:=</span> <span class="bp">FALSE</span><span class="p">;</span>
</span><span class="line"><span class="n">sender_check_recv_live</span><span class="p">:</span>   <span class="n">if</span> <span class="p">(</span><span class="o">~</span><span class="n">ReceiverLive</span><span class="p">)</span> <span class="n">goto</span> <span class="n">Done</span><span class="p">;</span>
</span><span class="line">                        <span class="ni">}</span>
</span><span class="line">                      <span class="ni">}</span>
</span><span class="line">  <span class="ni">}</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>The labels (e.g. <code>sender_request_notify:</code>) represent points in the program where other actions can happen.
Everything between two labels is considered to be atomic.
I <a href="https://github.com/talex5/spec-vchan/blob/d6e1c803820c952c53314da47270812e2fe88e79/vchan.tla#L654-L692">checked</a> that every block of code between labels accesses only one shared variable.
This means that the real system can't see any states that we don't consider.
The toolbox doesn't provide any help with this; you just have to check manually.</p>
<p>The <code>sender_ready</code> label represents a state where the client application hasn't yet decided to send any data.
Its label is tagged with <code>-</code> to indicate that fairness doesn't apply here, because the protocol doesn't
require applications to keep sending more data forever.
The other steps are fair, because once we've decided to send something we should keep going.</p>
<p>Taking a step from <code>sender_ready</code> to <code>sender_write</code> corresponds to the vchan library's write function
being called with some argument <code>m</code>.
The <code>with (m \in MSG)</code> says that <code>m</code> could be any message from the set <code>MSG</code>.
TLA also contains a <code>CHOOSE</code> operator that looks like it might do the same thing, but it doesn't.
When you use <code>with</code>, you are saying that TLC should check <em>all</em> possible messages.
When you use <code>CHOOSE</code>, you are saying that it doesn't matter which message TLC tries (and it will always try the
same one).
Or, in terms of the specification, a <code>CHOOSE</code> would say that applications can only ever send one particular message, without telling you what that message is.</p>
<p>In <code>sender_write_data</code>, we set <code>free := 0</code> for no obvious reason.
This is just to reduce the number of states that the model checker needs to explore,
since we don't care about its value after this point.</p>
<p>Some of the code is a little awkward because I had to put things in <code>else</code> branches that would more naturally go after the whole <code>if</code> block, but the translator wouldn't let me do that.
The use of semi-colons is also a bit confusing: the PlusCal-to-TLA translator requires them after a closing brace in some places, but the PDF generator messes up the indentation if you include them.</p>
<p>Here's how the code block starting at <code>sender_request_notify</code> gets translated into a TLA action:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
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
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="n">sender_request_notify</span> <span class="ni">==</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">pc</span><span class="p">[</span><span class="n">SenderWriteID</span><span class="p">]</span> <span class="ni">=</span> <span class="s">&quot;sender_request_notify&quot;</span>
</span><span class="line">  <span class="o">/\</span> <span class="k k-Conditional">IF</span> <span class="n">free</span> <span class="o">&gt;=</span> <span class="n">Len</span><span class="p">(</span><span class="n">msg</span><span class="p">)</span>
</span><span class="line">        <span class="k k-Conditional">THEN</span> <span class="o">/\</span> <span class="n">pc</span><span class="err">'</span> <span class="ni">=</span> <span class="p">[</span><span class="n">pc</span> <span class="n">EXCEPT</span> <span class="err">!</span><span class="p">[</span><span class="n">SenderWriteID</span><span class="p">]</span> <span class="ni">=</span> <span class="s">&quot;sender_write_data&quot;</span><span class="p">]</span>
</span><span class="line">             <span class="o">/\</span> <span class="n">UNCHANGED</span> <span class="n">NotifyRead</span>
</span><span class="line">        <span class="k k-Conditional">ELSE</span> <span class="o">/\</span> <span class="n">NotifyRead</span><span class="err">'</span> <span class="ni">=</span> <span class="bp">TRUE</span>
</span><span class="line">             <span class="o">/\</span> <span class="n">pc</span><span class="err">'</span> <span class="ni">=</span> <span class="p">[</span><span class="n">pc</span> <span class="n">EXCEPT</span> <span class="err">!</span><span class="p">[</span><span class="n">SenderWriteID</span><span class="p">]</span> <span class="ni">=</span> <span class="s">&quot;sender_recheck_len&quot;</span><span class="p">]</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">UNCHANGED</span> <span class="ni">&lt;&lt;</span> <span class="n">SenderLive</span><span class="p">,</span> <span class="n">ReceiverLive</span><span class="p">,</span> <span class="n">Buffer</span><span class="p">,</span> 
</span><span class="line">                  <span class="n">NotifyWrite</span><span class="p">,</span> <span class="n">DataReadyInt</span><span class="p">,</span> 
</span><span class="line">                  <span class="n">SpaceAvailableInt</span><span class="p">,</span> <span class="n">free</span><span class="p">,</span> <span class="n">msg</span><span class="p">,</span> <span class="n">Sent</span><span class="p">,</span> 
</span><span class="line">                  <span class="n">have</span><span class="p">,</span> <span class="n">want</span><span class="p">,</span> <span class="n">Got</span> <span class="ni">&gt;&gt;</span>
</span></code></pre></td></tr></tbody></table></div></figure><p><code>pc</code> is a mapping from process ID to the label where that process is currently executing.
So <code>sender_request_notify</code> can only be performed when the SenderWriteID process is
at the <code>sender_request_notify</code> label.
Afterwards <code>pc[SenderWriteID]</code> will either be at <code>sender_write_data</code> or <code>sender_recheck_len</code>
(if there wasn't enough space for the whole message).</p>
<p>Here's the code for the receiver:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
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
<span class="line-number">19</span>
<span class="line-number">20</span>
<span class="line-number">21</span>
<span class="line-number">22</span>
<span class="line-number">23</span>
<span class="line-number">24</span>
<span class="line-number">25</span>
<span class="line-number">26</span>
<span class="line-number">27</span>
<span class="line-number">28</span>
<span class="line-number">29</span>
<span class="line-number">30</span>
<span class="line-number">31</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line">  <span class="n">fair</span> <span class="n">process</span> <span class="p">(</span><span class="n">ReceiverRead</span> <span class="ni">=</span> <span class="n">ReceiverReadID</span><span class="p">)</span>
</span><span class="line">  <span class="n">variables</span> <span class="n">have</span> <span class="ni">=</span> <span class="m">0</span><span class="p">,</span>     <span class="c">\* The amount of data we think the buffer contains.</span>
</span><span class="line">            <span class="n">want</span> <span class="ni">=</span> <span class="m">0</span><span class="p">,</span>     <span class="c">\* The amount of data the user wants us to read.</span>
</span><span class="line">            <span class="n">Got</span> <span class="ni">=</span> <span class="ni">&lt;&lt;</span> <span class="ni">&gt;&gt;</span><span class="p">;</span>  <span class="c">\* Pseudo-variable recording all data ever received by receiver.</span>
</span><span class="line">  <span class="ni">{</span>
</span><span class="line"><span class="n">recv_ready</span><span class="p">:</span>         <span class="n">while</span> <span class="p">(</span><span class="n">ReceiverLive</span><span class="p">)</span> <span class="ni">{</span>
</span><span class="line">                      <span class="n">with</span> <span class="p">(</span><span class="n">n</span> <span class="s">\in</span> <span class="m">1</span><span class="o">..</span><span class="n">MaxReadLen</span><span class="p">)</span> <span class="n">want</span> <span class="o">:=</span> <span class="n">n</span><span class="p">;</span>
</span><span class="line"><span class="n">recv_reading</span><span class="p">:</span>         <span class="n">while</span> <span class="p">(</span><span class="bp">TRUE</span><span class="p">)</span> <span class="ni">{</span>
</span><span class="line">                        <span class="n">have</span> <span class="o">:=</span> <span class="n">Len</span><span class="p">(</span><span class="n">Buffer</span><span class="p">);</span>
</span><span class="line"><span class="n">recv_got_len</span><span class="p">:</span>           <span class="n">if</span> <span class="p">(</span><span class="n">have</span> <span class="o">&gt;=</span> <span class="n">want</span><span class="p">)</span> <span class="n">goto</span> <span class="n">recv_read_data</span>
</span><span class="line">                        <span class="n">else</span> <span class="n">NotifyWrite</span> <span class="o">:=</span> <span class="bp">TRUE</span><span class="p">;</span>
</span><span class="line"><span class="n">recv_recheck_len</span><span class="p">:</span>       <span class="n">have</span> <span class="o">:=</span> <span class="n">Len</span><span class="p">(</span><span class="n">Buffer</span><span class="p">);</span>
</span><span class="line"><span class="n">recv_read_data</span><span class="p">:</span>         <span class="n">if</span> <span class="p">(</span><span class="n">have</span> <span class="ni">&gt;</span> <span class="m">0</span><span class="p">)</span> <span class="ni">{</span>
</span><span class="line">                          <span class="n">Got</span> <span class="o">:=</span> <span class="n">Got</span> <span class="nb">\o</span> <span class="n">Take</span><span class="p">(</span><span class="n">Buffer</span><span class="p">,</span> <span class="n">Min</span><span class="p">(</span><span class="n">want</span><span class="p">,</span> <span class="n">have</span><span class="p">));</span>
</span><span class="line">                          <span class="n">Buffer</span> <span class="o">:=</span> <span class="n">Drop</span><span class="p">(</span><span class="n">Buffer</span><span class="p">,</span> <span class="n">Min</span><span class="p">(</span><span class="n">want</span><span class="p">,</span> <span class="n">have</span><span class="p">));</span>
</span><span class="line">                          <span class="n">want</span> <span class="o">:=</span> <span class="m">0</span><span class="p">;</span>
</span><span class="line">                          <span class="n">have</span> <span class="o">:=</span> <span class="m">0</span><span class="p">;</span>
</span><span class="line"><span class="n">recv_check_notify_read</span><span class="p">:</span>   <span class="n">if</span> <span class="p">(</span><span class="n">NotifyRead</span><span class="p">)</span> <span class="ni">{</span>
</span><span class="line">                            <span class="n">NotifyRead</span> <span class="o">:=</span> <span class="bp">FALSE</span><span class="p">;</span>      <span class="c">\* (atomic test-and-clear)</span>
</span><span class="line"><span class="n">recv_notify_read</span><span class="p">:</span>           <span class="n">SpaceAvailableInt</span> <span class="o">:=</span> <span class="bp">TRUE</span><span class="p">;</span>
</span><span class="line">                            <span class="n">goto</span> <span class="n">recv_ready</span><span class="p">;</span>          <span class="c">\* Return success</span>
</span><span class="line">                          <span class="ni">}</span> <span class="n">else</span> <span class="n">goto</span> <span class="n">recv_ready</span><span class="p">;</span>     <span class="c">\* Return success</span>
</span><span class="line">                        <span class="ni">}</span> <span class="n">else</span> <span class="n">if</span> <span class="p">(</span><span class="o">~</span><span class="n">SenderLive</span> <span class="o">\/</span> <span class="o">~</span><span class="n">ReceiverLive</span><span class="p">)</span> <span class="ni">{</span>
</span><span class="line">                          <span class="n">goto</span> <span class="n">Done</span><span class="p">;</span>
</span><span class="line">                        <span class="ni">}</span><span class="p">;</span>
</span><span class="line"><span class="n">recv_await_data</span><span class="p">:</span>        <span class="n">await</span> <span class="n">DataReadyInt</span> <span class="o">\/</span> <span class="o">~</span><span class="n">ReceiverLive</span><span class="p">;</span>
</span><span class="line">                        <span class="n">if</span> <span class="p">(</span><span class="o">~</span><span class="n">ReceiverLive</span><span class="p">)</span> <span class="ni">{</span> <span class="n">want</span> <span class="o">:=</span> <span class="m">0</span><span class="p">;</span> <span class="n">goto</span> <span class="n">Done</span> <span class="ni">}</span>
</span><span class="line">                        <span class="n">else</span> <span class="n">DataReadyInt</span> <span class="o">:=</span> <span class="bp">FALSE</span><span class="p">;</span>
</span><span class="line">                      <span class="ni">}</span>
</span><span class="line">                    <span class="ni">}</span>
</span><span class="line">  <span class="ni">}</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>It's quite similar to before.
<code>recv_ready</code> corresponds to a state where the application hasn't yet called <code>read</code>.
When it does, we take <code>n</code> (the maximum number of bytes to read) as an argument and
store it in the local variable <code>want</code>.</p>
<p>Note: you can use the C library in blocking or non-blocking mode.
In blocking mode, a <code>write</code> (or <code>read</code>) waits until data is sent (or received).
In non-blocking mode, it returns a special code to the application indicating that it needs to wait.
The application then does the waiting itself and then calls the library again.
I think the specification above covers both cases, depending on whether you think of
<code>sender_blocked</code> and <code>recv_await_data</code> as representing code inside or outside of the library.</p>
<p>We also need a way to close the channel.
It wasn't clear to me, from looking at the C headers, when exactly you're allowed to do that.
I <em>think</em> that if you had a multi-threaded program and you called the close function while the write
function was blocked, it would unblock and return.
But if you happened to call it at the wrong time, it would try to use a closed file descriptor and fail
(or read from the wrong one).
So I guess it's single threaded, and you should use the non-blocking mode if you want to cancel things.</p>
<p>That means that the sender can close only when it is at <code>sender_ready</code> or <code>sender_blocked</code>,
and similarly for the receiver.
The situation with the OCaml code is the same, because it is cooperatively threaded and so the close
operation can only be called while blocked or idle.
However, I decided to make the specification more general and allow for closing at any point
by modelling closing as separate processes:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
<span class="line-number">6</span>
<span class="line-number">7</span>
<span class="line-number">8</span>
<span class="line-number">9</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line">  <span class="n">fair</span> <span class="n">process</span> <span class="p">(</span><span class="n">SenderClose</span> <span class="ni">=</span> <span class="n">SenderCloseID</span><span class="p">)</span> <span class="ni">{</span>
</span><span class="line">    <span class="n">sender_open</span><span class="p">:</span><span class="o">-</span>         <span class="n">SenderLive</span> <span class="o">:=</span> <span class="bp">FALSE</span><span class="p">;</span>  <span class="c">\* Clear liveness flag</span>
</span><span class="line">    <span class="n">sender_notify_closed</span><span class="p">:</span> <span class="n">DataReadyInt</span> <span class="o">:=</span> <span class="bp">TRUE</span><span class="p">;</span> <span class="c">\* Signal receiver</span>
</span><span class="line">  <span class="ni">}</span>
</span><span class="line">
</span><span class="line">  <span class="n">fair</span> <span class="n">process</span> <span class="p">(</span><span class="n">ReceiverClose</span> <span class="ni">=</span> <span class="n">ReceiverCloseID</span><span class="p">)</span> <span class="ni">{</span>
</span><span class="line">    <span class="n">recv_open</span><span class="p">:</span><span class="o">-</span>         <span class="n">ReceiverLive</span> <span class="o">:=</span> <span class="bp">FALSE</span><span class="p">;</span>      <span class="c">\* Clear liveness flag</span>
</span><span class="line">    <span class="n">recv_notify_closed</span><span class="p">:</span> <span class="n">SpaceAvailableInt</span> <span class="o">:=</span> <span class="bp">TRUE</span><span class="p">;</span>  <span class="c">\* Signal sender</span>
</span><span class="line">  <span class="ni">}</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>Again, the processes are &quot;fair&quot; because once we start closing we should finish,
but the initial labels are tagged with &quot;-&quot; to disable fairness there: it's OK if
you keep a vchan open forever.</p>
<p>There's a slight naming problem here.
The PlusCal translator names the actions it generates after the <em>starting</em> state of the action.
So <em>sender_open</em> is the action that moves <em>from</em> the <em>sender_open</em> label.
That is, the <em>sender_open</em> action actually closes the connection!</p>
<p>Finally, we share the event channel with the buffer going in the other direction, so we might
get notifications that are nothing to do with us.
To ensure we handle that, I added another process that can send events at any time:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
<span class="line-number">6</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line">  <span class="n">process</span> <span class="p">(</span><span class="n">SpuriousInterrupts</span> <span class="ni">=</span> <span class="n">SpuriousID</span><span class="p">)</span> <span class="ni">{</span>
</span><span class="line">    <span class="n">spurious</span><span class="p">:</span> <span class="n">while</span> <span class="p">(</span><span class="bp">TRUE</span><span class="p">)</span> <span class="ni">{</span>
</span><span class="line">                <span class="n">either</span> <span class="n">SpaceAvailableInt</span> <span class="o">:=</span> <span class="bp">TRUE</span>
</span><span class="line">                <span class="n">or</span>     <span class="n">DataReadyInt</span> <span class="o">:=</span> <span class="bp">TRUE</span>
</span><span class="line">              <span class="ni">}</span>
</span><span class="line">  <span class="ni">}</span>
</span></code></pre></td></tr></tbody></table></div></figure><p><code>either/or</code> says that we need to consider both possibilities.
This process isn't marked fair, because we can't rely these interrupts coming.
But we do have to handle them when they happen.</p>
<h3>Testing the full spec</h3>
<p>PlusCal code is written in a specially-formatted comment block, and you have to press Ctrl-T to
generate (or update) then TLA translation before running the model checker.</p>
<p>Be aware that the TLA Toolbox is a bit unreliable about keyboard short-cuts.
While typing into the editor always works, short-cuts such as Ctrl-S (save) sometimes get disconnected.
So you think you're doing &quot;edit/save/translate/save/check&quot; cycles, but really you're just checking some old version over and over again.
You can avoid this by always running the model checker with the keyboard shortcut too, since that always seems to fail at the same time as the others.
Focussing a different part of the GUI and then clicking back in the editor again fixes everything for a while.</p>
<p>Anyway, running our model on the new spec shows that <code>Integrity</code> is still OK.
However, the <code>Availability</code> check fails with the following counter-example:</p>
<ol>
<li>The sender writes <code>&lt;&lt; 1 &gt;&gt;</code> to <code>Buffer</code>.
</li>
<li>The sender closes the connection.
</li>
<li>The receiver closes the connection.
</li>
<li>All processes come to a stop, but the data never arrived.
</li>
</ol>
<p>We need to update <code>Availability</code> to consider the effects of closing connections.
And at this point, I'm very unsure what vchan is intended to do.
We could say:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="n">Availability</span> <span class="ni">==</span>
</span><span class="line">  <span class="s">\A</span> <span class="n">x</span> <span class="s">\in</span> <span class="n">AvailabilityNat</span> <span class="p">:</span>
</span><span class="line">    <span class="n">Len</span><span class="p">(</span><span class="n">Sent</span><span class="p">)</span> <span class="ni">=</span> <span class="n">x</span> <span class="o">~</span><span class="ni">&gt;</span> <span class="o">\/</span> <span class="n">Len</span><span class="p">(</span><span class="n">Got</span><span class="p">)</span> <span class="o">&gt;=</span> <span class="n">x</span>
</span><span class="line">                     <span class="o">\/</span> <span class="o">~</span><span class="n">ReceiverLive</span>
</span><span class="line">                     <span class="o">\/</span> <span class="o">~</span><span class="n">SenderLive</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>That passes.
But vchan describes itself as being like a Unix socket.
If you write to a Unix socket and then close it, you still expect the data to be delivered.
So actually I tried this:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="n">Availability</span> <span class="ni">==</span>
</span><span class="line">  <span class="s">\A</span> <span class="n">x</span> <span class="s">\in</span> <span class="n">AvailabilityNat</span> <span class="p">:</span>
</span><span class="line">    <span class="n">x</span> <span class="ni">=</span> <span class="n">Len</span><span class="p">(</span><span class="n">Sent</span><span class="p">)</span> <span class="o">/\</span> <span class="n">SenderLive</span> <span class="o">/\</span> <span class="n">pc</span><span class="p">[</span><span class="n">SenderWriteID</span><span class="p">]</span> <span class="ni">=</span> <span class="s">&quot;sender_ready&quot;</span> <span class="o">~</span><span class="ni">&gt;</span>
</span><span class="line">         <span class="o">\/</span> <span class="n">Len</span><span class="p">(</span><span class="n">Got</span><span class="p">)</span> <span class="o">&gt;=</span> <span class="n">x</span>
</span><span class="line">         <span class="o">\/</span> <span class="o">~</span><span class="n">ReceiverLive</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>This says that if a sender write operation completes successfully (we're back at <code>sender_ready</code>)
and at that point the sender hasn't closed the connection, then the receiver will eventually receive
the data (or close its end).</p>
<p>That is how I would expect it to behave.
But TLC reports that the new spec does <em>not</em> satisfy this, giving this example (simplified - there are 16 steps in total):</p>
<ol>
<li>The receiver starts reading. It finds that the buffer is empty.
</li>
<li>The sender writes some data to <code>Buffer</code> and returns to <code>sender_ready</code>.
</li>
<li>The sender closes the channel.
</li>
<li>The receiver sees that the connection is closed and stops.
</li>
</ol>
<p>Is this a bug? Without a specification, it's impossible to say.
Maybe vchan was never intended to ensure delivery once the sender has closed its end.
But this case only happens if you're very unlucky about the scheduling.
If the receiving application calls <code>read</code> when the sender has closed the connection but there is data
available then the C code <em>does</em> return the data in that case.
It's only if the sender happens to close the connection just after the receiver has checked the buffer and just before it checks the close flag that this happens.</p>
<p>It's also easy to fix.
I changed the code in the receiver to do a final check on the buffer before giving up:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line">                        <span class="ni">}</span> <span class="n">else</span> <span class="n">if</span> <span class="p">(</span><span class="o">~</span><span class="n">SenderLive</span> <span class="o">\/</span> <span class="o">~</span><span class="n">ReceiverLive</span><span class="p">)</span> <span class="ni">{</span>
</span><span class="line"><span class="n">recv_final_check</span><span class="p">:</span>         <span class="n">if</span> <span class="p">(</span><span class="n">Len</span><span class="p">(</span><span class="n">Buffer</span><span class="p">)</span> <span class="ni">=</span> <span class="m">0</span><span class="p">)</span> <span class="ni">{</span> <span class="n">want</span> <span class="o">:=</span> <span class="m">0</span><span class="p">;</span> <span class="n">goto</span> <span class="n">Done</span> <span class="ni">}</span>
</span><span class="line">                          <span class="n">else</span> <span class="n">goto</span> <span class="n">recv_reading</span><span class="p">;</span>
</span><span class="line">                        <span class="ni">}</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>With that change, we can be sure that data sent while the connection is open will always be delivered
(provided only that the receiver doesn't close the connection itself).
If you spotted this issue yourself while you were reviewing the code earlier, then well done!</p>
<p>Note that when TLC finds a problem with a temporal property (such as <code>Availability</code>),
it does not necessarily find the shortest example first.
I changed the limit on <code>Sent</code> to <code>Len(Sent) &lt; 2</code> and added an action constraint of <code>~SpuriousInterrupts</code>
to get a simpler example, with only 1 byte being sent and no spurious interrupts.</p>
<h3>Some odd things</h3>
<p>I noticed a couple of other odd things, which I thought I'd mention.</p>
<p>First, <code>NotifyWrite</code> is initialised to <code>TRUE</code>, which seemed unnecessary.
We can initialise it to <code>FALSE</code> instead and everything still works.
We can even initialise it with <code>NotifyWrite \in {TRUE, FALSE}</code> to allow either behaviour,
and thus test that old programs that followed the original version of the spec still work
with either behaviour.</p>
<p>That's a nice advantage of using a specification language.
Saying &quot;the code is the spec&quot; becomes less useful as you build up more and more versions of the code!</p>
<p>However, because there was no spec before, we can't be sure that existing programs do follow it.
And, in fact, I found that QubesDB uses the vchan library in a different and unexpected way.
Instead of calling read, and then waiting if libvchan says to, QubesDB blocks first in all cases, and
then calls the read function once it gets an event.</p>
<p>We can document that by adding an extra step at the start of ReceiverRead:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="n">recv_init</span><span class="p">:</span>          <span class="n">either</span> <span class="n">goto</span> <span class="n">recv_ready</span>        <span class="c">\* (recommended)</span>
</span><span class="line">                    <span class="n">or</span> <span class="ni">{</span>    <span class="c">\* (QubesDB does this)</span>
</span><span class="line">                      <span class="n">with</span> <span class="p">(</span><span class="n">n</span> <span class="s">\in</span> <span class="m">1</span><span class="o">..</span><span class="n">MaxReadLen</span><span class="p">)</span> <span class="n">want</span> <span class="o">:=</span> <span class="n">n</span><span class="p">;</span>
</span><span class="line">                      <span class="n">goto</span> <span class="n">recv_await_data</span><span class="p">;</span>
</span><span class="line">                    <span class="ni">}</span><span class="p">;</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>Then TLC shows that <code>NotifyWrite</code> cannot start as <code>FALSE</code>.</p>
<p>The second odd thing is that the receiver sets <code>NotifyRead</code> whenever there isn't enough data available
to fill the application's buffer completely.
But usually when you do a read operation you just provide a buffer large enough for the largest likely message.
It would probably make more sense to set <code>NotifyWrite</code> only when the buffer is completely empty.
After checking the current version of the algorithm, I changed the specification to allow either behaviour.</p>
<h3>Why does vchan work?</h3>
<p>At this point, we have specified what vchan should do and how it does it.
We have also checked that it does do this, at least for messages up to 3 bytes long with a buffer size of 2.
That doesn't sound like much, but we still checked 79,288 distinct states, with behaviours up to 38 steps long.
This would be a perfectly reasonable place to declare the specification (and blog post) finished.</p>
<p>However, TLA has some other interesting abilities.
In particular, it provides a very interesting technique to help discover <em>why</em> the algorithm works.</p>
<p>We'll start with <code>Integrity</code>.
We would like to argue as follows:</p>
<ol>
<li><code>Integrity</code> is true in any initial state (i.e. <code>Init =&gt; Integrity</code>).
</li>
<li>Any <code>Next</code> step preserves <code>Integrity</code> (i.e. <code>Integrity /\ Next =&gt; Integrity'</code>).
</li>
</ol>
<p>Then it would just be a matter looking at each possible action that makes up <code>Next</code> and
checking that each one individually preserves <code>Integrity</code>.
However, we can't do this with <code>Integrity</code> because (2) isn't true.
For example, the state <code>{ Got: &quot;&quot;, Buffer: &quot;21&quot;, Sent: &quot;12&quot; }</code> satisfies <code>Integrity</code>,
but if we take a read step then the new state won't.
Instead, we have to argue &quot;If we take a <code>Next</code> step in any reachable state then <code>Integrity'</code>&quot;,
but that's very difficult because how do we know whether a state is reachable without searching them all?</p>
<p>So the idea is to make a stronger version of <code>Integrity</code>, called <code>IntegrityI</code>, which does what we want.
<code>IntegrityI</code> is called an <em>inductive invariant</em>.
The first step is fairly obvious - I began with:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="n">IntegrityI</span> <span class="ni">==</span>
</span><span class="line">  <span class="n">Sent</span> <span class="ni">=</span> <span class="n">Got</span> <span class="nb">\o</span> <span class="n">Buffer</span> <span class="nb">\o</span> <span class="n">msg</span>
</span></code></pre></td></tr></tbody></table></div></figure><p><code>Integrity</code> just said that <code>Got</code> is a prefix of <code>Sent</code>.
This says specifically that the rest is <code>Buffer \o msg</code> - the data currently being transmitted and the data yet to be transmitted.</p>
<p>We can ask TLC to check <code>Init /\ [][Next]_vars =&gt; []IntegrityI</code> to check that it is an invariant, as before.
It does that by finding all the <code>Init</code> states and then taking <code>Next</code> steps to find all reachable states.
But we can also ask it to check <code>IntegrityI /\ [][Next]_vars =&gt; []IntegrityI</code>.
That is, the same thing but starting from any state matching <code>IntegrityI</code> instead of <code>Init</code>.</p>
<p>I created a new model (<code>IntegrityI</code>) to do that.
It reports a few technical problems at the start because it doesn't know the types of anything.
For example, it can't choose initial values for <code>SenderLive</code> without knowing that <code>SenderLive</code> is a boolean.
I added a <code>TypeOK</code> state expression that gives the expected type of every variable:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
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
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="n">MESSAGE</span> <span class="ni">==</span> <span class="n">Seq</span><span class="p">(</span><span class="n">Byte</span><span class="p">)</span>
</span><span class="line"><span class="n">FINITE_MESSAGE</span><span class="p">(</span><span class="n">L</span><span class="p">)</span> <span class="ni">==</span> <span class="n">UNION</span> <span class="p">(</span> <span class="ni">{</span> <span class="p">[</span> <span class="m">1</span><span class="o">..</span><span class="n">N</span> <span class="o">-&gt;</span> <span class="n">Byte</span> <span class="p">]</span> <span class="p">:</span> <span class="n">N</span> <span class="s">\in</span> <span class="m">0</span><span class="o">..</span><span class="n">L</span> <span class="ni">}</span> <span class="p">)</span>
</span><span class="line">
</span><span class="line"><span class="n">TypeOK</span> <span class="ni">==</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">Sent</span> <span class="s">\in</span> <span class="n">MESSAGE</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">Got</span> <span class="s">\in</span> <span class="n">MESSAGE</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">Buffer</span> <span class="s">\in</span> <span class="n">FINITE_MESSAGE</span><span class="p">(</span><span class="n">BufferSize</span><span class="p">)</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">SenderLive</span> <span class="s">\in</span> <span class="bp">BOOLEAN</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">ReceiverLive</span> <span class="s">\in</span> <span class="bp">BOOLEAN</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">NotifyWrite</span> <span class="s">\in</span> <span class="bp">BOOLEAN</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">DataReadyInt</span> <span class="s">\in</span> <span class="bp">BOOLEAN</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">NotifyRead</span> <span class="s">\in</span> <span class="bp">BOOLEAN</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">SpaceAvailableInt</span> <span class="s">\in</span> <span class="bp">BOOLEAN</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">free</span> <span class="s">\in</span> <span class="m">0</span><span class="o">..</span><span class="n">BufferSize</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">msg</span> <span class="s">\in</span> <span class="n">FINITE_MESSAGE</span><span class="p">(</span><span class="n">MaxWriteLen</span><span class="p">)</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">want</span> <span class="s">\in</span> <span class="m">0</span><span class="o">..</span><span class="n">MaxReadLen</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">have</span> <span class="s">\in</span> <span class="m">0</span><span class="o">..</span><span class="n">BufferSize</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>We also need to tell it all the possible states of <code>pc</code> (which says which label each process it at):</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
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
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="n">PCOK</span> <span class="ni">==</span> <span class="n">pc</span> <span class="s">\in</span> <span class="p">[</span>
</span><span class="line">    <span class="n">SW</span><span class="p">:</span> <span class="ni">{</span><span class="s">&quot;sender_ready&quot;</span><span class="p">,</span> <span class="s">&quot;sender_write&quot;</span><span class="p">,</span> <span class="s">&quot;sender_request_notify&quot;</span><span class="p">,</span> <span class="s">&quot;sender_recheck_len&quot;</span><span class="p">,</span>
</span><span class="line">         <span class="s">&quot;sender_write_data&quot;</span><span class="p">,</span> <span class="s">&quot;sender_blocked&quot;</span><span class="p">,</span> <span class="s">&quot;sender_check_notify_data&quot;</span><span class="p">,</span>
</span><span class="line">         <span class="s">&quot;sender_notify_data&quot;</span><span class="p">,</span> <span class="s">&quot;sender_check_recv_live&quot;</span><span class="p">,</span> <span class="s">&quot;Done&quot;</span><span class="ni">}</span><span class="p">,</span>
</span><span class="line">    <span class="n">SC</span><span class="p">:</span> <span class="ni">{</span><span class="s">&quot;sender_open&quot;</span><span class="p">,</span> <span class="s">&quot;sender_notify_closed&quot;</span><span class="p">,</span> <span class="s">&quot;Done&quot;</span><span class="ni">}</span><span class="p">,</span>
</span><span class="line">    <span class="n">RR</span><span class="p">:</span> <span class="ni">{</span><span class="s">&quot;recv_init&quot;</span><span class="p">,</span> <span class="s">&quot;recv_ready&quot;</span><span class="p">,</span> <span class="s">&quot;recv_reading&quot;</span><span class="p">,</span> <span class="s">&quot;recv_got_len&quot;</span><span class="p">,</span> <span class="s">&quot;recv_recheck_len&quot;</span><span class="p">,</span>
</span><span class="line">         <span class="s">&quot;recv_read_data&quot;</span><span class="p">,</span> <span class="s">&quot;recv_final_check&quot;</span><span class="p">,</span> <span class="s">&quot;recv_await_data&quot;</span><span class="p">,</span>
</span><span class="line">         <span class="s">&quot;recv_check_notify_read&quot;</span><span class="p">,</span> <span class="s">&quot;recv_notify_read&quot;</span><span class="p">,</span> <span class="s">&quot;Done&quot;</span><span class="ni">}</span><span class="p">,</span>
</span><span class="line">    <span class="n">RC</span><span class="p">:</span> <span class="ni">{</span><span class="s">&quot;recv_open&quot;</span><span class="p">,</span> <span class="s">&quot;recv_notify_closed&quot;</span><span class="p">,</span> <span class="s">&quot;Done&quot;</span><span class="ni">}</span><span class="p">,</span>
</span><span class="line">    <span class="n">SP</span><span class="p">:</span> <span class="ni">{</span><span class="s">&quot;spurious&quot;</span><span class="ni">}</span>
</span><span class="line"><span class="p">]</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>You might imagine that the PlusCal translator would generate that for you, but it doesn't.
We also need to override <code>MESSAGE</code> with <code>FINITE_MESSAGE(n)</code> for some <code>n</code> (I used <code>2</code>).
Otherwise, it can't enumerate all possible messages.
Now we have:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="n">IntegrityI</span> <span class="ni">==</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">TypeOK</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">PCOK</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">Sent</span> <span class="ni">=</span> <span class="n">Got</span> <span class="nb">\o</span> <span class="n">Buffer</span> <span class="nb">\o</span> <span class="n">msg</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>With that out of the way, TLC starts finding real problems
(that is, examples showing that <code>IntegrityI /\ Next =&gt; IntegrityI'</code> isn't true).
First, <code>recv_read_data</code> would do an out-of-bounds read if <code>have = 1</code> and <code>Buffer = &lt;&lt; &gt;&gt;</code>.
Our job is to explain why that isn't a valid state.
We can fix it with an extra constraint:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="n">IntegrityI</span> <span class="ni">==</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">TypeOK</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">PCOK</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">Sent</span> <span class="ni">=</span> <span class="n">Got</span> <span class="nb">\o</span> <span class="n">Buffer</span> <span class="nb">\o</span> <span class="n">msg</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">pc</span><span class="p">[</span><span class="n">ReceiverReadID</span><span class="p">]</span> <span class="ni">=</span> <span class="s">&quot;recv_read_data&quot;</span> <span class="ni">=&gt;</span> <span class="n">have</span> <span class="o">&lt;=</span> <span class="n">Len</span><span class="p">(</span><span class="n">Buffer</span><span class="p">)</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>(note: that <code>=&gt;</code> is &quot;implies&quot;, while the <code>&lt;=</code> is &quot;less-than-or-equal-to&quot;)</p>
<p>Now it complains that if we do <code>recv_got_len</code> with <code>Buffer = &lt;&lt; &gt;&gt;, have = 1, want = 0</code> then we end up in <code>recv_read_data</code> with
<code>Buffer = &lt;&lt; &gt;&gt;, have = 1</code>, and we have to explain why <em>that</em> can't happen and so on.</p>
<p>Because TLC searches breadth-first, the examples it finds never have more than 2 states.
You just have to explain why the first state can't happen in the real system.
Eventually, you get a big ugly pile of constraints, which you then think about for a bit and simply.
I ended up with:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
<span class="line-number">6</span>
<span class="line-number">7</span>
<span class="line-number">8</span>
<span class="line-number">9</span>
<span class="line-number">10</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="n">IntegrityI</span> <span class="ni">==</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">TypeOK</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">PCOK</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">Sent</span> <span class="ni">=</span> <span class="n">Got</span> <span class="nb">\o</span> <span class="n">Buffer</span> <span class="nb">\o</span> <span class="n">msg</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">have</span> <span class="o">&lt;=</span> <span class="n">Len</span><span class="p">(</span><span class="n">Buffer</span><span class="p">)</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">free</span> <span class="o">&lt;=</span> <span class="n">BufferSize</span> <span class="o">-</span> <span class="n">Len</span><span class="p">(</span><span class="n">Buffer</span><span class="p">)</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">pc</span><span class="p">[</span><span class="n">SenderWriteID</span><span class="p">]</span> <span class="s">\in</span> <span class="ni">{</span><span class="s">&quot;sender_write&quot;</span><span class="p">,</span> <span class="s">&quot;sender_request_notify&quot;</span><span class="p">,</span> <span class="s">&quot;sender_recheck_len&quot;</span><span class="p">,</span>
</span><span class="line">                            <span class="s">&quot;sender_write_data&quot;</span><span class="p">,</span> <span class="s">&quot;sender_blocked&quot;</span><span class="p">,</span> <span class="s">&quot;sender_check_recv_live&quot;</span><span class="ni">}</span>
</span><span class="line">     <span class="ni">=&gt;</span> <span class="n">msg</span> <span class="o">/</span><span class="ni">=</span> <span class="ni">&lt;&lt;</span> <span class="ni">&gt;&gt;</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">pc</span><span class="p">[</span><span class="n">SenderWriteID</span><span class="p">]</span> <span class="s">\in</span> <span class="ni">{</span><span class="s">&quot;sender_ready&quot;</span><span class="ni">}</span> <span class="ni">=&gt;</span> <span class="n">msg</span> <span class="ni">=</span> <span class="ni">&lt;&lt;</span> <span class="ni">&gt;&gt;</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>It's a good idea to check the final <code>IntegrityI</code> with the original <code>SpecOK</code> model,
just to check it really is an invariant.</p>
<p>So, in summary, <code>Integrity</code> is always true because:</p>
<ul>
<li>
<p><code>Sent</code> is always the concatenation of <code>Got</code>, <code>Buffer</code> and <code>msg</code>.
That's fairly obvious, because <code>sender_ready</code> sets <code>msg</code> and appends the same thing to <code>Sent</code>,
and the other steps (<code>sender_write_data</code> and <code>recv_read_data</code>) just transfer some bytes from
the start of one variable to the end of another.</p>
</li>
<li>
<p>Although, like all local information, the receiver's <code>have</code> variable might be out-of-date,
there must be <em>at least</em> that much data in the buffer, because the sender process will only
have added more, not removed any. This is sufficient to ensure that we never do an
out-of-range read.</p>
</li>
<li>
<p>Likewise, the sender's <code>free</code> variable is a lower bound on the true amount of free space,
because the receiver only ever creates more space. We will therefore never write beyond the
free space.</p>
</li>
</ul>
<p>I think this ability to explain why an algorithm works, by being shown examples where the inductive property
doesn't hold, is a really nice feature of TLA.
Inductive invariants are useful as a first step towards writing a proof,
but I think they're valuable even on their own.
If you're documenting your own algorithm,
this process will get you to explain your own reasons for believing it works
(I <a href="https://github.com/mirage/capnp-rpc/pull/149">tried it</a> on a simple algorithm in my own code and it seemed helpful).</p>
<p>Some notes:</p>
<ul>
<li>
<p>Originally, I had the <code>free</code> and <code>have</code> constraints depending on <code>pc</code>.
However, the algorithm sets them to zero when not in use so it turns out they're always true.</p>
</li>
<li>
<p><code>IntegrityI</code> matches 532,224 states, even with a maximum <code>Sent</code> length of 1, but it passes!
There are some games you can play to speed things up;
see <a href="https://lamport.azurewebsites.net/tla/inductive-invariant.pdf">Using TLC to Check Inductive Invariance</a> for some suggestions
(I only discovered that while writing this up).</p>
</li>
</ul>
<h3>Proving Integrity</h3>
<p>TLA provides a syntax for writing proofs,
and integrates with <a href="https://tla.msr-inria.inria.fr/tlaps/content/Home.html">TLAPS</a> (the <em>TLA+ Proof System</em>) to allow them to be checked automatically.</p>
<p>Proving <code>IntegrityI</code> is just a matter of showing that <code>Init =&gt; IntegrityI</code> and that it is preserved
by any possible <code>[Next]_vars</code> step.
To do that, we consider each action of <code>Next</code> individually, which is long but simple enough.</p>
<p>I was able to prove it, but the <code>recv_read_data</code> action was a little difficult
because we don't know that <code>want &gt; 0</code> at that point, so we have to do some extra work
to prove that transferring 0 bytes works, even though the real system never does that.</p>
<p>I therefore added an extra condition to <code>IntegrityI</code> that <code>want</code> is non-zero whenever it's in use,
and also conditions about <code>have</code> and <code>free</code> being 0 when not in use, for completeness:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
<span class="line-number">6</span>
<span class="line-number">7</span>
<span class="line-number">8</span>
<span class="line-number">9</span>
<span class="line-number">10</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="n">IntegrityI</span> <span class="ni">==</span>
</span><span class="line">  <span class="p">[</span><span class="o">...</span><span class="p">]</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">want</span> <span class="ni">=</span> <span class="m">0</span> <span class="o">&lt;=</span><span class="ni">&gt;</span> <span class="n">pc</span><span class="p">[</span><span class="n">ReceiverReadID</span><span class="p">]</span> <span class="s">\in</span> <span class="ni">{</span><span class="s">&quot;recv_check_notify_read&quot;</span><span class="p">,</span> <span class="s">&quot;recv_notify_read&quot;</span><span class="p">,</span>
</span><span class="line">                                          <span class="s">&quot;recv_init&quot;</span><span class="p">,</span> <span class="s">&quot;recv_ready&quot;</span><span class="p">,</span> <span class="s">&quot;recv_notify_read&quot;</span><span class="p">,</span>
</span><span class="line">                                          <span class="s">&quot;Done&quot;</span><span class="ni">}</span>
</span><span class="line">  <span class="o">/\</span> <span class="o">\/</span> <span class="n">pc</span><span class="p">[</span><span class="n">ReceiverReadID</span><span class="p">]</span> <span class="s">\in</span> <span class="ni">{</span><span class="s">&quot;recv_got_len&quot;</span><span class="p">,</span> <span class="s">&quot;recv_recheck_len&quot;</span><span class="p">,</span> <span class="s">&quot;recv_read_data&quot;</span><span class="ni">}</span>
</span><span class="line">     <span class="o">\/</span> <span class="n">have</span> <span class="ni">=</span> <span class="m">0</span>
</span><span class="line">  <span class="o">/\</span> <span class="o">\/</span> <span class="n">pc</span><span class="p">[</span><span class="n">SenderWriteID</span><span class="p">]</span> <span class="s">\in</span> <span class="ni">{</span><span class="s">&quot;sender_write&quot;</span><span class="p">,</span> <span class="s">&quot;sender_request_notify&quot;</span><span class="p">,</span>
</span><span class="line">                               <span class="s">&quot;sender_recheck_len&quot;</span><span class="p">,</span> <span class="s">&quot;sender_write_data&quot;</span><span class="ni">}</span>
</span><span class="line">     <span class="o">\/</span> <span class="n">free</span> <span class="ni">=</span> <span class="m">0</span>
</span></code></pre></td></tr></tbody></table></div></figure><h3>Availability</h3>
<p><code>Integrity</code> was quite easy to prove, but I had more trouble trying to explain <code>Availability</code>.
One way to start would be to add <code>Availability</code> as a property to check to the <code>IntegrityI</code> model.
However, it takes a while to check properties as it does them at the end, and the examples
it finds may have several steps (it took 1m15s to find a counter-example for me).</p>
<p>Here's a faster way (37s).
The algorithm will deadlock if both sender and receiver are in their blocked states and neither
interrupt is pending, so I made a new invariant, <code>I</code>, which says that deadlock can't happen:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
<span class="line-number">6</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="n">I</span> <span class="ni">==</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">IntegrityI</span>
</span><span class="line">  <span class="o">/\</span> <span class="o">~</span> <span class="o">/\</span> <span class="n">pc</span><span class="p">[</span><span class="n">SenderWriteID</span><span class="p">]</span> <span class="ni">=</span> <span class="s">&quot;sender_blocked&quot;</span>
</span><span class="line">       <span class="o">/\</span> <span class="o">~</span><span class="n">SpaceAvailableInt</span>
</span><span class="line">       <span class="o">/\</span> <span class="n">pc</span><span class="p">[</span><span class="n">ReceiverReadID</span><span class="p">]</span> <span class="ni">=</span> <span class="s">&quot;recv_await_data&quot;</span>
</span><span class="line">       <span class="o">/\</span> <span class="o">~</span><span class="n">DataReadyInt</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>I discovered some obvious facts about closing the connection.
For example, the <code>SenderLive</code> flag is set if and only if the sender's close thread hasn't done anything.
I've put them all together in <code>CloseOK</code>:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
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
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="cm">(* Some obvious facts about shutting down connections. *)</span>
</span><span class="line"><span class="n">CloseOK</span> <span class="ni">==</span>
</span><span class="line">  <span class="c">\* An endpoint is live iff its close thread hasn't done anything:</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">pc</span><span class="p">[</span><span class="n">SenderCloseID</span><span class="p">]</span> <span class="ni">=</span> <span class="s">&quot;sender_open&quot;</span> <span class="o">&lt;=</span><span class="ni">&gt;</span> <span class="n">SenderLive</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">pc</span><span class="p">[</span><span class="n">ReceiverCloseID</span><span class="p">]</span> <span class="ni">=</span> <span class="s">&quot;recv_open&quot;</span> <span class="o">&lt;=</span><span class="ni">&gt;</span> <span class="n">ReceiverLive</span>
</span><span class="line">  <span class="c">\* The send and receive loops don't terminate unless someone has closed the connection:</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">pc</span><span class="p">[</span><span class="n">ReceiverReadID</span><span class="p">]</span> <span class="s">\in</span> <span class="ni">{</span><span class="s">&quot;recv_final_check&quot;</span><span class="p">,</span> <span class="s">&quot;Done&quot;</span><span class="ni">}</span> <span class="ni">=&gt;</span> <span class="o">~</span><span class="n">ReceiverLive</span> <span class="o">\/</span> <span class="o">~</span><span class="n">SenderLive</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">pc</span><span class="p">[</span><span class="n">SenderWriteID</span><span class="p">]</span> <span class="s">\in</span> <span class="ni">{</span><span class="s">&quot;Done&quot;</span><span class="ni">}</span> <span class="ni">=&gt;</span> <span class="o">~</span><span class="n">ReceiverLive</span> <span class="o">\/</span> <span class="o">~</span><span class="n">SenderLive</span>
</span><span class="line">  <span class="c">\* If the receiver closed the connection then we will get (or have got) the signal:</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">pc</span><span class="p">[</span><span class="n">ReceiverCloseID</span><span class="p">]</span> <span class="ni">=</span> <span class="s">&quot;Done&quot;</span> <span class="ni">=&gt;</span>
</span><span class="line">          <span class="o">\/</span> <span class="n">SpaceAvailableInt</span>
</span><span class="line">          <span class="o">\/</span> <span class="n">pc</span><span class="p">[</span><span class="n">SenderWriteID</span><span class="p">]</span> <span class="s">\in</span> <span class="ni">{</span><span class="s">&quot;sender_check_recv_live&quot;</span><span class="p">,</span> <span class="s">&quot;Done&quot;</span><span class="ni">}</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>But I had problems with other examples TLC showed me, and
I realised that I didn't actually know why this algorithm doesn't deadlock.</p>
<p>Intuitively it seems clear enough:
the sender puts data in the buffer when there's space and notifies the receiver,
and the receiver reads it and notifies the writer.
What could go wrong?
But both processes are working with information that can be out-of-date.
By the time the sender decides to block because the buffer looked full, the buffer might be empty.
And by the time the receiver decides to block because it looked empty, it might be full.</p>
<p>Maybe you already saw why it works from the C code, or the algorithm above,
but it took me a while to figure it out!
I eventually ended up with an invariant of the form:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="n">I</span> <span class="ni">==</span>
</span><span class="line">  <span class="o">..</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">SendMayBlock</span>    <span class="ni">=&gt;</span> <span class="n">SpaceWakeupComing</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">ReceiveMayBlock</span> <span class="ni">=&gt;</span> <span class="n">DataWakeupComing</span>
</span></code></pre></td></tr></tbody></table></div></figure><p><code>SendMayBlock</code> is <code>TRUE</code> if we're in a state that may lead to being blocked without checking the
buffer's free space again. Likewise, <code>ReceiveMayBlock</code> indicates that the receiver might block.
<code>SpaceWakeupComing</code> and <code>DataWakeupComing</code> predict whether we're going to get an interrupt.
The idea is that if we're going to block, we need to be sure we'll be woken up.
It's a bit ugly, though, e.g.</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
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
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="n">DataWakeupComing</span> <span class="ni">==</span>
</span><span class="line">  <span class="o">\/</span> <span class="n">DataReadyInt</span> <span class="c">\* Event sent</span>
</span><span class="line">  <span class="o">\/</span> <span class="n">pc</span><span class="p">[</span><span class="n">SenderWriteID</span><span class="p">]</span> <span class="ni">=</span> <span class="s">&quot;sender_notify_data&quot;</span>     <span class="c">\* Event being sent</span>
</span><span class="line">  <span class="o">\/</span> <span class="n">pc</span><span class="p">[</span><span class="n">SenderCloseID</span><span class="p">]</span> <span class="ni">=</span> <span class="s">&quot;sender_notify_closed&quot;</span>
</span><span class="line">  <span class="o">\/</span> <span class="n">pc</span><span class="p">[</span><span class="n">ReceiverCloseID</span><span class="p">]</span> <span class="ni">=</span> <span class="s">&quot;recv_notify_closed&quot;</span>
</span><span class="line">  <span class="o">\/</span> <span class="o">/\</span> <span class="n">NotifyWrite</span>   <span class="c">\* Event requested and ...</span>
</span><span class="line">     <span class="o">/\</span> <span class="n">ReceiverLive</span>  <span class="c">\* Sender can see receiver is still alive and ...</span>
</span><span class="line">     <span class="o">/\</span> <span class="o">\/</span> <span class="n">pc</span><span class="p">[</span><span class="n">SenderWriteID</span><span class="p">]</span> <span class="ni">=</span> <span class="s">&quot;sender_write_data&quot;</span> <span class="o">/\</span> <span class="n">free</span> <span class="ni">&gt;</span> <span class="m">0</span>
</span><span class="line">        <span class="o">\/</span> <span class="n">pc</span><span class="p">[</span><span class="n">SenderWriteID</span><span class="p">]</span> <span class="ni">=</span> <span class="s">&quot;sender_check_notify_data&quot;</span> 
</span><span class="line">        <span class="o">\/</span> <span class="n">pc</span><span class="p">[</span><span class="n">SenderWriteID</span><span class="p">]</span> <span class="ni">=</span> <span class="s">&quot;sender_recheck_len&quot;</span> <span class="o">/\</span> <span class="n">Len</span><span class="p">(</span><span class="n">Buffer</span><span class="p">)</span> <span class="ni">&lt;</span> <span class="n">BufferSize</span>
</span><span class="line">        <span class="o">\/</span> <span class="n">pc</span><span class="p">[</span><span class="n">SenderWriteID</span><span class="p">]</span> <span class="ni">=</span> <span class="s">&quot;sender_ready&quot;</span> <span class="o">/\</span> <span class="n">SenderLive</span> <span class="o">/\</span> <span class="n">Len</span><span class="p">(</span><span class="n">Buffer</span><span class="p">)</span> <span class="ni">&lt;</span> <span class="n">BufferSize</span>
</span><span class="line">        <span class="o">\/</span> <span class="n">pc</span><span class="p">[</span><span class="n">SenderWriteID</span><span class="p">]</span> <span class="ni">=</span> <span class="s">&quot;sender_write&quot;</span> <span class="o">/\</span> <span class="n">Len</span><span class="p">(</span><span class="n">Buffer</span><span class="p">)</span> <span class="ni">&lt;</span> <span class="n">BufferSize</span>
</span><span class="line">        <span class="o">\/</span> <span class="n">pc</span><span class="p">[</span><span class="n">SenderWriteID</span><span class="p">]</span> <span class="ni">=</span> <span class="s">&quot;sender_request_notify&quot;</span> <span class="o">/\</span> <span class="n">Len</span><span class="p">(</span><span class="n">Buffer</span><span class="p">)</span> <span class="ni">&lt;</span> <span class="n">BufferSize</span>
</span><span class="line">        <span class="o">\/</span> <span class="n">SpaceWakeupComing</span> <span class="o">/\</span> <span class="n">Len</span><span class="p">(</span><span class="n">Buffer</span><span class="p">)</span> <span class="ni">&lt;</span> <span class="n">BufferSize</span> <span class="o">/\</span> <span class="n">SenderLive</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>It did pass my model that tested sending one byte, and I decided to try a proof.
Well, it didn't work.
The problem seems to be that <code>DataWakeupComing</code> and <code>SpaceWakeupComing</code> are really mutually recursive.
The reader will wake up if the sender wakes it, but the sender might be blocked, or about to block.
That's OK though, as long as the receiver will wake it, which it will do, once the sender wakes it...</p>
<p>You've probably already figured it out, but I thought I'd document my confusion.
It occurred to me that although each process might have out-of-date information,
that could be fine as long as at any one moment one of them was right.
The last process to update the buffer must know how full it is,
so one of them must have correct information at any given time, and that should be enough to avoid deadlock.</p>
<p>That didn't work either.
When you're at a proof step and can't see why it's correct, you can ask TLC to show you an example.
e.g. if you're stuck trying to prove that <code>sender_request_notify</code> preserves <code>I</code> when the
receiver is at <code>recv_ready</code>, the buffer is full, and <code>ReceiverLive = FALSE</code>,
you can ask for an example of that:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
<span class="line-number">6</span>
<span class="line-number">7</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="n">Example</span> <span class="ni">==</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">PCOK</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">pc</span><span class="p">[</span><span class="n">SenderWriteID</span><span class="p">]</span> <span class="ni">=</span> <span class="s">&quot;sender_request_notify&quot;</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">pc</span><span class="p">[</span><span class="n">ReceiverReadID</span><span class="p">]</span> <span class="ni">=</span> <span class="s">&quot;recv_ready&quot;</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">ReceiverLive</span> <span class="ni">=</span> <span class="bp">FALSE</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">I</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">Len</span><span class="p">(</span><span class="n">Buffer</span><span class="p">)</span> <span class="ni">=</span> <span class="n">BufferSize</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>You then create a new model that searches <code>Example /\ [][Next]_vars</code> and tests <code>I</code>.
As long as <code>Example</code> has several constraints, you can use a much larger model for this.
I also ask it to check the property <code>[][FALSE]_vars</code>, which means it will show any step starting from <code>Example</code>.</p>
<p>It quickly became clear what was wrong: it is quite possible that neither process is up-to-date.
If both processes see the buffer contains <code>X</code> bytes of data, and the sender sends <code>Y</code> bytes and the receiver reads <code>Z</code> bytes, then the sender will think there are <code>X + Y</code> bytes in the buffer and the receiver will think there are <code>X - Z</code> bytes, and neither is correct.
My original 1-byte buffer was just too small to find a counter-example.</p>
<p>The real reason why vchan works is actually rather obvious.
I don't know why I didn't see it earlier.
But eventually it occurred to me that I could make use of <code>Got</code> and <code>Sent</code>.
I defined <code>WriteLimit</code> to be the total number of bytes that the sender would write before blocking,
if the receiver never did anything further.
And I defined <code>ReadLimit</code> to be the total number of bytes that the receiver would read if the sender
never did anything else.</p>
<p>Did I define these limits correctly?
It's easy to ask TLC to check some extra properties while it's running.
For example, I used this to check that <code>ReadLimit</code> behaves sensibly:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
<span class="line-number">6</span>
<span class="line-number">7</span>
<span class="line-number">8</span>
<span class="line-number">9</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="n">ReadLimitCorrect</span> <span class="ni">==</span>
</span><span class="line">  <span class="c">\* We will eventually receive what ReadLimit promises:</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">WF_vars</span><span class="p">(</span><span class="n">ReceiverRead</span><span class="p">)</span> <span class="ni">=&gt;</span>
</span><span class="line">      <span class="s">\A</span> <span class="n">i</span> <span class="s">\in</span> <span class="n">AvailabilityNat</span> <span class="p">:</span>
</span><span class="line">        <span class="n">ReadLimit</span> <span class="ni">=</span> <span class="n">i</span> <span class="o">~</span><span class="ni">&gt;</span> <span class="n">Len</span><span class="p">(</span><span class="n">Got</span><span class="p">)</span> <span class="o">&gt;=</span> <span class="n">i</span> <span class="o">\/</span> <span class="o">~</span><span class="n">ReceiverLive</span>
</span><span class="line">  <span class="c">\* ReadLimit can only decrease if we decide to shut down:</span>
</span><span class="line">  <span class="o">/\</span> <span class="p">[][</span><span class="n">ReadLimit</span><span class="err">'</span> <span class="o">&gt;=</span> <span class="n">ReadLimit</span> <span class="o">\/</span> <span class="o">~</span><span class="n">ReceiverLive</span><span class="p">]</span><span class="n">_vars</span>
</span><span class="line">  <span class="c">\* ReceiverRead steps don't change the read limit:</span>
</span><span class="line">  <span class="o">/\</span> <span class="p">[][</span><span class="n">ReceiverRead</span> <span class="ni">=&gt;</span> <span class="n">UNCHANGED</span> <span class="n">ReadLimit</span> <span class="o">\/</span> <span class="o">~</span><span class="n">ReceiverLive</span><span class="p">]</span><span class="n">_vars</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>Because <code>ReadLimit</code> is defined in terms of what it does when no other processes run,
this property should ideally be tested in a model without the fairness conditions
(i.e. just <code>Init /\ [][Next]_vars</code>).
Otherwise, fairness may force the sender to perform a step.
We still want to allow other steps, though, to show that <code>ReadLimit</code> is a lower bound.</p>
<p>With this, we can argue that e.g. a 2-byte buffer will eventually transfer 3 bytes:</p>
<ol>
<li>The receiver will eventually read 3 bytes as long as the sender eventually sends 3 bytes.
</li>
<li>The sender will eventually send 3, if the receiver reads at least 1.
</li>
<li>The receiver will read 1 if the sender sends at least 1.
</li>
<li>The sender will send 1 if the reader has read at least 0 bytes, which is always true.
</li>
</ol>
<p>By this point, I was learning to be more cautious before trying a proof,
so I added some new models to check this idea further.
One prevents the sender from ever closing the connection and the other prevents the receiver from ever closing.
That reduces the number of states to consider and I was able to check a slightly larger model.</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
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
<span class="line-number">19</span>
<span class="line-number">20</span>
<span class="line-number">21</span>
<span class="line-number">22</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="n">I</span> <span class="ni">==</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">IntegrityI</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">CloseOK</span>
</span><span class="line">  <span class="c">\* If the reader is stuck, but data is available, the sender will unblock it:</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">ReaderShouldBeUnblocked</span>
</span><span class="line">     <span class="ni">=&gt;</span> <span class="c">\* The sender is going to write more:</span>
</span><span class="line">        <span class="o">\/</span> <span class="n">WriteLimit</span> <span class="ni">&gt;</span> <span class="n">Len</span><span class="p">(</span><span class="n">Got</span><span class="p">)</span> <span class="o">+</span> <span class="n">Len</span><span class="p">(</span><span class="n">Buffer</span><span class="p">)</span> <span class="o">/\</span> <span class="n">Len</span><span class="p">(</span><span class="n">msg</span><span class="p">)</span> <span class="ni">&gt;</span> <span class="m">0</span> <span class="o">/\</span> <span class="n">SenderLive</span>
</span><span class="line">        <span class="c">\* The sender is about to increase ReadLimit:</span>
</span><span class="line">        <span class="o">\/</span> <span class="p">(</span><span class="o">\/</span> <span class="n">pc</span><span class="p">[</span><span class="n">SenderWriteID</span><span class="p">]</span> <span class="ni">=</span> <span class="s">&quot;sender_check_notify_data&quot;</span> <span class="o">/\</span> <span class="n">NotifyWrite</span>
</span><span class="line">            <span class="o">\/</span> <span class="n">pc</span><span class="p">[</span><span class="n">SenderWriteID</span><span class="p">]</span> <span class="ni">=</span> <span class="s">&quot;sender_notify_data&quot;</span><span class="p">)</span> <span class="o">/\</span> <span class="n">ReadLimit</span> <span class="ni">&lt;</span> <span class="n">Len</span><span class="p">(</span><span class="n">Got</span><span class="p">)</span> <span class="o">+</span> <span class="n">Len</span><span class="p">(</span><span class="n">Buffer</span><span class="p">)</span>
</span><span class="line">        <span class="c">\* The sender is about to notify us of shutdown:</span>
</span><span class="line">        <span class="o">\/</span> <span class="n">pc</span><span class="p">[</span><span class="n">SenderCloseID</span><span class="p">]</span> <span class="s">\in</span> <span class="ni">{</span><span class="s">&quot;sender_notify_closed&quot;</span><span class="ni">}</span>
</span><span class="line">  <span class="c">\* If the writer is stuck, but there is now space available, the receiver will unblock it:</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">WriterShouldBeUnblocked</span>
</span><span class="line">     <span class="ni">=&gt;</span> <span class="c">\* The reader is going to read more:</span>
</span><span class="line">        <span class="o">\/</span> <span class="n">ReadLimit</span> <span class="ni">&gt;</span> <span class="n">Len</span><span class="p">(</span><span class="n">Got</span><span class="p">)</span> <span class="o">/\</span> <span class="n">ReceiverLive</span>
</span><span class="line">        <span class="c">\* The reader is about to increase WriteLimit:</span>
</span><span class="line">        <span class="o">\/</span> <span class="p">(</span><span class="o">\/</span> <span class="n">pc</span><span class="p">[</span><span class="n">ReceiverReadID</span><span class="p">]</span> <span class="ni">=</span> <span class="s">&quot;recv_check_notify_read&quot;</span> <span class="o">/\</span> <span class="n">NotifyRead</span>
</span><span class="line">            <span class="o">\/</span> <span class="n">pc</span><span class="p">[</span><span class="n">ReceiverReadID</span><span class="p">]</span> <span class="ni">=</span> <span class="s">&quot;recv_notify_read&quot;</span><span class="p">)</span> <span class="o">/\</span> <span class="n">WriteLimit</span> <span class="ni">&lt;</span> <span class="n">Len</span><span class="p">(</span><span class="n">Got</span><span class="p">)</span> <span class="o">+</span> <span class="n">BufferSize</span>
</span><span class="line">        <span class="c">\* The receiver is about to notify us of shutdown:</span>
</span><span class="line">        <span class="o">\/</span> <span class="n">pc</span><span class="p">[</span><span class="n">ReceiverCloseID</span><span class="p">]</span> <span class="s">\in</span> <span class="ni">{</span><span class="s">&quot;recv_notify_closed&quot;</span><span class="ni">}</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">NotifyFlagsCorrect</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>If a process is on a path to being blocked then it must have set its notify flag.
<code>NotifyFlagsCorrect</code> says that in that case, the flag it still set, or the interrupt has been sent,
or the other process is just about to trigger the interrupt.</p>
<p>I managed to use that to prove that the sender's steps preserved <code>I</code>,
but I needed a little extra to finish the receiver proof.
At this point, I finally spotted the obvious invariant (which you, no doubt, saw all along):
whenever <code>NotifyRead</code> is still set, the sender has accurate information about the buffer.</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="o">/\</span> <span class="n">NotifyRead</span> <span class="ni">=&gt;</span>
</span><span class="line">      <span class="c">\* The sender has accurate information about the buffer:</span>
</span><span class="line">      <span class="o">\/</span> <span class="n">WriteLimit</span> <span class="ni">=</span> <span class="n">Len</span><span class="p">(</span><span class="n">Got</span><span class="p">)</span> <span class="o">+</span> <span class="n">BufferSize</span>
</span><span class="line">      <span class="c">\* Or the flag is being cleared right now:</span>
</span><span class="line">      <span class="o">\/</span> <span class="n">pc</span><span class="p">[</span><span class="n">ReceiverReadID</span><span class="p">]</span> <span class="ni">=</span> <span class="s">&quot;recv_check_notify_read&quot;</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>That's pretty obvious, isn't it?
The sender checks the buffer after setting the flag, so it must have accurate information at that point.
The receiver clears the flag after reading from the buffer (which invalidates the sender's information).</p>
<p>Now I had a dilemma.
There was obviously going to be a matching property about <code>NotifyWrite</code>.
Should I add that, or continue with just this?
I was nearly done, so I continued and finished off the proofs.</p>
<p>With <code>I</code> proved, I was able to prove some other nice things quite easily:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="n">THEOREM</span> 
</span><span class="line">  <span class="o">/\</span> <span class="n">I</span> <span class="o">/\</span> <span class="n">SenderLive</span> <span class="o">/\</span> <span class="n">ReceiverLive</span>
</span><span class="line">  <span class="o">/\</span> <span class="o">\/</span> <span class="n">pc</span><span class="p">[</span><span class="n">SenderWriteID</span><span class="p">]</span> <span class="ni">=</span> <span class="s">&quot;sender_ready&quot;</span>
</span><span class="line">     <span class="o">\/</span> <span class="n">pc</span><span class="p">[</span><span class="n">SenderWriteID</span><span class="p">]</span> <span class="ni">=</span> <span class="s">&quot;sender_blocked&quot;</span> <span class="o">/\</span> <span class="o">~</span><span class="n">SpaceAvailableInt</span>
</span><span class="line">  <span class="ni">=&gt;</span> <span class="n">ReadLimit</span> <span class="ni">=</span> <span class="n">Len</span><span class="p">(</span><span class="n">Got</span><span class="p">)</span> <span class="o">+</span> <span class="n">Len</span><span class="p">(</span><span class="n">Buffer</span><span class="p">)</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>That says that, whenever the sender is idle or blocked, the receiver will read everything sent so far,
without any further help from the sender. And:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="n">THEOREM</span> 
</span><span class="line">  <span class="o">/\</span> <span class="n">I</span> <span class="o">/\</span> <span class="n">SenderLive</span> <span class="o">/\</span> <span class="n">ReceiverLive</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">pc</span><span class="p">[</span><span class="n">ReceiverReadID</span><span class="p">]</span> <span class="s">\in</span> <span class="ni">{</span><span class="s">&quot;recv_await_data&quot;</span><span class="ni">}</span> <span class="o">/\</span> <span class="o">~</span><span class="n">DataReadyInt</span>
</span><span class="line">  <span class="ni">=&gt;</span> <span class="n">WriteLimit</span> <span class="ni">=</span> <span class="n">Len</span><span class="p">(</span><span class="n">Got</span><span class="p">)</span> <span class="o">+</span> <span class="n">BufferSize</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>That says that whenever the receiver is blocked, the sender can fill the buffer.
That's pretty nice.
It would be possible to make a vchan system that e.g. could only send 1 byte at a time and still
prove it couldn't deadlock and would always deliver data,
but here we have shown that the algorithm can use the whole buffer.
At least, that's what these theorems say as long as you believe that <code>ReadLimit</code> and <code>WriteLimit</code> are defined correctly.</p>
<p>With the proof complete, I then went back and deleted all the stuff about <code>ReadLimit</code> and <code>WriteLimit</code> from <code>I</code>
and started again with just the new rules about <code>NotifyRead</code> and <code>NotifyWrite</code>.
Instead of using <code>WriteLimit = Len(Got) + BufferSize</code> to indicate that the sender has accurate information,
I made a new <code>SenderInfoAccurate</code> that just returns <code>TRUE</code> whenever the sender will fill the buffer without further help.
That avoids some unnecessary arithmetic, which TLAPS needs a lot of help with.</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
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
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="cm">(* The sender's information is accurate if whenever it is going to block, the buffer</span>
</span><span class="line"><span class="cm">   really is full. *)</span>
</span><span class="line"><span class="n">SenderInfoAccurate</span> <span class="ni">==</span>
</span><span class="line">  <span class="c">\* We have accurate information:</span>
</span><span class="line">  <span class="o">\/</span> <span class="n">Len</span><span class="p">(</span><span class="n">Buffer</span><span class="p">)</span> <span class="o">+</span> <span class="n">free</span> <span class="ni">=</span> <span class="n">BufferSize</span>
</span><span class="line">  <span class="c">\* In these states, we're going to check the buffer before blocking:</span>
</span><span class="line">  <span class="o">\/</span> <span class="n">pc</span><span class="p">[</span><span class="n">SenderWriteID</span><span class="p">]</span> <span class="s">\in</span> <span class="ni">{</span><span class="s">&quot;sender_ready&quot;</span><span class="p">,</span> <span class="s">&quot;sender_request_notify&quot;</span><span class="p">,</span> <span class="s">&quot;sender_write&quot;</span><span class="p">,</span>
</span><span class="line">                            <span class="s">&quot;sender_recheck_len&quot;</span><span class="p">,</span> <span class="s">&quot;sender_check_recv_live&quot;</span><span class="p">,</span> <span class="s">&quot;Done&quot;</span><span class="ni">}</span>
</span><span class="line">  <span class="o">\/</span> <span class="n">pc</span><span class="p">[</span><span class="n">SenderWriteID</span><span class="p">]</span> <span class="s">\in</span> <span class="ni">{</span><span class="s">&quot;sender_request_notify&quot;</span><span class="ni">}</span> <span class="o">/\</span> <span class="n">free</span> <span class="ni">&lt;</span> <span class="n">Len</span><span class="p">(</span><span class="n">msg</span><span class="p">)</span>
</span><span class="line">  <span class="c">\* If we've been signalled, we'll immediately wake next time we try to block:</span>
</span><span class="line">  <span class="o">\/</span> <span class="n">SpaceAvailableInt</span>
</span><span class="line">  <span class="c">\* We're about to write some data:</span>
</span><span class="line">  <span class="o">\/</span> <span class="o">/\</span> <span class="n">pc</span><span class="p">[</span><span class="n">SenderWriteID</span><span class="p">]</span> <span class="s">\in</span> <span class="ni">{</span><span class="s">&quot;sender_write_data&quot;</span><span class="ni">}</span>
</span><span class="line">     <span class="o">/\</span> <span class="n">free</span> <span class="o">&gt;=</span> <span class="n">Len</span><span class="p">(</span><span class="n">msg</span><span class="p">)</span>                <span class="c">\* But we won't need to block</span>
</span><span class="line">  <span class="c">\* If we wrote all the data we intended to, we'll return without blocking:</span>
</span><span class="line">  <span class="o">\/</span> <span class="o">/\</span> <span class="n">pc</span><span class="p">[</span><span class="n">SenderWriteID</span><span class="p">]</span> <span class="s">\in</span> <span class="ni">{</span><span class="s">&quot;sender_check_notify_data&quot;</span><span class="p">,</span> <span class="s">&quot;sender_notify_data&quot;</span><span class="ni">}</span>
</span><span class="line">     <span class="o">/\</span> <span class="n">Len</span><span class="p">(</span><span class="n">msg</span><span class="p">)</span> <span class="ni">=</span> <span class="m">0</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>By talking about accuracy instead of the write limit, I was also able to include &quot;Done&quot; in with
the other happy cases.
Before, that had to be treated as a possible problem because the sender can't use the full buffer when it's Done.</p>
<p>With this change, the proof of <code>Spec =&gt; []I</code> became much simpler (384 lines shorter).
And most of the remaining steps were trivial.</p>
<p>The <code>ReadLimit</code> and <code>WriteLimit</code> idea still seemed useful, though,
but I found I was able to prove the same things from <code>I</code>.
e.g. we can still conclude this, even if <code>I</code> doesn't mention <code>WriteLimit</code>:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="n">THEOREM</span> 
</span><span class="line">  <span class="o">/\</span> <span class="n">I</span> <span class="o">/\</span> <span class="n">SenderLive</span> <span class="o">/\</span> <span class="n">ReceiverLive</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">pc</span><span class="p">[</span><span class="n">ReceiverReadID</span><span class="p">]</span> <span class="s">\in</span> <span class="ni">{</span><span class="s">&quot;recv_await_data&quot;</span><span class="ni">}</span> <span class="o">/\</span> <span class="o">~</span><span class="n">DataReadyInt</span>
</span><span class="line">  <span class="ni">=&gt;</span> <span class="n">WriteLimit</span> <span class="ni">=</span> <span class="n">Len</span><span class="p">(</span><span class="n">Got</span><span class="p">)</span> <span class="o">+</span> <span class="n">BufferSize</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>That's nice, because it keeps the invariant and its proofs simple,
but we still get the same result in the end.</p>
<p>I initially defined <code>WriteLimit</code> to be the number of bytes the sender <em>could</em> write if
the sending application wanted to send enough data,
but I later changed it to be the actual number of bytes it <em>would</em> write if the application didn't
try to send any more.
This is because otherwise, with packet-based sends
(where we only write when the buffer has enough space for the whole message at once)
<code>WriteLimit</code> could go down.
e.g. we think we can write another 3 bytes,
but then the application decides to write 10 bytes and now we can't write anything more.</p>
<p>The limit theorems above are useful properties,
but it would be good to have more confidence that <code>ReadLimit</code> and <code>WriteLimit</code> are correct.
I was able to prove some useful lemmas here.</p>
<p>First, <code>ReceiverRead</code> steps don't change <code>ReadLimit</code> (as long as the receiver hasn't closed
the connection):</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="n">THEOREM</span> <span class="n">ReceiverReadPreservesReadLimit</span> <span class="ni">==</span>
</span><span class="line">  <span class="n">ASSUME</span> <span class="n">I</span><span class="p">,</span> <span class="n">ReceiverLive</span><span class="p">,</span> <span class="n">ReceiverRead</span>
</span><span class="line">  <span class="n">PROVE</span>  <span class="n">UNCHANGED</span> <span class="n">ReadLimit</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>This gives us a good reason to think that ReadLimit is correct:</p>
<ul>
<li>When the receiver is blocked it cannot read any more than it has without help.
</li>
<li><code>ReadLimit</code> is defined to be <code>Len(Got)</code> then, so <code>ReadLimit</code> is obviously correct for this case.
</li>
<li>Since read steps preserve <code>ReadLimit</code>, this shows that ReadLimit is correct in all cases.
</li>
</ul>
<p>e.g. if <code>ReadLimit = 5</code> and no other processes do anything,
then we will end up in a state with the receiver blocked, and <code>ReadLimit = Len(Got) = 5</code>
and so we really did read a total of 5 bytes.</p>
<p>I was also able to prove that it never decreases (unless the receiver closes the connection):</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="n">THEOREM</span> <span class="n">ReadLimitMonotonic</span> <span class="ni">==</span>
</span><span class="line">  <span class="n">ASSUME</span> <span class="n">I</span><span class="p">,</span> <span class="n">Next</span><span class="p">,</span> <span class="n">ReceiverLive</span>
</span><span class="line">  <span class="n">PROVE</span>  <span class="n">ReadLimit</span><span class="err">'</span> <span class="o">&gt;=</span> <span class="n">ReadLimit</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>So, if <code>ReadLimit = n</code> then it will always be at least <code>n</code>,
and if the receiver ever blocks then it will have read at least <code>n</code> bytes.</p>
<p>I was able to prove similar properties about <code>WriteLimit</code>.
So, I feel reasonably confident that these limit predictions are correct.</p>
<p>Disappointingly, we can't actually prove <code>Availability</code> using TLAPS,
because currently it understands very little temporal logic (see <a href="https://github.com/tlaplus/v2-tlapm/blob/c0ea83d8481e9dffbcbc5b54822c0e235ff59153/library/TLAPS.tla#L312">TLAPS limitations</a>).
However, I could show that the system can't deadlock while there's data to be transmitted:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
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
<span class="line-number">19</span>
<span class="line-number">20</span>
<span class="line-number">21</span>
<span class="line-number">22</span>
<span class="line-number">23</span>
<span class="line-number">24</span>
<span class="line-number">25</span>
<span class="line-number">26</span>
<span class="line-number">27</span>
<span class="line-number">28</span>
<span class="line-number">29</span>
<span class="line-number">30</span>
<span class="line-number">31</span>
<span class="line-number">32</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="cm">(* We can't get into a state where the sender and receiver are both blocked</span>
</span><span class="line"><span class="cm">   and there is no wakeup pending: *)</span>
</span><span class="line"><span class="n">THEOREM</span> <span class="n">DeadlockFree1</span> <span class="ni">==</span>
</span><span class="line">  <span class="n">ASSUME</span> <span class="n">I</span>
</span><span class="line">  <span class="n">PROVE</span>  <span class="o">~</span> <span class="o">/\</span> <span class="n">pc</span><span class="p">[</span><span class="n">SenderWriteID</span><span class="p">]</span> <span class="ni">=</span> <span class="s">&quot;sender_blocked&quot;</span>
</span><span class="line">           <span class="o">/\</span> <span class="o">~</span><span class="n">SpaceAvailableInt</span> <span class="o">/\</span> <span class="n">SenderLive</span>
</span><span class="line">           <span class="o">/\</span> <span class="n">pc</span><span class="p">[</span><span class="n">ReceiverReadID</span><span class="p">]</span> <span class="ni">=</span> <span class="s">&quot;recv_await_data&quot;</span>
</span><span class="line">           <span class="o">/\</span> <span class="o">~</span><span class="n">DataReadyInt</span> <span class="o">/\</span> <span class="n">ReceiverLive</span>
</span><span class="line"><span class="ni">&lt;</span><span class="m">1</span><span class="ni">&gt;</span> <span class="n">SUFFICES</span> <span class="n">ASSUME</span> <span class="o">/\</span> <span class="n">pc</span><span class="p">[</span><span class="n">SenderWriteID</span><span class="p">]</span> <span class="ni">=</span> <span class="s">&quot;sender_blocked&quot;</span>
</span><span class="line">                    <span class="o">/\</span> <span class="o">~</span><span class="n">SpaceAvailableInt</span> <span class="o">/\</span> <span class="n">SenderLive</span>
</span><span class="line">                    <span class="o">/\</span> <span class="n">pc</span><span class="p">[</span><span class="n">ReceiverReadID</span><span class="p">]</span> <span class="ni">=</span> <span class="s">&quot;recv_await_data&quot;</span>
</span><span class="line">                    <span class="o">/\</span> <span class="o">~</span><span class="n">DataReadyInt</span> <span class="o">/\</span> <span class="n">ReceiverLive</span>
</span><span class="line">             <span class="n">PROVE</span>  <span class="bp">FALSE</span>
</span><span class="line">    <span class="n">OBVIOUS</span>
</span><span class="line"><span class="ni">&lt;</span><span class="m">1</span><span class="ni">&gt;</span> <span class="n">NotifyFlagsCorrect</span> <span class="n">BY</span> <span class="n">DEF</span> <span class="n">I</span>
</span><span class="line"><span class="ni">&lt;</span><span class="m">1</span><span class="ni">&gt;</span> <span class="n">NotifyRead</span> <span class="n">BY</span> <span class="n">DEF</span> <span class="n">NotifyFlagsCorrect</span>
</span><span class="line"><span class="ni">&lt;</span><span class="m">1</span><span class="ni">&gt;</span> <span class="n">NotifyWrite</span>
</span><span class="line">    <span class="ni">&lt;</span><span class="m">2</span><span class="ni">&gt;</span> <span class="n">have</span> <span class="ni">=</span> <span class="m">0</span> <span class="n">BY</span> <span class="n">DEF</span> <span class="n">IntegrityI</span><span class="p">,</span> <span class="n">I</span>
</span><span class="line">    <span class="ni">&lt;</span><span class="m">2</span><span class="ni">&gt;</span> <span class="n">QED</span> <span class="n">BY</span> <span class="n">DEF</span> <span class="n">NotifyFlagsCorrect</span>
</span><span class="line"><span class="ni">&lt;</span><span class="m">1</span><span class="ni">&gt;</span> <span class="n">SenderInfoAccurate</span> <span class="o">/\</span> <span class="n">ReaderInfoAccurate</span> <span class="n">BY</span> <span class="n">DEF</span> <span class="n">I</span>
</span><span class="line"><span class="ni">&lt;</span><span class="m">1</span><span class="ni">&gt;</span> <span class="n">free</span> <span class="ni">=</span> <span class="m">0</span> <span class="n">BY</span> <span class="n">DEF</span> <span class="n">IntegrityI</span><span class="p">,</span> <span class="n">I</span>
</span><span class="line"><span class="ni">&lt;</span><span class="m">1</span><span class="ni">&gt;</span> <span class="n">Len</span><span class="p">(</span><span class="n">Buffer</span><span class="p">)</span> <span class="ni">=</span> <span class="n">BufferSize</span> <span class="n">BY</span> <span class="n">DEF</span> <span class="n">SenderInfoAccurate</span>
</span><span class="line"><span class="ni">&lt;</span><span class="m">1</span><span class="ni">&gt;</span> <span class="n">Len</span><span class="p">(</span><span class="n">Buffer</span><span class="p">)</span> <span class="ni">=</span> <span class="m">0</span> <span class="n">BY</span> <span class="n">DEF</span> <span class="n">ReaderInfoAccurate</span>
</span><span class="line"><span class="ni">&lt;</span><span class="m">1</span><span class="ni">&gt;</span> <span class="n">QED</span> <span class="n">BY</span> <span class="n">BufferSizeType</span>
</span><span class="line">
</span><span class="line"><span class="cm">(* We can't get into a state where the sender is idle and the receiver is blocked</span>
</span><span class="line"><span class="cm">   unless the buffer is empty (all data sent has been consumed): *)</span>
</span><span class="line"><span class="n">THEOREM</span> <span class="n">DeadlockFree2</span> <span class="ni">==</span>
</span><span class="line">  <span class="n">ASSUME</span> <span class="n">I</span><span class="p">,</span> <span class="n">pc</span><span class="p">[</span><span class="n">SenderWriteID</span><span class="p">]</span> <span class="ni">=</span> <span class="s">&quot;sender_ready&quot;</span><span class="p">,</span> <span class="n">SenderLive</span><span class="p">,</span>
</span><span class="line">         <span class="n">pc</span><span class="p">[</span><span class="n">ReceiverReadID</span><span class="p">]</span> <span class="ni">=</span> <span class="s">&quot;recv_await_data&quot;</span><span class="p">,</span> <span class="n">ReceiverLive</span><span class="p">,</span>
</span><span class="line">         <span class="o">~</span><span class="n">DataReadyInt</span>
</span><span class="line">  <span class="n">PROVE</span>  <span class="n">Len</span><span class="p">(</span><span class="n">Buffer</span><span class="p">)</span> <span class="ni">=</span> <span class="m">0</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>I've included the proof of <code>DeadlockFree1</code> above:</p>
<ul>
<li>To show deadlock can't happen, it suffices to assume it has happened and show a contradiction.
</li>
<li>If both processes are blocked then <code>NotifyRead</code> and <code>NotifyWrite</code> must both be set
(because processes don't block without setting them,
and if they'd been unset then an interrupt would now be pending and we wouldn't be blocked).
</li>
<li>Since <code>NotifyRead</code> is still set,
the sender is correct in thinking that the buffer is still full.
</li>
<li>Since <code>NotifyWrite</code> is still set,
the receiver is correct in thinking that the buffer is still empty.
</li>
<li>That would be a contradiction, since <code>BufferSize</code> isn't zero.
</li>
</ul>
<p>If it doesn't deadlock, then some process must keep getting woken up by interrupts,
which means that interrupts keep being sent.
We only send interrupts after making progress (writing to the buffer or reading from it),
so we must keep making progress.
We'll have to content ourselves with that argument.</p>
<h2>Experiences with TLAPS</h2>
<p>The toolbox doesn't come with the proof system, so you need to install it separately.
The instructions are out-of-date and have a lot of broken links.
In May, I turned the steps into a Dockerfile, which got it partly installed, and asked on the TLA group for help,
but no-one else seemed to know how to install it either.
By looking at the error messages and searching the web for programs with the same names, I finally managed to get it working in December.
If you have trouble installing it too, try using <a href="https://github.com/talex5/tla">my Docker image</a>.</p>
<p>Once installed, you can write a proof in the toolbox and then press Ctrl-G, Ctrl-G to check it.
On success, the proof turns green. On failure, the failing step turns red.
You can also do the Ctrl-G, Ctrl-G combination on a single step to check just that step.
That's useful, because it's pretty slow.
It takes more than 10 minutes to check the complete specification.</p>
<p>TLA proofs are done in the mathematical style,
which is to write a set of propositions and vaguely suggest that thinking about these will lead you to the proof.
This is good for building intuition, but bad for reproducibility.
A mathematical proof is considered correct if the reader is convinced by it, which depends on the reader.
In this case, the &quot;reader&quot; is a collection of automated theorem-provers with various timeouts.
This means that whether a proof is correct or not depends on how fast your computer is,
how many programs are currently running, etc.
A proof might pass one day and fail the next.
Some proof steps consistently pass when you try them individually,
but consistently fail when checked as part of the whole proof.
If a step fails, you need to break it down into smaller steps.</p>
<p>Sometimes the proof system is very clever, and immediately solves complex steps.
For example, here is the proof that the <code>SenderClose</code> process (which represents the sender closing the channel),
preserves the invariant <code>I</code>:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
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
<span class="line-number">19</span>
<span class="line-number">20</span>
<span class="line-number">21</span>
<span class="line-number">22</span>
<span class="line-number">23</span>
<span class="line-number">24</span>
<span class="line-number">25</span>
<span class="line-number">26</span>
<span class="line-number">27</span>
<span class="line-number">28</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="n">LEMMA</span> <span class="n">SenderClosePreservesI</span> <span class="ni">==</span>
</span><span class="line">  <span class="n">I</span> <span class="o">/\</span> <span class="n">SenderClose</span> <span class="ni">=&gt;</span> <span class="n">I</span><span class="err">'</span>
</span><span class="line"><span class="ni">&lt;</span><span class="m">1</span><span class="ni">&gt;</span> <span class="n">SUFFICES</span> <span class="n">ASSUME</span> <span class="n">I</span><span class="p">,</span> <span class="n">SenderClose</span>
</span><span class="line">             <span class="n">PROVE</span>  <span class="n">I</span><span class="err">'</span>
</span><span class="line">    <span class="n">OBVIOUS</span>
</span><span class="line"><span class="ni">&lt;</span><span class="m">1</span><span class="ni">&gt;</span> <span class="n">IntegrityI</span> <span class="n">BY</span> <span class="n">DEF</span> <span class="n">I</span>
</span><span class="line"><span class="ni">&lt;</span><span class="m">1</span><span class="ni">&gt;</span> <span class="n">TypeOK</span> <span class="n">BY</span> <span class="n">DEF</span> <span class="n">IntegrityI</span>
</span><span class="line"><span class="ni">&lt;</span><span class="m">1</span><span class="ni">&gt;</span> <span class="n">PCOK</span> <span class="n">BY</span> <span class="n">DEF</span> <span class="n">IntegrityI</span>
</span><span class="line"><span class="ni">&lt;</span><span class="m">1</span><span class="ni">&gt;</span><span class="m">1</span><span class="o">.</span> <span class="k k-Conditional">CASE</span> <span class="n">sender_open</span>
</span><span class="line">      <span class="ni">&lt;</span><span class="m">2</span><span class="ni">&gt;</span> <span class="n">USE</span> <span class="ni">&lt;</span><span class="m">1</span><span class="ni">&gt;</span><span class="m">1</span> <span class="n">DEF</span> <span class="n">sender_open</span>
</span><span class="line">      <span class="ni">&lt;</span><span class="m">2</span><span class="ni">&gt;</span> <span class="n">UNCHANGED</span> <span class="ni">&lt;&lt;</span> <span class="n">pc</span><span class="p">[</span><span class="n">SenderWriteID</span><span class="p">],</span> <span class="n">pc</span><span class="p">[</span><span class="n">ReceiverReadID</span><span class="p">],</span> <span class="n">pc</span><span class="p">[</span><span class="n">ReceiverCloseID</span><span class="p">]</span> <span class="ni">&gt;&gt;</span> <span class="n">BY</span> <span class="n">DEF</span> <span class="n">PCOK</span>
</span><span class="line">      <span class="ni">&lt;</span><span class="m">2</span><span class="ni">&gt;</span> <span class="n">pc</span><span class="err">'</span><span class="p">[</span><span class="n">SenderCloseID</span><span class="p">]</span> <span class="ni">=</span> <span class="s">&quot;sender_notify_closed&quot;</span> <span class="n">BY</span> <span class="n">DEF</span> <span class="n">PCOK</span>
</span><span class="line">      <span class="ni">&lt;</span><span class="m">2</span><span class="ni">&gt;</span> <span class="n">TypeOK</span><span class="err">'</span> <span class="n">BY</span> <span class="n">DEF</span> <span class="n">TypeOK</span>
</span><span class="line">      <span class="ni">&lt;</span><span class="m">2</span><span class="ni">&gt;</span> <span class="n">PCOK</span><span class="err">'</span> <span class="n">BY</span> <span class="n">DEF</span> <span class="n">PCOK</span>
</span><span class="line">      <span class="ni">&lt;</span><span class="m">2</span><span class="ni">&gt;</span> <span class="n">IntegrityI</span><span class="err">'</span> <span class="n">BY</span> <span class="n">DEF</span> <span class="n">IntegrityI</span>
</span><span class="line">      <span class="ni">&lt;</span><span class="m">2</span><span class="ni">&gt;</span> <span class="n">NotifyFlagsCorrect</span><span class="err">'</span> <span class="n">BY</span> <span class="n">DEF</span> <span class="n">NotifyFlagsCorrect</span><span class="p">,</span> <span class="n">I</span>
</span><span class="line">      <span class="ni">&lt;</span><span class="m">2</span><span class="ni">&gt;</span> <span class="n">QED</span> <span class="n">BY</span> <span class="n">DEF</span> <span class="n">I</span><span class="p">,</span> <span class="n">SenderInfoAccurate</span><span class="p">,</span> <span class="n">ReaderInfoAccurate</span><span class="p">,</span> <span class="n">CloseOK</span>
</span><span class="line"><span class="ni">&lt;</span><span class="m">1</span><span class="ni">&gt;</span><span class="m">2</span><span class="o">.</span> <span class="k k-Conditional">CASE</span> <span class="n">sender_notify_closed</span>
</span><span class="line">      <span class="ni">&lt;</span><span class="m">2</span><span class="ni">&gt;</span> <span class="n">USE</span> <span class="ni">&lt;</span><span class="m">1</span><span class="ni">&gt;</span><span class="m">2</span> <span class="n">DEF</span> <span class="n">sender_notify_closed</span>
</span><span class="line">      <span class="ni">&lt;</span><span class="m">2</span><span class="ni">&gt;</span> <span class="n">UNCHANGED</span> <span class="ni">&lt;&lt;</span> <span class="n">pc</span><span class="p">[</span><span class="n">SenderWriteID</span><span class="p">],</span> <span class="n">pc</span><span class="p">[</span><span class="n">ReceiverReadID</span><span class="p">],</span> <span class="n">pc</span><span class="p">[</span><span class="n">ReceiverCloseID</span><span class="p">]</span> <span class="ni">&gt;&gt;</span> <span class="n">BY</span> <span class="n">DEF</span> <span class="n">PCOK</span>
</span><span class="line">      <span class="ni">&lt;</span><span class="m">2</span><span class="ni">&gt;</span> <span class="n">pc</span><span class="err">'</span><span class="p">[</span><span class="n">SenderCloseID</span><span class="p">]</span> <span class="ni">=</span> <span class="s">&quot;Done&quot;</span> <span class="n">BY</span> <span class="n">DEF</span> <span class="n">PCOK</span>
</span><span class="line">      <span class="ni">&lt;</span><span class="m">2</span><span class="ni">&gt;</span> <span class="n">TypeOK</span><span class="err">'</span> <span class="n">BY</span> <span class="n">DEF</span> <span class="n">TypeOK</span>
</span><span class="line">      <span class="ni">&lt;</span><span class="m">2</span><span class="ni">&gt;</span> <span class="n">PCOK</span><span class="err">'</span> <span class="n">BY</span> <span class="n">DEF</span> <span class="n">PCOK</span>
</span><span class="line">      <span class="ni">&lt;</span><span class="m">2</span><span class="ni">&gt;</span> <span class="n">IntegrityI</span><span class="err">'</span> <span class="n">BY</span> <span class="n">DEF</span> <span class="n">IntegrityI</span>
</span><span class="line">      <span class="ni">&lt;</span><span class="m">2</span><span class="ni">&gt;</span> <span class="n">NotifyFlagsCorrect</span><span class="err">'</span> <span class="n">BY</span> <span class="n">DEF</span> <span class="n">NotifyFlagsCorrect</span><span class="p">,</span> <span class="n">I</span>
</span><span class="line">      <span class="ni">&lt;</span><span class="m">2</span><span class="ni">&gt;</span> <span class="n">QED</span> <span class="n">BY</span> <span class="n">DEF</span> <span class="n">I</span><span class="p">,</span> <span class="n">SenderInfoAccurate</span><span class="p">,</span> <span class="n">ReaderInfoAccurate</span><span class="p">,</span> <span class="n">CloseOK</span>
</span><span class="line"><span class="ni">&lt;</span><span class="m">1</span><span class="ni">&gt;</span><span class="m">3</span><span class="o">.</span> <span class="n">QED</span>
</span><span class="line">  <span class="n">BY</span> <span class="ni">&lt;</span><span class="m">1</span><span class="ni">&gt;</span><span class="m">1</span><span class="p">,</span> <span class="ni">&lt;</span><span class="m">1</span><span class="ni">&gt;</span><span class="m">2</span> <span class="n">DEF</span> <span class="n">SenderClose</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>A step such as <code>IntegrityI' BY DEF IntegrityI</code> says
&quot;You can see that <code>IntegrityI</code> will be true in the next step just by looking at its definition&quot;.
So this whole lemma is really just saying &quot;it's obvious&quot;.
And TLAPS agrees.</p>
<p>At other times, TLAPS can be maddeningly stupid.
And it can't tell you what the problem is - it can only make things go red.</p>
<p>For example, this fails:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="n">THEOREM</span>
</span><span class="line">  <span class="n">ASSUME</span> <span class="n">pc</span><span class="err">'</span> <span class="ni">=</span> <span class="p">[</span><span class="n">pc</span> <span class="n">EXCEPT</span> <span class="err">!</span><span class="p">[</span><span class="m">1</span><span class="p">]</span> <span class="ni">=</span> <span class="s">&quot;l2&quot;</span><span class="p">],</span>
</span><span class="line">         <span class="n">pc</span><span class="p">[</span><span class="m">2</span><span class="p">]</span> <span class="ni">=</span> <span class="s">&quot;l1&quot;</span>
</span><span class="line">  <span class="n">PROVE</span>  <span class="n">pc</span><span class="err">'</span><span class="p">[</span><span class="m">2</span><span class="p">]</span> <span class="ni">=</span> <span class="s">&quot;l1&quot;</span>
</span><span class="line"><span class="n">OBVIOUS</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>We're trying to say that <code>pc[2]</code> is unchanged, given that <code>pc'</code> is the same as <code>pc</code> except that we changed <code>pc[1]</code>.
The problem is that TLA is an untyped language.
Even though we know we did a mapping update to <code>pc</code>,
that isn't enough (apparently) to conclude that <code>pc</code> is in fact a mapping.
To fix it, you need:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
<span class="line-number">6</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="n">THEOREM</span>
</span><span class="line">  <span class="n">ASSUME</span> <span class="n">pc</span> <span class="s">\in</span> <span class="p">[</span><span class="n">Nat</span> <span class="o">-&gt;</span> <span class="n">STRING</span><span class="p">],</span>
</span><span class="line">         <span class="n">pc</span><span class="err">'</span> <span class="ni">=</span> <span class="p">[</span><span class="n">pc</span> <span class="n">EXCEPT</span> <span class="err">!</span><span class="p">[</span><span class="m">1</span><span class="p">]</span> <span class="ni">=</span> <span class="s">&quot;l2&quot;</span><span class="p">],</span>
</span><span class="line">         <span class="n">pc</span><span class="p">[</span><span class="m">2</span><span class="p">]</span> <span class="ni">=</span> <span class="s">&quot;l1&quot;</span>
</span><span class="line">  <span class="n">PROVE</span>  <span class="n">pc</span><span class="err">'</span><span class="p">[</span><span class="m">2</span><span class="p">]</span> <span class="ni">=</span> <span class="s">&quot;l1&quot;</span>
</span><span class="line"><span class="n">OBVIOUS</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>The extra <code>pc \in [Nat -&gt; STRING]</code> tells TLA the type of the <code>pc</code> variable.
I found missing type information to be the biggest problem when doing proofs,
because you just automatically assume that the computer will know the types of things.
Another example:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="n">THEOREM</span>
</span><span class="line">  <span class="n">ASSUME</span> <span class="n">NEW</span> <span class="n">x</span> <span class="s">\in</span> <span class="n">Nat</span><span class="p">,</span> <span class="n">NEW</span> <span class="n">y</span> <span class="s">\in</span> <span class="n">Nat</span><span class="p">,</span>
</span><span class="line">         <span class="n">x</span> <span class="o">+</span> <span class="n">Min</span><span class="p">(</span><span class="n">y</span><span class="p">,</span> <span class="m">10</span><span class="p">)</span> <span class="ni">=</span> <span class="n">x</span> <span class="o">+</span> <span class="n">y</span>
</span><span class="line">  <span class="n">PROVE</span>  <span class="n">Min</span><span class="p">(</span><span class="n">y</span><span class="p">,</span> <span class="m">10</span><span class="p">)</span> <span class="ni">=</span> <span class="n">y</span>
</span><span class="line"><span class="n">OBVIOUS</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>We're just trying to remove the <code>x + ...</code> from both sides of the equation.
The problem is, TLA doesn't know that <code>Min(y, 10)</code> is a number,
so it doesn't know whether the normal laws of addition apply in this case.
It can't tell you that, though - it can only go red.
Here's the solution:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="n">THEOREM</span>
</span><span class="line">  <span class="n">ASSUME</span> <span class="n">NEW</span> <span class="n">x</span> <span class="s">\in</span> <span class="n">Nat</span><span class="p">,</span> <span class="n">NEW</span> <span class="n">y</span> <span class="s">\in</span> <span class="n">Nat</span><span class="p">,</span>
</span><span class="line">         <span class="n">x</span> <span class="o">+</span> <span class="n">Min</span><span class="p">(</span><span class="n">y</span><span class="p">,</span> <span class="m">10</span><span class="p">)</span> <span class="ni">=</span> <span class="n">x</span> <span class="o">+</span> <span class="n">y</span>
</span><span class="line">  <span class="n">PROVE</span>  <span class="n">Min</span><span class="p">(</span><span class="n">y</span><span class="p">,</span> <span class="m">10</span><span class="p">)</span> <span class="ni">=</span> <span class="n">y</span>
</span><span class="line"><span class="n">BY</span> <span class="n">DEF</span> <span class="n">Min</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>The <code>BY DEF Min</code> tells TLAPS to share the definition of <code>Min</code> with the solvers.
Then they can see that <code>Min(y, 10)</code> must be a natural number too and everything works.</p>
<p>Another annoyance is that sometimes it can't find the right lemma to use,
even when you tell it exactly what it needs.
Here's an extreme case:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
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
<span class="line-number">19</span>
<span class="line-number">20</span>
<span class="line-number">21</span>
<span class="line-number">22</span>
<span class="line-number">23</span>
<span class="line-number">24</span>
<span class="line-number">25</span>
<span class="line-number">26</span>
<span class="line-number">27</span>
<span class="line-number">28</span>
<span class="line-number">29</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="n">LEMMA</span> <span class="n">TransferFacts</span> <span class="ni">==</span>
</span><span class="line">  <span class="n">ASSUME</span> <span class="n">NEW</span> <span class="n">src</span><span class="p">,</span> <span class="n">NEW</span> <span class="n">src2</span><span class="p">,</span>   <span class="c">\* (TLAPS doesn't cope with &quot;NEW VARAIBLE src&quot;)</span>
</span><span class="line">         <span class="n">NEW</span> <span class="n">dst</span><span class="p">,</span> <span class="n">NEW</span> <span class="n">dst2</span><span class="p">,</span>
</span><span class="line">         <span class="n">NEW</span> <span class="n">i</span> <span class="s">\in</span> <span class="m">1</span><span class="o">..</span><span class="n">Len</span><span class="p">(</span><span class="n">src</span><span class="p">),</span>
</span><span class="line">         <span class="n">src</span> <span class="s">\in</span> <span class="n">MESSAGE</span><span class="p">,</span>
</span><span class="line">         <span class="n">dst</span> <span class="s">\in</span> <span class="n">MESSAGE</span><span class="p">,</span>
</span><span class="line">         <span class="n">dst2</span> <span class="ni">=</span> <span class="n">dst</span> <span class="nb">\o</span> <span class="n">Take</span><span class="p">(</span><span class="n">src</span><span class="p">,</span> <span class="n">i</span><span class="p">),</span>
</span><span class="line">         <span class="n">src2</span> <span class="ni">=</span> <span class="n">Drop</span><span class="p">(</span><span class="n">src</span><span class="p">,</span> <span class="n">i</span><span class="p">)</span>
</span><span class="line"> <span class="n">PROVE</span>  <span class="o">/\</span> <span class="n">src2</span> <span class="s">\in</span> <span class="n">MESSAGE</span>
</span><span class="line">        <span class="o">/\</span> <span class="n">Len</span><span class="p">(</span><span class="n">src2</span><span class="p">)</span> <span class="ni">=</span> <span class="n">Len</span><span class="p">(</span><span class="n">src</span><span class="p">)</span> <span class="o">-</span> <span class="n">i</span>
</span><span class="line">        <span class="o">/\</span> <span class="n">dst2</span> <span class="s">\in</span> <span class="n">MESSAGE</span>
</span><span class="line">        <span class="o">/\</span> <span class="n">Len</span><span class="p">(</span><span class="n">dst2</span><span class="p">)</span> <span class="ni">=</span> <span class="n">Len</span><span class="p">(</span><span class="n">dst</span><span class="p">)</span> <span class="o">+</span> <span class="n">i</span>
</span><span class="line">        <span class="o">/\</span> <span class="n">UNCHANGED</span> <span class="p">(</span><span class="n">dst</span> <span class="nb">\o</span> <span class="n">src</span><span class="p">)</span>
</span><span class="line"><span class="n">PROOF</span> <span class="n">OMITTED</span>
</span><span class="line">
</span><span class="line"><span class="n">LEMMA</span> <span class="n">SameAgain</span> <span class="ni">==</span>
</span><span class="line">  <span class="n">ASSUME</span> <span class="n">NEW</span> <span class="n">src</span><span class="p">,</span> <span class="n">NEW</span> <span class="n">src2</span><span class="p">,</span>   <span class="c">\* (TLAPS doesn't cope with &quot;NEW VARAIBLE src&quot;)</span>
</span><span class="line">         <span class="n">NEW</span> <span class="n">dst</span><span class="p">,</span> <span class="n">NEW</span> <span class="n">dst2</span><span class="p">,</span>
</span><span class="line">         <span class="n">NEW</span> <span class="n">i</span> <span class="s">\in</span> <span class="m">1</span><span class="o">..</span><span class="n">Len</span><span class="p">(</span><span class="n">src</span><span class="p">),</span>
</span><span class="line">         <span class="n">src</span> <span class="s">\in</span> <span class="n">MESSAGE</span><span class="p">,</span>
</span><span class="line">         <span class="n">dst</span> <span class="s">\in</span> <span class="n">MESSAGE</span><span class="p">,</span>
</span><span class="line">         <span class="n">dst2</span> <span class="ni">=</span> <span class="n">dst</span> <span class="nb">\o</span> <span class="n">Take</span><span class="p">(</span><span class="n">src</span><span class="p">,</span> <span class="n">i</span><span class="p">),</span>
</span><span class="line">         <span class="n">src2</span> <span class="ni">=</span> <span class="n">Drop</span><span class="p">(</span><span class="n">src</span><span class="p">,</span> <span class="n">i</span><span class="p">)</span>
</span><span class="line"> <span class="n">PROVE</span>  <span class="o">/\</span> <span class="n">src2</span> <span class="s">\in</span> <span class="n">MESSAGE</span>
</span><span class="line">        <span class="o">/\</span> <span class="n">Len</span><span class="p">(</span><span class="n">src2</span><span class="p">)</span> <span class="ni">=</span> <span class="n">Len</span><span class="p">(</span><span class="n">src</span><span class="p">)</span> <span class="o">-</span> <span class="n">i</span>
</span><span class="line">        <span class="o">/\</span> <span class="n">dst2</span> <span class="s">\in</span> <span class="n">MESSAGE</span>
</span><span class="line">        <span class="o">/\</span> <span class="n">Len</span><span class="p">(</span><span class="n">dst2</span><span class="p">)</span> <span class="ni">=</span> <span class="n">Len</span><span class="p">(</span><span class="n">dst</span><span class="p">)</span> <span class="o">+</span> <span class="n">i</span>
</span><span class="line">        <span class="o">/\</span> <span class="n">UNCHANGED</span> <span class="p">(</span><span class="n">dst</span> <span class="nb">\o</span> <span class="n">src</span><span class="p">)</span>
</span><span class="line"><span class="n">BY</span> <span class="n">TransferFacts</span>
</span></code></pre></td></tr></tbody></table></div></figure><p><code>TransferFacts</code> states some useful facts about transferring data between two variables.
You can prove that quite easily.
<code>SameAgain</code> is identical in every way, and just refers to <code>TransferFacts</code> for the proof.
But even with only one lemma to consider - one that matches all the assumptions and conclusions perfectly -
none of the solvers could figure this one out!</p>
<p>My eventual solution was to name the bundle of results.
This works:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
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
<span class="line-number">19</span>
<span class="line-number">20</span>
<span class="line-number">21</span>
<span class="line-number">22</span>
<span class="line-number">23</span>
<span class="line-number">24</span>
<span class="line-number">25</span>
<span class="line-number">26</span>
<span class="line-number">27</span>
<span class="line-number">28</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="n">TransferResults</span><span class="p">(</span><span class="n">src</span><span class="p">,</span> <span class="n">src2</span><span class="p">,</span> <span class="n">dst</span><span class="p">,</span> <span class="n">dst2</span><span class="p">,</span> <span class="n">i</span><span class="p">)</span> <span class="ni">==</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">src2</span> <span class="s">\in</span> <span class="n">MESSAGE</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">Len</span><span class="p">(</span><span class="n">src2</span><span class="p">)</span> <span class="ni">=</span> <span class="n">Len</span><span class="p">(</span><span class="n">src</span><span class="p">)</span> <span class="o">-</span> <span class="n">i</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">dst2</span> <span class="s">\in</span> <span class="n">MESSAGE</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">Len</span><span class="p">(</span><span class="n">dst2</span><span class="p">)</span> <span class="ni">=</span> <span class="n">Len</span><span class="p">(</span><span class="n">dst</span><span class="p">)</span> <span class="o">+</span> <span class="n">i</span>
</span><span class="line">  <span class="o">/\</span> <span class="n">UNCHANGED</span> <span class="p">(</span><span class="n">dst</span> <span class="nb">\o</span> <span class="n">src</span><span class="p">)</span>
</span><span class="line">
</span><span class="line"><span class="n">LEMMA</span> <span class="n">TransferFacts</span> <span class="ni">==</span>
</span><span class="line">  <span class="n">ASSUME</span> <span class="n">NEW</span> <span class="n">src</span><span class="p">,</span> <span class="n">NEW</span> <span class="n">src2</span><span class="p">,</span>
</span><span class="line">         <span class="n">NEW</span> <span class="n">dst</span><span class="p">,</span> <span class="n">NEW</span> <span class="n">dst2</span><span class="p">,</span>
</span><span class="line">         <span class="n">NEW</span> <span class="n">i</span> <span class="s">\in</span> <span class="m">1</span><span class="o">..</span><span class="n">Len</span><span class="p">(</span><span class="n">src</span><span class="p">),</span>
</span><span class="line">         <span class="n">src</span> <span class="s">\in</span> <span class="n">MESSAGE</span><span class="p">,</span>
</span><span class="line">         <span class="n">dst</span> <span class="s">\in</span> <span class="n">MESSAGE</span><span class="p">,</span>
</span><span class="line">         <span class="n">dst2</span> <span class="ni">=</span> <span class="n">dst</span> <span class="nb">\o</span> <span class="n">Take</span><span class="p">(</span><span class="n">src</span><span class="p">,</span> <span class="n">i</span><span class="p">),</span>
</span><span class="line">         <span class="n">src2</span> <span class="ni">=</span> <span class="n">Drop</span><span class="p">(</span><span class="n">src</span><span class="p">,</span> <span class="n">i</span><span class="p">)</span>
</span><span class="line"> <span class="n">PROVE</span>   <span class="n">TransferResults</span><span class="p">(</span><span class="n">src</span><span class="p">,</span> <span class="n">src2</span><span class="p">,</span> <span class="n">dst</span><span class="p">,</span> <span class="n">dst2</span><span class="p">,</span> <span class="n">i</span><span class="p">)</span>
</span><span class="line"><span class="n">PROOF</span> <span class="n">OMITTED</span>
</span><span class="line">
</span><span class="line"><span class="n">LEMMA</span> <span class="n">SameAgain</span> <span class="ni">==</span>
</span><span class="line">  <span class="n">ASSUME</span> <span class="n">NEW</span> <span class="n">src</span><span class="p">,</span> <span class="n">NEW</span> <span class="n">src2</span><span class="p">,</span>
</span><span class="line">         <span class="n">NEW</span> <span class="n">dst</span><span class="p">,</span> <span class="n">NEW</span> <span class="n">dst2</span><span class="p">,</span>
</span><span class="line">         <span class="n">NEW</span> <span class="n">i</span> <span class="s">\in</span> <span class="m">1</span><span class="o">..</span><span class="n">Len</span><span class="p">(</span><span class="n">src</span><span class="p">),</span>
</span><span class="line">         <span class="n">src</span> <span class="s">\in</span> <span class="n">MESSAGE</span><span class="p">,</span>
</span><span class="line">         <span class="n">dst</span> <span class="s">\in</span> <span class="n">MESSAGE</span><span class="p">,</span>
</span><span class="line">         <span class="n">dst2</span> <span class="ni">=</span> <span class="n">dst</span> <span class="nb">\o</span> <span class="n">Take</span><span class="p">(</span><span class="n">src</span><span class="p">,</span> <span class="n">i</span><span class="p">),</span>
</span><span class="line">         <span class="n">src2</span> <span class="ni">=</span> <span class="n">Drop</span><span class="p">(</span><span class="n">src</span><span class="p">,</span> <span class="n">i</span><span class="p">)</span>
</span><span class="line"> <span class="n">PROVE</span>   <span class="n">TransferResults</span><span class="p">(</span><span class="n">src</span><span class="p">,</span> <span class="n">src2</span><span class="p">,</span> <span class="n">dst</span><span class="p">,</span> <span class="n">dst2</span><span class="p">,</span> <span class="n">i</span><span class="p">)</span>
</span><span class="line"><span class="n">BY</span> <span class="n">TransferFacts</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>Most of the art of using TLAPS is in controlling how much information to share with the provers.
Too little (such as failing to provide the definition of <code>Min</code>) and they don't have enough information to find the proof.
Too much (such as providing the definition of <code>TransferResults</code>) and they get overwhelmed and fail to find the proof.</p>
<p>It's all a bit frustrating, but it does work,
and being machine checked does give you some confidence that your proofs are actually correct.</p>
<p>Another, perhaps more important, benefit of machine checked proofs is that
when you decide to change something in the specification you can just ask it to re-check everything.
Go and have a cup of tea, and when you come back it will have highlighted in red any steps that need to be updated.
I made a lot of changes, and this worked very well.</p>
<p>The TLAPS philosophy is that</p>
<blockquote>
<p>If you are concerned with an algorithm or system, you should not be spending your time proving basic mathematical facts.
Instead, you should assert the mathematical theorems you need as assumptions or theorems.</p>
</blockquote>
<p>So even if you can't find a formal proof of every step, you can still use TLAPS to break it down into steps than you
either can prove, or that you think are obvious enough that they don't require a proof.
However, I was able to prove everything I needed for the vchan specification within TLAPS.</p>
<h2>The final specification</h2>
<p>I did a little bit of tidying up at the end.
In particular, I removed the <code>want</code> variable from the specification.
I didn't like it because it doesn't correspond to anything in the OCaml implementation,
and the only place the algorithm uses it is to decide whether to set <code>NotifyWrite</code>,
which I thought might be wrong anyway.</p>
<p>I changed this:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="n">recv_got_len</span><span class="p">:</span>           <span class="n">if</span> <span class="p">(</span><span class="n">have</span> <span class="o">&gt;=</span> <span class="n">want</span><span class="p">)</span> <span class="n">goto</span> <span class="n">recv_read_data</span>
</span><span class="line">                        <span class="n">else</span> <span class="n">NotifyWrite</span> <span class="o">:=</span> <span class="bp">TRUE</span><span class="p">;</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>to:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
<span class="line-number">6</span>
</pre></td><td class="code"><pre><code class="tla"><span class="line"><span class="n">recv_got_len</span><span class="p">:</span>           <span class="n">either</span> <span class="ni">{</span>
</span><span class="line">                          <span class="n">if</span> <span class="p">(</span><span class="n">have</span> <span class="ni">&gt;</span> <span class="m">0</span><span class="p">)</span> <span class="n">goto</span> <span class="n">recv_read_data</span>
</span><span class="line">                          <span class="n">else</span> <span class="n">NotifyWrite</span> <span class="o">:=</span> <span class="bp">TRUE</span><span class="p">;</span>
</span><span class="line">                        <span class="ni">}</span> <span class="n">or</span> <span class="ni">{</span>
</span><span class="line">                          <span class="n">NotifyWrite</span> <span class="o">:=</span> <span class="bp">TRUE</span><span class="p">;</span>
</span><span class="line">                        <span class="ni">}</span><span class="p">;</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>That always allows an implementation to set <code>NotifyWrite</code> if it wants to,
or to skip that step just as long as <code>have &gt; 0</code>.
That covers the current C behaviour, my proposed C behaviour, and the OCaml implementation.
It also simplifies the invariant, and even made the proofs shorter!</p>
<p>I put the final specification online at <a href="https://github.com/talex5/spec-vchan">spec-vchan</a>.
I also configured Travis CI to check all the models and verify all the proofs.
That's useful because sometimes I'm too impatient to recheck everything on my laptop before pushing updates.</p>
<p>You can generate a PDF version of the specification with <code>make pdfs</code>.
Expressions there can be a little easier to read because they use proper symbols, but
it also breaks things up into pages, which is highly annoying.
It would be nice if it could omit the proofs too, as they're really only useful if you're trying to edit them.
I'd rather just see the statement of each theorem.</p>
<h2>The original bug</h2>
<p>With my new understanding of vchan, I couldn't see anything obvious wrong with the C code
(at least, as long as you keep the connection open, which the firewall does).</p>
<p>I then took a look at <a href="https://github.com/mirage/ocaml-vchan">ocaml-vchan</a>.
The first thing I noticed was that someone had commented out all the memory barriers,
noting in the Git log that they weren't needed on x86.
I am using x86, so that's not it, but I filed a bug about it anyway: <a href="https://github.com/mirage/ocaml-vchan/issues/122">Missing memory barriers</a>.</p>
<p>The other strange thing I saw was the behaviour of the <code>read</code> function.
It claims to implement the Mirage <code>FLOW</code> interface, which says that <code>read</code>
&quot;blocks until some data is available and returns a fresh buffer containing it&quot;.
However, looking at the code, what it actually does is to return a pointer directly into the shared buffer.
It then delays updating the consumer counter until the <em>next</em> call to <em>read</em>.
That's rather dangerous, and I filed another bug about that: <a href="https://github.com/mirage/ocaml-vchan/issues/119">Read has very surprising behaviour</a>.
However, when I checked the <code>mirage-qubes</code> code, it just takes this buffer and <a href="https://github.com/mirage/mirage-qubes/blob/ea900d5ac93278a43150cd21ced407806416681c/lib/msg_chan.ml#L34">makes a copy of it</a> immediately.
So that's not the bug either.</p>
<p>Also, the original bug report mentioned a 10 second timeout,
and neither the C implementation nor the OCaml one had any timeouts.
Time to look at QubesDB itself.</p>
<p>QubesDB accepts messages from either the guest VM (the firewall) or from local clients connected over Unix domain sockets.
The basic structure is:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
<span class="line-number">6</span>
</pre></td><td class="code"><pre><code class="python"><span class="line"><span class="k">while</span> <span class="kc">True</span><span class="p">:</span>
</span><span class="line">  <span class="k">await</span> <span class="n">vchan</span> <span class="n">event</span><span class="p">,</span> <span class="n">local</span> <span class="n">client</span> <span class="n">data</span><span class="p">,</span> <span class="ow">or</span> <span class="mi">10</span> <span class="n">second</span> <span class="n">timeout</span>
</span><span class="line">  <span class="k">while</span> <span class="n">vchan</span><span class="o">.</span><span class="n">receive_buffer</span> <span class="n">non</span><span class="o">-</span><span class="n">empty</span><span class="p">:</span>
</span><span class="line">    <span class="n">handle_vchan_data</span><span class="p">()</span>
</span><span class="line">  <span class="k">for</span> <span class="n">each</span> <span class="n">ready</span> <span class="n">client</span><span class="p">:</span>
</span><span class="line">    <span class="n">handle_client_data</span><span class="p">()</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>The suspicion was that we were missing a vchan event,
but then it was discovering that there was data in the buffer anyway due to the timeout.
Looking at the code, it does seem to me that there is a possible race condition here:</p>
<ol>
<li>A local client asks to send some data.
</li>
<li><code>handle_client_data</code> sends the data to the firewall using a blocking write.
</li>
<li>The firewall sends a message to QubesDB at the same time and signals an event because the firewall-to-db buffer has data.
</li>
<li>QubesDB gets the event but ignores it because it's doing a blocking write and there's still no space in the db-to-firewall direction.
</li>
<li>The firewall updates its consumer counter and signals another event, because the buffer now has space.
</li>
<li>The blocking write completes and QubesDB returns to the main loop.
</li>
<li>QubesDB goes to sleep for 10 seconds, without checking the buffer.
</li>
</ol>
<p>I don't think this is the cause of the bug though,
because the only messages the firewall might be sending here are <code>QDB_RESP_OK</code> messages,
and QubesDB just discards such messages.</p>
<p>I managed to reproduce the problem myself,
and saw that in fact QubesDB doesn't make any progress due to the 10 second timeout.
It just tries to go back to sleep for another 10 seconds and then
immediately gets woken up by a message from a local client.
So, it looks like QubesDB is only sending updates every 10 seconds because its client, <code>qubesd</code>,
is only asking it to send updates every 10 seconds!
And looking at the <code>qubesd</code> logs, I saw stacktraces about libvirt failing to attach network devices, so
I read the Xen network device attachment specification to check that the firewall implemented that correctly.</p>
<p>I'm kidding, of course.
There isn't any such specification.
But maybe this blog post will inspire someone to write one...</p>
<h2>Conclusions</h2>
<p>As users of open source software, we're encouraged to look at the source code and check that it's correct ourselves.
But that's pretty difficult without a specification saying what things are <em>supposed</em> to do.
Often I deal with this by learning just enough to fix whatever bug I'm working on,
but this time I decided to try making a proper specification instead.
Making the TLA specification took rather a long time, but it was quite pleasant.
Hopefully the next person who needs to know about vchan will appreciate it.</p>
<p>A TLA specification generally defines two sets of behaviours.
The first is the set of desirable behaviours (e.g. those where the data is delivered correctly).
This definition should clearly explain what users can expect from the system.
The second defines the behaviours of a particular algorithm.
This definition should make it easy to see how to implement the algorithm.
The TLC model checker can check that the algorithm's behaviours are all acceptable,
at least within some defined limits.</p>
<p>Writing a specification using the TLA notation forces us to be precise about what we mean.
For example, in a prose specification we might say &quot;data sent will eventually arrive&quot;, but in an
executable TLA specification we're forced to clarify what happens if the connection is closed.
I would have expected that if a sender writes some data and then closes the connection then the data would still arrive,
but the C implementation of vchan does not always ensure that.
The TLC model checker can find a counter-example showing how this can fail in under a minute.</p>
<p>To explain why the algorithm always works, we need to find an inductive invariant.
The TLC model checker can help with this,
by presenting examples of unreachable states that satisfy the invariant but don't preserve it after taking a step.
We must add constraints to explain why these states are invalid.
This was easy for the <code>Integrity</code> invariant, which explains why we never receive incorrect data, but
I found it much harder to prove that the system cannot deadlock.
I suspect that the original designer of a system would find this step easy, as presumably they already know why it works.</p>
<p>Once we have found an inductive invariant, we can write a formal machine-checked proof that the invariant is always true.
Although TLAPS doesn't allow us to prove liveness properties directly,
I was able to prove various interesting things about the algorithm: it doesn't deadlock; when the sender is blocked, the receiver can read everything that has been sent; and when the receiver is blocked, the sender can fill the entire buffer.</p>
<p>Writing formal proofs is a little tedious, largely because TLA is an untyped language.
However, there is nothing particularly difficult about it,
once you know how to work around various limitations of the proof checkers.</p>
<p>You might imagine that TLA would only work on very small programs like libvchan, but this is not the case.
It's just a matter of deciding what to specify in detail.
For example, in this specification I didn't give any details about how ring buffers work,
but instead used a single <code>Buffer</code> variable to represent them.
For a specification of a larger system using vchan, I would model each channel using just <code>Sent</code> and <code>Got</code>
and an action that transferred some of the difference on each step.</p>
<p>The TLA Toolbox has some rough edges.
The ones I found most troublesome were: the keyboard shortcuts frequently stop working;
when a temporal property is violated, it doesn't tell you which one it was; and
the model explorer tooltips appear right under the mouse pointer,
preventing you from scrolling with the mouse wheel.
It also likes to check its &quot;news feed&quot; on a regular basis.
It can't seem to do this at the same time as other operations,
and if you're in the middle of a particularly complex proof checking operation,
it will sometimes suddenly pop up a box suggesting that you cancel your job,
so that it can get back to reading the news.</p>
<p>However, it is improving.
In the latest versions, when you get a syntax error, it now tells you where in the file the error is.
And pressing Delete or Backspace while editing no longer causes it to crash and lose all unsaved data.
In general I feel that the TLA Toolbox is quite usable now.
If I were designing a new protocol, I would certainly use TLA to help with the design.</p>
<p>TLA does not integrate with any language type systems, so even after you have a specification
you still need to check manually that your code matches the spec.
It would be nice if you could check this automatically, somehow.</p>
<p>One final problem is that whenever I write a TLA specification, I feel the need to explain first what TLA is.
Hopefully it will become more popular and that problem will go away.</p>
<p>Update 2019-01-10: Marek Marczykowski-G&oacute;recki told me that the state model for network devices is the same as
the one for block devices, which is documented in the <code>blkif.h</code> block device header file, and provided libvirt debugging help -
so the bug is <a href="https://github.com/mirage/mirage-qubes/issues/25#issuecomment-452921207">now fixed</a>!</p>

