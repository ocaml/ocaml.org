---
title: Never-Ending Sequences
number: "100"
difficulty: beginner
tags: [ "seq" ]
---

# Solution

```ocaml
type 'a cons = Cons of 'a * 'a stream
and 'a stream = unit -> 'a cons

let hd (seq : 'a stream) = let (Cons (x, _)) = seq () in x
let tl (seq : 'a stream) = let (Cons (_, seq)) = seq () in seq
let rec take n seq = if n = 0 then [] else let (Cons (x, seq)) = seq () in x :: take (n - 1) seq
let rec unfold f x () = let (y, x) = f x in Cons (y, unfold f x)
let bang x = unfold (fun x -> (x, x)) x
let ints x = unfold (fun x -> (x, x + 1)) x
let rec map f seq () = let (Cons (x, seq)) = seq () in Cons (f x, map f seq)
let rec filter p seq () = let (Cons (x, seq)) = seq () in let seq = filter p seq in if p x then Cons (x, seq) else seq ()
let rec iter f seq = let (Cons (x, seq)) = seq () in f x; iter f seq
let to_seq seq = Seq.unfold (fun seq -> Some (hd seq, tl seq)) seq
let rec of_seq seq () = match seq () with
| Seq.Nil -> failwith "Not a infinite sequence"
| Seq.Cons (x, seq) -> Cons (x, of_seq seq)
```

# Statement

Lists are finite, meaning they always contain a finite number of elements. Sequences may
be finite or infinite.

The goal of this exercise is to define a type `'a stream` which only contains
infinite sequences. Using this type, define the following functions:
```ocaml
val hd : 'a stream -> 'a
(** Returns the first element of a stream *)
val tl : 'a stream -> 'a stream
(** Removes the first element of a stream *)
val take : int -> 'a stream -> 'a list
(** [take n seq] returns the n first values of [seq] *)
val unfold : ('a -> 'b * 'a) -> 'a -> 'b stream
(** Similar to Seq.unfold *)
val bang : 'a -> 'a stream
(** [bang x] produces an infinitely repeating sequence of [x] values. *)
val ints : int -> int stream
(* Similar to Seq.ints *)
val map : ('a -> 'b) -> 'a stream -> 'b stream
(** Similar to List.map and Seq.map *)
val filter: ('a -> bool) -> 'a stream -> 'a stream
(** Similar to List.filter and Seq.filter *)
val iter : ('a -> unit) -> 'a stream -> 'b
(** Similar to List.iter and Seq.iter *)
val to_seq : 'a stream -> 'a Seq.t
(** Translates an ['a stream] into an ['a Seq.t] *)
val of_seq : 'a Seq.t -> 'a stream
(** Translates an ['a Seq.t] into an ['a stream]
    @raise Failure if the input sequence is finite. *)
```
**Tip:** Use `let ... =` patterns.