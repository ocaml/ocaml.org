type location = { lat : float; long : float }
[@@deriving of_yaml, show { with_path = false }]

type metadata = {
  title : string;
  url : string;
  textual_location : string;
  location : location option;
  starts : string;
  ends : string option;
}
[@@deriving of_yaml, show { with_path = false }]

type t = {
  title : string;
  url : string;
  slug : string;
  textual_location : string;
  location : location option;
  starts : string;
  ends : string option;
  body_md : string;
  body_html : string;
}
[@@deriving
  stable_record ~version:metadata ~remove:[ slug; body_md; body_html ],
    show { with_path = false }]

let of_metadata m = of_metadata m ~slug:(Utils.slugify m.title)

let decode (fpath, (head, body_md)) =
  let metadata = metadata_of_yaml head |> Result.map_error (Utils.where fpath) in
  let body_html =
    Cmarkit.Doc.of_string body_md |> Cmarkit_html.of_doc ~safe:true
  in
  Result.map (of_metadata ~body_md ~body_html) metadata

let all () =
  Utils.map_files decode "events/*.md"
  |> List.sort (fun e1 e2 ->
         (* Sort the events by reversed start date. *)
         String.compare e2.starts e1.starts)

let template () =
  Format.asprintf
    {|
type location = { lat : float; long : float }

type t =
  { title : string
  ; url : string
  ; slug : string
  ; textual_location : string
  ; location : location option
  ; starts : string
  ; ends : string option
  ; body_md : string
  ; body_html : string
  }

let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
