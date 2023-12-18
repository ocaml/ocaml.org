---
title: 'Cumulus and ocp-memprof, a love story '
description: 'In this blog post, we went on the hunt of memory leaks in Cumulus by
  using our memory profiler: ocp-memprof. Cumulus is a feed aggregator based on Eliom,
  a framework for programming web sites and client/server web applications, part of
  the Ocsigen Project. First, run and get the memory snapshots To ...'
url: https://ocamlpro.com/blog/2015_03_04_cumulus_and_ocp_memprof_a_love_story
date: 2015-03-04T13:19:46-00:00
preview_image: URL_de_votre_image
featured:
authors:
- "\n    \xC7agdas Bozman\n  "
source:
---

<p>In this blog post, we went on the hunt of memory leaks in Cumulus by using <a href="https://memprof.typerex.org/">our memory profiler: ocp-memprof</a>. Cumulus is a feed aggregator based on <a href="https://ocsigen.org/eliom/">Eliom</a>, a framework for programming web sites and client/server web applications, part of the <a href="https://ocsigen.org/">Ocsigen Project</a>.</p>
<h3>First, run and get the memory snapshots</h3>
<p>To test and run the server, we use <code>ocp-memprof</code> to start the process:</p>
<pre><code class="language-shell-session">$ ocp-memprof -exec ocsigenserver.opt -c ocsigenserver.opt.conf -v
</code></pre>
<p>There are several ways to obtain snapshots:</p>
<ul>
<li>automatically after each GC: there is nothing to do, this is the default behavior
</li>
<li>manually:
<ul>
<li>by sending a SIGUSR1 signal (the default signal can be changed by using <code>--signal SIG</code> option);
</li>
<li>by editing the source code and using the dump function in the <code>Headump</code> module:
</li>
</ul>
<pre><code class="language-ocaml">(* the string argument stands for the name of the dump *)
val dump : string -&gt; unit
</code></pre>
</li>
</ul>
<p>Here, we use the default behavior and get a snapshot after every GC.</p>
<h3>The Memory Evolution Graph</h3>
<p>After running the server for a long time, the server process shows an unusually high consumption of memory. <code>ocp-memprof</code> automatically generates some statistics on the application memory usage. Below, we show the graph of memory consumption. On the x-axis, you can see the number of GCs, and on the y-axis, the memory size in bytes used by the most popular types in memory.</p>
<p><img src="https://ocamlpro.com/blog/assets/img/graph_cumulus_evolution_with_leak.png" alt="cumulus evolution with leak"/></p>
<p>Eliom expert users would quickly identify that most of the memory is used by XML nodes and attributes, together with strings and closures.</p>
<p>Unfortunately, it is not that easy to know which parts of Cumulus source code are the cause for the allocations of these XML trees. These trees are indeed abstract types allocated using functions exported by the Eliom modules. The main part of the allocations are then located in the Eliom source code.</p>
<p>Generally, we will have a problem to locate abstract type values just using allocation points. It may be useful to browse the memory graph which can be completely reconstructed from the snapshot to identify all paths between the globals and the blocks representing XML nodes.</p>
<h3>From roots to leaking nodes</h3>
<p><img src="https://ocamlpro.com/blog/assets/img/screenshot_cumulus_per_roots_with_leak.png" alt="screenshot_cumulus_per_roots_with_leak"/></p>
<p>The approach that we chose to identify the leak is to take a look at the pointer graph of our application in order to identify the roots retaining a significant portion of the memory. Above, we can observe the table of the retained size, for all roots of the application. What we can tell quickly is that <strong>92.2%</strong> of our memory is retained by values with finalizers.</p>
<p>Below, looking at them more closely, we can state that there is a significant amount of values of type:</p>
<p>[code language=&quot;fsharp&quot; gutter=&quot;false&quot;]
'a Eliom_comet_base.channel_data Lwt_stream.t -&gt; unit
[/code]</p>
<p><img src="https://ocamlpro.com/blog/assets/img/screenshot_cumulus_per_roots_with_leak_zoomed.png" alt="screenshot_cumulus_per_roots_with_leak_zoomed"/></p>
<p>Probably, these finalizers are never called in order to free their associated values. The leak is not trivial to track down and fix. However, a quick fix is possible in the case of Cumulus.</p>
<h3>Identifying the source code and patching it</h3>
<p>After further investigation into the source code of Cumulus, we found the only location where such values are allocated:</p>
<pre><code class="language-ocaml">(* $ROOT/cumulus/src/base/feeds.ml *)
let (event , call_event ) =
let ( private_event , call_event ) = React.E. create () in
let event = Eliom_react .Down. of_react private_event in
(event , call_event )
</code></pre>
<p>The function <code>of_react</code> takes an optional argument <code>~scope</code> to specify the way that <code>Eliom_comet.Channel.create</code> has to use the communication channel.</p>
<p>Changing the default value of the scope by another given in Eliom module, we have now only one channel and every client use this channel to communicate with the server (the default method created one channel by client).</p>
<pre><code class="language-ocaml">(* $ROOT/cumulus/src/base/feeds.ml *)
let (event , call_event ) =
let ( private_event , call_event ) = React.E. create () in
let event = Eliom_react .Down. of_react
~scope : Eliom_common . site_scope private_event in
(event , call_event )let (event , call_event ) =
</code></pre>
<h3>Checking the fix</h3>
<p>After patching the source code, we recompile our application and re-execute the process as before. Below, we can observe the new pointer graph. By changing the default value of <code>scope</code>, the size retained by finalizers drops from <strong>92.2% to 0%</strong> !</p>
<p><img src="https://ocamlpro.com/blog/assets/img/screenshot_cumulus_per_roots_fixed.png" alt="screenshot_cumulus_per_roots_fixed"/></p>
<p>The new evolution graph below shows that the memory usage drops from <strong>45Mb (still growing quickly) for a few hundreds connections to 5.2Mb</strong> for thousands connections.</p>
<p><img src="https://ocamlpro.com/blog/assets/img/graph_cumulus_evolution_fixed.png" alt="graph_cumulus_evolution_fixed"/></p>
<h3>Conclusion</h3>
<p>As a reminder, a finalisation function is a function that will be called with the (heap-allocated) value to which it is associated when that value becomes unreachable.</p>
<p>The GC calls finalisation functions in order to deallocate their associated values. You need to pay special attention when writing such finalisation functions, since anything reachable from the closure of a finalisation function is considered reachable. You also need to be careful not to make the value, that you want to free, become reachable again.</p>
<p>This example is online in our gallery of examples if you want to see and explore the graphs (<a href="https://memprof.typerex.org/users/04db0c7fb9232a0829e862d5bb2801fb/2015-03-02_16-04-33_7146967976ee57b0a97e053109440846_12249/">with the leak</a> and <a href="https://memprof.typerex.org/users/04db0c7fb9232a0829e862d5bb2801fb/2015-03-02_16-13-14_dd080e47d1bf4d18d3538d37769f325f_14185/">without the leak</a>).</p>
<p>Do not hesitate to use <code>ocp-memprof</code> on your applications. Of course, all feedback and suggestions on using <code>ocp-memprof</code> are welcome, just send us a mail !
More information:</p>
<ul>
<li>Homepage: <a href="https://memprof.typerex.org/">https://memprof.typerex.org/</a>
</li>
<li>Usage: <a href="https://memprof.typerex.org/free-version.php">https://memprof.typerex.org/free-version.php</a>
</li>
<li>Support: <a href="https://memprof.typerex.org/report-a-bug.php">https://memprof.typerex.org/report-a-bug.php</a>
</li>
<li>Gallery of examples: <a href="https://memprof.typerex.org/gallery.php">https://memprof.typerex.org/gallery.php</a>
</li>
<li>Commercial: <a href="https://memprof.typerex.org/commercial-version.php">https://memprof.typerex.org/commercial-version.php</a>
</li>
</ul>

