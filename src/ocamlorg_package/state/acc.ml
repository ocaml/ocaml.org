module Make (Elt : sig
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
