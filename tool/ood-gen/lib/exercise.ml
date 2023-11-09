module Proficiency = struct
  type t = [ `Beginner | `Intermediate | `Advanced ]
  [@@deriving show { with_path = false }]

  let of_string = function
    | "beginner" -> Ok `Beginner
    | "intermediate" -> Ok `Intermediate
    | "advanced" -> Ok `Advanced
    | s -> Error (`Msg ("Unknown proficiency type: " ^ s))

  let of_yaml = Utils.of_yaml of_string "Expected a string for difficulty type"
end

type metadata = {
  title : string;
  number : string;
  difficulty : Proficiency.t;
  tags : string list;
  description : string;
}
[@@deriving of_yaml]

let get_title (h : Cmarkit.Block.Heading.t) =
  let title =
    Cmarkit.Inline.to_plain_text ~break_on_soft:false
      (Cmarkit.Block.Heading.inline h)
  in
  String.concat "\n" (List.map (String.concat "") title)

let split_statement_statement (blocks : Cmarkit.Block.t list) =
  let rec blocks_until_heading acc = function
    | [] -> (List.rev acc, [])
    | Cmarkit.Block.Heading (h, _) :: rest
      when Cmarkit.Block.Heading.level h = 1 ->
        (List.rev acc, rest)
    | el :: rest -> blocks_until_heading (el :: acc) rest
  in
  let rec skip_non_heading_blocks = function
    | [] -> []
    | Cmarkit.Block.Heading (h, _) :: rest
      when Cmarkit.Block.Heading.level h = 1 ->
        rest
    | _ :: rest -> skip_non_heading_blocks rest
  in
  let err =
    "The format of the statement file is not valid. Expected exactly two \
     top-level headings: \"Solution\" and \"Statement\""
  in
  match skip_non_heading_blocks blocks with
  | Cmarkit.Block.Heading (h, _) :: rest when get_title h = "Solution" -> (
      let solution_blocks, rest = blocks_until_heading [] rest in
      match rest with
      | Cmarkit.Block.Heading (h, _) :: rest when get_title h = "Statement" -> (
          let statements_blocks, rest = blocks_until_heading [] rest in
          match rest with
          | [] -> (statements_blocks, solution_blocks)
          | _ -> raise (Exn.Decode_error err))
      | _ -> raise (Exn.Decode_error err))
  | _ -> raise (Exn.Decode_error err)

type t = {
  title : string;
  number : string;
  difficulty : Proficiency.t;
  tags : string list;
  description : string;
  statement : string;
  solution : string;
}
[@@deriving
  stable_record ~version:metadata ~remove:[ statement; solution ],
    show { with_path = false }]

let decode (_, (head, body)) =
  let metadata = metadata_of_yaml head in
  let statement_blocks, solution_blocks =
    split_statement_statement [ Cmarkit.Doc.block (Cmarkit.Doc.of_string body) ]
  in
  let statement_blocks_to_doc =
    Cmarkit.Block.Blocks (statement_blocks, Cmarkit.Meta.none)
    |> Cmarkit.Doc.make
  in
  let solution_blocks_to_doc =
    Cmarkit.Block.Blocks (solution_blocks, Cmarkit.Meta.none)
    |> Cmarkit.Doc.make
  in

  let statement =
    Cmarkit_html.of_doc ~safe:false
      (Hilite.Md.transform statement_blocks_to_doc)
  in
  let solution =
    Cmarkit_html.of_doc ~safe:false (Hilite.Md.transform solution_blocks_to_doc)
  in
  Result.map (of_metadata ~statement ~solution) metadata

let all () = Utils.map_files decode "exercises/*.md"

let template () =
  Format.asprintf
    {|
type difficulty =
  [ `Beginner
  | `Intermediate
  | `Advanced
  ]

type t =
  { title : string
  ; number : string
  ; difficulty : difficulty
  ; tags : string list
  ; description : string
  ; statement : string
  ; solution : string
  }
  
let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
