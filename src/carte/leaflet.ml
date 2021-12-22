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
  type opts = Jv.t

  let opts
      ?min_zoom
      ?max_zoom
      ?attribution
      ?subdomains
      ?error_title_url
      ?zoom_offset
      ?tms
      ?zoom_reverse
      ?detect_retina
      ?cross_origin
      ()
    =
    let jv = Jv.obj [||] in
    Jv.Bool.set_if_some jv "crossOrigin" cross_origin;
    Jv.Bool.set_if_some jv "detectRetina" detect_retina;
    Jv.Bool.set_if_some jv "zoomReverse" zoom_reverse;
    Jv.Bool.set_if_some jv "tms" tms;
    Jv.Int.set_if_some jv "zoomOffset" zoom_offset;
    Jv.Jstr.set_if_some jv "errorTitleUrl" (Option.map Jstr.v error_title_url);
    Jv.set_if_some
      jv
      "subdomains"
      (Option.map (Jv.of_array Jv.of_string) subdomains);
    Jv.Jstr.set_if_some jv "attribution" (Option.map Jstr.v attribution);
    Jv.Int.set_if_some jv "maxZoom" max_zoom;
    Jv.Int.set_if_some jv "minZoom" min_zoom;
    jv

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
  type opts = Jv.t

  let opts
      ?prefer_canvas
      ?attribution_control
      ?zoom_control
      ?close_popup_on_click
      ?zoom_snap
      ?zoom_delta
      ?track_resize
      ?box_zoom
      ?double_click_zoom
      ?dragging
      ?center
      ?zoom
      ?min_zoom
      ?max_zoom
      ()
    =
    let jv = Jv.obj [||] in
    Jv.Int.set_if_some jv "maxZoom" max_zoom;
    Jv.Int.set_if_some jv "minZoom" min_zoom;
    Jv.Int.set_if_some jv "zoom" zoom;
    Jv.set_if_some jv "center" center;
    Jv.Bool.set_if_some jv "dragging" dragging;
    Jv.Bool.set_if_some jv "doubleClickZoom" double_click_zoom;
    Jv.Bool.set_if_some jv "boxZoom" box_zoom;
    Jv.Bool.set_if_some jv "trackResize" track_resize;
    Jv.Int.set_if_some jv "zoomDelta" zoom_delta;
    Jv.Int.set_if_some jv "zoomSnap" zoom_snap;
    Jv.Bool.set_if_some jv "closePopupOnClick" close_popup_on_click;
    Jv.Bool.set_if_some jv "zoomControl" zoom_control;
    Jv.Bool.set_if_some jv "attributionControl" attribution_control;
    Jv.Bool.set_if_some jv "preferCanvas" prefer_canvas;
    jv

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
