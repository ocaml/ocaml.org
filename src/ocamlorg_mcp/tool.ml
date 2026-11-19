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
         (Blocks A/B) set this. *)
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

(* A successful result can still be incomplete: a docs-ci fetch failed, timed
   out, or was skipped at the call's deadline (see {!Fanout}), and the handler
   reports what it has. Such a result must not be served from the response cache
   for the whole TTL, since the next call may well get everything; the handler
   marks it with [partial]. The mark is a [_meta] entry on a content block,
   which the server moves to the result's [_meta] (the place every protocol
   version we speak allows it, see {!Server.call_result}) and checks before
   caching. *)
let partial_key = "org.ocaml/partial"

let partial (block : Yojson.Safe.t) : Yojson.Safe.t =
  match block with
  | `Assoc fields ->
      let meta =
        match List.assoc_opt "_meta" fields with
        | Some (`Assoc m) -> `Assoc ((partial_key, `Bool true) :: m)
        | _ -> `Assoc [ (partial_key, `Bool true) ]
      in
      `Assoc (List.remove_assoc "_meta" fields @ [ ("_meta", meta) ])
  | other -> other

(* [Some block'] iff [block] carries the mark, with [block'] the block without
   it. *)
let take_partial (block : Yojson.Safe.t) : Yojson.Safe.t option =
  match block with
  | `Assoc fields -> (
      match List.assoc_opt "_meta" fields with
      | Some (`Assoc m) when List.assoc_opt partial_key m = Some (`Bool true) ->
          let fields = List.remove_assoc "_meta" fields in
          Some
            (match List.remove_assoc partial_key m with
            | [] -> `Assoc fields
            | m -> `Assoc (fields @ [ ("_meta", `Assoc m) ]))
      | _ -> None)
  | _ -> None

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
