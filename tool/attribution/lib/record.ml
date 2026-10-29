(* The per-document attribution record and its JSON Lines encoding.

   One record is serialized to one compact JSON object per line, with a fixed
   key order and deterministically ordered lists, so that the committed
   [data/attribution.jsonl] is stable: regenerating a document rewrites exactly
   its own line. The Phase 2 packer reads these back with yojson. *)

type contributor = {
  name : string;
  commits : int;
  first_commit : string; (* full hash, stable as the repo grows *)
  first_date : string; (* YYYY-MM-DD, UTC *)
}

type ai_section = {
  commit : string;
  assisted_by : string list;
  sections : string list;
  context : string list;
}

type t = {
  path : string;
  contributors : contributor list;
  derived_from : string list; (* internal "path@commit" entries *)
  external_authors : string list; (* resolved via the sources manifest *)
  provenance_unknown_before : string option;
      (* date, if any import is unknown *)
  ai_assisted : ai_section list;
  overrides_applied : string list;
  generated_at_commit : string;
  generator : string;
}

let str s = `String s
let strings l = `List (List.map str l)

let contributor_to_json c =
  `Assoc
    [
      ("name", str c.name);
      ("commits", `Int c.commits);
      ("first_commit", str c.first_commit);
      ("first_date", str c.first_date);
    ]

let ai_section_to_json a =
  `Assoc
    [
      ("commit", str a.commit);
      ("assisted_by", strings a.assisted_by);
      ("sections", strings a.sections);
      ("context", strings a.context);
    ]

let to_json t : Yojson.Safe.t =
  `Assoc
    [
      ("path", str t.path);
      ("contributors", `List (List.map contributor_to_json t.contributors));
      ("derived_from", strings t.derived_from);
      ("external_authors", strings t.external_authors);
      ( "provenance_unknown_before",
        match t.provenance_unknown_before with Some d -> str d | None -> `Null
      );
      ("ai_assisted", `List (List.map ai_section_to_json t.ai_assisted));
      ("overrides_applied", strings t.overrides_applied);
      ("generated_at_commit", str t.generated_at_commit);
      ("generator", str t.generator);
    ]

(* Compact, one line, no trailing newline. *)
let to_line t = Yojson.Safe.to_string (to_json t)

(* Extract just the [path] key from a serialized line, for splicing an updated
   record into an existing file without re-serializing untouched records. *)
let path_of_line line =
  match Yojson.Safe.from_string line with
  | `Assoc fields -> (
      match List.assoc_opt "path" fields with
      | Some (`String p) -> p
      | _ -> Fmt.failwith "attribution record without a string path: %s" line)
  | _ -> Fmt.failwith "attribution record is not a JSON object: %s" line

(* The attribution content of a line, excluding the generation-time provenance
   stamp (generated_at_commit / generator). Freshness checks compare this so a
   store generated at an earlier HEAD is not flagged stale merely because HEAD
   has since advanced — only a change in actual authorship matters. *)
let content_of_line line =
  match Yojson.Safe.from_string line with
  | `Assoc fields ->
      Yojson.Safe.to_string
        (`Assoc
          (List.filter
             (fun (k, _) -> k <> "generated_at_commit" && k <> "generator")
             fields))
  | _ -> line
