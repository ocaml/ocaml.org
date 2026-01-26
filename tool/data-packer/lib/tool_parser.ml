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
[@@deriving
  of_yaml, stable_record ~version:t ~add:[ slug ] ~modify:[ description ]]

let of_metadata m =
  metadata_to_t m ~slug:(Utils.slugify m.name) ~modify_description:(fun desc ->
      Markdown.Content.(of_string desc |> render))

let all () =
  Utils.yaml_sequence_file
    (fun yaml -> Result.map of_metadata (metadata_of_yaml yaml))
    "tools.yml"
