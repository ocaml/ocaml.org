---
title: OCaml Functors
description: "In my OCaml project, I\u2019d like to abstract away the details of running
  containers into specific modules based on the OS. Currently, I have working container
  setups for Windows and Linux, and I\u2019ve haphazardly peppered if Sys.win32 then
  where I need differentiation, but this is OCaml, so let us use functors!"
url: https://www.tunbury.org/2025/07/01/ocaml-functors/
date: 2025-07-01T00:00:00-00:00
preview_image: https://www.tunbury.org/images/hot-functors.png
authors:
- Mark Elvers
source:
ignore:
---

<p>In my OCaml project, I’d like to abstract away the details of running containers into specific modules based on the OS. Currently, I have working container setups for Windows and Linux, and I’ve haphazardly peppered <code class="language-plaintext highlighter-rouge">if Sys.win32 then</code> where I need differentiation, but this is OCaml, so let us use <em>functors</em>!</p>

<p>I started by fleshing out the bare bones in a new project. After <code class="language-plaintext highlighter-rouge">dune init project functor</code>, I created <code class="language-plaintext highlighter-rouge">bin/s.ml</code> containing the signature of the module <code class="language-plaintext highlighter-rouge">CONTAINER</code>.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">module</span> <span class="k">type</span> <span class="nc">CONTAINER</span> <span class="o">=</span> <span class="k">sig</span>
  <span class="k">val</span> <span class="n">run</span> <span class="o">:</span> <span class="kt">string</span> <span class="o">-&gt;</span> <span class="kt">unit</span>
<span class="k">end</span>
</code></pre></div></div>

<p>Then a trivial <code class="language-plaintext highlighter-rouge">bin/linux.ml</code>.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">run</span> <span class="n">s</span> <span class="o">=</span> <span class="nn">Printf</span><span class="p">.</span><span class="n">printf</span> <span class="s2">"Linux container '%s'</span><span class="se">\n</span><span class="s2">"</span> <span class="n">s</span>
</code></pre></div></div>

<p>And <code class="language-plaintext highlighter-rouge">bin/windows.ml</code>.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">run</span> <span class="n">s</span> <span class="o">=</span> <span class="nn">Printf</span><span class="p">.</span><span class="n">printf</span> <span class="s2">"Windows container '%s'</span><span class="se">\n</span><span class="s2">"</span> <span class="n">s</span>
</code></pre></div></div>

<p>Then in <code class="language-plaintext highlighter-rouge">bin/main.ml</code>, I can select the container system once and from then on use <code class="language-plaintext highlighter-rouge">Container.foo</code> to run the appropriate OS specific function.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">container</span> <span class="o">=</span> <span class="k">if</span> <span class="nn">Sys</span><span class="p">.</span><span class="n">win32</span> <span class="k">then</span> <span class="p">(</span><span class="k">module</span> <span class="nc">Windows</span> <span class="o">:</span> <span class="nn">S</span><span class="p">.</span><span class="nc">CONTAINER</span><span class="p">)</span> <span class="k">else</span> <span class="p">(</span><span class="k">module</span> <span class="nc">Linux</span> <span class="o">:</span> <span class="nn">S</span><span class="p">.</span><span class="nc">CONTAINER</span><span class="p">)</span>

<span class="k">module</span> <span class="nc">Container</span> <span class="o">=</span> <span class="p">(</span><span class="k">val</span> <span class="n">container</span><span class="p">)</span>

<span class="k">let</span> <span class="bp">()</span> <span class="o">=</span> <span class="nn">Container</span><span class="p">.</span><span class="n">run</span> <span class="s2">"Hello, World!"</span>
</code></pre></div></div>

<p>You can additionally create <code class="language-plaintext highlighter-rouge">windows.mli</code> and <code class="language-plaintext highlighter-rouge">linux.mli</code> containing simply <code class="language-plaintext highlighter-rouge">include S.CONTAINER</code>.</p>

<p>Now, let’s imagine that we needed to have some specific configuration options depending upon whether we are running on Windows or Linux. For demonstration purposes, let’s use the user account. On Windows, this is a string, typically <code class="language-plaintext highlighter-rouge">ContainerAdministrator</code>, whereas on Linux, it’s an integer UID of value 0.</p>

<p>We can update the module type in <code class="language-plaintext highlighter-rouge">bin/s.ml</code> to include the type <code class="language-plaintext highlighter-rouge">t</code>, and add an <code class="language-plaintext highlighter-rouge">init</code> function to return a <code class="language-plaintext highlighter-rouge">t</code> and add <code class="language-plaintext highlighter-rouge">t</code> as a parameter to <code class="language-plaintext highlighter-rouge">run</code>.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">module</span> <span class="k">type</span> <span class="nc">CONTAINER</span> <span class="o">=</span> <span class="k">sig</span>
  <span class="k">type</span> <span class="n">t</span>

  <span class="k">val</span> <span class="n">init</span> <span class="o">:</span> <span class="kt">unit</span> <span class="o">-&gt;</span> <span class="n">t</span>
  <span class="k">val</span> <span class="n">run</span> <span class="o">:</span> <span class="n">t</span> <span class="o">-&gt;</span> <span class="kt">string</span> <span class="o">-&gt;</span> <span class="kt">unit</span>
<span class="k">end</span>
</code></pre></div></div>

<p>In <code class="language-plaintext highlighter-rouge">bin/linux.ml</code>, we can add the type and define <code class="language-plaintext highlighter-rouge">uid</code> as an integer, then add the <code class="language-plaintext highlighter-rouge">init</code> function to return the populated structure. <code class="language-plaintext highlighter-rouge">run</code> now accepts <code class="language-plaintext highlighter-rouge">t</code> as the first parameter.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">type</span> <span class="n">t</span> <span class="o">=</span> <span class="p">{</span>
  <span class="n">uid</span> <span class="o">:</span> <span class="kt">int</span><span class="p">;</span>
<span class="p">}</span>

<span class="k">let</span> <span class="n">init</span> <span class="bp">()</span> <span class="o">=</span> <span class="p">{</span> <span class="n">uid</span> <span class="o">=</span> <span class="mi">0</span> <span class="p">}</span>

<span class="k">let</span> <span class="n">run</span> <span class="n">t</span> <span class="n">s</span> <span class="o">=</span> <span class="nn">Printf</span><span class="p">.</span><span class="n">printf</span> <span class="s2">"Linux container user id %i says '%s'</span><span class="se">\n</span><span class="s2">"</span> <span class="n">t</span><span class="o">.</span><span class="n">uid</span> <span class="n">s</span>
</code></pre></div></div>

<p>In a similar vein, <code class="language-plaintext highlighter-rouge">bin/windows.ml</code> is updated like this</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">type</span> <span class="n">t</span> <span class="o">=</span> <span class="p">{</span>
  <span class="n">username</span> <span class="o">:</span> <span class="kt">string</span><span class="p">;</span>
<span class="p">}</span>

<span class="k">let</span> <span class="n">init</span> <span class="bp">()</span> <span class="o">=</span> <span class="p">{</span> <span class="n">username</span> <span class="o">=</span> <span class="s2">"ContainerAdministrator"</span> <span class="p">}</span>

<span class="k">let</span> <span class="n">run</span> <span class="n">t</span> <span class="n">s</span> <span class="o">=</span> <span class="nn">Printf</span><span class="p">.</span><span class="n">printf</span> <span class="s2">"Windows container user name %s says '%s'</span><span class="se">\n</span><span class="s2">"</span> <span class="n">t</span><span class="o">.</span><span class="n">username</span> <span class="n">s</span>
</code></pre></div></div>

<p>And finally, in <code class="language-plaintext highlighter-rouge">bin/main.ml</code> we run <code class="language-plaintext highlighter-rouge">Container.init ()</code> and use the returned type as a parameter to <code class="language-plaintext highlighter-rouge">Container.run</code>.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">container</span> <span class="o">=</span> <span class="k">if</span> <span class="nn">Sys</span><span class="p">.</span><span class="n">win32</span> <span class="k">then</span> <span class="p">(</span><span class="k">module</span> <span class="nc">Windows</span> <span class="o">:</span> <span class="nn">S</span><span class="p">.</span><span class="nc">CONTAINER</span><span class="p">)</span> <span class="k">else</span> <span class="p">(</span><span class="k">module</span> <span class="nc">Linux</span> <span class="o">:</span> <span class="nn">S</span><span class="p">.</span><span class="nc">CONTAINER</span><span class="p">)</span>

<span class="k">module</span> <span class="nc">Container</span> <span class="o">=</span> <span class="p">(</span><span class="k">val</span> <span class="n">container</span><span class="p">)</span>

<span class="k">let</span> <span class="n">c</span> <span class="o">=</span> <span class="nn">Container</span><span class="p">.</span><span class="n">init</span> <span class="bp">()</span>
<span class="k">let</span> <span class="bp">()</span> <span class="o">=</span> <span class="nn">Container</span><span class="p">.</span><span class="n">run</span> <span class="n">c</span> <span class="s2">"Hello, World!"</span>
</code></pre></div></div>
