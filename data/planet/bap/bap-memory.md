---
title: BAP Memory
description: The Binary Analysis Platform Blog
url: http://binaryanalysisplatform.github.io/memory
date: 2016-01-18T00:00:00-00:00
preview_image:
featured:
authors:
- bap
---

<p>This post explores a portion of the BAP API that may be useful when interacting
with binary images and their contents. The intention is to guide users with
initial steps for interacting with this interface; users may then explore
further features of the API depending on their needs. Thus, we elide some
details of the full API and data structures.</p>

<p>In this post, we use an ELF binary corresponding to <code class="language-plaintext highlighter-rouge">example.c</code> from the
<a href="http://binaryanalysisplatform.github.io/graphlib/">previous post</a>.</p>

<h4>Image contents</h4>

<blockquote>
  <p>How do I print out all of the memory chunks (with labels) in an ELF binary?</p>
</blockquote>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="nn">Project</span><span class="p">.</span><span class="n">memory</span> <span class="n">project</span>
<span class="o">|&gt;</span> <span class="nn">Memmap</span><span class="p">.</span><span class="n">to_sequence</span>
<span class="o">|&gt;</span> <span class="nn">Seq</span><span class="p">.</span><span class="n">iter</span> <span class="o">~</span><span class="n">f</span><span class="o">:</span><span class="p">(</span><span class="k">fun</span> <span class="p">(</span><span class="n">mem</span><span class="o">,</span><span class="n">v</span><span class="p">)</span> <span class="o">-&gt;</span>
     <span class="nn">Format</span><span class="p">.</span><span class="n">printf</span> <span class="s2">&quot;%s(%a)@.%a@.&quot;</span> <span class="p">(</span><span class="nn">Value</span><span class="p">.</span><span class="n">tagname</span> <span class="n">v</span><span class="p">)</span> <span class="nn">Value</span><span class="p">.</span><span class="n">pp</span> <span class="n">v</span> <span class="nn">Memory</span><span class="p">.</span><span class="n">pp</span> <span class="n">mem</span><span class="p">);</span>
</code></pre></div></div>

<p>Output:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>segment(02)
00400000  7F 45 4C 46 02 01 01 00 00 00 00 00 00 00 00 00 |.ELF............|
00400010  02 00 3E 00 01 00 00 00 40 04 40 00 00 00 00 00 |..&gt;.....@.@.....|
00400020  40 00 00 00 00 00 00 00 B0 14 00 00 00 00 00 00 |@...............|
00400030  00 00 00 00 40 00 38 00 09 00 40 00 23 00 20 00 |....@.8...@.#. .|

...

symbol(h)
0040052D  55 48 89 E5 48 83 EC 10 89 7D FC 83 45 FC 01 8B |UH..H....}..E...|
0040053D  45 FC 89 C7 E8 02 00 00 00 C9 C3                |E..........     |

symbol(g)
00400548  55 48 89 E5 48 83 EC 10 89 7D FC 83 7D FC 0A 7E |UH..H....}..}..~|
00400558  05 8B 45 FC EB 0E 83 45 FC 01 8B 45 FC 89 C7 E8 |..E....E...E....|
00400568  C1 FF FF FF C9 C3                               |......          |

...

section(.rodata)
0000000000400640: 01 00 02 00 52 65 73 3a 20 25 64 0a 00
section(.eh_frame_hdr)
00400650  01 1B 03 3B 4C 00 00 00 08 00 00 00 B0 FD FF FF |...;L...........|
00400660  98 00 00 00 F0 FD FF FF 68 00 00 00 DD FE FF FF |........h.......|
00400670  C0 00 00 00 F8 FE FF FF E0 00 00 00 1E FF FF FF |................|

...
</code></pre></div></div>

<ul>
  <li>
    <p>The binary image contents can be accessed with <code class="language-plaintext highlighter-rouge">Project.memory</code>. This returns a
<a href="https://github.com/BinaryAnalysisPlatform/bap/blob/master/lib/bap/bap.mli#L5393">Memmap</a>
data structure which is a lookup data structure, mapping memory regions to
values.</p>
  </li>
  <li>
    <p>We iterate over the Memmap, which gives us tuples <code class="language-plaintext highlighter-rouge">(mem,v)</code> corresponding to
(memory,value). For each of these values associated with memory, we can extract
a <a href="https://github.com/BinaryAnalysisPlatform/bap/blob/master/lib/bap/bap.mli#L3226">tagname</a>.</p>
  </li>
  <li>
    <p>Tag names correspond to the type (operating somewhat like a category) of the
chunks of memory. For instance, in the output we see <code class="language-plaintext highlighter-rouge">symbol</code>, <code class="language-plaintext highlighter-rouge">segment</code>, and
<code class="language-plaintext highlighter-rouge">section</code>.</p>
  </li>
  <li>
    <p><code class="language-plaintext highlighter-rouge">Value.pp</code> extracts the value of the relevant type, and prints it. For example,
a section and it&rsquo;s corresponding name (<code class="language-plaintext highlighter-rouge">.rodata</code>, <code class="language-plaintext highlighter-rouge">.got</code>, &hellip;).</p>
  </li>
  <li>
    <p>For the interested reader, see more on
<a href="https://github.com/BinaryAnalysisPlatform/bap/blob/master/lib/bap/bap.mli#L564">universal values</a>.</p>
  </li>
</ul>

<hr/>

<h4>Image Sections</h4>

<blockquote>
  <p>How do I print the memory contents of an ELF section, such as &lsquo;.rodata&rsquo;?</p>
</blockquote>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">find_section_by_name</span> <span class="n">name</span> <span class="o">=</span>
  <span class="k">let</span> <span class="k">open</span> <span class="nc">Format</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">memory</span> <span class="o">=</span> <span class="nn">Project</span><span class="p">.</span><span class="n">memory</span> <span class="n">project</span> <span class="k">in</span>
  <span class="nn">Memmap</span><span class="p">.</span><span class="n">to_sequence</span> <span class="n">memory</span> <span class="o">|&gt;</span> <span class="nn">Seq</span><span class="p">.</span><span class="n">find_map</span> <span class="o">~</span><span class="n">f</span><span class="o">:</span><span class="p">(</span><span class="k">fun</span> <span class="p">(</span><span class="n">m</span><span class="o">,</span><span class="n">v</span><span class="p">)</span> <span class="o">-&gt;</span>
      <span class="nn">Option</span><span class="p">.(</span><span class="nn">Value</span><span class="p">.</span><span class="n">get</span> <span class="nn">Image</span><span class="p">.</span><span class="n">section</span> <span class="n">v</span> <span class="o">&gt;&gt;=</span> <span class="k">fun</span> <span class="n">n</span> <span class="o">-&gt;</span>
              <span class="nn">Option</span><span class="p">.</span><span class="n">some_if</span> <span class="p">(</span><span class="n">n</span> <span class="o">=</span> <span class="n">name</span><span class="p">)</span> <span class="n">m</span><span class="p">))</span> <span class="k">in</span>
<span class="p">(</span><span class="k">match</span> <span class="n">find_section_by_name</span> <span class="s2">&quot;.rodata&quot;</span> <span class="k">with</span>
 <span class="o">|</span> <span class="nc">Some</span> <span class="n">mem</span> <span class="o">-&gt;</span> <span class="n">printf</span> <span class="s2">&quot;%a&quot;</span> <span class="nn">Memory</span><span class="p">.</span><span class="n">pp</span> <span class="n">mem</span>
 <span class="o">|</span> <span class="nc">None</span> <span class="o">-&gt;</span> <span class="n">printf</span> <span class="s2">&quot;No memory for this section</span><span class="se">\n</span><span class="s2">&quot;</span><span class="p">);</span>
</code></pre></div></div>

<p>Output:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>0000000000400640: 01 00 02 00 52 65 73 3a 20 25 64 0a 00
</code></pre></div></div>

<p>Notes:</p>

<ul>
  <li>
    <p>This time, we use <code class="language-plaintext highlighter-rouge">Value.get</code> on a special
<a href="https://github.com/BinaryAnalysisPlatform/bap/blob/master/lib/bap/bap.mli#L5353">section tag</a>
defined for <code class="language-plaintext highlighter-rouge">Image</code> to extract the section name.</p>
  </li>
  <li>
    <p>Where the value corresponds to a section name we are looking for, we return
the memory <code class="language-plaintext highlighter-rouge">m</code>.</p>
  </li>
</ul>

<hr/>

<h4>Reading memory</h4>

<blockquote>
  <p>How can I print out strings in the .rodata section?</p>
</blockquote>

<p>In the output of the previous example, we can recognize the hex encoding of a
string starting at <code class="language-plaintext highlighter-rouge">0x400644</code>. We define a number of helper functions to
extract and print it:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="c">(** Provide a view of the memory area, starting at [addr] *)</span>
<span class="k">let</span> <span class="n">mem_from_addr</span> <span class="n">addr</span> <span class="n">mem</span> <span class="o">=</span>
  <span class="k">match</span> <span class="nn">Memory</span><span class="p">.</span><span class="n">view</span> <span class="o">~</span><span class="n">word_size</span><span class="o">:</span><span class="nt">`r8</span> <span class="o">~</span><span class="n">from</span><span class="o">:</span><span class="n">addr</span> <span class="n">mem</span> <span class="k">with</span>
  <span class="o">|</span> <span class="nc">Ok</span> <span class="n">r</span> <span class="o">-&gt;</span> <span class="n">r</span>
  <span class="o">|</span> <span class="nc">Error</span> <span class="n">e</span> <span class="o">-&gt;</span> <span class="n">failwith</span> <span class="o">@@</span> <span class="n">sprintf</span> <span class="s2">&quot;Failure: %s</span><span class="se">\n</span><span class="s2">&quot;</span> <span class="o">@@</span> <span class="nn">Error</span><span class="p">.</span><span class="n">to_string_hum</span> <span class="n">e</span> <span class="k">in</span>
</code></pre></div></div>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="c">(** Given a memory area, start at the beginning and collect characters in the
accumulator string until we reach a until byte. Return the string *)</span>
<span class="k">let</span> <span class="n">read_string</span> <span class="n">mem</span> <span class="o">=</span>
  <span class="k">let</span> <span class="p">(</span><span class="o">!</span><span class="p">)</span> <span class="o">=</span> <span class="nn">Char</span><span class="p">.</span><span class="n">to_string</span> <span class="k">in</span>
  <span class="nn">Memory</span><span class="p">.</span><span class="n">foldi</span> <span class="o">~</span><span class="n">word_size</span><span class="o">:</span><span class="nt">`r8</span> <span class="n">mem</span> <span class="o">~</span><span class="n">init</span><span class="o">:</span><span class="p">(</span><span class="bp">false</span><span class="o">,</span><span class="s2">&quot;&quot;</span><span class="p">)</span>
    <span class="o">~</span><span class="n">f</span><span class="o">:</span><span class="p">(</span><span class="k">fun</span> <span class="n">addr</span> <span class="n">word</span> <span class="p">(</span><span class="n">set</span><span class="o">,</span><span class="n">acc</span><span class="p">)</span> <span class="o">-&gt;</span>
        <span class="k">let</span> <span class="kt">char</span> <span class="o">=</span> <span class="nn">Word</span><span class="p">.</span><span class="n">to_chars</span> <span class="n">word</span> <span class="nc">LittleEndian</span> <span class="o">|&gt;</span> <span class="nn">Seq</span><span class="p">.</span><span class="n">hd_exn</span> <span class="k">in</span>
        <span class="k">match</span> <span class="n">set</span><span class="o">,</span><span class="kt">char</span> <span class="k">with</span>
        <span class="o">|</span> <span class="p">(</span><span class="bp">false</span><span class="o">,</span><span class="sc">'\x00'</span><span class="p">)</span> <span class="o">-&gt;</span> <span class="p">(</span><span class="bp">true</span><span class="o">,</span><span class="n">acc</span><span class="p">)</span>
        <span class="o">|</span> <span class="p">(</span><span class="bp">false</span><span class="o">,</span><span class="n">c</span><span class="p">)</span> <span class="o">-&gt;</span> <span class="p">(</span><span class="bp">false</span><span class="o">,</span><span class="n">acc</span><span class="o">^</span><span class="p">(</span><span class="o">!</span><span class="n">c</span><span class="p">))</span>
        <span class="o">|</span> <span class="p">(</span><span class="bp">true</span><span class="o">,</span><span class="n">c</span><span class="p">)</span> <span class="o">-&gt;</span> <span class="p">(</span><span class="bp">true</span><span class="o">,</span><span class="n">acc</span><span class="p">))</span> <span class="o">|&gt;</span> <span class="n">snd</span> <span class="k">in</span>
</code></pre></div></div>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="c">(** Read from the address *)</span>
<span class="k">let</span> <span class="n">addr</span> <span class="o">=</span> <span class="nn">Addr</span><span class="p">.</span><span class="n">of_string</span> <span class="s2">&quot;0x400644:64&quot;</span> <span class="k">in</span>

<span class="c">(** Get and print the result *)</span>
<span class="k">let</span> <span class="n">result</span> <span class="o">=</span>
  <span class="k">let</span> <span class="k">open</span> <span class="nc">Option</span> <span class="k">in</span>
  <span class="n">find_section_by_name</span> <span class="s2">&quot;.rodata&quot;</span> <span class="o">&gt;&gt;=</span> <span class="k">fun</span> <span class="n">mem</span> <span class="o">-&gt;</span>
  <span class="nn">Option</span><span class="p">.</span><span class="n">some_if</span> <span class="p">(</span><span class="nn">Memory</span><span class="p">.</span><span class="n">contains</span> <span class="n">mem</span> <span class="n">addr</span><span class="p">)</span> <span class="p">(</span>
    <span class="k">let</span> <span class="n">mem'</span> <span class="o">=</span> <span class="n">mem_from_addr</span> <span class="n">addr</span> <span class="n">mem</span> <span class="k">in</span>
    <span class="n">read_string</span> <span class="n">mem'</span><span class="p">)</span> <span class="k">in</span>
<span class="p">(</span><span class="k">match</span> <span class="n">result</span> <span class="k">with</span>
 <span class="o">|</span> <span class="nc">Some</span> <span class="n">s</span> <span class="o">-&gt;</span> <span class="n">printf</span> <span class="s2">&quot;%s</span><span class="se">\n</span><span class="s2">%!&quot;</span> <span class="n">s</span>
 <span class="o">|</span> <span class="nc">None</span> <span class="o">-&gt;</span> <span class="n">failwith</span> <span class="s2">&quot;No string could be found&quot;</span><span class="p">);</span>
</code></pre></div></div>

<p>Output:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>Res: %d
</code></pre></div></div>

<p>Notes:</p>

<ul>
  <li>
    <p><code class="language-plaintext highlighter-rouge">Memory.view</code> gives us a way to create pieces of memory that we can use in
arbitrary ways.</p>
  </li>
  <li>
    <p><code class="language-plaintext highlighter-rouge">Memory.foldi</code> provides an interface for folding over the address range of a
memory structure.</p>
  </li>
  <li>
    <p>For the interested reader, refer to the
<a href="https://github.com/BinaryAnalysisPlatform/bap/blob/master/lib/bap/bap.mli#L4831">memory iterators</a>
and <a href="https://github.com/BinaryAnalysisPlatform/bap/blob/master/lib/bap/bap.mli#L4847">memory module</a>.</p>
  </li>
</ul>

