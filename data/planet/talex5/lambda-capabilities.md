---
title: Lambda Capabilities
description:
url: https://roscidus.com/blog/blog/2023/04/26/lambda-capabilities/
date: 2023-04-26T10:00:00-00:00
preview_image:
featured:
authors:
- Thomas Leonard
---

<p>&quot;Is this software safe?&quot; is a question software engineers should be able to answer,
but doing so can be difficult.
Capabilities offer an elegant solution, but seem to be little known among functional programmers.
This post is an introduction to capabilities in the context of ordinary programming
(using plain functions, in the style of the lambda calculus).</p>

<p>Even if you're not interested in security,
capabilities provide a useful way to understand programs;
when trying to track down buggy behaviour,
it's very useful to know that some component <em>couldn't</em> have been the problem.</p>
<p><strong>Table of Contents</strong></p>
<ul>
<li><a href="https://roscidus.com/#the-problem">The Problem</a>
</li>
<li><a href="https://roscidus.com/#option-1-security-as-a-separate-concern">Option 1: Security as a separate concern</a>
</li>
<li><a href="https://roscidus.com/#option-2-purity">Option 2: Purity</a>
</li>
<li><a href="https://roscidus.com/#option-3-capabilities">Option 3: Capabilities</a>
<ul>
<li><a href="https://roscidus.com/#attenuation">Attenuation</a>
</li>
<li><a href="https://roscidus.com/#web-server-example">Web-server example</a>
</li>
<li><a href="https://roscidus.com/#use-at-different-scales">Use at different scales</a>
</li>
<li><a href="https://roscidus.com/#key-points">Key points</a>
</li>
</ul>
</li>
<li><a href="https://roscidus.com/#practical-considerations">Practical considerations</a>
<ul>
<li><a href="https://roscidus.com/#plumbing-capabilities-everywhere">Plumbing capabilities everywhere</a>
</li>
<li><a href="https://roscidus.com/#levels-of-support">Levels of support</a>
</li>
<li><a href="https://roscidus.com/#running-on-a-traditional-os">Running on a traditional OS</a>
</li>
<li><a href="https://roscidus.com/#use-with-existing-security-mechanisms">Use with existing security mechanisms</a>
</li>
<li><a href="https://roscidus.com/#thread-local-storage">Thread-local storage</a>
</li>
<li><a href="https://roscidus.com/#symlinks">Symlinks</a>
</li>
<li><a href="https://roscidus.com/#time-and-randomness">Time and randomness</a>
</li>
<li><a href="https://roscidus.com/#power-boxes">Power boxes</a>
</li>
</ul>
</li>
<li><a href="https://roscidus.com/#conclusions">Conclusions</a>
</li>
</ul>
<p>( this post also appeared on <a href="https://www.reddit.com/r/ProgrammingLanguages/comments/130an3z/lambda_capabilities/">Reddit</a>, <a href="https://news.ycombinator.com/item?id=35723557">Hacker News</a> and <a href="https://lobste.rs/s/uyj3vj/lambda_capabilities">Lobsters</a> )</p>
<h2>The Problem</h2>
<p>We have some application (for example, a web-server) that we want to run.
The application is many thousands of lines long and depends on dozens of third-party libraries,
which get updated on a regular basis.
I would like to be able to check, quickly and easily, that the application cannot do any of these things:</p>
<ul>
<li>Delete my files.
</li>
<li>Append a line to my <code>~/.ssh/authorized_keys</code> file.
</li>
<li>Act as a relay, allowing remote machines to attack other computers on my local network.
</li>
<li>Send telemetry to a third-party.
</li>
<li>Anything else bad that I forget to think about.
</li>
</ul>
<p>For example, here are some of the OCaml packages I use just to generate this blog:</p>
<p><a href="https://roscidus.com/blog/images/lambda-caps/blog-deps.svg"><span class="caption-wrapper center"><img src="https://roscidus.com/blog/images/lambda-caps/blog-deps.svg" title="Dependency graph for this blog" class="caption"/><span class="caption-text">Dependency graph for this blog</span></span></a></p>
<p>Having to read every line of every version of each of these packages in order to decide whether it's safe
to generate the blog clearly isn't practical.</p>
<p>I'll start by looking at traditional solutions to this problem, using e.g. containers or VMs,
and then show how to do better using capabilities.</p>
<h2>Option 1: Security as a separate concern</h2>
<p>A common approach to access control treats securing software as a separate activity to writing it.
Programmers write (insecure) software, and a security team writes a policy saying what it can do.
Examples include firewalls, containers, virtual machines, seccomp policies, SELinux and AppArmor.</p>
<p>The great advantage of these schemes is that security can be applied after the software is written, treating it as a black box.
However, it comes with many problems:</p>
<dl><dt>Confused deputy problem</dt>
<dd>
<p>Some actions are OK for one use but not for another.</p>
<p>For example, if the client of a web-server requests <code>https://example.com/../../etc/httpd/server-key.pem</code>
then we don't want the server to read this file and send it to them.
But the server does need to read this file for other reasons, so the policy must allow it.</p>
</dd>
<dt>Coarse-grained controls</dt>
<dd>
<p>All the modules making up the program are treated the same way,
even though you probably trust some more than others.</p>
<p>For example, we might trust the TLS implementation with the server's private key, but not the templating engine,
and I know the modules I wrote myself are not malicious.</p>
</dd>
<dt>Even well-typed programs go wrong</dt>
<dd>
<p>Programming in a language with static types is supposed to ensure that if the program compiles then it won't crash.
But the security policy can cause the program to fail even though it passed the compiler's checks.</p>
<p>For example, the server might sometimes need to send an email notification.
If it didn't do that while the security policy was being written, then that will be blocked.
Or perhaps the web-server didn't even have a notification system when the policy was written,
but has since been updated.</p>
</dd>
<dt>Policy language limitations</dt>
<dd>
<p>The security configuration is written in a new language, which must be learned.
It's usually not worth learning this just for one program,
so the people who write the program struggle to write the policy.
Also, the policy language often cannot express the desired policy,
since it may depend on concepts unique to the program
(e.g. controlling access based on a web-app user's ID, rather than local Unix user ID).</p>
</dd>
</dl>
<p>All of the above problems stem from trying to separate security from the code.
If the code were fully correct, we wouldn't need the security layer.
Checking that code is fully correct is hard,
but maybe there are easy ways to check automatically that it does at least satisfy our security requirements...</p>
<h2>Option 2: Purity</h2>
<p>One way to prevent programs from performing unwanted actions is to prevent <em>all</em> actions.
In pure functional languages, such as Haskell, the only way to interact with the outside world is to return the action you want to perform from <code>main</code>. For example:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
</pre></td><td class="code"><pre><code class="haskell"><span class="line"><span class="nf">f</span> <span class="ow">::</span> <span class="kt">Int</span> <span class="ow">-&gt;</span> <span class="kt">String</span>
</span><span class="line"><span class="nf">f</span> <span class="n">x</span> <span class="ow">=</span> <span class="o">...</span>
</span><span class="line">
</span><span class="line"><span class="nf">main</span> <span class="ow">::</span> <span class="kt">IO</span> <span class="nb">()</span>
</span><span class="line"><span class="nf">main</span> <span class="ow">=</span> <span class="n">putStr</span> <span class="p">(</span><span class="n">f</span> <span class="mi">42</span><span class="p">)</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>Even if we don't look at the code of <code>f</code>, we can be sure it only returns a <code>String</code> and performs no other actions
(assuming <a href="https://downloads.haskell.org/ghc/latest/docs/users_guide/exts/safe_haskell.html">Safe Haskell</a> is being used).
Assuming we trust <code>putStr</code>, we can be sure this program will only output a string to stdout and not perform any other actions.</p>
<p>However, writing only pure code is quite limiting. Also, we still need to audit all IO code.</p>
<h2>Option 3: Capabilities</h2>
<p>Consider this code (written in a small OCaml-like functional language, where <code>ref n</code> allocates a new memory location
initially containing <code>n</code>, and <code>!x</code> reads the current value of <code>x</code>):</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
<span class="line-number">6</span>
<span class="line-number">7</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">let</span> <span class="n">f</span> <span class="n">a</span> <span class="o">=</span> <span class="o">...</span>
</span><span class="line">
</span><span class="line"><span class="k">let</span> <span class="bp">()</span> <span class="o">=</span>
</span><span class="line">  <span class="k">let</span> <span class="n">x</span> <span class="o">=</span> <span class="n">ref</span> <span class="mi">5</span> <span class="k">in</span>
</span><span class="line">  <span class="k">let</span> <span class="n">y</span> <span class="o">=</span> <span class="n">ref</span> <span class="mi">10</span> <span class="k">in</span>
</span><span class="line">  <span class="n">f</span> <span class="n">x</span><span class="o">;</span>
</span><span class="line">  <span class="k">assert</span> <span class="o">(!</span><span class="n">y</span> <span class="o">=</span> <span class="mi">10</span><span class="o">)</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>Can we be sure that the assert won't fail, without knowing the definition of <code>f</code>?
Assuming the language doesn't provide unsafe backdoors (such as OCaml's <code>Obj.magic</code>), we can.
<code>f x</code> cannot change <code>y</code>, because <code>f x</code> does not have access to <code>y</code>.</p>
<p>So here is an access control system, built in to the lambda calculus itself!
At first glance this might not look very promising.
For example, while <code>f</code> doesn't have access to <code>y</code>, it does have access to any global variables defined before <code>f</code>.
It also, typically, has access to the file-system and network,
which are effectively globals too.</p>
<p>To make this useful, we ban global variables.
Then any top-level function like <code>f</code> can only access things passed to it explicitly as arguments.
Avoiding global variables is usually considered good practise, and some systems ban them for other reasons anyway
(for example, Rust doesn't allow global mutable state as it wouldn't be able to prevent races accessing it from multiple threads).</p>
<p>Returning to the Haskell example above (but now in OCaml syntax),
it looks like this in our capability system:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">let</span> <span class="n">f</span> <span class="n">x</span> <span class="o">=</span> <span class="o">...</span>
</span><span class="line">
</span><span class="line"><span class="k">let</span> <span class="n">main</span> <span class="n">ch</span> <span class="o">=</span> <span class="n">output_string</span> <span class="n">ch</span> <span class="o">(</span><span class="n">f</span> <span class="mi">42</span><span class="o">)</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>Since <code>f</code> is a top-level function, we know it does not close over any mutable state, and our <code>42</code> argument is pure data.
Therefore, the call <code>f 42</code> does not have access to, and therefore cannot affect,
any pre-existing state (including the filesystem).
Internally, it can use mutation (creating arrays, etc),
but it has nowhere to store any mutable values and so they will get GC'd after it returns.
<code>f</code> therefore appears as a pure function, and calling it multiple times will always give the same result,
just as in the Haskell version.</p>
<p><code>output_string</code> is also a top-level function, closing over no mutable state.
However, the function resulting from evaluating <code>output_string ch</code> is not top-level,
and without knowing anything more about it we should assume it has full access to the output channel <code>ch</code>.</p>
<p>If <code>main</code> is invoked with standard output as its argument, it may output a message to it,
but cannot affect other pre-existing state.</p>
<p>In this way, we can reason about the pure parts of our code as easily as with Haskell,
but we can also reason about the parts with side-effects.
Haskell's purity is just a special case of a more general rule:
the effects of a (top-level) function are bounded by its arguments.</p>
<h3>Attenuation</h3>
<p>So far, we've been thinking about what values are reachable through other values.
For example, the set of ref-cells that can be modified by <code>f x</code> is bounded by
the union of the set of ref cells reachable from the closure <code>f</code>
with the set of ref cells reachable from <code>x</code>.</p>
<p>One powerful aspect of capabilities is that we can use functions to implement whatever access controls we want.
For example, let's say we only want <code>f</code> to be able to set the ref-cell, but not read it.
We can just pass it a suitable function:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">let</span> <span class="n">x</span> <span class="o">=</span> <span class="n">ref</span> <span class="mi">0</span> <span class="k">in</span>
</span><span class="line"><span class="k">let</span> <span class="n">set</span> <span class="n">v</span> <span class="o">=</span>
</span><span class="line">  <span class="n">x</span> <span class="o">:=</span> <span class="n">v</span>
</span><span class="line"><span class="k">in</span>
</span><span class="line"><span class="n">f</span> <span class="n">set</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>Or perhaps we only want to allow inserting positive integers:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">let</span> <span class="n">set</span> <span class="n">v</span> <span class="o">=</span>
</span><span class="line">  <span class="k">if</span> <span class="n">v</span> <span class="o">&gt;</span> <span class="mi">0</span> <span class="k">then</span> <span class="n">set</span> <span class="n">v</span>
</span><span class="line">  <span class="k">else</span> <span class="n">invalid_arg</span> <span class="s2">&quot;Positive values only!&quot;</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>Or we can allow access to be revoked:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
<span class="line-number">6</span>
<span class="line-number">7</span>
<span class="line-number">8</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">let</span> <span class="n">r</span> <span class="o">=</span> <span class="n">ref</span> <span class="o">(</span><span class="nc">Some</span> <span class="n">set</span><span class="o">)</span> <span class="k">in</span>
</span><span class="line"><span class="k">let</span> <span class="n">set</span> <span class="n">v</span> <span class="o">=</span>
</span><span class="line">  <span class="k">match</span> <span class="o">!</span><span class="n">r</span> <span class="k">with</span>
</span><span class="line">  <span class="o">|</span> <span class="nc">Some</span> <span class="n">fn</span> <span class="o">-&gt;</span> <span class="n">fn</span> <span class="n">v</span>
</span><span class="line">  <span class="o">|</span> <span class="nc">None</span> <span class="o">-&gt;</span> <span class="n">invalid_arg</span> <span class="s2">&quot;Access revoked!&quot;</span>
</span><span class="line"><span class="k">in</span>
</span><span class="line"><span class="o">...</span>
</span><span class="line"><span class="n">r</span> <span class="o">:=</span> <span class="nc">None</span>		<span class="c">(* Revoke *)</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>Or we could limit the number of times it can be used:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">let</span> <span class="n">used</span> <span class="o">=</span> <span class="n">ref</span> <span class="mi">0</span> <span class="k">in</span>
</span><span class="line"><span class="k">let</span> <span class="n">set</span> <span class="n">v</span> <span class="o">=</span>
</span><span class="line">  <span class="k">if</span> <span class="o">!</span><span class="n">used</span> <span class="o">&lt;</span> <span class="mi">3</span> <span class="k">then</span> <span class="o">(</span><span class="n">incr</span> <span class="n">used</span><span class="o">;</span> <span class="n">set</span> <span class="n">v</span><span class="o">)</span>
</span><span class="line">  <span class="k">else</span> <span class="n">invalid_arg</span> <span class="s2">&quot;Quota exceeded&quot;</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>Or log each time it is used, tagged with a label that's meaningful to us
(e.g. the function to which we granted access):</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
<span class="line-number">6</span>
<span class="line-number">7</span>
<span class="line-number">8</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">let</span> <span class="n">log</span> <span class="o">=</span> <span class="n">ref</span> <span class="bp">[]</span> <span class="k">in</span>
</span><span class="line"><span class="k">let</span> <span class="n">set</span> <span class="n">name</span> <span class="n">v</span> <span class="o">=</span>
</span><span class="line">  <span class="k">let</span> <span class="n">msg</span> <span class="o">=</span> <span class="n">sprintf</span> <span class="s2">&quot;%S set it to %d&quot;</span> <span class="n">name</span> <span class="n">v</span> <span class="k">in</span>
</span><span class="line">  <span class="n">log</span> <span class="o">:=</span> <span class="n">msg</span> <span class="o">::</span> <span class="o">!</span><span class="n">log</span><span class="o">;</span>
</span><span class="line">  <span class="n">set</span> <span class="n">v</span>
</span><span class="line"><span class="k">in</span>
</span><span class="line"><span class="n">f</span> <span class="o">(</span><span class="n">set</span> <span class="s2">&quot;f&quot;</span><span class="o">);</span>
</span><span class="line"><span class="n">g</span> <span class="o">(</span><span class="n">set</span> <span class="s2">&quot;g&quot;</span><span class="o">)</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>Or all of the above.</p>
<p>In these examples, our function <code>f</code> never got direct access (permission) to <code>x</code>, yet was still able to affect it.
Therefore, in capability systems people often talk about &quot;authority&quot; rather than permission.
Roughly speaking, the <em>authority</em> of a subject is the set of actions that the subject could cause to happen,
now or in the future, on currently-existing resources.
Since it's only things that <em>might</em> happen, and we don't want to read all the code to find out exactly what
it might do, we're usually only interested in getting an upper-bound on a subject's authority,
to show that it <em>can't</em> do something.</p>
<p>The examples here all used a single function.
We may want to allow multiple operations on a single value (e.g. getting and setting a ref-cell),
and the usual techniques are available for doing that (e.g. having the function take the operation as its first argument,
or collecting separate functions together in a record, module or object).</p>
<h3>Web-server example</h3>
<p>Let's look at a more realistic example.
Here's a simple web-server (we are defining the <code>main</code> function, which takes two arguments):</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">let</span> <span class="n">main</span> <span class="n">net</span> <span class="n">htdocs</span> <span class="o">=</span>
</span><span class="line">  <span class="o">...</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>To use it, we pass it access to some network (<code>net</code>) and a directory tree with the content (<code>htdocs</code>).
Immediately we can see that this server does not access any part of the file-system outside of <code>htdocs</code>,
but that it may use the network. Here's a picture of the situation:</p>
<p><span class="caption-wrapper center"><img src="https://roscidus.com/blog/images/lambda-caps/web1.svg" title="Initial reference graph" class="caption"/><span class="caption-text">Initial reference graph</span></span></p>
<p>Notes on reading the diagram:</p>
<ul>
<li>The diagram shows a model of the reference graph, where each node represents some value (function, record, tuple, etc)
or aggregated group of values.
</li>
<li>An arrow from A to B indicates the possibility that some value in the group A holds a reference to
some value in the group B.
</li>
<li>The model is typically an <em>over-approximation</em>, so the lack of an arrow from A to B means that no such reference
exists, while the presence of an arrow just means we haven't ruled it out.
</li>
<li>Orange nodes here represent OCaml values.
</li>
<li>White boxes are directories.
They include all contained files and subdirectories, except those shown separately.
I've pulled out <code>htdocs</code> so we can see that <code>app</code> doesn't have access to the rest of <code>home</code>.
Just for emphasis, I also show <code>.ssh</code> separately.
I'm assuming here that a directory doesn't give access to its parent,
so <code>htdocs</code> can only be used to read files within that sub-tree.
</li>
<li><code>net</code> represents the network and everything else connected to it.
</li>
<li>In most operating systems, directories exist in the kernel's address space,
and so you cannot have a direct reference to them.
That's not a problem, but for now you may find it easier to imagine a system where the kernel and applications
are all a single program, in a single programming language.
</li>
<li>This diagram represents the state at a particular moment in time (when starting the application).
We could also calculate and show all the references that might ever come to exist,
given what we know about the behaviour of <code>app</code> and <code>net</code>.
Since we don't yet know anything about either,
we would have to assume that <code>app</code> might give <code>net</code> access to <code>htdocs</code> and to itself.
</li>
</ul>
<p>So, the diagram above shows the application <code>app</code> has been given references to <code>net</code> and to <code>htdocs</code> as arguments.</p>
<p>Looking at our checklist from the start:</p>
<ul>
<li>It can't delete all my files, but it might delete the ones in <code>htdocs</code>.
</li>
<li>It can't edit <code>~/.ssh/authorized_keys</code>.
</li>
<li>It might act as a relay, allowing remote machines to attack other computers on my local network.
</li>
<li>It might send telemetry to a third-party.
</li>
</ul>
<p>We can read the body of the function to learn more:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">let</span> <span class="n">main</span> <span class="n">net</span> <span class="n">htdocs</span> <span class="o">=</span>
</span><span class="line">  <span class="k">let</span> <span class="n">socket</span> <span class="o">=</span> <span class="nn">Net</span><span class="p">.</span><span class="n">listen</span> <span class="n">net</span> <span class="o">(`</span><span class="nc">Tcp</span> <span class="mi">8080</span><span class="o">)</span> <span class="k">in</span>
</span><span class="line">  <span class="k">let</span> <span class="n">handler</span> <span class="o">=</span> <span class="n">static_files</span> <span class="n">htdocs</span> <span class="k">in</span>
</span><span class="line">  <span class="nn">Http</span><span class="p">.</span><span class="n">serve</span> <span class="n">socket</span> <span class="n">handler</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>Note: <code>Net.listen net</code> is typical OCaml style for performing the <code>listen</code> operation on <code>net</code>.
We could also have used a record and written <code>net.listen</code> instead, which may look more familiar to some readers.</p>
<p>Here's an updated diagram, showing the moment when <code>Http.serve</code> is called.
The <code>app</code> group has been opened to show <code>socket</code> and <code>handler</code> separately:</p>
<p><span class="caption-wrapper center"><img src="https://roscidus.com/blog/images/lambda-caps/web2.svg" title="After reading the code of main" class="caption"/><span class="caption-text">After reading the code of main</span></span></p>
<p>We can see that the code in the HTTP library can only access the network via <code>socket</code>,
and can only access <code>htdocs</code> by using <code>handler</code>.
Assuming <code>Net.listen</code> is trust-worthy (we'll normally trust the platform's networking layer),
it's clear that the application doesn't make out-bound connections,
since <code>net</code> is used only to create a listening socket.</p>
<p>To know what the application might do to <code>htdocs</code>, we only have to read the definition of <code>static_files</code>:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">let</span> <span class="n">static_files</span> <span class="n">dir</span> <span class="n">request</span> <span class="o">=</span>
</span><span class="line">  <span class="nn">Path</span><span class="p">.</span><span class="n">load</span> <span class="o">(</span><span class="n">dir</span> <span class="o">/</span> <span class="n">request</span><span class="o">.</span><span class="n">path</span><span class="o">)</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>Now we can see that the application doesn't change any files; it only uses <code>htdocs</code> to read them.</p>
<p>Finally, expanding <code>Http.serve</code>:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">let</span> <span class="n">serve</span> <span class="n">socket</span> <span class="n">handle_request</span> <span class="o">=</span>
</span><span class="line">  <span class="k">while</span> <span class="bp">true</span> <span class="k">do</span>
</span><span class="line">    <span class="k">let</span> <span class="n">conn</span> <span class="o">=</span> <span class="nn">Net</span><span class="p">.</span><span class="n">accept</span> <span class="n">socket</span> <span class="k">in</span>
</span><span class="line">    <span class="n">handle_connection</span> <span class="n">conn</span> <span class="n">handle_request</span>
</span><span class="line">  <span class="k">done</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>We see that <code>handle_connection</code> has no way to share telemetry information between connections,
given that <code>handle_request</code> never stores anything.</p>
<p>We can tell these things after only looking at the code for a few seconds, even though dozens of libraries are being used.
In particular, we didn't have to read <code>handle_connection</code> or any of the HTTP parsing logic.</p>
<p>Now let's enable TLS. For this, we will require a configuration directory containing the server's key:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">let</span> <span class="n">main</span> <span class="o">~</span><span class="n">tls_config</span> <span class="n">net</span> <span class="n">htdocs</span> <span class="o">=</span>
</span><span class="line">  <span class="k">let</span> <span class="n">socket</span> <span class="o">=</span> <span class="nn">Net</span><span class="p">.</span><span class="n">listen</span> <span class="n">net</span> <span class="o">(`</span><span class="nc">Tcp</span> <span class="mi">8443</span><span class="o">)</span> <span class="k">in</span>
</span><span class="line">  <span class="k">let</span> <span class="n">tls_socket</span> <span class="o">=</span> <span class="nn">Tls</span><span class="p">.</span><span class="n">wrap</span> <span class="o">~</span><span class="n">tls_config</span> <span class="n">socket</span> <span class="k">in</span>
</span><span class="line">  <span class="k">let</span> <span class="n">handler</span> <span class="o">=</span> <span class="n">static_files</span> <span class="n">htdocs</span> <span class="k">in</span>
</span><span class="line">  <span class="nn">Http</span><span class="p">.</span><span class="n">serve</span> <span class="n">tls_socket</span> <span class="n">handler</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>OCaml syntax note: I used <code>~</code> to make <code>tls_config</code> a named argument; we wouldn't want to get this directory confused with <code>htdocs</code>!</p>
<p>We can see that only the TLS library gets access to the key.
The HTTP library interacts only with the TLS socket, which presumably does not reveal it.</p>
<p><span class="caption-wrapper center"><img src="https://roscidus.com/blog/images/lambda-caps/web3.svg" title="Updated graph showing TLS" class="caption"/><span class="caption-text">Updated graph showing TLS</span></span></p>
<p>Notice too how this fixes the problem we had with our original policy enforcement system.
There, an attacker could request <code>https://example.com/../tls_config/server.key</code> and the HTTP server might send the key.
But here, the handler cannot do that even if it wants to.
When <code>handler</code> loads a file, it does so via <code>htdocs</code>, which does not have access to <code>tls_config</code>.</p>
<p>The above server has pretty good security properties,
even though we didn't make any special effort to write secure code.
Security-conscious programmers will try to wrap powerful capabilities (like <code>net</code>)
with less powerful ones (like <code>socket</code>) as early as possible, making the code easier to understand.
A programmer uninterested in readability is likely to mix in more irrelevant code you have to skip through,
but even so it shouldn't take too long to track down where things like <code>net</code> and <code>htdocs</code> end up.
And even if they spread them throughout their entire application,
at least you avoid having to read all the libraries too!</p>
<p>By contrast, consider a more traditional (non-capability) style.
We start with:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">let</span> <span class="n">main</span> <span class="n">htdocs</span> <span class="o">=</span> <span class="o">...</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>Here, <code>htdocs</code> would be a plain string rather than a reference to a directory,
and the network would be reached through a global.
We can't tell anything about what this server could do from looking at this one line,
and even if we expand it, we won't be able to tell what all the functions it calls do, either.
We will end up having to follow every function call recursively through all of the server's
dependencies, and our analysis will be out of date as soon as any of them changes.</p>
<h3>Use at different scales</h3>
<p>We've seen that we can create an over-approximation of the reference graph by looking at just a small part of the code,
and then get a closer bound on the possible effects as needed
by expanding groups of values until we can prove the desired property.
For example, to prove that the application didn't modify <code>htdocs</code>, we followed <code>htdocs</code> by expanding <code>main</code> and then <code>static_files</code>.</p>
<p>Within a single process, a capability is a reference (pointer) to another value in the process's memory.
However, the diagrams also included arrows (capabilities) to things outside of the process, such as directories.
We can regard these as references to privileged proxy functions in the process that make calls to the OS kernel,
or (at a higher level of abstraction) we can consider them to be capabilities to the external resources themselves.</p>
<p>It is possible to build capability operating systems (in fact, this was the first use of capabilities).
Just as we needed to ban global variables to make a safe programming language,
we need to ban global namespaces to make a capability operating system.
For example, on FreeBSD this is done (on a per-process basis) by invoking the <a href="https://man.freebsd.org/cgi/man.cgi?query=cap_enter">cap_enter</a> system call.</p>
<p>We can zoom out even further, and consider a network of computers.
Here, an arrow between machines represents some kind of (unforgeable) network address or connection.
At the IP level, any process can connect to any address, but a capability system can be implemented on top.
<a href="http://www.erights.org/elib/distrib/captp/index.html">CapTP</a> (the Capability Transport Protocol) was an early system for this, but
<a href="https://capnproto.org/rpc.html">Cap'n Proto</a> (Capabilities and Protocols) is the modern way to do it.</p>
<p>So, thinking in terms of capabilities, we can zoom out to look at the security properties of the whole network,
yet still be able to expand groups as needed right down to the level of individual closures in a process.</p>
<h3>Key points</h3>
<ul>
<li>
<p>Library code can be imported and called without it getting access to any pre-existing state,
except that given to it explicitly. There is no &quot;ambient authority&quot; available to the library.</p>
</li>
<li>
<p>A function's side-effects are bounded by its arguments.
We can understand (get a bound on) the behaviour of a function call just by looking at it.</p>
</li>
<li>
<p>If <code>a</code> has access to <code>b</code> and to <code>c</code>, then <code>a</code> can introduce them (e.g. by performing the function call <code>b c</code>).
Note that there is no capability equivalent to making something &quot;world readable&quot;;
to perform an introduction,
you need access to both the resource being granted and to the recipient (&quot;only connectivity begets connectivity&quot;).</p>
</li>
<li>
<p>Instead of passing the <em>name</em> of a resource, we pass a capability reference (pointer) to it,
thereby proving that we have access to it and sharing that access (&quot;no designation without authority&quot;).</p>
</li>
<li>
<p>The caller of a function decides what it should access, and can provide restricted access by wrapping
another capability, or substituting something else entirely.</p>
<p>I am sometimes unable to install a messaging app on my phone because it requires me to grant it
access to my address book.
A capability system should never say &quot;This application requires access to the address book. Continue?&quot;;
it should say &quot;This application requires access to <em>an</em> address book; which would you like to use?&quot;.</p>
</li>
<li>
<p>A capability must behave the same way regardless of who uses it.
When we do <code>f x</code>, <code>f</code> can perform exactly the same operations on <code>x</code> that we can.</p>
<p>It is tempting to add a traditional policy language alongside capabilities for &quot;extra security&quot;,
saying e.g. &quot;<code>f</code> cannot write to <code>x</code>, even if it has a reference to it&quot;.
However, apart from being complicated and annoying,
this creates an incentive for <code>f</code> to smuggle <code>x</code> to another context with more powers.
This is the root cause of many real-world attacks, such as click-jacking or cross-site request forgery,
where a URL permits an attack if a victim visits it, but not if the attacker does.
One of the great benefits of capability systems is that you don't need to worry that someone is trying to trick you
into doing something that you can do but they can't,
because your ability to access the resource they give you comes entirely from them in the first place.</p>
</li>
</ul>
<p>All of the above follow naturally from using functions in the usual way, while avoiding global variables.</p>
<h2>Practical considerations</h2>
<p>The above discussion argues that capabilities would have been a good way to build systems in an ideal world.
But given that most current operating systems and programming languages have not been designed this way,
how useful is this approach?
I'm currently working on <a href="https://github.com/ocaml-multicore/eio">Eio</a>, an IO library for OCaml, and using these principles to guide the design.
Here are a few thoughts about applying capabilities to a real system.</p>
<h3>Plumbing capabilities everywhere</h3>
<p>A lot of people worry about cluttering up their code by having to pass things explicitly everywhere.
This is actually not much of a problem, for a couple of reasons:</p>
<ol>
<li>
<p>We already do this with most things anyway.
If your program uses a database, you probably establish a connection to it at the start and pass the connection around as needed.
You probably also pass around open file handles, configuration settings, HTTP connection pools, arrays, queues, ref-cells, etc.
Handling &quot;the file-system&quot; and &quot;the network&quot; the same way as everything else isn't a big deal.</p>
</li>
<li>
<p>You can often bundle up a capability with something else.
For example, a web-server will likely let the user decide which directory to serve,
so you're already passing around a pathname argument.
Passing a path capability instead is no extra work.</p>
</li>
</ol>
<p>Consider a request handler that takes the address of a Redis server:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="nn">Http</span><span class="p">.</span><span class="n">serve</span> <span class="n">socket</span> <span class="o">(</span><span class="n">handle_request</span> <span class="n">redis_url</span><span class="o">)</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>It might seem that by using capabilities we'd need to pass the network in here too:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="nn">Http</span><span class="p">.</span><span class="n">serve</span> <span class="n">socket</span> <span class="o">(</span><span class="n">handle_request</span> <span class="n">net</span> <span class="n">redis_url</span><span class="o">)</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>This is both messy and unnecessary.
Instead, <code>handle_request</code> can take a function for connecting to Redis:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="nn">Http</span><span class="p">.</span><span class="n">serve</span> <span class="n">socket</span> <span class="o">(</span><span class="n">handle_request</span> <span class="n">redis</span><span class="o">)</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>Then there is only one argument to pass around again.
Instead of writing the connection logic in <code>handle_request</code>, we write the same logic outside and just pass in the function.
And now someone looking at the code can see &quot;the handler can connect to Redis&quot;,
rather than the less precise &quot;the handler accesses the network&quot;.
Of course, if Redis required more than one configuration setting then you'd probably already be doing it this way.</p>
<p>The main problematic case is providing <em>defaults</em>.
For example, a TLS library might allow us to specify the location of the system's certificate store,
but it would like to provide a default (e.g. <code>/etc/ssl/certs/</code>).
This is particularly important if the default location varies by platform.
If the TLS library decides the location, then we must give it (read-only at least) access to the whole system!
We may just decide to trust the library, or we might separate out the default paths into a trusted package.</p>
<h3>Levels of support</h3>
<p>Ideally, our programming language would provide a secure implementation of capabilities that we could depend on.
That would allow running untrusted code safely and protect us from compromised packages.
However, converting a non-capability language to a capability-secure one isn't easy,
and isn't likely to happen any time soon for OCaml
(but see <a href="https://www.hpl.hp.com/techreports/2006/HPL-2006-116.pdf">Emily</a> for an old proof-of-concept).</p>
<p>Even without that, though, capabilities help to protect non-malicious code from malicious inputs.
For example, the request handler above forgot to sanitise the URL path from the remote client,
but it still can't access anything outside of <code>htdocs</code>.</p>
<p>And even if we don't care about security at all, capabilities make it easy to see what a program does;
they make it easy to test programs by replacing OS resources with mocks;
and preventing access to globals helps to avoid race conditions,
since two functions that access the same resource must be explicitly introduced.</p>
<h3>Running on a traditional OS</h3>
<p>A capability OS would let us run a program's <code>main</code> function and provide the capabilities it wanted directly,
but most systems don't work like that.
Instead, each program requires a small trusted entrypoint that has the full privileges of the process.
In Eio, an application will typically start something like this:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="nn">Eio_main</span><span class="p">.</span><span class="n">run</span> <span class="o">@@</span> <span class="k">fun</span> <span class="n">env</span> <span class="o">-&gt;</span>
</span><span class="line"><span class="k">let</span> <span class="n">net</span> <span class="o">=</span> <span class="nn">Eio</span><span class="p">.</span><span class="nn">Stdenv</span><span class="p">.</span><span class="n">net</span> <span class="n">env</span> <span class="k">in</span>
</span><span class="line"><span class="k">let</span> <span class="n">fs</span> <span class="o">=</span> <span class="nn">Eio</span><span class="p">.</span><span class="nn">Stdenv</span><span class="p">.</span><span class="n">fs</span> <span class="n">env</span> <span class="k">in</span>
</span><span class="line"><span class="nn">Eio</span><span class="p">.</span><span class="nn">Path</span><span class="p">.</span><span class="n">with_open_dir</span> <span class="o">(</span><span class="n">fs</span> <span class="o">/</span> <span class="s2">&quot;/srv/www&quot;</span><span class="o">)</span> <span class="o">@@</span> <span class="k">fun</span> <span class="n">htdocs</span> <span class="o">-&gt;</span>
</span><span class="line"><span class="n">main</span> <span class="n">net</span> <span class="n">htdocs</span>
</span></code></pre></td></tr></tbody></table></div></figure><p><code>Eio_main.run</code> starts the Eio event loop and then runs the callback.
The <code>env</code> argument gives full access to the process's environment.
Here, the callback extracts network and filesystem access from this,
gets access to just &quot;/srv/www&quot; from <code>fs</code>,
and then calls the <code>main</code> function as before.</p>
<p>Note that <code>Eio_main.run</code> itself is not a capability-safe function (it magics up <code>env</code> from nothing).
A capability-enforcing compiler would flag this bit up as needing to be audited manually.</p>
<h3>Use with existing security mechanisms</h3>
<p>Maybe you're not convinced by all this capability stuff.
Traditional security systems are more widely available, better tested, and approved by your employer,
and you want to use that instead.
Still, to write the policy, you're going to need a list of resources the program might access.
Looking at the above code, we can immediately see that the policy need allow access only to the &quot;/srv/www&quot; directory,
and so we could call e.g. <a href="https://man.openbsd.org/unveil">unveil</a> here.
And if <code>main</code> later changes to use TLS,
the type-checker will let us know to update this code to provide the TLS configuration
and we'll know to update the policy at the same time.</p>
<p>If you want to drop privileges, such a program also makes it easy to see when it's safe to do that.
For example, looking at <code>main</code> we can see that <code>net</code> is never used after creating the socket,
so we don't need the <code>bind</code> system call after that,
and we never need <code>connect</code>.
We know, for instance, that this program isn't hiding an XML parser that needs to download schema files to validate documents.</p>
<h3>Thread-local storage</h3>
<p>In addition to global and local variables, systems often allow us to attach data to threads as a sort of middle ground.
This could allow unexpected interactions. For example:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">let</span> <span class="n">x</span> <span class="o">=</span> <span class="n">ref</span> <span class="mi">0</span> <span class="k">in</span>
</span><span class="line"><span class="n">f</span> <span class="n">x</span><span class="o">;</span>
</span><span class="line"><span class="n">g</span> <span class="bp">()</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>Here, we'd expect that <code>g</code> doesn't have access to <code>x</code>, but <code>f</code> could pass it using thread-local storage.
To prevent that, Eio instead provides <a href="https://ocaml-multicore.github.io/eio/eio/Eio/Fiber/index.html#val-with_binding">Fiber.with_binding</a>,
which runs a function with a binding but then puts things back how they were before returning,
so <code>f</code> can't make changes that are still active when <code>g</code> runs.</p>
<p>This also allows people who don't want capabilities to disable the whole system easily:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
<span class="line-number">6</span>
<span class="line-number">7</span>
<span class="line-number">8</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="k">let</span> <span class="n">everything</span> <span class="o">=</span> <span class="nn">Fiber</span><span class="p">.</span><span class="n">create_key</span> <span class="bp">()</span>
</span><span class="line">
</span><span class="line"><span class="k">let</span> <span class="n">f</span> <span class="bp">()</span> <span class="o">=</span>
</span><span class="line">  <span class="k">let</span> <span class="n">env</span> <span class="o">=</span> <span class="nn">Option</span><span class="p">.</span><span class="n">get</span> <span class="o">(</span><span class="nn">Fiber</span><span class="p">.</span><span class="n">get</span> <span class="n">everything</span><span class="o">)</span> <span class="k">in</span>
</span><span class="line">  <span class="o">...</span>
</span><span class="line">
</span><span class="line"><span class="k">let</span> <span class="n">main</span> <span class="n">env</span> <span class="o">=</span>
</span><span class="line">  <span class="nn">Fiber</span><span class="p">.</span><span class="n">with_binding</span> <span class="n">everything</span> <span class="n">env</span> <span class="n">f</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>It looks like <code>f ()</code> doesn't have access to anything, but in fact it can recover <code>env</code> and get access to everything!
However, anyone trying to understand the code will start following <code>env</code> from the main entrypoint
and will then see that it got put in fiber-local storage.
They then at least know that they must read all the code to understand anything about what it can do.</p>
<p>More usefully, this mechanism allows us to make just a few things ambiently available.
For example, we don't want to have to plumb stderr through to a function every time we want to do some <code>printf</code> debugging,
so it makes sense to provide a tracing function this way (and Eio does this by default).
Tracing allows all components to write debug messages, but it doesn't let them read them.
Therefore, it doesn't provide a way for components to communicate with each other.</p>
<p>It might be tempting to use <code>Fiber.with_binding</code> to restrict access to part of a program
(e.g. giving an HTTP server network access this way),
but note that this is a non-capability way to do things,
and suffers the same problems as traditional security systems,
separating designation from authority.
In particular, supposedly sandboxed code in other parts of the application
can try to escape by tricking the HTTP server part into running a callback function for them.
But fiber local storage is fine for things to which you don't care to restrict access.</p>
<h3>Symlinks</h3>
<p>Symlinks are a bit of a pain! If I have a capability reference to a directory, it's useful to know that I can only access things beneath that directory. But the directory may contain a symlink that points elsewhere.</p>
<p>One option would be to say that a symlink is a capability itself, but this means that you could only create symlinks to things you can access yourself, and this is quite a restriction. For example, you might be forbidden from extracting a tarball because <code>tar</code> didn't have permission to the target of a symlink it wanted to create.</p>
<p>The other option is to say that symlinks are just strings, and it's up to the user to interpret them.
This is the approach FreeBSD uses. When you use a system call like <code>openat</code>,
you pass a capability to a base directory and a string path relative to that.
In the case of our web-server, we'd use a capability for <code>htdocs</code>, but use strings to reference things inside it, allowing the server to follow symlinks within that sub-tree, but not outside.</p>
<p>The main problem is that it makes the API a bit confusing. Consider:</p>
<figure class="code"><div class="highlight"><table><tbody><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
</pre></td><td class="code"><pre><code class="ocaml"><span class="line"><span class="n">save_to</span> <span class="o">(</span><span class="n">htdocs</span> <span class="o">/</span> <span class="s2">&quot;uploads&quot;</span><span class="o">)</span>
</span></code></pre></td></tr></tbody></table></div></figure><p>It might look like <code>save_to</code> is only getting access to the &quot;uploads&quot; directory,
but in Eio it actually gets access to the whole of <code>htdocs</code>.
If you want to restrict access, you have to do that explicitly
(as we did when creating <code>htdocs</code> from <code>fs</code>).</p>
<p>The advantage, however, is that we don't break software that relies on symlinks.
Also, restricting access is quite expensive on some systems (FreeBSD has the handy <code>O_BENEATH</code> open flag,
and Linux has <code>RESOLVE_BENEATH</code>, but not all systems provide this), so might not be a good default.
I'm not completely satisfied with the current API, though.</p>
<h3>Time and randomness</h3>
<p>It is also possible to use capabilities to restrict access to time and randomness.
The security benefits here are less clear.
Tracking access to time can be useful in preventing side-channel attacks that depend on measuring time accurately,
but controlling access to randomness makes it difficult to e.g. randomise hash functions to
help prevent denial-of-service-attacks.</p>
<p>However, controlling access to these does have the advantage of making code deterministic by default,
which is a great benefit, especially for expect-style testing.
Your top level test function is called with no arguments, and therefore has no access to non-determinism,
instead creating deterministic mocks to use with the code under test.
You can then just record a good trace of a test's operations and check that it doesn't change.</p>
<h3>Power boxes</h3>
<p>Interactive applications that load and save files present a small problem:
since the user might load or save anywhere, it seems they need access to the whole file-system.
The solution is a &quot;powerbox&quot;.
The powerbox has access to the file-system and the rest of the application only has access to the powerbox.
When the application wants to save a file, it asks the powerbox, which pops up a GUI asking the user to choose the location.
Then it opens the file and passes that back to the application.</p>
<h2>Conclusions</h2>
<p>Currently-popular security mechanisms are complex and have many shortcomings.
Yet, the lambda calculus already contains an excellent security mechanism,
and making use of it requires little more than avoiding global variables.</p>
<p>This is known as &quot;capability-based security&quot;.
The word &quot;capabilities&quot; has also been used for several unrelated concepts (such as &quot;POSIX capabilities&quot;),
and for clarity much of the community rebranded a while back as &quot;Object Capabilities&quot;,
but this can make it seem irrelevant to functional programmers.
In fact, I wrote this blog post because several OCaml programmers have asked me what the point of capabilities is.
I was expecting it to be quite short (basically: applying functions to arguments good, global variables bad),
but it's got quite long; it seems there is a fair bit that follows from this simple idea!</p>
<p>Instead of seeing security as an extra layer that runs separately from the code and tries to guess what it meant to do,
capabilities fit naturally into the language.
The key difference with traditional security is that
the ability to do something depends on the reference used to do it, not on the identity of the caller.
This way of thinking about security works not only for controlling access to resources within a single program,
but also for controlling interactions between processes running on a machine, and between machines on a network.
We can group together resources and zoom out to see the overall picture, or expand groups to zoom in and get a closer
bound on the behaviour.</p>
<p>Even ignoring security, a key question is: what can a function do?
Should a function call be able to do anything at all that the process can do,
or should its behaviour be bounded in some way that is obvious just by looking at it?
If we say that you must read the source code of a function to see what it does, then this applies recursively:
we must also read all the functions that it calls, and so on.
To understand the <code>main</code> function, we end up having to read the code of every library it uses!</p>
<p>If you want to read more,
the <a href="http://habitatchronicles.com/2017/05/what-are-capabilities/">What Are Capabilities?</a> blog post provides a good overview;
Part II of <a href="https://papers.agoric.com/papers/robust-composition/abstract/">Robust Composition</a> contains a longer explanation;
<a href="https://srl.cs.jhu.edu/pubs/SRL2003-02.pdf">Capability Myths Demolished</a> does a good job of enumerating security properties provided by capabilities;
my own <a href="https://roscidus.com/blog/about/#the-serscis-access-modeller">SERSCIS Access Modeller</a> paper shows how to analyse systems
where some components have unknown behaviour; and, for historical interest, see
Dennis and Van Horn's 1966 <a href="https://dl.acm.org/doi/pdf/10.1145/365230.365252">Programming Semantics for Multiprogrammed Computations</a>, which introduced the idea.</p>

