module Kind = struct
  type t = [ `Compiler ] [@@deriving show { with_path = false }]

  let of_string = function
    | "compiler" -> Ok `Compiler
    | s -> Error (`Msg ("Unknown release type: " ^ s))

  let of_yaml = Utils.of_yaml of_string "Expected a string for release type"
end

type metadata = {
  kind : Kind.t;
  version : string;
  date : string;
  is_latest : bool option;
  is_lts : bool option;
  intro : string;
  highlights : string;
}
[@@deriving of_yaml]

type t = {
  kind : Kind.t;
  version : string;
  date : string;
  is_latest : bool option;
  is_lts : bool option;
  intro_md : string;
  intro_html : string;
  highlights_md : string;
  highlights_html : string;
  body_md : string;
  body_html : string;
}
[@@deriving
  stable_record ~version:metadata ~add:[ intro; highlights ]
    ~remove:
      [
        intro_md; intro_html; highlights_md; highlights_html; body_md; body_html;
      ],
    show { with_path = false }]

let of_metadata m =
  of_metadata m ~intro_md:m.intro
    ~intro_html:
      (Cmarkit.Doc.of_string ~strict:true m.intro
      |> Cmarkit_html.of_doc ~safe:true)
    ~highlights_md:m.highlights
    ~highlights_html:
      (Cmarkit.Doc.of_string ~strict:true m.highlights
      |> Hilite.Md.transform
      |> Cmarkit_html.of_doc ~safe:false)

let sort_by_decreasing_version x y =
  let to_list s = List.map int_of_string_opt @@ String.split_on_char '.' s in
  compare (to_list y.version) (to_list x.version)

let decode (_, (head, body_md)) =
  let metadata = metadata_of_yaml head in
  let body_html =
    Cmarkit.Doc.of_string ~strict:true body_md |> Hilite.Md.transform |> Cmarkit_html.of_doc ~safe:false
  in
  Result.map (of_metadata ~body_md ~body_html) metadata

let all () =
  Utils.map_files decode "releases/" |> List.sort sort_by_decreasing_version

let template () =
  let all = all () in
  let latest =
    try List.find (fun r -> r.is_latest = Some true) all
    with Not_found ->
      raise
        (Invalid_argument
           "none of the releases in data/releases is marked with is_latest: \
            true")
  in
  let lts =
    try List.find (fun r -> r.is_lts = Some true) all
    with Not_found ->
      raise
        (Invalid_argument
           "none of the releases in data/releases is marked with is_lts: true")
  in
  Format.asprintf
    {|
type kind = [ `Compiler ]

type t =
  { kind : kind
  ; version : string
  ; date : string
  ; is_latest: bool option
  ; is_lts: bool option
  ; intro_md : string
  ; intro_html : string
  ; highlights_md : string
  ; highlights_html : string
  ; body_md : string
  ; body_html : string
  }
  
let all = %a
let latest = %a
let lts = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    all pp latest pp lts
