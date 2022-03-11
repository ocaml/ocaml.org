let no_trailing_slash next_handler request =
  let target = Dream.target request in
  match target with
  | "/" -> next_handler request
  | _ ->
      if String.ends_with ~suffix:"/" target then
        Dream.redirect request (String.sub target 0 (String.length target - 1))
      else next_handler request
