type kind = [ `Compiler ] [@@deriving show { with_path = false }]

let kind_of_string = function
  | "compiler" -> `Compiler
  | _ -> raise (Exn.Decode_error "Unknown release kind")

let kind_to_string = function `Compiler -> "compiler"

type metadata = {
  kind : string;
  version : string;
  date : string;
  intro : string;
  highlights : string;
}
[@@deriving of_yaml]

type t = {
  kind : kind;
  version : string;
  date : string;
  intro_md : string;
  intro_html : string;
  highlights_md : string;
  highlights_html : string;
  body_md : string;
  body_html : string;
}
[@@deriving
  stable_record ~version:metadata ~modify:[ kind ] ~add:[ intro; highlights ]
    ~remove:
      [
        intro_md; intro_html; highlights_md; highlights_html; body_md; body_html;
      ],
    show { with_path = false }]

let of_metadata m =
  of_metadata m ~modify_kind:kind_of_string ~intro_md:m.intro
    ~intro_html:(Omd.of_string m.intro |> Omd.to_html)
    ~highlights_md:m.highlights
    ~highlights_html:
      (Omd.of_string m.highlights |> Hilite.Md.transform |> Omd.to_html)

let sort_by_decreasing_version x y =
  let to_list s = List.map int_of_string_opt @@ String.split_on_char '.' s in
  compare (to_list y.version) (to_list x.version)

let decode (_, (head, body_md)) =
  let metadata = metadata_of_yaml head in
  let body_html = Omd.of_string body_md |> Hilite.Md.transform |> Omd.to_html in
  Result.map (of_metadata ~body_md ~body_html) metadata

let all () =
  Utils.map_files decode "releases/" |> List.sort sort_by_decreasing_version

let template () =
  Format.asprintf
    {|
type kind = [ `Compiler ]

type t =
  { kind : kind
  ; version : string
  ; date : string
  ; intro_md : string
  ; intro_html : string
  ; highlights_md : string
  ; highlights_html : string
  ; body_md : string
  ; body_html : string
  }
  
let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
