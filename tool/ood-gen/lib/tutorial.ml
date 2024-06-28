open Ocamlorg.Import
open Data_intf.Tutorial

type metadata = {
  id : string;
  title : string;
  short_title : string option;
  description : string;
  category : string;
  external_tutorial : external_tutorial option;
  recommended_next_tutorials : recommended_next_tutorials option;
  prerequisite_tutorials : prerequisite_tutorials option;
}
[@@deriving
  of_yaml,
    stable_record ~version:t ~remove:[ id ]
      ~modify:
        [ recommended_next_tutorials; prerequisite_tutorials; short_title ]
      ~add:[ slug; fpath; section; toc; body_md; body_html ]]

let of_metadata m =
  metadata_to_t m ~slug:m.id
    ~modify_recommended_next_tutorials:(function None -> [] | Some u -> u)
    ~modify_prerequisite_tutorials:(function None -> [] | Some u -> u)
    ~modify_short_title:(function None -> m.title | Some u -> u)

exception Missing_Tutorial of string

let check_tutorial_references all =
  let all_slugs = List.map (fun t -> t.slug) all in
  let tut_is_missing slug = not @@ List.mem slug all_slugs in
  let missing_tut_msg t missing =
    "The following recommended next tutorial(s) in " ^ t.fpath
    ^ " were not found: [" ^ String.concat "; " missing ^ "]"
  in
  let has_missing_tuts_exn (t : t) =
    match
      List.filter tut_is_missing t.recommended_next_tutorials
      @ List.filter tut_is_missing t.prerequisite_tutorials
    with
    | [] -> ()
    | missing -> raise (Missing_Tutorial (missing_tut_msg t missing))
  in

  List.iter has_missing_tuts_exn all

let rec toc_toc (toc : Markdown.Toc.t list) = List.map toc_f toc

and toc_f { title; href; children } =
  { title; href; children = toc_toc children }

let decode (fpath, (head, body_md)) =
  let metadata =
    metadata_of_yaml head |> Result.map_error (Utils.where fpath)
  in
  let section =
    List.nth (String.split_on_char '/' fpath) 1
    |> Section.of_string
    |> Result.get_ok ~error:(fun (`Msg msg) ->
           Exn.Decode_error (fpath ^ ":" ^ msg))
  in
  let doc = Markdown.Content.of_string body_md in
  let toc = Markdown.Toc.generate ~start_level:2 ~max_level:4 doc in
  let body_html = Markdown.Content.render ~syntax_highlighting:true doc in
  Result.map
    (of_metadata ~fpath ~section ~toc:(toc_toc toc) ~body_md ~body_html)
    metadata

let all () =
  Utils.map_md_files decode "tutorials/*/*.md"
  |> List.sort (fun t1 t2 -> String.compare t1.fpath t2.fpath)

module TutorialSearch = struct
  let document_from_section
      ((section : Search.section option), (content : Cmarkit.Block.t list))
      ~(metadata : metadata) : search_document =
    let section_document =
      {
        title = metadata.title;
        category = metadata.category;
        section =
          section
          |> Option.map (fun (s : Search.section) ->
                 { title = s.title; id = s.id });
        content =
          content |> List.map Search.block_to_string |> String.concat "\n";
        slug = metadata.id;
      }
    in
    section_document

  let decode_search_document (_fpath, (head, body_md)) :
      (search_document list, [> `Msg of string ]) result =
    match metadata_of_yaml head with
    | Ok metadata ->
        let content_blocks =
          body_md
          |> Cmarkit.Doc.of_string ~heading_auto_ids:true
          |> Cmarkit.Doc.block
        in
        let document =
          content_blocks |> Search.flatten_block |> Search.collect_all_sections
          |> List.map (document_from_section ~metadata)
        in
        Ok document
    | Error msg -> Error msg

  let all () : search_document list =
    Utils.map_md_files decode_search_document "tutorials/*/*.md" |> List.flatten
end

let template () =
  let _ = check_tutorial_references @@ all () in

  Format.asprintf
    {|
include Data_intf.Tutorial
let all = %a
let all_search_documents = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
    (Fmt.brackets (Fmt.list pp_search_document ~sep:Fmt.semi))
    (TutorialSearch.all ())
