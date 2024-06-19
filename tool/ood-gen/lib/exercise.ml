open Data_intf.Exercise

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

let of_metadata m = metadata_to_t m ~modify_tutorials:(Option.value ~default:[])

let decode (fpath, (head, body)) : (t, [> `Msg of string ]) result =
  let ( let* ) = Result.bind in
  let* metadata =
    metadata_of_yaml head |> Result.map_error (Utils.where fpath)
  in
  let* statement_doc, solution_doc =
    split_statement_solution body |> Result.map_error (Utils.where fpath)
  in
  let statement =
    Cmarkit_html.of_doc ~safe:false (Hilite.Md.transform statement_doc)
  in
  let solution =
    Cmarkit_html.of_doc ~safe:false (Hilite.Md.transform solution_doc)
  in
  Ok (metadata |> of_metadata ~statement ~solution)

let compare_by_slug =
  let key (exercise : t) : int * string =
    Scanf.sscanf exercise.slug "%d%[A-Z]" (fun s c -> (s, c))
  in
  fun (x : t) (y : t) -> compare (key x) (key y)

let all () =
  Utils.map_md_files decode "exercises/*.md" |> List.sort compare_by_slug

let template () =
  Format.asprintf {|
include Data_intf.Exercise
let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
