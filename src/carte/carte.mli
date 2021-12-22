(** Partial bindings to {{:https://leafletjs.com/} Leaflet.js} *)
module Leaflet = Leaflet

module type Marker = sig
  (** A marker object to be placed on a map *)
  type t

  val title : t -> string
  (** A title for the marker *)

  val description : t -> string
  (** A short description for the marker *)

  val link : t -> string
  (** A URL to use as a link on the marker *)

  val latlng : t -> float * float
  (** The latitude and longitude of the marker *)
end

(** [JvMarker] is a [Marker] that assumes a Javascript object in the shape of a
    [Marker] i.e. [{ "title": "TITLE", "description": ... }] *)
module JvMarker : sig
  include Marker with type t = Jv.t

  val create
    :  title:string
    -> description:string
    -> link:string
    -> lat:float
    -> lng:float
    -> t
end

module Make (M : Marker) : sig
  val create
    :  ?opts:Leaflet.Map.opts
    -> ?icon:Leaflet.Icon.t
    -> string
    -> M.t list
    -> unit
  (** [create ?opts element_id markers] creates a new map using [element_id] and
      with [markers] which will optionally use the provided [icon]. *)
end
