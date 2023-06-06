---
title: Continuous Benchmarking & Call for Benchmarks
description:
url: https://kcsrk.info/multicore/ocaml/benchmarks/2018/09/13/1543-multicore-ci/
date: 2018-09-13T15:43:00-00:00
preview_image:
featured:
authors:
- KC Sivaramakrishnan
---

<p>Over the past few weeks, at <a href="http://ocamllabs.io/">OCaml Labs</a>, we&rsquo;ve deployed
continuous benchmarking infrastructure for <a href="https://github.com/ocamllabs/ocaml-multicore">Multicore
OCaml</a>. Live results are available
at <a href="http://ocamllabs.io/multicore">http://ocamllabs.io/multicore</a>. Continuous
benchmarking has already enabled us to make <a href="https://github.com/ocamllabs/ocaml-multicore/pull/221">informed
decisions</a> about the
impact of our changes, and should come in handy over the next few months where
we polish off and tune the multicore runtime.</p>



<p>Currently, the benchmarks are all single-threaded and run on x86-64. Our current
aim is to quantify the performance impact of running single-threaded OCaml
programs using the multicore compiler. Moving forward, would would include
multi-threaded benchmarks and other architectures.</p>

<p>The benchmarks and the benchmarking infrastructure were adapted from <a href="https://github.com/OCamlPro/ocamlbench-repo">OCamlPro&rsquo;s
benchmark suite</a> aimed at
benchmarking <a href="https://bench.flambda.ocamlpro.com/">Flambda optimisation passes</a>.
The difference with the new infrastructure is that all the data is generated as
static HTML and CSV files with data processing performed on the client side in
JavaScript. I find the new setup easier to manage and deploy.</p>

<h2>Quality of benchmarks</h2>

<p>If you observe the results, you will see that multicore is slowest compared to
trunk OCaml on <code class="language-plaintext highlighter-rouge">menhir-standard</code> and <code class="language-plaintext highlighter-rouge">menhir-fancy</code>. But if you look closely:</p>

<p><img src="https://kcsrk.info/assets/menhir-too-fast.png" alt="Binary tree"/></p>

<p>these benchmarks complete in less than 10 milliseconds. This is not enough time
to faithfully compare the implementations as constant factors such as runtime
initialisation and costs of single untimely major GC dominate any useful work.
In fact, almost half of the benchmarks complete within a second. The quality of
this benchmark suite ought to be improved.</p>

<h2>Call for benchmarks</h2>

<p>While we want longer running benchmarks, we would also like those benchmarks to
represent real OCaml programs found in the wild. If you have long running <em>real</em>
OCaml programs, please consider adding it to the benchmark suite. Your
contribution will ensure that performance-oriented OCaml features such as
multicore and flambda are evaluated on representative OCaml programs.</p>

<h2>How to contribute</h2>

<p>Make a PR to <code class="language-plaintext highlighter-rouge">multicore</code> branch of
<a href="https://github.com/ocamllabs/ocamlbench-repo/tree/multicore">ocamllabs/ocamlbench-repo</a>.
The <code class="language-plaintext highlighter-rouge">packages</code> directory contains many examples for how to prepare programs for
benchmarking. Among these, <code class="language-plaintext highlighter-rouge">numerical-analysis-bench</code> and <code class="language-plaintext highlighter-rouge">menhir-bench</code> are
simple and illustrative.</p>

<p>The benchmarks themselves are run using <a href="https://github.com/kayceesrk/ocamlbench-scripts">these
scripts</a>.</p>

<h3>Dockerfile</h3>

<p>There is a handy Dockerfile to test benchmarking setup:</p>

<figure class="highlight"><pre><code class="language-bash" data-lang="bash"><span class="nv">$ </span>docker build <span class="nt">-t</span> multicore-cb <span class="nt">-f</span> Dockerfile <span class="nb">.</span> <span class="c">#takes a while; grab a coffee</span></code></pre></figure>

<p>This builds the docker image for the benchmarking infrastructure. You can run
the benchmarks as:</p>

<figure class="highlight"><pre><code class="language-bash" data-lang="bash"><span class="nv">$ </span>docker run <span class="nt">-p</span> 8080:8080 <span class="nt">-it</span> multicore-cb bash
<span class="nv">$ </span><span class="nb">cd</span> ~/ocamlbench-scripts
<span class="nv">$ </span>./run-bench.sh <span class="nt">--nowait</span> <span class="nt">--lazy</span> <span class="c">#takes a while; grab lunch</span></code></pre></figure>

<p>You can view the results by:</p>

<figure class="highlight"><pre><code class="language-bash" data-lang="bash"><span class="nv">$ </span><span class="nb">cd</span> ~/logs/operf
<span class="nv">$ </span>python <span class="nt">-m</span> SimpleHTTPServer 8080</code></pre></figure>

<p>Now on your host machine, point your browser to <code class="language-plaintext highlighter-rouge">localhost:8080</code> to
interactively visualise the benchmark results.</p>

<h3>Caveats</h3>

<p>Aim to get your benchmark compiling with OCaml 4.06.1. You might have trouble
getting your benchmark to compile with the multicore compiler due to several
reasons:</p>

<ul>
  <li>Multicore compiler has syntax extensions for <a href="http://kcsrk.info/ocaml/multicore/2015/05/20/effects-multicore/">algebraic effect
handlers</a>
which breaks packages that use ppx.</li>
  <li>Multicore compiler has a different <a href="https://github.com/ocaml/ocaml/pull/1003">C
API</a> which breaks core dependencies
such as Lwt.</li>
  <li>Certain features such as marshalling closures and custom tag objects are
unimplemented.</li>
</ul>

<p>If you encounter trouble submitting benchmarks, please make an issue on
<a href="https://github.com/kayceesrk/ocamlbench-scripts">kayceesrk/ocamlbench-scripts</a> repo.</p>

