---
title: OCaml &lt; 4.14, Fedora 42 and GCC 15
description: Late last week, @MisterDA added Fedora 42 support to the Docker base
  image builder. The new base images attempted to build over the weekend, but there
  have been a few issues!
url: https://www.tunbury.org/2025/04/22/ocaml-fedora-gcc/
date: 2025-04-22T00:00:00-00:00
preview_image: https://www.tunbury.org/images/ocaml-logo.png
authors:
- Mark Elvers
source:
ignore:
---

<p>Late last week, @MisterDA added Fedora 42 support to the <a href="https://images.ci.ocaml.org">Docker base image builder</a>. The new base images attempted to build over the weekend, but there have been a few issues!</p>

<p>The code I had previously added to force Fedora 41 to use the DNF version 5 syntax was specifically for version 41. For reference, the old syntax was <code class="language-plaintext highlighter-rouge">yum groupinstall -y 'C Development Tools and Libraries’</code>, and the new syntax is <code class="language-plaintext highlighter-rouge">yum group install -y 'c-development'</code>. Note the extra space.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">c_devtools_libs</span> <span class="o">:</span> <span class="p">(</span><span class="n">t</span><span class="o">,</span> <span class="kt">unit</span><span class="o">,</span> <span class="kt">string</span><span class="o">,</span> <span class="n">t</span><span class="p">)</span> <span class="n">format4</span> <span class="o">=</span>
  <span class="k">match</span> <span class="n">d</span> <span class="k">with</span>
  <span class="o">|</span> <span class="nt">`Fedora</span> <span class="nt">`V41</span> <span class="o">-&gt;</span> <span class="p">{</span><span class="o">|</span><span class="s2">"c-development"</span><span class="o">|</span><span class="p">}</span>
  <span class="o">|</span> <span class="nt">`Fedora</span> <span class="n">_</span> <span class="o">-&gt;</span> <span class="p">{</span><span class="o">|</span><span class="s2">"C Development Tools and Libraries"</span><span class="o">|</span><span class="p">}</span>
  <span class="o">|</span> <span class="n">_</span> <span class="o">-&gt;</span> <span class="p">{</span><span class="o">|</span><span class="s2">"Development Tools”|}
...
let dnf_version = match d with `Fedora `V41 -&gt; 5 | _ -&gt; 3
</span></code></pre></div></div>

<p>To unburden ourselves of this maintenance in future releases, I have inverted the logic so unmatched versions will use the new syntax.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="p">(</span><span class="n">dnf_version</span><span class="o">,</span> <span class="n">c_devtools_libs</span><span class="p">)</span> <span class="o">:</span> <span class="kt">int</span> <span class="o">*</span> <span class="p">(</span><span class="n">t</span><span class="o">,</span> <span class="kt">unit</span><span class="o">,</span> <span class="kt">string</span><span class="o">,</span> <span class="n">t</span><span class="p">)</span> <span class="n">format4</span> <span class="o">=</span>
  <span class="k">match</span> <span class="n">d</span> <span class="k">with</span>
  <span class="o">|</span> <span class="nt">`Fedora</span>
    <span class="p">(</span> <span class="nt">`V21</span> <span class="o">|</span> <span class="nt">`V22</span> <span class="o">|</span> <span class="nt">`V23</span> <span class="o">|</span> <span class="nt">`V24</span> <span class="o">|</span> <span class="nt">`V25</span> <span class="o">|</span> <span class="nt">`V26</span> <span class="o">|</span> <span class="nt">`V27</span> <span class="o">|</span> <span class="nt">`V28</span> <span class="o">|</span> <span class="nt">`V29</span>
    <span class="o">|</span> <span class="nt">`V30</span> <span class="o">|</span> <span class="nt">`V31</span> <span class="o">|</span> <span class="nt">`V32</span> <span class="o">|</span> <span class="nt">`V33</span> <span class="o">|</span> <span class="nt">`V34</span> <span class="o">|</span> <span class="nt">`V35</span> <span class="o">|</span> <span class="nt">`V36</span> <span class="o">|</span> <span class="nt">`V37</span> <span class="o">|</span> <span class="nt">`V38</span>
    <span class="o">|</span> <span class="nt">`V39</span> <span class="o">|</span> <span class="nt">`V40</span> <span class="p">)</span> <span class="o">-&gt;</span>
    <span class="p">(</span><span class="mi">3</span><span class="o">,</span> <span class="p">{</span><span class="o">|</span><span class="s2">"C Development Tools and Libraries"</span><span class="o">|</span><span class="p">})</span>
  <span class="o">|</span> <span class="nt">`Fedora</span> <span class="n">_</span> <span class="o">-&gt;</span> <span class="p">(</span><span class="mi">5</span><span class="o">,</span> <span class="p">{</span><span class="o">|</span><span class="s2">"c-development"</span><span class="o">|</span><span class="p">})</span>
  <span class="o">|</span> <span class="n">_</span> <span class="o">-&gt;</span> <span class="p">(</span><span class="mi">3</span><span class="o">,</span> <span class="p">{</span><span class="o">|</span><span class="s2">"Development Tools"</span><span class="o">|</span><span class="p">})</span>
</code></pre></div></div>

<p>Fedora 42 also removed <code class="language-plaintext highlighter-rouge">awk</code>, so it now needs to be specifically included as a dependency. However, this code is shared with Oracle Linux, which does not have a package called <code class="language-plaintext highlighter-rouge">awk</code>. Fortunately, both have a package called <code class="language-plaintext highlighter-rouge">gawk</code>!</p>

<p>The next issue is that Fedora 42 is the first of the distributions we build base images for that has moved to GCC 15, specifically GCC 15.0.1. This breaks all versions of OCaml &lt; 4.14.</p>

<p>The change is that the code below, which previously gave no information about the number or type of parameters. (see <code class="language-plaintext highlighter-rouge">runtime/caml/prims.h</code>)</p>

<div class="language-c highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">typedef</span> <span class="nf">value</span> <span class="p">(</span><span class="o">*</span><span class="n">c_primitive</span><span class="p">)();</span>
</code></pre></div></div>

<p>Now means that there are no parameters, aka:</p>

<div class="language-c highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">typedef</span> <span class="nf">value</span> <span class="p">(</span><span class="o">*</span><span class="n">c_primitive</span><span class="p">)(</span><span class="kt">void</span><span class="p">);</span>
</code></pre></div></div>

<p>This is caused by a change of the default compilter language version. See <a href="https://gcc.gnu.org/gcc-15/changes.html">GCC change log</a></p>

<blockquote>
  <p>C23 by default: GCC 15 changes the default language version for C compilation from <code class="language-plaintext highlighter-rouge">-std=gnu17</code> to <code class="language-plaintext highlighter-rouge">-std=gnu23</code>. If your code relies on older versions of the C standard, you will need to either add <code class="language-plaintext highlighter-rouge">-std=</code> to your build flags, or port your code; see the porting notes.</p>
</blockquote>

<p>Also see the <a href="https://gcc.gnu.org/gcc-15/porting_to.html#c23">porting notes</a>, and <a href="https://gcc.gnu.org/bugzilla/show_bug.cgi?id=118112">this bug report</a>.</p>

<p>This is <em>not</em> an immediate problem as OCaml-CI and opam-repo-ci only test against OCaml 4.14.2 and 5.3.0 on Fedora. I have opened <a href="https://github.com/ocurrent/docker-base-images/issues/320">issue#320</a> to track this problem.</p>
