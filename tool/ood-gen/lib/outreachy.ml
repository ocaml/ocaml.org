type project = {
  title : string;
  description : string;
  mentee : string;
  blog : string;
  mentors : string list;
}
[@@deriving yaml]

type metadata = { name : string; projects : project list } [@@deriving yaml]
type t = metadata

let decode s =
  let yaml = Utils.decode_or_raise Yaml.of_string s in
  match yaml with
  | `O [ ("rounds", `A xs) ] ->
      Ok (List.map (Utils.decode_or_raise metadata_of_yaml) xs)
  | _ -> Error (`Msg "expected a list of opam-users")

let all () =
  let content = Data.read "outreachy.yml" |> Option.get in
  Utils.decode_or_raise decode content

let pp_project ppf v =
  Fmt.pf ppf
    {|
  { title = %a
  ; description = %a
  ; mentee = %a
  ; blog = %a
  ; mentors = %a
  }|}
    Pp.string v.title Pp.string v.description Pp.string v.mentee Pp.string
    v.blog (Pp.list Pp.string) v.mentors

let pp ppf v =
  Fmt.pf ppf {|
  { name = %a
  ; projects = %a
  }|} Pp.string v.name
    Pp.(list pp_project)
    v.projects

let pp_list = Pp.list pp

let template () =
  Format.asprintf
    {|
type project =
  { title : string
  ; description : string
  ; mentee : string
  ; blog : string
  ; mentors : string list
  }

type t =
  { name : string
  ; projects : project list
  }

let all = %a
|}
    pp_list (all ())
