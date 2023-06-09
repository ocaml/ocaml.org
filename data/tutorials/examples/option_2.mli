val get : 'a t -> 'a
val value : 'a t -> default:'a -> 'a
val fold : none:'a -> some:('b -> 'a) -> 'b t -> 'a
