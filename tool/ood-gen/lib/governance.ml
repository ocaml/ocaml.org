open Ocamlorg.Import

type contact_kind = GitHub | Email | Discord | Chat
[@@deriving show { with_path = false }]

let contact_kind_of_yaml = function
  | `String "github" -> Ok GitHub
  | `String "email" -> Ok Email
  | `String "discord" -> Ok Discord
  | `String "chat" -> Ok Chat
  | x -> (
      match Yaml.to_string x with
      | Ok str ->
          Error
            (`Msg
              ("\"" ^ str
             ^ "\" is not a valid contact_kind! valid options are: github, \
                email, discord, chat"))
      | Error _ -> Error (`Msg "Invalid Yaml value"))

let contact_kind_to_yaml = function
  | GitHub -> `String "github"
  | Email -> `String "email"
  | Discord -> `String "discord"
  | Chat -> `String "chat"

type member = { name : string; github : string; role : string }
[@@deriving yaml, show { with_path = false }]

type contact = { name : string; link : string; kind : contact_kind }
[@@deriving yaml, show { with_path = false }]

type dev_meeting = {
  date : string;
  time : string;
  link : string;
  calendar : string option;
  notes : string;
}
[@@deriving yaml, show { with_path = false }]

type team = {
  id : string;
  name : string;
  description : string;
  contacts : contact list;
  dev_meeting : dev_meeting option; [@default None] [@key "dev-meeting"]
  members : member list; [@default []]
  subteams : team list; [@default []]
}
[@@deriving yaml, show { with_path = false }]

type metadata = {
  teams : team list;
  working_groups : team list; [@key "working-groups"]
}
[@@deriving yaml]

type t = { teams : team list; working_groups : team list }
[@@deriving stable_record ~version:metadata, show { with_path = false }]

let decode s = Result.map of_metadata (metadata_of_yaml s)

let all () =
  let file = "governance.yml" in
  let result =
    let ( let* ) = Result.bind in
    let* yaml = Utils.yaml_file file in
    decode yaml
  in
  result
  |> Result.map_error (function `Msg err -> `Msg (file ^ ": " ^ err))
  |> Result.get_ok ~error:(fun (`Msg msg) -> Exn.Decode_error msg)

let template () =
  let t = all () in
  Format.asprintf
    {|
module Member = struct
  type t = { name : string; github : string; role : string }
  let compare a b = String.compare a.github b.github
end

type contact_kind = GitHub | Email | Discord | Chat

type contact = { name : string; link : string; kind : contact_kind }

type dev_meeting = {
  date : string;
  time : string;
  link : string;
  calendar : string option;
  notes : string;
}

type team = {
  id : string;
  name : string;
  description : string;
  contacts : contact list;
  dev_meeting : dev_meeting option;
  members : Member.t list;
  subteams : team list;
}

let teams = %a

let working_groups = %a
|}
    (Fmt.brackets (Fmt.list pp_team ~sep:Fmt.semi))
    t.teams
    (Fmt.brackets (Fmt.list pp_team ~sep:Fmt.semi))
    t.working_groups
