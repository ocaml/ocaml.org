---
title: Diagonal of a Sequence of Sequences
number: "101"
difficulty: intermediate
tags: [ "seq" ]
---

# Solution

```ocaml
let rec diag seq_seq () =
    let hds, tls = Seq.filter_map Seq.uncons seq_seq |> Seq.split in
    let hd, tl = Seq.uncons hds |> Option.map fst, Seq.uncons tls |> Option.map snd in
    let d = Option.fold ~none:Seq.empty ~some:diag tl in
    Option.fold ~none:Fun.id ~some:Seq.cons hd d ()
```

# Statement

Write a function `diag : 'a Seq.t Seq.t -> 'a Seq` that returns the _diagonal_
of a sequence of sequences. The returned sequence is formed as follows:
The first element of the returned sequence is the first element of the first
sequence; the second element of the returned sequence is the second element of
the second sequence; the third element of the returned sequence is the third
element of the third sequence; and so on.
