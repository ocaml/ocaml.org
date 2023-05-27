---
title: Dijkstra's algorithm
description: Shortest Path            This article assumes familiarity with Dijkstra's
  shortest path algorithm. For a refresher, see [1]. T...
url: http://blog.shaynefletcher.org/2018/05/dijkstras-algorithm.html
date: 2018-05-20T18:26:00-00:00
preview_image:
featured:
authors:
- Shayne Fletcher
---


<html>
  <head>
    
    <title>Shortest Path</title>
  </head>
  <body>
    <p>This article assumes familiarity with Dijkstra's shortest path algorithm. For a refresher, see [1]. The code assumes <code class="code">open Core</code> is in effect and is online <a href="https://github.com/shayne-fletcher/zen/tree/master/ocaml/dijkstra">here</a>.
    </p>
    <p>The first part of the program organizes our thoughts about what we are setting out to compute. The signature summarizes the notion (for our purposes) of a graph definition in modular form. A module implementing this signature defines a type <code class="code">vertex_t</code> for vertices, a type <code class="code">t</code> for graphs and type <code class="code">extern_t</code> : a representation of a <code class="code">t</code> for interaction between an implemening module and its &quot;outside world&quot;.
</p><pre><code class="code"><span class="keyword">module</span> <span class="keyword">type</span> <span class="constructor">Graph_sig</span> = <span class="keyword">sig</span>
  <span class="keyword">type</span> vertex_t [@@deriving sexp]
  <span class="keyword">type</span> t [@@deriving sexp]
  <span class="keyword">type</span> extern_t

  <span class="keyword">type</span> load_error = [ <span class="keywordsign">`</span><span class="constructor">Duplicate_vertex</span> <span class="keyword">of</span> vertex_t ] [@@deriving sexp]
  <span class="keyword">exception</span> <span class="constructor">Load_error</span> <span class="keyword">of</span> load_error [@@deriving sexp]

  <span class="keyword">val</span> of_adjacency : extern_t <span class="keywordsign">-&gt;</span> [ <span class="keywordsign">`</span><span class="constructor">Ok</span> <span class="keyword">of</span> t <span class="keywordsign">|</span> <span class="keywordsign">`</span><span class="constructor">Load_error</span> <span class="keyword">of</span> load_error ]
  <span class="keyword">val</span> to_adjacency : t <span class="keywordsign">-&gt;</span> extern_t

  <span class="keyword">module</span> <span class="constructor">Dijkstra</span> : <span class="keyword">sig</span>
    <span class="keyword">type</span> state

    <span class="keyword">type</span> error = [
      <span class="keywordsign">|</span> <span class="keywordsign">`</span><span class="constructor">Relax</span> <span class="keyword">of</span> vertex_t
    ] [@@deriving sexp]
    <span class="keyword">exception</span> <span class="constructor">Error</span> <span class="keyword">of</span> error [@@deriving sexp]

    <span class="keyword">val</span> dijkstra : vertex_t <span class="keywordsign">-&gt;</span> t <span class="keywordsign">-&gt;</span> [ <span class="keywordsign">`</span><span class="constructor">Ok</span> <span class="keyword">of</span> state <span class="keywordsign">|</span> <span class="keywordsign">`</span><span class="constructor">Error</span> <span class="keyword">of</span> error ]
    <span class="keyword">val</span> d : state <span class="keywordsign">-&gt;</span> (vertex_t * float) list
    <span class="keyword">val</span> shortest_paths : state <span class="keywordsign">-&gt;</span> (vertex_t * vertex_t list) list
  <span class="keyword">end</span>

<span class="keyword">end</span>
</code></pre>A realization of <code class="code">Graph_sig</code> provides &quot;conversion&quot; functions <code class="code">of_adjacency</code>/<code class="code">to_adjacency</code> between the types <code class="code">extern_t</code> and <code class="code">t</code> and nests a module <code class="code">Dijkstra</code>. The signature of the sub-module <code class="code">Dijkstra</code> requires concrete modules provide a type <code class="code">state</code> and an implementation of Dijkstra's algorithm in terms of the function signature <code class="code">val dijkstra : vertex_t -&gt; t -&gt; [ `Ok of state | `Error of error ]</code>.
    
    <p>For reusability, the strategy for implementing graphs will be generic programming via functors over modules implementing s vertex type.</p>
    <p>An implementation of the module type <code class="code">GRAPH</code> defines a module type <code class="code">VERT</code> which is required to provide a comparable type <code class="code">t</code>. It further defines a module type <code class="code">S</code> that is exactly module type <code class="code">Graph_sig</code> above. Lastly, modules of type <code class="code">GRAPH</code> provide a functor <code class="code">Make</code> that maps any module of type <code class="code">VERT</code> to new module of type <code class="code">S</code> fixing <code class="code">extern_t</code> to an adjacency list representation in terms of the native OCaml type <code class="code">'a list</code> and <code class="code">float</code> to represent weights on edges.
</p><pre><code class="code"><span class="keyword">module</span> <span class="keyword">type</span> <span class="constructor">GRAPH</span> = <span class="keyword">sig</span>
  <span class="keyword">module</span> <span class="keyword">type</span> <span class="constructor">VERT</span> = <span class="keyword">sig</span>
    <span class="keyword">type</span> t[@@deriving sexp]
    <span class="keyword">include</span> <span class="constructor">Comparable</span>.<span class="constructor">S</span> <span class="keyword">with</span> <span class="keyword">type</span> t := t
  <span class="keyword">end</span>

  <span class="keyword">module</span> <span class="keyword">type</span> <span class="constructor">S</span> = <span class="keyword">sig</span>
    <span class="keyword">include</span> <span class="constructor">Graph_sig</span>
  <span class="keyword">end</span>

  <span class="keyword">module</span> <span class="constructor">Make</span> : <span class="keyword">functor</span> (<span class="constructor">V</span> : <span class="constructor">VERT</span>) <span class="keywordsign">-&gt;</span>
    <span class="constructor">S</span> <span class="keyword">with</span> <span class="keyword">type</span> vertex_t = <span class="constructor">V</span>.t
       <span class="keyword">and</span> <span class="keyword">type</span> extern_t = (<span class="constructor">V</span>.t * (<span class="constructor">V</span>.t * float) list) list
<span class="keyword">end</span>
</code></pre>
The two module types <code class="code">Graph_sig</code> and <code class="code">GRAPH</code> together provide the specification for the program. <code class="code">module Graph</code> in the next section implements this specification.
    
    <p>Implementation of module <code class="code">Graph</code> is in outline this.
</p><pre><code class="code"><span class="keyword">module</span> <span class="constructor">Graph</span> : <span class="constructor">GRAPH</span> = <span class="keyword">struct</span>
  <span class="keyword">module</span> <span class="keyword">type</span> <span class="constructor">VERT</span> = <span class="keyword">sig</span>
    <span class="keyword">type</span> t[@@deriving sexp]
    <span class="keyword">include</span> <span class="constructor">Comparable</span>.<span class="constructor">S</span> <span class="keyword">with</span> <span class="keyword">type</span> t := t
  <span class="keyword">end</span>

  <span class="keyword">module</span> <span class="keyword">type</span> <span class="constructor">S</span> = <span class="keyword">sig</span>
    <span class="keyword">include</span> <span class="constructor">Graph_sig</span>
  <span class="keyword">end</span>

  <span class="keyword">module</span> <span class="constructor">Make</span> : <span class="keyword">functor</span> (<span class="constructor">V</span> : <span class="constructor">VERT</span>) <span class="keywordsign">-&gt;</span>
    <span class="constructor">S</span> <span class="keyword">with</span> <span class="keyword">type</span> vertex_t = <span class="constructor">V</span>.t
       <span class="keyword">and</span> <span class="keyword">type</span> extern_t = (<span class="constructor">V</span>.t * (<span class="constructor">V</span>.t * float) list) list
    =

    <span class="keyword">functor</span> (<span class="constructor">V</span> : <span class="constructor">VERT</span>) <span class="keywordsign">-&gt;</span> <span class="keyword">struct</span>
       ...
    <span class="keyword">end</span>
<span class="keyword">end</span>
</code></pre>
As per the requirements of <code class="code">GRAPH</code> the module types <code class="code">VERT</code> and <code class="code">S</code> are provided as is the functor <code class="code">Make</code>. It is the code that is ellided by the <code class="code">...</code> above in the definition of <code class="code">Make</code> that is now the focus.
    
    <p>Modules produced by applications of <code class="code">Make</code> satisfy <code class="code">S</code>. This requires suitable definitions of types <code class="code">vertext_t</code>, <code class="code">t</code> and <code class="code">extern_t</code>. The modules <code class="code">Map</code> and <code class="code">Set</code> are available due to modules of type <code class="code">VERT</code> being comparable in their type <code class="code">t</code>.
</p><pre><code class="code">      <span class="keyword">module</span> <span class="constructor">Map</span> = <span class="constructor">V</span>.<span class="constructor">Map</span>
      <span class="keyword">module</span> <span class="constructor">Set</span> = <span class="constructor">V</span>.<span class="constructor">Set</span>

      <span class="keyword">type</span> vertex_t = <span class="constructor">V</span>.t [@@deriving sexp]
      <span class="keyword">type</span> t = (vertex_t * float) list <span class="constructor">Map</span>.t [@@deriving sexp]
      <span class="keyword">type</span> extern_t = (vertex_t * (vertex_t * float) list) list
      <span class="keyword">type</span> load_error = [ <span class="keywordsign">`</span><span class="constructor">Duplicate_vertex</span> <span class="keyword">of</span> vertex_t ] [@@deriving sexp]
      <span class="keyword">exception</span> <span class="constructor">Load_error</span> <span class="keyword">of</span> load_error [@@deriving sexp]
</code></pre>
    
    <p>While the external representation <code class="code">extern_t</code> of graphs is chosen to be an adjacency list representation in terms of association lists, the internal representation <code class="code">t</code> is a vertex map of adjacency lists providing logarithmic loookup complexity. The conversion functions between the two representations &quot;come for free&quot; via module <code class="code">Map</code>.

</p><pre><code class="code">      <span class="keyword">let</span> to_adjacency g = <span class="constructor">Map</span>.to_alist g

      <span class="keyword">let</span> of_adjacency_exn l =  <span class="keyword">match</span> <span class="constructor">Map</span>.of_alist l <span class="keyword">with</span>
        <span class="keywordsign">|</span> <span class="keywordsign">`</span><span class="constructor">Ok</span> t <span class="keywordsign">-&gt;</span> t
        <span class="keywordsign">|</span> <span class="keywordsign">`</span><span class="constructor">Duplicate_key</span> c <span class="keywordsign">-&gt;</span> raise (<span class="constructor">Load_error</span> (<span class="keywordsign">`</span><span class="constructor">Duplicate_vertex</span> c))

      <span class="keyword">let</span> of_adjacency l =
        <span class="keyword">try</span>
          <span class="keywordsign">`</span><span class="constructor">Ok</span> (of_adjacency_exn l)
        <span class="keyword">with</span>
        <span class="keywordsign">|</span> <span class="constructor">Load_error</span> err <span class="keywordsign">-&gt;</span> <span class="keywordsign">`</span><span class="constructor">Load_error</span> err
</code></pre>
    
<p>At this point the &quot;scaffolding&quot; for Dijkstra's algorithm, that part of <code class="code">GRAPH</code> dealing with the representation of graphs is implemented.</p>
<p>The interpretation of Dijkstra's algorithm we adopt is functional : the idea is we loop over vertices relaxing their edges until all shortest paths are known. What we know on any recursive iteration of the loop is a current &quot;state&quot; (of the computation) and each iteration produces a new state. This next definition is the formal definition of <code class="code">type state</code>.
</p><pre><code class="code">      <span class="keyword">module</span> <span class="constructor">Dijkstra</span> = <span class="keyword">struct</span>

        <span class="keyword">type</span> state = {
          src    :                  vertex_t
        ; g      :                         t
        ; d      :               float <span class="constructor">Map</span>.t
        ; pred   :            vertex_t <span class="constructor">Map</span>.t
        ; s      :                     <span class="constructor">Set</span>.t
        ; v_s    : (vertex_t * float) <span class="constructor">Heap</span>.t
        }
</code></pre>
The fields of this record are:
<ul><li><code class="code">src : vertex_t</code>, the source vertex;</li>
<li><code class="code">g : t</code>, <i>G</i> the graph;</li>
<li><code class="code">d : float Map.t</code>, <i>d</i> the shortest path weight estimates;</li>
<li><code class="code">pre : vertex_t Map.t</code>, <i>&pi;</i> the predecessor relation;</li>
<li><code class="code">s : Set.t</code>, the set <i>S</i> of nodes for which the lower bound shortest path weight is known;</li>
<li><code class="code">v_s : (vertex_t * float) Heap.t</code>, <i>V - {S}, </i> , the set of nodes of <code class="code">g</code> for which the lower bound of the shortest path weight is not yet known ordered on their estimates.</li>
</ul>
<p>Function invocation <code class="code">init src g</code> compuates an initial state for the graph <code class="code">g</code> containing the source node <code class="code">src</code>. In the initial state, <code class="code">d</code> is everywhere <i>&infin;</i> except for <code class="code">src</code> which is <i>0</i>. Set <i>S</i> (i.e. <code class="code">s</code>) and the predecessor relation <i>&pi;</i> (i.e. <code class="code">pred</code>) are empty and the set <i>V - {S}</i> (i.e. <code class="code">v_s</code>) contains all nodes.
</p><pre><code class="code">        <span class="keyword">let</span> init src g =
          <span class="keyword">let</span> init x = <span class="keyword">match</span> <span class="constructor">V</span>.equal src x <span class="keyword">with</span>
            <span class="keywordsign">|</span> <span class="keyword">true</span> <span class="keywordsign">-&gt;</span> 0.0 <span class="keywordsign">|</span> <span class="keyword">false</span> <span class="keywordsign">-&gt;</span> <span class="constructor">Float</span>.infinity <span class="keyword">in</span>
          <span class="keyword">let</span> d = <span class="constructor">List</span>.fold (<span class="constructor">Map</span>.keys g) ~init:<span class="constructor">Map</span>.empty
              ~f:(<span class="keyword">fun</span> acc x <span class="keywordsign">-&gt;</span> <span class="constructor">Map</span>.set acc ~key:x ~data:(init x)) <span class="keyword">in</span>
          {
            src
          ; g
          ; s = <span class="constructor">Set</span>.empty
          ; d
          ; pred = <span class="constructor">Map</span>.empty
          ; v_s = <span class="constructor">Heap</span>.of_list (<span class="constructor">Map</span>.to_alist d)
                ~cmp:(<span class="keyword">fun</span> (_, e1) (_, e2) <span class="keywordsign">-&gt;</span> <span class="constructor">Float</span>.compare e1 e2)
          }
</code></pre>

<p>Relaxing an edge <i>(u, v)</i> with weight <i>w (u, v)</i> tests whether the shortest path to <i>v</i> so far can be improved by going through <i>u</i> and if so, updating <i>d (v)</i> and <i>&pi; (v)</i> accordingly.
</p><pre><code class="code">        <span class="keyword">type</span> error = [
          <span class="keywordsign">|</span> <span class="keywordsign">`</span><span class="constructor">Relax</span> <span class="keyword">of</span> vertex_t
        ] [@@deriving sexp]
        <span class="keyword">exception</span> <span class="constructor">Error</span> <span class="keyword">of</span> error [@@deriving sexp]

        <span class="keyword">let</span> relax state (u, v, w) =
          <span class="keyword">let</span> {d; pred; v_s; _} = state <span class="keyword">in</span>
          <span class="keyword">let</span> dv = <span class="keyword">match</span> <span class="constructor">Map</span>.find d v <span class="keyword">with</span>
            <span class="keywordsign">|</span> <span class="constructor">Some</span> dv <span class="keywordsign">-&gt;</span> dv
            <span class="keywordsign">|</span> <span class="constructor">None</span> <span class="keywordsign">-&gt;</span> raise (<span class="constructor">Error</span> (<span class="keywordsign">`</span><span class="constructor">Relax</span> v)) <span class="keyword">in</span>
          <span class="keyword">let</span> du = <span class="keyword">match</span> <span class="constructor">Map</span>.find d u <span class="keyword">with</span>
            <span class="keywordsign">|</span> <span class="constructor">Some</span> du <span class="keywordsign">-&gt;</span> du
            <span class="keywordsign">|</span> <span class="constructor">None</span> <span class="keywordsign">-&gt;</span> raise (<span class="constructor">Error</span> (<span class="keywordsign">`</span><span class="constructor">Relax</span> u)) <span class="keyword">in</span>
          <span class="keyword">if</span> dv &gt; du +. w <span class="keyword">then</span>
            <span class="keyword">let</span> dv = du +. w <span class="keyword">in</span>
            (<span class="keyword">match</span> <span class="constructor">Heap</span>.find_elt v_s ~f:(<span class="keyword">fun</span> (n, _) <span class="keywordsign">-&gt;</span> <span class="constructor">V</span>.equal n v) <span class="keyword">with</span>
            <span class="keywordsign">|</span> <span class="constructor">Some</span> tok <span class="keywordsign">-&gt;</span> ignore (<span class="constructor">Heap</span>.update v_s tok (v, dv))
            <span class="keywordsign">|</span> <span class="constructor">None</span> <span class="keywordsign">-&gt;</span> raise (<span class="constructor">Error</span> (<span class="keywordsign">`</span><span class="constructor">Relax</span> v))
            );
            { state <span class="keyword">with</span>
              d = <span class="constructor">Map</span>.change d v
                  ~f:(<span class="keyword">function</span>
                      <span class="keywordsign">|</span> <span class="constructor">Some</span> _ <span class="keywordsign">-&gt;</span> <span class="constructor">Some</span> dv
                      <span class="keywordsign">|</span> <span class="constructor">None</span> <span class="keywordsign">-&gt;</span> raise (<span class="constructor">Error</span> (<span class="keywordsign">`</span><span class="constructor">Relax</span> v))
                    )
            ; pred = <span class="constructor">Map</span>.set (<span class="constructor">Map</span>.remove pred v) ~key:v ~data:u
            }
          <span class="keyword">else</span> state
</code></pre>
Here, relaxation can result in a linear heap update operation. A better implementation might seek to avoid that.

<p>One iteration of the body of the loop of Dijkstra's algorithm consists of the node in <i>V - {S}</i> with the least shortest path weight estimate being moved to <i>S</i> and its edges relaxed.
</p><pre><code class="code">        <span class="keyword">let</span> dijkstra_exn src g =
          <span class="keyword">let</span> <span class="keyword">rec</span> loop ({s; v_s; _} <span class="keyword">as</span> state) =
            <span class="keyword">match</span> <span class="constructor">Heap</span>.is_empty v_s <span class="keyword">with</span>
            <span class="keywordsign">|</span> <span class="keyword">true</span> <span class="keywordsign">-&gt;</span> state
            <span class="keywordsign">|</span> <span class="keyword">false</span> <span class="keywordsign">-&gt;</span>
              <span class="keyword">let</span> u = fst (<span class="constructor">Heap</span>.pop_exn v_s) <span class="keyword">in</span>
              loop (
                <span class="constructor">List</span>.fold (<span class="constructor">Map</span>.find_exn g u)
                  ~init:{ state <span class="keyword">with</span> s = <span class="constructor">Set</span>.add s u }
                  ~f:(<span class="keyword">fun</span> state (v, w) <span class="keywordsign">-&gt;</span> relax state (u, v, w))
              )
          <span class="keyword">in</span> loop (init src g)

        <span class="keyword">let</span> dijkstra src g =
          <span class="keyword">try</span>
            <span class="keywordsign">`</span><span class="constructor">Ok</span> (dijkstra_exn src g)
          <span class="keyword">with</span>
          <span class="keywordsign">|</span> <span class="constructor">Error</span> err <span class="keywordsign">-&gt;</span> <span class="keywordsign">`</span><span class="constructor">Error</span> err
</code></pre>

    <p>The shortest path estimates contained by a value of <code class="code">state</code> is given by the projection <code class="code">d</code>.
</p><pre><code class="code">        <span class="keyword">let</span> d state = <span class="constructor">Map</span>.to_alist (state.d)
</code></pre>

<p>The shortest paths themselves are easily computed as,
</p><pre><code class="code">   <span class="keyword">let</span> path state n =
          <span class="keyword">let</span> <span class="keyword">rec</span> loop acc x =
            (<span class="keyword">match</span> <span class="constructor">V</span>.equal x state.src <span class="keyword">with</span>
            <span class="keywordsign">|</span> <span class="keyword">true</span> <span class="keywordsign">-&gt;</span> x :: acc
            <span class="keywordsign">|</span> <span class="keyword">false</span> <span class="keywordsign">-&gt;</span> loop (x :: acc) (<span class="constructor">Map</span>.find_exn state.pred x)
            ) <span class="keyword">in</span>
          loop [] n

        <span class="keyword">let</span> shortest_paths state =
          <span class="constructor">List</span>.map (<span class="constructor">Map</span>.keys state.g) ~f:(<span class="keyword">fun</span> n <span class="keywordsign">-&gt;</span> (n, path state n))
      <span class="keyword">end</span>
    <span class="keyword">end</span>
</code></pre>
which completes the implementation of <code class="code">Make</code>.
<p>The following program produces a concrete instance of the shortest path problem (with some evaluation output from the top-level).
</p><pre><code class="code"><span class="keyword">module</span> <span class="constructor">G</span> : <span class="constructor">Graph</span>.<span class="constructor">S</span> <span class="keyword">with</span>
  <span class="keyword">type</span> vertex_t = char <span class="keyword">and</span> <span class="keyword">type</span> extern_t = (char * (char * float) list) list
  =
  <span class="constructor">Graph</span>.<span class="constructor">Make</span> (<span class="constructor">Char</span>)

<span class="keyword">let</span> g : <span class="constructor">G</span>.t =
  <span class="keyword">match</span> <span class="constructor">G</span>.of_adjacency
          [ <span class="string">'s'</span>, [<span class="string">'u'</span>,  3.0; <span class="string">'x'</span>, 5.0]
          ; <span class="string">'u'</span>, [<span class="string">'x'</span>,  2.0; <span class="string">'v'</span>, 6.0]
          ; <span class="string">'x'</span>, [<span class="string">'v'</span>,  4.0; <span class="string">'y'</span>, 6.0; <span class="string">'u'</span>, 1.0]
          ; <span class="string">'v'</span>, [<span class="string">'y'</span>,  2.0]
          ; <span class="string">'y'</span>, [<span class="string">'v'</span>,  7.0]
          ]
  <span class="keyword">with</span>
  <span class="keywordsign">|</span> <span class="keywordsign">`</span><span class="constructor">Ok</span> g <span class="keywordsign">-&gt;</span> g
  <span class="keywordsign">|</span> <span class="keywordsign">`</span><span class="constructor">Load_error</span> e <span class="keywordsign">-&gt;</span> failwiths <span class="string">&quot;Graph load error : %s&quot;</span> e <span class="constructor">G</span>.sexp_of_load_error
;;
<span class="keyword">let</span> s = <span class="keyword">match</span> (<span class="constructor">G</span>.<span class="constructor">Dijkstra</span>.dijkstra <span class="string">'s'</span> g) <span class="keyword">with</span>
  <span class="keywordsign">|</span> <span class="keywordsign">`</span><span class="constructor">Ok</span> s <span class="keywordsign">-&gt;</span> s
  <span class="keywordsign">|</span> <span class="keywordsign">`</span><span class="constructor">Error</span> e <span class="keywordsign">-&gt;</span> failwiths <span class="string">&quot;Error : %s&quot;</span> e <span class="constructor">G</span>.<span class="constructor">Dijkstra</span>.sexp_of_error

;; <span class="constructor">G</span>.<span class="constructor">Dijkstra</span>.d s
- : (char * float) list =
[(<span class="string">'s'</span>, 0.); (<span class="string">'u'</span>, 3.); (<span class="string">'v'</span>, 9.); (<span class="string">'x'</span>, 5.); (<span class="string">'y'</span>, 11.)]

;; <span class="constructor">G</span>.<span class="constructor">Dijkstra</span>.shortest_paths s
- : (char * char list) list =
[(<span class="string">'s'</span>, [<span class="string">'s'</span>]); (<span class="string">'u'</span>, [<span class="string">'s'</span>; <span class="string">'u'</span>]); (<span class="string">'v'</span>, [<span class="string">'s'</span>; <span class="string">'u'</span>; <span class="string">'v'</span>]); (<span class="string">'x'</span>, [<span class="string">'s'</span>; <span class="string">'x'</span>]);
 (<span class="string">'y'</span>, [<span class="string">'s'</span>; <span class="string">'x'</span>; <span class="string">'y'</span>])]
</code></pre>


    <p>
    </p><hr/>
    <p>
      References:<br/>
      [1] &quot;Introduction to Algorithms&quot; Section 24.3:Dijkstra's algorithm -- Cormen et. al. (Second ed.) 2001.<br/>
    </p>
  </body>
</html>

