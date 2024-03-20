module Proficiency = struct
  type t = Beginner | Intermediate | Advanced
  [@@deriving show { with_path = false }]

  let of_string = function
    | "beginner" -> Ok Beginner
    | "intermediate" -> Ok Intermediate
    | "advanced" -> Ok Advanced
    | s -> Error (`Msg ("Unknown proficiency type: " ^ s))

  let of_yaml = Utils.of_yaml of_string "Expected a string for difficulty type"
end

type metadata = {
  title : string;
  slug : string;
  difficulty : Proficiency.t;
  tags : string list;
  description : string;
  tutorials : string list option;
}
[@@deriving of_yaml]

let get_title (h : Cmarkit.Block.Heading.t) =
  let title =
    Cmarkit.Inline.to_plain_text ~break_on_soft:false
      (Cmarkit.Block.Heading.inline h)
  in
  String.concat "\n" (List.map (String.concat "") title)

let split_statement_solution (body : string) =
  match Str.split (Str.regexp {|#[ ]*Solution|}) body with
  | [ _; statement_and_solution ] -> (
      match
        Str.split (Str.regexp {|#[ ]*Statement|}) statement_and_solution
      with
      | [ solution; statement ] ->
          Ok (Cmarkit.Doc.of_string statement, Cmarkit.Doc.of_string solution)
      | _ -> Error (`Msg "Failed to split on '# Statement' heading"))
  | _ -> Error (`Msg "Failed to split on '# Solution' heading")

type t = {
  title : string;
  slug : string;
  difficulty : Proficiency.t;
  tags : string list;
  description : string;
  statement : string;
  solution : string;
  tutorials : string list;
}
[@@deriving
  stable_record ~version:metadata ~remove:[ statement; solution ]
    ~modify:[ tutorials ],
    show { with_path = false }]

let of_metadata m = of_metadata m ~modify_tutorials:(Option.value ~default:[])
let attach_filepath fpath (`Msg m) = `Msg ("Error in file '" ^ fpath ^ "': " ^ m)

let decode (fpath, (head, body)) : (t, [> `Msg of string ]) result =
  let ( let* ) = Result.bind in
  let* metadata =
    metadata_of_yaml head |> Result.map_error (attach_filepath fpath)
  in
  let* statement_doc, solution_doc =
    split_statement_solution body |> Result.map_error (attach_filepath fpath)
  in
  let statement =
    Cmarkit_html.of_doc ~safe:false (Hilite.Md.transform statement_doc)
  in
  let solution =
    Cmarkit_html.of_doc ~safe:false (Hilite.Md.transform solution_doc)
  in
  Ok (metadata |> of_metadata ~statement ~solution)

let compare_by_slug =
  let key exercise : int * string =
    Scanf.sscanf exercise.slug "%d%[A-Z]" (fun s c -> (s, c))
  in
  fun (x : t) (y : t) -> compare (key x) (key y)

let all () =
  Utils.map_files decode "exercises/*.md" |> List.sort compare_by_slug

let template () =
  Format.asprintf
    {|
type difficulty = Beginner | Intermediate | Advanced

type t =
  { title : string
  ; slug : string
  ; difficulty : difficulty
  ; tags : string list
  ; description : string
  ; statement : string
  ; solution : string
  ; tutorials : string list;
  }
  
let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
