let uri = "https://api.github.com/graphql"

let headers =
  Cohttp.Header.of_list [ ("Accept", "application/vnd.github+json") ]

let graphql_query query =
  "{ \"query\": \"query " ^ String.escaped (String.trim query) ^ "\" }"

let ( !! ) = Yojson.Safe.Util.member

let post token graphql =
  let open Lwt.Syntax in
  Logs.info (fun m -> m "POST %s" uri);
  let headers = Cohttp.Header.add headers "Authorization" ("Bearer " ^ token) in
  let body = graphql_query graphql in
  let body = Cohttp_lwt.Body.of_string body in
  let* response, body =
    Cohttp_lwt_unix.Client.post ~headers ~body (Uri.of_string uri)
  in
  let+ body = Cohttp_lwt.Body.to_string body in
  match response.status with
  | `OK -> Ok Yojson.Safe.(body |> from_string |> !!"data")
  | _ -> Error (`Msg body)

let before_cursor = function
  | Some cursor -> ", before: \"" ^ cursor ^ "\""
  | None -> ""

let page_info json =
  let json = json |> !!"pageInfo" in
  Yojson.Safe.Util.
    ( json |> !!"hasPreviousPage" |> to_bool,
      json |> !!"startCursor" |> to_string )

module Repo = struct
  type t = {
    name : string;
    description : string;
    pull_request_total_count : int;
    pull_requests : string list (* author_login list *);
  }

  let query ?before repo =
    "\n  {\n    repository(owner: \"ocaml\", name: \"" ^ repo
    ^ "\") {\n\
      \      id\n\
      \      name\n\
      \      description\n\
      \      pullRequests(last: 100" ^ before_cursor before
    ^ ") {\n\
      \        totalCount\n\
      \        pageInfo { hasPreviousPage startCursor }\n\
      \        nodes {\n\
      \          author {\n\
      \            login\n\
      \          }\n\
      \        }\n\
      \      }\n\
      \    }\n\
      \  }"

  let request token repo =
    let ( let* ) = Lwt_result.bind in
    let ( let+ ) = Fun.flip Lwt_result.map in
    let rec loop buf graphql =
      let* json = post token graphql in
      let json = json |> !!"repository" in
      let has_previous_page, start_cursor =
        page_info (json |> !!"pullRequests")
      in
      Lwt_result.map (List.cons json)
      @@
      if has_previous_page then loop buf (query ~before:start_cursor repo)
      else Lwt.return_ok buf
    in
    let+ list = loop [] (query repo) in
    let hd = List.hd list in
    (* SAFE *)
    Yojson.Safe.Util.
      {
        name = hd |> !!"name" |> to_string;
        description = hd |> !!"description" |> to_string;
        pull_request_total_count =
          hd |> !!"pullRequests" |> !!"totalCount" |> to_int;
        pull_requests =
          (let author_login json =
             json |> !!"author" |> !!"login" |> to_string
           in
           let f json =
             json |> !!"pullRequests" |> !!"nodes" |> convert_each author_login
           in
           List.concat_map f list);
      }
end

type member = { login : string; name : string option; role : string }

type team = {
  name : string;
  description : string option;
  members : member list;
}

type organization = {
  name : string;
  description : string option;
  members : member list;
  teams : team list;
}

let to_member json =
  Yojson.Safe.Util.
    {
      role = json |> !!"role" |> to_string;
      login = json |> !!"node" |> !!"login" |> to_string;
      name = json |> !!"node" |> !!"name" |> to_string_option;
    }

let to_team json =
  Yojson.Safe.Util.
    {
      name = json |> !!"name" |> to_string;
      description = json |> !!"description" |> to_string_option;
      members = json |> !!"members" |> !!"edges" |> convert_each to_member;
    }

(* FIXME: Handle pagination *)
let request token org =
  let ( let+ ) = Fun.flip Lwt_result.map in
  let+ json = post token org in
  let json = json |> !!"organization" in
  Yojson.Safe.Util.
    {
      name = json |> !!"name" |> to_string;
      description = json |> !!"description" |> to_string_option;
      members =
        json |> !!"membersWithRole" |> !!"edges" |> convert_each to_member;
      teams = json |> !!"teams" |> !!"nodes" |> convert_each to_team;
    }
