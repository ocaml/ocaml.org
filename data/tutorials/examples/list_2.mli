val find_exn : ('a -> bool) -> 'a list -> 'a
(** @raise Not_found *)

val find : ('a -> bool) -> 'a list -> 'a option
