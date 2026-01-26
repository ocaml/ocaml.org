(* Release parser - adapted from ood-gen/lib/release.ml *)

open Import

type kind = [%import: Data_intf.Release.kind] [@@deriving show]

let kind_of_string = function
  | "compiler" -> Ok `Compiler
  | s -> Error (`Msg ("Unknown release type: " ^ s))

let kind_of_yaml = function
  | `String s -> kind_of_string s
  | _ -> Error (`Msg "Expected a string for release type")

type t = [%import: Data_intf.Release.t] [@@deriving show]

type metadata = {
  kind : kind;
  version : string;
  date : string;
  is_latest : bool option;
  is_lts : bool option;
  intro : string;
  highlights : string;
}
[@@deriving
  of_yaml,
    stable_record ~version:t ~remove:[ intro; highlights ]
      ~modify:[ is_latest; is_lts ]
      ~add:[ intro_md; intro_html; highlights_md; highlights_html; body_md; body_html ]]

let of_metadata m =
  metadata_to_t m ~intro_md:m.intro
    ~intro_html:(m.intro |> Markdown.Content.of_string |> Markdown.Content.render)
    ~highlights_md:m.highlights
    ~highlights_html:
      (m.highlights |> Markdown.Content.of_string
      |> Markdown.Content.render ~syntax_highlighting:true)
    ~modify_is_latest:(Option.value ~default:false)
    ~modify_is_lts:(Option.value ~default:false)

let sort_by_decreasing_version (x : t) (y : t) =
  let to_list s = List.map int_of_string_opt @@ Stdlib.String.split_on_char '.' s in
  compare (to_list y.version) (to_list x.version)

let decode (fpath, (head, body_md)) =
  let metadata =
    metadata_of_yaml head |> Result.map_error (Utils.where fpath)
  in
  let body_html =
    body_md |> Markdown.Content.of_string
    |> Markdown.Content.render ~syntax_highlighting:true
  in
  Result.map (of_metadata ~body_md ~body_html) metadata

let all () =
  Utils.map_md_files decode "releases/*.md"
  |> Stdlib.List.sort sort_by_decreasing_version

let latest () =
  try Stdlib.List.find (fun (r : t) -> r.is_latest) (all ())
  with Not_found ->
    raise (Invalid_argument "none of the releases is marked with is_latest: true")

let lts () =
  try Stdlib.List.find (fun (r : t) -> r.is_lts) (all ())
  with Not_found ->
    raise (Invalid_argument "none of the releases is marked with is_lts: true")
