(* Shared pieces of the MCP tools that read docs-ci beyond one page (issue
   #3775): which docs-ci accessors they use, how they find the latest documented
   version, and how long they wait for docs-ci.

   The docs-ci accessors are a record ({!backend}), the production one being
   {!docs_ci}, so that a handler can be tested end to end on fixture pages.

   The status of a version has three outcomes: documented (or a failed build),
   no documentation, or a status that could not be read. The last one is a
   backend failure, which a tool reports as such (an error, or a partial
   result), never as "no documentation": that would be cached as a complete
   answer. *)

module Package = Ocamlorg_package
module Documentation = Package.Documentation
module Navmap = Ocamlorg_frontend.Navmap

(* --- docs-ci accessors --- *)

type backend = {
  status : Package.t -> (Documentation.Status.t option, unit) result Lwt.t;
      (** The documentation build status of a version: [Ok None] when docs-ci
          has none (never built), [Error] when it could not be read. *)
  sidebar : Package.t -> Navmap.t Lwt.t;
      (** Its sidebar: [[]] when it has none or the fetch failed. *)
  page : Package.t -> string -> Documentation.t option Lwt.t;
      (** A page, by its doc-relative path ("lwt/Lwt/index.html"). *)
  file : Package.t -> string -> Documentation.t option Lwt.t;
      (** A file of the package, by its path from the package root
          ("doc/CHANGES.html"). *)
}

let docs_ci state =
  {
    status = Documentation.status_result ~kind:`Package state;
    sidebar = Documentation.sidebar ~kind:`Package;
    page = Documentation.documentation_page ~kind:`Package;
    file = Documentation.file ~kind:`Package;
  }

(* The first of [versions] whose documentation was built, probing at most
   [depth] of them, in order: one status.json fetch each, cached by
   [Documentation]. [Error pkg] when the status of [pkg] could not be read: a
   later version may be the one, so the search stops there. *)
let first_documented ~depth backend state name
    (versions : Package.Version.t list) :
    (Package.t option, Package.t) result Lwt.t =
  let open Lwt.Syntax in
  let rec go fuel = function
    | [] -> Lwt.return (Ok None)
    | _ when fuel <= 0 -> Lwt.return (Ok None)
    | v :: rest -> (
        match Package.get state name v with
        | None -> go (fuel - 1) rest
        | Some pkg -> (
            let* status = backend.status pkg in
            match status with
            | Ok (Some { failed = false; _ }) -> Lwt.return (Ok (Some pkg))
            | Ok _ -> go (fuel - 1) rest
            | Error _ -> Lwt.return (Error pkg)))
  in
  go depth versions

(* All versions of [name], newest first. *)
let versions_newest_first state name =
  List.map
    (fun (v : Package.version_summary) -> v.version)
    (Package.get_versions state name)

let latest_documented ~depth backend state name =
  first_documented ~depth backend state name (versions_newest_first state name)

(* --- time --- *)

(* How long a tool waits for docs-ci in one call. Past it, the tool reports what
   it has, as a partial result or an error. Each fetch also has its own timeout
   (OCAMLORG_DOC_FETCH_TIMEOUT, 30 s by default), longer than this, but a call
   can make many fetches. *)
let call_deadline = 15.

(* [Some v] when [f ()] resolves to [v] within [seconds], else [None]: [f ()] is
   then cancelled, and so are its docs-ci fetches. *)
let within seconds (f : unit -> 'a Lwt.t) : 'a option Lwt.t =
  let p = f () in
  match Lwt.state p with
  | Lwt.Return v -> Lwt.return (Some v)
  | _ ->
      Lwt.pick
        [
          Lwt.map Option.some p;
          Lwt.map (fun () -> None) (Lwt_unix.sleep (Float.max 0. seconds));
        ]
