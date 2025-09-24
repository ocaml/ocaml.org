---
title: Apache Parquet Files
description: "If you haven\u2019t discovered the Apache Parquet file format, allow
  me to introduce it along with ClickHouse."
url: https://www.tunbury.org/2025/09/17/parquet-files/
date: 2025-09-17T21:00:00-00:00
preview_image: https://www.tunbury.org/images/apache-parquet-logo.png
authors:
- Mark Elvers
source:
ignore:
---

<p>If you haven’t discovered the <a href="https://parquet.apache.org">Apache Parquet</a> file format, allow me to introduce it along with <a href="https://clickhouse.com">ClickHouse</a>.</p>

<p>Parquet is a columnar storage file format designed for analytics and big data processing. Data is stored by column rather than by row, there is efficient compression, and the file contains the schema definition.</p>

<p>On Ubuntu, you first need to add the ClickHouse repository.</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>curl -fsSL 'https://packages.clickhouse.com/rpm/lts/repodata/repomd.xml.key' | sudo gpg --dearmor -o /usr/share/keyrings/clickhouse-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/clickhouse-keyring.gpg] https://packages.clickhouse.com/deb stable main" | sudo tee /etc/apt/sources.list.d/clickhouse.list
</code></pre></div></div>

<p>Update and install - I’m going to use <code class="language-plaintext highlighter-rouge">clickhouse local</code>, so I only need the client.</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>apt update
apt install -y clickhouse-client
</code></pre></div></div>

<p>Given the JSON file below, you can use ClickHouse to run SQL queries on it directly: <code class="language-plaintext highlighter-rouge">clickhouse local --query "SELECT * FROM file('x.json')"</code></p>

<div class="language-json highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="p">[</span><span class="w">
  </span><span class="p">{</span><span class="w">
    </span><span class="nl">"name"</span><span class="p">:</span><span class="w"> </span><span class="s2">"0install-gtk.2.18"</span><span class="p">,</span><span class="w">
    </span><span class="nl">"status"</span><span class="p">:</span><span class="w"> </span><span class="s2">"no_solution"</span><span class="p">,</span><span class="w">
    </span><span class="nl">"sha"</span><span class="p">:</span><span class="w"> </span><span class="s2">"d0b74334d458c26f4b769b9b5819f7af222b159c"</span><span class="p">,</span><span class="w">
    </span><span class="nl">"solution"</span><span class="p">:</span><span class="w"> </span><span class="s2">"Can't find all required versions."</span><span class="p">,</span><span class="w">
    </span><span class="nl">"os"</span><span class="p">:</span><span class="w"> </span><span class="s2">"debian-12"</span><span class="p">,</span><span class="w">
    </span><span class="nl">"compiler"</span><span class="p">:</span><span class="w"> </span><span class="s2">"ocaml-base-compiler.5.4.0~beta1"</span><span class="w">
  </span><span class="p">}</span><span class="w">
</span><span class="p">]</span><span class="w">
</span></code></pre></div></div>

<p>Powerfully, the <code class="language-plaintext highlighter-rouge">file</code> parameter can contain wildcards, such as<code class="language-plaintext highlighter-rouge">*.json</code>, in which case the <code class="language-plaintext highlighter-rouge">SELECT</code> is performed across all the files.</p>

<p>In my examples below, the JSON file is 573MB. Let’s try to find all the records where `status = “no_solution”.</p>

<p>We could use <code class="language-plaintext highlighter-rouge">jq</code> with a command like <code class="language-plaintext highlighter-rouge">jq 'map(select(.status == "no_solution")) | length' commit.json</code>. This takes over 2 seconds on my machine. Cheating and using <code class="language-plaintext highlighter-rouge">grep no_solution commit.json | wc -l</code> takes 0.2 seconds.</p>

<p>Using ClickHouse on the same datasource, <code class="language-plaintext highlighter-rouge">clickhouse local --query "SELECT COUNT() FROM file('commit.json') WHERE status = 'no_solution'"</code> matches the performance of <code class="language-plaintext highlighter-rouge">grep</code> returning the count in 0.2 seconds.</p>

<p>Converting the JSON into Parquet format is straightforward. The output file size is an amazing 24MB. Contrast that with <code class="language-plaintext highlighter-rouge">gzip -9 commit.json</code>, which creates a file of 33MB!</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>clickhouse local --query "SELECT * FROM file('commit.json', 'JSONEachRow') INTO OUTFILE 'commit.parquet' FORMAT Parquet"
</code></pre></div></div>

<p>Now running our query again: <code class="language-plaintext highlighter-rouge">clickhouse local --query "SELECT COUNT() FROM file('commit.parquet') WHERE status = 'no_solution'"</code>. Just over 0.1 seconds.</p>

<p>How can I use these in my OCaml project? <a href="https://github.com/LaurentMazare/ocaml-arrow">LaurentMazare/ocaml-arrow</a> has created extensive OCaml bindings for Apache Arrow using the C++ API. This supports versions 4 and 5, but the current implementation is version 21. I have an updated commit which works on version 21 and C++ 17. <a href="https://github.com/mtelvers/ocaml-arrow/tree/arrow-21-cpp17">mtelvers/ocaml-arrow/tree/arrow-21-cpp17</a></p>

<p>I have also reimplemented the bulk of the library using the OCaml Standard Library which is available in <a href="https://github.com/mtelvers/arrow">mtelvers/arrow</a></p>
