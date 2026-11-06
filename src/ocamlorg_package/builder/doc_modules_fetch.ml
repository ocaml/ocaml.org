(* Download the doc-modules index (#3982) that CI publishes as a release asset,
   next to the package state, for the server to map.

   GitHub serves release assets through a redirect to a signed URL, whose
   response carries a stable ETag. The ETag of the file in place is kept in
   [PATH.etag] and sent as If-None-Match, so an unchanged index costs two small
   requests and no body, and no GitHub API rate limit applies. A new index is
   checked completely (header, MD5, every entry) before it replaces the old one
   by a rename, so the server never sees a partial or damaged file. Any failure
   (404 while CI replaces the asset, 5xx, timeout, a damaged download) keeps the
   file in place.

   cohttp does not follow redirects: they are followed here, at most
   [max_redirects] times. *)

open Lwt.Syntax

let default_url =
  "https://github.com/ocaml/ocaml.org/releases/download/doc-modules-latest/doc-modules-v1.idx"

let url =
  Option.value ~default:default_url (Sys.getenv_opt "OCAMLORG_DOC_MODULES_URL")

let timeout = 120.
let max_redirects = 5
let max_bytes = 256 * 1024 * 1024

let read_file path =
  try Some (In_channel.with_open_bin path In_channel.input_all)
  with Sys_error _ -> None

(* Write [contents] to [path] through a temporary file and a rename. *)
let write_atomically path contents =
  let tmp = path ^ ".tmp" in
  try
    Out_channel.with_open_bin tmp (fun oc -> output_string oc contents);
    Sys.rename tmp path
  with e ->
    (try Sys.remove tmp with Sys_error _ -> ());
    raise e

let valid_index path =
  match Ocamlorg_doc_modules.Reader.map_file path with
  | Ok _ -> true
  | Error _ -> false

type outcome = Unchanged | Updated of int | Failed of string

let rec get ~etag uri redirects =
  let headers =
    Cohttp.Header.of_list
      (("user-agent", "ocamlorg-package-builder")
      :: Option.fold ~none:[] ~some:(fun e -> [ ("if-none-match", e) ]) etag)
  in
  let* response, body = Cohttp_lwt_unix.Client.get ~headers uri in
  let status = Cohttp.Response.status response in
  let header h = Cohttp.Header.get (Cohttp.Response.headers response) h in
  match Cohttp.Code.code_of_status status with
  | (301 | 302 | 303 | 307 | 308) when redirects > 0 -> (
      let* () = Cohttp_lwt.Body.drain_body body in
      match header "location" with
      | Some l ->
          get ~etag (Uri.resolve "" uri (Uri.of_string l)) (redirects - 1)
      | None -> Lwt.return (`Failed "redirect without a Location"))
  | 304 ->
      let* () = Cohttp_lwt.Body.drain_body body in
      Lwt.return `Not_modified
  | 200 -> (
      match Option.bind (header "content-length") int_of_string_opt with
      | Some n when n > max_bytes ->
          let* () = Cohttp_lwt.Body.drain_body body in
          Lwt.return (`Failed (Printf.sprintf "too large (%d bytes)" n))
      | _ ->
          let+ contents = Cohttp_lwt.Body.to_string body in
          `Ok (contents, header "etag"))
  | code ->
      let* () = Cohttp_lwt.Body.drain_body body in
      Lwt.return (`Failed (Printf.sprintf "HTTP %d" code))

let update path =
  let path = Fpath.to_string path in
  let etag_path = path ^ ".etag" in
  (* Only revalidate a file that is actually there and valid. *)
  let etag =
    if valid_index path then Option.map String.trim (read_file etag_path)
    else None
  in
  let fetch =
    Lwt.catch
      (fun () -> get ~etag (Uri.of_string url) max_redirects)
      (fun e -> Lwt.return (`Failed (Printexc.to_string e)))
  in
  let timed_out =
    let+ () = Lwt_unix.sleep timeout in
    `Failed (Printf.sprintf "timed out after %.0fs" timeout)
  in
  let+ result = Lwt.pick [ fetch; timed_out ] in
  match result with
  | `Not_modified -> Unchanged
  | `Failed e -> Failed e
  | `Ok (contents, new_etag) -> (
      let open Ocamlorg_doc_modules in
      match
        Result.bind (Reader.of_string contents) (fun t ->
            Result.map (fun () -> t) (Reader.verify t))
      with
      | Error e -> Failed ("the downloaded index is damaged: " ^ e)
      | Ok t -> (
          try
            write_atomically path contents;
            (match new_etag with
            | Some e -> write_atomically etag_path e
            | None -> ( try Sys.remove etag_path with Sys_error _ -> ()));
            Updated (Reader.key_count t)
          with Sys_error e -> Failed e))

(* Bring the index at [path] up to date. Returns whether a valid index is in
   place afterwards. Never raises. *)
let run path =
  let+ outcome = update path in
  (match outcome with
  | Unchanged -> Logs.info (fun m -> m "Doc-modules index up to date")
  | Updated n ->
      Logs.info (fun m -> m "Doc-modules index updated (%d module paths)" n)
  | Failed e ->
      Logs.warn (fun m ->
          m "Doc-modules index not updated (%s): keeping the current one" e));
  valid_index (Fpath.to_string path)
