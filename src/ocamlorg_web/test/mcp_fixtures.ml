(* Fixtures shared by the tests of the MCP tools that read docs-ci: a package
   state, a docs-ci stand-in, and a way to call a tool's handler. Linked into
   every test of this directory. *)

module Package = Ocamlorg_package
module Documentation = Ocamlorg_package.Documentation
module Mcp_docs = Ocamlorg_web.Mcp_docs

let v = Package.Version.of_string
let n = Package.Name.of_string

let info ?(flags = []) ?url ?(dependencies = []) ?(depopts = []) publication =
  {
    Package.Info.synopsis = "";
    description = "";
    authors = [];
    maintainers = [];
    license = "";
    homepage = [];
    tags = [];
    dependencies;
    rev_deps = [];
    depopts;
    conflicts = [];
    url;
    publication;
    flags;
  }

let package ?(publication = 0.) ?dependencies ?depopts name version =
  Package.create ~name:(n name) ~version:(v version)
    (info ?dependencies ?depopts publication)

let key pkg =
  Package.Name.to_string (Package.name pkg)
  ^ "."
  ^ Package.Version.to_string (Package.version pkg)

let status ?(failed = false) ?(files = []) pkg : Documentation.Status.t =
  {
    name = Package.Name.to_string (Package.name pkg);
    version = Package.Version.to_string (Package.version pkg);
    failed;
    files;
    redirections = [];
    search_index_digest = None;
  }

(* A docs-ci stand-in. [docs] maps "name.version" to the version's
   documentation: [`Missing] (no status, as for a version never built),
   [`Unreadable] (a status that could not be read: a timeout, a 5xx), [`Failed]
   (a failed build), or [`Built (sidebar, pages, files)] with pages and files by
   path (its status lists the files). A path or version it does not know is a
   miss. A version listed in [raising] raises on every fetch but the status; one
   listed in [stalling] never answers any fetch, the status included. [fetches]
   counts the fetches but the statuses, [status_fetches] the statuses. *)
let backend ?(raising = []) ?(stalling = []) ?(fetches = ref 0)
    ?(status_fetches = ref 0) docs : Mcp_docs.backend =
  let find pkg = List.assoc_opt (key pkg) docs in
  let stall pkg f =
    if List.mem (key pkg) stalling then fst (Lwt.task ()) else f ()
  in
  let fetch pkg f =
    incr fetches;
    stall pkg (fun () ->
        if List.mem (key pkg) raising then Lwt.fail (Failure "docs-ci body")
        else Lwt.return (f (find pkg)))
  in
  let html content : Documentation.t =
    { uses_katex = false; toc = []; breadcrumbs = []; content }
  in
  {
    status =
      (fun pkg ->
        incr status_fetches;
        stall pkg (fun () ->
            Lwt.return
              (match find pkg with
              | None | Some `Missing -> Ok None
              | Some `Unreadable -> Error ()
              | Some `Failed -> Ok (Some (status ~failed:true pkg))
              | Some (`Built (_, _, files)) ->
                  Ok (Some (status ~files:(List.map fst files) pkg)))));
    sidebar =
      (fun pkg -> fetch pkg (function Some (`Built (s, _, _)) -> s | _ -> []));
    page =
      (fun pkg path ->
        fetch pkg (function
          | Some (`Built (_, pages, _)) ->
              Option.map html (List.assoc_opt path pages)
          | _ -> None));
    file =
      (fun pkg path ->
        fetch pkg (function
          | Some (`Built (_, _, files)) ->
              Option.map html (List.assoc_opt path files)
          | _ -> None));
  }

(* Call a tool's handler: [Ok payload] with the decoded JSON payload, or the
   in-band error. *)
let call (tool : Ocamlorg_mcp.Tool.t) args =
  match Lwt_main.run (tool.handler args) with
  | Ok [ `Assoc fields ] -> (
      match List.assoc_opt "text" fields with
      | Some (`String text) -> Ok (Yojson.Safe.from_string text)
      | _ -> Error "no text content")
  | Ok _ -> Error "expected one text block"
  | Error e -> Error e

let member k = function
  | `Assoc l -> List.assoc_opt k l |> Option.value ~default:`Null
  | _ -> `Null

let to_string = function
  | `String s -> s
  | `Null -> "null"
  | j -> Yojson.Safe.to_string j

let to_list = function `List l -> l | _ -> []

let contains affix s =
  let n = String.length s and m = String.length affix in
  let rec go i = i + m <= n && (String.sub s i m = affix || go (i + 1)) in
  go 0
