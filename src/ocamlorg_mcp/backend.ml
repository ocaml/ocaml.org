(* SSRF guard for the MCP endpoint (issue #3775, Phase 2). A public, no-auth
   server that fetches URLs is an SSRF vector, so every outbound request a tool
   makes must route through [check_url] against a fixed allowlist of backend
   origins. Only [https] to an allowlisted host is permitted.

   No tool fetches a backend yet (Phase 2 ships only the no-op [ping]); this is
   the single choke point Block B's docs-ci proxy must go through when it
   lands. *)

type t = { hosts : string list (* allowlisted hostnames, lowercased *) }

(* Split [s] at the first occurrence of [sep] into the part before and after, or
   [None] if [sep] is absent. Local helper to avoid an astring dependency. *)
let cut ~sep s =
  let sep_len = String.length sep in
  let n = String.length s in
  let rec find i =
    if i + sep_len > n then None
    else if String.sub s i sep_len = sep then
      Some (String.sub s 0 i, String.sub s (i + sep_len) (n - i - sep_len))
    else find (i + 1)
  in
  find 0

let scheme_of_url url =
  match cut ~sep:"://" url with
  | Some (scheme, _) -> Some (String.lowercase_ascii scheme)
  | None -> None

(* Extract the lowercased host from a [scheme://host[:port]/...] URL, ignoring
   any path, userinfo or port. *)
let host_of_url url =
  match cut ~sep:"://" url with
  | None -> None
  | Some (_scheme, rest) ->
      let authority =
        match String.index_opt rest '/' with
        | Some i -> String.sub rest 0 i
        | None -> rest
      in
      (* strip userinfo *)
      let authority =
        match String.rindex_opt authority '@' with
        | Some i ->
            String.sub authority (i + 1) (String.length authority - i - 1)
        | None -> authority
      in
      (* strip port *)
      let host =
        match String.index_opt authority ':' with
        | Some i -> String.sub authority 0 i
        | None -> authority
      in
      if host = "" then None else Some (String.lowercase_ascii host)

(* [create origins] builds the allowlist from a list of backend URLs/origins
   (e.g. the docs-ci endpoints); their hosts are what we permit. *)
let create origins = { hosts = List.filter_map host_of_url origins }

(* Permit only https to an allowlisted host; reject everything else. *)
let check_url t url : (string, string) result =
  match (scheme_of_url url, host_of_url url) with
  | Some "https", Some host when List.mem host t.hosts -> Ok url
  | Some "https", Some host -> Error ("host not allowlisted: " ^ host)
  | Some scheme, _ -> Error ("scheme not permitted: " ^ scheme)
  | None, _ -> Error "malformed URL"
