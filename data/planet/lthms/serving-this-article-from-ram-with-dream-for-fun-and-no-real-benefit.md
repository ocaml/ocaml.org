---
title: Serving This Article from RAM with Dream for Fun and No Real Benefit
description: 'This article is a kind of experience report of writing an HTTP server
  serving my website directly from memory, no file system involved. Just keep in mind:
  I am pretty that you should not try to reproduce this for your own little corner
  of the Internet, but I had a lot of fun.'
url: https://soap.coffee/~lthms/posts/DreamWebsite.html
date: 2024-12-25T00:00:00-00:00
preview_image: https://soap.coffee/~lthms/img/thinking.png
authors:
- "Thomas Letan\u2019s Blog"
source:
---


        
        <h1>Serving This Article from RAM with Dream for Fun and No Real Benefit</h1><div><span class="icon"><svg><use href="/~lthms/img/icons.svg#tag"></use></svg></span>&nbsp;<a href="https://soap.coffee/~lthms/tags/ocaml.html" marked="" class="tag">ocaml</a> <span class="icon"><svg><use href="/~lthms/img/icons.svg#tag"></use></svg></span>&nbsp;<a href="https://soap.coffee/~lthms/tags/meta.html" marked="" class="tag">meta</a> </div>
<p>In 2022, Xe Iaso published a <a href="https://xeiaso.net/talks/how-my-website-works/" marked="">transcript of their talk on how their website was
working at the time&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a>. In a nutshell, their approach consisted of a
server preprocessing the website from its source at startup, then serving its
contents from memory. If you have not already, I can only encourage you to read
the article or watch the talk, as the story they tell is very interesting. For
me personally, it sparked a question: what if, instead of preprocessing the
website at startup, one decided to embed the already preprocessed website
within the program of the HTTP server tasked to serve it?</p>
<p>Fast-forward today, and this question has finally been answered. The webpage
you are currently reading has been served to you by an ad hoc HTTP server built
with <a href="https://aantron.github.io/dream/" marked="">Dream&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a>, whose binary is the only file I need to push to my server to
deploy the latest version of my website. I have actually deployed it, and it’s
been serving the contents of this website for more than a week now.</p>
<p>What did I learn from this fun, little experiment? Basically, that this
approach changes nothing, as far as <a href="https://chromewebstore.google.com/detail/lighthouse/blipmdconlkpinefehnmjammfjpmpbjk?pli=1" marked="">Lighthouse&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a> and my monitoring is
concerned. I couldn’t find any meaningful differences between a static website
served by Nginx, a piece of software with thousands and thousands of
engineering work behind it, and my little toy web server pieced together in an
hour or so. Still. It was fun, so why not write about it?</p>
<p>This article is a kind of experience report. I’ll dive into what I have done to
turn my website into a single, static binary. Not only does it mean writing
some OCaml, which is always fun, but it also requires understanding a little
some key HTTP headers, as well as using Docker to build easily deployable
binaries. All in all, I hope it will be an interesting read for the curious
minds.</p>
<h2>Embedding My Website in a Binary</h2>
<p>Not much had changed much since <a href="https://soap.coffee/~lthms/posts/August2022.html" marked="">I stopped using <strong><code class="hljs">cleopatra</code></strong> to generate
this website</a>, and <a href="https://soap.coffee/~lthms/posts/Thanks2023.html" marked="">the article I published in 2023 still
stands</a>. In a nutshell, I work in the <code class="hljs">site/</code> directory, and <a href="https://soupault.app" marked="">soupault&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a>
generates my website in the <code class="hljs">out/~lthms</code> directory, thanks to a collection of
built-in and ad hoc plugins<label for="fn1" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-right sidenote note"><span class="footnote-p">For instance, Markdown footnotes are turned into side notes with
a soupault plugin. </span>
</span>. To deploy the website, I was relying
on <code class="hljs">rsync</code> to sync the contents of the <code class="hljs">out/~lthms</code> directory with the
directory statically served by a Nginx instance on my personal server.</p>
<p>The first step of my little toy project is to actually embed the output of
soupault into an OCaml program.</p>
<p>That’s where <a href="https://github.com/mirage/ocaml-crunch" marked="">ocaml-crunch&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a> comes in handy. It is a little program published by
<a href="https://tarides.com/" marked="">Tarides&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a>, whose only job is to generate an OCaml module from a file system
directory. It is straightforward to use it from Dune.</p>
<pre><code class="hljs language-lisp"><span class="hljs-comment">; file: out/dune</span>
(<span class="hljs-name">rule</span>
 (<span class="hljs-name">target</span> website_content.ml)
 (<span class="hljs-name">deps</span> (<span class="hljs-name">source_tree</span> ~lthms))
 (<span class="hljs-name">action</span>
  (<span class="hljs-name">run</span> ocaml-crunch -m plain -o %{target} -s ~lthms)))
</code></pre>
<p>This snippet generates the <code class="hljs">website_content.ml</code> module, which we can then
expose through a library with the <code class="hljs">library</code> stanza.</p>
<pre><code class="hljs language-lisp"><span class="hljs-comment">; file: out/dune</span>
(<span class="hljs-name">library</span>
 (<span class="hljs-name">name</span> website_content))
</code></pre>
<p>And we are basically done. Excluding an <code class="hljs">Internal</code> module, the signature of
<code class="hljs">Website_content</code> is pretty straightforward.</p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">val</span> file_list : <span class="hljs-built_in">string</span> <span class="hljs-built_in">list</span>
<span class="hljs-keyword">val</span> read : <span class="hljs-built_in">string</span> -&gt; <span class="hljs-built_in">string</span> option
<span class="hljs-keyword">val</span> hash : <span class="hljs-built_in">string</span> -&gt; <span class="hljs-built_in">string</span> option
<span class="hljs-keyword">val</span> size : <span class="hljs-built_in">string</span> -&gt; <span class="hljs-built_in">int</span> option
</code></pre>
<h2>Serving the content with Dream</h2>
<p><a href="https://aantron.github.io/dream/" marked="">Dream&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a> is a cool project, and provides a straightforward API that we can
leverage to turn our list of in-memory files into an HTTP server.</p>
<h3>Naive Approach</h3>
<p>Our goal now is to create a <code class="hljs">Dream.handler</code> for each item in
<code class="hljs language-ocaml">file_list</code>. Done naively (as was my first attempt), it gives you
something of the form:</p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">let</span> make_handler ~content path =
  <span class="hljs-type">Dream</span>.get path (<span class="hljs-keyword">fun</span> req -&gt;
    <span class="hljs-type">Lwt</span>.return (<span class="hljs-type">Dream</span>.response content)))
</code></pre>
<p>Which we can use to build the main route we will then pass to <code class="hljs">Dream.router</code>.</p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">let</span> website_route =
  <span class="hljs-type">Dream</span>.scope <span class="hljs-string">"~lthms"</span> <span class="hljs-literal">[]</span>
  @@ <span class="hljs-type">List</span>.map
       (<span class="hljs-keyword">fun</span> path -&gt;
         <span class="hljs-keyword">let</span> content = <span class="hljs-type">Option</span>.get (<span class="hljs-type">Website_content</span>.read path) <span class="hljs-keyword">in</span>
         make_handler ~content path)
       <span class="hljs-type">Website_content</span>.file_list
</code></pre>
<p>With this approach, we build our handlers once, and then the lookup is done by
Dream’s router. It could be an interesting experiment to see if doing the
lookup ourselves is more performant (since Dream’s router is very generic,
while in our case we don’t really need to parse anything). I remember Xe
routing is basically going through a linked list, which seems strange at first,
but works very well in practice because they have ordered said list with the
most recent articles up front, and everybody comes to their website to read the
latest article anyway.</p>
<p>It does not take an extensive QA process to figure out that this approach
is far from being enough. To name a few things:</p>
<ul>
<li>My website assumes <code class="hljs">http://path/index.html</code> can be accessed with
<code class="hljs">http://path/</code> or <code class="hljs">http://path</code>. Our little snippet does not handle this.</li>
<li>Browsers expect the <code class="hljs">Content-Type</code> headers to be correctly set. To give an
example, they won't load a CSS file if the <code class="hljs">Content-Type</code> header is not set
to <code class="hljs">text/css</code>.</li>
<li>Browsers work best for websites that take the time to provide caching
directives. Our little snippet does not care to do so.</li>
<li>Even if my website is rather lightweight<label for="fn2" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-left sidenote note"><span class="footnote-p">20MBytes at the time of writing the first version of this article. </span>
</span>, compressing the response
of our HTTP server for clients that support it is always a good idea.</li>
</ul>
<p>This is a gentle reminder of all the things Nginx can do for you with very
little configuration.</p>
<h3>Handling <code class="hljs">index.html</code> Synonyms</h3>
<p>This one is rather simple. For files named <code class="hljs">index.html</code>, we need 3 handers, not
just one. We can achieve this with an additional helper
<code class="hljs">make_handler_remove_suffix</code>.</p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">let</span> make_handler_remove_suffix ~content path suffix
    =
  <span class="hljs-keyword">if</span> <span class="hljs-type">String</span>.ends_with ~suffix path <span class="hljs-keyword">then</span>
    <span class="hljs-keyword">let</span> alt_path =
      <span class="hljs-type">String</span>.sub path <span class="hljs-number">0</span> (<span class="hljs-type">String</span>.length path - <span class="hljs-type">String</span>.length suffix)
    <span class="hljs-keyword">in</span>
    [ make_handler ~content alt_path ]
  <span class="hljs-keyword">else</span> <span class="hljs-literal">[]</span>
</code></pre>
<p>Updating the <code class="hljs">website_route</code> definition to use <code class="hljs">make_handler_remove_suffix</code> is
quite easy as well.</p>
<pre><code class="hljs language-patch"> let website_route =
   Dream.scope "~lthms" []
<span class="hljs-deletion">-  @@ List.map</span>
<span class="hljs-addition">+  @@ List.concat_map</span>
        (fun path -&gt;
          let content = Option.get (Website_content.read path) in
<span class="hljs-deletion">-         make_handler ~content path)</span>
<span class="hljs-addition">+         if path = "index.html" then</span>
<span class="hljs-addition">+           (* Special case to deal with "index.html" which needs to be</span>
<span class="hljs-addition">+              recognized by the route "/" *)</span>
<span class="hljs-addition">+           [</span>
<span class="hljs-addition">+             make_handler ~content "/";</span>
<span class="hljs-addition">+             make_handler ~content "";</span>
<span class="hljs-addition">+             make_handler ~content "index.html";</span>
<span class="hljs-addition">+           ]</span>
<span class="hljs-addition">+         else</span>
<span class="hljs-addition">+           make_handler_remove_suffix ~content path</span>
<span class="hljs-addition">+             "/index.html"</span>
<span class="hljs-addition">+           @ make_handler_remove_suffix ~content</span>
<span class="hljs-addition">+               path "index.html"</span>
<span class="hljs-addition">+           @ [ make_handler ~content path ])</span>
        Website_content.file_list
</code></pre>
<p>With that, <code class="hljs">https://soap.coffee/~lthms/posts/index.html</code> returns the same pages
as <code class="hljs">https://soap.coffee/~lthms/posts</code> or <code class="hljs">https://soap.coffee/~lthms/posts</code>.
Check.</p>
<h3>Supporting <code class="hljs">Content-Type</code></h3>
<p><code class="hljs">Content-Type</code> is an HTTP header which is used by the receiver of the HTTP
message (whether it is a request or a response) to interpret its content.</p>
<p>For instance, when building a RPC API, <code class="hljs">Content-Type</code> is used by the server to
know how to parse the request body (<code class="hljs language-http"><span class="hljs-attribute">Content-Type</span><span class="hljs-punctuation">: </span>application/json</code> or
<code class="hljs language-http"><span class="hljs-attribute">Content-Type</span><span class="hljs-punctuation">: </span>application/octet-stream</code> being two popular choices, for
JSON or binary encoding, respectively).</p>
<p>In our case, the <code class="hljs">Content-Type</code> header is used by the HTTP server to
communicate the nature of the content to browsers. For my website, I can just
use the file extensions to infer the correct header to set. First, we list the
extensions that are actually used.</p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">let</span> content_types =
  [
    (<span class="hljs-string">".html"</span>, <span class="hljs-string">"text/html"</span>);
    (<span class="hljs-string">".css"</span>, <span class="hljs-string">"text/css"</span>);
    (<span class="hljs-string">".xml"</span>, <span class="hljs-string">"text/xml"</span>);
    (<span class="hljs-string">".png"</span>, <span class="hljs-string">"image/png"</span>);
    (<span class="hljs-string">".svg"</span>, <span class="hljs-string">"image/svg+xml"</span>);
    (<span class="hljs-string">".gz"</span>, <span class="hljs-string">"application/gzip"</span>);
    (<span class="hljs-string">".pub"</span>, <span class="hljs-string">"text/plain"</span>);
  ]
</code></pre>
<p>A header in Dream is encoded as a <code class="hljs language-ocaml"><span class="hljs-built_in">string</span> * <span class="hljs-built_in">string</span></code> value, with the
first <code class="hljs language-ocaml"><span class="hljs-built_in">string</span></code> being the header name and the second being the header
value.</p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">let</span> content_type_header path =
  <span class="hljs-type">List</span>.filter_map
    (<span class="hljs-keyword">fun</span> (ext, content_type) -&gt;
      <span class="hljs-keyword">if</span> <span class="hljs-type">String</span>.ends_with ~suffix:ext path <span class="hljs-keyword">then</span>
        <span class="hljs-type">Some</span> (<span class="hljs-string">"Content-Type"</span>, content_type)
      <span class="hljs-keyword">else</span> <span class="hljs-type">None</span>)
    content_types
  |&gt; assert_f
       ~error_msg:<span class="hljs-type">Format</span>.(sprintf <span class="hljs-string">"Unsupported file type %s"</span> path)
       (( &lt;&gt; ) <span class="hljs-literal">[]</span>)
</code></pre>
<p>with <code class="hljs language-ocaml">assert_f</code> being defined as follows.</p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">let</span> assert_f ~error_msg f v =
  <span class="hljs-keyword">if</span> f v <span class="hljs-keyword">then</span> v <span class="hljs-keyword">else</span> failwith error_msg
</code></pre>
<p><code class="hljs language-ocaml">assert_f</code> is used to enforce that I don’t deploy a website which
contains route lacking a <code class="hljs">Content-Type</code> header. For instance, if I remove the
<code class="hljs language-ocaml"><span class="hljs-string">"html"</span></code> entry of the <code class="hljs language-ocaml">content_type</code> list, I get this error
when I try to execute the server.</p>
<pre><code class="hljs">Fatal error: exception Failure("Unsupported file type index.html")
</code></pre>
<p>This is because the headers are only computed once, when each <code class="hljs">route</code> are
defined. This is a key principle of this project: compute once, serve many
time<label for="fn3" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-right sidenote note"><span class="footnote-p">I would love to get a compilation error instead (considering there
are no runtime values involved), but have not looked into this just yet. </span>
</span>.</p>
<pre><code class="hljs language-patch"> let website_route =
   Dream.scope "~lthms" []
   @@ List.concat_map
        (fun path -&gt;
          let content = Option.get (Website_content.read path) in
<span class="hljs-addition">+         let headers = content_type_header path in</span>
          if path = "index.html" then
            (* Special case to deal with "index.html" which needs to be
               recognized by the route "/" *)
            [
<span class="hljs-deletion">-             make_handler ~content "/";</span>
<span class="hljs-deletion">-             make_handler ~content "";</span>
<span class="hljs-deletion">-             make_handler ~content "index.html";</span>
<span class="hljs-addition">+             make_handler ~headers ~content "/";</span>
<span class="hljs-addition">+             make_handler ~headers ~content "";</span>
<span class="hljs-addition">+             make_handler ~headers ~content "index.html";</span>
            ]
          else
<span class="hljs-deletion">-           make_handler_remove_suffix ~content path</span>
<span class="hljs-addition">+           make_handler_remove_suffix ~headers ~content path</span>
              "/index.html"
<span class="hljs-deletion">-           @ make_handler_remove_suffix ~content</span>
<span class="hljs-addition">+           @ make_handler_remove_suffix ~headers ~content</span>
                path "index.html"
<span class="hljs-deletion">-           @ [ make_handler ~content path ])</span>
<span class="hljs-addition">+           @ [ make_handler ~headers ~content path ])</span>
        Website_content.file_list
</code></pre>
<p>(The changes in <code class="hljs">make_handler</code> and <code class="hljs">make_handler_remove_prefix</code> are left as an
exercise to enthusiast readers)</p>
<h3>Compressing if Requested</h3>
<p>Nowadays, computations are cheap, while downloading data costs time (and
sometimes money). As a consequence, it is often a good idea for a server to
compress a large HTTP response, and browsers do ask them to do so, by setting
the <a href="https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Accept-Encoding" marked=""><code class="hljs language-http">Accept-Encoding</code>&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a> header of their requests.</p>
<p>The value of the <code class="hljs language-http">Accept-Encoding</code> header is a comma-separated list of
supported compression algorithms, optionally ordered with a priority value <code class="hljs">q</code>.</p>
<p>For instance, <code class="hljs language-http"><span class="hljs-attribute">Accept-Encoding</span><span class="hljs-punctuation">: </span>gzip;q=0.5, deflate;q=0.3, identity</code>
tells you that the browser supports three encoding methods: <code class="hljs">gzip</code>, <code class="hljs">deflate</code>
and <code class="hljs">identity</code> (no compression), and the browser prefers <code class="hljs">gzip</code> over <code class="hljs">deflate</code>.
Besides, the request can provide several <code class="hljs">Accept-Encoding</code> headers instead of
just one, so we can have</p>
<pre><code class="hljs language-http"><span class="hljs-attribute">Accept-Encoding</span><span class="hljs-punctuation">: </span>gzip;q=0.5
<span class="hljs-attribute">Accept-Encoding</span><span class="hljs-punctuation">: </span>deflate;q=0.3
<span class="hljs-attribute">Accept-Encoding</span><span class="hljs-punctuation">: </span>identity
</code></pre>
<p>The <code class="hljs">String</code> module provides everything we need to check if a browser
supports gzip as an encoding method<label for="fn4" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-left sidenote note"><span class="footnote-p">Spoiler: they do. I was even wondering at some point if I could
just <em>always</em> return GZIP-compressed values, ignoring the
<code class="hljs language-http">Accept-Encoding</code> header altogether. If you do that, though, <code class="hljs">curl</code>
becomes annoying to use (it does not uncompress the response automatically,
and instead complains about being about to write binary to the standard
output). </span>
</span>.</p>
<pre><code class="hljs language-ocaml"><span class="hljs-comment">(* For [method(; q=val)?], returns [method], except if
   [q=0]. *)</span>
<span class="hljs-keyword">let</span> to_directive str =
  <span class="hljs-keyword">match</span> <span class="hljs-type">String</span>.split_on_char <span class="hljs-string">';'</span> str |&gt; <span class="hljs-type">List</span>.map <span class="hljs-type">String</span>.trim <span class="hljs-keyword">with</span>
  | [ x ] -&gt; <span class="hljs-type">Some</span> x
  | [ x; y ] -&gt; (
      <span class="hljs-keyword">match</span> <span class="hljs-type">String</span>.split_on_char <span class="hljs-string">'='</span> y |&gt; <span class="hljs-type">List</span>.map <span class="hljs-type">String</span>.trim <span class="hljs-keyword">with</span>
      | [ <span class="hljs-string">"q"</span>; <span class="hljs-string">"0"</span> ] -&gt; <span class="hljs-type">None</span>
      | [ <span class="hljs-string">"q"</span>; _ ] -&gt; <span class="hljs-type">Some</span> x
      | _ -&gt; <span class="hljs-type">None</span>)
  | _ -&gt; <span class="hljs-type">None</span>

<span class="hljs-comment">(* [contains ~value:v header] returns [true] if [v] is a
   supported method listed in [header]. *)</span>
<span class="hljs-keyword">let</span> contains ~<span class="hljs-keyword">value</span> header =
  <span class="hljs-type">String</span>.split_on_char <span class="hljs-string">','</span> header
  |&gt; <span class="hljs-type">List</span>.to_seq |&gt; <span class="hljs-type">Seq</span>.map <span class="hljs-type">String</span>.trim
  |&gt; <span class="hljs-type">Seq</span>.filter_map to_directive
  |&gt; <span class="hljs-type">Seq</span>.exists (( = ) <span class="hljs-keyword">value</span>)
</code></pre>
<p>We use <code class="hljs language-ocaml">contains</code> to tell us if we can return a compressed response,
which leaves us with one final question: how to compress said response?</p>
<p>The OCaml ecosystem seems to have picked <a href="https://ocaml.org/p/camlzip/latest" marked="">camlzip&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a> library when GZIP is
involved<label for="fn5" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-right sidenote note"><span class="footnote-p">You know it is a legitimate OCaml library when one of the top-level
modules <a href="https://ocaml.org/p/camlzip/latest/doc/Zlib/" marked="">is not documented at all&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a>. </span>
</span>. What is surprising with this library is that it does not
support in-memory compression: the functions expect channels, not
<code class="hljs language-ocaml"><span class="hljs-built_in">bytes</span></code>. That is quite annoying, because we are specifically doing this
<strong>not</strong> to use files.</p>
<p>The Internet is helpful here, and quickly suggests using pipes. It works when
you remember –or figure out– that pipes are a blocking mechanism: one does not
just write a buffer of arbitrary size in a pipe, because after something like
4KBytes, writing becomes blocking until a read happens to free some space.
That’s not a big problem: we can read and write concurrently to the pipe using
threads, and OCaml 5 makes it quite easy to do so with the <code class="hljs language-ocaml"><span class="hljs-type">Domain</span></code>
module.</p>
<pre><code class="hljs language-ocaml"><span class="hljs-keyword">let</span> gzip content =
  <span class="hljs-keyword">let</span> inc, ouc = <span class="hljs-type">Unix</span>.pipe <span class="hljs-literal">()</span> <span class="hljs-keyword">in</span>
  <span class="hljs-keyword">let</span> ouc = <span class="hljs-type">Gzip</span>.open_out_chan ~level:<span class="hljs-number">6</span> <span class="hljs-type">Unix</span>.(out_channel_of_descr ouc) <span class="hljs-keyword">in</span>
  <span class="hljs-keyword">let</span> _writer =
    <span class="hljs-type">Domain</span>.spawn (<span class="hljs-keyword">fun</span> <span class="hljs-literal">()</span> -&gt;
        <span class="hljs-type">Gzip</span>.output_substring ouc content <span class="hljs-number">0</span> <span class="hljs-type">String</span>.(length content);
        <span class="hljs-type">Gzip</span>.close_out ouc)
  <span class="hljs-keyword">in</span>
  <span class="hljs-keyword">let</span> res = <span class="hljs-type">In_channel</span>.input_all <span class="hljs-type">Unix</span>.(in_channel_of_descr inc) <span class="hljs-keyword">in</span>
  <span class="hljs-type">Unix</span>.close inc;
  res
</code></pre>
<p>We know how to decide whether to compress or not, and how to compress. The next
step is to modify <code class="hljs">make_handler</code> accordingly.</p>
<pre><code class="hljs language-patch"><span class="hljs-deletion">-let make_handler ~headers ~content path =</span>
<span class="hljs-addition">+let make_handler ~headers ~gzip_content ~content path =</span>
<span class="hljs-addition">+  let gzip_headers = ("Content-Encoding", "gzip") :: headers in</span>
   Dream.get path (fun req -&gt;
<span class="hljs-deletion">-    Lwt.return (Dream.response content)))</span>
<span class="hljs-addition">+      match Dream.headers req "Accept-Encoding" with</span>
<span class="hljs-addition">+      | accepted_encodings</span>
<span class="hljs-addition">+        when List.exists (contains ~value:"gzip") accepted_encodings -&gt;</span>
<span class="hljs-addition">+          Lwt.return @@ Dream.response ~headers:gzip_headers gzip_content</span>
<span class="hljs-addition">+      | _ -&gt; Lwt.return @@ Dream.response ~headers content)</span>
</code></pre>
<p><code class="hljs">gzip_content</code> is computed only once (using our <code class="hljs">gzip</code> function), and passed to
<code class="hljs">make_handler</code>. This way, the only computation the handler needs to do is to
“parse” <code class="hljs">Accept-Encoding</code>.</p>
<h3>Caching</h3>
<p>Compressing a page to reduce the number of bytes a browser needs to download is
fine. Letting the browser know it does not need to download anything because
it's previous version is still accurate is better.</p>
<p>This is achieved through two complementary mechanisms: <a href="https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/ETag" marked="">entity tags&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a>
(<code class="hljs language-http">ETag</code>)<label for="fn6" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-left sidenote note"><span class="footnote-p">My first encounter with entity tags was around the time GDPR was a
hot topic, because you can use them as a cheap replacement for cookies to
<a href="https://levelup.gitconnected.com/no-cookies-no-problem-using-etags-for-user-tracking-3e745544176b" marked="">track your users&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a>. I remained at the surface level at the time,
it was fun learning more about them through this little project. </span>
</span>, and <a href="https://developer.mozilla.org/fr/docs/Web/HTTP/Headers/Cache-Control" marked="">cache policies&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a> (<code class="hljs language-http">Cache-Control</code>).</p>
<p>Entity tags are used to identify a resource, and are expected to change
every time the resource is updated. The general workflow goes like this: the
first time a browser requests <code class="hljs">https://soap.coffee/~lthms/index.html</code>, it
caches the result along with the value of the <code class="hljs language-http">ETag</code> header. The next
time it needs the page, it adds the header <code class="hljs language-http">If-None-Match</code>, with the
ETag as its value. For such requests, the server is expected to return an empty
response with HTTP code 304 (<em>Not Modified</em>).</p>
<p>I decided to use the sha256 hash algorithm to compute the entity tag of each
resource of my website. The <a href="https://ocaml.org/p/sha/latest" marked="">sha&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a> OCaml library looked like a good enough
candidate.</p>
<pre><code class="hljs language-ocaml"><span class="hljs-comment">(* in `website_route` *)</span>
<span class="hljs-keyword">let</span> etag = <span class="hljs-type">Sha256</span>.(<span class="hljs-built_in">string</span> content |&gt; to_hex) <span class="hljs-keyword">in</span>
</code></pre>
<p>Interestingly, one question I had to answer was whether the entity tag of a
page needed to be different whether it was compressed or not. Internet almost
unanimously answered yes. So be it. We just need to keep in mind ETag values
are expected to be surrounded by quotes, and we are good to go. It is just a
matter of suffixing the ETag with <code class="hljs">+gzip</code> in the compressed case.</p>
<pre><code class="hljs language-patch"><span class="hljs-deletion">-let make_handler ~headers ~gzip_content ~content path =</span>
<span class="hljs-deletion">-  let gzip_headers = ("Content-Encoding", "gzip") :: headers in</span>
<span class="hljs-addition">+let make_handler ~headers ~etag ~gzip_content ~content path =</span>
<span class="hljs-addition">+  let etag_gzip = Format.sprintf "\"%s+gzip\"" etag in</span>
<span class="hljs-addition">+  let etag = Format.sprintf "\"%s\"" etag in</span>
<span class="hljs-addition">+  let gzip_headers =</span>
<span class="hljs-addition">+    ("Content-Encoding", "gzip") :: ("ETag", etag_gzip) :: headers in</span>
<span class="hljs-addition">+  let identity_headers = ("ETag", etag) :: headers in</span>
   Dream.get path (fun req -&gt;
<span class="hljs-deletion">-      match Dream.headers req "Accept-Encoding" with</span>
<span class="hljs-deletion">-      | accepted_encodings</span>
<span class="hljs-deletion">-        when List.exists (contains ~value:"gzip") accepted_encodings -&gt;</span>
<span class="hljs-deletion">-          Lwt.return @@ Dream.response ~headers:gzip_headers gzip_content</span>
<span class="hljs-deletion">-      | _ -&gt; Lwt.return @@ Dream.response ~headers content)</span>
<span class="hljs-addition">+      match Dream.headers req "If-None-Match" with</span>
<span class="hljs-addition">+      | [ previous_etag ] when previous_etag = etag || previous_etag = etag_gzip</span>
<span class="hljs-addition">+        -&gt;</span>
<span class="hljs-addition">+          Lwt.return</span>
<span class="hljs-addition">+          @@ Dream.response</span>
<span class="hljs-addition">+               ~headers:(("ETag", previous_etag) :: headers)</span>
<span class="hljs-addition">+               ~code:304 ""</span>
<span class="hljs-addition">+      | _ -&gt; (</span>
<span class="hljs-addition">+          match Dream.headers req "Accept-Encoding" with</span>
<span class="hljs-addition">+          | accepted_encodings</span>
<span class="hljs-addition">+            when List.exists (contains ~value:"gzip") accepted_encodings -&gt;</span>
<span class="hljs-addition">+              Lwt.return @@ Dream.response ~headers:gzip_headers gzip_content</span>
<span class="hljs-addition">+          | _ -&gt; Lwt.return @@ Dream.response ~headers:identity_headers content))</span>
</code></pre>
<p>Entity tags are useful, but you still need the browser to make an HTTP request
every single time you visit the website. By setting a cache policy, we can
remove even remove the need for this request most of the time. The
<code class="hljs language-http">Cache-Control</code> header is used to set a number of parameters, including
the <code class="hljs">max-age</code> value (in seconds).</p>
<p>In my Nginx configuration, I had set <code class="hljs">max-age</code> to a year for images. I did
the same thing here. Besides, I decided to set <code class="hljs">max-age</code> for other resources
to 5 minutes. This seems like a good compromise: since my website does not
change very often, it is very unlikely that you happen to visit it when I
publish new content. Setting a 5-minute cache policy should let my readers
download each resource only once, yet get the freshest version at their next
visit<label for="fn7" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-right sidenote note"><span class="footnote-p">Dealing with the <code class="hljs language-http">Cache-Control</code> header is basically the same
exercise as setting the correct <code class="hljs language-http">Content-Type</code> header, and this
article is already long enough, which is why there is no diff or snippet in
this section. </span>
</span>.</p>
<p>And with this, we are done. We get a standalone library to server our website
in a browser-friendly manner, which I can theoretically use to replace my
current Nginx-powered setup. Although… is it <em>that</em> simple?</p>
<h2>Building and Deploying the Website</h2>
<p>Files are quite easy to share and deploy. As I mentioned earlier in this
article, you just need to <code class="hljs language-bash">rsync</code> them and be done with it. <em>Binaries</em>,
on the other hand… One cannot just assume a binary build on a machine X will
work on another machine Y. Some additional works need to be done.</p>
<p>The most straightforward solution I know is to rely on static binaries. <a href="https://soap.coffee/~lthms/posts/%5BOCamlStaticBinaries.html%5D" marked="">I have
already written about how to generate static binaries for OCaml
projects</a>, so I had a pretty strong head start, but one drawback of the
approach I’ve described there (and that I have been using for <a href="https://github.com/lthms/spatial-shell/releases" marked="">Spatial Shell’s
releases&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#github"></use></svg></span></a><label for="fn8" class="sidenote-number margin-toggle"></label><input type="checkbox" class="margin-toggle"><span class="note-left sidenote note"><span class="footnote-p">Not that there were many of them lately. </span>
</span>) is that it is rather slow (I have a script creating
a new local switch each time) and requires static libraries to be installed
(which Arch Linux does not provide).</p>
<p>And so, I figured, why not build the static binary in Docker? This allows me to
use Alpine to get a static version of my system dependencies, and can be quite
fast thanks to <a href="https://docs.docker.com/build/cache/" marked="">Docker build cache&nbsp;<span class="icon"><svg><use href="/~lthms/img/icons.svg#external-link"></use></svg></span></a>. The Dockerfile is quite simple:
one stage for building the system and OCaml dependencies, and one stage for
building the static binary.</p>
<pre><code class="hljs language-dockerfile"><span class="hljs-keyword">FROM</span> alpine:<span class="hljs-number">3.21</span> AS build_environment

<span class="hljs-comment"># Use alpine /bin/ash and set shell options</span>
<span class="hljs-comment"># See https://docs.docker.com/build/building/best-practices/#using-pipes</span>
<span class="hljs-keyword">SHELL</span><span class="language-bash"> [<span class="hljs-string">"/bin/ash"</span>, <span class="hljs-string">"-euo"</span>, <span class="hljs-string">"pipefail"</span>, <span class="hljs-string">"-c"</span>]</span>

<span class="hljs-keyword">USER</span> root
<span class="hljs-keyword">WORKDIR</span><span class="language-bash"> /root</span>

<span class="hljs-keyword">RUN</span><span class="language-bash"> apk add autoconf automake bash build-base ca-certificates opam gcc \ </span>
  git rsync gmp-dev libev-dev openssl-libs-static pkgconf zlib-static \
  openssl-dev zlib-dev
<span class="hljs-keyword">RUN</span><span class="language-bash"> opam init --bare --<span class="hljs-built_in">yes</span> --disable-sandboxing</span>
<span class="hljs-keyword">COPY</span><span class="language-bash"> makefile dune-project .</span>
<span class="hljs-keyword">RUN</span><span class="language-bash"> make _opam/.init OCAML=<span class="hljs-string">"ocaml-option-static,ocaml-option-no-compression,ocaml.5.2.1"</span></span>
<span class="hljs-keyword">RUN</span><span class="language-bash"> <span class="hljs-built_in">eval</span> $(opam <span class="hljs-built_in">env</span>) &amp;&amp; make server-deps</span>

<span class="hljs-keyword">FROM</span> build_environment AS builder

<span class="hljs-keyword">COPY</span><span class="language-bash"> server ./server</span>
<span class="hljs-keyword">COPY</span><span class="language-bash"> out ./out</span>
<span class="hljs-keyword">COPY</span><span class="language-bash"> dune .</span>
<span class="hljs-keyword">RUN</span><span class="language-bash"> <span class="hljs-built_in">eval</span> $(opam <span class="hljs-built_in">env</span>) &amp;&amp; dune build server/main.exe --profile=static</span>

<span class="hljs-keyword">FROM</span> alpine:<span class="hljs-number">3.21</span> AS soap.coffee

<span class="hljs-keyword">COPY</span><span class="language-bash"> --from=builder /root/_build/default/server/main.exe /bin/soap.coffee</span>
</code></pre>
<p>Then, building my static binary becomes as simple as:</p>
<pre><code class="hljs language-bash">docker build . -f ./build.Dockerfile \
  --target soap.coffee \
  -t soap.coffee:latest
docker create --name soap-coffee-build soap.coffee:latest
docker <span class="hljs-built_in">cp</span> soap-coffee-build:/bin/soap.coffee .
docker <span class="hljs-built_in">rm</span> -f soap-coffee-build
</code></pre>
<p><code class="hljs language-bash">docker <span class="hljs-built_in">cp</span></code> does not work on an image, but on a container, so we need to
create one which can be destroyed shortly after.</p>
<p>This little binary weights 38MBytes, which seems relatively reasonable to me,
considering my website weights 20MBytes. I guess it could be easy to reduce
this size by embedding the compressed version of my articles and images,
instead of the uncompressed one. But really, for my website, I’m not really
interested in investing the extra effort.</p>
<h2>Conclusion</h2>
<p>I would not recommend anyone to use this in production for anything remotely
important, but from my perspective, it was both fun and insightful. I was able
to refresh my memories about HTTP “internal,” among other things.&nbsp;Again, as
far as I can tell, deploying my website this way did not bring me any benefit,
performance-wise; even worse, I am pretty sure the Dream server will not behave
as well as Nginx when it comes to handling the load (since it is limited to one
core, instead of several with Nginx).</p>
<p>That being said, I am way too invested now… which is why, yes, you are
reading a blog post served to you directly from memory 🎉.</p>
        
      
