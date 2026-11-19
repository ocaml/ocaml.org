(* Fixtures shared by the tests of the MCP tools that read docs-ci: a real
   sidebar, a package state, a docs-ci stand-in, and a way to call a tool's
   handler. Linked into every test of this directory. *)

module Package = Ocamlorg_package
module Documentation = Ocamlorg_package.Documentation
module Mcp_docs = Ocamlorg_web.Mcp_docs

(* The sidebar.json of lwt 5.9.0 as docs-ci serves it, cut down to a few
   modules: libraries are untitled nodes ("Library <code>lwt</code>"), each
   module lists its submodules and module types, at every depth, and the titles
   are simple names. *)
let lwt_sidebar_json =
  {|[
  {"node": {"url": "p/lwt/5.9.0/doc/index.html", "kind": "leaf-page", "content": "Lwt"},
   "children": [
    {"node": {"url": "p/lwt/5.9.0/doc/LICENSE.html", "kind": "leaf-page", "content": "LICENSE"}, "children": []},
    {"node": {"url": null, "kind": null, "content": "Library <code>lwt</code>"},
     "children": [
      {"node": {"url": "p/lwt/5.9.0/doc/lwt/Lwt/index.html", "kind": "module", "content": "Lwt"},
       "children": [
        {"node": {"url": "p/lwt/5.9.0/doc/lwt/Lwt/Infix/index.html", "kind": "module", "content": "Infix"}, "children": []},
        {"node": {"url": "p/lwt/5.9.0/doc/lwt/Lwt/Let_syntax/index.html", "kind": "module", "content": "Let_syntax"}, "children": []}]},
      {"node": {"url": "p/lwt/5.9.0/doc/lwt/Lwt_pqueue/index.html", "kind": "module", "content": "Lwt_pqueue"},
       "children": [
        {"node": {"url": "p/lwt/5.9.0/doc/lwt/Lwt_pqueue/module-type-S/index.html", "kind": "module-type", "content": "S"}, "children": []}]},
      {"node": {"url": "p/lwt/5.9.0/doc/lwt/Lwt_result/index.html", "kind": "module", "content": "Lwt_result"},
       "children": [
        {"node": {"url": "p/lwt/5.9.0/doc/lwt/Lwt_result/Infix/index.html", "kind": "module", "content": "Infix"}, "children": []}]}]},
    {"node": {"url": null, "kind": null, "content": "Library <code>lwt.unix</code>"},
     "children": [
      {"node": {"url": "p/lwt/5.9.0/doc/lwt.unix/Lwt_main/index.html", "kind": "module", "content": "Lwt_main"}, "children": []},
      {"node": {"url": "p/lwt/5.9.0/doc/lwt.unix/Lwt_unix/index.html", "kind": "module", "content": "Lwt_unix"},
       "children": [
        {"node": {"url": "p/lwt/5.9.0/doc/lwt.unix/Lwt_unix/IO_vectors/index.html", "kind": "module", "content": "IO_vectors"}, "children": []},
        {"node": {"url": "p/lwt/5.9.0/doc/lwt.unix/Lwt_unix/LargeFile/index.html", "kind": "module", "content": "LargeFile"}, "children": []}]}]}]}]|}

let lwt_sidebar =
  match Documentation.sidebar_of_string lwt_sidebar_json with
  | Ok s -> s
  | Error e -> failwith e

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
   [`Failed] (a failed build), or [`Built (sidebar, pages, files)] with pages
   and files by path (its status lists the files). A path or version it does not
   know is a miss, and a version listed in [raising] raises on every fetch but
   the status. [fetches] counts the fetches. *)
let backend ?(raising = []) ?(fetches = ref 0) docs : Mcp_docs.backend =
  let find pkg = List.assoc_opt (key pkg) docs in
  let fetch pkg f =
    incr fetches;
    if List.mem (key pkg) raising then Lwt.fail (Failure "docs-ci body")
    else Lwt.return (f (find pkg))
  in
  let html content : Documentation.t =
    { uses_katex = false; toc = []; breadcrumbs = []; content }
  in
  {
    status =
      (fun pkg ->
        Lwt.return
          (match find pkg with
          | None | Some `Missing -> None
          | Some `Failed -> Some (status ~failed:true pkg)
          | Some (`Built (_, _, files)) ->
              Some (status ~files:(List.map fst files) pkg)));
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

(* Call a tool's handler: [Ok (payload, partial)] with the decoded JSON payload
   and whether the result is marked partial, or the in-band error. *)
let call (tool : Ocamlorg_mcp.Tool.t) args =
  match Lwt_main.run (tool.handler args) with
  | Ok [ block ] -> (
      let partial, block =
        match Ocamlorg_mcp.Tool.take_partial block with
        | Some b -> (true, b)
        | None -> (false, block)
      in
      match block with
      | `Assoc fields -> (
          match List.assoc_opt "text" fields with
          | Some (`String text) -> Ok (Yojson.Safe.from_string text, partial)
          | _ -> Error "no text content")
      | _ -> Error "unexpected content")
  | Ok _ -> Error "expected one content block"
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
