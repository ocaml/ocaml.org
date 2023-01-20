module String = struct
  include Stdlib.String

  let prefix s len = try sub s 0 len with Invalid_argument _ -> ""

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
end

module Glob = struct
  (* From https://github.com/simonjbeaumont/ocaml-glob *)

  (** Returns list of indices of occurances of substr in x *)
  let find_substrings ?(start_point = 0) substr x =
    let len_s = String.length substr and len_x = String.length x in
    let rec aux acc i =
      if len_x - i < len_s then acc
      else if String.sub x i len_s = substr then aux (i :: acc) (i + 1)
      else aux acc (i + 1)
    in
    aux [] start_point

  let matches_glob ~glob x =
    let rec contains_all_sections = function
      | _, [] | _, [ "" ] -> true
      | i, [ g ] ->
          (* need to find a match that matches to end of string *)
          find_substrings ~start_point:i g x
          |> List.exists (fun j -> j + String.length g = String.length x)
      | 0, "" :: g :: gs ->
          find_substrings g x
          |> List.exists (fun j ->
                 contains_all_sections (j + String.length g, gs))
      | i, g :: gs ->
          find_substrings ~start_point:i g x
          |> List.exists (fun j ->
                 (if i = 0 then j = 0 else true)
                 && contains_all_sections (j + String.length g, gs))
    in
    contains_all_sections (0, String.split_on_char '*' glob)
end
