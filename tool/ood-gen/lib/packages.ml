type metadata = { featured_packages : string list }
[@@deriving of_yaml, show { with_path = false }]

type t = metadata [@@deriving show { with_path = false }]

let all () =
  Data.read "packages.yml" |> Option.get
  |> Utils.decode_or_raise Yaml.of_string
  |> Utils.decode_or_raise metadata_of_yaml

let template () =
  Format.asprintf
    {|
type t = { featured_packages : string list }

let all = %a
    |}
    pp (all ())
