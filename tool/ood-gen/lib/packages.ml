open Ocamlorg.Import

type metadata = { featured_packages : string list }
[@@deriving of_yaml, show { with_path = false }]

type t = metadata [@@deriving show { with_path = false }]

let all () =
  let ( let* ) = Result.bind in
  let file = "packages.yml" in
  let file_opt = Data.read file in
  let file_res = Option.to_result ~none:(`Msg "file not found") file_opt in
  (let* file = file_res in
   let* yaml = Yaml.of_string file in
   metadata_of_yaml yaml)
  |> Result.map_error (function `Msg err -> file ^ ": " ^ err)
  |> Result.get_ok ~error:(fun msg -> Exn.Decode_error msg)

let template () =
  Format.asprintf
    {|
type t = { featured_packages : string list }

let all = %a
    |}
    pp (all ())
