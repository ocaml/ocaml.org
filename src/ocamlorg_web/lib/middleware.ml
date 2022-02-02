let no_trailing_slash next_handler request =
  let target = Dream.target request in
  match target with
  | "/" -> next_handler request
  | _ ->
      if String.ends_with ~suffix:"/" target then
        Dream.redirect request (String.sub target 0 (String.length target - 1))
      else next_handler request

let set_locale handler req =
  let language =
    match Dream_accept.accepted_languages req |> List.hd with
    | Dream_accept.Language "" -> "en"
    | Dream_accept.Language s ->
        (* We're only interested in the "en" in "en-US" *)
        String.split_on_char '-' s |> List.hd
    | Dream_accept.Any -> "en"
  in
  I18n.put_locale language;
  handler req
