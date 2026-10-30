(* Parsing helpers for the attribution trailer vocabulary.

   The trailers (inputs to the generator, see the issue) are: Co-authored-by :
   extra contributors on a commit ("Name <email>") Derived-from : "path@commit"
   (internal) or "source:<key>" (external) Imported-from : the work predates
   this repo (the importer is not the author) Provenance : "unknown" marks
   pre-import authorship as unknown Assisted-by : an AI tool credited for part
   of the commit AI-sections : which sections the assistance covered AI-context
   : free-form note on the assistance

   The repository does not use these trailers yet, so for the initial seed these
   helpers mostly operate on empty strings; the machinery stays dormant until
   maintainers adopt the vocabulary. *)

(* A trailer field is empty when git found no such trailer. *)
let is_empty = function "" -> true | _ -> false

(* [git log]'s [separator=%x2C] joins repeated trailers with commas. *)
let values field =
  if is_empty field then []
  else
    String.split_on_char ',' field
    |> List.map String.trim
    |> List.filter (fun s -> s <> "")

(* "Name <email>" -> "Name" (we never publish email addresses). *)
let name_only s =
  match String.index_opt s '<' with
  | Some i -> String.trim (String.sub s 0 i)
  | None -> String.trim s

let co_authors field = values field |> List.map name_only

(* "Name <email>" -> "email" (empty when absent). *)
let email_of s =
  match (String.index_opt s '<', String.index_opt s '>') with
  | Some i, Some j when j > i -> String.sub s (i + 1) (j - i - 1)
  | _ -> ""

(* "Provenance: unknown" (case-insensitive) marks authorship-before-date as
   unknown rather than crediting the importer. *)
let is_unknown field =
  values field |> List.exists (fun v -> String.lowercase_ascii v = "unknown")
