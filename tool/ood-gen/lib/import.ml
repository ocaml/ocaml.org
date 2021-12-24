module Result = struct
  include Stdlib.Result

  let both a b =
    match a with
    | Error e ->
      Error e
    | Ok a ->
      (match b with Error e -> Error e | Ok b -> Ok (a, b))

  module Syntax = struct
    let ( >>= ) t f = bind t f

    let ( >>| ) t f = map f t

    let ( let* ) = ( >>= )

    let ( let+ ) = ( >>| )

    let ( and+ ) = both
  end

  open Syntax

  module List = struct
    let map f t =
      let rec loop acc = function
        | [] ->
          Ok (List.rev acc)
        | x :: xs ->
          f x >>= fun x -> loop (x :: acc) xs
      in
      loop [] t

    let all =
      let rec loop acc = function
        | [] ->
          Ok (List.rev acc)
        | t :: l ->
          t >>= fun x -> loop (x :: acc) l
      in
      fun l -> loop [] l

    let concat_map =
      let rec loop f acc = function
        | [] ->
          Ok (List.rev acc)
        | x :: l ->
          f x >>= fun y -> loop f (List.rev_append y acc) l
      in
      fun l f -> loop f [] l

    let rec iter f t =
      match t with [] -> Ok () | x :: xs -> f x >>= fun () -> iter f xs

    let rec fold_left f init t =
      match t with
      | [] ->
        Ok init
      | x :: xs ->
        f init x >>= fun init -> fold_left f init xs

    let rec iter_left f t =
      match t with [] -> Ok () | x :: xs -> f x >>= fun () -> iter_left f xs

    let filter_map t f =
      fold_left
        (fun acc x -> f x >>| function None -> acc | Some y -> y :: acc)
        []
        t
      >>| List.rev
  end
end

module String = struct
  include Stdlib.String

  let lsplit2_exn on s =
    let i = index s on in
    sub s 0 i, sub s (i + 1) (length s - i - 1)

  let lsplit2 on s = try Some (lsplit2_exn s on) with Not_found -> None

  let prefix s len = try sub s 0 len with Invalid_argument _ -> ""

  let suffix s len =
    try sub s (length s - len) len with Invalid_argument _ -> ""

  let drop_prefix s len = sub s len (length s - len)

  let drop_suffix s len = sub s 0 (length s - len)

  (* ripped off stringext, itself ripping it off from one of dbuenzli's libs *)
  let cut s ~on =
    let sep_max = length on - 1 in
    if sep_max < 0 then
      invalid_arg "Stringext.cut: empty separator"
    else
      let s_max = length s - 1 in
      if s_max < 0 then
        None
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
            if unsafe_get s !i <> unsafe_get on 0 then
              incr i
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
        with
        | Exit ->
          (* i is at the beginning of the separator *)
          let left_end = !i - 1 in
          let right_start = !i + sep_max + 1 in
          Some
            (sub s 0 (left_end + 1), sub s right_start (s_max - right_start + 1))

  let rcut s ~on =
    let sep_max = length on - 1 in
    if sep_max < 0 then
      invalid_arg "Stringext.rcut: empty separator"
    else
      let s_max = length s - 1 in
      if s_max < 0 then
        None
      else
        let k = ref 0 in
        let i = ref s_max in
        (* We run from the end of [s] to the beginning with [i] trying to match
           the last character of [on] in [s]. If this matches, we verify that
           the whole [on] is matched using [k] (we do that backwards). If it
           doesn't match we continue to look for [on] with [i]. If it matches we
           exit the loop and extract a substring from the start of [s] to the
           position before the [on] we found and another from the position after
           the [on] we found to end of string. If [i] is such that no separator
           can be found we exit the loop and return the no match case. *)
        try
          while !i >= sep_max do
            if unsafe_get s !i <> unsafe_get on sep_max then
              decr i
            else
              (* Check remaining [on] chars match, access to unsafe_get s
                 (sep_start + !k) is guaranteed by loop invariant. *)
              let sep_start = !i - sep_max in
              k := sep_max - 1;
              while
                !k >= 0 && unsafe_get s (sep_start + !k) = unsafe_get on !k
              do
                decr k
              done;
              if !k >= 0 then (* no match *) decr i else raise Exit
          done;
          None (* no match in the whole string. *)
        with
        | Exit ->
          (* i is at the end of the separator *)
          let left_end = !i - sep_max - 1 in
          let right_start = !i + 1 in
          Some
            (sub s 0 (left_end + 1), sub s right_start (s_max - right_start + 1))
end

module Glob = struct
  (* From https://github.com/simonjbeaumont/ocaml-glob *)

  let split c s =
    let len = String.length s in
    let rec loop acc last_pos pos =
      if pos = -1 then
        String.sub s 0 last_pos :: acc
      else if s.[pos] = c then
        let pos1 = pos + 1 in
        let sub_str = String.sub s pos1 (last_pos - pos1) in
        loop (sub_str :: acc) pos (pos - 1)
      else
        loop acc last_pos (pos - 1)
    in
    loop [] len (len - 1)

  (** Returns list of indices of occurances of substr in x *)
  let find_substrings ?(start_point = 0) substr x =
    let len_s = String.length substr
    and len_x = String.length x in
    let rec aux acc i =
      if len_x - i < len_s then
        acc
      else if String.sub x i len_s = substr then
        aux (i :: acc) (i + 1)
      else
        aux acc (i + 1)
    in
    aux [] start_point

  let matches_glob ~glob x =
    let rec contains_all_sections = function
      | _, [] | _, [ "" ] ->
        true
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
    contains_all_sections (0, split '*' glob)

  let matches_globs ~globs x =
    List.exists (fun glob -> matches_glob ~glob x) globs

  let filter_files ~globs files = List.filter (matches_globs ~globs) files
end

module Sys = struct
  include Stdlib.Sys

  let write_file file content =
    let oc = open_out file in
    Fun.protect
      (fun () -> output_string oc content)
      ~finally:(fun () -> close_out oc)

  let read_file file =
    let ic = open_in_bin file in
    Fun.protect
      (fun () ->
        let length = in_channel_length ic in
        really_input_string ic length)
      ~finally:(fun () -> close_in ic)
end