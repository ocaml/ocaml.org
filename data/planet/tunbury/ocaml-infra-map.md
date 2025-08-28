---
title: OCaml Infra Map
description: "Yesterday, we were talking about extending the current infrastructure
  database to incorporate other information to provide prompts to return machines
  to the pool of resources after they have completed their current role/loan, etc.
  There is also a wider requirement to bring these services back to Cambridge from
  Equinix/Scaleway, which will be the subject of a follow-up post. However, the idea
  of extending the database made me think that it would be amusing to overlay the
  machine\u2019s positions onto Google Maps."
url: https://www.tunbury.org/2025/04/24/infra-map/
date: 2025-04-24T10:00:00-00:00
preview_image: https://www.tunbury.org/images/ocaml-map.png
authors:
- Mark Elvers
source:
ignore:
---

<p>Yesterday, we were talking about extending the current infrastructure database to incorporate other information to provide prompts to return machines to the pool of resources after they have completed their current role/loan, etc. There is also a wider requirement to bring these services back to Cambridge from Equinix/Scaleway, which will be the subject of a follow-up post. However, the idea of extending the database made me think that it would be amusing to overlay the machine’s positions onto Google Maps.</p>

<p>I added positioning data in the Jekyll Collection <code class="language-plaintext highlighter-rouge">_machines\*.md</code> for each machine. e.g. <a href="https://raw.githubusercontent.com/ocaml/infrastructure/refs/heads/master/_machines/ainia.md">ainia.md</a></p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>---
name: ainia
...
latitude: 52.2109
longitude: 0.0917
---
</code></pre></div></div>

<p>Then Jekyll’s Liquid templating engine can create a JavaScript array for us</p>

<div class="language-js highlighter-rouge"><div class="highlight"><pre class="highlight"><code>
  <span class="c1">// Define machines data array from Jekyll collection</span>
  <span class="kd">const</span> <span class="nx">machinesData</span> <span class="o">=</span> <span class="p">[</span>
    <span class="p">{</span><span class="o">%</span> <span class="k">for</span> <span class="nx">machine</span> <span class="k">in</span> <span class="nx">site</span><span class="p">.</span><span class="nx">machines</span> <span class="o">%</span><span class="p">}</span>
      <span class="p">{</span><span class="o">%</span> <span class="k">if</span> <span class="nx">machine</span><span class="p">.</span><span class="nx">latitude</span> <span class="nx">and</span> <span class="nx">machine</span><span class="p">.</span><span class="nx">longitude</span> <span class="o">%</span><span class="p">}</span>
      <span class="p">{</span>
        <span class="na">name</span><span class="p">:</span> <span class="dl">"</span><span class="s2">{{ machine.name }}</span><span class="dl">"</span><span class="p">,</span>
        <span class="na">lat</span><span class="p">:</span> <span class="p">{{</span> <span class="nx">machine</span><span class="p">.</span><span class="nx">latitude</span> <span class="p">}},</span>
        <span class="na">lng</span><span class="p">:</span> <span class="p">{{</span> <span class="nx">machine</span><span class="p">.</span><span class="nx">longitude</span> <span class="p">}},</span>
        <span class="p">{</span><span class="o">%</span> <span class="k">if</span> <span class="nx">machine</span><span class="p">.</span><span class="nx">description</span> <span class="o">%</span><span class="p">}</span>
        <span class="nl">description</span><span class="p">:</span> <span class="dl">"</span><span class="s2">{{ machine.description | escape }}</span><span class="dl">"</span><span class="p">,</span>
        <span class="p">{</span><span class="o">%</span> <span class="nx">endif</span> <span class="o">%</span><span class="p">}</span>
        <span class="c1">// Add any other properties you need</span>
      <span class="p">},</span>
      <span class="p">{</span><span class="o">%</span> <span class="nx">endif</span> <span class="o">%</span><span class="p">}</span>
    <span class="p">{</span><span class="o">%</span> <span class="nx">endfor</span> <span class="o">%</span><span class="p">}</span>
  <span class="p">];</span>

</code></pre></div></div>

<p>This array can be converted into an array of map markers. Google have an API for clustering the markers into a count of machines. I added a random offset to each location to avoid all the markers piling up on a single spot.</p>

<p>The interactive map can be seen at <a href="https://infra.ocaml.org/machines.html">machines.html</a></p>
