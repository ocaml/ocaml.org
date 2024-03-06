---
title: Sudoku
slug: "97"
difficulty: intermediate
tags: []
description: "Solve Sudoku puzzles by filling in the missing spots with digits (1-9) in such a way that every row, column, and 3x3 square contains every number exactly once."
tutorials: [ "arrays", "mutability-imperative-control-flow" ]
---

# Solution

A simple way of resolving this is to use brute force.
The idea is to start filling with available values in each case and
test if it works.  When there is no available values, it means we
made a mistake so we go back to the last choice we made, and try a
different choice.

```ocaml
# open Printf

  module Board = struct
    type t = int array (* 9×9, row-major representation.  A value of 0
                          means undecided. *)

    let is_valid c = c >= 1

    let get (b : t) (x, y) = b.(x + y * 9)

    let get_as_string (b : t) pos =
      let i = get b pos in
      if is_valid i then string_of_int i else "."

    let with_val (b : t) (x, y) v =
      let b = Array.copy b in
      b.(x + y * 9) <- v;
      b

    let of_list l : t =
      let b = Array.make 81 0 in
      List.iteri (fun y r -> List.iteri (fun x e ->
        b.(x + y * 9) <- if e >= 0 && e <= 9 then e else 0) r) l;
      b

    let print b =
      for y = 0 to 8 do
        for x = 0 to 8 do
          printf (if x = 0 then "%s" else if x mod 3 = 0 then " | %s"
                  else "  %s")  (get_as_string b (x, y))
        done;
        if y < 8 then
          if y mod 3 = 2 then printf "\n--------+---------+--------\n"
          else printf "\n        |         |        \n"
        else printf "\n"
      done

    let available b (x, y) =
      let avail = Array.make 10 true in
      for i = 0 to 8 do
        avail.(get b (x, i)) <- false;
        avail.(get b (i, y)) <- false;
      done;
      let sq_x = x - x mod 3 and sq_y = y - y mod 3 in
      for x = sq_x to sq_x + 2 do
        for y = sq_y to sq_y + 2 do
          avail.(get b (x, y)) <- false;
        done;
      done;
      let av = ref [] in
      for i = 1 (* not 0 *) to 9 do if avail.(i) then av := i :: !av done;
      !av

    let next (x,y) = if x < 8 then (x + 1, y) else (0, y + 1)

    (** Try to fill the undecided entries. *)
    let rec fill b ((x, y) as pos) =
      if y > 8 then Some b (* filled all entries *)
      else if is_valid(get b pos) then fill b (next pos)
      else match available b pos with
           | [] -> None (* no solution *)
           | l -> try_values b pos l
    and try_values b pos = function
      | v :: l ->
         (match fill (with_val b pos v) (next pos) with
          | Some _ as res -> res
          | None -> try_values b pos l)
      | [] -> None
  end

  let sudoku b = match Board.fill b (0, 0) with
    | Some b -> b
    | None -> failwith "sudoku: no solution";;
module Board :
  sig
    type t = int array
    val is_valid : int -> bool
    val get : t -> int * int -> int
    val get_as_string : t -> int * int -> string
    val with_val : t -> int * int -> int -> int array
    val of_list : int list list -> t
    val print : t -> unit
    val available : t -> int * int -> int list
    val next : int * int -> int * int
    val fill : t -> int * int -> t option
    val try_values : t -> int * int -> int list -> t option
  end
val sudoku : Board.t -> Board.t = <fun>
```

# Statement

Sudoku puzzles go like this:

```text
   Problem statement                 Solution

    .  .  4 | 8  .  . | .  1  7      9  3  4 | 8  2  5 | 6  1  7
            |         |                      |         |
    6  7  . | 9  .  . | .  .  .      6  7  2 | 9  1  4 | 8  5  3
            |         |                      |         |
    5  .  8 | .  3  . | .  .  4      5  1  8 | 6  3  7 | 9  2  4
    --------+---------+--------      --------+---------+--------
    3  .  . | 7  4  . | 1  .  .      3  2  5 | 7  4  8 | 1  6  9
            |         |                      |         |
    .  6  9 | .  .  . | 7  8  .      4  6  9 | 1  5  3 | 7  8  2
            |         |                      |         |
    .  .  1 | .  6  9 | .  .  5      7  8  1 | 2  6  9 | 4  3  5
    --------+---------+--------      --------+---------+--------
    1  .  . | .  8  . | 3  .  6      1  9  7 | 5  8  2 | 3  4  6
            |         |                      |         |
    .  .  . | .  .  6 | .  9  1      8  5  3 | 4  7  6 | 2  9  1
            |         |                      |         |
    2  4  . | .  .  1 | 5  .  .      2  4  6 | 3  9  1 | 5  7  8
```

Every spot in the puzzle belongs to a (horizontal) row and a (vertical)
column, as well as to one single 3x3 square (which we call "square" for
short). At the beginning, some of the spots carry a single-digit number
between 1 and 9. The problem is to fill the missing spots with digits in
such a way that every number between 1 and 9 appears exactly once in
each row, in each column, and in each square.

```ocaml
# (* The board representation is not imposed.  Here "0" stands for "." *);;
```
