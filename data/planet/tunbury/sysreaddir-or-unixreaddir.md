---
title: Sys.readdir or Unix.readdir
description: When you recursively scan a massive directory tree, would you use Sys.readdir
  or Unix.readdir? My inclination is that Sys.readdir feels more convenient to use,
  and thus the lower-level Unix.readdir would have the performance edge. Is it significant
  enough to bother with?
url: https://www.tunbury.org/2025/07/08/unix-or-sys/
date: 2025-07-08T00:00:00-00:00
preview_image: https://www.tunbury.org/images/sys-or-unix.png
authors:
- Mark Elvers
source:
ignore:
---

<p>When you recursively scan a massive directory tree, would you use <code class="language-plaintext highlighter-rouge">Sys.readdir</code> or <code class="language-plaintext highlighter-rouge">Unix.readdir</code>? My inclination is that <code class="language-plaintext highlighter-rouge">Sys.readdir</code> feels more convenient to use, and thus the lower-level <code class="language-plaintext highlighter-rouge">Unix.readdir</code> would have the performance edge. Is it significant enough to bother with?</p>

<p>Quickly coding up the two different options for comparison. Here’s the <code class="language-plaintext highlighter-rouge">Unix.readdir</code> version, running <code class="language-plaintext highlighter-rouge">Unix.opendir</code> then recursively calling <code class="language-plaintext highlighter-rouge">Unix.readdir</code> until the <code class="language-plaintext highlighter-rouge">End_of_file</code> exception is raised.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="k">rec</span> <span class="n">traverse_directory_unix</span> <span class="n">path</span> <span class="n">x</span> <span class="o">=</span>
  <span class="k">let</span> <span class="n">stats</span> <span class="o">=</span> <span class="nn">Unix</span><span class="p">.</span><span class="n">lstat</span> <span class="n">path</span> <span class="k">in</span>
  <span class="k">match</span> <span class="n">stats</span><span class="o">.</span><span class="n">st_kind</span> <span class="k">with</span>
  <span class="o">|</span> <span class="nn">Unix</span><span class="p">.</span><span class="nc">S_REG</span> <span class="o">-&gt;</span> <span class="n">x</span> <span class="o">+</span> <span class="mi">1</span>
  <span class="o">|</span> <span class="nc">S_LNK</span> <span class="o">|</span> <span class="nc">S_CHR</span> <span class="o">|</span> <span class="nc">S_BLK</span> <span class="o">|</span> <span class="nc">S_FIFO</span> <span class="o">|</span> <span class="nc">S_SOCK</span> <span class="o">-&gt;</span> <span class="n">x</span>
  <span class="o">|</span> <span class="nc">S_DIR</span> <span class="o">-&gt;</span>
      <span class="k">try</span>
        <span class="k">let</span> <span class="n">dir_handle</span> <span class="o">=</span> <span class="nn">Unix</span><span class="p">.</span><span class="n">opendir</span> <span class="n">path</span> <span class="k">in</span>
        <span class="k">let</span> <span class="k">rec</span> <span class="n">read_entries</span> <span class="n">acc</span> <span class="o">=</span>
          <span class="k">try</span>
            <span class="k">match</span> <span class="nn">Unix</span><span class="p">.</span><span class="n">readdir</span> <span class="n">dir_handle</span> <span class="k">with</span>
            <span class="o">|</span> <span class="s2">"."</span> <span class="o">|</span> <span class="s2">".."</span> <span class="o">-&gt;</span> <span class="n">read_entries</span> <span class="n">acc</span>
            <span class="o">|</span> <span class="n">entry</span> <span class="o">-&gt;</span>
                <span class="k">let</span> <span class="n">full_path</span> <span class="o">=</span> <span class="nn">Filename</span><span class="p">.</span><span class="n">concat</span> <span class="n">path</span> <span class="n">entry</span> <span class="k">in</span>
                <span class="n">read_entries</span> <span class="p">(</span><span class="n">traverse_directory_unix</span> <span class="n">full_path</span> <span class="n">acc</span><span class="p">)</span>
          <span class="k">with</span> <span class="nc">End_of_file</span> <span class="o">-&gt;</span>
            <span class="nn">Unix</span><span class="p">.</span><span class="n">closedir</span> <span class="n">dir_handle</span><span class="p">;</span>
            <span class="n">acc</span>
        <span class="k">in</span>
        <span class="n">read_entries</span> <span class="n">x</span>
      <span class="k">with</span> <span class="n">_</span> <span class="o">-&gt;</span> <span class="n">x</span>
</code></pre></div></div>

<p>The <code class="language-plaintext highlighter-rouge">Sys.readdir</code> version nicely gives us an array so we can idiomatically use <code class="language-plaintext highlighter-rouge">Array.fold_left</code>.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">traverse_directory_sys</span> <span class="n">source</span> <span class="o">=</span>
  <span class="k">let</span> <span class="k">rec</span> <span class="n">process_directory</span> <span class="n">s</span> <span class="n">current_source</span> <span class="o">=</span>
    <span class="k">let</span> <span class="n">entries</span> <span class="o">=</span> <span class="nn">Sys</span><span class="p">.</span><span class="n">readdir</span> <span class="n">current_source</span> <span class="k">in</span>
    <span class="nn">Array</span><span class="p">.</span><span class="n">fold_left</span>
      <span class="p">(</span><span class="k">fun</span> <span class="n">acc</span> <span class="n">entry</span> <span class="o">-&gt;</span>
        <span class="k">let</span> <span class="n">source</span> <span class="o">=</span> <span class="nn">Filename</span><span class="p">.</span><span class="n">concat</span> <span class="n">current_source</span> <span class="n">entry</span> <span class="k">in</span>
        <span class="k">try</span>
          <span class="k">let</span> <span class="n">stat</span> <span class="o">=</span> <span class="nn">Unix</span><span class="p">.</span><span class="n">lstat</span> <span class="n">source</span> <span class="k">in</span>
          <span class="k">match</span> <span class="n">stat</span><span class="o">.</span><span class="n">st_kind</span> <span class="k">with</span>
          <span class="o">|</span> <span class="nn">Unix</span><span class="p">.</span><span class="nc">S_REG</span> <span class="o">-&gt;</span> <span class="n">acc</span> <span class="o">+</span> <span class="mi">1</span>
          <span class="o">|</span> <span class="nn">Unix</span><span class="p">.</span><span class="nc">S_DIR</span> <span class="o">-&gt;</span> <span class="n">process_directory</span> <span class="n">acc</span> <span class="n">source</span>
          <span class="o">|</span> <span class="nc">S_LNK</span> <span class="o">|</span> <span class="nc">S_CHR</span> <span class="o">|</span> <span class="nc">S_BLK</span> <span class="o">|</span> <span class="nc">S_FIFO</span> <span class="o">|</span> <span class="nc">S_SOCK</span> <span class="o">-&gt;</span> <span class="n">acc</span>
        <span class="k">with</span> <span class="nn">Unix</span><span class="p">.</span><span class="nc">Unix_error</span> <span class="n">_</span> <span class="o">-&gt;</span> <span class="n">acc</span><span class="p">)</span>
      <span class="n">s</span> <span class="n">entries</span>
  <span class="k">in</span>
  <span class="n">process_directory</span> <span class="mi">0</span> <span class="n">source</span>
</code></pre></div></div>

<p>The file system may have a big impact, so I tested NTFS, ReFS, and ext4, running each a couple of times to ensure the cache was primed.</p>

<p><code class="language-plaintext highlighter-rouge">Sys.readdir</code> was quicker in my test cases up to 500,000 files. Reaching 750,000 files, <code class="language-plaintext highlighter-rouge">Unix.readdir</code> edged ahead. I was surprised by the outcome and wondered whether it was my code rather than the module I used.</p>

<p>Pushing for the result I expected/wanted, I rewrote the function so it more closely mirrors the <code class="language-plaintext highlighter-rouge">Sys.readdir</code> version.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">traverse_directory_unix_2</span> <span class="n">path</span> <span class="o">=</span>
  <span class="k">let</span> <span class="k">rec</span> <span class="n">process_directory</span> <span class="n">s</span> <span class="n">path</span> <span class="o">=</span>
    <span class="k">try</span>
      <span class="k">let</span> <span class="n">dir_handle</span> <span class="o">=</span> <span class="nn">Unix</span><span class="p">.</span><span class="n">opendir</span> <span class="n">path</span> <span class="k">in</span>
      <span class="k">let</span> <span class="k">rec</span> <span class="n">read_entries</span> <span class="n">acc</span> <span class="o">=</span>
        <span class="k">try</span>
          <span class="k">let</span> <span class="n">entry</span> <span class="o">=</span> <span class="nn">Unix</span><span class="p">.</span><span class="n">readdir</span> <span class="n">dir_handle</span> <span class="k">in</span>
          <span class="k">match</span> <span class="n">entry</span> <span class="k">with</span>
          <span class="o">|</span> <span class="s2">"."</span> <span class="o">|</span> <span class="s2">".."</span> <span class="o">-&gt;</span> <span class="n">read_entries</span> <span class="n">acc</span>
          <span class="o">|</span> <span class="n">entry</span> <span class="o">-&gt;</span>
              <span class="k">let</span> <span class="n">full_path</span> <span class="o">=</span> <span class="nn">Filename</span><span class="p">.</span><span class="n">concat</span> <span class="n">path</span> <span class="n">entry</span> <span class="k">in</span>
              <span class="k">let</span> <span class="n">stats</span> <span class="o">=</span> <span class="nn">Unix</span><span class="p">.</span><span class="n">lstat</span> <span class="n">full_path</span> <span class="k">in</span>
              <span class="k">match</span> <span class="n">stats</span><span class="o">.</span><span class="n">st_kind</span> <span class="k">with</span>
              <span class="o">|</span> <span class="nn">Unix</span><span class="p">.</span><span class="nc">S_REG</span> <span class="o">-&gt;</span> <span class="n">read_entries</span> <span class="p">(</span><span class="n">acc</span> <span class="o">+</span> <span class="mi">1</span><span class="p">)</span>
              <span class="o">|</span> <span class="nc">S_LNK</span> <span class="o">|</span> <span class="nc">S_CHR</span> <span class="o">|</span> <span class="nc">S_BLK</span> <span class="o">|</span> <span class="nc">S_FIFO</span> <span class="o">|</span> <span class="nc">S_SOCK</span> <span class="o">-&gt;</span> <span class="n">read_entries</span> <span class="n">acc</span>
              <span class="o">|</span> <span class="nc">S_DIR</span> <span class="o">-&gt;</span> <span class="n">read_entries</span> <span class="p">(</span><span class="n">process_directory</span> <span class="n">acc</span> <span class="n">full_path</span><span class="p">)</span>
        <span class="k">with</span> <span class="nc">End_of_file</span> <span class="o">-&gt;</span>
          <span class="nn">Unix</span><span class="p">.</span><span class="n">closedir</span> <span class="n">dir_handle</span><span class="p">;</span>
          <span class="n">acc</span>
      <span class="k">in</span>
      <span class="n">read_entries</span> <span class="n">s</span>
    <span class="k">with</span> <span class="n">_</span> <span class="o">-&gt;</span> <span class="n">s</span>
  <span class="k">in</span>
  <span class="n">process_directory</span> <span class="mi">0</span> <span class="n">path</span>
</code></pre></div></div>

<p>This version is indeed faster than <code class="language-plaintext highlighter-rouge">Sys.readdir</code> in all cases. However, at 750,000 files the speed up was &lt; 0.5%.</p>
