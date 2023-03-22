open Ocamlorg.Import

type metadata = { featured : string list }
[@@deriving of_yaml, show { with_path = false }]

type t = metadata [@@deriving show { with_path = false }]

let all () =
  let ( let* ) = Result.bind in
  let file = "packages.yml" in
  (let* yaml = Utils.yaml_file file in
   metadata_of_yaml yaml)
  |> Result.map_error (function `Msg err -> file ^ ": " ^ err)
  |> Result.get_ok ~error:(fun msg -> Exn.Decode_error msg)

let template () =
  Format.asprintf
    {|
type t = { featured : string list }

let all = %a
    |}
    pp (all ())
