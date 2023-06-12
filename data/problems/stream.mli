val hd : 'a stream -> 'a
(** Returns the first element of a stream *)

val tl : 'a stream -> 'a stream
(** Removes the first element of a stream *)

val take : int -> 'a stream -> 'a list
(** [take n seq] returns the n first values of [seq] *)

val unfold : ('a -> 'b * 'a) -> 'a -> 'b stream
(** Similar to Seq.unfold *)

val bang : 'a -> 'a stream
(** [bang x] produces an infinitely repeating sequence of [x] values. *)

val ints : int -> int stream
(* Similar to Seq.ints *)

val map : ('a -> 'b) -> 'a stream -> 'b stream
(** Similar to List.map and Seq.map *)

val filter : ('a -> bool) -> 'a stream -> 'a stream
(** Similar to List.filter and Seq.filter *)

val iter : ('a -> unit) -> 'a stream -> 'b
(** Similar to List.iter and Seq.iter *)

val to_seq : 'a stream -> 'a Seq.t
(** Translates an ['a stream] into an ['a Seq.t] *)

val of_seq : 'a Seq.t -> 'a stream
(** Translates an ['a Seq.t] into an ['a stream]

    @raise Failure if the input sequence is finite. *)
