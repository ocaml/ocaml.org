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
