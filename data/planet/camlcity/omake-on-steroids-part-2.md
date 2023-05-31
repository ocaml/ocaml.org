---
title: OMake On Steroids (Part 2)
description:
url: http://blog.camlcity.org/blog/omake2.html
date: 2015-06-19T12:00:00-00:00
preview_image:
featured:
authors:
- camlcity
---



<div>
  <b>Faster builds with omake, part 2: Linux</b><br/>&nbsp;
</div>

<div>
  
The Linux version of OMake suffered from specific problems, and it is
worth looking at these in detail.

</div>

<div>
  
<div style="float:right; width:50%; border: 1px solid black; padding: 10px; margin-left: 1em; margin-bottom: 1em; background-color: #E0E0E0">
This text is part 2/3 of a series about the OMake improvements
sponsored by <a href="http://lexifi.com">LexiFi</a>:
<ul>
  <li>Part 1: <a href="http://blog.camlcity.org/blog/omake1.html">Overview</a>
  </li><li>Part 2: Linux (this page)
  </li><li>Part 3: Caches (will be released on Tuesday, 6/23)
</li></ul>
The original publishing is on <a href="http://blog.camlcity.org/blog">camlcity.org</a>.
</div>
<p>While analyzing the performance characteristics of OMake, I found
that the features of the OS were used in a non-optimal way. In
particular, the fork() system call can be very expensive, and by
avoiding it the speed of OMake could be dramatically improved. This is
the biggest contribution to the performance optimizations allowing
OMake to run roughly twice as fast on Linux
(see <a href="http://blog.camlcity.org/blog/omake1.html">part 1</a> for numbers).

</p><h2>The fork/exec problem</h2>
<p>
The traditional way of starting commands is to use the fork/exec
combination: The fork() system call creates an almost identical copy
of the process, and in this copy the exec() call starts the
command. This has a number of logical advantages, namely that you can
run code between fork() and exec() that modifies the environment for
the new command. Often, the file descriptors 0, 1, and 2 are assigned
as it is required for creating pipelines. You can also do other
things, e.g. change the working directory.

</p><p>
The whole problem with this is that it is slow. Even for a modern OS
like Linux, fork() includes a number of expensive operations. Although
it can be avoided to actually copy memory, the new address space must
be set up by duplicating the page table. This is the more expensive the
bigger the address space is. Also, memory must be set aside even if it
is not immediately used. The entries for all file mappings must be
duplicated (and every linked-in shared library needs such mappings).
The point is now that all these actions are not really needed because
at exec() time the whole process image is replaced by a different one.

</p><p>
In my performance tests I could measure that forking a 450 MB process
image needs around 10 ms. In the n=8 test for compiling each of the
4096 modules two commands are needed (ocamldep.opt and ocamlopt.opt).
The time for this fork alone sums up to 80 seconds. Even worse, this
dramatically limits the benefit of parallelizing the build, because
this time is always spent in the main process.

</p><p>
The POSIX standard includes an alternate way of starting commands, the
posix_spawn() call. It was originally developed for small systems
without virtual memory where it is difficult to implement fork()
efficiently. However, because of the mentioned problems of the
fork/exec combinations it was quickly picked up by all current POSIX
systems.  The posix_spawn() call takes a potentially long list of
parameters that describes all the actions needed to be done between
fork() and exec().  This gives the implementer all freedom to exploit
low-level features of the OS for speeding the call up. Some OS, e.g.
Mac OS X, even implement posix_spawn directly as system call.

</p><p>
On Linux, posix_spawn is a library function of glibc. By default,
however, it is no real help because it uses fork/exec (being very
conservative).  If you pass the flag POSIX_SPAWN_USEVFORK, though, it
switches to a fast alternate implementation. I was pointed (by T&ouml;r&ouml;k
Edwin) to a few emails showing that the quality in glibc is not yet
optimal. In particular, there are weaknesses in signal handling and in
thread cancellation. Fortunately, these weaknesses do not matter for
this application (signals are not actively used, and on Linux OMake is
single-threaded).

</p><p>
Note that I developed the wrapper for posix_spawn already years ago
for OCamlnet where it is still used. So, if you want to test the speed
advantage out on yourself, just use OCamlnet's Shell library for
starting commands.

</p><h2>Pipelines and fork()</h2>

<p>It turned that there is another application of fork() in OMake. When
creating pipelines, it is sometimes required that the OMake process
forks itself, namely when one of commands of the pipeline is
implemented in the OMake language. This is somewhat expected, as the
parts of a pipeline need to run concurrently. However, this feature
turned out to be a little bit in the way because the default build
rules used it. In particular, there is the pipeline

</p><blockquote>
<code><small>
$(OCAMLFIND) $(OCAMLDEP) ... -modules $(src_file) | ocamldep-postproc
</small></code>
</blockquote>

which is started for scanning OCaml modules. While the first command,
$(OCAMLFIND), is a normal external command, the second command,
ocamldep-postprocess, is written in the OMake language.

<p>Forking for creating pipelines is even more expensive than the
fork/exec combination discussed above, because memory needs really to
be copied. I could finally avoid this fork() by some trickery in the
command starter. When used for scanning, and the command is the last one
in the pipeline (as in the above pipeline), a workaround is activated
that writes the data to a temporary file, as if the pipeline would read

</p><blockquote>
<code><small>
$(OCAMLFIND) $(OCAMLDEP) ... -modules $(src_file) &gt;$(tmpfile);<br/>
ocamldep-postproc &lt;$(tmpfile)
</small></code>
</blockquote>

<p>(NB. You actually can also program this in the OMake language. However,
this does not solve the problem, because for sequences of commands
$(cmd1);$(cmd2) it is also required to fork the process. Hence, I had to
find a solution deeper in the OMake internals.)

</p><div style="float:right; width:50%; border: 1px solid black; padding: 10px; margin-left: 1em; margin-top: 1em; background-color: #E0E0E0">
There is a now a <a href="https://github.com/gerdstolpmann/omake-fork/tags">pre-release omake-0.10.0-test1</a> that can be bootstrapped! It contains all
of the described improvements, plus a number of bugfixes.
</div>

<p>There is one drawback of this, though: The latency of the pipeline is
increased when the commands are run sequentially rather than in parallel.
The effect is that OMake takes longer for a j=1 build even if less CPU
resources are consumed. A number of further improvements compensate for
this:

</p><ul>
  <li>Most importantly, ocamldep-postprocess can now use a builtin function,
      speeding this part up by switching the implementation language (now
      OCaml, previously the OMake language).
  </li><li>Because ocamldep-postprocess mainly accesses the target cache,
      speeding up this cache also helped (see the next part of this
      article series).
  </li><li>Finally, there is now a way how functions like ocamldep-postprocess
      can propagate updates of the target cache to the main environment.
      The background is here that functions implementing commands run in
      a sub environment simulating some isolation from the parent
      environment. This isolation prevented that updates of the target
      cache found by one invocation of ocamldep-postprocess could be used
      by the next invocation. This also speeds up this function.
</li></ul>

<h2>Windows is not affected</h2>

<p>The Windows port of OMake is not affected by the fork problems. For
starting commands, an optimized technique similar to posix_spawn() is
used anyway. For pipelines and other internal uses of fork() the
Windows port uses threads. (Note beside: You may ask why we don't use
threads on Linux. There are a couple of reasons: First, the emulation
of the process environment with threads is probably not quite as
stable as the original using real processes. Second, there are
difficult interoperability problems between threads and signals
(something that does not exist in Windows).  Finally, this would not
save us maintaining the code branch using real processes and fork()
because OCaml does not support multi-threading for all POSIX systems.
Of course, this does not mean we cannot implement it as optional
feature, and probably this will be done at some point in the future.)

</p><p>The trick of using temporary files for speeding up pipelines is not
enabled on Windows. Here, it is more important to get the benefits of
parallelization that the real pipeline allows.

</p><div style="border: 1px solid black; padding: 10px; margin-left: 1em; margin-bottom: 1em; background-color: #E0E0E0">
The next part will be published on Tuesday, 6/23.
</div>

<img src="http://blog.camlcity.org/files/img/blog/omake2_bug.gif" width="1" height="1"/>


</div>

<div>
  Gerd Stolpmann works as OCaml consultant.

</div>

<div>
  
</div>


          
