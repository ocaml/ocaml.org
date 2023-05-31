---
title: More static analysis with CIL
description: "Years ago I played around with CIL to analyze libvirt. More recently
  Dan used CIL to analyze libvirt\u2019s locking code. We didn\u2019t get so far either
  time, but I\u2019ve been taking a deepe\u2026"
url: https://rwmj.wordpress.com/2013/02/07/more-static-analysis-with-cil/
date: 2013-02-07T18:18:35-00:00
preview_image: https://s0.wp.com/i/blank.jpg
featured:
authors:
- rjones
---

<p>Years ago I <a href="http://people.redhat.com/~rjones/cil-analysis-of-libvirt/">played around</a> with <a href="http://www.cs.berkeley.edu/~necula/cil/">CIL</a> to analyze <a href="http://libvirt.org">libvirt</a>.  More recently <a href="https://rwmj.wordpress.com/2009/05/15/dan-uses-ocaml-cil-to-analyze-libvirts-locking-patterns/">Dan used CIL to analyze libvirt&rsquo;s locking code</a>.</p>
<p>We didn&rsquo;t get so far either time, but I&rsquo;ve been taking a deeper look at CIL in an attempt to verify error handling in <a href="http://libguestfs.org/">libguestfs</a>.</p>
<p>Here is my partly working code so far.</p>
<pre>
<tt><i><font color="#9A1900">(*</font></i>
<i><font color="#9A1900"> * Analyse libguestfs APIs to find error overwriting.</font></i>
<i><font color="#9A1900"> * Copyright (C) 2008-2013 Red Hat, Inc.</font></i>
<i><font color="#9A1900"> *</font></i>
<i><font color="#9A1900"> * This library is free software; you can redistribute it and/or</font></i>
<i><font color="#9A1900"> * modify it under the terms of the GNU Lesser General Public</font></i>
<i><font color="#9A1900"> * License as published by the Free Software Foundation; either</font></i>
<i><font color="#9A1900"> * version 2.1 of the License, or (at your option) any later version.</font></i>
<i><font color="#9A1900"> *</font></i>
<i><font color="#9A1900"> * This library is distributed in the hope that it will be useful,</font></i>
<i><font color="#9A1900"> * but WITHOUT ANY WARRANTY; without even the implied warranty of</font></i>
<i><font color="#9A1900"> * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU</font></i>
<i><font color="#9A1900"> * Lesser General Public License for more details.</font></i>
<i><font color="#9A1900"> *</font></i>
<i><font color="#9A1900"> * You should have received a copy of the GNU Lesser General Public</font></i>
<i><font color="#9A1900"> * License along with this library.  If not, see</font></i>
<i><font color="#9A1900"> * &lt;http://www.gnu.org/licenses/&gt;.</font></i>
<i><font color="#9A1900"> *</font></i>
<i><font color="#9A1900"> * Author: Daniel P. Berrange &lt;berrange@redhat.com&gt;</font></i>
<i><font color="#9A1900"> * Author: Richard W.M. Jones &lt;rjones@redhat.com&gt;</font></i>
<i><font color="#9A1900"> *)</font></i>

<b><font color="#000080">open</font></b> <font color="#009900">Unix</font>
<b><font color="#000080">open</font></b> <font color="#009900">Printf</font>

<b><font color="#000080">open</font></b> <font color="#009900">Cil</font>

<b><font color="#0000FF">let</font></b> debug <font color="#990000">=</font> <font color="#009900">ref</font> <b><font color="#0000FF">false</font></b>

<i><font color="#9A1900">(* Set of ints. *)</font></i>
<b><font color="#0000FF">module</font></b> <font color="#009900">IntSet</font> <font color="#990000">=</font> <b><font color="#000080">Set</font></b><font color="#990000">.</font><font color="#009900">Make</font> <font color="#990000">(</font><b><font color="#0000FF">struct</font></b> <b><font color="#0000FF">type</font></b> t <font color="#990000">=</font> <font color="#009900">int</font> <b><font color="#0000FF">let</font></b> compare <font color="#990000">=</font> compare <b><font color="#0000FF">end</font></b><font color="#990000">)</font>

<i><font color="#9A1900">(* A module for storing any set (unordered list) of functions. *)</font></i>
<b><font color="#0000FF">module</font></b> <font color="#009900">FunctionSet</font> <font color="#990000">=</font> <b><font color="#000080">Set</font></b><font color="#990000">.</font><font color="#009900">Make</font> <font color="#990000">(</font>
  <b><font color="#0000FF">struct</font></b>
    <b><font color="#0000FF">type</font></b> t <font color="#990000">=</font> varinfo
    <b><font color="#0000FF">let</font></b> compare v1 v2 <font color="#990000">=</font> compare v1<font color="#990000">.</font>vid v2<font color="#990000">.</font>vid
  <b><font color="#0000FF">end</font></b>
<font color="#990000">)</font>

<i><font color="#9A1900">(* Directed graph of functions.</font></i>
<i><font color="#9A1900"> *</font></i>
<i><font color="#9A1900"> * Function = a node in the graph</font></i>
<i><font color="#9A1900"> * FunctionDigraph = the directed graph</font></i>
<i><font color="#9A1900"> * FunctionPathChecker = path checker module using Dijkstra's algorithm</font></i>
<i><font color="#9A1900"> *)</font></i>
<b><font color="#0000FF">module</font></b> <font color="#009900">Function</font> <font color="#990000">=</font>
<b><font color="#0000FF">struct</font></b>
  <b><font color="#0000FF">type</font></b> t <font color="#990000">=</font> varinfo
  <b><font color="#0000FF">let</font></b> compare f1 f2 <font color="#990000">=</font> compare f1<font color="#990000">.</font>vid f2<font color="#990000">.</font>vid
  <b><font color="#0000FF">let</font></b> hash f <font color="#990000">=</font> <b><font color="#000080">Hashtbl</font></b><font color="#990000">.</font>hash f<font color="#990000">.</font>vid
  <b><font color="#0000FF">let</font></b> equal f1 f2 <font color="#990000">=</font> f1<font color="#990000">.</font>vid <font color="#990000">=</font> f2<font color="#990000">.</font>vid
<b><font color="#0000FF">end</font></b>
<b><font color="#0000FF">module</font></b> <font color="#009900">FunctionDigraph</font> <font color="#990000">=</font> <b><font color="#000080">Graph</font></b><font color="#990000">.</font><b><font color="#000080">Imperative</font></b><font color="#990000">.</font><b><font color="#000080">Digraph</font></b><font color="#990000">.</font><font color="#009900">Concrete</font> <font color="#990000">(</font><font color="#009900">Function</font><font color="#990000">)</font>
<b><font color="#0000FF">module</font></b> <font color="#009900">FunctionPathChecker</font> <font color="#990000">=</font> <b><font color="#000080">Graph</font></b><font color="#990000">.</font><b><font color="#000080">Path</font></b><font color="#990000">.</font><font color="#009900">Check</font> <font color="#990000">(</font><font color="#009900">FunctionDigraph</font><font color="#990000">)</font>

<i><font color="#9A1900">(* Module used to analyze the paths through each function. *)</font></i>
<b><font color="#0000FF">module</font></b> <font color="#009900">ErrorCounter</font> <font color="#990000">=</font>
<b><font color="#0000FF">struct</font></b>
  <b><font color="#0000FF">let</font></b> name <font color="#990000">=</font> <font color="#FF0000">&quot;ErrorCounter&quot;</font>
  <b><font color="#0000FF">let</font></b> debug <font color="#990000">=</font> debug

  <i><font color="#9A1900">(* Our current state is very simple, just the number of error</font></i>
<i><font color="#9A1900">   * function calls did encountered up to this statement.</font></i>
<i><font color="#9A1900">   *)</font></i>
  <b><font color="#0000FF">type</font></b> t <font color="#990000">=</font> <font color="#009900">int</font>

  <b><font color="#0000FF">let</font></b> copy errcalls <font color="#990000">=</font> errcalls

  <i><font color="#9A1900">(* Start data for each statement. *)</font></i>
  <b><font color="#0000FF">let</font></b> stmtStartData <font color="#990000">=</font> <b><font color="#000080">Inthash</font></b><font color="#990000">.</font>create <font color="#993399">97</font>

  <b><font color="#0000FF">let</font></b> printable errcalls <font color="#990000">=</font> sprintf <font color="#FF0000">&quot;(errcalls=%d)&quot;</font> errcalls

  <b><font color="#0000FF">let</font></b> pretty <font color="#990000">()</font> t <font color="#990000">=</font> <b><font color="#000080">Pretty</font></b><font color="#990000">.</font>text <font color="#990000">(</font>printable t<font color="#990000">)</font>

  <b><font color="#0000FF">let</font></b> computeFirstPredecessor stmt x <font color="#990000">=</font> x <i><font color="#9A1900">(* XXX??? *)</font></i>

  <b><font color="#0000FF">let</font></b> combinePredecessors stmt <font color="#990000">~</font>old<font color="#990000">:</font>old_t new_t <font color="#990000">=</font>
    <b><font color="#0000FF">if</font></b> old_t <font color="#990000">=</font> new_t <b><font color="#0000FF">then</font></b> <font color="#009900">None</font>
    <b><font color="#0000FF">else</font></b> <font color="#009900">Some</font> new_t

  <i><font color="#9A1900">(* This will be initialized after we have calculated the set of all</font></i>
<i><font color="#9A1900">   * functions which can call an error function, in main() below.</font></i>
<i><font color="#9A1900">   *)</font></i>
  <b><font color="#0000FF">let</font></b> error_functions_set <font color="#990000">=</font> <font color="#009900">ref</font> <b><font color="#000080">FunctionSet</font></b><font color="#990000">.</font>empty

  <i><font color="#9A1900">(* Handle a Cil.Instr. *)</font></i>
  <b><font color="#0000FF">let</font></b> doInstr instr _ <font color="#990000">=</font>
    <b><font color="#0000FF">match</font></b> instr <b><font color="#0000FF">with</font></b>
    <i><font color="#9A1900">(* A call to an error function. *)</font></i>
    <font color="#990000">|</font> <font color="#009900">Call</font> <font color="#990000">(</font>_<font color="#990000">,</font> <font color="#009900">Lval</font> <font color="#990000">(</font><font color="#009900">Var</font> callee<font color="#990000">,</font> _<font color="#990000">),</font> _<font color="#990000">,</font> _<font color="#990000">)</font>
        <b><font color="#0000FF">when</font></b> <b><font color="#000080">FunctionSet</font></b><font color="#990000">.</font>mem callee <font color="#990000">!</font>error_functions_set <font color="#990000">-&gt;</font>
      <b><font color="#000080">Dataflow</font></b><font color="#990000">.</font><font color="#009900">Post</font> <font color="#990000">(</font><b><font color="#0000FF">fun</font></b> errcalls <font color="#990000">-&gt;</font> errcalls<font color="#990000">+</font><font color="#993399">1</font><font color="#990000">)</font>

    <font color="#990000">|</font> _ <font color="#990000">-&gt;</font> <b><font color="#000080">Dataflow</font></b><font color="#990000">.</font><font color="#009900">Default</font>

  <i><font color="#9A1900">(* Handle a Cil.Stmt. *)</font></i>
  <b><font color="#0000FF">let</font></b> doStmt _ _ <font color="#990000">=</font> <b><font color="#000080">Dataflow</font></b><font color="#990000">.</font><font color="#009900">SDefault</font>

  <i><font color="#9A1900">(* Handle a Cil.Guard. *)</font></i>
  <b><font color="#0000FF">let</font></b> doGuard _ _ <font color="#990000">=</font> <b><font color="#000080">Dataflow</font></b><font color="#990000">.</font><font color="#009900">GDefault</font>

  <i><font color="#9A1900">(* Filter statements we've seen already to prevent loops. *)</font></i>
  <b><font color="#0000FF">let</font></b> filter_set <font color="#990000">=</font> <font color="#009900">ref</font> <b><font color="#000080">IntSet</font></b><font color="#990000">.</font>empty
  <b><font color="#0000FF">let</font></b> filterStmt <font color="#FF0000">{</font> sid <font color="#990000">=</font> sid <font color="#FF0000">}</font> <font color="#990000">=</font>
    <b><font color="#0000FF">if</font></b> <b><font color="#000080">IntSet</font></b><font color="#990000">.</font>mem sid <font color="#990000">!</font>filter_set <b><font color="#0000FF">then</font></b> <b><font color="#0000FF">false</font></b>
    <b><font color="#0000FF">else</font></b> <font color="#990000">(</font>
      filter_set <font color="#990000">:=</font> <b><font color="#000080">IntSet</font></b><font color="#990000">.</font>add sid <font color="#990000">!</font>filter_set<font color="#990000">;</font>
      <b><font color="#0000FF">true</font></b>
    <font color="#990000">)</font>

  <i><font color="#9A1900">(* Initialize the module before each function that we examine. *)</font></i>
  <b><font color="#0000FF">let</font></b> init stmts <font color="#990000">=</font>
    filter_set <font color="#990000">:=</font> <b><font color="#000080">IntSet</font></b><font color="#990000">.</font>empty<font color="#990000">;</font>
    <b><font color="#000080">Inthash</font></b><font color="#990000">.</font>clear stmtStartData<font color="#990000">;</font>
    <i><font color="#9A1900">(* Add the initial statement(s) to the hash. *)</font></i>
    <b><font color="#000080">List</font></b><font color="#990000">.</font>iter <font color="#990000">(</font><b><font color="#0000FF">fun</font></b> stmt <font color="#990000">-&gt;</font> <b><font color="#000080">Inthash</font></b><font color="#990000">.</font>add stmtStartData stmt<font color="#990000">.</font>sid <font color="#993399">0</font><font color="#990000">)</font> stmts
<b><font color="#0000FF">end</font></b>

<b><font color="#0000FF">module</font></b> <font color="#009900">ForwardsErrorCounter</font> <font color="#990000">=</font> <b><font color="#000080">Dataflow</font></b><font color="#990000">.</font><font color="#009900">ForwardsDataFlow</font> <font color="#990000">(</font><font color="#009900">ErrorCounter</font><font color="#990000">)</font>

<i><font color="#9A1900">(* The always useful filter + map function. *)</font></i>
<b><font color="#0000FF">let</font></b> <b><font color="#0000FF">rec</font></b> filter_map f <font color="#990000">=</font> <b><font color="#0000FF">function</font></b>
  <font color="#990000">|</font> <font color="#990000">[]</font> <font color="#990000">-&gt;</font> <font color="#990000">[]</font>
  <font color="#990000">|</font> x <font color="#990000">::</font> xs <font color="#990000">-&gt;</font>
      <b><font color="#0000FF">match</font></b> f x <b><font color="#0000FF">with</font></b>
      <font color="#990000">|</font> <font color="#009900">Some</font> y <font color="#990000">-&gt;</font> y <font color="#990000">::</font> filter_map f xs
      <font color="#990000">|</font> <font color="#009900">None</font> <font color="#990000">-&gt;</font> filter_map f xs

<b><font color="#0000FF">let</font></b> <b><font color="#0000FF">rec</font></b> main <font color="#990000">()</font> <font color="#990000">=</font>
  <i><font color="#9A1900">(* Read the list of input C files. *)</font></i>
  <b><font color="#0000FF">let</font></b> files <font color="#990000">=</font>
    <b><font color="#0000FF">let</font></b> chan <font color="#990000">=</font> open_process_in <font color="#FF0000">&quot;find src -name '*.i' | sort&quot;</font> <b><font color="#0000FF">in</font></b>
    <b><font color="#0000FF">let</font></b> files <font color="#990000">=</font> input_chan chan <b><font color="#0000FF">in</font></b>
    <b><font color="#0000FF">if</font></b> close_process_in chan <font color="#990000">&lt;&gt;</font> <font color="#009900">WEXITED</font> <font color="#993399">0</font> <b><font color="#0000FF">then</font></b>
      failwith <font color="#FF0000">&quot;failed to read input list of files&quot;</font><font color="#990000">;</font>
    <b><font color="#0000FF">if</font></b> files <font color="#990000">=</font> <font color="#990000">[]</font> <b><font color="#0000FF">then</font></b>
      failwith <font color="#FF0000">&quot;no input files; is the program running from the top directory? did you compile with make -C src CFLAGS=\&quot;-save-temps\&quot;?&quot;</font><font color="#990000">;</font>
    files <b><font color="#0000FF">in</font></b>

  <i><font color="#9A1900">(* Load and parse each input file. *)</font></i>
  <b><font color="#0000FF">let</font></b> files <font color="#990000">=</font>
    <b><font color="#000080">List</font></b><font color="#990000">.</font>map <font color="#990000">(</font>
      <b><font color="#0000FF">fun</font></b> filename <font color="#990000">-&gt;</font>
        printf <font color="#FF0000">&quot;loading %s\n%!&quot;</font> filename<font color="#990000">;</font>
        <b><font color="#000080">Frontc</font></b><font color="#990000">.</font>parse filename <font color="#990000">()</font>
    <font color="#990000">)</font> files <b><font color="#0000FF">in</font></b>

  <i><font color="#9A1900">(* Merge the files. *)</font></i>
  printf <font color="#FF0000">&quot;merging files\n%!&quot;</font><font color="#990000">;</font>
  <b><font color="#0000FF">let</font></b> sourcecode <font color="#990000">=</font> <b><font color="#000080">Mergecil</font></b><font color="#990000">.</font>merge files <font color="#FF0000">&quot;libguestfs&quot;</font> <b><font color="#0000FF">in</font></b>

  <i><font color="#9A1900">(* CFG analysis. *)</font></i>
  printf <font color="#FF0000">&quot;computing control flow\n%!&quot;</font><font color="#990000">;</font>
  <b><font color="#000080">Cfg</font></b><font color="#990000">.</font>computeFileCFG sourcecode<font color="#990000">;</font>

  <b><font color="#0000FF">let</font></b> functions <font color="#990000">=</font>
    filter_map <font color="#990000">(</font><b><font color="#0000FF">function</font></b> <font color="#009900">GFun</font> <font color="#990000">(</font>f<font color="#990000">,</font> loc<font color="#990000">)</font> <font color="#990000">-&gt;</font> <font color="#009900">Some</font> <font color="#990000">(</font>f<font color="#990000">,</font> loc<font color="#990000">)</font> <font color="#990000">|</font> _ <font color="#990000">-&gt;</font> <font color="#009900">None</font><font color="#990000">)</font>
      sourcecode<font color="#990000">.</font>globals <b><font color="#0000FF">in</font></b>

  <i><font color="#9A1900">(* Examine which functions directly call which other functions. *)</font></i>
  printf <font color="#FF0000">&quot;computing call graph\n%!&quot;</font><font color="#990000">;</font>
  <b><font color="#0000FF">let</font></b> call_graph <font color="#990000">=</font> make_call_graph functions <b><font color="#0000FF">in</font></b>
  <i><font color="#9A1900">(*</font></i>
<i><font color="#9A1900">  FunctionDigraph.iter_edges (</font></i>
<i><font color="#9A1900">    fun caller callee -&gt;</font></i>
<i><font color="#9A1900">      printf &quot;%s calls %s\n&quot; caller.vname callee.vname</font></i>
<i><font color="#9A1900">  ) call_graph;</font></i>
<i><font color="#9A1900">  *)</font></i>

  <i><font color="#9A1900">(* The libguestfs error functions.  These are global function names,</font></i>
<i><font color="#9A1900">   * but to be any use to us we have to look these up in the list of</font></i>
<i><font color="#9A1900">   * all global functions (ie. 'functions') and turn them into the</font></i>
<i><font color="#9A1900">   * corresponding varinfo structures.</font></i>
<i><font color="#9A1900">   *)</font></i>
  <b><font color="#0000FF">let</font></b> error_function_names <font color="#990000">=</font> <font color="#990000">[</font> <font color="#FF0000">&quot;guestfs_error_errno&quot;</font><font color="#990000">;</font>
                               <font color="#FF0000">&quot;guestfs_perrorf&quot;</font> <font color="#990000">]</font> <b><font color="#0000FF">in</font></b>

  <b><font color="#0000FF">let</font></b> find_function name <font color="#990000">=</font>
    <b><font color="#0000FF">try</font></b> <b><font color="#000080">List</font></b><font color="#990000">.</font>find <font color="#990000">(</font><b><font color="#0000FF">fun</font></b> <font color="#990000">(</font><font color="#FF0000">{</font> svar <font color="#990000">=</font> <font color="#FF0000">{</font> vname <font color="#990000">=</font> n <font color="#FF0000">}}</font><font color="#990000">,</font> _<font color="#990000">)</font> <font color="#990000">-&gt;</font> n <font color="#990000">=</font> name<font color="#990000">)</font> functions
    <b><font color="#0000FF">with</font></b> <font color="#009900">Not_found</font> <font color="#990000">-&gt;</font> failwith <font color="#990000">(</font><font color="#FF0000">&quot;function '&quot;</font> <font color="#990000">^</font> name <font color="#990000">^</font> <font color="#FF0000">&quot;' does not exist&quot;</font><font color="#990000">)</font>
  <b><font color="#0000FF">in</font></b>
  <b><font color="#0000FF">let</font></b> error_function_names <font color="#990000">=</font> <b><font color="#000080">List</font></b><font color="#990000">.</font>map <font color="#990000">(</font>
    <b><font color="#0000FF">fun</font></b> f <font color="#990000">-&gt;</font> <font color="#990000">(</font>fst <font color="#990000">(</font>find_function f<font color="#990000">)).</font>svar
  <font color="#990000">)</font> error_function_names <b><font color="#0000FF">in</font></b>

  <i><font color="#9A1900">(* Get a list of functions that might (directly or indirectly) call</font></i>
<i><font color="#9A1900">   * one of the error functions.</font></i>
<i><font color="#9A1900">   *)</font></i>
  <b><font color="#0000FF">let</font></b> error_functions<font color="#990000">,</font> non_error_functions <font color="#990000">=</font>
    functions_which_call call_graph error_function_names functions <b><font color="#0000FF">in</font></b>

  <i><font color="#9A1900">(*</font></i>
<i><font color="#9A1900">  List.iter (</font></i>
<i><font color="#9A1900">    fun f -&gt; printf &quot;%s can call an error function\n&quot; f.vname</font></i>
<i><font color="#9A1900">  ) error_functions;</font></i>

<i><font color="#9A1900">  List.iter (</font></i>
<i><font color="#9A1900">    fun f -&gt; printf &quot;%s can NOT call an error function\n&quot; f.vname</font></i>
<i><font color="#9A1900">  ) non_error_functions;</font></i>
<i><font color="#9A1900">  *)</font></i>

  <i><font color="#9A1900">(* Save the list of error functions in a global set for fast lookups. *)</font></i>
  <b><font color="#0000FF">let</font></b> set <font color="#990000">=</font>
    <b><font color="#000080">List</font></b><font color="#990000">.</font>fold_left <font color="#990000">(</font>
      <b><font color="#0000FF">fun</font></b> set elt <font color="#990000">-&gt;</font> <b><font color="#000080">FunctionSet</font></b><font color="#990000">.</font>add elt set
    <font color="#990000">)</font> <b><font color="#000080">FunctionSet</font></b><font color="#990000">.</font>empty error_functions <b><font color="#0000FF">in</font></b>
  <b><font color="#000080">ErrorCounter</font></b><font color="#990000">.</font>error_functions_set <font color="#990000">:=</font> set<font color="#990000">;</font>

  <i><font color="#9A1900">(* Analyze each top-level function to ensure it calls an error</font></i>
<i><font color="#9A1900">   * function exactly once on error paths, and never on normal return</font></i>
<i><font color="#9A1900">   * paths.</font></i>
<i><font color="#9A1900">   *)</font></i>
  printf <font color="#FF0000">&quot;analyzing correctness of error paths\n%!&quot;</font><font color="#990000">;</font>
  <b><font color="#000080">List</font></b><font color="#990000">.</font>iter compute_error_paths functions<font color="#990000">;</font>

  <font color="#990000">()</font>

<i><font color="#9A1900">(* Make a directed graph of which functions directly call which other</font></i>
<i><font color="#9A1900"> * functions.</font></i>
<i><font color="#9A1900"> *)</font></i>
<b><font color="#0000FF">and</font></b> make_call_graph functions <font color="#990000">=</font>
  <b><font color="#0000FF">let</font></b> graph <font color="#990000">=</font> <b><font color="#000080">FunctionDigraph</font></b><font color="#990000">.</font>create <font color="#990000">()</font> <b><font color="#0000FF">in</font></b>

  <b><font color="#000080">List</font></b><font color="#990000">.</font>iter <font color="#990000">(</font>
    <b><font color="#0000FF">fun</font></b> <font color="#990000">(</font><font color="#FF0000">{</font> svar <font color="#990000">=</font> caller<font color="#990000">;</font> sallstmts <font color="#990000">=</font> sallstmts <font color="#FF0000">}</font><font color="#990000">,</font> _<font color="#990000">)</font> <font color="#990000">-&gt;</font>
      <i><font color="#9A1900">(* Evaluate which other functions 'caller' calls.  First pull</font></i>
<i><font color="#9A1900">       * out every 'Call' instruction anywhere in the function.</font></i>
<i><font color="#9A1900">       *)</font></i>
      <b><font color="#0000FF">let</font></b> insns <font color="#990000">=</font>  <b><font color="#000080">List</font></b><font color="#990000">.</font>concat <font color="#990000">(</font>
        filter_map <font color="#990000">(</font>
          <b><font color="#0000FF">function</font></b>
          <font color="#990000">|</font> <font color="#FF0000">{</font> skind <font color="#990000">=</font> <font color="#009900">Instr</font> insns <font color="#FF0000">}</font> <font color="#990000">-&gt;</font> <font color="#009900">Some</font> insns
          <font color="#990000">|</font> _ <font color="#990000">-&gt;</font> <font color="#009900">None</font>
        <font color="#990000">)</font> sallstmts
      <font color="#990000">)</font> <b><font color="#0000FF">in</font></b>
      <b><font color="#0000FF">let</font></b> calls <font color="#990000">=</font> <b><font color="#000080">List</font></b><font color="#990000">.</font>filter <font color="#990000">(</font><b><font color="#0000FF">function</font></b> <font color="#009900">Call</font> _ <font color="#990000">-&gt;</font> <b><font color="#0000FF">true</font></b> <font color="#990000">|</font> _ <font color="#990000">-&gt;</font> <b><font color="#0000FF">false</font></b><font color="#990000">)</font> insns <b><font color="#0000FF">in</font></b>
      <i><font color="#9A1900">(* Then examine what function is being called at each place. *)</font></i>
      <b><font color="#0000FF">let</font></b> callees <font color="#990000">=</font> filter_map <font color="#990000">(</font>
        <b><font color="#0000FF">function</font></b>
        <font color="#990000">|</font> <font color="#009900">Call</font> <font color="#990000">(</font>_<font color="#990000">,</font> <font color="#009900">Lval</font> <font color="#990000">(</font><font color="#009900">Var</font> callee<font color="#990000">,</font> _<font color="#990000">),</font> _<font color="#990000">,</font> _<font color="#990000">)</font> <font color="#990000">-&gt;</font> <font color="#009900">Some</font> callee
        <font color="#990000">|</font> _ <font color="#990000">-&gt;</font> <font color="#009900">None</font>
      <font color="#990000">)</font> calls <b><font color="#0000FF">in</font></b>

      <b><font color="#000080">List</font></b><font color="#990000">.</font>iter <font color="#990000">(</font>
        <b><font color="#0000FF">fun</font></b> callee <font color="#990000">-&gt;</font>
          <b><font color="#000080">FunctionDigraph</font></b><font color="#990000">.</font>add_edge graph caller callee
      <font color="#990000">)</font> callees
  <font color="#990000">)</font> functions<font color="#990000">;</font>

  graph

<i><font color="#9A1900">(* [functions_which_call g endpoints functions] partitions the</font></i>
<i><font color="#9A1900"> * [functions] list, returning those functions that call directly or</font></i>
<i><font color="#9A1900"> * indirectly one of the functions in [endpoints], and a separate list</font></i>
<i><font color="#9A1900"> * of functions which do not.  [g] is the direct call graph.</font></i>
<i><font color="#9A1900"> *)</font></i>
<b><font color="#0000FF">and</font></b> functions_which_call g endpoints functions <font color="#990000">=</font>
  <b><font color="#0000FF">let</font></b> functions <font color="#990000">=</font> <b><font color="#000080">List</font></b><font color="#990000">.</font>map <font color="#990000">(</font><b><font color="#0000FF">fun</font></b> <font color="#990000">(</font><font color="#FF0000">{</font> svar <font color="#990000">=</font> svar <font color="#FF0000">}</font><font color="#990000">,</font> _<font color="#990000">)</font> <font color="#990000">-&gt;</font> svar<font color="#990000">)</font> functions <b><font color="#0000FF">in</font></b>

  <b><font color="#0000FF">let</font></b> checker <font color="#990000">=</font> <b><font color="#000080">FunctionPathChecker</font></b><font color="#990000">.</font>create g <b><font color="#0000FF">in</font></b>
  <b><font color="#000080">List</font></b><font color="#990000">.</font>partition <font color="#990000">(</font>
    <b><font color="#0000FF">fun</font></b> f <font color="#990000">-&gt;</font>
      <i><font color="#9A1900">(* Does a path exist from f to any of the endpoints? *)</font></i>
      <b><font color="#000080">List</font></b><font color="#990000">.</font>exists <font color="#990000">(</font>
        <b><font color="#0000FF">fun</font></b> endpoint <font color="#990000">-&gt;</font>
          <b><font color="#0000FF">try</font></b> <b><font color="#000080">FunctionPathChecker</font></b><font color="#990000">.</font>check_path checker f endpoint
          <b><font color="#0000FF">with</font></b>
          <i><font color="#9A1900">(* It appears safe to ignore this exception.  It seems to</font></i>
<i><font color="#9A1900">           * mean that this function is in a part of the graph which</font></i>
<i><font color="#9A1900">           * is completely disconnected from the other part of the graph</font></i>
<i><font color="#9A1900">           * that contains the endpoint.</font></i>
<i><font color="#9A1900">           *)</font></i>
          <font color="#990000">|</font> <font color="#009900">Invalid_argument</font> <font color="#FF0000">&quot;[ocamlgraph] iter_succ&quot;</font> <font color="#990000">-&gt;</font> <b><font color="#0000FF">false</font></b>
      <font color="#990000">)</font> endpoints
  <font color="#990000">)</font> functions

<b><font color="#0000FF">and</font></b> compute_error_paths <font color="#990000">(</font><font color="#FF0000">{</font> svar <font color="#990000">=</font> svar <font color="#FF0000">}</font> <b><font color="#0000FF">as</font></b> f<font color="#990000">,</font> loc<font color="#990000">)</font> <font color="#990000">=</font>
  <i><font color="#9A1900">(*ErrorCounter.debug := true;*)</font></i>

  <i><font color="#9A1900">(* Find the initial statement in this function (assumes that the</font></i>
<i><font color="#9A1900">   * function can only be entered in one place, which is normal for C</font></i>
<i><font color="#9A1900">   * functions).</font></i>
<i><font color="#9A1900">   *)</font></i>
  <b><font color="#0000FF">let</font></b> initial_stmts <font color="#990000">=</font>
    <b><font color="#0000FF">match</font></b> f<font color="#990000">.</font>sbody<font color="#990000">.</font>bstmts <b><font color="#0000FF">with</font></b>
    <font color="#990000">|</font> <font color="#990000">[]</font> <font color="#990000">-&gt;</font> <font color="#990000">[]</font>
    <font color="#990000">|</font> first<font color="#990000">::</font>_ <font color="#990000">-&gt;</font> <font color="#990000">[</font>first<font color="#990000">]</font> <b><font color="#0000FF">in</font></b>

  <i><font color="#9A1900">(* Initialize ErrorCounter. *)</font></i>
  <b><font color="#000080">ErrorCounter</font></b><font color="#990000">.</font>init initial_stmts<font color="#990000">;</font>

  <i><font color="#9A1900">(* Compute the error counters along paths through the function. *)</font></i>
  <b><font color="#000080">ForwardsErrorCounter</font></b><font color="#990000">.</font>compute initial_stmts<font color="#990000">;</font>

  <i><font color="#9A1900">(* Process all Return statements in this function. *)</font></i>
  <b><font color="#000080">List</font></b><font color="#990000">.</font>iter <font color="#990000">(</font>
    <b><font color="#0000FF">fun</font></b> stmt <font color="#990000">-&gt;</font>
      <b><font color="#0000FF">try</font></b>
        <b><font color="#0000FF">let</font></b> errcalls <font color="#990000">=</font> <b><font color="#000080">Inthash</font></b><font color="#990000">.</font>find <b><font color="#000080">ErrorCounter</font></b><font color="#990000">.</font>stmtStartData stmt<font color="#990000">.</font>sid <b><font color="#0000FF">in</font></b>

        <b><font color="#0000FF">match</font></b> stmt <b><font color="#0000FF">with</font></b>
        <i><font color="#9A1900">(* return -1; *)</font></i>
        <font color="#990000">|</font> <font color="#FF0000">{</font> skind <font color="#990000">=</font> <font color="#009900">Return</font> <font color="#990000">(</font><font color="#009900">Some</font> i<font color="#990000">,</font> loc<font color="#990000">)</font> <font color="#FF0000">}</font> <b><font color="#0000FF">when</font></b> is_literal_minus_one i <font color="#990000">-&gt;</font>
          <b><font color="#0000FF">if</font></b> errcalls <font color="#990000">=</font> <font color="#993399">0</font> <b><font color="#0000FF">then</font></b>
            printf <font color="#FF0000">&quot;%s:%d: %s: may return an error code without calling error/perrorf\n&quot;</font>
              loc<font color="#990000">.</font>file loc<font color="#990000">.</font>line svar<font color="#990000">.</font>vname
          <b><font color="#0000FF">else</font></b> <b><font color="#0000FF">if</font></b> errcalls <font color="#990000">&gt;</font> <font color="#993399">1</font> <b><font color="#0000FF">then</font></b>
            printf <font color="#FF0000">&quot;%s:%d: %s: may call error/perrorf %d times (more than once) along an error path\n&quot;</font>
          loc<font color="#990000">.</font>file loc<font color="#990000">.</font>line svar<font color="#990000">.</font>vname errcalls

        <i><font color="#9A1900">(* return 0; *)</font></i>
        <font color="#990000">|</font> <font color="#FF0000">{</font> skind <font color="#990000">=</font> <font color="#009900">Return</font> <font color="#990000">(</font><font color="#009900">Some</font> i<font color="#990000">,</font> loc<font color="#990000">)</font> <font color="#FF0000">}</font> <b><font color="#0000FF">when</font></b> is_literal_zero i <font color="#990000">-&gt;</font>
          <b><font color="#0000FF">if</font></b> errcalls <font color="#990000">&gt;=</font> <font color="#993399">1</font> <b><font color="#0000FF">then</font></b>
            printf <font color="#FF0000">&quot;%s:%d: %s: may call error/perrorf along a non-error return path\n&quot;</font>
              loc<font color="#990000">.</font>file loc<font color="#990000">.</font>line svar<font color="#990000">.</font>vname

        <i><font color="#9A1900">(* return; (void return) *)</font></i>
        <font color="#990000">|</font> <font color="#FF0000">{</font> skind <font color="#990000">=</font> <font color="#009900">Return</font> <font color="#990000">(</font><font color="#009900">None</font><font color="#990000">,</font> loc<font color="#990000">)</font> <font color="#FF0000">}</font> <font color="#990000">-&gt;</font>
          <b><font color="#0000FF">if</font></b> errcalls <font color="#990000">&gt;=</font> <font color="#993399">1</font> <b><font color="#0000FF">then</font></b>
            printf <font color="#FF0000">&quot;%s:%d: %s: may call error/perrorf and return void\n&quot;</font>
              loc<font color="#990000">.</font>file loc<font color="#990000">.</font>line svar<font color="#990000">.</font>vname

        <font color="#990000">|</font> _ <font color="#990000">-&gt;</font> <font color="#990000">()</font>

      <b><font color="#0000FF">with</font></b>
        <font color="#009900">Not_found</font> <font color="#990000">-&gt;</font>
          printf <font color="#FF0000">&quot;%s:%d: %s: may contain unreachable code\n&quot;</font>
            loc<font color="#990000">.</font>file loc<font color="#990000">.</font>line svar<font color="#990000">.</font>vname
  <font color="#990000">)</font> f<font color="#990000">.</font>sallstmts

<i><font color="#9A1900">(* Some convenience CIL matching functions. *)</font></i>
<b><font color="#0000FF">and</font></b> is_literal_minus_one <font color="#990000">=</font> <b><font color="#0000FF">function</font></b>
  <font color="#990000">|</font> <font color="#009900">Const</font> <font color="#990000">(</font><font color="#009900">CInt64</font> <font color="#990000">(-</font><font color="#993399">1L</font><font color="#990000">,</font> _<font color="#990000">,</font> _<font color="#990000">))</font> <font color="#990000">-&gt;</font> <b><font color="#0000FF">true</font></b>
  <font color="#990000">|</font> _ <font color="#990000">-&gt;</font> <b><font color="#0000FF">false</font></b>

<b><font color="#0000FF">and</font></b> is_literal_zero <font color="#990000">=</font> <b><font color="#0000FF">function</font></b>
  <font color="#990000">|</font> <font color="#009900">Const</font> <font color="#990000">(</font><font color="#009900">CInt64</font> <font color="#990000">(</font><font color="#993399">0L</font><font color="#990000">,</font> _<font color="#990000">,</font> _<font color="#990000">))</font> <font color="#990000">-&gt;</font> <b><font color="#0000FF">true</font></b>
  <font color="#990000">|</font> _ <font color="#990000">-&gt;</font> <b><font color="#0000FF">false</font></b>

<i><font color="#9A1900">(* Convenient routine to load the contents of a channel into a list of</font></i>
<i><font color="#9A1900"> * strings.</font></i>
<i><font color="#9A1900"> *)</font></i>
<b><font color="#0000FF">and</font></b> input_chan chan <font color="#990000">=</font>
  <b><font color="#0000FF">let</font></b> lines <font color="#990000">=</font> <font color="#009900">ref</font> <font color="#990000">[]</font> <b><font color="#0000FF">in</font></b>
  <b><font color="#0000FF">try</font></b> <b><font color="#0000FF">while</font></b> <b><font color="#0000FF">true</font></b><font color="#990000">;</font> <b><font color="#0000FF">do</font></b> lines <font color="#990000">:=</font> input_line chan <font color="#990000">::</font> <font color="#990000">!</font>lines <b><font color="#0000FF">done</font></b><font color="#990000">;</font> <font color="#990000">[]</font>
  <b><font color="#0000FF">with</font></b> <font color="#009900">End_of_file</font> <font color="#990000">-&gt;</font> <b><font color="#000080">List</font></b><font color="#990000">.</font>rev <font color="#990000">!</font>lines

<b><font color="#0000FF">and</font></b> input_file filename <font color="#990000">=</font>
  <b><font color="#0000FF">let</font></b> chan <font color="#990000">=</font> open_in filename <b><font color="#0000FF">in</font></b>
  <b><font color="#0000FF">let</font></b> r <font color="#990000">=</font> input_chan chan <b><font color="#0000FF">in</font></b>
  close_in chan<font color="#990000">;</font>
  r

<b><font color="#0000FF">let</font></b> <font color="#990000">()</font> <font color="#990000">=</font>
  <b><font color="#0000FF">try</font></b> main <font color="#990000">()</font>
  <b><font color="#0000FF">with</font></b> 
    <font color="#009900">exn</font> <font color="#990000">-&gt;</font>
      prerr_endline <font color="#990000">(</font><b><font color="#000080">Printexc</font></b><font color="#990000">.</font>to_string <font color="#009900">exn</font><font color="#990000">);</font>
      <b><font color="#000080">Printexc</font></b><font color="#990000">.</font>print_backtrace <b><font color="#000080">Pervasives</font></b><font color="#990000">.</font>stderr<font color="#990000">;</font>
      exit <font color="#993399">1</font>
</tt>
</pre>

