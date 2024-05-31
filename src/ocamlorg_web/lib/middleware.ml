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
  let release str =
    str |> Release.get_by_version
    |> Option.value ~default:Release.latest
    |> minor
  in
  let release_path = function
    | [] -> (minor Release.latest, [ "index.html" ])
    | x :: u -> (
        match Release.get_by_version x with
        | None -> (minor Release.latest, x :: u)
        | Some v -> (minor v, u))
  in
  let tweak_base u =
    match List.rev u with
    | _ :: "notes" :: _ -> u
    | base :: _ when String.contains base '.' -> u
    | htap -> List.rev ("index.html" :: htap)
  in
  let path =
    match init_path with
    | "" :: ("manual" | "htmlman") :: path ->
        let version, path = release_path path in
        "" :: "manual" :: version :: tweak_base path
    | "" :: "api" :: path ->
        let version, path = release_path path in
        "" :: "manual" :: version :: "api" :: tweak_base path
    | [ ""; "releases"; version; "index.html" ] -> [ ""; "releases"; version ]
    | [ ""; "releases"; something ]
      when String.ends_with ~suffix:".html" something ->
        let prefix = String.(sub something 0 (length something - 5)) in
        "" :: "releases" :: (if prefix = "index" then [] else [ prefix ])
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
