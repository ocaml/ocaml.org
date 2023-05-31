---
title: OMake On Steroids (Part 1)
description:
url: http://blog.camlcity.org/blog/omake1.html
date: 2015-06-16T00:00:00-00:00
preview_image:
featured:
authors:
- camlcity
---



<div>
  <b>Faster builds with omake, part 1: Overview</b><br/>&nbsp;
</div>

<div>
  
In
the <a href="https://sympa.inria.fr/sympa/arc/caml-list/2014-09/msg00090.html">2014
edition</a> of the &quot;which is the best build system for OCaml&quot; debate
the <a href="http://omake.metaprl.org">OMake</a> utility was heavily
criticized for being not scalable enough. Some quick tests showed that
there was in deed a problem. At
<a href="http://lexifi.com">LexiFi</a>, the size of the source tree obviously
already exceeded the critical point, and LexiFi was interested in an
improvement. LexiFi develops for both Linux and Windows, and
OMake is their preferred build system because of its excellent support
for Windows. The author of these lines got some funding from LexiFi
for analyzing and fixing the problem.

</div>

<div>
  
<div style="float:right; width:50%; border: 1px solid black; padding: 10px; margin-left: 1em; margin-bottom: 1em; background-color: #E0E0E0">
This text is part 1/3 of a series about the OMake improvements
sponsored by <a href="http://lexifi.com">LexiFi</a>:
<ul>
  <li>Part 1: Overview (this page)
  </li><li>Part 2: Linux (will be released on Friday, 6/19)
  </li><li>Part 3: Caches (will be released on Tuesday, 6/23)
</li></ul>
The original publishing is on <a href="http://blog.camlcity.org/blog">camlcity.org</a>.
</div>

<p>
OMake is not only a build system (like e.g. ocamlbuild), but it also
includes extensions that are important for controlling and customizing
builds. There is an interpreter for a simple dynamically typed
functional language. There is a command shell implementing utilities
like &quot;rm&quot; or &quot;cp&quot; which is in particular important on non-Unix
systems. There are system interfaces for watching files and restarting
the build whenever source code is saved in the editor. In short, OMake
is very feature-rich, but also, and this is the downside, it is also
quite complex: around 130 modules and 80k lines of code. Obviously, it
is easy to overlook performance problems when so much code is
involved. For me as the developer seeing the sources for the first
time the size was also a challenge, namely for identifying possible
problems and for finding solutions.

</p><h2>Quantifying the performance problem</h2>

My very first activity was to develop a synthetic benchmark for OMake
(and actually, for any type of OCaml build system). Compared with a
real build, a synthetic benchmark has the big advantage that you can
simulate builds of any size. The benchmark has these characteristics:
The task is to build n^2 libraries with n^2 modules each (for a given
small number n), and the dependencies between the modules are created
in a way so that we can stress both the dependency analyzer of the
build utility and the ability to run commands in parallel. In
particular, every library would allow n parallel build flows of the
n^2 modules, and you can build n of the n^2 libraries in
parallel. (For details see the <a href="https://github.com/gerdstolpmann/omake-fork/blob/perf-test/performance/generate.ml">source code</a>.)

<p>
This is what I got for omake-0.9.8.6 (note that a different computer
was used for Windows, so you cannot compare Linux with Windows):

</p><p>
</p><table border="1">
<tr>
<th>Size n</th>
<th>Parallelism j</th>
<th>Number of modules (n^4)</th>
<th>Runtime Linux</th>
<th>Runtime Windows</th>
</tr>
<tr>
<td align="right">n=7</td>
<td align="right">j=1</td>
<td align="right">2401</td>
<td align="right">645</td>
<td align="right">353</td>
</tr>
<tr>
<td align="right">n=7</td>
<td align="right">j=4</td>
<td align="right">2401</td>
<td align="right">213</td>
<td align="right">179</td>
</tr>
<tr>
<td align="right">n=8</td>
<td align="right">j=1</td>
<td align="right">4096</td>
<td align="right">1906</td>
<td align="right">877</td>
</tr>
<tr>
<td align="right">n=8</td>
<td align="right">j=4</td>
<td align="right">4096</td>
<td align="right">607</td>
<td align="right">341</td>
</tr>
</table>

<p>This clearly shows that there is something wrong, in particular for
Linux as OS: For the n=8 number of 4096 modules, which is around 1.7
times of the 2401 modules for n=7, omake needs around three times
longer (for a single-threaded build). For Windows, the numbers are
slightly better: the n=8 build takes 2.5 of the time of the n=7
build. Nevertheless, this is quite far away from the optimum.

</p><p>Note that this is not good, but it is also not a catastrophe. The
latter shows up if you try to use ocamlbuild. I couldn't manage to
build the n=7 test case at all: after 30 minutes ocamlbuild slowed
down to a crawl, and progressed only with a speed of around one module
per second. Apparently, there are much worse problems than with
OMake. (Btw, it would be nice to hear how other build systems
compete.)

</p><h2>After improving OMake</h2>

The version from today (2015-05-18)
at <a href="https://github.com/gerdstolpmann/omake-fork">Github</a>
behaves much better:

<p>
</p><table border="1">
<tr>
<th>Size n</th>
<th>Parallelism j</th>
<th>Number of modules (n^4)</th>
<th>Runtime Linux<br/>(Speedup factor)</th>
<th>Runtime Windows<br/>(Speedup factor)</th>
</tr>
<tr>
<td align="right">n=7</td>
<td align="right">j=1</td>
<td align="right">2401</td>
<td align="right">169 (3.8)</td>
<td align="right">317 (1.1)</td>
</tr>
<tr>
<td align="right">n=7</td>
<td align="right">j=4</td>
<td align="right">2401</td>
<td align="right">59 (3.6)</td>
<td align="right">163 (1.1)</td>
</tr>
<tr>
<td align="right">n=8</td>
<td align="right">j=1</td>
<td align="right">4096</td>
<td align="right">363 (5.3)</td>
<td align="right">661 (1.3)</td>
</tr>
<tr>
<td align="right">n=8</td>
<td align="right">j=4</td>
<td align="right">4096</td>
<td align="right">144 (4.2)</td>
<td align="right">330 (1.0)</td>
</tr>
</table>

<div style="float:right; width:50%; border: 1px solid black; padding: 10px; margin-left: 1em; margin-top: 1em; background-color: #E0E0E0">
There is a now a <a href="https://github.com/gerdstolpmann/omake-fork/tags">pre-release omake-0.10.0-test1</a> that can be bootstrapped! It contains all
of the described improvements, plus a number of bugfixes.
</div>

<p>As you can see, there is a huge improvement for Linux and a slight
one for Windows. It turns out that the Linux version ran into a
Unix-specific issue of starting commands from a big process (the OMake
main process reaches around 450MB). OMake used the conventional
fork/exec combination for doing so, but it is a known problem that
this does not work well for big process images. We'll come to the
details of this later. The Windows version never suffered from this
problem.

</p><p>The scalability is now somewhat better, but still not great. For both
Windows and Linux, the n=8 runs take now around 2.1 times longer than the
n=7 runs.

</p><p>Another aspect of the performance impression is how long a typical
incremental build takes after changing a single file. At least for
OMake, a good measure for this is the zero rebuild time: how long
OMake takes to figure out that nothing has changed, i.e. the time for
the second omake run in &quot;omake ; omake&quot;:

</p><table border="1">
<tr>
<th>Parameters</th>
<th>Runtime Linux omake-0.9.8.6</th>
<th>Runtime Linux 2015-05-18<br/>(Speedup Factor)</th>
</tr>
<tr>
<td align="right">n=7, j=1</td>
<td align="right">16.8</td>
<td align="right">8.4 (2.0)</td>
</tr>
<tr>
<td align="right">n=8, j=1</td>
<td align="right">39.2</td>
<td align="right">15.6 (2.5)</td>
</tr>
</table>

<p>The time roughly halves. Note that you get a similar effect under
Windows as OMake doesn't start any commands for a zero
rebuild. Actually, most time is spent for constructing the internal
data structures and for computing digests (not only for files but also
for commands, which turns out to be the more expensive action).


</p><h2>How to tackle the analysis</h2>

I started it the old-fashioned way by manually instrumenting
interesting functions. This means that counts and (wall-clock)
runtimes are measured. Functions that (subjectively) &quot;take too long&quot;
are further analyzed by also instrumenting called functions. This way
I could quickly find out the interesting parts (while learning how
OMake works as you go through the code and instrument it). The
helper module I used: <a href="https://github.com/gerdstolpmann/omake-fork/blob/master/src/libmojave/lm_instrument.mli">Lm_instrument</a>. (Note that
I did all the actual instrumentation in the &quot;perf-test&quot; branch.)

<p>As OCaml supports gprof instrumentation I also tried this but
without success. The problem is simply that gprof looks at the wrong
metrics, namely only at the runtimes of the two innermost function
invocations in the call stack. In OCaml this is usually something like
<code>List.map</code> calling <code>String.sub</code>, i.e. at both
levels there are general-purpose functions. This is useless
information. We need more context for the analysis (i.e. more levels
in the call stack), but it depends very much from where the function
is called.

</p><p>Another problem of gprof was that you do not see kernel time. For
analyzing a utility like OMake whose purpose is to start external
commands this is crucial information, though.

</p><p>For measuring the size of OCaml values I used <a href="http://forge.ocamlcore.org/projects/objsize/">objsize</a>.


</p><h2>The main points of the improvement</h2>

<p>Summarized, the following improvements were done:

</p><ul>
<li>For Linux, I switched to posix_spawn instead of fork/exec for
    starting commands.
</li><li>For Linux, it was also important to avoid a self-fork of omake for
    postprocessing ocamldep output. Now temporary files are used.
</li><li>I rewrote the target cache that stores whether a file can be built
    or not. The new data structure for this cache highly compresses
    the data, and is better aligned to the main user, namely the
    function figuring out which implicit rules are needed to build
    a file. This way I could save processing time in this cache,
    and the memory footprint also got substantially smaller.
</li><li>I also rewrote the file cache that connects file names with file stats
    and digests. The new cache allows it to skip the computation of
    digests in more cases. Also, less data is cached (saving memory).
</li><li>I tweaked when the file digests are computed. This is no longer done
    immediately but delayed after the next command has been started,
    and in parallel to the command. This is in particular advantageous
    when there are some CPU resources left that could be utilized for
    this purpose.
</li><li>There are also simplified scanner rules in OMake.om, reducing the
    time needed for computing scanner dependencies. There is a drawback
    of the new rules, namely that when a file is moved to a new directory
    OMake does not rescan the file the next time it is run. I guess this is
    acceptable, because it normally does not matter where a file is
    stored. Nevertheless, there is an option to get the old behavior
    back (by setting EXTENDED_DIGESTS).
</li><li>Not regarding speed: OMake can now be built with the mingw port of OCaml
</li></ul>


<h2>One major problem remains</h2>

<p>
There is still one problem I could not yet address, and this problem is
mainly responsible for the long startup time of OMake for large builds.
Unlike other build systems, OMake creates a dependency from the rule
to the command of the rule, as if every rule looked like:

</p><blockquote>
<code>
target: source1 ... sourceN :value: $(command)<br/>
&nbsp;&nbsp;&nbsp;&nbsp;$(command)
</code>
</blockquote>

i.e. when the command changes the rule &quot;fires&quot; and is executed. This is
an automatic addition, and it is very useful: When you start a build after
changing parameters (e.g. include paths) OMake automatically
detects which commands have changed because of this, and reruns these.

<p>
However, there is a price to pay. For checking whether a rule is out of date
it is required to expand the command and compute the digest. For a full
build the time for this is negligible (and you need the commands anyway
for starting them), but for a &quot;zero rebuild&quot; the commands are finally
not needed, and OMake expands them only for the out-of-date check. As you
might guess, this is the main reason why a zero rebuild is so slow.

</p><p>
It is probably possible to speed up the out-of-date check by doing a
static analysis of the command expansions. Most expansions just depend
on a small number of variables, and only if these variables change the
command can expand to something different. With that knowledge it is 
possible to compile a quick check whether the expansion is actually needed.
As any expression of the OMake language can be used for the commands,
developing such a compiler is non-trivial, and it was so far not possible
to do in my time budget.

</p><div style="border: 1px solid black; padding: 10px; margin-left: 1em; margin-bottom: 1em; background-color: #E0E0E0">
The next part will be published on Friday, 6/19.
</div>

<img src="http://blog.camlcity.org/files/img/blog/omake1_bug.gif" width="1" height="1"/>


</div>

<div>
  Gerd Stolpmann works as OCaml consultant.

</div>

<div>
  
</div>


          
