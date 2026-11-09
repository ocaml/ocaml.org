(* Tool parser - adapted from ood-gen/lib/tool.ml *)

open Import

type lifecycle = [%import: Data_intf.Tool.lifecycle] [@@deriving show]

let lifecycle_of_string = function
  | "incubate" -> Ok `Incubate
  | "active" -> Ok `Active
  | "sustain" -> Ok `Sustain
  | "deprecate" -> Ok `Deprecate
  | s -> Error (`Msg ("Unknown lifecycle: " ^ s))

let lifecycle_of_yaml = function
  | `String s -> lifecycle_of_string s
  | _ -> Error (`Msg "Expected string for lifecycle")

type t = [%import: Data_intf.Tool.t] [@@deriving show]

type metadata = {
  name : string;
  source : string;
  license : string;
  synopsis : string;
  description : string;
  lifecycle : lifecycle;
}
[@@deriving of_yaml]

let of_metadata
    ({ name; source; license; synopsis; description; lifecycle } : metadata) : t
    =
  {
    name;
    slug = Utils.slugify name;
    source;
    license;
    synopsis;
    description = Markdown.Content.(of_string description |> render);
    lifecycle;
  }

let all () =
  Utils.yaml_sequence_file
    (fun yaml -> Result.map of_metadata (metadata_of_yaml yaml))
    "tools.yml"
