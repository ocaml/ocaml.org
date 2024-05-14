---
title: Announcing DBCaml, Silo, Serde Postgres and a new driver for postgres
description: Announcing DBCaml, Silo, Serde Postgres and a new driver for postgres
url: https://priver.dev/blog/dbcaml/dbcaml-project/
date: 2024-05-03T00:01:38-00:00
preview_image: https://priver.dev/images/ocaml/dbcaml.jpeg
featured:
authors:
- "Emil Priv\xE9r"
source:
---

<p>I&rsquo;ve spent the last four months working on DBCaml. Some of you may be familiar with this project, while others may not. When I started DBCaml, I had one primary goal: to build a toolkit for OCaml that handles pooling and mapping to types and more. This toolkit would also run on Riot, which is an actor-model multi-core scheduler for OCaml 5.</p>
<p>An issue I&rsquo;ve found in the OCaml space and databases is that most of the existing database libraries either don&rsquo;t support Postgres version 14 and higher, or they run on the PostgreSQL library, which is a C-binding library. The initial release of DBcaml also used the Postgresl library just to get something published. However, this wasn&rsquo;t something I wanted as I felt really limited in what I was able to do, and the C-bindings library would also limit the number of processes I could run with Riot, which is something I didn&rsquo;t want. So, I decided to work hard on the Postgres driver to write a native OCaml driver which uses Riot&rsquo;s socket connection for the database.</p>
<p>This post is to describe the new change by talking about each library. The GitHub repo for this project exists here: <a href="https://github.com/dbcaml/dbcaml">https://github.com/dbcaml/dbcaml</a></p>
<p>Before I continue, I want to say a big thank you to <a href="https://twitter.com/leostera">Leandro Ostera</a>, <a href="https://twitter.com/_anmonteiro">Antonio Monteiro</a> and many more in the OCaml community. When I&rsquo;ve been in need of help, you have provided me with information and code to fix the issues I encountered. Thank you tons! &lt;3</p>
<p>Now that DBCaml has expanded into multiple libraries, I will refer to these as &ldquo;The DBCaml project&rdquo;. I felt it was important to write about this project again because the direction has changed since v0.0.1.</p>
<h2>DBCaml</h2>
<p>DBCaml, the central library in this project, was initially designed to handle queries, type mapping, and pooling. As the project expanded, I decided to make DBCaml more developer-friendly. It now aids in pooling and sending queries to the database, returning raw bytes in response.</p>
<p>DBCaml&rsquo;s pool takes inspiration from Elixir&rsquo;s ecto.</p>
<p>Currently, I recommend developers use DBCaml for querying the database and receiving raw bytes, which they can then use to build any desired features.</p>
<p>However, my vision for DBCaml is not yet complete. I plan to extract the pooling function from DBCaml and create a separate pool manager, inspired by Elixir&rsquo;s ecto. This manager can be used by developers to construct features, such as a Redis pool.</p>
<p>If you&rsquo;re interested in learning more about how DBCaml works, I recommend reading these articles: <a href="https://priver.dev/blog/dbcaml/building-a-connnection-pool/">&rdquo;Building a Connnection Pool for DBCaml on top of riot</a>&rdquo; and <a href="https://priver.dev/blog/dbcaml/dbcaml/">&rdquo;Introducing DBCaml, Database toolkit for OCaml&rdquo;</a>.</p>
<h2>DBCaml Postgres Driver</h2>
<p>A driver essentially serves as the bridge between your code and the database. It&rsquo;s responsible for making queries to the database, setting up the connection, handling security, and managing TLS. In other words, it performs &ldquo;the real job.&rdquo;</p>
<p>The first version of the driver was built for Postgresql, using a C-binding library. However, I wasn&rsquo;t fond of this library because it didn&rsquo;t provide raw bytes, which are crucial when mapping data to types.</p>
<p>This library has since been rewritten into native OCaml code, using Riot&rsquo;s sockets to connect to the database.</p>
<h2>Serde Postgres</h2>
<p>The next library to discuss is Serde Postgres, a Postgres wire deserializer. The Postgres wire is a protocol used by Postgres to define the structure of bytes, enabling us to create clients for Postgres. You can read about the Postgres wire protocol at: <a href="https://www.postgresql.org/docs/current/protocol.html">https://www.postgresql.org/docs/current/protocol.html</a></p>
<p>With the introduction of Serde Postgres, it&rsquo;s now possible to deserialize Postgres wire and map the data to types. Here&rsquo;s an example:</p>
<div class="highlight"><div class="chroma">
<table class="lntable"><tr><td class="lntd">
<pre tabindex="0" class="chroma"><code><span class="lnt"> 1
</span><span class="lnt"> 2
</span><span class="lnt"> 3
</span><span class="lnt"> 4
</span><span class="lnt"> 5
</span><span class="lnt"> 6
</span><span class="lnt"> 7
</span><span class="lnt"> 8
</span><span class="lnt"> 9
</span><span class="lnt">10
</span><span class="lnt">11
</span><span class="lnt">12
</span><span class="lnt">13
</span><span class="lnt">14
</span><span class="lnt">15
</span><span class="lnt">16
</span><span class="lnt">17
</span><span class="lnt">18
</span><span class="lnt">19
</span><span class="lnt">20
</span></code></pre></td>
<td class="lntd">
<pre tabindex="0" class="chroma"><code class="language-ocaml" data-lang="ocaml"><span class="line"><span class="cl"><span class="k">type</span> <span class="n">user</span> <span class="o">=</span> <span class="o">{</span>
</span></span><span class="line"><span class="cl">  <span class="n">name</span><span class="o">:</span> <span class="kt">string</span><span class="o">;</span>
</span></span><span class="line"><span class="cl">  <span class="n">id</span><span class="o">:</span> <span class="kt">int</span><span class="o">;</span>
</span></span><span class="line"><span class="cl">  <span class="n">some_int64</span><span class="o">:</span> <span class="n">int64</span><span class="o">;</span>
</span></span><span class="line"><span class="cl">  <span class="n">some_int32</span><span class="o">:</span> <span class="n">int32</span><span class="o">;</span>
</span></span><span class="line"><span class="cl">  <span class="n">some_float</span><span class="o">:</span> <span class="kt">float</span><span class="o">;</span>
</span></span><span class="line"><span class="cl">  <span class="n">some_bool</span><span class="o">:</span> <span class="kt">bool</span><span class="o">;</span>
</span></span><span class="line"><span class="cl">  <span class="n">pet_name</span><span class="o">:</span> <span class="kt">string</span> <span class="n">option</span><span class="o">;</span>
</span></span><span class="line"><span class="cl">  <span class="n">pets</span><span class="o">:</span> <span class="kt">string</span> <span class="kt">list</span><span class="o">;</span>
</span></span><span class="line"><span class="cl">  <span class="n">pets_array</span><span class="o">:</span> <span class="kt">string</span> <span class="kt">array</span><span class="o">;</span>
</span></span><span class="line"><span class="cl"><span class="o">}</span>
</span></span><span class="line"><span class="cl"><span class="o">[@@</span><span class="n">deriving</span> <span class="n">deserialize</span><span class="o">]</span>
</span></span><span class="line"><span class="cl">
</span></span><span class="line"><span class="cl"><span class="k">let</span> <span class="n">u</span> <span class="o">=</span>
</span></span><span class="line"><span class="cl">    <span class="k">match</span> <span class="nn">Serde_postgres</span><span class="p">.</span><span class="n">of_bytes</span> <span class="n">deserialize_user</span> <span class="n">message</span> <span class="k">with</span>
</span></span><span class="line"><span class="cl">    <span class="o">|</span> <span class="nc">Ok</span> <span class="n">u</span> <span class="o">-&gt;</span> <span class="n">u</span>
</span></span><span class="line"><span class="cl">    <span class="o">|</span> <span class="nc">Error</span> <span class="n">e</span> <span class="o">-&gt;</span> <span class="n">fail</span> <span class="o">(</span><span class="nn">Format</span><span class="p">.</span><span class="n">asprintf</span> <span class="s2">&quot;Deserialize error: %a&quot;</span> <span class="nn">Serde</span><span class="p">.</span><span class="n">pp_err</span> <span class="n">e</span><span class="o">)</span>
</span></span><span class="line"><span class="cl">  <span class="k">in</span>
</span></span><span class="line"><span class="cl">
</span></span><span class="line"><span class="cl"><span class="n">print_string</span> <span class="n">u</span><span class="o">.</span><span class="n">name</span><span class="o">:</span>
</span></span></code></pre></td></tr></table>
</div>
</div><p>By creating a separate library, developers can use Serde, Postgres, and Dbcaml to make queries and later parse the data into types.</p>
<h2>Silo</h2>
<p>The final library to discuss is Silo. This is the high-level library I envisioned for DBcaml, one that handles everything for you and allows you to simply write your queries and work with the necessary types. Silo uses DBcaml to make raw queries to the database and then maps the bytes from Postgres to types using Serde Postgres.</p>
<p>Here&rsquo;s an example:</p>
<div class="highlight"><div class="chroma">
<table class="lntable"><tr><td class="lntd">
<pre tabindex="0" class="chroma"><code><span class="lnt"> 1
</span><span class="lnt"> 2
</span><span class="lnt"> 3
</span><span class="lnt"> 4
</span><span class="lnt"> 5
</span><span class="lnt"> 6
</span><span class="lnt"> 7
</span><span class="lnt"> 8
</span><span class="lnt"> 9
</span><span class="lnt">10
</span><span class="lnt">11
</span><span class="lnt">12
</span><span class="lnt">13
</span><span class="lnt">14
</span><span class="lnt">15
</span><span class="lnt">16
</span><span class="lnt">17
</span><span class="lnt">18
</span><span class="lnt">19
</span><span class="lnt">20
</span><span class="lnt">21
</span><span class="lnt">22
</span><span class="lnt">23
</span><span class="lnt">24
</span><span class="lnt">25
</span><span class="lnt">26
</span><span class="lnt">27
</span><span class="lnt">28
</span><span class="lnt">29
</span><span class="lnt">30
</span><span class="lnt">31
</span><span class="lnt">32
</span><span class="lnt">33
</span><span class="lnt">34
</span><span class="lnt">35
</span><span class="lnt">36
</span><span class="lnt">37
</span><span class="lnt">38
</span><span class="lnt">39
</span><span class="lnt">40
</span><span class="lnt">41
</span><span class="lnt">42
</span><span class="lnt">43
</span><span class="lnt">44
</span><span class="lnt">45
</span><span class="lnt">46
</span><span class="lnt">47
</span><span class="lnt">48
</span><span class="lnt">49
</span><span class="lnt">50
</span><span class="lnt">51
</span><span class="lnt">52
</span><span class="lnt">53
</span><span class="lnt">54
</span><span class="lnt">55
</span></code></pre></td>
<td class="lntd">
<pre tabindex="0" class="chroma"><code class="language-ocaml" data-lang="ocaml"><span class="line"><span class="cl"><span class="k">type</span> <span class="n">user</span> <span class="o">=</span> <span class="o">{</span>
</span></span><span class="line"><span class="cl">  <span class="n">name</span><span class="o">:</span> <span class="kt">string</span><span class="o">;</span>
</span></span><span class="line"><span class="cl">  <span class="n">id</span><span class="o">:</span> <span class="kt">int</span><span class="o">;</span>
</span></span><span class="line"><span class="cl">  <span class="n">some_int64</span><span class="o">:</span> <span class="n">int64</span><span class="o">;</span>
</span></span><span class="line"><span class="cl">  <span class="n">some_int32</span><span class="o">:</span> <span class="n">int32</span><span class="o">;</span>
</span></span><span class="line"><span class="cl">  <span class="n">some_float</span><span class="o">:</span> <span class="kt">float</span><span class="o">;</span>
</span></span><span class="line"><span class="cl">  <span class="n">some_bool</span><span class="o">:</span> <span class="kt">bool</span><span class="o">;</span>
</span></span><span class="line"><span class="cl">  <span class="n">pet_name</span><span class="o">:</span> <span class="kt">string</span> <span class="n">option</span><span class="o">;</span>
</span></span><span class="line"><span class="cl">  <span class="n">pets</span><span class="o">:</span> <span class="kt">string</span> <span class="kt">list</span><span class="o">;</span>
</span></span><span class="line"><span class="cl">  <span class="n">pets_array</span><span class="o">:</span> <span class="kt">string</span> <span class="kt">array</span><span class="o">;</span>
</span></span><span class="line"><span class="cl"><span class="o">}</span>
</span></span><span class="line"><span class="cl"><span class="o">[@@</span><span class="n">deriving</span> <span class="n">deserialize</span><span class="o">]</span>
</span></span><span class="line"><span class="cl">
</span></span><span class="line"><span class="cl"><span class="k">type</span> <span class="n">users</span> <span class="o">=</span> <span class="n">user</span> <span class="kt">list</span> <span class="o">[@@</span><span class="n">deriving</span> <span class="n">deserialize</span><span class="o">]</span>
</span></span><span class="line"><span class="cl">
</span></span><span class="line"><span class="cl"><span class="k">let</span> <span class="bp">()</span> <span class="o">=</span>
</span></span><span class="line"><span class="cl">  <span class="nn">Riot</span><span class="p">.</span><span class="n">run_with_status</span> <span class="o">~</span><span class="n">on_error</span><span class="o">:(</span><span class="k">fun</span> <span class="n">x</span> <span class="o">-&gt;</span> <span class="n">failwith</span> <span class="n">x</span><span class="o">)</span> <span class="o">@@</span> <span class="k">fun</span> <span class="bp">()</span> <span class="o">-&gt;</span>
</span></span><span class="line"><span class="cl">  <span class="c">(* Start the database connection pool *)</span>
</span></span><span class="line"><span class="cl">  <span class="k">let</span><span class="o">*</span> <span class="n">db</span> <span class="o">=</span>
</span></span><span class="line"><span class="cl">    <span class="k">let</span> <span class="n">config</span> <span class="o">=</span>
</span></span><span class="line"><span class="cl">      <span class="nn">Silo</span><span class="p">.</span><span class="n">config</span>
</span></span><span class="line"><span class="cl">        <span class="o">~</span><span class="n">connections</span><span class="o">:</span><span class="n">5</span>
</span></span><span class="line"><span class="cl">        <span class="o">~</span><span class="n">driver</span><span class="o">:(</span><span class="k">module</span> <span class="nc">Dbcaml_driver_postgres</span><span class="o">)</span>
</span></span><span class="line"><span class="cl">        <span class="o">~</span><span class="n">connection_string</span><span class="o">:</span>
</span></span><span class="line"><span class="cl">          <span class="s2">&quot;postgresql://postgres:postgres@localhost:6432/postgres?sslmode=disabled&quot;</span>
</span></span><span class="line"><span class="cl">    <span class="k">in</span>
</span></span><span class="line"><span class="cl">
</span></span><span class="line"><span class="cl">    <span class="nn">Silo</span><span class="p">.</span><span class="n">connect</span> <span class="o">~</span><span class="n">config</span>
</span></span><span class="line"><span class="cl">  <span class="k">in</span>
</span></span><span class="line"><span class="cl">
</span></span><span class="line"><span class="cl">  <span class="c">(* Fetch the user and return the user to a variable *)</span>
</span></span><span class="line"><span class="cl">  <span class="k">let</span><span class="o">*</span> <span class="n">fetched_users</span> <span class="o">=</span>
</span></span><span class="line"><span class="cl">    <span class="nn">Silo</span><span class="p">.</span><span class="n">query</span>
</span></span><span class="line"><span class="cl">      <span class="n">db</span>
</span></span><span class="line"><span class="cl">      <span class="o">~</span><span class="n">query</span><span class="o">:</span>
</span></span><span class="line"><span class="cl">        <span class="s2">&quot;select name, id, some_bool, pet_name, some_int64, some_int32, some_float, pets, pets as pets_array from users limit 2&quot;</span>
</span></span><span class="line"><span class="cl">      <span class="o">~</span><span class="n">deserializer</span><span class="o">:</span><span class="n">deserialize_users</span>
</span></span><span class="line"><span class="cl">  <span class="k">in</span>
</span></span><span class="line"><span class="cl">
</span></span><span class="line"><span class="cl">  <span class="nn">List</span><span class="p">.</span><span class="n">iter</span>
</span></span><span class="line"><span class="cl">    <span class="o">(</span><span class="k">fun</span> <span class="n">x</span> <span class="o">-&gt;</span>
</span></span><span class="line"><span class="cl">      <span class="nn">Printf</span><span class="p">.</span><span class="n">printf</span>
</span></span><span class="line"><span class="cl">        <span class="s2">&quot;Fetching user with id %d:</span><span class="se">\n</span><span class="s2">Name: %s</span><span class="se">\n</span><span class="s2">Some float: %f</span><span class="se">\n</span><span class="s2">Some int64: %d</span><span class="se">\n</span><span class="s2">Some int32: %d</span><span class="se">\n</span><span class="s2">%s</span><span class="se">\n</span><span class="s2"> Some bool: %b</span><span class="se">\n</span><span class="s2">Pets: %s</span><span class="se">\n</span><span class="s2">Pets array: %s</span><span class="se">\n\n</span><span class="s2">&quot;</span>
</span></span><span class="line"><span class="cl">        <span class="n">x</span><span class="o">.</span><span class="n">id</span>
</span></span><span class="line"><span class="cl">        <span class="n">x</span><span class="o">.</span><span class="n">name</span>
</span></span><span class="line"><span class="cl">        <span class="n">x</span><span class="o">.</span><span class="n">some_float</span>
</span></span><span class="line"><span class="cl">        <span class="o">(</span><span class="nn">Int64</span><span class="p">.</span><span class="n">to_int</span> <span class="n">x</span><span class="o">.</span><span class="n">some_int64</span><span class="o">)</span>
</span></span><span class="line"><span class="cl">        <span class="o">(</span><span class="nn">Int32</span><span class="p">.</span><span class="n">to_int</span> <span class="n">x</span><span class="o">.</span><span class="n">some_int32</span><span class="o">)</span>
</span></span><span class="line"><span class="cl">        <span class="o">(</span><span class="k">match</span> <span class="n">x</span><span class="o">.</span><span class="n">pet_name</span> <span class="k">with</span>
</span></span><span class="line"><span class="cl">        <span class="o">|</span> <span class="nc">Some</span> <span class="n">pn</span> <span class="o">-&gt;</span> <span class="nn">Printf</span><span class="p">.</span><span class="n">sprintf</span> <span class="s2">&quot;Pet name: %S&quot;</span> <span class="n">pn</span>
</span></span><span class="line"><span class="cl">        <span class="o">|</span> <span class="nc">None</span> <span class="o">-&gt;</span> <span class="s2">&quot;No pet&quot;</span><span class="o">)</span>
</span></span><span class="line"><span class="cl">        <span class="n">x</span><span class="o">.</span><span class="n">some_bool</span>
</span></span><span class="line"><span class="cl">        <span class="o">(</span><span class="nn">String</span><span class="p">.</span><span class="n">concat</span> <span class="s2">&quot;, &quot;</span> <span class="n">x</span><span class="o">.</span><span class="n">pets</span><span class="o">)</span>
</span></span><span class="line"><span class="cl">        <span class="o">(</span><span class="nn">String</span><span class="p">.</span><span class="n">concat</span> <span class="s2">&quot;, &quot;</span> <span class="o">(</span><span class="nn">Array</span><span class="p">.</span><span class="n">to_list</span> <span class="n">x</span><span class="o">.</span><span class="n">pets_array</span><span class="o">)))</span>
</span></span><span class="line"><span class="cl">    <span class="o">(</span><span class="nn">Option</span><span class="p">.</span><span class="n">get</span> <span class="n">fetched_users</span><span class="o">);</span>
</span></span></code></pre></td></tr></table>
</div>
</div><p>Silo is the library I anticipate most developers will use if they don&rsquo;t create their own database library and need further control over functionality.</p>
<h2>The future</h2>
<p>There is some more stuff I&rsquo;ve planned for this project, such as building more drivers and deserializers for different databases:</p>
<ul>
<li>MariaDB</li>
<li>MySQL</li>
<li>SQLite</li>
<li>Turso</li>
<li>Clickhouse</li>
</ul>
<p>I also want to build more tools for you as a developer when you write your OCaml projects, and some of these are:</p>
<ul>
<li>Generate types based on the query</li>
<li>Mock database driver so you can test the functionality within your project without a database running</li>
<li>Developer feedback from your LSP</li>
</ul>
<h2>The End</h2>
<p>I hope you appreciate these changes. If you&rsquo;re interested in contributing to the libraries or discussing them, I recommend joining the Discord: <a href="https://discord.gg/wqbprMmgaD">https://discord.gg/wqbprMmgaD</a></p>
<p>For more minor updates, follow my Twitter page: <a href="https://twitter.com/emil_priver">https://twitter.com/emil_priver</a></p>
<p>If you find a bug would I love if you create a issue here: <a href="https://github.com/dbcaml/dbcaml/issues">https://github.com/dbcaml/dbcaml/issues</a></p>

