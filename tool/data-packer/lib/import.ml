(* Import module - copied from src/global/import.ml *)

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

  let is_sub_ignore_case pattern text =
    contains_s (lowercase_ascii text) (lowercase_ascii pattern)

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
        try
          while !i + sep_max <= s_max do
            if unsafe_get s !i <> unsafe_get on 0 then incr i
            else (
              k := 1;
              while
                !k <= sep_max && unsafe_get s (!i + !k) = unsafe_get on !k
              do
                incr k
              done;
              if !k <= sep_max then incr i else raise Exit)
          done;
          None
        with Exit ->
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
end

module Result = struct
  include Stdlib.Result

  let const_error e _ = Error e
  let apply f = Result.fold ~ok:Result.map ~error:const_error f
  let get_ok ~error = fold ~ok:Fun.id ~error:(fun e -> raise (error e))
  let sequential_or f g x = fold (f x) ~ok ~error:(Fun.const (g x))
end
