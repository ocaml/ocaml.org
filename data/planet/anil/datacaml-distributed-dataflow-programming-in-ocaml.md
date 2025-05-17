---
title: 'DataCaml: distributed dataflow programming in OCaml'
description: DataCaml brings distributed dataflow programming to OCaml using the CIEL
  engine.
url: https://anil.recoil.org/notes/datacaml-with-ciel
date: 2011-06-11T00:00:00-00:00
preview_image:
authors:
- Anil Madhavapeddy
source:
---

<p>Distributed programming frameworks like
<a href="http://wiki.apache.org/hadoop">Hadoop</a> and
<a href="http://research.microsoft.com/en-us/projects/dryad/">Dryad</a> are popular
for performing computation over large amounts of data. The reason is
programmer convenience: they accept a query expressed in a simple form
such as <a href="http://wiki.apache.org/hadoop/HadoopMapReduce">MapReduce</a>, and
automatically take care of distributing computation to multiple hosts,
ensuring the data is available at all nodes that need it, and dealing
with host failures and stragglers.</p>
<p>A major limitation of Hadoop and Dryad is that they are not well-suited
to expressing <a href="http://en.wikipedia.org/wiki/Iterative_method">iterative
algorithms</a> or <a href="http://en.wikipedia.org/wiki/Dynamic_programming">dynamic
programming</a> problems.
These are very commonly found patterns in many algorithms, such as
<a href="http://en.wikipedia.org/wiki/K-means_clustering">k-means clustering</a>,
<a href="http://en.wikipedia.org/wiki/Binomial_options_pricing_model">binomial options
pricing</a> or
<a href="http://en.wikipedia.org/wiki/Smith%E2%80%93Waterman_algorithm">Smith Waterman</a>
for sequence alignment.</p>
<p>Over in the SRG in Cambridge,
<a href="http://www.cl.cam.ac.uk/research/srg/netos/ciel/who-we-are/">we</a>
developed a Turing-powerful distributed execution engine called
<a href="http://www.cl.cam.ac.uk/research/srg/netos/ciel/">CIEL</a> that addresses
this. The <a href="https://anil.recoil.org/papers/2011-nsdi-ciel">CIEL: A universal execution engine for distributed data-flow computing</a>
paper describes the system in detail, but here’s a shorter introduction.</p>
<h2>The CIEL Execution Engine</h2>
<p>CIEL consists of a master coordination server and workers installed on
every host. The engine is job-oriented: a job consists of a graph of
tasks which results in a deterministic output. CIEL tasks can run in any
language and are started by the worker processes as needed. Data flows
around the cluster in the form of <em>references</em> that are fed to tasks as
dependencies. Tasks can publish their outputs either as <em>concrete</em>
references if they can finish the work immediately or as a <em>future</em>
reference. Additionally, tasks can dynamically spawn more tasks and
delegate references to them, which makes the system Turing-powerful and
suitable for iterative and dynamic programming problems where the task
graph cannot be computed statically.</p>
<p>The first iteration of CIEL used a domain-specific language called
<a href="https://anil.recoil.org/papers/2011-nsdi-ciel.pdf">Skywriting</a> to
coordinate how tasks should run across a cluster. Skywriting is an
interpreted language that is “native” to CIEL, and when it needs to
block it stores its entire execution state inside CIEL as a
continuation. <a href="http://www.cl.cam.ac.uk/~dgm36/">Derek Murray</a> has
written a blog post <a href="http://www.syslog.cl.cam.ac.uk/2011/04/06/ciel/">explaining this in more
detail</a>.</p>
<p>More recently, we have been working on eliminating the need for
Skywriting entirely, by adding direct support for CIEL into languages
such as <a href="http://www.stackless.com/">Python</a>, Java,
<a href="http://www.scala-lang.org/">Scala</a>, and the main subject of this post –
<a href="http://caml.inria.fr">OCaml</a>. It works via libraries that communicate
with CIEL to spawn tasks, publish references, or suspend itself into the
cluster to be woken up when a future reference is completed.</p>
<h2>DataCaml API</h2>
<p>Rather than go into too much detail about the innards of CIEL, this post
describes the OCaml API and gives some examples of how to use it. The
simplest interface to start with is:</p>
<pre><code class="language-ocaml">type 'a ref
val deref : 'a ref -&gt; 'a
</code></pre>
<p>The type <code>'a ref</code> represents a CIEL reference. This data might not be
immediately present on the current node, and so must be dereferenced
using the <code>deref</code> function.</p>
<p>If the reference has been completed, then the OCaml value is
unmarshalled and returned. If it is not present, then the program needs
to wait until the computation involving the reference has completed
elsewhere. The future reference might contain a large data structure and
be on another host entirely, and so we should serialise the program
state and spawn a task that is dependent on the future’s completion.
This way, CIEL can resume execution on whatever node finished that
computation, avoiding the need to move data across the network.</p>
<p>Luckily, we do not need to serialise the entire heap to suspend the
program. DataCaml uses the
<a href="http://okmij.org/ftp/continuations/implementations.html">delimcc</a>
delimited continuations library to walk the stack and save only the
subset required to restart this particular task. Delimcc abstracts this
in the form a “restartable exception” that supplies a closure which can
be called later to resume the execution, as if the exception had never
happened. Delimcc supports serialising this closure to an output
channel, which you can read about in Oleg’s
<a href="http://okmij.org/ftp/continuations/caml-shift.pdf">paper</a>.</p>
<p>So how do we construct references? Lets fill in more of the interface:</p>
<pre><code class="language-ocaml">module Ciel = struct
  type 'a ref
  val deref : 'a ref -&gt; 'a
  val spawn : ('a -&gt; 'b) -&gt; 'a -&gt; 'b ref
  val run : (string list -&gt; 'a) -&gt; ('a -&gt; string) -&gt; unit
end
</code></pre>
<p>The <code>spawn</code> function accepts a closure and an argument, and returns a
future of the result as a reference. The <code>run</code> function begins the
execution of a job, with the first parameter taking some
<code>string arguments</code> and returning an <code>'a</code> value. We also supply a
pretty-printer second argument to convert the <code>'a</code> into a string for
returning as the result of the job (this can actually be any JSON value
in CIEL, and just simplified here).</p>
<pre><code class="language-ocaml">let r1 = spawn (fun x -&gt; x + 5) arg1 in
let r2 = spawn (fun x -&gt; deref r1 + 5) arg1 in
deref r2
</code></pre>
<p>We first spawn a function <code>r1</code> which simply adds 5 to the job argument.
A job in CIEL is <em>lazily scheduled</em>, so this marshals the function to
CIEL, creates a future, and returns immediately. Next, the <code>r2</code> function
spawns a task which also adds 5, but to the dereferenced value of <code>r1</code>.
Again, it is not scheduled yet as the return reference has not been
dereferenced.</p>
<p>Finally, we attempt to dereference <code>r2</code>, which causes it be scheduled on
a worker. While executing, it will try to dereference <code>r1</code> that will
schedule it, and all the tasks will run to completion.</p>
<p>Programming language boffins will recognise that this interface is very
similar to <a href="http://www.ps.uni-saarland.de/alice/">AliceML</a>’s concept of
<a href="http://www.ps.uni-saarland.de/alice/manual/futures.html">lazy futures</a>.
The main difference is that it is implemented as a pure OCaml library,
and uses a general-purpose distributed engine that can also work with
other languages.</p>
<h2>Streaming References</h2>
<p>The references described so far only have two states: they are either
concrete or futures. However, there are times when a task can
progressively accept input and make forward progress. For these
situations, references can also be typed as <em>opaque</em> references that are
accessed via <code>in_channel</code> and <code>out_channel</code>, as networks are:</p>
<pre><code class="language-ocaml">type opaque_ref

val spawn_ref : (unit -&gt; opaque_ref) -&gt; opaque_ref
val output : ?stream:bool -&gt; ?pipe:bool -&gt; (out_channel -&gt; unit) -&gt; opaque_ref
val input : (in_channel -&gt; 'a) -&gt; opaque_ref -&gt; 'a
</code></pre>
<p>This interface is a lower-level version of the previous one:</p>
<ul>
<li><code>spawn_ref</code> creates a lazy future as before, but the type of
references here is completely opaque to the program.</li>
<li>Inside a spawned function, <code>output</code> is called with a closure that
accepts an <code>out_channel</code>. The <code>stream</code> argument informs CIEL that a
dependent task can consume the output before it is completed, and
<code>pipe</code> forms an even more closely coupled shared-memory connection
(requiring the tasks to be scheduled on the same host). Piping is
more efficient, but will require more work to recover from a fault,
and so using it is left to the programmer to decide.</li>
<li>The <code>input</code> function is used by the receiving task to parse the
input as a standard <code>in_channel</code>.</li>
</ul>
<p>The CIEL engine actually supports multiple concurrent input and output
streams to a task, but I’ve just bound it as a single version for now
while the bindings find their feet. Here’s an example of how streaming
references can be used:</p>
<pre><code class="language-ocaml">let x_ref = spawn_ref (fun () -&gt;
    output ~stream:true (fun oc -&gt;
      for i = 0 to 5 do
        Unix.sleep 1;
        fprintf oc "%d\n%!" i;
      done
    )
  ) in
  let y_ref = spawn_ref (fun () -&gt;
    input (fun ic -&gt;
      output ~stream:true (fun oc -&gt;
        for i = 0 to 5 do
          let line = input_line ic in
          fprintf oc "LINE=%s\n%!" line
        done
      )
    ) x_ref
  ) in
</code></pre>
<p>We first spawn an <code>x_ref</code> which pretends to do 5 seconds of work by
sleeping and outputing a number. This would of course be heavy number
crunching in a real program. The <code>y_ref</code> then inputs this stream, and
outputs its own result by prepending a string to each line.</p>
<h2>Try it out</h2>
<p>If you are interested in a more real example, then read through the
<a href="https://github.com/avsm/ciel/blob/master/src/ocaml/binomial.ml">binomial
options</a>
calculator that uses streaming references to parallelise a dynamic
programming problem (this would be difficult to express in MapReduce).
On my Mac, I can run this by:</p>
<ul>
<li>check out CIEL from from Derek’s <a href="http://github.com/mrry/ciel">Git
repository</a>.</li>
<li>install all the Python libraries required (see the <code>INSTALL</code> file)
and OCaml libraries
(<a href="http://okmij.org/ftp/continuations/implementations.html">delimcc</a>
and <a href="http://martin.jambon.free.fr/yojson.html">Yojson</a>).</li>
<li>add <code>&lt;repo&gt;/src/python</code> to your <code>PYTHONPATH</code></li>
<li>in one terminal: <code>./scripts/run_master.sh</code></li>
<li>in another terminal: <code>./scripts/run_worker.sh -n 5</code> (this allocates
5 execution slots)</li>
<li>build the OCaml libraries: <code>cd src/ocaml &amp;&amp; make</code></li>
<li>start the binomial options job:
<code>./scripts/sw-start-job -m http://localhost:8000 ./src/package/ocaml_binopt.pack</code></li>
<li>there will be a URL printed which shows the execution progress in
real-time</li>
<li>you should see log activity on the worker(s), and a result reference
with the answer (<code>10.x</code>)</li>
<li>let us know the happy news if it worked or sad news if something
broke</li>
</ul>
<h2>Discussion</h2>
<p>The DataCaml bindings outlined here provide an easy way to write
distributed, fault-tolerant and cluster-scheduled jobs in OCaml. The
current implementation of the engine is aimed at cluster computation,
but <a href="http://www.cl.cam.ac.uk/~ms705">Malte</a> has been working on
<a href="http://www.cl.cam.ac.uk/~ms705/pub/papers/2011-ciel-sfma.pdf">condensing CIEL onto multicore
hardware</a>.
Thus, this could be one approach to ‘solving the OCaml multicore
problem’ for problems that fit nicely into the dataflow paradigm.</p>
<p>The biggest limitation for using these bindings is that delimited
continuation serialisation only works in bytecode. Native code delimcc
supports <code>shift/reduce</code> in the same program, but serialising is
problematic since native code continuations contain a C stack, which may
have unwrapped integers. One way to work around this is by switching to
a monadic approach to dereferencing, but I find delimcc programming more
natural (also see <a href="http://www.openmirage.org/wiki/delimcc-vs-lwt">this
discussion</a>).</p>
<p>Another important point is that tasks are lazy and purely functional
(remind you of Haskell?). This is essential for reliable fault-tolerance
and reproducibility, while allowing individual tasks to run fast, strict
and mutable OCaml code. The tasks must remain referentially transparent
and idempotent, as CIEL may choose to schedule them multiple times (in
the case of faults or straggler correction). Derek has been working on
<a href="http://www.cl.cam.ac.uk/~dgm36/publications/2011-murray2011nondet.pdf">integrating non-determinism into
CIEL</a>,
so this restriction may be relaxed soon.</p>
<p>Finally, these ideas are not limited to OCaml at all, but also apply to
Scala, Java, and Python. We have submitted a draft paper dubbed <em>‘<a href="http://www.cl.cam.ac.uk/~ms705/pub/papers/2011-ciel-socc-draft.pdf">A
Polyglot Approach to Cloud
Programming</a>’</em>
with more details and the ubiquitous evaluation versus Hadoop. There is
a really interesting line to explore between low-level
<a href="http://en.wikipedia.org/wiki/Message_Passing_Interface">MPI</a> coding and
high-level MapReduce, and we think CIEL is a useful spot in that design
space.</p>
<p>Incidentally, I was recently hosted by <a href="http://research.nokia.com/">Nokia
Research</a> in Palo Alto by my friend
<a href="http://www.linkedin.com/pub/prashanth-mundkur/6/b44/27">Prashanth
Mundkur</a>, where
they work on the Python/Erlang/OCaml <a href="http://discoproject.org/">Disco</a>
MapReduce engine. I’m looking forward to seeing more critical
comparisons and discussions of alternatives to Hadoop, from them and
others.</p>
<p><em>Thanks are due to <a href="http://www.cl.cam.ac.uk/~dgm36/">Derek</a>,
<a href="https://twitter.com/#!/chrissmowton">Chris</a> and
<a href="http://www.cl.cam.ac.uk/~ms705">Malte</a> for answering my incessant CIEL
questions while writing this post! Remember that DataCaml is a work in
progress and a research prototype, and feedback is most welcome.</em></p>

