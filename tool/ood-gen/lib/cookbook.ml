type task_metadata = { title : string; slug : string; description : string }
[@@deriving of_yaml]

type category_metadata = {
  title : string;
  subcategories : category_metadata list option;
  tasks : task_metadata list option;
}
[@@deriving of_yaml]

type category = { title : string; slug : string; subcategories : category list }
[@@deriving show { with_path = false }]

type task = {
  title : string;
  slug : string;
  category_path : string list;
  description : string;
}
[@@deriving show { with_path = false }]

type code_block_with_explanation = { code : string; explanation : string }
[@@deriving show { with_path = false }]

type package = {
  name : string;
  tested_version : string;
  used_libraries : string list;
}
[@@deriving of_yaml, show { with_path = false }]

type metadata = { packages : package list; discussion : string option }
[@@deriving of_yaml]

type t = {
  filepath : string;
  slug : string;
  task : task;
  packages : package list;
  code_blocks : code_block_with_explanation list;
  code_plaintext : string;
  discussion_html : string;
}
[@@deriving
  stable_record ~version:metadata
    ~remove:
      [ slug; filepath; task; discussion_html; code_blocks; code_plaintext ]
    ~add:[ discussion ],
    show { with_path = false }]

let decode (tasks : task list) (fpath, (head, body)) =
  let ( let* ) = Result.bind in
  let name = Filename.basename (Filename.remove_extension fpath) in
  let task_slug = List.nth (String.split_on_char '/' fpath) 1 in
  let* task =
    try Ok (tasks |> List.find (fun (c : task) -> c.slug = task_slug))
    with Not_found ->
      Error (`Msg (fpath ^ ": failed to find task '" ^ task_slug ^ "'"))
  in
  let slug = String.sub name 3 (String.length name - 3) in
  let metadata = metadata_of_yaml head in

  let render_markdown str =
    str |> String.trim
    |> Cmarkit.Doc.of_string ~strict:true
    |> Hilite.Md.transform
    |> Cmarkit_html.of_doc ~safe:false
  in

  let code_blocks =
    let rec extract_explanation_code_pairs split_result =
      match split_result with
      | [] -> []
      | Str.Text code :: rest when String.trim code = "" ->
          extract_explanation_code_pairs rest
      | Str.Text code :: rest ->
          { explanation = ""; code } :: extract_explanation_code_pairs rest
      | Str.Delim "(*"
        :: Str.Text explanation
        :: Str.Delim "*)\n"
        :: Str.Text code
        :: rest ->
          { explanation; code } :: extract_explanation_code_pairs rest
      | _ ->
          failwith
            ("should never happen, two comments after one another Delim/Delim \
              in " ^ fpath)
    in
    body
    |> Str.full_split (Str.regexp {|^(\*\|\*)
|})
    |> extract_explanation_code_pairs
    |> List.map (fun (c : code_block_with_explanation) ->
           let code =
             Printf.sprintf "```ocaml\n%s\n```" c.code |> render_markdown
           in
           let explanation = c.explanation |> render_markdown in
           { explanation; code })
  in
  Result.map
    (fun (metadata : metadata) ->
      let discussion_html =
        metadata.discussion |> Option.value ~default:"" |> render_markdown
      in
      of_metadata ~slug ~filepath:fpath ~task ~discussion_html ~code_blocks
        ~code_plaintext:body metadata)
    metadata

let all_categories_and_tasks () =
  let categories_and_tasks_metadata =
    Utils.yaml_sequence_file ~key:"categories" category_metadata_of_yaml
      "cookbook/tasks.yml"
  in
  let rec extract_tasks_from_category (path : string list) (tasks, categories) (meta_cat : category_metadata) : task list * category list =
    let cat_slug = Utils.slugify meta_cat.title in
    let cat_tasks =
      meta_cat.tasks
      |> Option.value ~default:[]
      |> List.map (fun (t : task_metadata) : task ->
              {
                title = t.title;
                slug = t.slug;
                category_path = List.rev (cat_slug :: path);
                description = t.description;
              }) in
    let subcategories_tasks, subcategories =
      List.fold_left (extract_tasks_from_category (cat_slug :: path)) ([], []) (Option.value ~default:[] meta_cat.subcategories) in
    let category =
      {
        title = meta_cat.title;
        slug = cat_slug;
        subcategories
      }
    in (cat_tasks @ subcategories_tasks @ tasks, category :: subcategories @ categories)
    in
    List.fold_left (extract_tasks_from_category []) (([], []) : task list * category list) categories_and_tasks_metadata


let tasks, categories = all_categories_and_tasks ()

let all () =
  Utils.map_files (decode tasks) "cookbook/*/*.ml"
  |> List.sort (fun a b -> String.compare b.slug a.slug)
  |> List.rev

let template () =
  Format.asprintf
    {|
type category =
  { title : string
  ; slug : string
  ; subcategories : category list
  }
type task =
  { title : string
  ; slug : string
  ; category_path : string list
  ; description : string
  }
type package =
  { name : string
  ; tested_version : string
  ; used_libraries : string list
  }
type code_block_with_explanation =
  { code : string
  ; explanation : string
  }
type t =
  { slug: string
  ; filepath: string
  ; task : task
  ; packages : package list
  ; code_blocks : code_block_with_explanation list
  ; code_plaintext : string
  ; discussion_html : string
  }

let categories = %a
let tasks = %a
let all = %a
|}
    (Fmt.brackets (Fmt.list pp_category ~sep:Fmt.semi))
    categories
    (Fmt.brackets (Fmt.list pp_task ~sep:Fmt.semi))
    tasks
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
