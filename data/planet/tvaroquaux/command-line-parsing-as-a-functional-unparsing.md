---
title: Command line parsing as a functional unparsing
description: "Command line argument parsing is a puzzling subject: it seems simple
  and small enough that it wouldn\u2019t gather much attention yet it pops up ..."
url: https://till-varoquaux.blogspot.com/2010/07/command-line-parsing-as-functional.html
date: 2010-07-13T01:16:00-00:00
preview_image:
featured:
authors:
- Till
---

Command line argument parsing is a puzzling subject: it seems simple and small enough that it wouldn&rsquo;t gather much attention yet it pops up regularly through the blogosphere. There are many libraries for argument parsing but none of them seem to be unanimously loved. This has all the hallmarks of a surprisingly sneaky (and thus interesting) problem.
A couple of long plane rides have allowed me to try taking a stab at argument parsing. This is however not intended to be a fully maintained and polished library; it is toy code used to test out a couple of ideas. The code uses a couple of clever tricks (functional unparsing, staging of functions, phantom types) but none of them are really new.  A seasoned ocaml programmers should be able to tackle all the concepts involved without much of a headache.
So, without further ado:
<h2>Getting started</h2>
We can usually see writing a command line interfaces as making one or several ocaml functions callable from the console (aka the entry points of our program).  The library we&rsquo;ve defined allows us to make those functions callable by giving a specification of their arguments (using functional unparsing).
Throughout this post we shall incrementally refine a given command line interface. Each of those refinement will be exposed through the command line as a separate functions
Our subject today is a basic <tt>cp</tt> function which takes its arguments in reverse order (thus cp_into). It doesn&rsquo;t actually execute any action; instead it prints to stdout. We&rsquo;ll get into why we are not using a function with the arguments in the standard order for <tt>cp</tt> soon.

<pre><tt><span style="font-weight: bold"><span style="color: #0000FF">let</span></span> cp_into
    <span style="color: #990000">?(</span>recursive<span style="color: #990000">=</span><span style="font-weight: bold"><span style="color: #0000FF">false</span></span><span style="color: #990000">)</span>
    <span style="color: #990000">?(</span>force<span style="color: #990000">=</span><span style="font-weight: bold"><span style="color: #0000FF">false</span></span><span style="color: #990000">)</span>
    <span style="color: #990000">(</span>dst<span style="color: #990000">:</span><span style="color: #009900">string</span><span style="color: #990000">)</span>
    <span style="color: #990000">(</span>src<span style="color: #990000">:</span><span style="color: #009900">string</span> <span style="color: #009900">list</span><span style="color: #990000">)</span> <span style="color: #990000">:</span> <span style="color: #009900">unit</span> <span style="color: #990000">=</span>
  <span style="font-weight: bold"><span style="color: #000080">Printf</span></span><span style="color: #990000">.</span>printf &quot;cp_into<span style="color: #990000">\</span>n<span style="color: #990000">\</span>
    recursive<span style="color: #990000">:%</span>b<span style="color: #990000">\</span>n<span style="color: #990000">\</span>
    force<span style="color: #990000">:%</span>b<span style="color: #990000">\</span>n<span style="color: #990000">\</span>
    <span style="color: #990000">%</span>s <span style="color: #990000">&lt;-</span> <span style="color: #990000">%</span>s<span style="color: #990000">\</span>n&quot;
    recursive
    force
    dst
    <span style="color: #990000">(</span><span style="font-weight: bold"><span style="color: #000080">String</span></span><span style="color: #990000">.</span>concat <span style="color: #FF0000">&quot;,&quot;</span> src<span style="color: #990000">)</span></tt></pre>
Now that we know what we&rsquo;ll be working on we can start looking at how to define the command line interface. The main function we&rsquo;ll use is <tt>Unparse.choice</tt> which takes two unlabelled arguments: A specification (of type <tt>Unparse.t</tt>) which tells us which kind of command line arguments we expect and how to parse them and the function that we are embedding.  <tt>Unparse.choice</tt> doesn&rsquo;t actually parse the arguments straight away: it actually creates a value that can be used to define command line interface with several sub commands (&agrave; la busybox,git,hg etc..). 
<h2>Embedding simple functions</h2>
The simple specifications are very straightforwardly driven by the type of the functions we are embedding. We provide little more information than the type of the function and names of the arguments (used for documentation purposes)
<pre><tt>
<span style="font-weight: bold"><span style="color: #0000FF">let</span></span> basic_fun <span style="color: #990000">:</span> <span style="color: #009900">string</span> <span style="color: #990000">-&gt;</span> <span style="color: #009900">string</span> <span style="color: #009900">list</span> <span style="color: #990000">-&gt;</span> <span style="color: #009900">unit</span> <span style="color: #990000">=</span> <span style="font-weight: bold"><span style="color: #0000FF">fun</span></span> dst srcs <span style="color: #990000">-&gt;</span> cp_into dst srcs

<span style="font-style: italic"><span style="color: #9A1900">(* In this post we will gloss over the first parameter of the type `Unparse.t`</span></span>
<span style="font-style: italic"><span style="color: #9A1900">   it is a phantom type used to enforce some constraints on the specification. *)</span></span>
<span style="font-weight: bold"><span style="color: #0000FF">let</span></span> basic_spec <span style="color: #990000">:</span> <span style="color: #990000">(</span>_<span style="color: #990000">,</span><span style="color: #009900">string</span> <span style="color: #990000">-&gt;</span> <span style="color: #009900">string</span> <span style="color: #009900">list</span> <span style="color: #990000">-&gt;</span> 'a<span style="color: #990000">,</span>'a<span style="color: #990000">)</span> <span style="font-weight: bold"><span style="color: #000080">Unparse</span></span><span style="color: #990000">.</span>t <span style="color: #990000">=</span>
  <span style="font-weight: bold"><span style="color: #000080">Unparse</span></span><span style="color: #990000">.(</span><span style="color: #009900">string</span> <span style="color: #FF0000">&quot;tgt&quot;</span> <span style="color: #990000">++</span> non_empty_list <span style="color: #990000">(</span><span style="color: #009900">string</span> <span style="color: #FF0000">&quot;src&quot;</span><span style="color: #990000">))</span>

<span style="font-weight: bold"><span style="color: #0000FF">let</span></span> basic_choice <span style="color: #990000">:</span> <span style="color: #009900">unit</span> <span style="font-weight: bold"><span style="color: #000080">Unparse</span></span><span style="color: #990000">.</span>choice <span style="color: #990000">=</span>
  <span style="font-weight: bold"><span style="color: #000080">Unparse</span></span><span style="color: #990000">.</span>choice basic_spec
    <span style="color: #990000">~</span>f<span style="color: #990000">:</span>basic_fun
    <span style="color: #990000">~</span>descr<span style="color: #990000">:</span><span style="color: #FF0000">&quot;copy (without any flags)&quot;</span>
    <span style="color: #990000">~</span>name<span style="color: #990000">:</span><span style="color: #FF0000">&quot;cp_basic&quot;</span></tt></pre>
At this point I owe you an explanation: why did we not take the target as last argument like the unix <tt>cp</tt> command?
<h2>A note on the argument parsing heuristic</h2>
The parsers we build are <a href="http://en.wikipedia.org/wiki/LL_parser">LL(1)</a> parser. This means that there is no backtracking possible; if an operator successfully consumes an argument any solution that implies that operator failing will not even be considered
The <tt>list</tt> operator is greedy and matches the longest possible list. If we had try to embed the classical <tt>cp</tt> function. <pre><tt>cp file... directory</tt></pre> with the specification: <pre><tt>list (string &quot;file&quot;) ++ string &quot;directory&quot;</tt></pre> this would have resulted in an unusable function (since the first the list (<tt>string ...</tt>) would always have consumed all the remaining arguments).
<pre><tt><span style="font-weight: bold"><span style="color: #0000FF">let</span></span> cp <span style="color: #990000">(</span>_src<span style="color: #990000">:</span><span style="color: #009900">string</span> <span style="color: #009900">list</span><span style="color: #990000">)</span> <span style="color: #990000">(</span>_tgt<span style="color: #990000">:</span><span style="color: #009900">string</span><span style="color: #990000">)</span> <span style="color: #990000">:</span> <span style="color: #009900">unit</span> <span style="color: #990000">=</span>
  <span style="font-style: italic"><span style="color: #9A1900">(* This function is never going to get successfully called... *)</span></span>
  <span style="font-weight: bold"><span style="color: #0000FF">assert</span></span> <span style="font-weight: bold"><span style="color: #0000FF">false</span></span>

<span style="font-weight: bold"><span style="color: #0000FF">let</span></span> non_ll1_spec <span style="color: #990000">:</span> <span style="color: #990000">(</span>_<span style="color: #990000">,</span><span style="color: #009900">string</span> <span style="color: #009900">list</span> <span style="color: #990000">-&gt;</span> <span style="color: #009900">string</span> <span style="color: #990000">-&gt;</span> 'a<span style="color: #990000">,</span>'a<span style="color: #990000">)</span> <span style="font-weight: bold"><span style="color: #000080">Unparse</span></span><span style="color: #990000">.</span>t <span style="color: #990000">=</span>
  <span style="font-weight: bold"><span style="color: #000080">Unparse</span></span><span style="color: #990000">.(</span>non_empty_list <span style="color: #990000">(</span><span style="color: #009900">string</span> <span style="color: #FF0000">&quot;src&quot;</span><span style="color: #990000">)</span> <span style="color: #990000">++</span> <span style="color: #009900">string</span> <span style="color: #FF0000">&quot;tgt&quot;</span><span style="color: #990000">)</span>

<span style="font-weight: bold"><span style="color: #0000FF">let</span></span> non_ll1_choice <span style="color: #990000">:</span> <span style="color: #009900">unit</span> <span style="font-weight: bold"><span style="color: #000080">Unparse</span></span><span style="color: #990000">.</span>choice <span style="color: #990000">=</span>
  <span style="font-weight: bold"><span style="color: #000080">Unparse</span></span><span style="color: #990000">.</span>choice non_ll1_spec
    <span style="color: #990000">~</span>descr<span style="color: #990000">:</span><span style="color: #FF0000">&quot;broken will always fail because of the way the spec was defined&quot;</span>
    <span style="color: #990000">~</span>f<span style="color: #990000">:</span>cp
    <span style="color: #990000">~</span>name<span style="color: #990000">:</span><span style="color: #FF0000">&quot;cp_non_ll1&quot;</span>
</tt></pre>
<h2>Simple command line parsing with flags</h2>
Specifications for flags with no arguments match simple boolean values; iff the flag is present on the command the specification evaluates to <tt>true</tt> when parsing.
<pre><tt>
<span style="font-weight: bold"><span style="color: #0000FF">let</span></span> basic_flag_fun <span style="color: #990000">:</span> <span style="color: #009900">bool</span> <span style="color: #990000">-&gt;</span> <span style="color: #009900">bool</span> <span style="color: #990000">-&gt;</span> <span style="color: #009900">string</span> <span style="color: #990000">-&gt;</span> <span style="color: #009900">string</span> <span style="color: #009900">list</span> <span style="color: #990000">-&gt;</span> <span style="color: #009900">unit</span> <span style="color: #990000">=</span>
  <span style="font-weight: bold"><span style="color: #0000FF">fun</span></span> recursive force dst src <span style="color: #990000">-&gt;</span> cp_into <span style="color: #990000">~</span>recursive <span style="color: #990000">~</span>force dst src

<span style="font-weight: bold"><span style="color: #0000FF">let</span></span> basic_flag_spec <span style="color: #990000">:</span>
    <span style="color: #990000">(</span>_<span style="color: #990000">,</span><span style="color: #009900">bool</span> <span style="color: #990000">-&gt;</span> <span style="color: #009900">bool</span> <span style="color: #990000">-&gt;</span> <span style="color: #009900">string</span> <span style="color: #990000">-&gt;</span> <span style="color: #009900">string</span> <span style="color: #009900">list</span> <span style="color: #990000">-&gt;</span> 'a<span style="color: #990000">,</span>'a<span style="color: #990000">)</span> <span style="font-weight: bold"><span style="color: #000080">Unparse</span></span><span style="color: #990000">.</span>t
    <span style="color: #990000">=</span> <span style="font-weight: bold"><span style="color: #000080">Unparse</span></span><span style="color: #990000">.(</span>
     bool_flag <span style="color: #FF0000">&quot;recursive&quot;</span> <span style="color: #990000">~</span>descr<span style="color: #990000">:</span><span style="color: #FF0000">&quot;do a recursive copy&quot;</span>
     <span style="color: #990000">++</span> bool_flag <span style="color: #FF0000">&quot;force&quot;</span> <span style="color: #990000">~</span>descr<span style="color: #990000">:</span><span style="color: #FF0000">&quot;overwrite target without warning&quot;</span>
     <span style="color: #990000">++</span> <span style="color: #009900">string</span> <span style="color: #FF0000">&quot;tgt&quot;</span>
     <span style="color: #990000">++</span> non_empty_list <span style="color: #990000">(</span><span style="color: #009900">string</span> <span style="color: #FF0000">&quot;src&quot;</span><span style="color: #990000">))</span>

<span style="font-weight: bold"><span style="color: #0000FF">let</span></span> basic_flag_choice <span style="color: #990000">=</span>
  <span style="font-weight: bold"><span style="color: #000080">Unparse</span></span><span style="color: #990000">.</span>choice basic_flag_spec
    <span style="color: #990000">~</span>f<span style="color: #990000">:</span>basic_flag_fun
    <span style="color: #990000">~</span>descr<span style="color: #990000">:</span><span style="color: #FF0000">&quot;first attempt to have flags&quot;</span>
    <span style="color: #990000">~</span>name<span style="color: #990000">:</span><span style="color: #FF0000">&quot;cp_basic_flags&quot;</span>
</tt></pre>
<h2>More flags</h2>
At this point incremental rewrites of the same code are getting a bit tedious so I will introduce two concepts at once:
<dl><dt class="hdlist1">
Non-boolean flags
</dt><dd> will evaluate to <tt>Some</tt> of a value when the flag is specified on the command line, This value can be produced by a specification that consumes an element from the command line</dd>
<dt class="hdlist1">Choice between flags
</dt><dd>When put between two flags (<tt>&lt;!&gt;</tt>) this operator will return the value attached to the last flag specified on the command line. It can be chained used for more than two flags.</dd></dl>
<pre><tt>
<span style="font-weight: bold"><span style="color: #0000FF">let</span></span> flag_fun <span style="color: #990000">:</span> <span style="color: #009900">bool</span> <span style="color: #009900">option</span>
       <span style="color: #990000">-&gt;</span> <span style="color: #009900">bool</span> <span style="color: #009900">option</span>
       <span style="color: #990000">-&gt;</span> <span style="color: #009900">string</span>
       <span style="color: #990000">-&gt;</span> <span style="color: #009900">string</span> <span style="color: #009900">list</span>
       <span style="color: #990000">-&gt;</span> <span style="color: #009900">unit</span> <span style="color: #990000">=</span>
  <span style="font-weight: bold"><span style="color: #0000FF">fun</span></span> recursive force dst src <span style="color: #990000">-&gt;</span> cp_into <span style="color: #990000">?</span>recursive <span style="color: #990000">?</span>force dst src

<span style="font-weight: bold"><span style="color: #0000FF">let</span></span> recursive_flag_spec <span style="color: #990000">:</span> <span style="color: #990000">(</span>_<span style="color: #990000">,</span><span style="color: #009900">bool</span> <span style="color: #009900">option</span> <span style="color: #990000">-&gt;</span> 'a<span style="color: #990000">,</span>  'a<span style="color: #990000">)</span> <span style="font-weight: bold"><span style="color: #000080">Unparse</span></span><span style="color: #990000">.</span>t <span style="color: #990000">=</span>
  <span style="font-weight: bold"><span style="color: #000080">Unparse</span></span><span style="color: #990000">.(</span>
    flag <span style="color: #FF0000">&quot;recursive&quot;</span> <span style="color: #990000">~</span>descr<span style="color: #990000">:</span><span style="color: #FF0000">&quot;do a recursive copy&quot;</span> <span style="color: #990000">(</span>const <span style="font-weight: bold"><span style="color: #0000FF">true</span></span><span style="color: #990000">)</span>
    <span style="color: #990000">&lt;!&gt;</span> flag <span style="color: #FF0000">&quot;no-recursive&quot;</span> <span style="color: #990000">~</span>descr<span style="color: #990000">:</span><span style="color: #FF0000">&quot;&quot;</span> <span style="color: #990000">(</span>const <span style="font-weight: bold"><span style="color: #0000FF">false</span></span><span style="color: #990000">))</span>

<span style="font-weight: bold"><span style="color: #0000FF">let</span></span> force_flag_spec <span style="color: #990000">:</span> <span style="color: #990000">(</span>_<span style="color: #990000">,</span><span style="color: #009900">bool</span> <span style="color: #009900">option</span> <span style="color: #990000">-&gt;</span> 'a<span style="color: #990000">,</span>  'a<span style="color: #990000">)</span> <span style="font-weight: bold"><span style="color: #000080">Unparse</span></span><span style="color: #990000">.</span>t <span style="color: #990000">=</span>
  <span style="font-weight: bold"><span style="color: #000080">Unparse</span></span><span style="color: #990000">.(</span>
   flag <span style="color: #FF0000">&quot;force&quot;</span> <span style="color: #990000">~</span>descr<span style="color: #990000">:</span><span style="color: #FF0000">&quot;overwrite target without warning&quot;</span> <span style="color: #990000">(</span>const <span style="font-weight: bold"><span style="color: #0000FF">true</span></span><span style="color: #990000">)</span>
   <span style="color: #990000">&lt;!&gt;</span> flag <span style="color: #FF0000">&quot;no-force&quot;</span> <span style="color: #990000">~</span>descr<span style="color: #990000">:</span><span style="color: #FF0000">&quot;&quot;</span> <span style="color: #990000">(</span>const <span style="font-weight: bold"><span style="color: #0000FF">false</span></span><span style="color: #990000">))</span>

<span style="font-weight: bold"><span style="color: #0000FF">let</span></span> flag_spec <span style="color: #990000">:</span>
    <span style="color: #990000">(</span>_<span style="color: #990000">,</span><span style="color: #009900">bool</span> <span style="color: #009900">option</span>
       <span style="color: #990000">-&gt;</span> <span style="color: #009900">bool</span> <span style="color: #009900">option</span>
       <span style="color: #990000">-&gt;</span> <span style="color: #009900">string</span>
       <span style="color: #990000">-&gt;</span> <span style="color: #009900">string</span> <span style="color: #009900">list</span>
       <span style="color: #990000">-&gt;</span> 'a<span style="color: #990000">,</span>  'a<span style="color: #990000">)</span> <span style="font-weight: bold"><span style="color: #000080">Unparse</span></span><span style="color: #990000">.</span>t <span style="color: #990000">=</span>
  <span style="font-weight: bold"><span style="color: #000080">Unparse</span></span><span style="color: #990000">.</span>
    <span style="color: #990000">(</span>recursive_flag_spec
     <span style="color: #990000">++</span> force_flag_spec
     <span style="color: #990000">++</span> <span style="color: #009900">string</span> <span style="color: #FF0000">&quot;tgt&quot;</span>
     <span style="color: #990000">++</span> non_empty_list <span style="color: #990000">(</span><span style="color: #009900">string</span> <span style="color: #FF0000">&quot;src&quot;</span><span style="color: #990000">))</span>

<span style="font-weight: bold"><span style="color: #0000FF">let</span></span> flag_choice <span style="color: #990000">:</span> <span style="color: #009900">unit</span> <span style="font-weight: bold"><span style="color: #000080">Unparse</span></span><span style="color: #990000">.</span>choice <span style="color: #990000">=</span>
  <span style="font-weight: bold"><span style="color: #000080">Unparse</span></span><span style="color: #990000">.</span>choice flag_spec
    <span style="color: #990000">~</span>f<span style="color: #990000">:</span>flag_fun
    <span style="color: #990000">~</span>descr<span style="color: #990000">:</span><span style="color: #FF0000">&quot;first attempt to have flags&quot;</span>
    <span style="color: #990000">~</span>name<span style="color: #990000">:</span><span style="color: #FF0000">&quot;cp_into_with_flags&quot;</span>
</tt></pre>
<h2>Labelling arguments of the called function</h2>
What we did above in order to call the function is that we mapped the function we were calling. This is still not a very satisfying solution because we would like to specify those labels locally when we define the spec. This is made possible by the interface which allows us to map the accumulator function locally.
<pre><tt><span style="font-weight: bold"><span style="color: #0000FF">let</span></span> final_spec <span style="color: #990000">:</span>
    <span style="color: #990000">(</span>_<span style="color: #990000">,?</span>recursive<span style="color: #990000">:</span><span style="color: #009900">bool</span> <span style="color: #990000">-&gt;</span>
      <span style="color: #990000">?</span>force<span style="color: #990000">:</span><span style="color: #009900">bool</span> <span style="color: #990000">-&gt;</span>
      <span style="color: #009900">string</span> <span style="color: #990000">-&gt;</span>
      <span style="color: #009900">string</span> <span style="color: #009900">list</span>
      <span style="color: #990000">-&gt;</span> 'a<span style="color: #990000">,</span>  'a<span style="color: #990000">)</span> <span style="font-weight: bold"><span style="color: #000080">Unparse</span></span><span style="color: #990000">.</span>t
    <span style="color: #990000">=</span>
  <span style="font-weight: bold"><span style="color: #000080">Unparse</span></span><span style="color: #990000">.(</span>
    mapf <span style="color: #990000">~</span>f<span style="color: #990000">:(</span><span style="font-weight: bold"><span style="color: #0000FF">fun</span></span> f v <span style="color: #990000">-&gt;</span> f <span style="color: #990000">?</span>recursive<span style="color: #990000">:</span>v<span style="color: #990000">)</span>
      <span style="color: #990000">(</span>flag <span style="color: #FF0000">&quot;recursive&quot;</span> <span style="color: #990000">~</span>descr<span style="color: #990000">:</span><span style="color: #FF0000">&quot;do a recursive copy&quot;</span> <span style="color: #990000">(</span>const <span style="font-weight: bold"><span style="color: #0000FF">true</span></span><span style="color: #990000">))</span>
    <span style="color: #990000">++</span> mapf <span style="color: #990000">~</span>f<span style="color: #990000">:(</span><span style="font-weight: bold"><span style="color: #0000FF">fun</span></span> f v <span style="color: #990000">-&gt;</span> f <span style="color: #990000">?</span>force<span style="color: #990000">:</span>v<span style="color: #990000">)</span>
          <span style="color: #990000">(</span>flag <span style="color: #FF0000">&quot;force&quot;</span> <span style="color: #990000">~</span>descr<span style="color: #990000">:</span><span style="color: #FF0000">&quot;overwrite target without warning&quot;</span> <span style="color: #990000">(</span>const <span style="font-weight: bold"><span style="color: #0000FF">true</span></span><span style="color: #990000">))</span>
    <span style="color: #990000">++</span> <span style="color: #009900">string</span> <span style="color: #FF0000">&quot;tgt&quot;</span>
    <span style="color: #990000">++</span> non_empty_list <span style="color: #990000">(</span><span style="color: #009900">string</span> <span style="color: #FF0000">&quot;src&quot;</span><span style="color: #990000">))</span>

<span style="font-weight: bold"><span style="color: #0000FF">let</span></span> final_choice <span style="color: #990000">:</span> <span style="color: #009900">unit</span> <span style="font-weight: bold"><span style="color: #000080">Unparse</span></span><span style="color: #990000">.</span>choice  <span style="color: #990000">=</span>
  <span style="font-weight: bold"><span style="color: #000080">Unparse</span></span><span style="color: #990000">.</span>choice final_spec
    <span style="color: #990000">~</span>descr<span style="color: #990000">:</span><span style="color: #FF0000">&quot;Our last example function&quot;</span>
    <span style="color: #990000">~</span>f<span style="color: #990000">:</span>cp_into
    <span style="color: #990000">~</span>name<span style="color: #990000">:</span><span style="color: #FF0000">&quot;cp_final&quot;</span>
</tt></pre>
<h2>Tying it all together</h2>
All we need to make that command line interface is to actually tie all those commands (i.e. `choice`s) we&rsquo;ve defined together.

<pre><tt><span style="font-weight: bold"><span style="color: #0000FF">let</span></span> <span style="color: #990000">()</span> <span style="color: #990000">=</span>
  <span style="font-weight: bold"><span style="color: #000080">Unparse</span></span><span style="color: #990000">.</span>multi_run <span style="color: #990000">[</span>
    basic_choice<span style="color: #990000">;</span>
    non_ll1_choice<span style="color: #990000">;</span>
    basic_flag_choice<span style="color: #990000">;</span>
    flag_choice<span style="color: #990000">;</span>
    final_choice
  <span style="color: #990000">]</span></tt></pre>
<h2>Conclusion</h2>
This is only a quick introduction to how this library can be used. If you want to understand what makes that library tick I invite you to read Olivier Danvy excellent article on functional unparsing.
Hacks like this one might seem as a purely academical exercise to some but getting familiar with tricks like the ones used here makes them cheaper to use and, in the long run, a sound investment. Argument parsing is a small enough problem that allows us to demonstrate those techniques.
