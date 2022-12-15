type metadata = { featured_packages : string list }
[@@deriving of_yaml, show { with_path = false }]

type t = metadata [@@deriving show { with_path = false }]

let all () =
  let (>>=) = Result.bind in
  Data.read "packages.yml"
  |> Import.Result.of_option (`Msg "packages.ml: file not found")
  >>= Yaml.of_string
  >>= metadata_of_yaml
  |> Import.Result.get Utils.decode_error

let template () =
  Format.asprintf
    {|
type t = { featured_packages : string list }

let all = %a
    |}
    pp (all ())
