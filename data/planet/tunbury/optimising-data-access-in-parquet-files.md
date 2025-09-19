---
title: Optimising Data Access in Parquet Files
description: "Yesterday I wrote about the amazing performance of Apache Parquet files;
  today I reflect on how that translates into an actual application reading Parquet
  files using the OCaml wrapper of Apache\u2019s C++ library."
url: https://www.tunbury.org/2025/09/17/optimising-parquet-files/
date: 2025-09-17T21:00:00-00:00
preview_image: https://www.tunbury.org/images/apache-parquet-logo.png
authors:
- Mark Elvers
source:
ignore:
---

<p>Yesterday I wrote about the amazing performance of Apache Parquet files; today I reflect on how that translates into an actual application reading Parquet files using the OCaml wrapper of Apache’s C++ library.</p>

<p>I have a TUI application that displays build results for OCaml packages across multiple compiler versions. The application needs to provide two primary operations:</p>

<ol>
  <li>Table view: Display a matrix of build statuses (packages × compilers)</li>
  <li>Detail view: Show detailed build logs and dependency solutions for specific package-compiler combinations</li>
</ol>

<p>The dataset contained 48,895 records with the following schema:</p>

<ul>
  <li>name: Package name (~4,500 unique values)</li>
  <li>compiler: Compiler version (~11 unique versions)</li>
  <li>status: Build result (success/failure/etc.)</li>
  <li>log: Detailed build output (large text field)</li>
  <li>solution: Dependency resolution graph (large text field)</li>
</ul>

<h1>Initial Implementation and Performance Bottleneck</h1>

<p>The initial implementation used Apache Arrow’s OCaml bindings to load the complete Parquet file into memory:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>let analyze_data filename =
  let table = Arrow.Parquet_reader.table filename in
  let name_col = Arrow.Wrapper.Column.read_utf8 table ~column:(`Name "name") in
  let status_col = Arrow.Wrapper.Column.read_utf8_opt table ~column:(`Name "status") in
  let compiler_col = Arrow.Wrapper.Column.read_utf8 table ~column:(`Name "compiler") in
  let log_col = Arrow.Wrapper.Column.read_utf8_opt table ~column:(`Name "log") in
  let solution_col = Arrow.Wrapper.Column.read_utf8_opt table ~column:(`Name "solution") in
  (* Build hashtable for O(1) lookups *)
</code></pre></div></div>

<p>This approach exhibited 3-4 second loading times, creating an unacceptable user experience for interactive data exploration.</p>

<h1>Performance Analysis</h1>

<h2>Phase 1: Timing Instrumentation</h2>

<p>I implemented some basic timing instrumentation to identify bottlenecks by logging data to a file.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">append_to_file</span> <span class="n">filename</span> <span class="n">message</span> <span class="o">=</span>
  <span class="k">let</span> <span class="n">oc</span> <span class="o">=</span> <span class="n">open_out_gen</span> <span class="p">[</span><span class="nc">Open_creat</span><span class="p">;</span> <span class="nc">Open_text</span><span class="p">;</span> <span class="nc">Open_append</span><span class="p">]</span> <span class="mo">0o644</span> <span class="n">filename</span> <span class="k">in</span>
  <span class="nn">Printf</span><span class="p">.</span><span class="n">fprintf</span> <span class="n">oc</span> <span class="s2">"%s: %s</span><span class="se">\n</span><span class="s2">"</span> <span class="p">(</span><span class="nn">Sys</span><span class="p">.</span><span class="n">time</span> <span class="bp">()</span> <span class="o">|&gt;</span> <span class="nn">Printf</span><span class="p">.</span><span class="n">sprintf</span> <span class="s2">"%.3f"</span><span class="p">)</span> <span class="n">message</span><span class="p">;</span>
  <span class="n">close_out</span> <span class="n">oc</span>
</code></pre></div></div>

<p>The timings revealed that <code class="language-plaintext highlighter-rouge">Arrow.Parquet_reader.table</code> consumed ~3.6 seconds (80%) of the total loading time, with individual column extractions adding minimal overhead.</p>

<h2>Phase 2: Deep API Analysis</h2>

<p>Reviewing the Arrow C++ implementation to understand the performance characteristics:</p>

<div class="language-c highlighter-rouge"><div class="highlight"><pre class="highlight"><code>  <span class="c1">// From arrow_c_api.cc - the core bottleneck</span>
  <span class="n">TablePtr</span> <span class="o">*</span><span class="nf">parquet_read_table</span><span class="p">(</span><span class="kt">char</span> <span class="o">*</span><span class="n">filename</span><span class="p">,</span> <span class="kt">int</span> <span class="o">*</span><span class="n">col_idxs</span><span class="p">,</span> <span class="kt">int</span> <span class="n">ncols</span><span class="p">,</span>
                                <span class="kt">int</span> <span class="n">use_threads</span><span class="p">,</span> <span class="kt">int64_t</span> <span class="n">only_first</span><span class="p">)</span> <span class="p">{</span>
    <span class="c1">// ...</span>
    <span class="k">if</span> <span class="p">(</span><span class="n">only_first</span> <span class="o">&lt;</span> <span class="mi">0</span><span class="p">)</span> <span class="p">{</span>
      <span class="n">st</span> <span class="o">=</span> <span class="n">reader</span><span class="o">-&gt;</span><span class="n">ReadTable</span><span class="p">(</span><span class="o">&amp;</span><span class="n">table</span><span class="p">);</span>  <span class="c1">// Loads entire table!</span>
    <span class="p">}</span>
    <span class="c1">// ...</span>
  <span class="p">}</span>
</code></pre></div></div>

<p>This shows that the <code class="language-plaintext highlighter-rouge">ReadTable()</code> operation materialises the complete dataset in memory, regardless of actual usage patterns.</p>

<h1>Optimisation Strategy: Column Selection</h1>

<p>Could the large text fields (log and solution columns) be responsible for the performance bottleneck?</p>

<p>I modified the table loading to exclude large columns during initial load:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">table</span> <span class="o">=</span> <span class="nn">Arrow</span><span class="p">.</span><span class="nn">Parquet_reader</span><span class="p">.</span><span class="n">table</span> <span class="o">~</span><span class="n">column_idxs</span><span class="o">:</span><span class="p">[</span><span class="mi">0</span><span class="p">;</span> <span class="mi">1</span><span class="p">;</span> <span class="mi">6</span><span class="p">;</span> <span class="mi">7</span><span class="p">]</span> <span class="n">filename</span> <span class="k">in</span>
  <span class="c">(* Only load: name, status, os, compiler *)</span>
</code></pre></div></div>

<p>This dramatically reduced the loading time from 3.6 seconds to 0.021 seconds.</p>

<p>This optimisation validated the hypothesis that the large text columns were the primary bottleneck. However, it created a new challenge of accessing the detailed log/solution data for individual records.</p>

<p>There is a function <code class="language-plaintext highlighter-rouge">Arrow.Parquet_reader.fold_batches</code> which could be used for on-demand detail loading:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">find_package_detail</span> <span class="n">filename</span> <span class="n">target_package</span> <span class="n">target_compiler</span> <span class="o">=</span>
  <span class="nn">Arrow</span><span class="p">.</span><span class="nn">Parquet_reader</span><span class="p">.</span><span class="n">fold_batches</span> <span class="n">filename</span>
    <span class="o">~</span><span class="n">column_idxs</span><span class="o">:</span><span class="p">[</span><span class="mi">0</span><span class="p">;</span> <span class="mi">4</span><span class="p">;</span> <span class="mi">5</span><span class="p">;</span> <span class="mi">7</span><span class="p">]</span>  <span class="c">(* name, log, solution, compiler *)</span>
    <span class="o">~</span><span class="n">batch_size</span><span class="o">:</span><span class="mi">100</span>
    <span class="o">~</span><span class="n">f</span><span class="o">:</span><span class="p">(</span><span class="k">fun</span> <span class="bp">()</span> <span class="n">batch</span> <span class="o">-&gt;</span>
      <span class="c">(* Search batch for target, stop when found *)</span>
    <span class="p">)</span>
</code></pre></div></div>

<p>However, the performance analysis showed that it was equivalent to loading the whole table. If the log and solution columns were omitted, then the performance was fast!</p>

<ul>
  <li>With large columns: 2.981 seconds</li>
  <li>Without large columns: 0.033 seconds (33ms)</li>
</ul>

<h1>Comparative Analysis: ClickHouse vs Arrow</h1>

<p>To establish performance baselines, I compared Arrow’s performance with <code class="language-plaintext highlighter-rouge">clickhouse local</code>:</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="c"># ClickHouse aggregation query (equivalent to table view)</span>
<span class="nb">time </span>clickhouse <span class="nb">local</span> <span class="nt">--query</span> <span class="s2">"
  SELECT name, anyIf(status, compiler = 'ocaml.5.3.0') as col1, ...
  FROM file('data.parquet', 'Parquet') GROUP BY name ORDER BY name"</span>
<span class="c"># Result: 0.2 seconds</span>

<span class="c"># ClickHouse individual lookup</span>
<span class="nb">time </span>clickhouse <span class="nb">local</span> <span class="nt">--query</span> <span class="s2">"
  SELECT log, solution FROM file('data.parquet', 'Parquet') WHERE name = '0install.2.18' AND compiler = 'ocaml.5.3.0'"</span>
<span class="c"># Result: 1.716 seconds</span>

<span class="c"># ClickHouse lookup without large columns</span>
<span class="nb">time </span>clickhouse <span class="nb">local</span> <span class="nt">--query</span> <span class="s2">"
  SELECT COUNT() FROM file('data.parquet', 'Parquet') WHERE name = '0install.2.18' AND compiler = 'ocaml.5.3.0'"</span>
<span class="c"># Result: 0.190 seconds</span>
</code></pre></div></div>

<p>The 1.5-second difference (1.716s - 0.190s) represented the fundamental cost of decompressing and decoding large text fields and this is present both in OCaml and when using ClickHouse.</p>

<h1>Data Structure Redesign: The Wide Table Approach</h1>

<p>Instead of searching through 48,895 rows to find specific package-compiler combinations, I restructured the data into a wide table format:</p>

<div class="language-sql highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">SELECT</span>
    <span class="n">name</span><span class="p">,</span>
    <span class="n">anyIf</span><span class="p">(</span><span class="n">status</span><span class="p">,</span> <span class="n">compiler</span> <span class="o">=</span> <span class="s1">'ocaml.5.3.0'</span><span class="p">)</span> <span class="k">as</span> <span class="n">status_5_3_0</span><span class="p">,</span>
    <span class="n">anyIf</span><span class="p">(</span><span class="n">log</span><span class="p">,</span> <span class="n">compiler</span> <span class="o">=</span> <span class="s1">'ocaml.5.3.0'</span><span class="p">)</span> <span class="k">as</span> <span class="n">log_5_3_0</span><span class="p">,</span>
    <span class="n">anyIf</span><span class="p">(</span><span class="n">solution</span><span class="p">,</span> <span class="n">compiler</span> <span class="o">=</span> <span class="s1">'ocaml.5.3.0'</span><span class="p">)</span> <span class="k">as</span> <span class="n">solution_5_3_0</span><span class="p">,</span>
    <span class="c1">-- ... repeat for all compilers</span>
<span class="k">FROM</span> <span class="n">file</span><span class="p">(</span><span class="s1">'original.parquet'</span><span class="p">,</span> <span class="s1">'Parquet'</span><span class="p">)</span>
<span class="k">GROUP</span> <span class="k">BY</span> <span class="n">name</span>
<span class="k">ORDER</span> <span class="k">BY</span> <span class="n">name</span>
</code></pre></div></div>

<p>This transformation:</p>
<ul>
  <li>Reduced row count from ~48,895 to ~4,500 (one row per package)</li>
  <li>Eliminated search operations - direct column access by name</li>
  <li>Preserved all data while optimising access patterns</li>
</ul>

<p>The wide table restructure delivered the expected performance both in ClickHouse and OCaml.</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="nb">time </span>clickhouse <span class="nb">local</span> <span class="nt">--query</span> <span class="s2">"
  SELECT log_5_3_0, solution_5_3_0      FROM file('restructured.parquet', 'Parquet')      WHERE name = '0install.2.18'"</span>
<span class="c"># Result: 0.294 seconds</span>
</code></pre></div></div>

<h1>Conclusion</h1>

<p>There is no way to access a specific row within a column without loading (thus decompressing) the entire column. Given a column of ~50K rows, this takes a significant time. By splitting this table by compiler and by log, any given column which needs to be loaded is only ~4.5K rows make the application more responsive.</p>

<p>The wide table schema goes against my instincts for database table structure, and adds complexity when later using this dataset in other queries. This trade-off between performance and schema flexibility needs careful thought based on specific application requirements.</p>
