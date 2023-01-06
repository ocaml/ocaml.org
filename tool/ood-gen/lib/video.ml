type metadata = {
  title : string;
  description : string;
  people : string list;
  kind : string;
  tags : string list;
  paper : string option;
  link : string;
  embed : string option;
  year : int;
}
[@@deriving of_yaml]

module Kind = struct
  type t = [ `Conference | `Mooc | `Lecture ]
  [@@deriving show { with_path = false }]

  let of_string = function
    | "conference" -> Ok `Conference
    | "mooc" -> Ok `Mooc
    | "lecture" -> Ok `Lecture
    | _ -> Error (`Msg "Unknown video kind")
end

type t = {
  title : string;
  slug : string;
  description : string;
  people : string list;
  kind : Kind.t;
  tags : string list;
  paper : string option;
  link : string;
  embed : string option;
  year : int;
}
[@@deriving
  stable_record ~version:metadata ~modify:[ kind ] ~remove:[ slug ],
    show { with_path = false }]

let of_metadata m =
  of_metadata m ~slug:(Utils.slugify m.title)
    ~modify_kind:(Utils.decode_or_raise Kind.of_string)

let decode s =
  let yaml = Utils.decode_or_raise Yaml.of_string s in
  match yaml with
  | `O [ ("videos", `A xs) ] ->
      Ok
        (List.map
           (fun x ->
             let metadata = Utils.decode_or_raise metadata_of_yaml x in
             of_metadata metadata)
           xs)
  | _ -> Error (`Msg "expected a list of videos")

let all () =
  let content = Data.read "videos.yml" |> Option.get in
  Utils.decode_or_raise decode content

let template () =
  Format.asprintf
    {|
type kind =
  [ `Conference
  | `Mooc
  | `Lecture
  ]

type t =
  { title : string
  ; slug : string
  ; description : string
  ; people : string list
  ; kind : kind
  ; tags : string list
  ; paper : string option
  ; link : string
  ; embed : string option
  ; year : int
  }
  
let all = %a
|}
    (Fmt.brackets (Fmt.list pp ~sep:Fmt.semi))
    (all ())
