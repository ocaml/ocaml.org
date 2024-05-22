open Ocamlorg.Import

let no_trailing_slash next_handler request =
  let target = "///" ^ Dream.target request in
  (* FIXME: https://github.com/aantron/dream/issues/248 *)
  let path, query = target |> Dream.split_target in
  let path =
    path |> Dream.from_path |> Dream.drop_trailing_slash |> Dream.to_path
  in
  let target = path ^ if query = "" then "" else "?" ^ query in
  if Dream.target request = target then next_handler request
  else Dream.redirect request target

let language_manual_version next_handler request =
  let open Data in
  let init_path = request |> Dream.target |> String.split_on_char '/' in
  let minor (release : Release.t) = Ocamlorg.Url.minor release.version in
  let release ?insert candidate =
    Option.(
      fold
        ~none:(fold ~none:candidate ~some:(fun v -> v ^ "/" ^ candidate) insert)
        ~some:minor
        (Release.get_by_version candidate))
  in
  let path =
    match init_path with
    | "" :: "manual" :: something :: tl ->
        "" :: "manual" :: release ~insert:(minor Release.latest) something :: tl
    | [ ""; "releases"; version; "index.html" ] -> [ ""; "releases"; version ]
    | "" :: "releases" :: version :: ("htmlman" | "manual") :: tl ->
        "" :: "manual" :: release version
        :: (if tl = [] then [ "index.html" ] else tl)
    | "" :: "releases" :: version :: (("notes" | "api") as folder) :: tl ->
        "" :: "manual" :: release version :: folder
        :: (if tl = [] && folder = "api" then [ "index.html" ] else tl)
    | [ ""; "releases"; version; man ] when String.contains_s man "refman" ->
        [ ""; "manual"; release version; man ]
    | u -> u
  in
  if init_path = path then next_handler request
  else Dream.redirect request (String.concat "/" path)

let head handler request =
  match Dream.method_ request with
  | `HEAD ->
      let open Lwt.Syntax in
      Dream.set_method_ request `GET;
      let* response = handler request in
      let transfer_encoding = Dream.header response "Transfer-Encoding" in
      let* () =
        if
          transfer_encoding = Some "chunked"
          || Dream.has_header response "Content-Length"
        then Lwt.return_unit
        else
          let+ body = Dream.body response in
          body |> String.length |> string_of_int
          |> Dream.add_header response "Content-Length"
      in
      Dream.empty ~headers:(Dream.all_headers response) (Dream.status response)
  | _ -> handler request
