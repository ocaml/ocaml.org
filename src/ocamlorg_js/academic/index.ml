open Brr
module C = Carte.Make (Carte.JvMarker)

let icon =
  Carte.Leaflet.Icon.Div.create
    ~class':"svg-marker"
    {|
  <svg width="100%" height="auto" fill="none" xmlns="http://www.w3.org/2000/svg">
    <g>
      <circle opacity="0.1" cx="12" cy="12" r="12" fill="#EE6A1A" />
      <circle opacity="0.2" cx="12" cy="12" r="10" fill="#EE6A1A" />
      <circle opacity="0.3" cx="12" cy="12" r="7" fill="#EE6A1A" />
      <circle cx="12" cy="12" r="4" fill="#EE6A1A" />
    </g>
  </svg>
|}

let markers =
  let acad_to_marker (a : Ood.Academic_institution.t) =
    match a.location with
    | Some { lat; long = lng } ->
      let m =
        Carte.JvMarker.create
          ~title:a.name
          ~description:a.description
          ~link:a.url
          ~lat
          ~lng
      in
      Some m
    | None ->
      None
  in
  List.filter_map acad_to_marker (Ood.Academic_institution.all ())

let () = C.create ~icon "map-container" markers
