(* An MCP tool: a name, a human description, a JSON-Schema for its arguments,
   and a handler turning call arguments into result content (or an error message
   reported in-band, per the MCP tools/call convention). *)

type t = {
  name : string;
  description : string;
  input_schema : Yojson.Safe.t;
  handler : Yojson.Safe.t -> (Yojson.Safe.t list, string) result;
  cacheable : bool;
      (* whether identical [tools/call] arguments always yield the same result,
         so the response may be served from {!Cache}. Deterministic data tools
         (Blocks A/B) set this; [ping] does not. *)
}

(* A text content block, the simplest MCP result content type. *)
let text_content (text : string) : Yojson.Safe.t =
  `Assoc [ ("type", `String "text"); ("text", `String text) ]

(* Serialisation for tools/list. *)
let to_json (t : t) : Yojson.Safe.t =
  `Assoc
    [
      ("name", `String t.name);
      ("description", `String t.description);
      ("inputSchema", t.input_schema);
    ]

(* No-op smoke-test tool (Phase 1). Later feature blocks register real tools for
   package dependencies, docs, and search. *)
let ping : t =
  {
    name = "ping";
    description = "No-op health check. Returns \"pong\".";
    input_schema =
      `Assoc [ ("type", `String "object"); ("properties", `Assoc []) ];
    handler = (fun _args -> Ok [ text_content "pong" ]);
    cacheable = false;
  }

let registry : t list = [ ping ]
let find name = List.find_opt (fun t -> t.name = name) registry
