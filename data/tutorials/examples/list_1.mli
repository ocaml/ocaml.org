val find : ('a -> bool) -> 'a list -> 'a
(** @raise Not_found *)

val find_opt : ('a -> bool) -> 'a list -> 'a option
