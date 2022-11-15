module String = struct
  include Stdlib.String

  let contains_s s1 s2 =
    try
      let len = String.length s2 in
      for i = 0 to String.length s1 - len do
        if String.sub s1 i len = s2 then raise Exit
      done;
      false
    with Exit -> true
end

module List = struct
  include Stdlib.List

  let rec take n = function
    | _ when n = 0 -> []
    | [] -> []
    | hd :: tl -> hd :: take (n - 1) tl
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
