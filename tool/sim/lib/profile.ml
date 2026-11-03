(* A traffic profile: what human visitors request, and how fast.

   A profile is source-agnostic: it is produced from Plausible ([Plausible]),
   from access logs ([Access_log]), or written by hand ([profiles/sample.json]),
   and consumed by [Traffic].

   Page paths may contain the placeholders [{pkg}] and [{ver}], replaced at
   request time by a random package (and one of its versions) from the opam
   repository the server is running on. They stand for the long tail of package
   pages, which no top-N list captures. *)

type page = { path : string; weight : float }

type t = {
  source : string;  (** where the profile came from, for the record *)
  base_rps : float;  (** mean page requests per second, over the day *)
  hourly : float array;
      (** 24 relative weights, one per UTC hour, normalised to mean 1 *)
  pages : page array;
}

let normalise_hourly a =
  let a = if Array.length a = 24 then a else Array.make 24 1. in
  let mean = Array.fold_left ( +. ) 0. a /. 24. in
  if mean <= 0. then Array.make 24 1. else Array.map (fun x -> x /. mean) a

let to_json t : Yojson.Safe.t =
  `Assoc
    [
      ("source", `String t.source);
      ("base_rps", `Float t.base_rps);
      ("hourly", `List (Array.to_list t.hourly |> List.map (fun x -> `Float x)));
      ( "pages",
        `List
          (Array.to_list t.pages
          |> List.map (fun p ->
                 `Assoc
                   [ ("path", `String p.path); ("weight", `Float p.weight) ]))
      );
    ]

let number = function
  | `Float f -> f
  | `Int i -> float_of_int i
  | _ -> failwith "profile: expected a number"

let of_json (j : Yojson.Safe.t) =
  let open Yojson.Safe.Util in
  {
    source =
      j |> member "source" |> to_string_option |> Option.value ~default:"";
    base_rps = j |> member "base_rps" |> number;
    hourly =
      j |> member "hourly" |> to_list |> List.map number |> Array.of_list
      |> normalise_hourly;
    pages =
      j |> member "pages" |> to_list
      |> List.map (fun p ->
             {
               path = p |> member "path" |> to_string;
               weight = p |> member "weight" |> number;
             })
      |> List.filter (fun p -> p.weight > 0.)
      |> Array.of_list;
  }

let load path = of_json (Yojson.Safe.from_file path)
let save path t = Yojson.Safe.to_file path (to_json t)

(* Weighted sampling: cumulative weights and a binary search. *)
type sampler = { cumulative : float array; paths : string array }

let sampler t =
  let n = Array.length t.pages in
  if n = 0 then invalid_arg "Profile.sampler: no pages";
  let cumulative = Array.make n 0. in
  let acc = ref 0. in
  Array.iteri
    (fun i p ->
      acc := !acc +. p.weight;
      cumulative.(i) <- !acc)
    t.pages;
  { cumulative; paths = Array.map (fun p -> p.path) t.pages }

let pick s r =
  (* [r] is uniform in [0, 1) *)
  let n = Array.length s.cumulative in
  let x = r *. s.cumulative.(n - 1) in
  let rec go lo hi =
    if lo >= hi then lo
    else
      let mid = (lo + hi) / 2 in
      if s.cumulative.(mid) > x then go lo mid else go (mid + 1) hi
  in
  s.paths.(go 0 (n - 1))

(* Coarse page classes, used to break latencies down and to fold the long tail
   of a profile into placeholders. *)
let classify path =
  let path =
    match String.index_opt path '?' with
    | Some i -> String.sub path 0 i
    | None -> path
  in
  let segs = String.split_on_char '/' path |> List.filter (( <> ) "") in
  let static_ext =
    List.exists
      (fun e -> Filename.check_suffix path e)
      [
        ".css"; ".js"; ".png"; ".svg"; ".jpg"; ".ico"; ".woff2"; ".xml"; ".txt";
      ]
  in
  if static_ext then "static"
  else
    match segs with
    | [] -> "home"
    | [ "p"; _ ] -> "pkg"
    | [ "p"; _; _ ] -> "pkg-ver"
    | "p" :: _ :: _ :: "doc" :: _ -> "pkg-doc"
    | "p" :: _ -> "pkg-other"
    | ("packages" | "search") :: _ -> "packages"
    | "u" :: _ -> "universe"
    | ("learn" | "docs" | "exercises" | "cookbook") :: _ -> "learn"
    | "manual" :: _ -> "manual"
    | "api" :: _ -> "api"
    | ("blog" | "ocaml-planet" | "news" | "changelog" | "backstage") :: _ ->
        "news"
    | _ -> "other"
