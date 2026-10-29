(* Reads the committed per-document attribution store (data/attribution.jsonl,
   produced by tool/attribution) into the packed blob. One compact JSON object
   per line; see Data_intf.Attribution.t for the schema. *)

let all () = Utils.jsonl_file Types.Attribution.of_yojson "attribution.jsonl"
