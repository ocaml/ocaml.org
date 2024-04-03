type project = {
  title : string;
  description : string;
  mentee : string;
  blog : string option;
  source : string;
  mentors : string list;
  video : string option;
}
[@@deriving of_yaml, show { with_path = false }]

type metadata = { name : string; projects : project list }
[@@deriving of_yaml, show { with_path = false }]

type t = { name : string; projects : project list }
[@@deriving
  stable_record ~version:metadata ~modify:[ projects ],
    show { with_path = false }]

let modify_projects (v : project list) : project list =
  List.map
    (fun (p : project) ->
      {
        title = p.title;
        description =
          Cmarkit.Doc.of_string p.description |> Cmarkit_html.of_doc ~safe:true;
        mentee = p.mentee;
        blog = p.blog;
        source = p.source;
        mentors = p.mentors;
        video = p.video;
      })
    v

let decode s = Result.map (of_metadata ~modify_projects) (metadata_of_yaml s)
let all () = Utils.yaml_sequence_file ~key:"rounds" decode "outreachy.yml"

let template () =
  Format.asprintf
    {|
type project =
  { title : string
  ; description : string
  ; mentee : string
  ; blog : string option
  ; source : string
  ; mentors : string list
  ; video : string option
  }

type t =
  { name : string
  ; projects : project list
  }

let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
