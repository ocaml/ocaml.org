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

let no_trailing_slash next_handler request =
  let target = Dream.target request in
  if target = "/" then
    next_handler request
  else if String.get target (String.length target - 1) = '/' then
    Dream.redirect request (String.sub target 0 (String.length target - 1))
  else
    next_handler request
