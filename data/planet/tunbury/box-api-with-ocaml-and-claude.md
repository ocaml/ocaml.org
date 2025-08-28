---
title: Box API with OCaml and Claude
description: Over the weekend, I decided to extend my Box tool to incorporate file
  upload. There is a straightforward POST API for this with a curl one-liner given
  in the Box documentation. Easy.
url: https://www.tunbury.org/2025/04/07/ocaml-claude-box/
date: 2025-04-07T00:00:00-00:00
preview_image: https://www.tunbury.org/images/box-logo.png
authors:
- Mark Elvers
source:
ignore:
---

<p>Over the weekend, I decided to extend my <a href="https://box.com">Box</a> <a href="https://github.com/mtelvers/ocaml-box-diff">tool</a> to incorporate file upload. There is a straightforward POST API for this with a <code class="language-plaintext highlighter-rouge">curl</code> one-liner given in the Box <a href="https://developer.box.com/reference/post-files-content/">documentation</a>. Easy.</p>

<p>The documentation for <a href="https://mirage.github.io/ocaml-cohttp/cohttp-eio/Cohttp_eio/Client/index.html">Cohttp-eio.Client</a> only gives the function signature for <code class="language-plaintext highlighter-rouge">post</code>, but it looked pretty similar to <code class="language-plaintext highlighter-rouge">get</code>, which I had already been working with. The <a href="https://github.com/mirage/ocaml-cohttp">README</a> for Cohttp gave me pause when I read this comment about multipart forms.</p>

<blockquote>
  <p>Multipart form data is not supported out of the box but is provided by external libraries</p>
</blockquote>

<p>Of the three options given, the second option looked abandoned, while the third said it didn’t support streaming, so I went with the first one <a href="https://github.com/dinosaure/multipart_form">dionsaure/multipart_form</a>.</p>

<p>The landing page included an example encoder. A couple of external functions are mentioned, and I found example code for these in <a href="https://github.com/dinosaure/multipart_form/blob/main/test/test.ml">test/test.ml</a>. This built, but didn’t work against Box. I ran <code class="language-plaintext highlighter-rouge">nc -l 127.0.0.1 6789</code> and set that as the API endpoint for both the <code class="language-plaintext highlighter-rouge">curl</code> and my application. This showed I was missing the <code class="language-plaintext highlighter-rouge">Content-Type</code> header in the part boundary. It should be <code class="language-plaintext highlighter-rouge">application/octet-stream</code>.</p>

<p>There is a <code class="language-plaintext highlighter-rouge">~header</code> parameter to <code class="language-plaintext highlighter-rouge">part</code>, and I hoped for a <code class="language-plaintext highlighter-rouge">Header.add</code> like the <code class="language-plaintext highlighter-rouge">Cohttp</code>, but sadly not. See the <a href="https://ocaml.org/p/multipart_form/latest/doc/Multipart_form/Header/index.html">documentation</a>. There is <code class="language-plaintext highlighter-rouge">Header.content_type</code>, but that returns the content type. How do you make it? <code class="language-plaintext highlighter-rouge">Header.of_list</code> requires a <code class="language-plaintext highlighter-rouge">Field.field list</code>.</p>

<p>In a bit of frustration, I decided to ask Claude. I’ve not tried it before, but I’ve seen some impressive demonstrations. My first lesson here was to be specific. Claude is not a mind reader. After a few questions, I got to this:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="nn">Field</span><span class="p">.(</span><span class="n">make</span> <span class="nn">Content_type</span><span class="p">.</span><span class="n">name</span> <span class="p">(</span><span class="nn">Content_type</span><span class="p">.</span><span class="n">v</span> <span class="nt">`Application</span> <span class="nt">`Octet_stream</span><span class="p">));</span>
</code></pre></div></div>

<p>I can see why this was suggested as <code class="language-plaintext highlighter-rouge">Content_disposition.v</code> exists, but <code class="language-plaintext highlighter-rouge">Content_type.v</code> does not, nor does <code class="language-plaintext highlighter-rouge">Field.make</code>. Claude quickly obliged with a new version when I pointed this out but added the <code class="language-plaintext highlighter-rouge">Content_type</code> to the HTTP header rather than the boundary header. This went back and forth for a while, with Claude repeatedly suggesting functions which did not exist. I gave up.</p>

<p>On OCaml.org, the <a href="https://ocaml.org/p/multipart_form/latest">multipart-form</a> documentation includes a <em>Used by</em> section that listed <code class="language-plaintext highlighter-rouge">dream</code> as the only (external) application which used the library. From the source, I could see <code class="language-plaintext highlighter-rouge">Field.Field (field_name, Field.Content_type, v)</code>, which looked good.</p>

<p>There is a function <code class="language-plaintext highlighter-rouge">Content_type.of_string</code>. I used <code class="language-plaintext highlighter-rouge">:MerlinLocate</code> to find the source, which turned out to be an Angstrom parser which returns a <code class="language-plaintext highlighter-rouge">Content_type.t</code>. This led me to <code class="language-plaintext highlighter-rouge">Content_type.make</code>, and ultimately, I was able to write these two lines:</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">v</span> <span class="o">=</span> <span class="nn">Content_type</span><span class="p">.</span><span class="n">make</span> <span class="nt">`Application</span> <span class="p">(</span><span class="nt">`Iana_token</span> <span class="s2">"octet-stream"</span><span class="p">)</span> <span class="nn">Content_type</span><span class="p">.</span><span class="nn">Parameters</span><span class="p">.</span><span class="n">empty</span>
<span class="k">let</span> <span class="n">p0</span> <span class="o">=</span> <span class="n">part</span> <span class="o">~</span><span class="n">header</span><span class="o">:</span><span class="p">(</span><span class="nn">Header</span><span class="p">.</span><span class="n">of_list</span> <span class="p">[</span> <span class="nc">Field</span> <span class="p">(</span><span class="nn">Field_name</span><span class="p">.</span><span class="n">content_type</span><span class="o">,</span> <span class="nc">Content_type</span><span class="o">,</span> <span class="n">v</span><span class="p">)</span> <span class="p">])</span> <span class="o">...</span>
</code></pre></div></div>

<p>As a relatively new adopter of OCaml as my language of choice, the most significant challenge I face is documentation, particularly when I find a library on opam which I want to use. I find this an interesting contrast to the others in the community, where it is often cited that tooling is the most significant barrier to adoption. In my opinion, the time taken to set up a build environment is dwarfed by the time spent in that environment iterating code.</p>

<p>I would like to take this opportunity to thank all contributors to opam repository for their time and effort in making packages available. This post mentions specific packages but only to illustrate my point.</p>
