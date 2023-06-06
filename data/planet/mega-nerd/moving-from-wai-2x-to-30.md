---
title: Moving from Wai 2.X to 3.0.
description:
url: http://www.mega-nerd.com/erikd/Blog/CodeHacking/Haskell/wai_3.html
date: 2014-06-11T10:16:00-00:00
preview_image:
featured:
authors:
- mega-nerd
---



<p>
Michael Snoyman has just released version 3.0 of
	<a href="http://hackage.haskell.org/package/wai/">
	Wai</a>,
the Haskell Web Application Interface library which is used with the
	<a href="http://www.yesodweb.com/">
	Yesod Web Framework</a>
and anything that uses the
	<a href="http://hackage.haskell.org/package/warp">
	Warp</a>
web server.
The important changes for Wai are listed this
	<a href="http://www.yesodweb.com/blog/2014/05/wai-3-0-alpha">
	blog post</a>.
The tl;dr is that removing the Conduit library dependency makes the Wai
interface more easily usable with one of the alternative Haskell streaming
libraries, like Pipes, Stream-IO, Iterator etc.
</p>

<p>
As a result of the above changes, the type of a web application changes as
follows:
</p>

<pre class="code">

  -- Wai &gt; 2.0 &amp;&amp; Wai &lt; 3.0
  type Application = Request -&gt; IO Response

  -- Wai == 3.0
  type Application = Request -&gt; (Response -&gt; IO ResponseReceived) -&gt; IO ResponseReceived

</pre>

<p>
Typically a function of type <b><tt>Application</tt></b> will be run by the Warp
web server using one of <b><tt>Warp.run</tt></b> or associated functions which
have type signatures of:
</p>

<pre class="code">

  run :: Port -&gt; Application -&gt; IO ()

  runSettings :: Settings -&gt; Application -&gt; IO ()

  runSettingsSocket :: Settings -&gt; Socket -&gt; Application -&gt; IO ()Source

  runSettingsConnection :: Settings -&gt; IO (Connection, SockAddr) -&gt; Application -&gt; IO ()

</pre>

<p>
Its important to note that the only thing that has changed about these Warp
functions is the <b><tt>Application</tt></b> type.
That means that if we have a function <b><tt>oldWaiApplication</tt></b> that we
want to interface to the new version of Wai, we can just wrap it with the
following function:
</p>

<pre class="code">

  newWaiApplication :: Manager -&gt; Request -&gt; (Response -&gt; IO ResponseReceived) -&gt; IO ResponseReceived
  newWaiApplication mgr wreq receiver = oldWaiApplication mgr wreq &gt;&gt;= receiver

</pre>

<p>
and use <b><tt>newWaiApplication</tt></b> in place of <b><tt>oldWaiApplication</tt></b>
in the call to whichever of the Warp <b><tt>run</tt></b> functions you are using.
</p>


