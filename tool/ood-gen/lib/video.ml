open Data_intf.Video

type video_list = t list [@@deriving yaml, show]

let all () = Youtube.all () @ Watch.all ()

let template () =
  Format.asprintf {ocaml|
include Data_intf.Video
let all =%a
|ocaml}
    pp_video_list (all ())

let create_entry (v : t) =
  let url = Uri.of_string v.content in
  let source : Syndic.Atom.source =
    Syndic.Atom.source ~authors:[]
      ~id:(Uri.of_string v.source_link)
      ~title:(Syndic.Atom.Text v.source_title)
      ~links:[ Syndic.Atom.link (Uri.of_string v.source_link) ]
      ?updated:None ?categories:None ?contributors:None ?generator:None
      ?icon:None ?logo:None ?rights:None ?subtitle:None
  in
  let content = Syndic.Atom.Text v.description in
  let id = url in
  let authors =
    (Syndic.Atom.author ~uri:(Uri.of_string v.author_uri) v.author_name, [])
  in
  let updated = Syndic.Date.of_rfc3339 v.published in
  Syndic.Atom.entry ~content ~source ~id ~authors
    ~title:(Syndic.Atom.Text v.title) ~updated
    ~links:[ Syndic.Atom.link id ]
    ()

let create_feed () =
  let open Rss in
  () |> all
  |> create_feed ~id:"video.xml" ~title:"OCaml Videos" ~create_entry ~span:3653
  |> feed_to_string

let scrape () =
  Youtube.scrape "data/video-youtube.yml";
  Watch.scrape "data/vide-watch.yml"
