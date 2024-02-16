type code_block_with_explanation = { code : string; explanation : string }
[@@deriving of_yaml, show { with_path = false }]

type metadata_section = {
  filename : string;
  language : string;
  code_blocks : code_block_with_explanation list;
}
[@@deriving of_yaml]

type metadata = {
  title : string;
  problem : string;
  category : string;
  packages : string list;
  sections : metadata_section list;
}
[@@deriving of_yaml]

type section = {
  filename : string;
  language : string;
  code_blocks : code_block_with_explanation list;
  code_plaintext : string;
}
[@@deriving show { with_path = false }]

type t = {
  group_id : string;
  slug : string;
  title : string;
  problem : string;
  category : string;
  packages : string list;
  sections : section list;
  body_html : string;
}
[@@deriving
  stable_record ~version:metadata
    ~remove:[ slug; group_id; body_html ]
    ~modify:[ sections ],
    show { with_path = false }]

let decode (fpath, (head, body)) =
  (* TODO: use body and put that somewhere *)
  let group_id = Filename.basename (Filename.dirname fpath) in
  let name = Filename.basename (Filename.remove_extension fpath) in
  let id = String.sub name 3 (String.length name - 3) in
  let slug = group_id ^ "-" ^ id in
  let metadata = metadata_of_yaml head in

  let render_markdown str =
    str |> String.trim
    |> Cmarkit.Doc.of_string ~strict:true
    |> Hilite.Md.transform
    |> Cmarkit_html.of_doc ~safe:false
  in

  let modify_sections (sections : metadata_section list) =
    sections
    |> List.map (fun ({ filename; language; code_blocks } : metadata_section) ->
           let code_plaintext =
             code_blocks
             |> List.map (fun (c : code_block_with_explanation) -> c.code)
             |> String.concat "\n"
           in
           let code_blocks =
             code_blocks
             |> List.map (fun (c : code_block_with_explanation) ->
                    let code =
                      Printf.sprintf "```%s\n%s\n```" language c.code
                      |> render_markdown
                    in
                    let explanation = c.explanation |> render_markdown in
                    { explanation; code })
           in
           { filename; language; code_blocks; code_plaintext })
  in
  let body_html = body |> render_markdown in

  Result.map
    (fun metadata ->
      of_metadata ~slug ~group_id ~body_html ~modify_sections metadata)
    metadata

let all () =
  Utils.map_files decode "cookbook/*/*.md"
  |> List.sort (fun a b -> String.compare b.slug a.slug)

let template () =
  Format.asprintf
    {|
type code_block_with_explanation =
  { code : string
  ; explanation : string
  }
type section =
  { filename : string
  ; language : string
  ; code_blocks : code_block_with_explanation list
  ; code_plaintext : string
  }
type t =
  { slug: string
  ; group_id: string
  ; title : string
  ; problem : string
  ; category : string
  ; packages : string list
  ; sections : section list
  ; body_html : string
  }
  
let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
