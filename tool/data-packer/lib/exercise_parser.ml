(* Exercise parser - adapted from ood-gen/lib/exercise.ml *)

open Import

type difficulty = [%import: Data_intf.Exercise.difficulty] [@@deriving show]

let difficulty_of_string = function
  | "beginner" -> Ok Beginner
  | "intermediate" -> Ok Intermediate
  | "advanced" -> Ok Advanced
  | s -> Error (`Msg ("Unknown difficulty: " ^ s))

let difficulty_of_yaml = function
  | `String s -> difficulty_of_string s
  | _ -> Error (`Msg "Expected string for difficulty")

type t = [%import: Data_intf.Exercise.t] [@@deriving show]

type metadata = {
  title : string;
  slug : string;
  difficulty : difficulty;
  tags : string list;
  description : string;
  tutorials : string list option;
}
[@@deriving
  of_yaml,
    stable_record ~version:t ~add:[ statement; solution ] ~modify:[ tutorials ]]

let of_metadata m = metadata_to_t m ~modify_tutorials:(Option.value ~default:[])

let split_body body =
  (* Split body on "# Statement" and "# Solution" headers *)
  let statement_marker = "# Statement" in
  let solution_marker = "# Solution" in
  let find_section marker =
    try Some (Str.search_forward (Str.regexp_string marker) body 0)
    with Not_found -> None
  in
  match (find_section statement_marker, find_section solution_marker) with
  | Some stmt_pos, Some sol_pos when stmt_pos < sol_pos ->
      let stmt_start = stmt_pos + String.length statement_marker in
      let statement =
        String.sub body stmt_start (sol_pos - stmt_start) |> String.trim
      in
      let sol_start = sol_pos + String.length solution_marker in
      let solution =
        String.sub body sol_start (String.length body - sol_start)
        |> String.trim
      in
      (statement, solution)
  | _ ->
      (* Fallback: entire body is statement *)
      (String.trim body, "")

let render_with_highlight md =
  let doc = Cmarkit.Doc.of_string ~strict:true ~heading_auto_ids:true md in
  Hilite.Md.transform doc |> Cmarkit_html.of_doc ~safe:false

let decode (fpath, (head, body)) =
  let ( let* ) = Result.bind in
  let* metadata =
    metadata_of_yaml head |> Result.map_error (Utils.where fpath)
  in
  let statement_md, solution_md = split_body body in
  let statement = render_with_highlight statement_md in
  let solution = render_with_highlight solution_md in
  Ok (of_metadata ~statement ~solution metadata)

(* Custom sort by slug: handles "001", "002a", "002b", etc. *)
let compare_slugs s1 s2 =
  let extract_parts s =
    let len = String.length s in
    let rec find_alpha i =
      if i >= len then (s, "")
      else if s.[i] >= '0' && s.[i] <= '9' then find_alpha (i + 1)
      else (String.sub s 0 i, String.sub s i (len - i))
    in
    find_alpha 0
  in
  let n1, a1 = extract_parts s1 in
  let n2, a2 = extract_parts s2 in
  let num_cmp = String.compare n1 n2 in
  if num_cmp <> 0 then num_cmp else String.compare a1 a2

let all () =
  Utils.map_md_files decode "exercises/*.md"
  |> List.sort (fun (e1 : t) (e2 : t) -> compare_slugs e1.slug e2.slug)
