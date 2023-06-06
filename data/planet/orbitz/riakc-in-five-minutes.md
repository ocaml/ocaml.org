---
title: Riakc In Five Minutes
description: This is a simple example using Riakc to PUT a key into a Riak database.  It
  assumes that you already have a Riak database up and running.  ...
url: http://functional-orbitz.blogspot.com/2013/07/riakc-in-five-minutes.html
date: 2013-07-04T17:01:00-00:00
preview_image:
featured:
authors:
- orbitz
---

<p>
This is a simple example using Riakc to PUT a key into a Riak database.  It assumes that you already have a Riak database up and running.
</p>

<p>
First you need to install riakc.  Simply do: <code>opam install riakc</code>.  As of this writing, the latest version of riakc is 2.0.0 and the code given depends on that version.
</p>

<p>
Now, the code.  The following is a complete CLI tool that will PUT a key and print back the result from Riak.  It handles all errors that the library can generate as well as outputting siblings correctly.
</p>

<pre><code><i><font color="#9A1900">(*</font></i>
<i><font color="#9A1900"> * This example is valid for version 2.0.0, and possibly later</font></i>
<i><font color="#9A1900"> *)</font></i>
<b><font color="#000080">open</font></b> <b><font color="#000080">Core</font></b><font color="#990000">.</font><font color="#009900">Std</font>
<b><font color="#000080">open</font></b> <b><font color="#000080">Async</font></b><font color="#990000">.</font><font color="#009900">Std</font>

<i><font color="#9A1900">(*</font></i>
<i><font color="#9A1900"> * Take a string of bytes and convert them to hex string</font></i>
<i><font color="#9A1900"> * representation</font></i>
<i><font color="#9A1900"> *)</font></i>
<b><font color="#0000FF">let</font></b> hex_of_string <font color="#990000">=</font>
  <b><font color="#000080">String</font></b><font color="#990000">.</font>concat_map <font color="#990000">~</font>f<font color="#990000">:(</font><b><font color="#0000FF">fun</font></b> c <font color="#990000">-&gt;</font> sprintf <font color="#FF0000">&quot;%X&quot;</font> <font color="#990000">(</font><b><font color="#000080">Char</font></b><font color="#990000">.</font>to_int c<font color="#990000">))</font>

<i><font color="#9A1900">(*</font></i>
<i><font color="#9A1900"> * An Robj can have multiple values in it, each one with its</font></i>
<i><font color="#9A1900"> * own content type, encoding, and value.  This just prints</font></i>
<i><font color="#9A1900"> * the value, which is a string blob</font></i>
<i><font color="#9A1900"> *)</font></i>
<b><font color="#0000FF">let</font></b> print_contents contents <font color="#990000">=</font>
  <b><font color="#000080">List</font></b><font color="#990000">.</font>iter
    <font color="#990000">~</font>f<font color="#990000">:(</font><b><font color="#0000FF">fun</font></b> content <font color="#990000">-&gt;</font>
      <b><font color="#0000FF">let</font></b> <b><font color="#0000FF">module</font></b> <font color="#009900">C</font> <font color="#990000">=</font> <b><font color="#000080">Riakc</font></b><font color="#990000">.</font><b><font color="#000080">Robj</font></b><font color="#990000">.</font><font color="#009900">Content</font> <b><font color="#0000FF">in</font></b>
      printf <font color="#FF0000">&quot;VALUE: %s\n&quot;</font> <font color="#990000">(</font><b><font color="#000080">C</font></b><font color="#990000">.</font>value content<font color="#990000">))</font>
    contents

<b><font color="#0000FF">let</font></b> fail s <font color="#990000">=</font>
  printf <font color="#FF0000">&quot;%s\n&quot;</font> s<font color="#990000">;</font>
  shutdown <font color="#993399">1</font>

<b><font color="#0000FF">let</font></b> exec <font color="#990000">()</font> <font color="#990000">=</font>
  <b><font color="#0000FF">let</font></b> host <font color="#990000">=</font> <b><font color="#000080">Sys</font></b><font color="#990000">.</font>argv<font color="#990000">.(</font><font color="#993399">1</font><font color="#990000">)</font> <b><font color="#0000FF">in</font></b>
  <b><font color="#0000FF">let</font></b> port <font color="#990000">=</font> <b><font color="#000080">Int</font></b><font color="#990000">.</font>of_string <b><font color="#000080">Sys</font></b><font color="#990000">.</font>argv<font color="#990000">.(</font><font color="#993399">2</font><font color="#990000">)</font> <b><font color="#0000FF">in</font></b>
  <i><font color="#9A1900">(*</font></i>
<i><font color="#9A1900">   * [with_conn] is a little helper function that will</font></i>
<i><font color="#9A1900">   * establish a connection, run a function on the connection</font></i>
<i><font color="#9A1900">   * and tear it down when done</font></i>
<i><font color="#9A1900">   *)</font></i>
  <b><font color="#000080">Riakc</font></b><font color="#990000">.</font><b><font color="#000080">Conn</font></b><font color="#990000">.</font>with_conn
    <font color="#990000">~</font>host
    <font color="#990000">~</font>port
    <font color="#990000">(</font><b><font color="#0000FF">fun</font></b> c <font color="#990000">-&gt;</font>
      <b><font color="#0000FF">let</font></b> <b><font color="#0000FF">module</font></b> <font color="#009900">R</font> <font color="#990000">=</font> <b><font color="#000080">Riakc</font></b><font color="#990000">.</font><font color="#009900">Robj</font> <b><font color="#0000FF">in</font></b>
      <b><font color="#0000FF">let</font></b> content  <font color="#990000">=</font> <b><font color="#000080">R</font></b><font color="#990000">.</font><b><font color="#000080">Content</font></b><font color="#990000">.</font>create <font color="#FF0000">&quot;some random data&quot;</font> <b><font color="#0000FF">in</font></b>
      <b><font color="#0000FF">let</font></b> robj     <font color="#990000">=</font> <b><font color="#000080">R</font></b><font color="#990000">.</font>create <font color="#990000">[]</font> <font color="#990000">|&gt;</font> <b><font color="#000080">R</font></b><font color="#990000">.</font>set_content content <b><font color="#0000FF">in</font></b>
      <i><font color="#9A1900">(*</font></i>
<i><font color="#9A1900">       * Put takes a bucket, a key, and an optional list of</font></i>
<i><font color="#9A1900">       * options.  In this case we are setting the</font></i>
<i><font color="#9A1900">       * [Return_body] option which returns what the key</font></i>
<i><font color="#9A1900">       * looks like after the put.  It is possible that</font></i>
<i><font color="#9A1900">       * siblings were created.</font></i>
<i><font color="#9A1900">       *)</font></i>
      <b><font color="#000080">Riakc</font></b><font color="#990000">.</font><b><font color="#000080">Conn</font></b><font color="#990000">.</font>put
        c
        <font color="#990000">~</font>b<font color="#990000">:</font><font color="#FF0000">&quot;test_bucket&quot;</font>
        <font color="#990000">~</font>k<font color="#990000">:</font><font color="#FF0000">&quot;test_key&quot;</font>
        <font color="#990000">~</font>opts<font color="#990000">:[</font><b><font color="#000080">Riakc</font></b><font color="#990000">.</font><b><font color="#000080">Opts</font></b><font color="#990000">.</font><b><font color="#000080">Put</font></b><font color="#990000">.</font><font color="#009900">Return_body</font><font color="#990000">]</font>
        robj<font color="#990000">)</font>

<b><font color="#0000FF">let</font></b> eval <font color="#990000">()</font> <font color="#990000">=</font>
  exec <font color="#990000">()</font> <font color="#990000">&gt;&gt;|</font> <b><font color="#0000FF">function</font></b>
    <font color="#990000">|</font> <font color="#009900">Ok</font> <font color="#990000">(</font>robj<font color="#990000">,</font> key<font color="#990000">)</font> <font color="#990000">-&gt;</font> <b><font color="#0000FF">begin</font></b>
      <i><font color="#9A1900">(*</font></i>
<i><font color="#9A1900">       * [put] returns a [Riakc.Robj.t] and a [string</font></i>
<i><font color="#9A1900">       * option], which is the key if Riak had to generate</font></i>
<i><font color="#9A1900">       * it</font></i>
<i><font color="#9A1900">       *)</font></i>
      <b><font color="#0000FF">let</font></b> <b><font color="#0000FF">module</font></b> <font color="#009900">R</font> <font color="#990000">=</font> <b><font color="#000080">Riakc</font></b><font color="#990000">.</font><font color="#009900">Robj</font> <b><font color="#0000FF">in</font></b>
      <i><font color="#9A1900">(*</font></i>
<i><font color="#9A1900">       * Extract the vclock, if it exists, and convert it to</font></i>
<i><font color="#9A1900">       * to something printable</font></i>
<i><font color="#9A1900">       *)</font></i>
      <b><font color="#0000FF">let</font></b> vclock <font color="#990000">=</font>
 <b><font color="#000080">Option</font></b><font color="#990000">.</font>value
   <font color="#990000">~</font>default<font color="#990000">:</font><font color="#FF0000">&quot;&lt;none&gt;&quot;</font>
   <font color="#990000">(</font><b><font color="#000080">Option</font></b><font color="#990000">.</font>map <font color="#990000">~</font>f<font color="#990000">:</font>hex_of_string <font color="#990000">(</font><b><font color="#000080">R</font></b><font color="#990000">.</font>vclock robj<font color="#990000">))</font>
      <b><font color="#0000FF">in</font></b>
      <b><font color="#0000FF">let</font></b> key <font color="#990000">=</font> <b><font color="#000080">Option</font></b><font color="#990000">.</font>value <font color="#990000">~</font>default<font color="#990000">:</font><font color="#FF0000">&quot;&lt;none&gt;&quot;</font> key <b><font color="#0000FF">in</font></b>
      printf <font color="#FF0000">&quot;KEY: %s\n&quot;</font> key<font color="#990000">;</font>
      printf <font color="#FF0000">&quot;VCLOCK: %s\n&quot;</font> vclock<font color="#990000">;</font>
      print_contents <font color="#990000">(</font><b><font color="#000080">R</font></b><font color="#990000">.</font>contents robj<font color="#990000">);</font>
      shutdown <font color="#993399">0</font>
    <b><font color="#0000FF">end</font></b>
    <i><font color="#9A1900">(*</font></i>
<i><font color="#9A1900">     * These are the various errors that can be returned.</font></i>
<i><font color="#9A1900">     * Many of then come directly from the ProtoBuf layer</font></i>
<i><font color="#9A1900">     * since there aren't really any more semantics to apply</font></i>
<i><font color="#9A1900">     * to the data if it matches the PB frame.</font></i>
<i><font color="#9A1900">     *)</font></i>
    <font color="#990000">|</font> <font color="#009900">Error</font> `<font color="#009900">Bad_conn</font>           <font color="#990000">-&gt;</font> fail <font color="#FF0000">&quot;Bad_conn&quot;</font>
    <font color="#990000">|</font> <font color="#009900">Error</font> `<font color="#009900">Bad_payload</font>        <font color="#990000">-&gt;</font> fail <font color="#FF0000">&quot;Bad_payload&quot;</font>
    <font color="#990000">|</font> <font color="#009900">Error</font> `<font color="#009900">Incomplete_payload</font> <font color="#990000">-&gt;</font> fail <font color="#FF0000">&quot;Incomplete_payload&quot;</font>
    <font color="#990000">|</font> <font color="#009900">Error</font> `<font color="#009900">Notfound</font>           <font color="#990000">-&gt;</font> fail <font color="#FF0000">&quot;Notfound&quot;</font>
    <font color="#990000">|</font> <font color="#009900">Error</font> `<font color="#009900">Incomplete</font>         <font color="#990000">-&gt;</font> fail <font color="#FF0000">&quot;Incomplete&quot;</font>
    <font color="#990000">|</font> <font color="#009900">Error</font> `<font color="#009900">Overflow</font>           <font color="#990000">-&gt;</font> fail <font color="#FF0000">&quot;Overflow&quot;</font>
    <font color="#990000">|</font> <font color="#009900">Error</font> `<font color="#009900">Unknown_type</font>       <font color="#990000">-&gt;</font> fail <font color="#FF0000">&quot;Unknown_type&quot;</font>
    <font color="#990000">|</font> <font color="#009900">Error</font> `<font color="#009900">Wrong_type</font>         <font color="#990000">-&gt;</font> fail <font color="#FF0000">&quot;Wrong_type&quot;</font>

<b><font color="#0000FF">let</font></b> <font color="#990000">()</font> <font color="#990000">=</font>
  ignore <font color="#990000">(</font>eval <font color="#990000">());</font>
  never_returns <font color="#990000">(</font><b><font color="#000080">Scheduler</font></b><font color="#990000">.</font>go <font color="#990000">())</font>
</code></pre>


<p>
Now compile it:
</p>

<pre><code>ocamlfind ocamlopt -thread -I +camlp4 -package riakc -c demo.ml
ocamlfind ocamlopt -package riakc -thread -linkpkg \
-o demo.native demo.cmx
</code></pre>

<p>
Finally, you can run it: <code>./demo.native <i>hostname</i> <i>port</i></code>
</p>

<h1>...And More Detail</h1>
<p>
The API for Riakc is broken up into two modules: <code>Riakc.Robj</code> and <code>Riakc.Conn</code> with <code>Riakc.Opts</code> being a third helper module.  Below is in reference to version 2.0.0 of Riakc.
</p>

<h2>Riakc.Robj</h2>
<p>
<code>Riakc.Robj</code> defines a representation of an object stored in Riak.  <code>Robj</code> is completely pure code.  The API can be found <a href="https://github.com/orbitz/ocaml-riakc/blob/2.0.0/lib/riakc/robj.mli">here</a>.
</p>

<h2>Riakc.Conn</h2>
<p>
This is the I/O layer.  All interaction with the actual database happens through this module.  <code>Riakc.Conn</code> is somewhat clever in that it has a compile-time requirement that you have called <code>Riakc.Robj.set_content</code> on any value you want to PUT.  This guarantees you have resolved all siblings, somehow.  Its API can be found <a href="https://github.com/orbitz/ocaml-riakc/blob/2.0.0/lib/riakc/conn.mli">here</a>.
</p>

<h2>Riakc.Opts</h2>
<p>
Finally, various options are defined in <code>Riakc.Opts</code>.  These are options that GET and PUT take.  Not all of them are actually supported but support is planned.  The API can be viewed <a href="https://github.com/orbitz/ocaml-riakc/blob/2.0.0/lib/riakc/opts.mli">here</a>.
</p>

<p>
Hopefully Riakc has a fairly straight forward API.  While the example code might be longer than other clients, it is complete and correct (I hope).
</p>
