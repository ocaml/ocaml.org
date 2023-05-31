---
title: 'CI/CD pipelines: Monad, Arrow or Dart?'
description:
url: https://roscidus.com/blog/blog/2019/11/14/cicd-pipelines/
date: 2019-11-14T09:59:40-00:00
preview_image:
featured:
authors:
- Thomas Leonard
---

<p>In this post I describe three approaches to building a language for writing CI/CD pipelines. My first attempt used a <i>monad</i>, but this prevented static analysis of the pipelines. I then tried using an <i>arrow</i>, but found the syntax very difficult to use. Finally, I ended up using a light-weight alternative to arrows that I will refer to here as a <i>dart</i> (I don't know if this has a name already). This allows for static analysis like an arrow, but has a syntax even simpler than a monad.</p>

<p><strong>Table of Contents</strong></p>
<ul>
<li><a href="https://roscidus.com/#introduction">Introduction</a>
</li>
<li><a href="https://roscidus.com/#attempt-one-a-monad">Attempt one: a monad</a>
</li>
<li><a href="https://roscidus.com/#attempt-two-an-arrow">Attempt two: an arrow</a>
</li>
<li><a href="https://roscidus.com/#attempt-three-a-dart">Attempt three: a dart</a>
</li>
<li><a href="https://roscidus.com/#comparison-with-arrows">Comparison with arrows</a>
</li>
<li><a href="https://roscidus.com/#larger-examples">Larger examples</a>
<ul>
<li><a href="https://roscidus.com/#ocaml-docker-base-image-builder">OCaml Docker base image builder</a>
</li>
<li><a href="https://roscidus.com/#ocaml-ci">OCaml CI</a>
</li>
</ul>
</li>
<li><a href="https://roscidus.com/#conclusions">Conclusions</a>
</li>
</ul>
<p>( this post also appeared on <a href="https://www.reddit.com/r/ocaml/comments/dwpxdj/cicd_pipelines_monad_arrow_or_dart/">Reddit</a>
and <a href="https://lobste.rs/s/u5i2t0/ci_cd_pipelines_monad_arrow_dart">Lobsters</a> )</p>
<h2>Introduction</h2>
<p>I was asked to build a system for creating CI/CD pipelines.
The initial use for it was to build a CI for testing OCaml projects on GitHub (testing each commit against multiple versions of the OCaml compiler and on multiple operating systems).
Here's a simple pipeline that gets the Git commit at the head of a branch, builds it,
and then runs the tests:</p>
<p><img src="https://roscidus.com/blog/images/cicd/example1.svg" class="center"/></p>
<p>The colour-scheme here is that green boxes are completed, orange ones are in progress and grey means the step can't be started yet.</p>
<p>Here's a slightly more complex example, which also downloads a Docker base image, builds the commit in parallel using two different versions of the OCaml compiler, and then tests the resulting images. Here the red box indicates that this step failed:</p>
<p><img src="https://roscidus.com/blog/images/cicd/example2.svg" class="center"/></p>
<p>A more complex example is testing the project itself and then searching for other projects that depend on it and testing those against the new version too:</p>
<p><img src="https://roscidus.com/blog/images/cicd/example3.svg" class="center"/></p>
<p>Here, the circle means that we should wait for the tests to pass before checking the reverse dependencies.</p>
<p>We could describe these pipelines using YAML or similar, but that would be very limiting.
Instead, I decided to use an Embedded Domain Specific Language, so that we can use the host
language's features for free (e.g. string manipulation, variables, functions, imports,
type-checking, etc).</p>
<p>The most obvious approach is making each box a regular function.
Then the first example above could be (here, using OCaml syntax):</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">let</span> <span class="n">example1</span> <span class="n">commit</span> <span class="o">=</span>
</span><span class="line">  <span class="k">let</span> <span class="n">src</span> <span class="o">=</span> <span class="n">fetch</span> <span class="n">commit</span> <span class="k">in</span>
</span><span class="line">  <span class="k">let</span> <span class="n">image</span> <span class="o">=</span> <span class="n">build</span> <span class="n">src</span> <span class="k">in</span>
</span><span class="line">  <span class="n">test</span> <span class="n">image</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>The second could be:</p>
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
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">let</span> <span class="n">example2</span> <span class="n">commit</span> <span class="o">=</span>
</span><span class="line">  <span class="k">let</span> <span class="n">src</span> <span class="o">=</span> <span class="n">fetch</span> <span class="n">commit</span> <span class="k">in</span>
</span><span class="line">  <span class="k">let</span> <span class="n">base</span> <span class="o">=</span> <span class="n">docker_pull</span> <span class="s2">&quot;ocaml/opam2&quot;</span> <span class="k">in</span>
</span><span class="line">  <span class="k">let</span> <span class="n">build</span> <span class="n">ocaml_version</span> <span class="o">=</span>
</span><span class="line">    <span class="k">let</span> <span class="n">dockerfile</span> <span class="o">=</span> <span class="n">make_dockerfile</span> <span class="o">~</span><span class="n">base</span> <span class="o">~</span><span class="n">ocaml_version</span> <span class="k">in</span>
</span><span class="line">    <span class="k">let</span> <span class="n">image</span> <span class="o">=</span> <span class="n">build</span> <span class="o">~</span><span class="n">dockerfile</span> <span class="n">src</span> <span class="o">~</span><span class="n">label</span><span class="o">:</span><span class="n">ocaml_version</span> <span class="k">in</span>
</span><span class="line">    <span class="n">test</span> <span class="n">image</span>
</span><span class="line">  <span class="k">in</span>
</span><span class="line">  <span class="n">build</span> <span class="s2">&quot;4.07&quot;</span><span class="o">;</span>
</span><span class="line">  <span class="n">build</span> <span class="s2">&quot;4.08&quot;</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>And the third might look something like this:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
<span class="line-number">6</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">let</span> <span class="n">example3</span> <span class="n">commit</span> <span class="o">=</span>
</span><span class="line">  <span class="k">let</span> <span class="n">src</span> <span class="o">=</span> <span class="n">fetch</span> <span class="n">commit</span> <span class="k">in</span>
</span><span class="line">  <span class="k">let</span> <span class="n">image</span> <span class="o">=</span> <span class="n">build</span> <span class="n">src</span> <span class="k">in</span>
</span><span class="line">  <span class="n">test</span> <span class="n">image</span><span class="o">;</span>
</span><span class="line">  <span class="k">let</span> <span class="n">revdeps</span> <span class="o">=</span> <span class="n">get_revdeps</span> <span class="n">src</span> <span class="k">in</span>
</span><span class="line">  <span class="nn">List</span><span class="p">.</span><span class="n">iter</span> <span class="n">example1</span> <span class="n">revdeps</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>However, we'd like to add some extras to the language:</p>
<ul>
<li>Pipeline steps should run in parallel when possible.
The <code>example2</code> function above would do the builds one at a time.
</li>
<li>Pipeline steps should be recalculated whenever their input changes.
e.g. when a new commit is made we need to rebuild.
</li>
<li>The user should be able to view the progress of each step.
</li>
<li>The user should be able to trigger a rebuild for any step.
</li>
<li>We should be able to generate the diagrams automatically from the code,
so we can see what the pipeline will do before running it.
</li>
<li>The failure of one step shouldn't stop the whole pipeline.
</li>
</ul>
<p>The exact extras don't matter too much to this blog post,
so for simplicity I'll focus on just running steps concurrently.</p>
<h2>Attempt one: a monad</h2>
<p>Without the extra features, we have functions like this:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">val</span> <span class="n">fetch</span> <span class="o">:</span> <span class="n">commit</span> <span class="o">-&gt;</span> <span class="n">source</span>
</span><span class="line"><span class="k">val</span> <span class="n">build</span> <span class="o">:</span> <span class="n">source</span> <span class="o">-&gt;</span> <span class="n">image</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>You can read this as &quot;<code>build</code> is a function that takes a <code>source</code> value and returns a (Docker) <code>image</code>&quot;.</p>
<p>These functions compose together easily to make a larger function that will fetch a
commit and build it:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">let</span> <span class="n">fab</span> <span class="n">c</span> <span class="o">=</span>
</span><span class="line">  <span class="k">let</span> <span class="n">src</span> <span class="o">=</span> <span class="n">fetch</span> <span class="n">c</span> <span class="k">in</span>
</span><span class="line">  <span class="n">build</span> <span class="n">src</span>
</span></code></pre></td></tr></tbody></table></div></figure><p><img src="https://roscidus.com/blog/images/cicd/fetch_and_build.svg" class="center"/></p>
<p>We could also shorten this to <code>build (fetch c)</code> or to <code>fetch c |&gt; build</code>.
The <code>|&gt;</code> (pipe) operator in OCaml just calls the function on its right with the argument on its left.</p>
<p>To extend these functions to be concurrent, we can make them return promises, e.g.</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">val</span> <span class="n">fetch</span> <span class="o">:</span> <span class="n">commit</span> <span class="o">-&gt;</span> <span class="n">source</span> <span class="n">promise</span>
</span><span class="line"><span class="k">val</span> <span class="n">build</span> <span class="o">:</span> <span class="n">source</span> <span class="o">-&gt;</span> <span class="n">image</span> <span class="n">promise</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>But now we can't compose them easily using <code>let</code> (or <code>|&gt;</code>), because the output type of <code>fetch</code> doesn't match the input of <code>build</code>.</p>
<p>However, we can define a similar operation, <code>let*</code> (or <code>&gt;&gt;=</code>) that works with promises. It immediately returns a promise for the final
result, and calls the body of the <code>let*</code> later, when the first promise is fulfilled. Then we have:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">let</span> <span class="n">fab</span> <span class="n">c</span> <span class="o">=</span>
</span><span class="line">  <span class="k">let</span><span class="o">*</span> <span class="n">src</span> <span class="o">=</span> <span class="n">fetch</span> <span class="n">c</span> <span class="k">in</span>
</span><span class="line">  <span class="n">build</span> <span class="n">src</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>In order words, by sprinkling a few <code>*</code> characters around we can turn our plain old pipeline into a new concurrent one!
The rules for when you can compose promise-returning functions using <code>let*</code> are exactly the same as the rules about when
you can compose regular functions using <code>let</code>, so writing programs using promises is just as easy as writing regular programs.</p>
<p>Just using <code>let*</code> doesn't add any concurrency within our pipeline
(it just allows it to execute concurrently with other code).
But we can define extra functions for that, such as <code>all</code> to evaluate every promise in a list at once,
or an <code>and*</code> operator to indicate that two things should run in parallel:</p>
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
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">let</span> <span class="n">example2</span> <span class="n">commit</span> <span class="o">=</span>
</span><span class="line">  <span class="c">(* Fetch the source code and Docker base image in parallel: *)</span>
</span><span class="line">  <span class="k">let</span><span class="o">*</span> <span class="n">src</span> <span class="o">=</span> <span class="n">fetch</span> <span class="n">commit</span>
</span><span class="line">  <span class="ow">and</span><span class="o">*</span> <span class="n">base</span> <span class="o">=</span> <span class="n">docker_pull</span> <span class="s2">&quot;ocaml/opam2&quot;</span> <span class="k">in</span>
</span><span class="line">  <span class="k">let</span> <span class="n">build</span> <span class="n">ocaml_version</span> <span class="o">=</span>
</span><span class="line">    <span class="k">let</span> <span class="n">dockerfile</span> <span class="o">=</span> <span class="n">make_dockerfile</span> <span class="o">~</span><span class="n">base</span> <span class="o">~</span><span class="n">ocaml_version</span> <span class="k">in</span>
</span><span class="line">    <span class="k">let</span><span class="o">*</span> <span class="n">image</span> <span class="o">=</span> <span class="n">build</span> <span class="o">~</span><span class="n">dockerfile</span> <span class="n">src</span> <span class="o">~</span><span class="n">label</span><span class="o">:</span><span class="n">ocaml_version</span> <span class="k">in</span>
</span><span class="line">    <span class="n">test</span> <span class="n">image</span>
</span><span class="line">  <span class="k">in</span>
</span><span class="line">  <span class="c">(* Build and test against each compiler version in parallel: *)</span>
</span><span class="line">  <span class="n">all</span> <span class="o">[</span>
</span><span class="line">    <span class="n">build</span> <span class="s2">&quot;4.07&quot;</span><span class="o">;</span>
</span><span class="line">    <span class="n">build</span> <span class="s2">&quot;4.08&quot;</span>
</span><span class="line">  <span class="o">]</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>As well as handling promises,
we could also define a <code>let*</code> for functions that might return errors (the body of the let is called only if the first value
is successful), or for live updates (the body is called each time the input changes), or for all of these things together.
This is the basic idea of a monad.</p>
<p>This actually works pretty well.
In 2016, I used this approach to make <a href="https://github.com/moby/datakit/tree/master/ci">DataKitCI</a>, which was used initially as the CI system for Docker-for-Mac.
Later, Anil Madhavapeddy used it to create <a href="https://github.com/avsm/mirage-ci">opam-repo-ci</a>, which is the CI system for <a href="https://github.com/ocaml/opam-repository">opam-repository</a>, OCaml's main package repository.
This checks each new PR to see what packages it adds or modifies,
tests each one against multiple OCaml compiler versions and Linux distributions (Debian, Ubuntu, Alpine, CentOS, Fedora and OpenSUSE),
and then finds all versions of all packages depending on the changed packages and tests those too.</p>
<p>The main problem with using a monad is that we can't statically analyse the pipeline.
Consider the <code>example2</code> function above. Until we have queried GitHub to get a commit to
test, we cannot run the function and therefore have no idea what it will do.
Once we have <code>commit</code> we can call <code>example2 commit</code>,
but until the <code>fetch</code> and <code>docker_pull</code> operations complete we cannot evaluate the body of the <code>let*</code> to find out what the pipeline will do next.</p>
<p>In other words, we can only draw diagrams showing the bits of the pipeline that have already
executed or are currently executing, and we must indicate opportunities for concurrency
manually using <code>and*</code>.</p>
<h2>Attempt two: an arrow</h2>
<p>An <a href="https://en.wikipedia.org/wiki/Arrow_(computer_science)">arrow</a> makes it possible to analyse pipelines statically.
Instead of our monadic functions:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">val</span> <span class="n">fetch</span> <span class="o">:</span> <span class="n">commit</span> <span class="o">-&gt;</span> <span class="n">source</span> <span class="n">promise</span>
</span><span class="line"><span class="k">val</span> <span class="n">build</span> <span class="o">:</span> <span class="n">source</span> <span class="o">-&gt;</span> <span class="n">image</span> <span class="n">promise</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>we can define an arrow type:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">type</span> <span class="o">(</span><span class="k">'</span><span class="n">a</span><span class="o">,</span> <span class="k">'</span><span class="n">b</span><span class="o">)</span> <span class="n">arrow</span>
</span><span class="line">
</span><span class="line"><span class="k">val</span> <span class="n">fetch</span> <span class="o">:</span> <span class="o">(</span><span class="n">commit</span><span class="o">,</span> <span class="n">source</span><span class="o">)</span> <span class="n">arrow</span>
</span><span class="line"><span class="k">val</span> <span class="n">build</span> <span class="o">:</span> <span class="o">(</span><span class="n">source</span><span class="o">,</span> <span class="n">image</span><span class="o">)</span> <span class="n">arrow</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>An <code>('a, 'b) arrow</code> is a pipeline that takes an input of type <code>'a</code> and produces a result of type <code>'b</code>.
If we define <code>type ('a, 'b) arrow = 'a -&gt; 'b promise</code> then this is the same as the monadic version.
However, we can instead make the <code>arrow</code> type abstract and extend it to store whatever static information we require.
For example, we could label the arrows:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">type</span> <span class="o">(</span><span class="k">'</span><span class="n">a</span><span class="o">,</span> <span class="k">'</span><span class="n">b</span><span class="o">)</span> <span class="n">arrow</span> <span class="o">=</span> <span class="o">{</span>
</span><span class="line">  <span class="n">f</span> <span class="o">:</span> <span class="k">'</span><span class="n">a</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">b</span> <span class="n">promise</span><span class="o">;</span>
</span><span class="line">  <span class="n">label</span> <span class="o">:</span> <span class="kt">string</span><span class="o">;</span>
</span><span class="line"><span class="o">}</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>Here, <code>arrow</code> is a record. <code>f</code> is the old monadic function and <code>label</code> is the &quot;static analysis&quot;.</p>
<p>Users can't see the internals of the <code>arrow</code> type, and must build up pipelines using functions provided by the arrow implementation.
There are three basic functions available:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">val</span> <span class="n">arr</span> <span class="o">:</span> <span class="o">(</span><span class="k">'</span><span class="n">a</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">b</span><span class="o">)</span> <span class="o">-&gt;</span> <span class="o">(</span><span class="k">'</span><span class="n">a</span><span class="o">,</span> <span class="k">'</span><span class="n">b</span><span class="o">)</span> <span class="n">arrow</span>
</span><span class="line"><span class="k">val</span> <span class="o">(</span> <span class="o">&gt;&gt;&gt;</span> <span class="o">)</span> <span class="o">:</span> <span class="o">(</span><span class="k">'</span><span class="n">a</span><span class="o">,</span> <span class="k">'</span><span class="n">b</span><span class="o">)</span> <span class="n">arrow</span> <span class="o">-&gt;</span> <span class="o">(</span><span class="k">'</span><span class="n">b</span><span class="o">,</span> <span class="k">'</span><span class="n">c</span><span class="o">)</span> <span class="n">arrow</span> <span class="o">-&gt;</span> <span class="o">(</span><span class="k">'</span><span class="n">a</span><span class="o">,</span> <span class="k">'</span><span class="n">c</span><span class="o">)</span> <span class="n">arrow</span>
</span><span class="line"><span class="k">val</span> <span class="n">first</span> <span class="o">:</span> <span class="o">(</span><span class="k">'</span><span class="n">a</span><span class="o">,</span> <span class="k">'</span><span class="n">b</span><span class="o">)</span> <span class="n">arrow</span> <span class="o">-&gt;</span> <span class="o">((</span><span class="k">'</span><span class="n">a</span> <span class="o">*</span> <span class="k">'</span><span class="n">c</span><span class="o">),</span> <span class="o">(</span><span class="k">'</span><span class="n">b</span> <span class="o">*</span> <span class="k">'</span><span class="n">c</span><span class="o">))</span> <span class="n">arrow</span>
</span></code></pre></td></tr></tbody></table></div></figure><p><code>arr</code> takes a pure function and gives the equivalent arrow.
For our promise example, that means the arrow returns a promise that is already fulfilled.
<code>&gt;&gt;&gt;</code> joins two arrows together.
<code>first</code> takes an arrow from <code>'a</code> to <code>'b</code> and makes it work on pairs instead.
The first element of the pair will be processed by the given arrow and
the second component is returned unchanged.</p>
<p>We can have these operations automatically create new arrows with appropriate <code>f</code> and <code>label</code> fields.
For example, in <code>a &gt;&gt;&gt; b</code>, the resulting label field could be the string <code>{a.label} &gt;&gt;&gt; {b.label}</code>.
This means that we can display the pipeline without having to run it first,
and we could easily replace <code>label</code> with something more structured if needed.</p>
<p>With this our first example changes from:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">let</span> <span class="n">example1</span> <span class="n">commit</span> <span class="o">=</span>
</span><span class="line">  <span class="k">let</span> <span class="n">src</span> <span class="o">=</span> <span class="n">fetch</span> <span class="n">commit</span> <span class="k">in</span>
</span><span class="line">  <span class="k">let</span> <span class="n">image</span> <span class="o">=</span> <span class="n">build</span> <span class="n">src</span> <span class="k">in</span>
</span><span class="line">  <span class="n">test</span> <span class="n">image</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>to</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">let</span> <span class="n">example1</span> <span class="o">=</span>
</span><span class="line">  <span class="n">fetch</span> <span class="o">&gt;&gt;&gt;</span> <span class="n">build</span> <span class="o">&gt;&gt;&gt;</span> <span class="n">test</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>That seems quite pleasant, although we did have to give up our variable names.
But things start to get complicated with larger examples. For <code>example2</code>, we
need to define a few standard combinators:</p>
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
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="c">(** Process the second component of a tuple, leaving the first unchanged. *)</span>
</span><span class="line"><span class="k">let</span> <span class="n">second</span> <span class="n">f</span> <span class="o">=</span>
</span><span class="line">  <span class="k">let</span> <span class="n">swap</span> <span class="o">(</span><span class="n">x</span><span class="o">,</span> <span class="n">y</span><span class="o">)</span> <span class="o">=</span> <span class="o">(</span><span class="n">y</span><span class="o">,</span> <span class="n">x</span><span class="o">)</span> <span class="k">in</span>
</span><span class="line">  <span class="n">arr</span> <span class="n">swap</span> <span class="o">&gt;&gt;&gt;</span> <span class="n">first</span> <span class="n">f</span> <span class="o">&gt;&gt;&gt;</span> <span class="n">arr</span> <span class="n">swap</span>
</span><span class="line">
</span><span class="line"><span class="c">(** [f *** g] processes the first component of a pair with [f] and the second</span>
</span><span class="line"><span class="c">    with [g]. *)</span>
</span><span class="line"><span class="k">let</span> <span class="o">(</span> <span class="o">***</span> <span class="o">)</span> <span class="n">f</span> <span class="n">g</span> <span class="o">=</span>
</span><span class="line">  <span class="n">first</span> <span class="n">f</span> <span class="o">&gt;&gt;&gt;</span> <span class="n">second</span> <span class="n">g</span>
</span><span class="line">
</span><span class="line"><span class="c">(** [f &amp;&amp;&amp; g] processes a single value with [f] and [g] in parallel and</span>
</span><span class="line"><span class="c">    returns a pair with the results. *)</span>
</span><span class="line"><span class="k">let</span> <span class="o">(</span> <span class="o">&amp;&amp;&amp;</span> <span class="o">)</span> <span class="n">f</span> <span class="n">g</span> <span class="o">=</span>
</span><span class="line">  <span class="n">arr</span> <span class="o">(</span><span class="k">fun</span> <span class="n">x</span> <span class="o">-&gt;</span> <span class="o">(</span><span class="n">x</span><span class="o">,</span> <span class="n">x</span><span class="o">))</span> <span class="o">&gt;&gt;&gt;</span> <span class="o">(</span><span class="n">f</span> <span class="o">***</span> <span class="n">g</span><span class="o">)</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>Then, <code>example2</code> changes from:</p>
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
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">let</span> <span class="n">example2</span> <span class="n">commit</span> <span class="o">=</span>
</span><span class="line">  <span class="k">let</span> <span class="n">src</span> <span class="o">=</span> <span class="n">fetch</span> <span class="n">commit</span> <span class="k">in</span>
</span><span class="line">  <span class="k">let</span> <span class="n">base</span> <span class="o">=</span> <span class="n">docker_pull</span> <span class="s2">&quot;ocaml/opam2&quot;</span> <span class="k">in</span>
</span><span class="line">  <span class="k">let</span> <span class="n">build</span> <span class="n">ocaml_version</span> <span class="o">=</span>
</span><span class="line">    <span class="k">let</span> <span class="n">dockerfile</span> <span class="o">=</span> <span class="n">make_dockerfile</span> <span class="o">~</span><span class="n">base</span> <span class="o">~</span><span class="n">ocaml_version</span> <span class="k">in</span>
</span><span class="line">    <span class="k">let</span> <span class="n">image</span> <span class="o">=</span> <span class="n">build</span> <span class="o">~</span><span class="n">dockerfile</span> <span class="n">src</span> <span class="o">~</span><span class="n">label</span><span class="o">:</span><span class="n">ocaml_version</span> <span class="k">in</span>
</span><span class="line">    <span class="n">test</span> <span class="n">image</span>
</span><span class="line">  <span class="k">in</span>
</span><span class="line">  <span class="n">build</span> <span class="s2">&quot;4.07&quot;</span><span class="o">;</span>
</span><span class="line">  <span class="n">build</span> <span class="s2">&quot;4.08&quot;</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>to:</p>
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
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">let</span> <span class="n">example2</span> <span class="o">=</span>
</span><span class="line">  <span class="k">let</span> <span class="n">build</span> <span class="n">ocaml_version</span> <span class="o">=</span>
</span><span class="line">    <span class="n">first</span> <span class="o">(</span><span class="n">arr</span> <span class="o">(</span><span class="k">fun</span> <span class="n">base</span> <span class="o">-&gt;</span> <span class="n">make_dockerfile</span> <span class="o">~</span><span class="n">base</span> <span class="o">~</span><span class="n">ocaml_version</span><span class="o">))</span>
</span><span class="line">    <span class="o">&gt;&gt;&gt;</span> <span class="n">build_with_dockerfile</span> <span class="o">~</span><span class="n">label</span><span class="o">:</span><span class="n">ocaml_version</span>
</span><span class="line">    <span class="o">&gt;&gt;&gt;</span> <span class="n">test</span>
</span><span class="line">  <span class="k">in</span>
</span><span class="line">  <span class="n">arr</span> <span class="o">(</span><span class="k">fun</span> <span class="n">c</span> <span class="o">-&gt;</span> <span class="o">(</span><span class="bp">()</span><span class="o">,</span> <span class="n">c</span><span class="o">))</span>
</span><span class="line">  <span class="o">&gt;&gt;&gt;</span> <span class="o">(</span><span class="n">docker_pull</span> <span class="s2">&quot;ocaml/opam2&quot;</span> <span class="o">***</span> <span class="n">fetch</span><span class="o">)</span>
</span><span class="line">  <span class="o">&gt;&gt;&gt;</span> <span class="o">(</span><span class="n">build</span> <span class="s2">&quot;4.07&quot;</span> <span class="o">&amp;&amp;&amp;</span> <span class="n">build</span> <span class="s2">&quot;4.08&quot;</span><span class="o">)</span>
</span><span class="line">  <span class="o">&gt;&gt;&gt;</span> <span class="n">arr</span> <span class="o">(</span><span class="k">fun</span> <span class="o">(</span><span class="bp">()</span><span class="o">,</span> <span class="bp">()</span><span class="o">)</span> <span class="o">-&gt;</span> <span class="bp">()</span><span class="o">)</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>We've lost most of the variable names and instead have to use tuples, remembering where our values are.
It's not <em>too</em> bad here with two values,
but it gets very difficult very quickly as more are added and we start nesting tuples.
We also lost the ability to use an optional labelled argument in <code>build ~dockerfile src</code>
and instead need to use a new operation that takes a tuple of the dockerfile and the source.</p>
<p>Imagine that running the tests now requires getting the test cases from the source code.
In the original code, we'd just change <code>test image</code> to <code>test image ~using:src</code>.
In the arrow version, we need to duplicate the source before the build step,
run the build with <code>first build_with_dockerfile</code>,
and make sure the arguments are the right way around for a new <code>test_using</code>.</p>
<h2>Attempt three: a dart</h2>
<p>I started wondering whether there might be an easier way to achieve the same static analysis that you get with arrows,
but without the point-free syntax, and it seems that there is. Consider the monadic version of <code>example1</code>.
We had:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
<span class="line-number">6</span>
<span class="line-number">7</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">val</span> <span class="n">build</span> <span class="o">:</span> <span class="n">source</span> <span class="o">-&gt;</span> <span class="n">image</span> <span class="n">promise</span>
</span><span class="line"><span class="k">val</span> <span class="n">test</span> <span class="o">:</span> <span class="n">image</span> <span class="o">-&gt;</span> <span class="n">results</span> <span class="n">promise</span>
</span><span class="line">
</span><span class="line"><span class="k">let</span> <span class="n">example1</span> <span class="n">commit</span> <span class="o">=</span>
</span><span class="line">  <span class="k">let</span><span class="o">*</span> <span class="n">src</span> <span class="o">=</span> <span class="n">fetch</span> <span class="n">commit</span> <span class="k">in</span>
</span><span class="line">  <span class="k">let</span><span class="o">*</span> <span class="n">image</span> <span class="o">=</span> <span class="n">build</span> <span class="n">src</span> <span class="k">in</span>
</span><span class="line">  <span class="n">test</span> <span class="n">image</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>If you didn't know about monads, there is another way you might try to do this.
Instead of using <code>let*</code> to wait for the <code>fetch</code> to complete and then calling <code>build</code> with
the source, you might define <code>build</code> and <code>test</code> to take promises as inputs:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">val</span> <span class="n">build</span> <span class="o">:</span> <span class="n">source</span> <span class="n">promise</span> <span class="o">-&gt;</span> <span class="n">image</span> <span class="n">promise</span>
</span><span class="line"><span class="k">val</span> <span class="n">test</span> <span class="o">:</span> <span class="n">image</span> <span class="n">promise</span> <span class="o">-&gt;</span> <span class="n">results</span> <span class="n">promise</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>After all, fetching gives you a <code>source promise</code> and you want an <code>image promise</code>, so this seems very natural.
We could even have <code>example1</code> take a promise of the commit.
Then it looks like this:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">let</span> <span class="n">example1</span> <span class="n">commit</span> <span class="o">=</span>
</span><span class="line">  <span class="k">let</span> <span class="n">src</span> <span class="o">=</span> <span class="n">fetch</span> <span class="n">commit</span> <span class="k">in</span>
</span><span class="line">  <span class="k">let</span> <span class="n">image</span> <span class="o">=</span> <span class="n">build</span> <span class="n">src</span> <span class="k">in</span>
</span><span class="line">  <span class="n">test</span> <span class="n">image</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>That's good, because it's identical to the simple version we started with.
The problem is that it is inefficient:</p>
<ul>
<li>We call <code>example1</code> with the promise of the commit (we don't know what it is yet).
</li>
<li>Without waiting to find out which commit we're testing, we call <code>fetch</code>, getting back a promise of some source.
</li>
<li>Without waiting to get the source, we call <code>build</code>, getting a promise of an image.
</li>
<li>Without waiting for the build, we call <code>test</code>, getting a promise of the results.
</li>
</ul>
<p>We return the final promise of the test results immediately, but we haven't done any real work yet.
Instead, we've built up a long chain of promises, wasting memory.</p>
<p>However, in this situation what we want is to perform a static analysis.
i.e. we want to build up in memory some data structure representing the pipeline...
and this is exactly what our &quot;inefficient&quot; use of the monad produces!</p>
<p>To make this useful, we need the primitive operations (such as <code>fetch</code>)
to provide some information (e.g. labels) for the static analysis.
OCaml's <code>let</code> syntax doesn't provide an obvious place for a label,
but I was able to define an operator (<code>let**</code>) that returns a function taking a label argument.
It can be used to build primitive operations like this:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">let</span> <span class="n">fetch</span> <span class="n">commit</span> <span class="o">=</span>
</span><span class="line">  <span class="s2">&quot;fetch&quot;</span> <span class="o">|&gt;</span>
</span><span class="line">  <span class="k">let</span><span class="o">**</span> <span class="n">commit</span> <span class="o">=</span> <span class="n">commit</span> <span class="k">in</span>
</span><span class="line">  <span class="c">(* (standard monadic implementation of fetch goes here) *)</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>So, <code>fetch</code> takes a promise of a commit, does a monadic bind on it to wait for the actual commit and then proceeds as before,
but it labels the bind as a <code>fetch</code> operation.
If <code>fetch</code> took multiple arguments, it could use <code>and*</code> to wait for all of them in parallel.</p>
<p>In theory, the body of the <code>let**</code> in <code>fetch</code> could contain further binds.
In that case, we wouldn't be able to analyse the whole pipeline at the start.
But as long as the primitives wait for all their inputs at the start and don't do any binds internally,
we can discover the whole pipeline statically.</p>
<p>We can choose whether to expose these bind operations to application code or not.
If <code>let*</code> (or <code>let**</code>) is exposed, then applications get to use all the expressive power of monads,
but there will be points where we cannot show the whole pipeline until some promise resolves.
If we hide them, then applications can only make static pipelines.</p>
<p>My approach so far has been to use <code>let*</code> as an escape hatch, so that any required pipeline can be built,
but I later replace any uses of it by more specialised operations. For example, I added:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">val</span> <span class="n">list_map</span> <span class="o">:</span> <span class="o">(</span><span class="k">'</span><span class="n">a</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">b</span> <span class="n">t</span><span class="o">)</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">a</span> <span class="kt">list</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">b</span> <span class="kt">list</span> <span class="n">t</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>This processes each item in a list that isn't known until runtime.
However, we can still know statically what pipeline we will apply to each item,
even though we don't know what the items themselves are.
<code>list_map</code> could have been implemented using <code>let*</code>, but then we wouldn't be able to see the pipeline statically.</p>
<p>Here are the other two examples, using the dart approach:</p>
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
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">let</span> <span class="n">example2</span> <span class="n">commit</span> <span class="o">=</span>
</span><span class="line">  <span class="k">let</span> <span class="n">src</span> <span class="o">=</span> <span class="n">fetch</span> <span class="n">commit</span> <span class="k">in</span>
</span><span class="line">  <span class="k">let</span> <span class="n">base</span> <span class="o">=</span> <span class="n">docker_pull</span> <span class="s2">&quot;ocaml/opam2&quot;</span> <span class="k">in</span>
</span><span class="line">  <span class="k">let</span> <span class="n">build</span> <span class="n">ocaml_version</span> <span class="o">=</span>
</span><span class="line">    <span class="k">let</span> <span class="n">dockerfile</span> <span class="o">=</span>
</span><span class="line">      <span class="k">let</span><span class="o">+</span> <span class="n">base</span> <span class="o">=</span> <span class="n">base</span> <span class="k">in</span>
</span><span class="line">      <span class="n">make_dockerfile</span> <span class="o">~</span><span class="n">base</span> <span class="o">~</span><span class="n">ocaml_version</span> <span class="k">in</span>
</span><span class="line">    <span class="k">let</span> <span class="n">image</span> <span class="o">=</span> <span class="n">build</span> <span class="o">~</span><span class="n">dockerfile</span> <span class="n">src</span> <span class="o">~</span><span class="n">label</span><span class="o">:</span><span class="n">ocaml_version</span> <span class="k">in</span>
</span><span class="line">    <span class="n">test</span> <span class="n">image</span>
</span><span class="line">  <span class="k">in</span>
</span><span class="line">  <span class="n">all</span> <span class="o">[</span>
</span><span class="line">    <span class="n">build</span> <span class="s2">&quot;4.07&quot;</span><span class="o">;</span>
</span><span class="line">    <span class="n">build</span> <span class="s2">&quot;4.08&quot;</span>
</span><span class="line">  <span class="o">]</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>Compared to the original, we have an <code>all</code> to combine the results, and there's an extra <code>let+ base = base</code> when calculating the dockerfile.
<code>let+</code> is just another syntax for <code>map</code>, used here because I chose not to change the signature of <code>make_dockerfile</code>.
Alternatively, we could have <code>make_dockerfile</code> take a promise of the base image and do the map inside it instead.
Because <code>map</code> takes a pure body (<code>make_dockerfile</code> just generates a string; there are no promises or errors) it doesn't need its own box
on the diagrams and we don't lose anything by allowing its use.</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
<span class="line-number">6</span>
<span class="line-number">7</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">let</span> <span class="n">example3</span> <span class="n">commit</span> <span class="o">=</span>
</span><span class="line">  <span class="k">let</span> <span class="n">src</span> <span class="o">=</span> <span class="n">fetch</span> <span class="n">commit</span> <span class="k">in</span>
</span><span class="line">  <span class="k">let</span> <span class="n">image</span> <span class="o">=</span> <span class="n">build</span> <span class="n">src</span> <span class="k">in</span>
</span><span class="line">  <span class="k">let</span> <span class="n">ok</span> <span class="o">=</span> <span class="n">test</span> <span class="n">image</span> <span class="k">in</span>
</span><span class="line">  <span class="k">let</span> <span class="n">revdeps</span> <span class="o">=</span> <span class="n">get_revdeps</span> <span class="n">src</span> <span class="k">in</span>
</span><span class="line">  <span class="n">gate</span> <span class="n">revdeps</span> <span class="o">~</span><span class="n">on</span><span class="o">:</span><span class="n">ok</span> <span class="o">|&gt;</span>
</span><span class="line">  <span class="n">list_iter</span> <span class="o">~</span><span class="n">pp</span><span class="o">:</span><span class="nn">Fmt</span><span class="p">.</span><span class="n">string</span> <span class="n">example1</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>This shows another custom operation: <code>gate revdeps ~on:ok</code> is a promise that only resolves once both <code>revdeps</code> and <code>ok</code> have resolved.
This prevents it from testing the library's revdeps until the library's own tests have passed,
even though it could do this in parallel if we wanted it to.
Whereas with a monad we have to enable concurrency explicitly where we want it (using <code>and*</code>),
with a dart we have to disable concurrency explicitly where we don't want it (using <code>gate</code>).</p>
<p>I also added a <code>list_iter</code> convenience function,
and gave it a pretty-printer argument so that we can label the cases in the diagrams once the list inputs are known.</p>
<p>Finally, although I said that you can't use <code>let*</code> inside a primitive,
you can still use some other monad (that doesn't generate diagrams).
In fact, in the real system I used a separate <code>let&gt;</code> operator for primitives.
That expects a body using non-diagram-generating promises provided by the underlying promise library,
so you can't use <code>let*</code> (or <code>let&gt;</code>) inside the body of a primitive.</p>
<h2>Comparison with arrows</h2>
<p>Given a &quot;dart&quot; you can create an arrow interface from it easily by defining e.g.</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">type</span> <span class="o">(</span><span class="k">'</span><span class="n">a</span><span class="o">,</span> <span class="k">'</span><span class="n">b</span><span class="o">)</span> <span class="n">arrow</span> <span class="o">=</span> <span class="k">'</span><span class="n">a</span> <span class="n">promise</span> <span class="o">-&gt;</span> <span class="k">'</span><span class="n">b</span> <span class="n">promise</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>Then <code>arr</code> is just <code>map</code> and <code>f &gt;&gt;&gt; g</code> is just <code>fun x -&gt; g (f x)</code>. <code>first</code> can be defined easily too, assuming you have some kind
of function for doing two things in parallel (like our <code>and*</code> above).</p>
<p>So a dart API (even with <code>let*</code> hidden) is still enough to express any pipeline you can express using an arrow API.</p>
<p>The <a href="https://en.wikibooks.org/wiki/Haskell/Arrow_tutorial">Haskell Arrow tutorial</a> uses an example where an arrow is a stateful function.
For example, there is a <code>total</code> arrow that returns the sum of its input and every previous input it has been called with.
e.g. calling it three times with inputs <code>1 2 3</code> produces outputs <code>1 3 6</code>.
Running a pipeline on a sequence of inputs returns the sequence of outputs.</p>
<p>The tutorial uses <code>total</code> to define a <code>mean1</code> function like this:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
</pre></td><td class="code"><pre><code class="haskell"><span class="line"><span class="nf">mean1</span> <span class="ow">=</span> <span class="p">(</span><span class="n">total</span> <span class="o">&amp;&amp;&amp;</span> <span class="p">(</span><span class="n">arr</span> <span class="p">(</span><span class="n">const</span> <span class="mi">1</span><span class="p">)</span> <span class="o">&gt;&gt;&gt;</span> <span class="n">total</span><span class="p">))</span> <span class="o">&gt;&gt;&gt;</span> <span class="n">arr</span> <span class="p">(</span><span class="n">uncurry</span> <span class="p">(</span><span class="o">/</span><span class="p">))</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>So this pipeline duplicates each input number,
replaces the second one with <code>1</code>,
totals both streams, and then
replaces each pair with its ratio.
Each time you put another number into the pipeline, you get out the average of all values input so far.</p>
<p>The equivalent code using the dart style would be (OCaml uses <code>/.</code> for floating-point division):</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">let</span> <span class="n">mean</span> <span class="n">values</span> <span class="o">=</span>
</span><span class="line">  <span class="k">let</span> <span class="n">t</span> <span class="o">=</span> <span class="n">total</span> <span class="n">values</span> <span class="k">in</span>
</span><span class="line">  <span class="k">let</span> <span class="n">n</span> <span class="o">=</span> <span class="n">total</span> <span class="o">(</span><span class="n">const</span> <span class="mi">1</span><span class="o">.</span><span class="mi">0</span><span class="o">)</span> <span class="k">in</span>
</span><span class="line">  <span class="n">map</span> <span class="o">(</span><span class="n">uncurry</span> <span class="o">(/.))</span> <span class="o">(</span><span class="n">pair</span> <span class="n">t</span> <span class="n">n</span><span class="o">)</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>That seems more readable to me.
We can simplify the code slightly by defining the standard operators <code>let+</code> (for <code>map</code>) and <code>and+</code> (for <code>pair</code>):</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
<span class="line-number">6</span>
<span class="line-number">7</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">let</span> <span class="o">(</span><span class="k">let</span><span class="o">+)</span> <span class="n">x</span> <span class="n">f</span> <span class="o">=</span> <span class="n">map</span> <span class="n">f</span> <span class="n">x</span>
</span><span class="line"><span class="k">let</span> <span class="o">(</span><span class="ow">and</span><span class="o">+)</span> <span class="o">=</span> <span class="n">pair</span>
</span><span class="line">
</span><span class="line"><span class="k">let</span> <span class="n">mean</span> <span class="n">values</span> <span class="o">=</span>
</span><span class="line">  <span class="k">let</span><span class="o">+</span> <span class="n">t</span> <span class="o">=</span> <span class="n">total</span> <span class="n">values</span>
</span><span class="line">  <span class="ow">and</span><span class="o">+</span> <span class="n">n</span> <span class="o">=</span> <span class="n">total</span> <span class="o">(</span><span class="n">const</span> <span class="mi">1</span><span class="o">.</span><span class="mi">0</span><span class="o">)</span> <span class="k">in</span>
</span><span class="line">  <span class="n">t</span> <span class="o">/.</span> <span class="n">n</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>This is not a great example of an arrow anyway,
because we don't use the output of one stateful function as the input to another,
so this is actually just a plain <a href="https://en.wikipedia.org/wiki/Applicative_functor">applicative</a>.</p>
<p>We could easily extend the example pipeline with another stateful function though,
perhaps by adding some smoothing.
That would look like <code>mean1 &gt;&gt;&gt; smooth</code> in the arrow notation,
and <code>values |&gt; mean |&gt; smooth</code> (or <code>smooth (mean values)</code>) in the dart notation.</p>
<p>Note: Haskell does also have an <code>Arrows</code> syntax extension, which allows the Haskell code to be written as:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
</pre></td><td class="code"><pre><code class="haskell"><span class="line"><span class="nf">mean2</span> <span class="ow">=</span> <span class="n">proc</span> <span class="n">value</span> <span class="ow">-&gt;</span> <span class="kr">do</span>
</span><span class="line">    <span class="n">t</span> <span class="ow">&lt;-</span> <span class="n">total</span> <span class="o">-&lt;</span> <span class="n">value</span>
</span><span class="line">    <span class="n">n</span> <span class="ow">&lt;-</span> <span class="n">total</span> <span class="o">-&lt;</span> <span class="mi">1</span>
</span><span class="line">    <span class="n">returnA</span> <span class="o">-&lt;</span> <span class="n">t</span> <span class="o">/</span> <span class="n">n</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>That's more similar to the dart notation.</p>
<h2>Larger examples</h2>
<p>I've put up a library using a slightly extended version of these ideas at <a href="https://github.com/ocurrent/ocurrent">ocurrent/ocurrent</a>.
The <code>lib_term</code> subdirectory is the part relevant to this blog post, with the various combinators described in <a href="https://github.com/ocurrent/ocurrent/blob/00688f949f3cfbf3d599949f89ca71c8e9e536fc/lib_term/s.ml#L48">TERM</a>.
The other directories handle more concrete details, such as integration with the Lwt promise library,
and providing the admin web UI or the Cap'n Proto RPC interface, as well as plugins with primitives
for using Git, GitHub, Docker and Slack.</p>
<h3>OCaml Docker base image builder</h3>
<p><a href="https://github.com/ocurrent/docker-base-images">ocurrent/docker-base-images</a> contains a pipeline that builds Docker base images for OCaml for various Linux distributions, CPU architectures, OCaml compiler versions and configuration options.
For example, to test OCaml 4.09 on Debian 10, you can do:</p>
<pre><code>$ docker run --rm -it ocurrent/opam:debian-10-ocaml-4.09

:~$ ocamlopt --version
4.09.0

:~$ opam depext -i utop
[...]

:~$ utop
----+-------------------------------------------------------------+------------------
    | Welcome to utop version 2.4.2 (using OCaml version 4.09.0)! |                   
    +-------------------------------------------------------------+                   

Type #utop_help for help about using utop.

-( 11:50:06 )-&lt; command 0 &gt;-------------------------------------------{ counter: 0 }-
utop # 
</code></pre>
<p>Here's what the pipeline looks like (click for full-size):</p>
<p><a href="https://roscidus.com/blog/images/cicd/docker-base-images.svg"><img src="https://roscidus.com/blog/images/cicd/docker-base-images-thumb.png" class="center"/></a></p>
<p>It pulls the latest Git commit of opam-repository each week, then builds base images containing that and the opam package manager for each distribution version, then builds one image for each supported compiler variant. Many of the images are built on multiple architectures (<code>amd64</code>, <code>arm32</code>, <code>arm64</code> and <code>ppc64</code>) and pushed to a staging area on Docker Hub. Then, the pipeline combines all the hashes to push a multi-arch manifest to Docker Hub. There are also some aliases (e.g. <code>debian</code> means <code>debian-10-ocaml-4.09</code> at the moment). Finally, if there is any problem then the pipeline sends the error to a Slack channel.</p>
<p>You might wonder whether we really need a pipeline for this, rather than a simple script run from a cron-job.
But having a pipeline allows us to see what the pipeline will do before running it, watch the pipeline's progress, restart failed jobs individually, etc, with almost the same code we would have written anyway.</p>
<p>You can read <a href="https://github.com/ocurrent/docker-base-images/blob/f65663b09d78bbb17c39aca97cbd9425c2e7816e/src/pipeline.ml">pipeline.ml</a> if you want to see the full pipeline.</p>
<h3>OCaml CI</h3>
<p><a href="https://github.com/ocurrent/ocaml-ci">ocurrent/ocaml-ci</a> is an (experimental) GitHub app for testing OCaml projects.
The pipeline gets the list of installations of the app,
gets the configured repositories for each installation,
gets the branches and PRs for each repository,
and then tests the head of each one against multiple Linux distributions and OCaml compiler versions.
If the project uses ocamlformat, it also checks that the commit is formatted exactly as ocamlformat would do it.</p>
<p><a href="https://roscidus.com/blog/images/cicd/ocaml-ci.svg"><img src="https://roscidus.com/blog/images/cicd/ocaml-ci-thumb.png" class="center"/></a></p>
<p>The results are pushed back to GitHub as the commit status, and also recorded in a local index for the web and tty UIs.
There's quite a lot of red here mainly because if a project doesn't support a particular version of OCaml then the build is marked
as failed and shows up as red in the pipeline, although these failures are filtered out when making the GitHub status report.
We probably need a new colour for skipped stages.</p>
<h2>Conclusions</h2>
<p>It's convenient to write CI/CD pipelines as if they were single-shot scripts
that run the steps once, in series, and always succeed,
and then with only minor changes have the pipeline run the steps whenever
the input changes, in parallel, with logging, error reporting, cancellation
and rebuild support.</p>
<p>Using a monad allows any program to be converted easily to have these features,
but, as with a regular program, we don't know what the program will do with some
data until we run it. In particular, we can only automatically generate diagrams
showing steps that have already started.</p>
<p>The traditional way to do static analysis is to use an arrow.
This is a little more limited than a monad, because the structure of the pipeline
can't change depending on the input data, although we can add limited flexibility
such as optional steps or a choice between two branches.
However, writing pipelines using arrow notation is difficult because we have to
program in a point-free style (without variables).</p>
<p>We can get the same benefits of static analysis by using a monad in an unusual way,
here referred to as a &quot;dart&quot;.
Instead of functions that take plain values and return wrapped values, our functions
both take and return wrapped values. This results in a syntax that looks
identical to plain programming, but allows static analysis (at the cost of not being
able to manipulate the wrapped values directly).</p>
<p>If we hide (or don't use) the monad's <code>let*</code> (bind) function then the pipelines we
create can always be determined statically. If we use a bind, then there will be holes
in the pipeline that may expand to more pipeline stages as the pipeline runs.</p>
<p>Primitive steps can be created by using a single &quot;labelled bind&quot;, where the label
provides the static analysis for the atomic component.</p>
<p>I haven't seen this pattern used before (or mentioned in the arrow documentation),
and it seems to provide exactly the same benefits as arrows with much less difficulty.
If this has a proper name, let me know!</p>
<p>This work was funded by OCaml Labs.</p>

