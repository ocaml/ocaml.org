(* An MCP tool: a name, a human description, a JSON-Schema for its arguments,
   and a handler turning call arguments into result content (or an error message
   reported in-band, per the MCP tools/call convention). The handler is
   [Lwt]-returning: Block A's dependency tools read in-memory state and just
   [Lwt.return] their result, but Block B's docs tools fetch docs-ci
   asynchronously. *)

type t = {
  name : string;
  description : string;
  input_schema : Yojson.Safe.t;
  handler : Yojson.Safe.t -> (Yojson.Safe.t list, string) result Lwt.t;
  cacheable : bool;
      (* whether identical [tools/call] arguments always yield the same result,
         so the response may be served from {!Cache}. Deterministic data tools
         (Blocks A/B) set this; [ping] does not. *)
  annotations : Yojson.Safe.t option;
      (* Optional MCP [ToolAnnotations] emitted in [tools/list]: behavioural
         hints (readOnly / destructive / idempotent / openWorld) a client may
         use to decide how much scrutiny a call needs. Advisory only — the spec
         says clients must not trust them from untrusted servers — but honest
         self-description lets a cooperative host isolate this server's
         (community-authored, untrusted) output from auto-approving tools. *)
}

(* A text content block, the simplest MCP result content type. *)
let text_content (text : string) : Yojson.Safe.t =
  `Assoc [ ("type", `String "text"); ("text", `String text) ]

(* Annotations shared by every ocaml.org tool: all are read-only queries over a
   fixed backend (docs-ci) and in-memory package state — nothing is mutated, and
   there is no open-world/arbitrary-URL access ([openWorldHint = false]). *)
let read_only_annotations : Yojson.Safe.t =
  `Assoc
    [
      ("readOnlyHint", `Bool true);
      ("destructiveHint", `Bool false);
      ("idempotentHint", `Bool true);
      ("openWorldHint", `Bool false);
    ]

(* Serialisation for tools/list. *)
let to_json (t : t) : Yojson.Safe.t =
  `Assoc
    ([
       ("name", `String t.name);
       ("description", `String t.description);
       ("inputSchema", t.input_schema);
     ]
    @ match t.annotations with Some a -> [ ("annotations", a) ] | None -> [])

(* No-op smoke-test tool (Phase 1). Later feature blocks register real tools for
   package dependencies, docs, and search. *)
let ping : t =
  {
    name = "ping";
    description = "No-op health check. Returns \"pong\".";
    input_schema =
      `Assoc [ ("type", `String "object"); ("properties", `Assoc []) ];
    handler = (fun _args -> Lwt.return (Ok [ text_content "pong" ]));
    cacheable = false;
    annotations = Some read_only_annotations;
  }
