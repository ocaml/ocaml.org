open Brr

module G : sig
  val l : Jv.t
  (** Global leaflet object *)
end

module Layer : sig
  (** A Layer for a map, see {{:https://leafletjs.com/reference.html#layer} the
      docs} *)
  type t

  include Jv.CONV with type t := t
end

module LatLng : sig
  (** An object for latitude and longitude *)
  type t

  include Jv.CONV with type t := t

  val create : lat:float -> lng:float -> t
  (** [create ~lat ~lng] creates a new latitude-longitude object, no checks are
      performed to make sure the provided numbers make sense. *)
end

module TileLayer : sig
  (** Options for creating a tile layer. *)
  type opts

  val opts
    :  ?min_zoom:int
    -> ?max_zoom:int
    -> ?attribution:string
    -> ?subdomains:string array
    -> ?error_title_url:string
    -> ?zoom_offset:int
    -> ?tms:bool
    -> ?zoom_reverse:bool
    -> ?detect_retina:bool
    -> ?cross_origin:bool
    -> unit
    -> opts

  (** A tile layer object *)
  type t

  include Jv.CONV with type t := t

  val create : ?opts:opts -> string -> t

  val set_url : ?no_redraw:bool -> t -> string -> unit
end

module Map : sig
  (** Map options *)
  type opts

  val opts
    :  ?prefer_canvas:bool
    -> ?attribution_control:bool
    -> ?zoom_control:bool
    -> ?close_popup_on_click:bool
    -> ?zoom_snap:int
    -> ?zoom_delta:int
    -> ?track_resize:bool
    -> ?box_zoom:bool
    -> ?double_click_zoom:bool
    -> ?dragging:bool
    -> ?center:Jv.t
    -> ?zoom:int
    -> ?min_zoom:int
    -> ?max_zoom:int
    -> unit
    -> opts

  type t

  include Jv.CONV with type t := t

  val create : ?opts:opts -> string -> t
  (** Create a new map by passing the element's id as a string *)

  val create_with_el : ?opts:opts -> El.t -> t
  (** Create a new map by passing the element *)

  val set_view : latlng:LatLng.t -> zoom:int -> t -> t
  (** Set the map's view using a {!LatLng.t} and a value for the [zoom] *)

  val add_layer : t -> [ `Layer of Layer.t | `Tile of TileLayer.t ] -> t
  (** Add a new layer to the map *)
end

module Icon : sig
  type t
  (* An Icon *)

  module Div : sig
    val create : ?class':string -> string -> t
    (** An icon created with a HTML string *)
  end
end

module Marker : sig
  (** A marker object *)
  type t

  (** Options for a markers *)
  type opts

  val opts : ?icon:Icon.t -> unit -> opts
  (** [opts ?icon ()] creates a new marker option object *)

  val create : ?opts:opts -> LatLng.t -> t
  (** [create ?opts latlng] creates a new marker with the {!LatLng.t} object *)

  val add_to : Map.t -> t -> Jv.t
  (** [add_to map marker] adds [marker] to the [map] *)

  val bind_popup : string -> t -> Jv.t
  (** [bind_popup html marker] binds the popup represented by the HTML as a
      string to the [marker] *)
end

module Control : sig
  type t

  type position =
    | TopLeft
    | TopRight
    | BottomLeft
    | BottomRight

  include Jv.CONV with type t := t

  val create
    :  ?position:position
    -> on_add:(Map.t -> El.t)
    -> update:(Jv.t -> unit)
    -> unit
    -> t

  val add_to : map:Map.t -> t -> t

  val remove : t -> unit
end
