module Store : sig
  module type S = sig
    val create_event : Event.t -> (unit, string) result Lwt.t
    val get_events : unit -> (Event.t list, string) result Lwt.t
  end

  module In_memory : S
end

val route :
  ?store:(module Store.S) ->
  ?prefix:string ->
  ?middlewares:Dream.middleware list ->
  unit ->
  Dream.route
(** A Dream middleware that will serve the dashboard under the [prefix]
    endpoint. If prefix is not specified, it will be [/dashboard] by default. *)

val analytics : ?store:(module Store.S) -> unit -> Dream.middleware
val init : ?interval:float -> unit -> unit
