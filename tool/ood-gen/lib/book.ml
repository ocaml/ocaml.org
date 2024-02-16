module Difficulty = struct
  type t = Beginner | Intermediate | Advanced
  [@@deriving show { with_path = false }]

  let of_string = function
    | "beginner" -> Ok Beginner
    | "intermediate" -> Ok Intermediate
    | "advanced" -> Ok Advanced
    | s -> Error (`Msg ("Unknown difficulty type: " ^ s))

  let of_yaml = Utils.of_yaml of_string "Expected a string for difficulty type"
end

type link = { description : string; uri : string }
[@@deriving of_yaml, show { with_path = false }]

type metadata = {
  title : string;
  slug : string;
  description : string;
  recommendation : string option;
  authors : string list;
  language : string list;
  published : string;
  cover : string;
  isbn : string option;
  links : link list;
  difficulty : Difficulty.t;
  pricing : string;
}
[@@deriving of_yaml, show { with_path = false }]

type t = {
  title : string;
  slug : string;
  description : string;
  recommendation : string option;
  authors : string list;
  language : string list;
  published : string;
  cover : string;
  isbn : string option;
  links : link list;
  difficulty : Difficulty.t;
  pricing : string;
  body_md : string;
  body_html : string;
}
[@@deriving
  stable_record ~version:metadata ~remove:[ body_md; body_html ],
    show { with_path = false }]

let of_metadata m = of_metadata m

let decode (fpath, (head, body)) =
  let metadata =
    metadata_of_yaml head |> Result.map_error (Utils.where fpath)
  in
  let body_md = String.trim body in
  let body_html =
    Cmarkit.Doc.of_string ~strict:true body_md |> Cmarkit_html.of_doc ~safe:true
  in
  Result.map (of_metadata ~body_md ~body_html) metadata

let all () =
  Utils.map_files decode "books/*.md"
  |> List.sort (fun b1 b2 ->
         (* Sort the books by reversed publication date. *)
         String.compare b2.published b1.published)

let template () =
  Format.asprintf
    {|
type difficulty = Beginner | Intermediate | Advanced
type link = { description : string; uri : string }

type t = 
  { title : string
  ; slug : string
  ; description : string
  ; recommendation : string option
  ; authors : string list
  ; language : string list
  ; published : string
  ; cover : string
  ; isbn : string option
  ; links : link list
  ; difficulty : difficulty
  ; pricing : string
  ; body_md : string
  ; body_html : string
  }

let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
