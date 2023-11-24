---
title: Conversions
slug: "80"
difficulty: beginner
tags: [ "graph" ]
description: "Convert from edge-clause form (a list of pairs of nodes) to graph-term form (a record with a list of nodes and a list of edges)."
---

# Solution

```ocaml
(* example pending *)
```

# Statement

![A graph](/media/problems/graph1.gif)

*A graph is defined as a set of nodes and a set of edges, where each
edge is a pair of different nodes.*

There are several ways to represent graphs in OCaml.

* One method is to list all edges, an edge being a pair of nodes. In
 this form, the graph depicted opposite is represented as the
 following expression:

```ocaml
# [('h', 'g'); ('k', 'f'); ('f', 'b'); ('f', 'c'); ('c', 'b')];;
- : (char * char) list =
[('h', 'g'); ('k', 'f'); ('f', 'b'); ('f', 'c'); ('c', 'b')]
```

We call this **edge-clause form**. Obviously, isolated nodes cannot
be represented.


* Another method is to represent the whole graph as one data object.
 According to the definition of the graph as a pair of two sets
 (nodes and edges), we may use the following OCaml type:

```ocaml
# type 'a graph_term = {nodes : 'a list;  edges : ('a * 'a) list};;
type 'a graph_term = { nodes : 'a list; edges : ('a * 'a) list; }
```

Then, the above example graph is represented by:

```ocaml
# let example_graph =
  {nodes = ['b'; 'c'; 'd'; 'f'; 'g'; 'h'; 'k'];
   edges = [('h', 'g'); ('k', 'f'); ('f', 'b'); ('f', 'c'); ('c', 'b')]};;
val example_graph : char graph_term =
  {nodes = ['b'; 'c'; 'd'; 'f'; 'g'; 'h'; 'k'];
   edges = [('h', 'g'); ('k', 'f'); ('f', 'b'); ('f', 'c'); ('c', 'b')]}
```

We call this **graph-term form**. Note, that the lists are kept
sorted, they are really sets, without duplicated elements. Each edge
appears only once in the edge list; i.e. an edge from a node x to
another node y is represented as `(x, y)`, the couple `(y, x)` is not
present. The **graph-term form is our default representation.** You
may want to define a similar type using sets instead of lists.

* A third representation method is to associate with each node the set
 of nodes that are adjacent to that node. We call this the
 **adjacency-list form**. In our example:

```ocaml
    (* example pending *)
```

* The representations we introduced so far well suited for automated
 processing, but their syntax is not very user-friendly. Typing the
 terms by hand is cumbersome and error-prone. We can define a more
 compact and "human-friendly" notation as follows: A graph (with char
 labelled nodes) is represented by a string of atoms and terms of the
 type X-Y. The atoms stand for isolated nodes, the X-Y terms describe
 edges. If an X appears as an endpoint of an edge, it is
 automatically defined as a node. Our example could be written as:

```ocaml
# "b-c f-c g-h d f-b k-f h-g";;
- : string = "b-c f-c g-h d f-b k-f h-g"
```

We call this the **human-friendly form**. As the example shows, the
list does not have to be sorted and may even contain the same edge
multiple times. Notice the isolated node `d`.

Write functions to convert between the different graph representations.
With these functions, all representations are equivalent; i.e. for the
following problems you can always pick freely the most convenient form.
This problem is not particularly difficult, but it's a lot of work to
deal with all the special cases.
