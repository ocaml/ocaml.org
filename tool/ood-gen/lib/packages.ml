type metadata = { featured_packages : string list } [@@deriving of_yaml]
type t = metadata

let all () =
  Data.read "packages.yml" |> Option.get
  |> Utils.decode_or_raise Yaml.of_string
  |> Utils.decode_or_raise metadata_of_yaml

let pp ppf t =
  Fmt.pf ppf {|{ featured_packages = %a }|} (Pp.list Pp.string)
    t.featured_packages

let template () =
  Format.asprintf
    {|
type t = { featured_packages : string list }

let all = %a
    |}
    pp (all ())
