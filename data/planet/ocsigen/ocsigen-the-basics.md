---
title: Ocsigen, the basics
description:
url: https://ocsigen.github.io/blog/2016/02/08/tutorial-basics/
date: 2016-02-08T00:00:00-00:00
preview_image:
featured:
authors:
- Vincent Balat
---

<p>Following last week release,
I&rsquo;m starting today a series of tutorials about the Ocsigen framework. For the impatient, most of these tutorials are already available on <a href="http://ocsigen.org/tuto">Ocsigen</a>&rsquo;s Web site.</p>

<p>In this first tutorial, we show how to use the Ocsigen framework (mainly Eliom) to write a lightweight Web site by generating pages using OCaml functions.
Even though Eliom makes it possible to write complete client-server Web and mobile apps,
you can still use Eliom even if you don&rsquo;t need all these features (for example if you don&rsquo;t want HTML type checking or client side features). Besides, this will allow you to extend your Web site in a full Web application if you need, later on. This tutorial is also a good overview of the basics of Eliom.</p>

<h2>A service generating a page</h2>

<p>The following code shows how to create a service that answers requests at URL <code class="language-plaintext highlighter-rouge">http://.../aaa/bbb</code>, by invoking an Ocaml function <code class="language-plaintext highlighter-rouge">f</code> of type:</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="n">f</span> <span class="o">:</span> <span class="p">(</span><span class="kt">string</span> <span class="o">*</span> <span class="kt">string</span><span class="p">)</span> <span class="kt">list</span> <span class="o">-&gt;</span> <span class="kt">unit</span> <span class="o">-&gt;</span> <span class="kt">string</span> <span class="nn">Lwt</span><span class="p">.</span><span class="n">t</span></code></pre></figure>

<p>Function <code class="language-plaintext highlighter-rouge">f</code> generates HTML as a string, taking as argument the list of URL parameters (GET parameters).</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="k">let</span> <span class="n">f</span> <span class="n">_</span> <span class="bp">()</span> <span class="o">=</span>
  <span class="nn">Lwt</span><span class="p">.</span><span class="n">return</span> <span class="s2">&quot;&lt;html&gt;&lt;head&gt;&lt;title&gt;A&lt;/title&gt;&lt;/head&gt;&lt;body&gt;B&lt;/body&gt;&lt;/html&gt;&quot;</span>

<span class="k">let</span> <span class="n">main_service</span> <span class="o">=</span>
  <span class="nn">Eliom_registration</span><span class="p">.</span><span class="nn">Html_text</span><span class="p">.</span><span class="n">register_service</span>
    <span class="o">~</span><span class="n">path</span><span class="o">:</span><span class="p">[</span><span class="s2">&quot;aaa&quot;</span><span class="p">;</span> <span class="s2">&quot;bbb&quot;</span><span class="p">]</span>
    <span class="o">~</span><span class="n">get_params</span><span class="o">:</span><span class="nn">Eliom_parameter</span><span class="p">.</span><span class="n">any</span>
    <span class="n">f</span></code></pre></figure>

<p><code class="language-plaintext highlighter-rouge">Eliom_paramer.any</code> means that the service takes any GET parameter.</p>

<p>We recommend to use the program eliom-distillery to generate a template for your application (a Makefile and a default configuration file for Ocsigen Server).</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>$ eliom-distillery -name mysite -template basic.ppx -target-directory mysite
</code></pre></div></div>
<p>Put the piece of code above in file mysite.eliom, compile and run the server by doing:</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>$ make test.byte
</code></pre></div></div>
<p>Your page is now available at URL http://localhost:8080/aaa/bbb.</p>

<p>If you dont want to use the Makefile provided by eliom-distillery, just replace mysite.eliom by a file mysite.ml, compile and run with</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>$ ocamlfind ocamlc -package eliom.server -thread -c mysite.ml
$ ocsigenserver -c mysite.conf
</code></pre></div></div>
<p>where <code class="language-plaintext highlighter-rouge">mysite.conf</code> is adapted from <code class="language-plaintext highlighter-rouge">local/etc/mysite/mysite-test.conf</code> by replacing <code class="language-plaintext highlighter-rouge">mysite.cma</code> by your cmo.</p>

<h2>POST service</h2>

<p>Services using the POST HTTP method are created using the function <code class="language-plaintext highlighter-rouge">Eliom_service.&#8203;Http.&#8203;post_service</code>. To create a service with POST parameters, first you must create a service without POST parameters, and then the service with POST parameters, with the first service as fallback. The fallback is used if the user comes back later without POST parameters, for example because he put a bookmark on this URL.</p>

<figure class="highlight"><pre><code class="language-ocaml" data-lang="ocaml"><span class="k">let</span> <span class="n">g</span> <span class="n">getp</span> <span class="n">postp</span> <span class="o">=</span> <span class="nn">Lwt</span><span class="p">.</span><span class="n">return</span> <span class="s2">&quot;...&quot;</span>

<span class="k">let</span> <span class="n">post_service</span> <span class="o">=</span>
  <span class="nn">Eliom_registration</span><span class="p">.</span><span class="nn">Html_text</span><span class="p">.</span><span class="n">register_post_service</span>
    <span class="o">~</span><span class="n">fallback</span><span class="o">:</span><span class="n">main_service</span>
    <span class="o">~</span><span class="n">post_params</span><span class="o">:</span><span class="nn">Eliom_parameter</span><span class="p">.</span><span class="n">any</span>
    <span class="n">g</span></code></pre></figure>

<h2>Going further</h2>

<p>That is probably all you need for a very basic Web site in OCaml.
But Ocsigen provides many tools to write more advanced Web sites
and applications:</p>

<p>Instead of generating HTML in OCaml strings, we highly recommend to use
<em>typed HTML</em>. It is very easy to use, once you have learned the basics,
and helps a lot to efficiently write modular and valid HTML.
To do this, use module
<a href="http://ocsigen.org/eliom/api/server/Eliom_registration.Html5"><code class="language-plaintext highlighter-rouge">Eliom_registration.Html5</code></a>
instead of
<a href="http://ocsigen.org/eliom/api/server/Eliom_registration.Html_text"><code class="language-plaintext highlighter-rouge">Eliom_registration.Html_text</code></a>.
See this
<a href="http://ocsigen.org/tuto/manual/application#tyxml">tutorial</a>
for more information, a comprehensive documentation
<a href="http://ocsigen.org/tyxml/manual/">here</a>,
and a more advanced manual
<a href="http://ocsigen.org/eliom/manual/clientserver-html">here</a>.</p>

<p>Have a look at Eliom&rsquo;s API documentation to see other kinds of services,
for example <a href="http://ocsigen.org/eliom/api/server/Eliom_registration.Redirection"><code class="language-plaintext highlighter-rouge">Eliom_registration.Redirection</code></a>
to create HTTP redirections.</p>

<p>Eliom also has a way to typecheck forms and GET or POST parameters.
By giving a description of the parameters your service expects,
Eliom will check their presence automatically, and convert them
for you to OCaml types.
See
<a href="http://ocsigen.org/tuto/manual/interaction">this tutorial</a>
and <a href="http://ocsigen.org/eliom/manual/server-params">this manual page</a>.</p>

<p>Eliom also has other ways to identify services (besides just the PATH
in the URL). For example Eliom can identify a service just by a parameter
(whatever the path is). This is called <em>non-attached coservices</em> and
this makes it possible for instance to have the same feature on every page
(for example a connection service).
See
<a href="http://ocsigen.org/tuto/manual/interaction">this tutorial</a>
and <a href="http://ocsigen.org/eliom/manual/server-services">this manual page</a>.</p>

<p>One of the main features of Eliom is the ability to write complete
Web and mobile applications in OCaml. Annotations are used to
separate the code to be executed server-side from the client code.
Client functions are translated into Javascript using
<a href="http://ocsigen.org/js_of_ocaml/">Ocsigen Js_of_ocaml</a>.
See
<a href="http://ocsigen.org/tuto/manual/tutowidgets">this tutorial</a> for
a quick introduction,
or <a href="http://ocsigen.org/tuto/manual/application">this one</a> for a
more comprehensive one.
You can also have a look at
<a href="http://ocsigen.org/eliom/manual/clientserver-applications">this manual page</a>.</p>

<p>Another interesting feature of Eliom is its session model, that uses a
very simple interface to record session data server-side.
It is even possible to choose
the <em>scope</em> of this data: either a browser, or a tab, or even a group
of browsers (belonging for instance to a same user).
See
<a href="http://ocsigen.org/tuto/manual/interaction#eref">this section</a>
and the beginning of
<a href="http://ocsigen.org/eliom/manual/server-state">this manual page</a>.</p>

<p>We suggest to continue your reading by one of these tutorials:</p>

<ul>
  <li><a href="http://ocsigen.org/tuto/manual/tutowidgets">A quick start tutorial for client-server Eliom applications</a> (for the people already familiar with OCaml, Lwt, etc.)</li>
  <li><a href="http://ocsigen.org/tuto/manual/application">A step by step tutorial for client-server Eliom applications</a></li>
  <li><a href="http://ocsigen.org/tuto/manual/interaction">A tutorial on server side dynamic Web site</a></li>
</ul>


