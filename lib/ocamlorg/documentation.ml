module Package = struct
  type status =
    | Built of string
    | Pending
    | Failed
    | Unknown

  type t = status

  let status t = t
end

module Universe = struct
  type t =
    { deps : OpamPackage.t list
    ; hash : string
    }

  let deps t = t.deps

  let hash t = t.hash
end

module StringMap = OpamStd.String.Map

module Stats = struct
  type status_count =
    { total : int
    ; failed : int
    ; pending : int
    ; success : int
    }

  let to_string { total; failed; pending; success } =
    let pending =
      match pending with 0 -> "" | _ -> Fmt.str "/ %d 🟠" pending
    in
    let failed = match failed with 0 -> "" | _ -> Fmt.str "/ %d ❌" failed in
    Fmt.str "%d ↦ %d 📗 %s %s" total success pending failed

  type t =
    { opam : status_count
    ; versions : status_count
    ; universes : status_count
    }

  let empty =
    let empty_status () = { total = 0; failed = 0; pending = 0; success = 0 } in
    { opam = empty_status ()
    ; versions = empty_status ()
    ; universes = empty_status ()
    }

  type kind =
    | Opam
    | Version
    | Universe

  let update_status sc = function
    | `FAILED ->
      { sc with total = sc.total + 1; failed = sc.failed + 1 }
    | `PENDING ->
      { sc with total = sc.total + 1; pending = sc.pending + 1 }
    | `SUCCESS ->
      { sc with total = sc.total + 1; success = sc.success + 1 }
    | _ ->
      sc

  let update stats kind status =
    match kind with
    | Opam ->
      { stats with opam = update_status stats.opam status }
    | Version ->
      { stats with versions = update_status stats.versions status }
    | Universe ->
      { stats with universes = update_status stats.universes status }
end

type t =
  { mutable packages : Package.t OpamPackage.Map.t
  ; universes : Universe.t StringMap.t
  ; mutable static_files_endpoint : string
  ; mutable stats : Stats.t
  }

type error = [ `Not_found ]

open Lwt.Syntax

module type S = sig
  type t

  module Raw : sig
    type t
  end

  val query : string

  val unsafe_fromJson : Yojson.Basic.t -> Raw.t

  val parse : Raw.t -> t
end

let get_cohttp (type a) (module Api : S with type t = a) ~api () =
  let body = `Assoc [ "query", `String Api.query; "variables", `Null ] in
  let serialized_body = Yojson.Basic.to_string body in
  let headers = Cohttp.Header.of_list [ "Content-Type", "application/json" ] in
  let* response, body =
    Cohttp_lwt_unix.Client.post ~headers ~body:(`String serialized_body) api
  in
  let* body = Cohttp_lwt.Body.to_string body in
  match Cohttp.Code.(code_of_status response.status |> is_success) with
  | false ->
    Lwt.fail
      (Failure ("Status: " ^ Cohttp.Code.string_of_status response.status))
  | true ->
    let json = Yojson.Basic.(from_string body |> Util.member "data") in
    Lwt.return (Api.unsafe_fromJson json |> Api.parse)

let get_last_update ~api () =
  let+ res = get_cohttp (module Docs_api.Last_update) ~api () in
  res.last_update

let get_packages = get_cohttp (module Docs_api.Packages)

let parse_status t =
  let open Docs_api.Packages in
  match t.status with
  | `FAILED ->
    Package.Failed
  | `PENDING ->
    Pending
  | `SUCCESS ->
    Built (t.blessed_universe |> Option.get)
  | `FutureAddedValue _ ->
    failwith "Unsupported value"

let parse_version ~stats version =
  let open Docs_api.Packages in
  let () =
    stats := Stats.update !stats Version version.status;
    version.universes
    |> Array.iter (fun (universe : t_packages_versions_universes) ->
           stats := Stats.update !stats Universe universe.status)
  in
  ( OpamPackage.create
      (OpamPackage.Name.of_string version.name)
      (OpamPackage.Version.of_string version.version)
  , parse_status version )

let parse_package ~stats package =
  let open Docs_api.Packages in
  let () =
    let last_version =
      package.versions
      |> Array.fold_left
           (fun max_s s ->
             match max_s with
             | None ->
               Some s
             | Some s' when s.version > s'.version ->
               Some s
             | Some s' ->
               Some s')
           None
      |> Option.get
    in
    stats := Stats.update !stats Opam last_version.status
  in
  package.versions |> Array.to_seq |> Seq.map (parse_version ~stats)

let parse data =
  let open Docs_api.Packages in
  let stats = ref Stats.empty in
  let data =
    data.packages
    |> Array.to_seq
    |> Seq.flat_map (parse_package ~stats)
    |> OpamPackage.Map.of_seq
  in
  data, !stats

let make ~api ~polling () =
  let res =
    { packages = OpamPackage.Map.empty
    ; universes = StringMap.empty
    ; static_files_endpoint = ""
    ; stats = Stats.empty
    }
  in
  let update_docs_status () =
    Dream.log "Docs: updating docs status.";
    let+ data = get_packages ~api () in
    let packages, stats = parse data in
    res.packages <- packages;
    res.stats <- stats;
    res.static_files_endpoint <- data.static_files_endpoint
  in
  let last_update = ref "" in
  let rec updater () =
    let* () =
      Lwt.catch
        (fun () ->
          let* v = get_last_update ~api () in
          if v <> !last_update then
            let+ () = update_docs_status () in
            last_update := v
          else
            Lwt.return_unit)
        (fun exn ->
          Dream.error (fun log ->
              log
                "Failed to contact the graphql api: %s"
                (Printexc.to_string exn));
          Lwt.return ())
    in
    let* () = Lwt_unix.sleep (float_of_int polling) in
    updater ()
  in
  Lwt.async updater;
  res

let stats t = t.stats

let package_info t pkg = OpamPackage.Map.find_opt pkg t.packages

let universe_info t univ = StringMap.find_opt univ t.universes

let extract_docs_body html =
  let open Soup in
  let soup = parse html in
  let preamble =
    soup
    |> select_one ".odoc-preamble"
    |> Option.map to_string
    |> Option.value ~default:""
  in
  let toc =
    soup
    |> select_one ".odoc-toc"
    |> Option.map to_string
    |> Option.value ~default:""
  in
  let content =
    soup
    |> select_one ".odoc-content"
    |> Option.map to_string
    |> Option.value ~default:""
  in
  toc ^ preamble ^ content

let try_load ~t path =
  let uri = Uri.of_string (t.static_files_endpoint ^ path) in
  Dream.log "Proxy request => %a" Uri.pp_hum uri;
  let* response, body = Cohttp_lwt_unix.Client.get uri in
  if response.status == `OK then
    let+ body = body |> Cohttp_lwt.Body.to_string in
    body |> extract_docs_body |> Tyxml.Html.Unsafe.data |> Result.ok
  else
    let+ () = Cohttp_lwt.Body.drain_body body in
    Error `Not_found

let load t path =
  let res () =
    (* if the link ends by .html, it's something from odoc. just trust it *)
    if Astring.String.is_suffix ~affix:".html" path then
      try_load ~t path
    else
      (* otherwise, we're probably pointing to a package index page. It can
         either be the index.html of the target folder, or a single file name
         <target folder>.html. We try both. *)
      let* load = try_load ~t (path ^ "/index.html") in
      match load with
      | Ok v ->
        Lwt.return_ok v
      | Error _ ->
        try_load ~t (Astring.String.trim ~drop:(( = ) '/') path ^ ".html")
  in
  res ()
