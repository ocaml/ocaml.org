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
end

module List = struct
  include Stdlib.List

  let rec take n = function
    | _ when n = 0 -> []
    | [] -> []
    | hd :: tl -> hd :: take (n - 1) tl

  let rec drop i = function _ :: u when i > 0 -> drop (i - 1) u | u -> u
  let hd_opt u = try Some (hd u) with Failure _ -> None
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

module Option = struct
  include Stdlib.Option

  let filter p = function Some x when p x -> Some x | _ -> None

  let update_with x =
    let none = Some x in
    fold ~none ~some:(fun prev -> filter (( <> ) prev) none)
end

module Result = struct
  include Stdlib.Result

  let const_error e _ = Error e
  let apply f = Result.fold ~ok:Result.map ~error:const_error f
  let get_ok ~error = fold ~ok:Fun.id ~error:(fun e -> raise (error e))
  let sequential_or f g x = fold (f x) ~ok ~error:(Fun.const (g x))
end
