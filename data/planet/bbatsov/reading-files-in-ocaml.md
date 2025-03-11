---
title: Reading Files in OCaml
description: "One thing I\u2019ve noticed on my journey to learn OCaml was that reading
  (text) files wasn\u2019t as straightforward as with many other programming languages.
  To give you some point of reference - here\u2019s how easy it is to do this in Ruby:"
url: https://batsov.com/articles/2022/11/27/reading-files-in-ocaml/
date: 2022-11-27T07:52:00-00:00
preview_image: https://batsov.com/assets/images/bozhidar_avatar.jpg
authors:
- Bozhidar Batsov
source:
---

<p>One thing I’ve noticed on my <a href="https://batsov.com/articles/2022/08/19/learning-ocaml/">journey to learn OCaml</a> was that reading (text) files wasn’t as
straightforward as with many other programming languages. To give you some point
of reference - here’s how easy it is to do this in Ruby:</p>

<div class="language-ruby highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="c1"># read entire file to string</span>
<span class="n">content</span> <span class="o">=</span> <span class="no">File</span><span class="p">.</span><span class="nf">read</span><span class="p">(</span><span class="n">filename</span><span class="p">)</span>

<span class="c1"># read lines into an array of lines</span>
<span class="n">lines</span> <span class="o">=</span> <span class="no">File</span><span class="p">.</span><span class="nf">readlines</span><span class="p">(</span><span class="n">filename</span><span class="p">)</span>

<span class="c1"># process lines one at a time (memory efficient when dealing with large files)</span>
<span class="no">File</span><span class="p">.</span><span class="nf">foreach</span><span class="p">(</span><span class="n">filename</span><span class="p">)</span> <span class="p">{</span> <span class="o">|</span><span class="n">line</span><span class="o">|</span> <span class="nb">puts</span> <span class="n">line</span> <span class="p">}</span>
</code></pre></div></div>

<p>In my beloved Clojure the situation is similar:</p>

<div class="language-clojure highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="c1">;; read entire file into string</span><span class="w">
</span><span class="p">(</span><span class="nb">slurp</span><span class="w"> </span><span class="n">filename</span><span class="p">)</span><span class="w">

</span><span class="c1">;; process lines one at a time</span><span class="w">
</span><span class="p">(</span><span class="nf">use</span><span class="w"> </span><span class="ss">'clojure.java.io</span><span class="p">)</span><span class="w">

</span><span class="p">(</span><span class="nb">with-open</span><span class="w"> </span><span class="p">[</span><span class="n">rdr</span><span class="w"> </span><span class="p">(</span><span class="nf">reader</span><span class="w"> </span><span class="n">filename</span><span class="p">)]</span><span class="w">
  </span><span class="p">(</span><span class="nb">doseq</span><span class="w"> </span><span class="p">[</span><span class="n">line</span><span class="w"> </span><span class="p">(</span><span class="nb">line-seq</span><span class="w"> </span><span class="n">rdr</span><span class="p">)]</span><span class="w">
    </span><span class="p">(</span><span class="nb">println</span><span class="w"> </span><span class="n">line</span><span class="p">)))</span><span class="w">
</span></code></pre></div></div>

<p>Basically there are three common operations when
dealing with text files:</p>

<ul>
  <li>reading the whole contents as a single string</li>
  <li>reading the whole contents of a collection of lines (often that’s just a slight variation of the previous operation)</li>
  <li>reading and processing lines one by one (useful when dealing with large files)</li>
</ul>

<p>When I had to play with files in OCaml for the first time I did some digging
around and I noticed that many people were either rolling out their own
<code class="language-plaintext highlighter-rouge">read_lines</code> function based on the built-in <code class="language-plaintext highlighter-rouge">input_line</code> function or using Jane
Street’s <code class="language-plaintext highlighter-rouge">Base</code> library.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="c">(* Using Base *)</span>
<span class="k">open</span> <span class="nn">Core</span><span class="p">.</span><span class="nc">Std</span>
<span class="k">let</span> <span class="n">contents</span> <span class="o">=</span> <span class="nn">In_channel</span><span class="p">.</span><span class="n">read_all</span> <span class="n">file</span>
<span class="k">let</span> <span class="n">lines</span> <span class="o">=</span> <span class="nn">In_channel</span><span class="p">.</span><span class="n">read_lines</span> <span class="n">file</span>

<span class="c">(* homemade read_lines that gathers all lines in a list *)</span>
<span class="k">let</span> <span class="n">read_lines</span> <span class="n">name</span> <span class="o">:</span> <span class="kt">string</span> <span class="kt">list</span> <span class="o">=</span>
  <span class="k">let</span> <span class="n">ic</span> <span class="o">=</span> <span class="n">open_in</span> <span class="n">name</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">try_read</span> <span class="bp">()</span> <span class="o">=</span>
    <span class="k">try</span> <span class="nc">Some</span> <span class="p">(</span><span class="n">input_line</span> <span class="n">ic</span><span class="p">)</span> <span class="k">with</span> <span class="nc">End_of_file</span> <span class="o">-&gt;</span> <span class="nc">None</span> <span class="k">in</span>
  <span class="k">let</span> <span class="k">rec</span> <span class="n">loop</span> <span class="n">acc</span> <span class="o">=</span> <span class="k">match</span> <span class="n">try_read</span> <span class="bp">()</span> <span class="k">with</span>
    <span class="o">|</span> <span class="nc">Some</span> <span class="n">s</span> <span class="o">-&gt;</span> <span class="n">loop</span> <span class="p">(</span><span class="n">s</span> <span class="o">::</span> <span class="n">acc</span><span class="p">)</span>
    <span class="o">|</span> <span class="nc">None</span> <span class="o">-&gt;</span> <span class="n">close_in</span> <span class="n">ic</span><span class="p">;</span> <span class="nn">List</span><span class="p">.</span><span class="n">rev</span> <span class="n">acc</span> <span class="k">in</span>
  <span class="n">loop</span> <span class="bp">[]</span>

<span class="k">let</span> <span class="n">lines</span> <span class="o">=</span> <span class="n">read_lines</span> <span class="n">filename</span>

<span class="c">(* homemade read_lines that processes each line *)</span>
<span class="k">let</span> <span class="n">read_lines</span> <span class="n">file</span> <span class="n">process</span> <span class="o">=</span>
  <span class="k">let</span> <span class="n">in_ch</span> <span class="o">=</span> <span class="n">open_in</span> <span class="n">file</span> <span class="k">in</span>
  <span class="k">let</span> <span class="k">rec</span> <span class="n">read_line</span> <span class="bp">()</span> <span class="o">=</span>
    <span class="k">let</span> <span class="n">line</span> <span class="o">=</span> <span class="k">try</span> <span class="n">input_line</span> <span class="n">in_ch</span> <span class="k">with</span> <span class="nc">End_of_file</span> <span class="o">-&gt;</span> <span class="n">exit</span> <span class="mi">0</span>
    <span class="k">in</span> <span class="c">(* process line in this block, then read the next line *)</span>
       <span class="n">process</span> <span class="n">line</span><span class="p">;</span>
       <span class="n">read_line</span> <span class="bp">()</span><span class="p">;</span>
<span class="k">in</span> <span class="n">read_line</span> <span class="bp">()</span>

<span class="n">read_lines</span> <span class="n">filename</span> <span class="n">print_endline</span>
</code></pre></div></div>

<p>Obviously, this gets the job done, but I was quite surprised such basic
operations are not covered in the standard library. Turns out, however, that the
situation has changed recently with OCaml 4.14 with the introduction of the
module <code class="language-plaintext highlighter-rouge">In_channel</code>:<sup role="doc-noteref"><a href="https://batsov.com/feeds/OCaml.xml#fn:1" class="footnote" rel="footnote">1</a></sup></p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="c">(* read the entire file *)</span>
<span class="k">let</span> <span class="n">read_file</span> <span class="n">file</span> <span class="o">=</span>
  <span class="nn">In_channel</span><span class="p">.</span><span class="n">with_open_bin</span> <span class="n">file</span> <span class="nn">In_channel</span><span class="p">.</span><span class="n">input_all</span>

<span class="c">(* read lines *)</span>
<span class="k">let</span> <span class="n">read_lines</span> <span class="n">file</span> <span class="o">=</span>
  <span class="k">let</span> <span class="n">contents</span> <span class="o">=</span> <span class="nn">In_channel</span><span class="p">.</span><span class="n">with_open_bin</span> <span class="n">file</span> <span class="nn">In_channel</span><span class="p">.</span><span class="n">input_all</span> <span class="k">in</span>
  <span class="nn">String</span><span class="p">.</span><span class="n">split_on_char</span> <span class="sc">'\n'</span> <span class="n">contents</span>

<span class="nn">List</span><span class="p">.</span><span class="n">iter</span> <span class="n">print_endline</span> <span class="p">(</span><span class="n">read_lines</span> <span class="n">filename</span><span class="p">)</span>
</code></pre></div></div>

<p>While you still need to roll out your own <code class="language-plaintext highlighter-rouge">read_file</code> and <code class="language-plaintext highlighter-rouge">read_lines</code>
functions, the implementation is significantly simpler than before. Even more
importantly, the code is now more reliable as noted by Daniel Bünzli:<sup role="doc-noteref"><a href="https://batsov.com/feeds/OCaml.xml#fn:2" class="footnote" rel="footnote">2</a></sup></p>

<blockquote>
  <p>Be careful, <code class="language-plaintext highlighter-rouge">input_line</code> is a footgun and has led to more than one bug out there – along with <code class="language-plaintext highlighter-rouge">open_in</code> and <code class="language-plaintext highlighter-rouge">open_out</code> defaulting to text mode and thus lying by default about your data.</p>

  <p><code class="language-plaintext highlighter-rouge">input_line</code> will never report an empty final line and performs newline translations if your channel is in text mode. This means you can’t expect to recover the exact file contents you just read by doing <code class="language-plaintext highlighter-rouge">String.concat "\n"</code> on the lines you input with <code class="language-plaintext highlighter-rouge">input_line</code>.</p>

  <p>Also of course it doesn’t help with making sure you correctly close your channels and don’t leak them in case of exception. The new functions finally make that a no brainer.</p>
</blockquote>

<p><strong>Note:</strong> Daniel is referring to functions in <code class="language-plaintext highlighter-rouge">Stdlib</code>. They should not be confused with similarly named
functions in the new <code class="language-plaintext highlighter-rouge">In_channel</code> module.</p>

<p>You can also use <code class="language-plaintext highlighter-rouge">In_channel.input_line</code> to read file contents line by line and
avoid excessive memory allocation. I’m still missing something like Clojure’s
<code class="language-plaintext highlighter-rouge">line-seq</code> that create a lazy seq from which you can obtain the file lines, but
I guess this should be doable in OCaml one way or another.<sup role="doc-noteref"><a href="https://batsov.com/feeds/OCaml.xml#fn:3" class="footnote" rel="footnote">3</a></sup></p>

<p>One interesting library that I’ve discovered was <a href="https://github.com/c-cube/iter/">Iter</a> and it particular its module <a href="https://c-cube.github.io/iter/dev/iter/Iter/IO/index.html">Iter.IO</a>. It provides a basic interface to manipulate files as iterator of chunks/lines. The iterators take care of opening and closing files properly; every time one iterates over an iterator, the file is opened/closed again. Here’s are a few examples from the library’s documentation:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="c">(* Example: copy a file "a" into file "b", removing blank lines: *)</span>
<span class="nn">Iterator</span><span class="p">.(</span><span class="nn">IO</span><span class="p">.</span><span class="n">lines_of</span> <span class="s2">"a"</span> <span class="o">|&gt;</span> <span class="n">filter</span> <span class="p">(</span><span class="k">fun</span> <span class="n">l</span> <span class="o">-&gt;</span> <span class="n">l</span> <span class="o">&lt;&gt;</span> <span class="s2">""</span><span class="p">)</span> <span class="o">|&gt;</span> <span class="nn">IO</span><span class="p">.</span><span class="n">write_lines</span> <span class="s2">"b"</span><span class="p">)</span>

<span class="c">(* By chunks of 4096 bytes: *)</span>
<span class="nn">Iterator</span><span class="p">.</span><span class="nn">IO</span><span class="p">.(</span><span class="n">chunks_of</span> <span class="o">~</span><span class="n">size</span><span class="o">:</span><span class="mi">4096</span> <span class="s2">"a"</span> <span class="o">|&gt;</span> <span class="n">write_to</span> <span class="s2">"b"</span><span class="p">)</span>

<span class="c">(* Read the lines of a file into a list: *)</span>
<span class="nn">Iterator</span><span class="p">.</span><span class="nn">IO</span><span class="p">.</span><span class="n">lines</span> <span class="s2">"a"</span> <span class="o">|&gt;</span> <span class="nn">Iterator</span><span class="p">.</span><span class="n">to_list</span>
</code></pre></div></div>

<p>Cool stuff! I’ll make sure to explore further at some point.</p>

<p>Perhaps the takeaway for you today is to use libraries like <code class="language-plaintext highlighter-rouge">Base</code> and
<code class="language-plaintext highlighter-rouge">Containers</code> instead of relying solely on the standard library, perhaps it’s
not. I’ll leave that for you to decide. If you decide to stick with the standard
library - I encourage you to peruse the <a href="https://v2.ocaml.org/api/In_channel.html">documentation of
<code class="language-plaintext highlighter-rouge">In_channel</code></a> to learn more about the
functions it offers and the advantages of using it over the legacy <code class="language-plaintext highlighter-rouge">input_line</code>
function.</p>

<p>I really wish that someone would update <a href="https://ocaml.org/docs/file-manipulation">OCaml’s page on file
manipulation</a> to include coverage of
the OCaml 4.14 functionality (perhaps I’ll do this myself).  I’m guessing this
outdated page and other legacy docs are sending a lot of people in the wrong
direction, which was the main reason I’ve decided to write this article.</p>

<p>That’s all I have for you today. Keep hacking!</p>

<p><strong>Update:</strong> The article generated a nice <a href="https://www.reddit.com/r/ocaml/comments/z6ws71/reading_files_in_ocaml/">discussion on Reddit</a> that you may want to peruse.</p>
<div class="footnotes" role="doc-endnotes">
  <ol>
    <li role="doc-endnote">
      <p><a href="https://discuss.ocaml.org/t/ocaml-compiler-development-newsletter-issue-3-june-september-2021/8598#channels-in-the-standard-library-2">https://discuss.ocaml.org/t/ocaml-compiler-development-newsletter-issue-3-june-september-2021/8598#channels-in-the-standard-library-2</a>&nbsp;<a href="https://batsov.com/feeds/OCaml.xml#fnref:1" class="reversefootnote" role="doc-backlink">↩</a></p>
    </li>
    <li role="doc-endnote">
      <p><a href="https://discuss.ocaml.org/t/how-do-you-read-the-lines-of-a-text-file/8834/8">https://discuss.ocaml.org/t/how-do-you-read-the-lines-of-a-text-file/8834/8</a>&nbsp;<a href="https://batsov.com/feeds/OCaml.xml#fnref:2" class="reversefootnote" role="doc-backlink">↩</a></p>
    </li>
    <li role="doc-endnote">
      <p>After writing the article I’ve noticed that there’s a <code class="language-plaintext highlighter-rouge">read_lines_seq</code> function in the <a href="https://github.com/c-cube/ocaml-containers/blob/master/src/core/CCIO.mli">Containers</a> library.&nbsp;<a href="https://batsov.com/feeds/OCaml.xml#fnref:3" class="reversefootnote" role="doc-backlink">↩</a></p>
    </li>
  </ol>
</div>
