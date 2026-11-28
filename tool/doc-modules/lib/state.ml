(* The scrape state: per package, its candidate versions and, if it has docs,
   the version they come from, its module paths and the ETag they were fetched
   with.

   Stored as JSONL: a header line {"format": "ocamlorg-doc-modules-state",
   "version": 2}, then one object per package, sorted by name: {"name",
   "latest", "candidates", "docs": {"version", "modules", "etag"}}, "docs"
   absent for a package without docs, "etag" absent if the backend sent none.
   The output is regenerated from it, never read back. *)

type docs = { version : string; modules : string list; etag : string option }

type entry = {
  latest : string;
  candidates : string list;  (** newest first, [latest] the first *)
  docs : docs option;  (** [None]: no docs *)
}

module M = Map.Make (String)

type t = entry M.t

let format = "ocamlorg-doc-modules-state"
let version = 2
let empty = M.empty

let entry_to_json name e =
  `Assoc
    ([
       ("name", `String name);
       ("latest", `String e.latest);
       ("candidates", `List (List.map (fun s -> `String s) e.candidates));
     ]
    @
    match e.docs with
    | None -> []
    | Some d ->
        [
          ( "docs",
            `Assoc
              ([
                 ("version", `String d.version);
                 ("modules", `List (List.map (fun s -> `String s) d.modules));
               ]
              @
              match d.etag with
              | None -> []
              | Some e -> [ ("etag", `String e) ]) );
        ])

let to_string t =
  let b = Buffer.create (1024 * 1024) in
  Buffer.add_string b
    (Yojson.Safe.to_string
       (`Assoc [ ("format", `String format); ("version", `Int version) ]));
  Buffer.add_char b '\n';
  M.iter
    (fun name e ->
      Buffer.add_string b (Yojson.Safe.to_string (entry_to_json name e));
      Buffer.add_char b '\n')
    t;
  Buffer.contents b

exception Bad of string

let strings = function
  | `List l ->
      List.map
        (function `String s -> s | _ -> raise (Bad "expected strings"))
        l
  | _ -> raise (Bad "expected a list")

let entry_of_json = function
  | `Assoc f ->
      let str k =
        match List.assoc_opt k f with
        | Some (`String s) -> s
        | _ -> raise (Bad ("missing " ^ k))
      in
      let docs =
        match List.assoc_opt "docs" f with
        | None -> None
        | Some (`Assoc d) ->
            let version =
              match List.assoc_opt "version" d with
              | Some (`String s) -> s
              | _ -> raise (Bad "docs: missing version")
            in
            let modules =
              strings (Option.value (List.assoc_opt "modules" d) ~default:`Null)
            in
            let etag =
              match List.assoc_opt "etag" d with
              | Some (`String s) -> Some s
              | _ -> None
            in
            Some { version; modules; etag }
        | Some _ -> raise (Bad "docs: expected an object")
      in
      ( str "name",
        {
          latest = str "latest";
          candidates =
            strings
              (Option.value (List.assoc_opt "candidates" f) ~default:`Null);
          docs;
        } )
  | _ -> raise (Bad "expected an object")

let of_string s =
  match
    String.split_on_char '\n' s |> List.filter (fun l -> l <> "") |> function
    | [] -> raise (Bad "empty")
    | h :: rest ->
        (match Yojson.Safe.from_string h with
        | `Assoc f
          when List.assoc_opt "format" f = Some (`String format)
               && List.assoc_opt "version" f = Some (`Int version) ->
            ()
        | _ -> raise (Bad "not a state of this version"));
        List.fold_left
          (fun t l ->
            let name, e = entry_of_json (Yojson.Safe.from_string l) in
            M.add name e t)
          M.empty rest
  with
  | t -> Ok t
  | exception Bad e -> Error e
  | exception Yojson.Json_error e -> Error e

(* Attempts, tried in order until one answers 200 or 304: a version, and whether
   to send the ETag. [None]: not asked this run. - docs known: revalidate the
   docs version, but try the latest first if it is newer; then the other
   candidates, in case the docs version stopped answering; - no docs, and either
   changed candidates or its re-probe day: every candidate; - no docs otherwise:
   not asked; - unknown package: every candidate. *)
type attempt = { version : string; conditional : bool }

(* Packages without docs are asked again once every [every] days, a different
   share of them each day. *)
let due ~day ~every name =
  let h =
    String.fold_left
      (fun h c ->
        let code = Char.code c in
        let ord = if code >= 32 && code < 127 then code else 0 in
        ((h * 31) + ord) mod 9973)
      0 name
  in
  (h + day) mod every = 0

let attempts ~day ~every name previous candidates =
  let all () =
    Some (List.map (fun version -> { version; conditional = false }) candidates)
  in
  match (previous, candidates) with
  | _, [] -> Some []
  | Some { docs = Some d; _ }, latest :: _ ->
      let first =
        if d.version <> latest then
          [ { version = latest; conditional = false } ]
        else []
      in
      let others =
        List.filter (fun v -> v <> latest && v <> d.version) candidates
        |> List.map (fun version -> { version; conditional = false })
      in
      Some (first @ ({ version = d.version; conditional = true } :: others))
  | Some ({ docs = None; _ } as e), _
    when e.candidates = candidates && not (due ~day ~every name) ->
      None
  | _ -> all ()
