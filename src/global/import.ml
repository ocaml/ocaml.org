module String = struct
  include Stdlib.String
  module Map = Map.Make (Stdlib.String)

  let contains_s s1 s2 =
    try
      let len = String.length s2 in
      for i = 0 to String.length s1 - len do
        if String.sub s1 i len = s2 then raise Exit
      done;
      false
    with Exit -> true

  (* ripped off stringext, itself ripping it off from one of dbuenzli's libs *)
  let cut s ~on =
    let sep_max = length on - 1 in
    if sep_max < 0 then invalid_arg "Stringext.cut: empty separator"
    else
      let s_max = length s - 1 in
      if s_max < 0 then None
      else
        let k = ref 0 in
        let i = ref 0 in
        (* We run from the start of [s] to end with [i] trying to match the
           first character of [on] in [s]. If this matches, we verify that the
           whole [on] is matched using [k]. If it doesn't match we continue to
           look for [on] with [i]. If it matches we exit the loop and extract a
           substring from the start of [s] to the position before the [on] we
           found and another from the position after the [on] we found to end of
           string. If [i] is such that no separator can be found we exit the
           loop and return the no match case. *)
        try
          while !i + sep_max <= s_max do
            (* Check remaining [on] chars match, access to unsafe s (!i + !k) is
               guaranteed by loop invariant. *)
            if unsafe_get s !i <> unsafe_get on 0 then incr i
            else (
              k := 1;
              while
                !k <= sep_max && unsafe_get s (!i + !k) = unsafe_get on !k
              do
                incr k
              done;
              if !k <= sep_max then (* no match *) incr i else raise Exit)
          done;
          None (* no match in the whole string. *)
        with Exit ->
          (* i is at the beginning of the separator *)
          let left_end = !i - 1 in
          let right_start = !i + sep_max + 1 in
          Some
            (sub s 0 (left_end + 1), sub s right_start (s_max - right_start + 1))

  (* A UTF-8 continuation byte has the form 0b10xxxxxx. A character is at most 4
     bytes long, so at most 3 continuation bytes follow its first byte. *)
  let is_utf_8_continuation c = Char.code c land 0xC0 = 0x80

  (* [utf_8_prefix s n] is the longest prefix of [s] of at most [n] bytes that
     does not end inside a UTF-8 character. *)
  let utf_8_prefix s n =
    let len = length s in
    if n >= len then s
    else
      let rec back i steps =
        if i > 0 && steps < 3 && is_utf_8_continuation (unsafe_get s i) then
          back (i - 1) (steps + 1)
        else i
      in
      let stop = if n <= 0 then 0 else back n 0 in
      sub s 0 stop

  (* [utf_8_suffix s n] is the longest suffix of [s] of at most [n] bytes that
     does not start inside a UTF-8 character. *)
  let utf_8_suffix s n =
    let len = length s in
    if n >= len then s
    else if n <= 0 then ""
    else
      let rec forward i steps =
        if i < len && steps < 3 && is_utf_8_continuation (unsafe_get s i) then
          forward (i + 1) (steps + 1)
        else i
      in
      let start = forward (len - n) 0 in
      sub s start (len - start)

  (* [utf_8_first s] is the first character of [s], or [""] if [s] is empty. An
     invalid leading sequence yields its first byte. *)
  let utf_8_first s =
    if s = "" then ""
    else sub s 0 (Uchar.utf_decode_length (get_utf_8_uchar s 0))

  (* [utf_8_length s] is the number of characters in [s]. Each invalid byte
     counts as one character. *)
  let utf_8_length s =
    let len = length s in
    let rec go i n =
      if i >= len then n
      else go (i + Uchar.utf_decode_length (get_utf_8_uchar s i)) (n + 1)
    in
    go 0 0

  let is_ascii s =
    let rec go i =
      i >= length s || (Char.code (unsafe_get s i) < 0x80 && go (i + 1))
    in
    go 0

  let add_case_map map b u =
    match map u with
    | `Self -> Buffer.add_utf_8_uchar b u
    | `Uchars us -> List.iter (Buffer.add_utf_8_uchar b) us

  (* [fold s] is the Unicode case folding of [s], for case-insensitive
     comparison: "É" and "é" both fold to "é", and "ß" folds to "ss". Invalid
     UTF-8 sequences become U+FFFD. *)
  let fold s =
    if is_ascii s then lowercase_ascii s
    else
      let len = length s in
      let b = Buffer.create len in
      let rec go i =
        if i < len then (
          let c = unsafe_get s i in
          if Char.code c < 0x80 then (
            Buffer.add_char b (Char.lowercase_ascii c);
            go (i + 1))
          else
            let d = get_utf_8_uchar s i in
            add_case_map Uucp.Case.Fold.fold b (Uchar.utf_decode_uchar d);
            go (i + Uchar.utf_decode_length d))
      in
      go 0;
      Buffer.contents b

  (* [is_sub_ignore_case pattern text] is [true] iff [pattern] occurs in [text],
     ignoring case. *)
  let is_sub_ignore_case pattern text = contains_s (fold text) (fold pattern)

  (* [fold_with_offsets s] is [(f, starts, ends)] where [f] is [fold s] and, for
     each byte [j] of [f], [starts.(j)] and [ends.(j)] are the offsets in [s] of
     the start and end of the character whose folding produced that byte. *)
  let fold_with_offsets s =
    let len = length s in
    let b = Buffer.create len in
    let starts = ref [] and ends = ref [] in
    let rec go i =
      if i < len then (
        let d = get_utf_8_uchar s i in
        let next = i + Uchar.utf_decode_length d in
        let before = Buffer.length b in
        add_case_map Uucp.Case.Fold.fold b (Uchar.utf_decode_uchar d);
        for _ = before to Buffer.length b - 1 do
          starts := i :: !starts;
          ends := next :: !ends
        done;
        go next)
    in
    go 0;
    let to_array l = Array.of_list (List.rev l) in
    (Buffer.contents b, to_array !starts, to_array !ends)

  (* [fold_split ~terms text] splits [text] into the pieces that match one of
     [terms], ignoring case, and the pieces between them. The pieces are
     substrings of [text] that never split a character, and their concatenation
     is [text]. A match that covers part of a character whose folding is several
     characters long, like "s" in "ß", covers the whole character. *)
  let fold_split ~terms text =
    match List.filter (( <> ) "") (List.map fold terms) with
    | [] -> if text = "" then [] else [ `Text text ]
    | terms ->
        let re = Re.compile (Re.alt (List.map Re.str terms)) in
        (* ASCII text folds byte for byte, so offsets are unchanged. *)
        let folded, start_of, end_of =
          if is_ascii text then (lowercase_ascii text, Fun.id, succ)
          else
            let folded, starts, ends = fold_with_offsets text in
            (folded, Array.get starts, Array.get ends)
        in
        let pieces = ref [] in
        let add_text a b =
          if b > a then pieces := `Text (sub text a (b - a)) :: !pieces
        in
        let last =
          Re.all re folded
          |> Stdlib.List.fold_left
               (fun last g ->
                 let a, b = Re.Group.offset g 0 in
                 let start = start_of a and stop = end_of (b - 1) in
                 (* Two matches inside the folding of a single character are
                    merged into the first. *)
                 if start < last then last
                 else (
                   add_text last start;
                   pieces := `Delim (sub text start (stop - start)) :: !pieces;
                   stop))
               0
        in
        add_text last (length text);
        Stdlib.List.rev !pieces

  (* [utf_8_uppercase_first s] is the first character of [s], uppercased, or
     [""] if [s] is empty. *)
  let utf_8_uppercase_first s =
    match utf_8_first s with
    | "" -> ""
    | c ->
        let b = Buffer.create 4 in
        add_case_map Uucp.Case.Map.to_upper b
          (Uchar.utf_decode_uchar (get_utf_8_uchar c 0));
        Buffer.contents b
end

module List = struct
  include Stdlib.List

  let rec take n = function
    | _ when n = 0 -> []
    | [] -> []
    | hd :: tl -> hd :: take (n - 1) tl

  let rec drop i = function _ :: u when i > 0 -> drop (i - 1) u | u -> u
end

module Acc_biggest (Elt : sig
  type t

  val compare : t -> t -> int
end) : sig
  (** Accumulate the [n] bigger elements given to [acc]. *)

  type elt = Elt.t
  type t

  val make : int -> t
  val acc : elt -> t -> t
  val to_list : t -> elt list
end = struct
  type elt = Elt.t
  type t = int * elt list

  let make size = (size, [])

  (* Insert sort is enough. *)
  let rec insert_sort elt = function
    | [] -> [ elt ]
    | hd :: _ as t when Elt.compare hd elt >= 0 -> elt :: t
    | hd :: tl -> hd :: insert_sort elt tl

  let acc elt (rem, elts) =
    let elts = insert_sort elt elts in
    if rem = 0 then (0, List.tl elts) else (rem - 1, elts)

  let to_list (_, elts) = elts
end

module Result = struct
  include Stdlib.Result

  let const_error e _ = Error e
  let apply f = Result.fold ~ok:Result.map ~error:const_error f
  let get_ok ~error = fold ~ok:Fun.id ~error:(fun e -> raise (error e))
  let sequential_or f g x = fold (f x) ~ok ~error:(Fun.const (g x))
end
