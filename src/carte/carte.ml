module Leaflet = Leaflet

module type Marker = sig
  type t

  val title : t -> string

  val description : t -> string

  val link : t -> string

  val latlng : t -> float * float
end

module JvMarker = struct
  type t = Jv.t

  let create ~title ~description ~link ~lat ~lng =
    Jv.obj
      [| "title", Jv.of_string title
       ; "description", Jv.of_string description
       ; "link", Jv.of_string link
       ; "latlng", Jv.of_array Jv.of_float [| lat; lng |]
      |]

  let get_string t s = Jv.get t s |> Jv.to_string

  let title t = get_string t "title"

  let description t = get_string t "description"

  let link t = get_string t "link"

  let latlng t =
    let jv = Jv.get t "latlng" in
    let arr = Jv.to_array Jv.to_float jv in
    arr.(0), arr.(1)
end

let default_latlng = Leaflet.LatLng.create ~lat:54.6627 ~lng:(-6.7135)

let default_zoom = 2

module Make (M : Marker) = struct
  let create ?opts ?icon el ms =
    let map = Leaflet.Map.create ?opts el in
    let opts =
      Leaflet.TileLayer.opts
        ~attribution:
          "&copy; <a \
           href=\"https://www.openstreetmap.org/copyright\">OpenStreetMap</a> \
           contributors"
        ()
    in
    let tile_layer =
      Leaflet.TileLayer.create
        ~opts
        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
    in
    let add_marker map m =
      let lat, lng = M.latlng m in
      let latlng = Leaflet.LatLng.create ~lat ~lng in
      let marker = Leaflet.Marker.(create ~opts:(opts ?icon ()) latlng) in
      let html =
        "<a href='"
        ^ M.link m
        ^ "'>"
        ^ M.title m
        ^ "</a>"
        ^ "<p>"
        ^ M.description m
        ^ "</p>"
      in
      let (_ : Jv.t) = Leaflet.Marker.bind_popup html marker in
      let (_ : Jv.t) = Leaflet.Marker.add_to map marker in
      ()
    in
    let map' = Leaflet.Map.add_layer map (`Tile tile_layer) in
    let map' =
      Leaflet.Map.set_view ~latlng:default_latlng ~zoom:default_zoom map'
    in
    List.iter (add_marker map') ms
end
