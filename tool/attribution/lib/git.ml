(* Synchronous git-CLI wrappers for the attribution generator.

   Ported from the git idiom in [src/ocamlorg_package/lib/opam_repository.ml],
   which is Lwt-based. This is a build-time tool, so we stay synchronous via
   [Bos.OS.Cmd] rather than pulling in Lwt. Only the [git log] format strings
   and the stdout-parsing shape are reused. *)

let git ?(root = ".") args =
  Bos.Cmd.(v "git" %% of_list [ "-C"; root ] %% of_list args)

let fail_msg = function Ok v -> v | Error (`Msg m) -> failwith m

(* Raw stdout (no trimming), raising on a non-zero exit. *)
let run_out ?root args =
  Bos.OS.Cmd.(run_out (git ?root args) |> out_string ~trim:false |> success)
  |> fail_msg

(* Trimmed single-value stdout, raising on a non-zero exit. *)
let run_string ?root args =
  Bos.OS.Cmd.(run_out (git ?root args) |> out_string ~trim:true |> success)
  |> fail_msg

let head_commit ?root () = run_string ?root [ "rev-parse"; "HEAD" ]
let version ?root () = run_string ?root [ "--version" ]

(* Contents of [path] at revision [rev] (e.g. a base branch's committed store),
   or [None] if it does not exist there — so a new file reads as empty rather
   than raising. stderr is discarded to swallow git's "does not exist"
   message. *)
let show_file ?root ~rev ~path () =
  match
    Bos.OS.Cmd.(
      run_out ~err:err_null (git ?root [ "show"; rev ^ ":" ^ path ])
      |> out_string ~trim:false |> success)
  with
  | Ok s -> Some s
  | Error _ -> None

(* Resolve a "Name <email>" identity through .mailmap. git applies .mailmap to
   %aN for commit authors automatically, but trailer values (Co-authored-by …)
   are literal text, so co-authors must be normalised explicitly or the same
   person appears twice. Identities without an e-mail are returned unchanged. *)
let resolve_identity ?root raw =
  if String.contains raw '<' then run_string ?root [ "check-mailmap"; raw ]
  else raw

(* [git log] with a per-document history following renames. Each commit is
   introduced by a RS byte (0x1e) so commits are unambiguously separable even
   though trailer values and [--numstat] lines are interleaved. The format
   fields, tab-separated, are:

   0 %H commit hash (full, for determinism as the repo grows) 1 %at author
   timestamp (unix, for ordering) 2 %aN author name (honours .mailmap) 3 %aE
   author e-mail (honours .mailmap; for human/AI/bot classification) 4..10 the
   attribution trailers (comma-joined when repeated)

   [--numstat -w] appends one "added<TAB>removed<TAB>path" line per commit with
   whitespace-only changes counted as 0/0, which drives the trivial-commit
   filter. *)
let doc_format =
  "format:%x1e%H%x09%at%x09%aN%x09%aE%x09"
  ^ "%(trailers:key=Co-authored-by,valueonly,separator=%x2C)%x09"
  ^ "%(trailers:key=Derived-from,valueonly,separator=%x2C)%x09"
  ^ "%(trailers:key=Provenance,valueonly,separator=%x2C)%x09"
  ^ "%(trailers:key=Imported-from,valueonly,separator=%x2C)%x09"
  ^ "%(trailers:key=Assisted-by,valueonly,separator=%x2C)%x09"
  ^ "%(trailers:key=AI-sections,valueonly,separator=%x2C)%x09"
  ^ "%(trailers:key=AI-context,valueonly,separator=%x2C)"

let options = [ "log"; "--follow"; "-M90%"; "--no-merges" ]

let log_document ?root ?range ~path () =
  let range = match range with Some r -> [ r ] | None -> [] in
  run_out ?root
    (options
    @ [ "-w"; "--numstat"; "--format=" ^ doc_format ]
    @ range @ [ "--"; path ])

(* The options recorded in each record's [generator] field, so the output is
   self-describing and reproducible. *)
let generator_options = String.concat " " (List.tl options)
