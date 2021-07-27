(* Used to improve the routing for the v3 site directory. *)

(* Only `en` for now *)
let supported_locales = [ "en" ]

let i18n next_handler request =
  let rec is_directory path =
    match path with
    | [ "" ] ->
      true
    | [ x ] ->
      not (Fpath.v x |> Fpath.exists_ext)
    | _ :: suffix ->
      is_directory suffix
    | _ ->
      false
  in
  let path = Dream.path request in
  if is_directory path then
    let path = List.filter (fun seg -> String.length seg <> 0) path in
    (* TODO: If someone tries to get to /de/... they will go to /en/de/... *)
    let locale = try List.hd path with _ -> "" in
    match List.mem locale supported_locales with
    | true ->
      next_handler request
    | false ->
      (* TODO: In the future we could inspect the accepted languages here also
         -- the length check is to ensure there are no trailing slashes which
         silently 404s Dream.static *)
      let redirection =
        if List.length path = 0 then
          "/en"
        else
          Fmt.str "/%s/%s" "en" (String.concat "/" path)
      in
      Dream.redirect request redirection
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
