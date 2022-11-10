type member = { name : string; github : string; role : string }
[@@deriving yaml]

type contact = { name : string; link : string; icon : string } [@@deriving yaml]

type subteam = {
  name : string;
  github : string option; [@default None]
  members : member list; [@default []]
}
[@@deriving yaml]

type team = {
  id : string;
  name : string;
  description : string;
  contacts : contact list;
  subteams : subteam list; [@key "teams"]
}
[@@deriving yaml]

type t = {
  teams : team list;
  working_groups : team list; [@key "working-groups"]
}
[@@deriving yaml]

let graphql_request =
  {|
{
  organization(login: "ocaml") {
    id
    name
    description
    membersWithRole(last: 100) {
      totalCount
      pageInfo { hasPreviousPage startCursor }
      edges {
        role
        node { id login name }
      }
    }
    teams(last: 100) {
      totalCount
      pageInfo { hasPreviousPage startCursor }
      nodes {
        id
        name
        slug
        description
        parentTeam { id }
        members {
          totalCount
          pageInfo { hasPreviousPage startCursor }
          edges {
            role
            node { id login name }
          }
        }
      }
    }
  }
}
|}

let all () =
  let s = Data.read "governance.yml" |> Option.get in
  let yaml = Utils.decode_or_raise Yaml.of_string s in
  Utils.decode_or_raise of_yaml yaml

let scrape () =
  let t = all () in
  let yaml = Yaml.to_string ~encoding:`Utf8 (to_yaml t) |> Result.get_ok in
  Import.Sys.write_file "data/governance.yml" yaml

let pp_contact ppf (v : contact) =
  Fmt.pf ppf {|
{ name = %a
; link = %a
; icon = %a
}|} Pp.string v.name
    Pp.string v.link Pp.string v.icon

let pp_member ppf (v : member) =
  Fmt.pf ppf {|
{ name = %a
; github = %a
; role = %a
}|} Pp.string v.name
    Pp.string v.github Pp.string v.role

let pp_subteam ppf (v : subteam) =
  Fmt.pf ppf {|
{ name = %a
; github = %a
; members = %a
}|} Pp.string v.name
    (Pp.option Pp.string) v.github (Pp.list pp_member) v.members

let pp_team ppf (v : team) =
  Fmt.pf ppf
    {|
{ id = %a
; name = %a
; description = %a
; contacts = %a
; teams = %a
}|}
    Pp.string v.id Pp.string v.name Pp.string v.description (Pp.list pp_contact)
    v.contacts (Pp.list pp_subteam) v.subteams

let pp_team_list = Pp.list pp_team

let template () =
  let t = all () in
  Format.asprintf
    {|
type member = { name : string; github : string; role : string }

type contact = { name : string; link : string; icon : string }

type team = {
  name : string;
  github : string option;
  members : member list;
}

type t = {
  id : string;
  name : string;
  description : string;
  contacts : contact list;
  teams : team list;
}

let teams = %a

let working_groups = %a
|}
    pp_team_list t.teams pp_team_list t.working_groups
