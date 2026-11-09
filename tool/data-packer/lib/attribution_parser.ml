(* Reads the committed per-document attribution store (data/attribution.jsonl,
   produced by tool/attribution) into the packed blob. One compact JSON object
   per line; see Data_intf.Attribution.t for the schema. *)

type contributor = [%import: Data_intf.Attribution.contributor]
[@@deriving of_yojson]

type ai_section = [%import: Data_intf.Attribution.ai_section]
[@@deriving of_yojson]

type t = [%import: Data_intf.Attribution.t] [@@deriving of_yojson]

let all () = Utils.jsonl_file of_yojson "attribution.jsonl"
