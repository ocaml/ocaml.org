---
title: A Simple Telnet Client Using Data.Conduit.
description:
url: http://www.mega-nerd.com/erikd/Blog/CodeHacking/Haskell/telnet-conduit.html
date: 2012-01-14T02:22:00-00:00
preview_image:
featured:
authors:
- mega-nerd
---



<p>
Below is a simple telnet client written using Haskell's new
	<a href="http://hackage.haskell.org/package/conduit/">
	Conduit</a>
library.
This library was written by
	<a href="http://www.snoyman.com/">Michael Snoyman</a>
the man behind the
	<a href="http://www.yesodweb.com/">
	Yesod</a>
Web Framework for Haskell.
</p>

<p>
The Conduit library is a second generation approach to the problem of
guaranteeing bounded memory usage in the presence of lazy evaluation.
The first generation of these ideas were libraries like
	<a href="http://hackage.haskell.org/package/iteratee">
	Iteratee</a>,
	<a href="http://hackage.haskell.org/package/enumerator">
	Enumerator</a>,
and
	<a href="http://hackage.haskell.org/package/iterIO">
	IterIO</a>.
All of these first generation libraries use the the term <i>enumerator</i>
for data producers and <i>iteratee</i> for data consumers.
The new Conduit library calls data producers <i>&quot;sources&quot;</i> and data consumers
<i>&quot;sinks&quot;</i> to make them a little more approachable.
</p>

<p>
The other big difference between Conduit and the early libraries in this space
is to do with guaranteeing early clean up of potentially scarce resources like
sockets.
Although I have not looked in any detail at the IterIO library, both Iteratee and
Enumerator simply rely on Haskell's garbage collector to clean up resources
when they are no longer required.
The Conduit library on the other hand uses
	<a href="http://hackage.haskell.org/packages/archive/conduit/latest/doc/html/Control-Monad-Trans-Resource.html">
	Resource transformers</a>
to guarantee release of these resources as soon as possible.
</p>

<p>
The client looks like this
(<a href="https://gist.github.com/1596792">latest available here</a>):
</p>

<pre class="code">

  import Control.Concurrent (forkIO, killThread)
  import Control.Monad.IO.Class (MonadIO, liftIO)
  import Control.Monad.Trans.Resource
  import Data.Conduit
  import Data.Conduit.Binary
  import Network (connectTo, PortID (..))
  import System.Environment (getArgs, getProgName)
  import System.IO


  main :: IO ()
  main = do
      args &lt;- getArgs
      case args of
          [host, port] -&gt; telnet host (read port :: Int)
          _ -&gt; usageExit
    where
      usageExit = do
          name &lt;- getProgName
          putStrLn $ &quot;Usage : &quot; ++ name ++ &quot; host port&quot;


  telnet :: String -&gt; Int -&gt; IO ()
  telnet host port = runResourceT $ do
      (releaseSock, hsock) &lt;- with (connectTo host $ PortNumber $ fromIntegral port) hClose
      liftIO $ mapM_ (`hSetBuffering` LineBuffering) [ stdin, stdout, hsock ]
      (releaseThread, _) &lt;- with (
                            forkIO $ runResourceT $ sourceHandle stdin $$ sinkHandle hsock
                            ) killThread
      sourceHandle hsock $$ sinkHandle stdout
      release releaseThread
      release releaseSock

</pre>

<p>
There are basically three blocks, a bunch of imports at the top, the program's
entry point <b><tt>main</tt></b> and the <b><tt>telnet</tt></b> function.
</p>

<p>
The <b><tt>telnet</tt></b> function is pretty simple.
Most of the function runs inside a <b><tt>runResourceT</tt></b> resource
transformer.
The purpose of these resources transformers is to keep track of resources such
as sockets, file handles, thread ids etc and make sure they get released in a
timely manner.
For example, in the <b><tt>telnet</tt></b> function, the <b><tt>connectTo</tt></b>
function call opens a connection to the specified host and port number and
returns a socket.
By wrapping the <b><tt>connectTo</tt></b> in the call to <b><tt>with</tt></b>
then the socket is registered with the resource transformer.
The <b><tt>with</tt></b> function has the following prototype:
</p>

<pre class="code">

  with :: Resource m
       =&gt; Base m a             -- Base monad for the current monad stack
       -&gt; (a -&gt; Base m ())     -- Resource de-allocation function
       -&gt; ResourceT m (ReleaseKey, a)

</pre>

<p>
When the resource is registered, the user must also supply a function that will
destroy and release the resource.
The <b><tt>with</tt></b> function returns a <b><tt>ReleaseKey</tt></b> for the
resource and the resource itself.
Formulating the <b><tt>with</tt></b> function this way makes it hard to misuse.
</p>

<p>
The other thing of interest is that because a telnet client needs to send data
in both directions, the server-to-client communication path and the
client-to-server communication run in separate GHC runtime threads.
The thread is spawned using <b><tt>forkIO</tt></b> and even though the thread
identifier is thrown away, the resource transformer still records it and will
later call <b><tt>killThread</tt></b> to clean up the thread.
</p>

<p>
The main core of the program are the two lines containing calls to
<b><tt>sourceHandle</tt></b> and <b><tt>sinkHandle</tt></b>.
The first of these lines pulls data from <b><tt>stdin</tt></b> and pushes it to
the socket <b><tt>hsock</tt></b> while the second pulls from the socket and
pushes it to <b><tt>stdout</tt></b>.
</p>

<p>
It should be noted that the final two calls to <b><tt>release</tt></b> are not
strictly necessary since the resource transformer will clean up these resources
automatically.
</p>

<p>
The experience of writing this telnet client suggests that the Conduit library
is certainly easier to use than the Enumerator or Iteratee libraries.
</p>


