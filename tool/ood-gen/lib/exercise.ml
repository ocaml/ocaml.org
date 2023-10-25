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

let split_statement_statement (blocks : _ Omd.block list) =
  let rec blocks_until_heading acc = function
    | [] -> (List.rev acc, [])
    | Omd.Heading (_, 1, _) :: _ as l -> (List.rev acc, l)
    | el :: rest -> blocks_until_heading (el :: acc) rest
  in
  let rec skip_non_heading_blocks = function
    | [] -> []
    | Omd.Heading (_, 1, _) :: _ as l -> l
    | _ :: rest -> skip_non_heading_blocks rest
  in
  let err =
    "The format of the statement file is not valid. Expected exactly two \
     top-level headings: \"Solution\" and \"Statement\""
  in
  match skip_non_heading_blocks blocks with
  | Omd.Heading (_, 1, Omd.Text (_, "Solution")) :: rest -> (
      let solution_blocks, rest = blocks_until_heading [] rest in
      match rest with
      | Omd.Heading (_, 1, Omd.Text (_, "Statement")) :: rest -> (
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
    split_statement_statement (Omd.of_string body)
  in
  let statement = Omd.to_html (Hilite.Md.transform statement_blocks) in
  let solution = Omd.to_html (Hilite.Md.transform solution_blocks) in
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
