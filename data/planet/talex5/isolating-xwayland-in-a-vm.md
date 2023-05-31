---
title: Isolating Xwayland in a VM
description:
url: https://roscidus.com/blog/blog/2021/10/30/xwayland/
date: 2021-10-30T10:00:00-00:00
preview_image:
featured:
authors:
- Thomas Leonard
---

<p>In my last post, <a href="https://roscidus.com/blog/blog/2021/03/07/qubes-lite-with-kvm-and-wayland/">Qubes-lite with KVM and Wayland</a>, I described setting up a Qubes-inspired Linux system that runs applications in virtual machines. A Wayland proxy running in each VM connects its applications to the host Wayland compositor over virtwl, allowing them to appear on the desktop alongside normal host applications. In this post, I extend this to support X11 applications using Xwayland.</p>

<p><strong>Table of Contents</strong></p>
<ul>
<li><a href="https://roscidus.com/#overview">Overview</a>
</li>
<li><a href="https://roscidus.com/#introduction-to-x11">Introduction to X11</a>
</li>
<li><a href="https://roscidus.com/#running-xwayland">Running Xwayland</a>
</li>
<li><a href="https://roscidus.com/#the-x11-protocol">The X11 protocol</a>
</li>
<li><a href="https://roscidus.com/#initialising-the-window-manager">Initialising the window manager</a>
</li>
<li><a href="https://roscidus.com/#windows">Windows</a>
</li>
<li><a href="https://roscidus.com/#performance">Performance</a>
</li>
<li><a href="https://roscidus.com/#pointer-events">Pointer events</a>
</li>
<li><a href="https://roscidus.com/#keyboard-events">Keyboard events</a>
</li>
<li><a href="https://roscidus.com/#pointer-cursor">Pointer cursor</a>
</li>
<li><a href="https://roscidus.com/#selections">Selections</a>
</li>
<li><a href="https://roscidus.com/#drag-and-drop">Drag-and-drop</a>
</li>
<li><a href="https://roscidus.com/#bonus-features">Bonus features</a>
<ul>
<li><a href="https://roscidus.com/#hidpi-works">HiDPI works</a>
</li>
<li><a href="https://roscidus.com/#ring-buffer-logging">Ring-buffer logging</a>
</li>
<li><a href="https://roscidus.com/#vim-windows-open-correctly">Vim windows open correctly</a>
</li>
<li><a href="https://roscidus.com/#copy-and-paste-without-m-characters">Copy-and-paste without ^M characters</a>
</li>
</ul>
</li>
<li><a href="https://roscidus.com/#conclusions">Conclusions</a>
</li>
</ul>
<p>( this post also appeared on <a href="https://news.ycombinator.com/item?id=29645743">Hacker News</a> )</p>
<h2>Overview</h2>
<p>A graphical desktop typically allows running multiple applications on a single display
(e.g. by showing each application in a separate window).
Client applications connect to a server process (usually on the same machine) and ask it to display their windows.</p>
<p>Until recently, this service was an <em>X server</em>, and applications would communicate with it using the X11 protocol.
However, on newer systems the display is managed by a <em>Wayland compositor</em>, using the Wayland protocol.</p>
<p>Many older applications haven't been updated yet.
<a href="https://wayland.freedesktop.org/docs/html/ch05.html">Xwayland</a> can be used to allow unmodified X11 applications to run in a Wayland desktop environment.
However, setting this up wasn't as easy as I'd hoped.
Ideally, Xwayland would completely isolate the Wayland compositor from needing to know anything about X11:</p>
<p><span class="caption-wrapper center"><img src="https://roscidus.com/blog/images/xwayland/fantasy-xwayland.png" title="Fantasy Xwayland architecture" class="caption"/><span class="caption-text">Fantasy Xwayland architecture</span></span></p>
<p>However, it doesn't work like this.
Xwayland handles X11 drawing operations, but it doesn't handle lots of other details, including window management (e.g. telling the Wayland compositor what the window title should be), copy-and-paste, and selections.
Instead, the Wayland compositor is supposed to connect back to Xwayland over the X11 protocol and act as an X11 window manager to provide the missing features:</p>
<p><span class="caption-wrapper center"><img src="https://roscidus.com/blog/images/xwayland/real-xwayland.png" title="Actual Xwayland architecture" class="caption"/><span class="caption-text">Actual Xwayland architecture</span></span></p>
<p>This is a problem for several reasons:</p>
<ol>
<li>It means that every Wayland compositor has to implement not only the new Wayland protocol, but also the old X11 protocol.
</li>
<li>The compositor is part of the trusted computing base (it sees all your keystrokes and window contents)
and this adds a whole load of legacy code that you'd need to audit to have confidence in it.
</li>
<li>It doesn't work when running applications in VMs,
because each VM needs its own Xwayland service and existing compositors can only manage one.
</li>
</ol>
<p>Because Wayland (unlike X11) doesn't allow applications to mess with other applications' windows,
we can't have a third-party application act as the X11 window manager.
It wouldn't have any way to ask the compositor to put Xwayland's surfaces into a window frame, because Xwayland is a separate application.</p>
<p>There is another way to do it, however.
As I mentioned in the last post,
I already had to write a Wayland proxy (<a href="https://github.com/talex5/wayland-proxy-virtwl">wayland-proxy-virtwl</a>) to run in each VM
and relay Wayland messages over virtwl, so I decided to extend it to handle Xwayland too.
As a bonus, the proxy can also be used even without VMs, avoiding the need for any X11 support in Wayland compositors at all.
In fact, I found that doing this avoided several bugs in Sway's built-in Xwayland support.</p>
<p><a href="https://chromium.googlesource.com/chromiumos/platform2/+/refs/heads/main/vm_tools/sommelier/">Sommelier</a> already has support for this, but it doesn't work for the applications I want to use.
For example, popup menus appear in the center of the screen, text selections don't work, and it generally crashes after a few seconds (often with the error <code>xdg_surface has never been configured</code>).
So instead I'd been using <code>ssh -Y vm</code> from the host to forward X11 connections to the host's Xwayland,
managed by Sway.
That works, but it's not at all secure.</p>
<h2>Introduction to X11</h2>
<p>Unlike Wayland, where applications are mostly unaware of each other, X is much more collaborative.
The X server maintains a tree of windows (rectangles) and the applications manipulate it.
The root of the tree is called the <em>root window</em> and fills the screen.
You can see the tree using the <code>xwininfo</code> command, like this:</p>
<pre><code>$ xwininfo -tree -root

xwininfo: Window id: 0x47 (the root window) (has no name)

  Root window id: 0x47 (the root window) (has no name)
  Parent window id: 0x0 (none)
     9 children:
     0x800112 &quot;~/Projects/wayland/wayland-proxy-virtwl&quot;: (&quot;ROX-Filer&quot; &quot;ROX-Filer&quot;)  2184x2076+0+0  +0+0
        1 child:
        0x800113 (has no name): ()  1x1+-1+-1  +-1+-1
     0x800123 (has no name): ()  1x1+-1+-1  +-1+-1
     0x800003 &quot;ROX-Filer&quot;: ()  10x10+-100+-100  +-100+-100
     0x800001 &quot;ROX-Filer&quot;: (&quot;ROX-Filer&quot; &quot;ROX-Filer&quot;)  10x10+10+10  +10+10
        1 child:
        0x800002 (has no name): ()  1x1+-1+-1  +9+9
     0x600002 &quot;main.ml (~/Projects/wayland/wayland-proxy-virtwl) - GVIM1&quot;: (&quot;gvim&quot; &quot;Gvim&quot;)  1648x1012+0+0  +0+0
        1 child:
        0x600003 (has no name): ()  1x1+-1+-1  +-1+-1
     0x600007 (has no name): ()  1x1+-1+-1  +-1+-1
     0x600001 &quot;Vim&quot;: (&quot;gvim&quot; &quot;Gvim&quot;)  10x10+10+10  +10+10
     0x200002 (has no name): ()  1x1+0+0  +0+0
     0x200001 (has no name): ()  1x1+0+0  +0+0
</code></pre>
<p>This tree shows the windows of two X11 applications, ROX-Filer and GVim,
as well as various invisible utility windows (mostly 1x1 or 10x10 pixels in size).</p>
<p>Applications can create, move, resize and destroy windows, draw into them, and request events from them.
The X server also allows arbitrary data to be attached to windows in <em>properties</em>.
You can see a window's properties with <code>xprop</code>. Here are some of the properties on the GVim window:</p>
<pre><code>$ xprop -id 0x600002
WM_HINTS(WM_HINTS):
		Client accepts input or input focus: True
		Initial state is Normal State.
		window id # of group leader: 0x600001
_NET_WM_WINDOW_TYPE(ATOM) = _NET_WM_WINDOW_TYPE_NORMAL
WM_NORMAL_HINTS(WM_SIZE_HINTS):
		program specified minimum size: 188 by 59
		program specified base size: 188 by 59
		window gravity: NorthWest
WM_CLASS(STRING) = &quot;gvim&quot;, &quot;Gvim&quot;
WM_NAME(STRING) = &quot;main.ml (~/Projects/wayland/wayland-proxy-virtwl) - GVIM1&quot;
...
</code></pre>
<p>The X server itself doesn't know anything about e.g. window title bars.
Instead, a <em>window manager</em> process connects and handles that.
A window manager is just another X11 application.
It asks to be notified when an application tries to show (&quot;map&quot;) a window inside the root,
and when that happens it typically creates a slightly larger window (with room for the title bar, etc)
and moves the other application's window inside that.</p>
<p>This design gives X a lot of flexibility.
All kinds of window managers have been implemented, without needing to change the X server itself.
However, it is very bad for security. For example:</p>
<ol>
<li>Open an xterm.
</li>
<li>Use <code>xwininfo</code> to find its window ID (you need the nested child window, not the top-level one).
</li>
<li>Run <code>xev -id 0x80001b -event keyboard</code> in another window (using the ID you got above).
</li>
<li>Use <code>sudo</code> or similar inside <code>xterm</code> and enter a password.
</li>
</ol>
<p>As you type the password into <code>xterm</code>, you should see the characters being captured by <code>xev</code>.
An X application can easily spy on another application, send it synthetic events, etc.</p>
<h2>Running Xwayland</h2>
<p>Xwayland is a version of the <a href="https://www.x.org/wiki/">xorg</a> X server that treats Wayland as its display hardware.
If you run it as e.g. <code>Xwayland :1</code> then it opens a single Wayland window corresponding to the X root window,
and you can use it as a nested desktop.
This isn't very useful, because these windows don't fit in with the rest of your desktop.
Instead, it is normally used in <em>rootless</em> mode, where each child of the X root window may have its own Wayland window.</p>
<pre><code>$ WAYLAND_DEBUG=1 Xwayland :1 -rootless
[3991465.523]  -&gt; wl_display@1.get_registry(new id wl_registry@2)
[3991465.531]  -&gt; wl_display@1.sync(new id wl_callback@3)
...
</code></pre>
<p>When run this way, however, no windows actually appear.
If we run <code>DISPLAY=:1 xterm</code> then we see Xwayland creating some buffers, but no surfaces:</p>
<pre><code>[4076460.506]  -&gt; wl_shm@4.create_pool(new id wl_shm_pool@15, fd 9, 540)
[4076460.520]  -&gt; wl_shm_pool@15.create_buffer(new id wl_buffer@24, 0, 9, 15, 36, 0)
[4076460.526]  -&gt; wl_shm_pool@15.destroy()
...
</code></pre>
<p>We need to run Xwayland as <code>Xwayland :1 -rootless -wm FD</code>, where FD is a socket we will use to speak the X11 protocol and act as a window manager.</p>
<p>It's a little hard to find information about Xwayland's rootless mode, because &quot;rootless&quot; has two separate common meanings in xorg:</p>
<ol>
<li>Running xorg without root privileges.
</li>
<li>Using xorg's miext/rootless extension to display application windows on some other desktop.
</li>
</ol>
<p>After a while, it became clear that Xwayland's rootless mode isn't either of these, but a third xorg feature also called &quot;rootless&quot;.</p>
<h2>The X11 protocol</h2>
<p><a href="https://xcb.freedesktop.org/">libxcb</a> provides C bindings to the X11 protocol, but I wanted to program in OCaml.
Luckily, the <a href="https://www.x.org/releases/X11R7.7/doc/xproto/x11protocol.html">X11 protocol</a> is well documented, and generating the messages directly didn't look any harder than binding libxcb,
so I wrote a little OCaml library to do this (<a href="https://github.com/talex5/wayland-proxy-virtwl/blob/master/x11/x11.mli">ocaml-x11</a>).</p>
<p>At first, I hard-coded the messages. For example, here's the code to delete a property on a window:</p>
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
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">module</span> <span class="nc">Delete</span> <span class="o">=</span> <span class="k">struct</span>
</span><span class="line">  <span class="o">[%%</span><span class="n">cstruct</span>
</span><span class="line">    <span class="k">type</span> <span class="n">req</span> <span class="o">=</span> <span class="o">{</span>
</span><span class="line">      <span class="n">window</span> <span class="o">:</span> <span class="n">uint32_t</span><span class="o">;</span>
</span><span class="line">      <span class="n">property</span> <span class="o">:</span> <span class="n">uint32_t</span><span class="o">;</span>
</span><span class="line">    <span class="o">}</span> <span class="o">[@@</span><span class="n">little_endian</span><span class="o">]</span>
</span><span class="line">  <span class="o">]</span>
</span><span class="line">
</span><span class="line">  <span class="k">let</span> <span class="n">send</span> <span class="n">t</span> <span class="n">window</span> <span class="n">property</span> <span class="o">=</span>
</span><span class="line">    <span class="nn">Request</span><span class="p">.</span><span class="n">send_only</span> <span class="n">t</span> <span class="o">~</span><span class="n">major</span><span class="o">:</span><span class="mi">19</span> <span class="n">sizeof_req</span> <span class="o">@@</span> <span class="k">fun</span> <span class="n">r</span> <span class="o">-&gt;</span>
</span><span class="line">    <span class="n">set_req_window</span> <span class="n">r</span> <span class="n">window</span><span class="o">;</span>
</span><span class="line">    <span class="n">set_req_property</span> <span class="n">r</span> <span class="n">property</span>
</span><span class="line"><span class="k">end</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>I'm using the <a href="https://github.com/mirage/ocaml-cstruct">cstruct</a> syntax extension to let me define the exact layout of the message body.
Here, it generates <code>sizeof_req</code>, <code>set_req_window</code> and <code>set_req_property</code> automatically.</p>
<p>After a bit, I discovered that there are XML files in <a href="https://gitlab.freedesktop.org/xorg/proto/xcbproto">xcbproto</a> describing the X11 protocol.
This provides a Python library for parsing the XML,
which you can use by writing a Python script for your language of choice.
For example, this <a href="https://gitlab.freedesktop.org/xorg/lib/libxcb/-/blob/master/src/c_client.py">glorious 3394 line Python script</a>
generates the C bindings.
After studying this script carefully, I decided that hard-coding everything wasn't so bad after all.</p>
<p>I ended up having to implement more messages than I expected,
including some surprising ones like <code>OpenFont</code> (see <a href="https://github.com/talex5/wayland-proxy-virtwl/blob/master/x11/x11.mli">x11.mli</a> for the final list).
My implementation came to 1754 lines of OCaml,
which is quite a bit shorter than the Python generator script,
so I guess I still came out ahead!</p>
<p>In the X11 protocol, client applications send <em>requests</em> and the server sends <em>replies</em>, <em>errors</em> and <em>events</em>.
Most requests don't produce replies, but can produce errors.
Replies and errors are returned immediately, so if you see a response to a later request, you know all previous ones succeeded.
If you care about whether a request succeeded, you may need to send a dummy message that generates a reply after it.
Since message sequence numbers are 16-bit, after sending 0xffff consecutive requests without replies,
you should send a dummy one with a reply to resynchronise
(but window management involves lots of round-trips, so this isn't likely to be a problem for us).
Events can be sent by the server at any time.</p>
<p>Unlike Wayland, which is very regular, X11 has various quirks.
For example, every event has a sequence number at offset 2, except for <code>KeymapNotify</code>.</p>
<h2>Initialising the window manager</h2>
<p>Using <code>Xwayland -wm FD</code> actually prevents any client applications from connecting at all at first,
because Xwayland then waits for the window manager to be ready before accepting any client connections.</p>
<p>To fix that, we need to claim ownership of the <code>WM_S0</code> <em>selection</em>.
A &quot;selection&quot; is something that can be owned by only one application at a time.
Selections were originally used to track ownership of the currently-selected text, and later also used for the clipboard.
<code>WM_S0</code> means &quot;Window Manager for Screen 0&quot; (Xwayland only has one screen).</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="c">(* Become the window manager. This allows other clients to connect. *)</span>
</span><span class="line"><span class="k">let</span><span class="o">*</span> <span class="n">wm_sn</span> <span class="o">=</span> <span class="n">intern</span> <span class="n">t</span> <span class="o">~</span><span class="n">only_if_exists</span><span class="o">:</span><span class="bp">false</span> <span class="o">(</span><span class="s2">&quot;WM_S&quot;</span> <span class="o">^</span> <span class="n">string_of_int</span> <span class="n">i</span><span class="o">)</span> <span class="k">in</span>
</span><span class="line"><span class="nn">X11</span><span class="p">.</span><span class="nn">Selection</span><span class="p">.</span><span class="n">set_owner</span> <span class="n">x11</span> <span class="o">~</span><span class="n">owner</span><span class="o">:(</span><span class="nc">Some</span> <span class="n">root</span><span class="o">)</span> <span class="o">~</span><span class="n">timestamp</span><span class="o">:`</span><span class="nc">CurrentTime</span> <span class="n">wm_sn</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>Instead of passing things like <code>WM_S0</code> as strings in each request, X11 requires us to first <em>intern</em> the string.
This returns a unique 32-bit ID for it, which we use in future messages.
Because <code>intern</code> may require a round-trip to the server, it returns a promise,
and so we use <code>let*</code> instead of <code>let</code> to wait for that to resolve before continuing.
<code>let*</code> is defined in the <code>Lwt.Syntax</code> module, as an alternative to the more traditional <code>&gt;&gt;=</code> notation.</p>
<p>This lets our clients connect. However, Xwayland still isn't creating any Wayland surfaces.
By reading the Sommelier code and stepping through Xwayland with a debugger, I found that I needed to enable the <a href="https://www.x.org/wiki/guide/extensions/">Composite</a> extension.</p>
<p>Composite was originally intended to speed up redraw operations, by having the server keep a copy of every top-level window's pixels
(even when obscured), so that when you move a window it can draw it right away without asking the application for help.
The application's drawing operations go to the window's buffer, and then the buffer is copied to the screen, either automatically by the X server
or manually by the window manager.
Xwayland reuses this mechanism, by turning each window buffer into a Wayland surface.
We just need to turn that on:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">let</span><span class="o">*</span> <span class="n">composite</span> <span class="o">=</span> <span class="nn">X11</span><span class="p">.</span><span class="nn">Composite</span><span class="p">.</span><span class="n">init</span> <span class="n">x11</span> <span class="k">in</span>
</span><span class="line"><span class="k">let</span><span class="o">*</span> <span class="bp">()</span> <span class="o">=</span> <span class="nn">X11</span><span class="p">.</span><span class="nn">Composite</span><span class="p">.</span><span class="n">redirect_subwindows</span> <span class="n">composite</span> <span class="o">~</span><span class="n">window</span><span class="o">:</span><span class="n">root</span> <span class="o">~</span><span class="n">update</span><span class="o">:`</span><span class="nc">Manual</span> <span class="k">in</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>This says that every child of the root window should use this system.
Finally, we see Xwayland creating Wayland surfaces:</p>
<pre><code>-&gt; wl_compositor@5.create_surface id:+28
</code></pre>
<p>Now we just need to make them appear on the screen!</p>
<h2>Windows</h2>
<p>As usual for Wayland, we need to create a role object and attach it to the surface.
This tells Wayland whether the surface is a window or a dialog, for example, and lets us set the title, etc.</p>
<p>But first we have a problem: we need to know which X11 window corresponds to each Wayland surface.
For example, we need the title, which is stored in a property on the X11 window.
Xwayland does this by sending the new window a <em>ClientMessage</em> event of type <code>WL_SURFACE_ID</code> containing the Wayland ID.
We don't get this message by default, but it seems that selecting <code>SubstructureRedirect</code> on the root does the trick.</p>
<p><code>SubstructureRedirect</code> is used by window managers to intercept attempts by other applications to change the children of the root window.
When an application asks the server to e.g. map a window, the server just forwards the request to the window manager.
Operations performed by the window manager itself do not get redirected, so it can just perform the same request the client wanted, or
make any changes it requires.</p>
<p>In our case, we don't actually need to modify the request, so we just re-perform the original <code>map</code> operation:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
<span class="line-number">6</span>
<span class="line-number">7</span>
<span class="line-number">8</span>
<span class="line-number">9</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">let</span> <span class="n">event_handler</span> <span class="o">=</span> <span class="k">object</span> <span class="o">(_</span> <span class="o">:</span> <span class="nn">X11</span><span class="p">.</span><span class="nn">Event</span><span class="p">.</span><span class="n">handler</span><span class="o">)</span>
</span><span class="line">  <span class="k">method</span> <span class="n">map_request</span> <span class="o">~</span><span class="n">window</span> <span class="o">=</span> <span class="nn">X11</span><span class="p">.</span><span class="nn">Window</span><span class="p">.</span><span class="n">map</span> <span class="n">x11</span> <span class="n">window</span>
</span><span class="line">
</span><span class="line">  <span class="k">method</span> <span class="n">client_message</span> <span class="o">~</span><span class="n">window</span> <span class="o">~</span><span class="n">ty</span> <span class="n">body</span> <span class="o">=</span>
</span><span class="line">      <span class="k">if</span> <span class="n">ty</span> <span class="o">=</span> <span class="n">wl_surface_id</span> <span class="k">then</span> <span class="o">(</span>
</span><span class="line">        <span class="k">let</span> <span class="n">wayland_id</span> <span class="o">=</span> <span class="nn">Cstruct</span><span class="p">.</span><span class="nn">LE</span><span class="p">.</span><span class="n">get_uint32</span> <span class="n">body</span> <span class="mi">0</span> <span class="k">in</span>
</span><span class="line">        <span class="nn">Log</span><span class="p">.</span><span class="n">info</span> <span class="o">(</span><span class="k">fun</span> <span class="n">f</span> <span class="o">-&gt;</span> <span class="n">f</span> <span class="s2">&quot;X window %a corresponds to Wayland surface %ld&quot;</span> <span class="nn">X11</span><span class="p">.</span><span class="nn">Window</span><span class="p">.</span><span class="n">pp</span> <span class="n">window</span> <span class="n">wayland_id</span><span class="o">);</span>
</span><span class="line">        <span class="n">pair_when_ready</span> <span class="o">~</span><span class="n">x11</span> <span class="n">t</span> <span class="n">window</span> <span class="n">wayland_id</span>
</span><span class="line">      <span class="o">)</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>Having two separate connections to Xwayland is quite annoying, because messages can arrive in any order.
We might get the X11 <code>ClientMessage</code> first and need to wait for the Wayland <code>create_surface</code>, or we might get the <code>create_surface</code> first
and need to wait for the <code>ClientMessage</code>.</p>
<p>An added complication is that not all Wayland surfaces correspond to X11 windows.
For example, Xwayland also creates surfaces representing cursor shapes, and these don't have X11 windows.
However, when we get the <code>ClientMessage</code> we <em>can</em> be sure that a Wayland message is on the way,
so I just pause the X11 event handling until that has arrived:</p>
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
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="c">(* We got an X11 message saying X11 [window] corresponds to Wayland surface [wayland_id].</span>
</span><span class="line"><span class="c">   Turn [wayland_id] into an xdg_surface. If we haven't seen that surface yet, wait until it appears</span>
</span><span class="line"><span class="c">   on the Wayland socket. *)</span>
</span><span class="line"><span class="k">let</span> <span class="k">rec</span> <span class="n">pair_when_ready</span> <span class="o">~</span><span class="n">x11</span> <span class="n">t</span> <span class="n">window</span> <span class="n">wayland_id</span> <span class="o">=</span>
</span><span class="line">  <span class="k">match</span> <span class="nn">Hashtbl</span><span class="p">.</span><span class="n">find_opt</span> <span class="n">t</span><span class="o">.</span><span class="n">unpaired</span> <span class="n">wayland_id</span> <span class="k">with</span>
</span><span class="line">  <span class="o">|</span> <span class="nc">None</span> <span class="o">-&gt;</span>
</span><span class="line">    <span class="nn">Log</span><span class="p">.</span><span class="n">info</span> <span class="o">(</span><span class="k">fun</span> <span class="n">f</span> <span class="o">-&gt;</span> <span class="n">f</span> <span class="s2">&quot;Unknown Wayland object %ld; waiting for surface to be created...&quot;</span> <span class="n">wayland_id</span><span class="o">);</span>
</span><span class="line">    <span class="k">let</span><span class="o">*</span> <span class="bp">()</span> <span class="o">=</span> <span class="nn">Lwt_condition</span><span class="p">.</span><span class="n">wait</span> <span class="n">t</span><span class="o">.</span><span class="n">unpaired_added</span> <span class="k">in</span>
</span><span class="line">    <span class="n">pair_when_ready</span> <span class="o">~</span><span class="n">x11</span> <span class="n">t</span> <span class="n">window</span> <span class="n">wayland_id</span>
</span><span class="line">  <span class="o">|</span> <span class="nc">Some</span> <span class="o">{</span> <span class="n">client_surface</span> <span class="o">=</span> <span class="o">_;</span> <span class="n">host_surface</span><span class="o">;</span> <span class="n">set_configured</span> <span class="o">}</span> <span class="o">-&gt;</span>
</span><span class="line">    <span class="nn">Log</span><span class="p">.</span><span class="n">info</span> <span class="o">(</span><span class="k">fun</span> <span class="n">f</span> <span class="o">-&gt;</span> <span class="n">f</span> <span class="s2">&quot;Setting up Wayland surface %ld using X11 window %a&quot;</span> <span class="n">wayland_id</span> <span class="nn">X11</span><span class="p">.</span><span class="nn">Xid</span><span class="p">.</span><span class="n">pp</span> <span class="n">window</span><span class="o">);</span>
</span><span class="line">    <span class="nn">Hashtbl</span><span class="p">.</span><span class="n">remove</span> <span class="n">t</span><span class="o">.</span><span class="n">unpaired</span> <span class="n">wayland_id</span><span class="o">;</span>
</span><span class="line">    <span class="nn">Lwt</span><span class="p">.</span><span class="n">async</span> <span class="o">(</span><span class="k">fun</span> <span class="bp">()</span> <span class="o">-&gt;</span> <span class="n">pair</span> <span class="n">t</span> <span class="o">~</span><span class="n">set_configured</span> <span class="o">~</span><span class="n">host_surface</span> <span class="n">window</span><span class="o">);</span>
</span><span class="line">    <span class="nn">Lwt</span><span class="p">.</span><span class="n">return_unit</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>Another complication is that Wayland doesn't allow you to attach a buffer to a surface until the window has been &quot;configured&quot;.
Doing so is a protocol error, and Sway will disconnect us if we try!
But Xwayland likes to attach the buffer immediately after creating the surface.</p>
<p>To avoid this, I use a queue:</p>
<ol>
<li>Xwayland asks to create a surface.
</li>
<li>We forward this to Sway, add its ID to the <code>unpaired</code> map, and create a queue for further events.
</li>
<li>Xwayland asks us to attach a buffer, etc. We just queue these up.
</li>
<li>We get the <code>ClientMessage</code> over the X11 connection and create a role for the new surface.
</li>
<li>Sway sends us a <code>configure</code> event, confirming it's ready for the buffer.
</li>
<li>We forward the queued events.
</li>
</ol>
<p>However, this creates a new problem: if the surface isn't a window then the events will be queued forever.
To fix that, when we get a <code>create_surface</code> we also do a round-trip on the X11 connection.
If the window is still unpaired when that returns then we know that no <code>ClientMessage</code> is coming, and we flush the queue.</p>
<p>X applications like to create dummy windows for various purposes (e.g. receiving clipboard data),
and we need to avoid showing those.
They're normally set as <code>override_redirect</code> so the window manager doesn't handle them,
but Xwayland redirects them anyway (it needs to because otherwise e.g. tooltips wouldn't appear at all).
I'm trying various heuristics to detect this, e.g. that override redirect windows with a size of 1x1 shouldn't be shown.</p>
<p>If Sway asks us to close a window, we need to relay that to the X application using the <code>WM_DELETE_WINDOW</code> protocol,
if it supports that:</p>
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
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">let</span> <span class="n">toplevel</span> <span class="o">=</span> <span class="nn">Xdg_surface</span><span class="p">.</span><span class="n">get_toplevel</span> <span class="n">xdg_surface</span> <span class="o">@@</span> <span class="k">object</span>
</span><span class="line">    <span class="k">inherit</span> <span class="o">[_]</span> <span class="nn">Xdg_toplevel</span><span class="p">.</span><span class="n">v1</span>
</span><span class="line">
</span><span class="line">    <span class="k">method</span> <span class="n">on_close</span> <span class="o">_</span> <span class="o">=</span>
</span><span class="line">      <span class="nn">Lwt</span><span class="p">.</span><span class="n">async</span> <span class="o">(</span><span class="k">fun</span> <span class="bp">()</span> <span class="o">-&gt;</span>
</span><span class="line">          <span class="k">let</span><span class="o">*</span> <span class="n">x11</span> <span class="o">=</span> <span class="n">t</span><span class="o">.</span><span class="n">x11</span> <span class="k">in</span>
</span><span class="line">          <span class="k">let</span><span class="o">*</span> <span class="n">wm_protocols</span> <span class="o">=</span> <span class="nn">X11</span><span class="p">.</span><span class="nn">Atom</span><span class="p">.</span><span class="n">intern</span> <span class="n">x11</span> <span class="s2">&quot;WM_PROTOCOLS&quot;</span>
</span><span class="line">          <span class="ow">and</span><span class="o">*</span> <span class="n">wm_delete_window</span> <span class="o">=</span> <span class="nn">X11</span><span class="p">.</span><span class="nn">Atom</span><span class="p">.</span><span class="n">intern</span> <span class="n">x11</span> <span class="s2">&quot;WM_DELETE_WINDOW&quot;</span> <span class="k">in</span>
</span><span class="line">          <span class="k">let</span><span class="o">*</span> <span class="n">protocols</span> <span class="o">=</span> <span class="nn">X11</span><span class="p">.</span><span class="nn">Property</span><span class="p">.</span><span class="n">get_atoms</span> <span class="n">x11</span> <span class="n">window</span> <span class="n">wm_protocols</span> <span class="k">in</span>
</span><span class="line">          <span class="k">if</span> <span class="nn">List</span><span class="p">.</span><span class="n">mem</span> <span class="n">wm_delete_window</span> <span class="n">protocols</span> <span class="k">then</span> <span class="o">(</span>
</span><span class="line">            <span class="k">let</span> <span class="n">data</span> <span class="o">=</span> <span class="nn">Cstruct</span><span class="p">.</span><span class="n">create</span> <span class="mi">8</span> <span class="k">in</span>
</span><span class="line">            <span class="nn">Cstruct</span><span class="p">.</span><span class="nn">LE</span><span class="p">.</span><span class="n">set_uint32</span> <span class="n">data</span> <span class="mi">0</span> <span class="o">(</span><span class="n">wm_delete_window</span> <span class="o">:&gt;</span> <span class="n">int32</span><span class="o">);</span>
</span><span class="line">            <span class="nn">Cstruct</span><span class="p">.</span><span class="nn">LE</span><span class="p">.</span><span class="n">set_uint32</span> <span class="n">data</span> <span class="mi">4</span> <span class="mi">0</span><span class="n">l</span><span class="o">;</span>
</span><span class="line">            <span class="nn">X11</span><span class="p">.</span><span class="nn">Window</span><span class="p">.</span><span class="n">send_client_message</span> <span class="n">x11</span> <span class="n">window</span> <span class="o">~</span><span class="n">fmt</span><span class="o">:</span><span class="mi">32</span> <span class="o">~</span><span class="n">propagate</span><span class="o">:</span><span class="bp">false</span> <span class="o">~</span><span class="n">event_mask</span><span class="o">:</span><span class="mi">0</span><span class="n">l</span> <span class="o">~</span><span class="n">ty</span><span class="o">:</span><span class="n">wm_protocols</span> <span class="n">data</span><span class="o">;</span>
</span><span class="line">          <span class="o">)</span> <span class="k">else</span> <span class="o">(</span>
</span><span class="line">            <span class="nn">X11</span><span class="p">.</span><span class="nn">Window</span><span class="p">.</span><span class="n">destroy</span> <span class="n">x11</span> <span class="n">window</span>
</span><span class="line">          <span class="o">)</span>
</span><span class="line">        <span class="o">)</span>
</span><span class="line">  <span class="k">end</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>Wayland defaults to using client-side decorations (where the application draws its own window decorations).
X doesn't do that, so we need to turn it off (if the Wayland compositor supports the decoration manager extension):</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
<span class="line-number">6</span>
<span class="line-number">7</span>
<span class="line-number">8</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="n">t</span><span class="o">.</span><span class="n">decor_mgr</span> <span class="o">|&gt;</span> <span class="nn">Option</span><span class="p">.</span><span class="n">iter</span> <span class="o">(</span><span class="k">fun</span> <span class="n">decor_mgr</span> <span class="o">-&gt;</span>
</span><span class="line">    <span class="k">let</span> <span class="n">decor</span> <span class="o">=</span> <span class="nn">Xdg_decor_mgr</span><span class="p">.</span><span class="n">get_toplevel_decoration</span> <span class="n">decor_mgr</span> <span class="o">~</span><span class="n">toplevel</span> <span class="o">@@</span> <span class="k">object</span>
</span><span class="line">        <span class="k">inherit</span> <span class="o">[_]</span> <span class="nn">Xdg_decoration</span><span class="p">.</span><span class="n">v1</span>
</span><span class="line">        <span class="k">method</span> <span class="n">on_configure</span> <span class="o">_</span> <span class="o">~</span><span class="n">mode</span><span class="o">:_</span> <span class="o">=</span> <span class="bp">()</span>
</span><span class="line">      <span class="k">end</span>
</span><span class="line">    <span class="k">in</span>
</span><span class="line">    <span class="nn">Xdg_decoration</span><span class="p">.</span><span class="n">set_mode</span> <span class="n">decor</span> <span class="o">~</span><span class="n">mode</span><span class="o">:</span><span class="nn">Xdg_decoration</span><span class="p">.</span><span class="nn">Mode</span><span class="p">.</span><span class="nc">Server_side</span>
</span><span class="line">  <span class="o">)</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>Dialog boxes are more of a problem.
Wayland requires every dialog box to have a parent window, but X11 doesn't.
To handle that, the proxy tracks the last window the user interacted with and uses that as a fallback parent
if an X11 window with type <code>_NET_WM_WINDOW_TYPE_DIALOG</code> is created without setting <code>WM_TRANSIENT_FOR</code>.
That could be a problem if the application closes that window, but it seems to work.</p>
<h2>Performance</h2>
<p>I noticed a strange problem: scrolling around in GVim had long pauses once a second or so,
corresponding to OCaml GC runs.
This was surprising, as OCaml has a fast incremental garbage collector, and is normally not a problem for interactive programs.
Besides, I'd been using the proxy with the (Wayland) Firefox and xfce4-terminal applications for 6 months without any similar problem.</p>
<p>Using <code>perf</code> showed that Linux was spending a huge amount of time in <code>release_pages</code>.
The problem is that Xwayland was sharing lots of short-lived memory pools with the proxy.
Each time it shares a pool, we have to ask the VM host for a chunk of memory of the same size.
We map both pools into our address space and then copy each frame across
(this is needed because we can't export guest memory to the host).</p>
<p>Normally, an application shares a single pool and just refers to regions within it, so we just map once at startup and unmap at exit.
But Xwayland was creating, sharing and discarding around 100 pools per second while scrolling in GVim!
Because these pools take up a lot of RAM, OCaml was (correctly) running the GC very fast, freeing them in batches of 100 or so each second.</p>
<p>First, I tried adding a cache of host memory, but that only solved half the problem: freeing the client pool was still slow.</p>
<p>Another option is to unmap the pools as soon as we get the destroy message, to spread the work out.
Annoyingly, OCaml's standard library doesn't let you free memory-mapped memory explicitly
(see the <a href="https://github.com/ocaml/ocaml/pull/389">Add BigArray.Genarray.free</a> PR for the current status),
but adding this myself with a bit of C code would have been easy enough.
We only touch the memory in one place (for the copy), so manually checking it hadn't been freed would have been pretty safe.</p>
<p>Then I noticed something interesting about the repeated log entries, which mostly looked like this:</p>
<pre><code>-&gt; wl_shm@4.create_pool id:+26 fd:(fd) size:8368360
-&gt; wl_shm_pool@26.create_buffer id:+28 offset:0 width:2090 height:1001 stride:8360 format:1
-&gt; wl_shm_pool@26.destroy 
&lt;- wl_display@1.delete_id id:26
-&gt; wl_buffer@28.destroy 
&lt;- wl_display@1.delete_id id:28
</code></pre>
<p>Xwayland creates a pool, allocates a buffer within it, destroys the pool (so it can't create more buffers), and then deletes the buffer.
But <em>it never uses the buffer for anything</em>!</p>
<p>So the solution was simple: I just made the host buffer allocation and the mapping operations lazy.
We force the mapping if a pool's buffer is ever attached to a surface, but if not we just close the FD and forget about it.
Would be more efficient if Xwayland only shared the pools when needed, though.</p>
<h2>Pointer events</h2>
<p>Wayland delivers pointer events relative to a surface, so we simply forward these on to Xwayland unmodified and everything just works.</p>
<p>I'm kidding - this was the hardest bit! When Xwayland gets a pointer event on a window, it doesn't send it directly to that window.
Instead, it converts the location to screen coordinates and then pushes the event through the old X event handling mechanism, which looks at the X11 window stack to decide where to send it.</p>
<p>However, the X11 window stack (which we saw earlier with <code>xwininfo -tree -root</code>) doesn't correspond to the Wayland window layout at all.
In fact, Wayland doesn't provide us any way to know where our windows are, or how they are stacked.</p>
<p>Sway seems to handle this via a backdoor: X11 applications do get access to location information even though native Wayland clients don't.
This is one of the reasons I want to get X11 support out of the compositor - I want to make sure X11 apps don't have any special access.
Sommelier has a solution though: when the pointer enters a window we raise it to the top of the X11 stack. Since it's the topmost window, it will get the events.</p>
<p>Unfortunately, the raise request goes over the X11 connection while the pointer events go over the Wayland one.
We need to make sure that they arrive in the right order.
If the computer is running normally, this isn't much of a problem,
but if it's swapping or otherwise struggling it could result in events going to the wrong place
(I temporarily added a 2-second delay to test this).
This is what I ended up with:</p>
<ol>
<li>Get a wayland pointer enter event from Sway.
</li>
<li>Pause event delivery from Sway.
</li>
<li>Flush any pending Wayland events we previously sent to Xwayland by doing a round-trip on the Wayland connection.
</li>
<li>Send a raise on the X11 connection.
</li>
<li>Do a round-trip on the X11 connection to ensure the raise has completed.
</li>
<li>Forward the enter event on the Wayland connection.
</li>
<li>Unpause the event stream from Sway.
</li>
</ol>
<p>At first I tried queuing up just the pointer events,
but that doesn't work because e.g. keyboard events need to be synchronised with pointer events.
Otherwise, if you e.g. Shift-click on something then the click gets delayed but the Shift doesn't and it can do the wrong thing.
Also, Xwayland might ask Sway to destroy the window while we're entering it, and Sway might confirm the deletion.
Pausing the whole event stream from Sway fixes all these problems.</p>
<p>The next problem was how to do the two round-trips.
For X11 we just send an <code>Intern</code> request after the raise and wait to get a reply to that.
Wayland provides the <code>wl_display.sync</code> method to clients, but we're acting as a Wayland server to Xwayland,
not a client.
I remembered that Wayland's xdg-shell extension provides a ping from the server to the client
(the compositor can use this to detect when an application is not responding).
Unfortunately, Xwayland has no reason to use this extension because it doesn't deal with window roles.
Luckily, it uses it anyway (it does need it for non-rootless mode and doesn't bother to check).</p>
<p><code>wl_display.sync</code> works by creating a fresh callback object, but xdg-shell's <code>ping</code> just sends a <code>pong</code> event to a fixed object,
so we also need a queue to keep track of pings in flight so we don't get confused between our pings and any pings we're relaying for Sway.
Also, xdg-shell's ping requires a serial number and we don't have one.
But since Xwayland is the only app this needs to support, and it doesn't look at that, I cheat and just send zero.</p>
<p>And that's how to get pointer events to go to the right window with Xwayland.</p>
<h2>Keyboard events</h2>
<p>A very similar problem exists with the keyboard.
When Wayland says the focus has entered a window
we need to send a <code>SetInputFocus</code> over the X11 connection
and then send the keyboard events over the Wayland one,
requiring another two round-trips to synchronise the two connections.</p>
<h2>Pointer cursor</h2>
<p>Some applications set their own pointer shape, which works fine.
But others rely on the default and for some reason you get no cursor at all in that case.
To fix it, you need to set a cursor on the root window, which applications will then inherit by default.
Unlike Wayland, where every application provides its own cursor bitmaps,
X very sensibly provides a standard set of cursors, in a font called <code>cursor</code>
(this is why I had to implement <code>OpenFont</code>).
As cursors have two colours and a mask, each cursor is two glyphs: even numbered glyphs are the image and the following glyph is its mask:</p>
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
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="c">(* Load the default cursor image *)</span>
</span><span class="line"><span class="k">let</span><span class="o">*</span> <span class="n">cursor_font</span> <span class="o">=</span> <span class="nn">X11</span><span class="p">.</span><span class="nn">Font</span><span class="p">.</span><span class="n">open_font</span> <span class="n">x11</span> <span class="s2">&quot;cursor&quot;</span> <span class="k">in</span>
</span><span class="line"><span class="k">let</span><span class="o">*</span> <span class="n">default_cursor</span> <span class="o">=</span> <span class="nn">X11</span><span class="p">.</span><span class="nn">Font</span><span class="p">.</span><span class="n">create_glyph_cursor</span> <span class="n">x11</span>
</span><span class="line">    <span class="o">~</span><span class="n">source_font</span><span class="o">:</span><span class="n">cursor_font</span> <span class="o">~</span><span class="n">mask_font</span><span class="o">:</span><span class="n">cursor_font</span>
</span><span class="line">    <span class="o">~</span><span class="n">source_char</span><span class="o">:</span><span class="mi">68</span> <span class="o">~</span><span class="n">mask_char</span><span class="o">:</span><span class="mi">69</span>
</span><span class="line">    <span class="o">~</span><span class="n">bg</span><span class="o">:(</span><span class="mh">0xffff</span><span class="o">,</span> <span class="mh">0xffff</span><span class="o">,</span> <span class="mh">0xffff</span><span class="o">)</span>
</span><span class="line">    <span class="o">~</span><span class="n">fg</span><span class="o">:(</span><span class="mi">0</span><span class="o">,</span> <span class="mi">0</span><span class="o">,</span> <span class="mi">0</span><span class="o">)</span>
</span><span class="line"><span class="k">in</span>
</span><span class="line"><span class="nn">X11</span><span class="p">.</span><span class="nn">Window</span><span class="p">.</span><span class="n">create_attributes</span> <span class="o">~</span><span class="n">cursor</span><span class="o">:</span><span class="n">default_cursor</span> <span class="bp">()</span>
</span><span class="line"><span class="o">|&gt;</span> <span class="nn">X11</span><span class="p">.</span><span class="nn">Window</span><span class="p">.</span><span class="n">change_attributes</span> <span class="n">x11</span> <span class="n">root</span>
</span></code></pre></td></tr></tbody></table></div></figure><h2>Selections</h2>
<p>The next job was to get copying text between X and Wayland working.</p>
<p>In X11:</p>
<ul>
<li>When you select something, the application takes ownership of the <code>PRIMARY</code> selection.
</li>
<li>When you click the middle button or press Shift-Insert, the application requests <code>PRIMARY</code>.
</li>
<li>When you press Ctrl-C, the application takes ownership of the <code>CLIPBOARD</code> selection.
</li>
<li>When you press Ctrl-V it requests <code>CLIPBOARD</code>.
</li>
</ul>
<p>It's quite neat that adding support for a Windows-style clipboard didn't require changing the X server at all.
Good forward-thinking design there.</p>
<p>In Wayland, things are not so simple.
I have so far found no less than four separate Wayland protocols for copying text:</p>
<ol>
<li><code>gtk_primary_selection</code> supports copying the primary selection, but not the clipboard.
</li>
<li><code>wp_primary_selection_unstable_v1</code> is identical to <code>gtk_primary_selection</code> except that it renames everything.
</li>
<li><code>wl_data_device_manager</code> supports clipboard transfers but not the primary selection.
</li>
<li><code>zwlr_data_control_manager_v1</code> supports both, but it's for a &quot;privileged client&quot; to be a clipboard manager.
</li>
</ol>
<p><code>gtk_primary_selection</code> and <code>wl_data_device_manager</code> both say they're stable, while the other two are unstable.
However, Sway dropped support for <code>gtk_primary_selection</code> a while ago, breaking many applications
(luckily, I had a handy Wayland proxy and was able to add some adaptor code
to route <code>gtk_primary_selection</code> messages to the new &quot;unstable&quot; protocol).</p>
<p>For this project, I went with <code>wp_primary_selection_unstable_v1</code> and <code>wl_data_device_manager</code>.
On the Wayland side, everything has to be written twice for the two protocols, which are almost-but-not-quite the same.
In particular, <code>wl_data_device_manager</code> also has a load of drag-and-drop stuff you need to ignore.</p>
<p>For each selection (<code>PRIMARY</code> or <code>CLIPBOARD</code>), we can be in one of two states:</p>
<ul>
<li>An X11 client owns the selection (and we own the Wayland selection).
</li>
<li>A Wayland client owns the selection (and we own the X11 selection).
</li>
</ul>
<p>When we own a selection we proxy requests for it to the matching selection on the other protocol.</p>
<ul>
<li>At startup, we take ownership of the X11 selection, since there are no X11 apps running yet.
</li>
<li>When we lose the X11 selection it means that an X11 client now owns it and we take the Wayland selection.
</li>
<li>When we lose the Wayland selection it means that a Wayland client now owns it and we take the X11 selection.
</li>
</ul>
<p>One good thing about the Wayland protocols is that you send the data by writing it to a normal Unix pipe.
For X11, we need to write the data to a property on the requesting application's window and then notify it about the data.
And we may need to split it into multiple chunks if there's a lot of data to transfer.</p>
<p>A strange problem I had was that, while pasting into GVim worked fine, xterm would segfault shortly after trying to paste into it.
This turned out to be a bug in the way I was sending the notifications.
If an X11 application requests the special <code>TEXT</code> target, it means that the sender should choose the exact format.
You write the property with the chosen type (e.g. <code>UTF8_STRING</code>),
but you must still send the notification with the target <code>TEXT</code>.
xterm is a C application (thankfully no longer set-uid!) and seems to have a use-after-free bug in the timeout code.</p>
<h2>Drag-and-drop</h2>
<p>Sadly, I wasn't able to get this working at all.
X itself doesn't know anything about drag-and-drop and instead applications look at the window tree to decide where the user dropped things.
This doesn't work with the proxy, because Wayland doesn't tell us where the windows really are on the screen.</p>
<p>Even without any VMs or proxies, drag-and-drop from X applications to Wayland ones doesn't work,
because the X app can't see the Wayland window and the drop lands on the X window below (if any).</p>
<h2>Bonus features</h2>
<p>In the last post, I mentioned several other problems, which have also now been solved by the proxy:</p>
<h3>HiDPI works</h3>
<p>Wayland's support for high resolution screens is a bit strange.
I would have thought that applications really only need to know two things:</p>
<ol>
<li>The size in pixels of the window.
</li>
<li>The size in pixels you want some standard thing (e.g. a normal-sized letter M).
</li>
</ol>
<p>Some systems instead provide the size of the window and the DPI (dots-per-inch),
but this doesn't work well.
For example, a mobile phone might be high DPI but still want small text because you hold it close to your face,
while a display board will have very low DPI but want large text.</p>
<p>Wayland instead redefines the idea of pixel to be a group of pixels corresponding to a single pixel on a typical 1990's display.
So if you set your scale factor to 2 then 1 Wayland pixel is a 2x2 grid of physical pixels.
If you have a 1000x1000 pixel window, Wayland will tell the application it is 500x500 but suggest a scale factor of 2.
If the application supports HiDPI mode, it will double all the numbers and render a 1000x1000 image and things work correctly.
If not, it will render a 500x500 pixel image and the compositor will scale it up.</p>
<p>Since Xwayland doesn't support this, it just draws everything too small and Sway scales it up,
creating a blurry and unusable mess.
This might be made worse by <a href="https://en.wikipedia.org/wiki/Subpixel_rendering">subpixel rendering</a>, which doesn't cope well with being scaled.</p>
<p>With the proxy, the solution is simple enough: when talking to Xwayland we just scale everything back up to the real dimensions,
scaling all coordinates as we relay them:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">let</span> <span class="n">scale_to_client</span> <span class="n">t</span> <span class="o">(</span><span class="n">x</span><span class="o">,</span> <span class="n">y</span><span class="o">)</span> <span class="o">=</span>
</span><span class="line">  <span class="n">x</span> <span class="o">*</span> <span class="n">t</span><span class="o">.</span><span class="n">config</span><span class="o">.</span><span class="n">xunscale</span><span class="o">,</span>
</span><span class="line">  <span class="n">y</span> <span class="o">*</span> <span class="n">t</span><span class="o">.</span><span class="n">config</span><span class="o">.</span><span class="n">xunscale</span>
</span></code></pre></td></tr></tbody></table></div></figure><figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
<span class="line-number">6</span>
<span class="line-number">7</span>
<span class="line-number">8</span>
<span class="line-number">9</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">method</span> <span class="n">on_configure</span> <span class="o">_</span> <span class="o">~</span><span class="n">width</span> <span class="o">~</span><span class="n">height</span> <span class="o">~</span><span class="n">states</span><span class="o">:_</span> <span class="o">=</span>
</span><span class="line">  <span class="k">let</span> <span class="n">width</span> <span class="o">=</span> <span class="nn">Int32</span><span class="p">.</span><span class="n">to_int</span> <span class="n">width</span> <span class="k">in</span>
</span><span class="line">  <span class="k">let</span> <span class="n">height</span> <span class="o">=</span> <span class="nn">Int32</span><span class="p">.</span><span class="n">to_int</span> <span class="n">height</span> <span class="k">in</span>
</span><span class="line">  <span class="k">if</span> <span class="n">width</span> <span class="o">&gt;</span> <span class="mi">0</span> <span class="o">&amp;&amp;</span> <span class="n">height</span> <span class="o">&gt;</span> <span class="mi">0</span> <span class="k">then</span> <span class="o">(</span>
</span><span class="line">    <span class="nn">Lwt</span><span class="p">.</span><span class="n">async</span> <span class="o">(</span><span class="k">fun</span> <span class="bp">()</span> <span class="o">-&gt;</span>
</span><span class="line">        <span class="k">let</span> <span class="o">(</span><span class="n">width</span><span class="o">,</span> <span class="n">height</span><span class="o">)</span> <span class="o">=</span> <span class="n">scale_to_client</span> <span class="n">t</span> <span class="o">(</span><span class="n">width</span><span class="o">,</span> <span class="n">height</span><span class="o">)</span> <span class="k">in</span>
</span><span class="line">        <span class="nn">X11</span><span class="p">.</span><span class="nn">Window</span><span class="p">.</span><span class="n">configure</span> <span class="n">x11</span> <span class="n">window</span> <span class="o">~</span><span class="n">width</span> <span class="o">~</span><span class="n">height</span> <span class="o">~</span><span class="n">border_width</span><span class="o">:</span><span class="mi">0</span>
</span><span class="line">      <span class="o">)</span>
</span><span class="line">  <span class="o">)</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>This will tend to make things sharp but too small, but X applications already have their own ways to handle high resolution screens.
For example, you can set <code>Xft.dpi</code> to make all the fonts bigger. I run this proxy like this, which works for me:</p>
<pre><code>wayland-proxy-virtwl --x-display=0 --xrdb Xft.dpi:150 --x-unscale=2
</code></pre>
<p>However, there is a problem.
The Wayland specification says:</p>
<blockquote>
<p>The new size of the surface is calculated based on the buffer
size transformed by the inverse buffer_transform and the
inverse buffer_scale. This means that at commit time the supplied
buffer size must be an integer multiple of the buffer_scale. If
that's not the case, an invalid_size error is sent.</p>
</blockquote>
<p>Let's say we have an X11 image viewer that wants to show a 1001-pixel-high image in a 1001-pixel-high window.
This isn't allowed by the spec, which can only handle even-sized windows when the scale factor is 2.
Regular Wayland applications already have to deal with that somehow, but for X11 applications it becomes our problem.</p>
<p>I tried rounding down, but that has a bad side-effect: if GTK asks for a 1001-pixel high menu and gets a 1000 pixel allocation,
it switches to squashed mode and draws two big bumper arrows at the top and bottom of the menu which you must use to scroll it.
It looks very silly.</p>
<p>I also tried rounding up, but tooltips look bad with any rounding. Either one border is missing, or it's double thickness.
Luckily, it seems that Sway doesn't actually enforce the rule about surfaces being a multiple of the scale factor.
So, I just let the application attach a buffer of whatever size it likes to the surface and it seems to work!</p>
<p>The only problem I had was that when using unscaling, the mouse pointer in GVim would get lost.
Vim hides it when you start typing, but it's supposed to come back when you move the mouse.
The problem seems to be that it hides it by creating a 1x1 pixel cursor.
Sway decides this isn't worth showing (maybe because it's 0x0 in Wayland-pixels?),
and sends Xwayland a leave event saying the cursor is no longer on the screen.
Then when Vim sets the cursor back, Xwayland doesn't bother updating it, since it's not on screen!</p>
<p>The solution was to stop applying unscaling to cursors.
They look better doubled in size, anyway.
True, this does mean that the sharpness of the cursor changes as you move between windows,
but you're unlikely to notice this
due to the far more jarring effect of Wayland cursors also changing size and shape at the same time.</p>
<h3>Ring-buffer logging</h3>
<p>Even without a proxy to complicate things, Wayland applications often have problems.
To make investigating this easier, I added a ring-buffer log feature.
When on, the proxy keeps the last 512K or so of log messages in memory, and will dump them out on demand.</p>
<p>To use it, you run the proxy with e.g. <code>-v --log-ring-path ~/wayland.log</code>.
When something odd happens (e.g. an application crashes, or opens its menus in the wrong place) you can
dump out the ring buffer and see what just happened with:</p>
<pre><code>echo dump-log &gt; /run/user/1000/wayland-1-ctl
</code></pre>
<p>I also added some filtering options (e.g. <code>--log-suppress motion,shm</code>) to suppress certain classes of noisy messages.</p>
<h3>Vim windows open correctly</h3>
<p>One annoyance with Sway is that Vim's window always appears blank (even when running on the host, without any proxy).
You have to resize it before you can see the text.</p>
<p>My proxy initially suffered from the same problem, although only intermittently.
It turned out to be because Vim sends a <code>ConfigureRequest</code> with its desired size and then waits for the confirmation message.
Since Sway is a tiling window manager, it ignores the new size and no event is generated.
In this case, an X11 window manager is supposed to send a synthetic <code>ConfigureNotify</code>,
so I just got the proxy to do that and the problem disappeared
(I confirmed this by adding a sleep to Vim's <code>gui_mch_update</code>).</p>
<p>By the way, the GVim start-up code is quite interesting.
The code path to opening the window goes though three separate functions which each define a
<code>static int recursive = 0</code> and then proceed to behave differently depending on how many times they've
been reentered - see <a href="https://github.com/vim/vim/blob/9cd063e3195a4c250c8016fa340922ab21fda252/src/gui.c#L489">gui_init</a> for an example!</p>
<h3>Copy-and-paste without ^M characters</h3>
<p>The other major annoyance with Sway is that copy-and-paste doesn't work correctly (<a href="https://github.com/swaywm/wlroots/issues/1839">Sway bug #1839</a>).
Using the proxy avoids that problem completely.</p>
<h2>Conclusions</h2>
<p>I'm not sure how I feel about this project.
It ended up taking a lot longer than I expected, and I could probably have ported several X11 applications to Wayland in the same time.
On the other hand, I now have working X support in the VMs with no need for <code>ssh -Y</code> from the host, plus support for HiDPI in Wayland, mouse cursors that are large enough to see easily, windows that open reliably, text pasting that works, and I can get logs whenever something misbehaves.</p>
<p>In fact, I'm now also running an instance of the proxy directly on the host to get the same benefits for host X11 applications.
Setting this up is actually a bit tricky:
you want to start Sway with <code>DISPLAY=:0</code> so that every application it spawns knows it has an X11 display,
but if you set that then Sway thinks you want it to run nested inside an X window provided by the proxy,
which doesn't end well (or, indeed, at all).</p>
<p>Having all the legacy X11 support in a separate binary should make it much easier to write new Wayland compositors,
which might be handy if I ever get some time to try that.
It also avoids having many thousands of lines of legacy C code in the highly-trusted compositor code.</p>
<p>If Wayland had an official protocol for letting applications know the window layout then I could make drag-and-drop between X11 applications within the same VM work, but it still wouldn't work between VMs or to Wayland applications, so it's probably not worth it.</p>
<p>Having two separate connections to Xwayland creates a lot of unnecessary race conditions.
A simple solution might be a Wayland extension that allows the Wayland server to say &quot;please read N bytes from the X11 socket now&quot;,
and likewise in the other direction.
Then messages would always arrive in the order in which they were sent.</p>
<p>The code is all available at <a href="https://github.com/talex5/wayland-proxy-virtwl">https://github.com/talex5/wayland-proxy-virtwl</a> if you want to try it.
It works with the applications I use when running under Sway,
but will probably require some tweaking for other programs or compositors.
Here's a screenshot of my desktop using it:</p>
<p><a href="https://roscidus.com/blog/images/xwayland/desktop.png"><span class="caption-wrapper center"><img src="https://roscidus.com/blog/images/xwayland/desktop.png" title="Screenshot of my desktop" class="caption"/><span class="caption-text">Screenshot of my desktop</span></span></a></p>
<p>The windows with <code>[dev]</code> in the title are from my Debian VM, while <code>[com]</code> is a SpectrumOS VM I use for email, etc.
Gitk, GVim and ROX-Filer are X11 applications using Xwayland,
while Firefox and xfce4-terminal are using plain Wayland proxying.</p>

