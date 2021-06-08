type metadata =
  { name : string
  ; source : string
  ; license : string
  ; synopsis : string
  ; description : string
  ; lifecycle : string
  }
[@@deriving yaml]

type lifecycle =
  [ `Incubate
  | `Active
  | `Sustain
  | `Deprecate
  ]

type t = Ood.Tools.Tool.t =
  { name : string
  ; source : string
  ; license : string
  ; synopsis : string
  ; description : string
  ; lifecycle : lifecycle
  }

let decode s =
  let yaml = Utils.decode_or_raise Yaml.of_string s in
  match yaml with
  | `O [ ("tools", `A xs) ] ->
    List.map
      (fun x ->
        try
          let (metadata : metadata) =
            Utils.decode_or_raise metadata_of_yaml x
          in
          let lifecycle =
            match Ood.Tools.Lifecycle.of_string metadata.lifecycle with
            | Ok x ->
              x
            | Error (`Msg err) ->
              raise (Exn.Decode_error err)
          in
          let description = Omd.of_string metadata.description |> Omd.to_html in
          ({ name = metadata.name
           ; source = metadata.source
           ; license = metadata.license
           ; synopsis = metadata.synopsis
           ; description
           ; lifecycle
           }
            : t)
        with
        | e ->
          print_endline (Yaml.to_string x |> Result.get_ok);
          raise e)
      xs
  | _ ->
    raise (Exn.Decode_error "expected a list of tools")

let all () =
  let content = Data.read "tools.yml" |> Option.get in
  decode content

let get_by_lifecycle lc = List.filter (fun (x : t) -> x.lifecycle = lc) (all ())

let get_incubate () = get_by_lifecycle `Incubate

let get_active () = get_by_lifecycle `Active

let get_sustain () = get_by_lifecycle `Sustain

let get_deprecate () = get_by_lifecycle `Deprecate

let slug (t : t) = Utils.slugify t.name

let get_by_slug id = all () |> List.find_opt (fun video -> slug video = id)
