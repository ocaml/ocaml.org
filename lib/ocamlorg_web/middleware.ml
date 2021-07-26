(* Used to improve the routing for the v3 site directory. *)
let index_html next_handler request =
  let rec is_directory path =
    match path with
    | [ "" ] ->
      true
    | _ :: suffix ->
      is_directory suffix
    | _ ->
      false
  in
  let path = Dream.path request in
  if is_directory path then
    let path = List.filter (fun seg -> String.length seg <> 0) path in
    Dream.redirect
      request
      (Fmt.str "/%s" (String.concat "/" (path @ [ "index.html" ])))
  else
    next_handler request

(* Only used to catch the 404 status coming from serving the site directory
   without a namespace. *)
let catch_404 next_handler request =
  let open Lwt.Syntax in
  let* response = next_handler request in
  if Dream.status response = `Not_Found then
    Page_handler.not_found request
  else
    Lwt.return response