open Brr

module G = struct
  let l = Jv.get (Window.to_jv G.window) "L"
end

module Layer = struct
  type t = Jv.t

  include (Jv.Id : Jv.CONV with type t := t)
end

module LatLng = struct
  type t = Jv.t

  include (Jv.Id : Jv.CONV with type t := t)

  let create ~lat ~lng =
    Jv.obj [| "lat", Jv.of_float lat; "lng", Jv.of_float lng |]
end

module TileLayer = struct
  type opts_internal =
    { min_zoom : int option
    ; max_zoom : int option
    ; attribution : string option
    ; subdomains : string array option
    ; error_title_url : string option
    ; zoom_offset : int option
    ; tms : bool option
    ; zoom_reverse : bool option
    ; detect_retina : bool option
    ; cross_origin : bool option
    }
  [@@deriving brr_opt]

  type opts = Jv.t

  let opts_to_jv : opts -> Jv.t = Jv.Id.to_jv

  let opts = opts_internal_to_jv

  type t = Jv.t

  include (Jv.Id : Jv.CONV with type t := t)

  let create ?(opts = Jv.undefined) url =
    Jv.call G.l "tileLayer" [| Jv.of_string url; opts |]

  let set_url ?no_redraw t url =
    Jv.call
      t
      "setUrl"
      [| Jv.of_string url
       ; Jv.of_option ~none:Jv.undefined Jv.of_bool no_redraw
      |]
    |> ignore
end

module Map = struct
  type opt_internal =
    { prefer_canvas : bool option
    ; attribution_control : bool option
    ; zoom_control : bool option
    ; close_popup_on_click : bool option
    ; zoom_snap : int option
    ; zoom_delta : int option
    ; track_resize : bool option
    ; box_zoom : bool option
    ; double_click_zoom : bool option
    ; dragging : bool option
    ; center : Jv.t option
    ; zoom : int option
    ; min_zoom : int option
    ; max_zoom : int option
    }
  [@@deriving brr_opt]

  type opts = Jv.t

  let opts_to_jv : opts -> Jv.t = Jv.Id.to_jv

  let opts = opt_internal_to_jv

  type t = Jv.t

  include (Jv.Id : Jv.CONV with type t := t)

  let create ?(opts = Jv.undefined) el_id =
    Jv.call G.l "map" [| Jv.of_string el_id; opts |]

  let create_with_el ?(opts = Jv.undefined) el =
    Jv.call G.l "map" [| El.to_jv el; opts |]

  let add_layer t layer =
    let layer =
      match layer with
      | `Layer l ->
        Layer.to_jv l
      | `Tile l ->
        TileLayer.to_jv l
    in
    Jv.call t "addLayer" [| Layer.to_jv layer |]

  let set_view ~latlng ~zoom t =
    Jv.call t "setView" [| LatLng.to_jv latlng; Jv.of_int zoom |]
end

module Control = struct
  type t = Jv.t

  include (Jv.Id : Jv.CONV with type t := t)

  type position =
    | TopLeft
    | TopRight
    | BottomLeft
    | BottomRight

  let position_to_jstr = function
    | TopLeft ->
      Jstr.v "top-left"
    | TopRight ->
      Jstr.v "top-right"
    | BottomLeft ->
      Jstr.v "bottom-left"
    | BottomRight ->
      Jstr.v "bottom-right"

  let create ?position ~on_add ~update () =
    let args =
      match position with
      | None ->
        Jv.undefined
      | Some s ->
        Jv.of_jstr (position_to_jstr s)
    in
    let control = Jv.call G.l "control" [| args |] in
    Jv.set control "onAdd" (Jv.repr on_add);
    Jv.set control "update" (Jv.repr update);
    control

  let add_to ~map t = Jv.call t "addTo" [| Map.to_jv map |]

  let remove t = ignore @@ Jv.call t "remove" [||]
end

module Icon = struct
  type t = Jv.t

  include (Jv.Id : Jv.CONV with type t := t)

  module Div = struct
    let create ?(class' = "") html =
      let opts =
        Jv.obj [| "html", Jv.of_string html; "className", Jv.of_string class' |]
      in
      Jv.call G.l "divIcon" [| opts |]
  end
end

module Marker = struct
  type t = Jv.t

  include (Jv.Id : Jv.CONV with type t := t)

  type opts = Jv.t

  let opts ?icon () =
    let o = Jv.obj [||] in
    Jv.set_if_some o "icon" icon;
    o

  let create ?(opts = Jv.undefined) latlng =
    Jv.call G.l "marker" [| LatLng.to_jv latlng; opts |]

  let add_to map marker = Jv.call marker "addTo" [| Map.to_jv map |]

  let bind_popup html t = Jv.call t "bindPopup" [| Jv.of_string html |]
end
