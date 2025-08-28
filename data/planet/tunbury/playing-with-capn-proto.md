---
title: "Playing with Cap\u2019n Proto"
description: "Cap\u2019n Proto has become a hot topic recently and while this is used
  for many OCaml-CI services, I spent some time creating a minimal application."
url: https://www.tunbury.org/2025/03/17/capnproto/
date: 2025-03-17T00:00:00-00:00
preview_image: https://www.tunbury.org/images/capnproto-logo.png
authors:
- Mark Elvers
source:
ignore:
---

<p>Cap’n Proto has become a hot topic recently and while this is used for many OCaml-CI services, I spent some time creating a minimal application.</p>

<p>Firstly create a schema with a single interface whch accepts a file name and returns the content.</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>interface Foo {
  get      @0 (name :Text) -&gt; (reply :Text);
}
</code></pre></div></div>

<p>This schema can then be compiled into the bindings for your required language. e.g. <code class="language-plaintext highlighter-rouge">capnp compile -o ocaml:. schema.capnp</code></p>

<p>In practice this need not be done by hand as we can use a <code class="language-plaintext highlighter-rouge">dune</code> rule to do this.</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>(rule
 (targets foo_api.ml foo_api.mli)
 (deps    foo_api.capnp)
 (action (run capnp compile -o %{bin:capnpc-ocaml} %{deps})))
</code></pre></div></div>

<p>On the server side we now need to extend the automatically generate code to actually implement the interface.  This code is largely boilerplate.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">module</span> <span class="nc">Api</span> <span class="o">=</span> <span class="nn">Foo_api</span><span class="p">.</span><span class="nc">MakeRPC</span><span class="p">(</span><span class="nc">Capnp_rpc</span><span class="p">)</span>

<span class="k">open</span> <span class="nn">Capnp_rpc</span><span class="p">.</span><span class="nc">Std</span>

<span class="k">let</span> <span class="n">read_from_file</span> <span class="n">filename</span> <span class="o">=</span> <span class="nn">In_channel</span><span class="p">.</span><span class="n">with_open_text</span> <span class="n">filename</span> <span class="o">@@</span> <span class="k">fun</span> <span class="n">ic</span> <span class="o">-&gt;</span> <span class="nn">In_channel</span><span class="p">.</span><span class="n">input_all</span> <span class="n">ic</span>

<span class="k">let</span> <span class="n">local</span> <span class="o">=</span>
  <span class="k">let</span> <span class="k">module</span> <span class="nc">Foo</span> <span class="o">=</span> <span class="nn">Api</span><span class="p">.</span><span class="nn">Service</span><span class="p">.</span><span class="nc">Foo</span> <span class="k">in</span>
  <span class="nn">Foo</span><span class="p">.</span><span class="n">local</span> <span class="o">@@</span> <span class="k">object</span>
    <span class="k">inherit</span> <span class="nn">Foo</span><span class="p">.</span><span class="n">service</span>

    <span class="n">method</span> <span class="n">get_impl</span> <span class="n">params</span> <span class="n">release_param_caps</span> <span class="o">=</span>
      <span class="k">let</span> <span class="k">open</span> <span class="nn">Foo</span><span class="p">.</span><span class="nc">Get</span> <span class="k">in</span>
      <span class="k">let</span> <span class="n">name</span> <span class="o">=</span> <span class="nn">Params</span><span class="p">.</span><span class="n">name_get</span> <span class="n">params</span> <span class="k">in</span>
      <span class="n">release_param_caps</span> <span class="bp">()</span><span class="p">;</span>
      <span class="k">let</span> <span class="n">response</span><span class="o">,</span> <span class="n">results</span> <span class="o">=</span> <span class="nn">Service</span><span class="p">.</span><span class="nn">Response</span><span class="p">.</span><span class="n">create</span> <span class="nn">Results</span><span class="p">.</span><span class="n">init_pointer</span> <span class="k">in</span>
      <span class="nn">Results</span><span class="p">.</span><span class="n">reply_set</span> <span class="n">results</span> <span class="p">(</span><span class="n">read_from_file</span> <span class="n">name</span><span class="p">);</span>
      <span class="nn">Service</span><span class="p">.</span><span class="n">return</span> <span class="n">response</span>
  <span class="k">end</span>
</code></pre></div></div>

<p>The server needs to generate the capability file needed to access the service and wait for incoming connections.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">cap_file</span> <span class="o">=</span> <span class="s2">"echo.cap"</span>

<span class="k">let</span> <span class="n">serve</span> <span class="n">config</span> <span class="o">=</span>
  <span class="nn">Switch</span><span class="p">.</span><span class="n">run</span> <span class="o">@@</span> <span class="k">fun</span> <span class="n">sw</span> <span class="o">-&gt;</span>
  <span class="k">let</span> <span class="n">service_id</span> <span class="o">=</span> <span class="nn">Capnp_rpc_unix</span><span class="p">.</span><span class="nn">Vat_config</span><span class="p">.</span><span class="n">derived_id</span> <span class="n">config</span> <span class="s2">"main"</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">restore</span> <span class="o">=</span> <span class="nn">Restorer</span><span class="p">.</span><span class="n">single</span> <span class="n">service_id</span> <span class="p">(</span><span class="nn">Foo</span><span class="p">.</span><span class="n">local</span><span class="p">)</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">vat</span> <span class="o">=</span> <span class="nn">Capnp_rpc_unix</span><span class="p">.</span><span class="n">serve</span> <span class="o">~</span><span class="n">sw</span> <span class="o">~</span><span class="n">restore</span> <span class="n">config</span> <span class="k">in</span>
  <span class="k">match</span> <span class="nn">Capnp_rpc_unix</span><span class="p">.</span><span class="nn">Cap_file</span><span class="p">.</span><span class="n">save_service</span> <span class="n">vat</span> <span class="n">service_id</span> <span class="n">cap_file</span> <span class="k">with</span>
  <span class="o">|</span> <span class="nc">Error</span> <span class="nt">`Msg</span> <span class="n">m</span> <span class="o">-&gt;</span> <span class="n">failwith</span> <span class="n">m</span>
  <span class="o">|</span> <span class="nc">Ok</span> <span class="bp">()</span> <span class="o">-&gt;</span>
    <span class="n">traceln</span> <span class="s2">"Server running. Connect using %S."</span> <span class="n">cap_file</span><span class="p">;</span>
    <span class="nn">Fiber</span><span class="p">.</span><span class="n">await_cancel</span> <span class="bp">()</span>
</code></pre></div></div>

<p>The client application imports the capability file and calls the service <code class="language-plaintext highlighter-rouge">Foo.get</code>.</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">let</span> <span class="n">run_client</span> <span class="n">service</span> <span class="o">=</span>
  <span class="k">let</span> <span class="n">x</span> <span class="o">=</span> <span class="nn">Foo</span><span class="p">.</span><span class="n">get</span> <span class="n">service</span> <span class="s2">"client.ml"</span> <span class="k">in</span>
  <span class="n">traceln</span> <span class="s2">"%S"</span> <span class="n">x</span>

<span class="k">let</span> <span class="n">connect</span> <span class="n">net</span> <span class="n">uri</span> <span class="o">=</span>
  <span class="nn">Switch</span><span class="p">.</span><span class="n">run</span> <span class="o">@@</span> <span class="k">fun</span> <span class="n">sw</span> <span class="o">-&gt;</span>
  <span class="k">let</span> <span class="n">client_vat</span> <span class="o">=</span> <span class="nn">Capnp_rpc_unix</span><span class="p">.</span><span class="n">client_only_vat</span> <span class="o">~</span><span class="n">sw</span> <span class="n">net</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">sr</span> <span class="o">=</span> <span class="nn">Capnp_rpc_unix</span><span class="p">.</span><span class="nn">Vat</span><span class="p">.</span><span class="n">import_exn</span> <span class="n">client_vat</span> <span class="n">uri</span> <span class="k">in</span>
  <span class="nn">Capnp_rpc_unix</span><span class="p">.</span><span class="n">with_cap_exn</span> <span class="n">sr</span> <span class="n">run_client</span>
</code></pre></div></div>

<p>Where <code class="language-plaintext highlighter-rouge">Foo.get</code> is defined like this</p>

<div class="language-ocaml highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="k">module</span> <span class="nc">Foo</span> <span class="o">=</span> <span class="nn">Api</span><span class="p">.</span><span class="nn">Client</span><span class="p">.</span><span class="nc">Foo</span>

<span class="k">let</span> <span class="n">get</span> <span class="n">t</span> <span class="n">name</span> <span class="o">=</span>
  <span class="k">let</span> <span class="k">open</span> <span class="nn">Foo</span><span class="p">.</span><span class="nc">Get</span> <span class="k">in</span>
  <span class="k">let</span> <span class="n">request</span><span class="o">,</span> <span class="n">params</span> <span class="o">=</span> <span class="nn">Capability</span><span class="p">.</span><span class="nn">Request</span><span class="p">.</span><span class="n">create</span> <span class="nn">Params</span><span class="p">.</span><span class="n">init_pointer</span> <span class="k">in</span>
  <span class="nn">Params</span><span class="p">.</span><span class="n">name_set</span> <span class="n">params</span> <span class="n">name</span><span class="p">;</span>
  <span class="nn">Capability</span><span class="p">.</span><span class="n">call_for_value_exn</span> <span class="n">t</span> <span class="n">method_id</span> <span class="n">request</span> <span class="o">|&gt;</span> <span class="nn">Results</span><span class="p">.</span><span class="n">reply_get</span>
</code></pre></div></div>

<p>Run the server application passing it parameters of where to save the private key and which interface/port to listen on.</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="nv">$ </span>dune <span class="nb">exec</span> <span class="nt">--</span> ./server.exe <span class="nt">--capnp-secret-key-file</span> ./server.pem <span class="nt">--capnp-listen-address</span> tcp:127.0.0.1:7000
+Server running. Connect using <span class="s2">"echo.cap"</span><span class="nb">.</span>
</code></pre></div></div>

<p>The <code class="language-plaintext highlighter-rouge">.cap</code> looks like this</p>

<div class="language-plaintext highlighter-rouge"><div class="highlight"><pre class="highlight"><code>capnp://sha-256:f5BAo2n_2gVxUdkyzYsIuitpA1YT_7xFg31FIdNKVls@127.0.0.1:7000/6v45oIvGQ6noMaLOh5GHAJnGJPWEO5A3Qkt0Egke4Ic
</code></pre></div></div>

<p>In another window, invoke the client.</p>

<div class="language-sh highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="nv">$ </span>dune <span class="nb">exec</span> <span class="nt">--</span> ./client.exe ./echo.cap
</code></pre></div></div>

<p>The full code is available on <a href="https://github.com/mtelvers/capnp-minimum">Github</a>.</p>
