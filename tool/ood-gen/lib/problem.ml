module Proficiency = struct
  type t = [ `Beginner | `Intermediate | `Advanced ]

  let of_string = function
    | "beginner" -> Ok `Beginner
    | "intermediate" -> Ok `Intermediate
    | "advanced" -> Ok `Advanced
    | s -> Error (`Msg ("Unknown proficiency type: " ^ s))
end

type metadata = {
  title : string;
  number : string;
  difficulty : string;
  tags : string list;
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
  statement : string;
  solution : string;
}

let all () =
  Utils.map_files
    (fun content ->
      let metadata, body = Utils.extract_metadata_body content in
      let metadata = Utils.decode_or_raise metadata_of_yaml metadata in
      let statement_blocks, solution_blocks =
        split_statement_statement (Omd.of_string body)
      in
      let statement = Omd.to_html (Hilite.Md.transform statement_blocks) in
      let solution = Omd.to_html (Hilite.Md.transform solution_blocks) in
      {
        title = metadata.title;
        number = metadata.number;
        difficulty = Proficiency.of_string metadata.difficulty |> Result.get_ok;
        tags = metadata.tags;
        statement;
        solution;
      })
    "problems/*.md"

let pp_proficiency ppf v =
  Fmt.pf ppf "%s"
    (match v with
    | `Beginner -> "`Beginner"
    | `Intermediate -> "`Intermediate"
    | `Advanced -> "`Advanced")

let pp ppf v =
  Fmt.pf ppf
    {|
  { title = %a
  ; number = %a
  ; difficulty = %a
  ; tags = %a
  ; statement = %a
  ; solution = %a
  }|}
    Pp.string v.title Pp.string v.number pp_proficiency v.difficulty
    Pp.string_list v.tags Pp.string v.statement Pp.string v.solution

let pp_list = Pp.list pp

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
  ; statement : string
  ; solution : string
  }
  
let all = %a
|}
    pp_list (all ())
