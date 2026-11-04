(* Build a [Profile.t] from Plausible's Stats API v2.

   Three queries over the same period: total pageviews (the mean rate), a
   breakdown by hour (the diurnal shape), and a breakdown by page (the mix). The
   page breakdown is capped at [limit] pages; the pageviews of the pages below
   the cap (the long tail) are given to the package-page placeholders, in
   proportion to how much each package page class weighs in the top pages.

   Plausible only counts browsers that run its script: crawlers and scrapers are
   invisible to it. [Traffic] adds them as a separate, synthetic stream. *)

open Lwt.Syntax

let query ~site ~period ?(dimensions = []) ?limit () : Yojson.Safe.t =
  `Assoc
    ([
       ("site_id", `String site);
       ("metrics", `List [ `String "pageviews" ]);
       ("date_range", `String period);
       ("dimensions", `List (List.map (fun d -> `String d) dimensions));
     ]
    @
    match limit with
    | None -> []
    | Some n ->
        [
          ("order_by", `List [ `List [ `String "pageviews"; `String "desc" ] ]);
          ("pagination", `Assoc [ ("limit", `Int n) ]);
        ])

(* [(dimensions, pageviews)] rows of a v2 response. *)
let rows (j : Yojson.Safe.t) =
  let open Yojson.Safe.Util in
  j |> member "results" |> to_list
  |> List.map (fun r ->
         let dims = r |> member "dimensions" |> to_list |> List.map to_string in
         let v =
           match r |> member "metrics" |> to_list with
           | v :: _ -> Profile.number v
           | [] -> 0.
         in
         (dims, v))

(* Plausible v2 renders [time:hour] as ["YYYY-MM-DD HH:MM:SS"] (older releases
   used a ['T'] separator); either way the hour is at offset 11. *)
let hour_of s =
  if String.length s >= 13 then int_of_string_opt (String.sub s 11 2) else None

(* Plausible reports [time:hour] in the site's reporting timezone, and the API
   cannot ask for another; [Profile.hourly] is in UTC. [utc_offset] is that
   timezone's offset from UTC in hours (2 for Europe/Paris in summer): a
   pageview at local hour [h] goes to UTC hour [h - utc_offset]. *)
let hourly ?(utc_offset = 0) rows =
  let a = Array.make 24 0. in
  List.iter
    (fun (dims, v) ->
      match dims with
      | [ t ] -> (
          match hour_of t with
          | Some h when h >= 0 && h < 24 ->
              let u = (((h - utc_offset) mod 24) + 24) mod 24 in
              a.(u) <- a.(u) +. v
          | _ -> ())
      | _ -> ())
    rows;
  Profile.normalise_hourly a

let placeholder = function
  | "pkg" -> Some "/p/{pkg}"
  | "pkg-ver" -> Some "/p/{pkg}/{ver}"
  | "pkg-doc" -> Some "/p/{pkg}/{ver}/doc/index.html"
  | _ -> None

(* Top pages plus the long tail folded into placeholders. *)
let pages ~total rows =
  let top =
    List.filter_map
      (function [ path ], v when v > 0. -> Some (path, v) | _ -> None)
      rows
  in
  let top_sum = List.fold_left (fun acc (_, v) -> acc +. v) 0. top in
  let tail = Float.max 0. (total -. top_sum) in
  let by_class = Hashtbl.create 8 in
  List.iter
    (fun (path, v) ->
      match placeholder (Profile.classify path) with
      | Some ph ->
          let w = Option.value ~default:0. (Hashtbl.find_opt by_class ph) in
          Hashtbl.replace by_class ph (w +. v)
      | None -> ())
    top;
  let class_sum = Hashtbl.fold (fun _ w acc -> acc +. w) by_class 0. in
  let tail_pages =
    if tail <= 0. then []
    else if class_sum <= 0. then [ ("/p/{pkg}", tail) ]
    else
      Hashtbl.fold
        (fun ph w acc -> (ph, tail *. w /. class_sum) :: acc)
        by_class []
      |> List.sort compare
  in
  top @ tail_pages
  |> List.map (fun (path, weight) -> { Profile.path; weight })
  |> Array.of_list

let period_seconds = function
  | "day" -> Some 86400.
  | "7d" -> Some (7. *. 86400.)
  | "28d" -> Some (28. *. 86400.)
  | "30d" -> Some (30. *. 86400.)
  | "91d" -> Some (91. *. 86400.)
  | "month" -> None
  | p -> (
      match Scanf.sscanf_opt p "%dd%!" Fun.id with
      | Some d -> Some (float_of_int d *. 86400.)
      | None -> None)

let profile ?(utc_offset = 0) ~site ~period ~total_rows ~hour_rows ~page_rows ()
    =
  let total =
    match total_rows with (_, v) :: _ -> v | [] -> failwith "no total"
  in
  let seconds =
    match period_seconds period with
    | Some s -> s
    | None -> failwith ("unsupported period (use e.g. 30d): " ^ period)
  in
  {
    Profile.source =
      Printf.sprintf "plausible:%s:%s:utc%+d" site period utc_offset;
    base_rps = total /. seconds;
    hourly = hourly ~utc_offset hour_rows;
    pages = pages ~total page_rows;
  }

let post ~base ~key body =
  let uri = Uri.of_string (base ^ "/api/v2/query") in
  let headers =
    Cohttp.Header.of_list
      [
        ("Authorization", "Bearer " ^ key); ("Content-Type", "application/json");
      ]
  in
  let body = Cohttp_lwt.Body.of_string (Yojson.Safe.to_string body) in
  let* resp, body = Cohttp_lwt_unix.Client.post ~headers ~body uri in
  let* s = Cohttp_lwt.Body.to_string body in
  match Cohttp.Response.status resp with
  | `OK -> Lwt.return (Yojson.Safe.from_string s)
  | st ->
      Lwt.fail_with
        (Printf.sprintf "Plausible %s: %s" (Cohttp.Code.string_of_status st) s)

let fetch ?utc_offset ~base ~key ~site ~period ~limit () =
  let q = query ~site ~period in
  let* total = post ~base ~key (q ()) in
  let* hours = post ~base ~key (q ~dimensions:[ "time:hour" ] ()) in
  let+ pages = post ~base ~key (q ~dimensions:[ "event:page" ] ~limit ()) in
  profile ?utc_offset ~site ~period ~total_rows:(rows total)
    ~hour_rows:(rows hours) ~page_rows:(rows pages) ()
