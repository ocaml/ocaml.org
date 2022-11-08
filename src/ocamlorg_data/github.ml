let uri = "https://api.github.com/graphql"

let headers = Cohttp.Header.of_list [
  ( "Accept", "application/vnd.github+json" );
]

let graphql_query query =
  "{ \"query\": \"query " ^ String.escaped query ^ "\" }"

let read_token filepath = "Bearer " ^ input_line (open_in filepath)

let (!!) = Yojson.Safe.Util.member

let post token graphql =
  let open Lwt.Syntax in
  Logs.info (fun m -> m "POST %s" uri);
  let headers = Cohttp.Header.add headers "Authorization" token in
  let body = Cohttp_lwt.Body.of_string (graphql_query graphql) in
  let* response, body =
    Cohttp_lwt_unix.Client.post ~headers ~body (Uri.of_string uri)
  in
  let+ body = Cohttp_lwt.Body.to_string body in
  match response.status with
  | `OK -> Ok Yojson.Safe.(body |> from_string |> !! "data")
  | _ -> Error (`Msg body)

  let before_cursor = function
  | Some cursor -> ", before: \"" ^ cursor ^ "\""
  | None -> ""


  module Repo = struct

    type t = {
      name: string;
      description: string;
      pull_request_total_count: int;
      pull_requests: string list (* author_login list *)
    }

    let query ?before repo =
      "{
        repository(owner: \"ocaml\", name: \"" ^ repo ^ "\") {
          id
          name
          description
          pullRequests(last: 100" ^ before_cursor before ^ ") {
            totalCount
            pageInfo {
              hasPreviousPage
              startCursor
            }
            nodes {
              author {
                login
              }
            }
          }
        }
      }"

  let request token repo =
    let (let*) = Lwt_result.bind in
    let (let+) = Fun.flip Lwt_result.map in
    let rec loop buf graphql =
      let* json = post token graphql in
      let json = json |> !! "repository" in
      let has_previous_page, start_cursor =
        let page_info = json |> !! "pullRequests" |> !! "pageInfo" in
        Yojson.Safe.Util.(
          page_info |> !! "hasPreviousPage" |> to_bool,
          page_info |> !! "startCursor" |> to_string) in
      Lwt_result.map (List.cons json) @@ if has_previous_page then
        loop buf (query ~before:start_cursor repo)
      else
        Lwt.return_ok buf in
    let+ list = loop [] (query repo) in
      let hd = List.hd list in (* SAFE *)
      Yojson.Safe.Util.{
        name = hd |> !! "name" |> to_string;
        description = hd |> !! "description" |> to_string;
        pull_request_total_count =
          hd |> !! "pullRequests" |> !! "totalCount" |> to_int;
        pull_requests =
          let author_login json = json |> !! "author" |> !! "login" |> to_string in
          let f json = json |> !! "pullRequests" |> !! "nodes" |> convert_each author_login in
          List.concat_map f list
      }

  end

  module Org = struct

    let _teams ?before org =
      "{
        organization(login: \"" ^ org ^ "\") {
          teams(last: 100" ^ before_cursor before ^ ") {
            edges {
              node {
                id
              }
            }
          }
        }
      }"

    let _repos ?before org =
      "{
        organization(login: \"" ^ org ^ "\") {
          repositories(last: 100" ^ before_cursor before ^ ") {
            nodes {
              name
            }
          }
        }
      }"

  end