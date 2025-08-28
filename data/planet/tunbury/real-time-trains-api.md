---
title: Real Time Trains API
description: After the Heathrow substation electrical fire, I found myself in Manchester
  with a long train ride ahead. Checking on Real Time Trains for the schedule I noticed
  that they had an API. With time to spare, I registered for an account and downloaded
  the sample code from ocaml-cohttp.
url: https://www.tunbury.org/2025/03/23/real-time-trains/
date: 2025-03-23T00:00:00-00:00
preview_image: https://www.tunbury.org/images/rtt.png
authors:
- Mark Elvers
source:
ignore:
---

<p>After the Heathrow substation electrical fire, I found myself in Manchester with a long train ride ahead.  Checking on <a href="https://www.realtimetrains.co.uk">Real Time Trains</a> for the schedule I noticed that they had an API.  With time to spare, I registered for an account and downloaded the sample code from <a href="https://github.com/mirage/ocaml-cohttp">ocaml-cohttp</a>.</p>

<p>The API account details uses HTTP basic authentication which is added via the HTTP header:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code>  <span class="k">let</span> <span class="n">headers</span> <span class="o">=</span> <span class="nn">Cohttp</span><span class="p">.</span><span class="nn">Header</span><span class="p">.</span><span class="n">init</span> <span class="bp">()</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">headers</span> <span class="o">=</span>
    <span class="nn">Cohttp</span><span class="p">.</span><span class="nn">Header</span><span class="p">.</span><span class="n">add_authorization</span> <span class="n">headers</span> <span class="p">(</span><span class="nt">`Basic</span> <span class="p">(</span><span class="n">user</span><span class="o">,</span> <span class="n">password</span><span class="p">))</span>
</code></pre></div></div>

<p>The response from the API can be converted to JSON using <a href="https://github.com/ocaml-community/yojson">Yojson</a>.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">json</span> <span class="o">=</span>
      <span class="nn">Eio</span><span class="p">.</span><span class="nn">Buf_read</span><span class="p">.(</span><span class="n">parse_exn</span> <span class="n">take_all</span><span class="p">)</span> <span class="n">body</span> <span class="o">~</span><span class="n">max_size</span><span class="o">:</span><span class="n">max_int</span>
      <span class="o">|&gt;</span> <span class="nn">Yojson</span><span class="p">.</span><span class="nn">Safe</span><span class="p">.</span><span class="n">from_string</span>
</code></pre></div></div>

<p>The JSON field can be read using the <code class="language-plaintext highlighter-rouge">Util</code> functions.  For example, <code class="language-plaintext highlighter-rouge">Yojson.Basic.Util.member "services" json</code> will read the <code class="language-plaintext highlighter-rouge">services</code> entry.  Elements can be converted to lists with <code class="language-plaintext highlighter-rouge">Yojson.Basic.Util.to_list</code>.  After a bit of hacking this turned out to be quite tedious to code.</p>

<p>As an alternative, I decided to use <code class="language-plaintext highlighter-rouge">ppx_deriving_yojson.runtime</code>.  I described the JSON blocks as OCaml types, e.g. <code class="language-plaintext highlighter-rouge">station</code> as below.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">type</span> <span class="n">station</span> <span class="o">=</span> <span class="p">{</span>
  <span class="n">tiploc</span> <span class="o">:</span> <span class="kt">string</span><span class="p">;</span>
  <span class="n">description</span> <span class="o">:</span> <span class="kt">string</span><span class="p">;</span>
  <span class="n">workingTime</span> <span class="o">:</span> <span class="kt">string</span><span class="p">;</span>
  <span class="n">publicTime</span> <span class="o">:</span> <span class="kt">string</span><span class="p">;</span>
<span class="p">}</span>
<span class="p">[</span><span class="o">@@</span><span class="n">deriving</span> <span class="n">yojson</span><span class="p">]</span>
</code></pre></div></div>

<p>The preprocessor automatically generates two functions:<code class="language-plaintext highlighter-rouge">station_of_json</code> and <code class="language-plaintext highlighter-rouge">station_to_json</code> which handle the conversion.</p>

<p>The only negative on this approach is that RTT doesn’t emit empty JSON fields, so they need to be flagged as possibly missing and a default value provided.  For example, <code class="language-plaintext highlighter-rouge">realtimeArrivalNextDay</code> is not emitted unless the value is <code class="language-plaintext highlighter-rouge">true</code>.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code>  <span class="n">realtimeArrivalNextDay</span> <span class="o">:</span> <span class="p">(</span><span class="kt">bool</span><span class="p">[</span><span class="o">@</span><span class="n">default</span> <span class="bp">false</span><span class="p">]);</span>
</code></pre></div></div>

<p>Now once the JSON has been received we can just convert it to OCaml types very easily:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code>    <span class="k">match</span> <span class="n">reply_of_yojson</span> <span class="n">json</span> <span class="k">with</span>
    <span class="o">|</span> <span class="nc">Ok</span> <span class="n">reply</span> <span class="o">-&gt;</span>
       <span class="c">(* Use reply.services *)</span>
    <span class="o">|</span> <span class="nc">Error</span> <span class="n">err</span> <span class="o">-&gt;</span> <span class="nn">Printf</span><span class="p">.</span><span class="n">printf</span> <span class="s2">"Error %s</span><span class="se">\n</span><span class="s2">"</span> <span class="n">err</span>
</code></pre></div></div>

<p>My work in progress code is available on <a href="https://github.com/mtelvers/ocaml-rtt">GitHub</a></p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>dune exec --release -- rtt --user USER --pass PASS --station RTR
rtt: [DEBUG] received 3923 bytes of body
rtt: [DEBUG] received 4096 bytes of body
rtt: [DEBUG] received 4096 bytes of body
rtt: [DEBUG] received 4096 bytes of body
rtt: [DEBUG] received 1236 bytes of body
rtt: [DEBUG] end of inbound body
2025-03-23 2132 W16178 1C69 1 Ramsgate St Pancras International
2025-03-23 2132 W25888 9P59 2 Plumstead Rainham (Kent)
2025-03-23 2136 J00119 1U28 2 London Victoria Ramsgate
2025-03-23 2144 W25927 9P86 1 Rainham (Kent) Plumstead
2025-03-23 2157 W16899 1C66 2 St Pancras International Ramsgate
2025-03-23 2202 W25894 9P61 2 Plumstead Rainham (Kent)
2025-03-23 2210 J26398 1U80 1 Ramsgate London Victoria
2025-03-23 2214 W25916 9P70 1 Rainham (Kent) Plumstead
2025-03-23 2232 W16910 1C73 1 Ramsgate St Pancras International
2025-03-23 2232 W25900 9P63 2 Plumstead Rainham (Kent)
2025-03-23 2236 J00121 1U30 2 London Victoria Ramsgate
2025-03-23 2244 W25277 9A92 1 Rainham (Kent) Dartford
2025-03-23 2257 W16450 1F70 2 St Pancras International Faversham
2025-03-23 2302 W25906 9P65 2 Plumstead Rainham (Kent)
2025-03-23 2314 W25283 9A94 1 Rainham (Kent) Dartford
2025-03-23 2318 J00155 1U82 1 Ramsgate London Victoria
2025-03-23 2332 W25912 9P67 2 Plumstead Gillingham (Kent)
2025-03-23 2336 J00123 1U32 2 London Victoria Ramsgate
2025-03-23 2344 W25289 9A96 1 Rainham (Kent) Dartford
2025-03-23 2357 W16475 1F74 2 St Pancras International Faversham
2025-03-23 0002 W25915 9P69 2 Plumstead Gillingham (Kent)
2025-03-23 0041 J26381 1Z34 2 London Victoria Faversham
</code></pre></div></div>
