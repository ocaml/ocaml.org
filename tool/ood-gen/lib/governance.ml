type member = { name : string; github : string; role : string }
[@@deriving yaml]

type contributor = { name : string; github : string } [@@deriving yaml]
type contact = { name : string; link : string; icon : string } [@@deriving yaml]

type team = {
  id : string;
  name : string;
  description : string;
  contacts : contact list;
  team : member list;
  alumni : contributor list option;
  contributors : contributor list option;
}
[@@deriving yaml]

type wg = {
  id : string;
  name : string;
  description : string;
  contacts : contact list;
  team : member list;
}
[@@deriving yaml]

let all_teams () =
  Utils.map_files
    (fun content ->
      content |> Yaml.of_string_exn |> team_of_yaml |> function
      | Ok x -> x
      | Error (`Msg err) -> raise (Failure err))
    "governance/"

let pp_contact ppf (v : contact) =
  Fmt.pf ppf
    {|
          { name = %a
          ; link = %a
          ; icon = %a
          }|}
    Pp.string v.name Pp.string v.link Pp.string v.icon

let pp_member ppf (v : member) =
  Fmt.pf ppf
    {|
          { name = %a
          ; github = %a
          ; role = %a
          }|}
    Pp.string v.name Pp.string v.github Pp.string v.role

let pp_contributor ppf (v : contributor) =
  Fmt.pf ppf
    {|
          { name = %a
          ; github = %a
          }|}
    Pp.string v.name Pp.string v.github

let pp_team ppf (v : team) =
  Fmt.pf ppf
    {|
  { id = %a
  ; name = %a
  ; description = %a
  ; contacts = %a
  ; team = %a
  ; alumni = %a
  ; contributors = %a
  }|}
    Pp.string v.id Pp.string v.name Pp.string v.description (Pp.list pp_contact)
    v.contacts (Pp.list pp_member) v.team (Pp.list pp_contributor)
    (Option.value ~default:[] v.alumni)
    (Pp.list pp_contributor)
    (Option.value ~default:[] v.contributors)

let pp_team_list = Pp.list pp_team

let pp_wg ppf (v : wg) =
  Fmt.pf ppf
    {|
  { id = %a
  ; name = %a
  ; description = %a
  ; contacts = %a
  ; team = %a
  }|}
    Pp.string v.id Pp.string v.name Pp.string v.description (Pp.list pp_contact)
    v.contacts (Pp.list pp_member) v.team

let pp_wg_list = Pp.list pp_wg

let template () =
  Format.asprintf
    {|
type member = { name : string; github : string; role : string }

type contributor = { name : string; github : string }

type contact = { name : string; link : string; icon : string }

type t = {
  id : string;
  name : string;
  description : string;
  contacts : contact list;
  team : member list;
  alumni : contributor list;
  contributors : contributor list;
}

let all = %a
|}
    pp_team_list (all_teams ())
