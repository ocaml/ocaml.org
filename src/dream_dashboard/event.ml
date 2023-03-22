type referer = { url : string; favicon : string option }

type t = {
  url : string;
  ua : User_agent.t;
  referer : referer option;
  timestamp : float;
  ip_digest : string;
  ip_info : Ip_info.t option;
}

let _get_favicon_of_referer url =
  let open Lwt.Syntax in
  let host = url |> Uri.of_string |> Uri.host |> Option.get in
  let favicon_url = Uri.with_path (url |> Uri.of_string) "favicon.ico" in
  let+ response =
    Hyper.run
    @@ Hyper.request
         ~headers:[ ("Host", host); ("User-Agent", "hyper") ]
         (Uri.to_string favicon_url)
  in
  match Dream.status response with
  | #Dream.successful -> Some (Uri.to_string favicon_url)
  | _ -> None

let create ~ua ~url ~referer ~client =
  let open Lwt.Syntax in
  let timestamp = Unix.gettimeofday () in
  let host_opt = client |> Uri.of_string |> Uri.host in
  let* referer =
    match referer with
    | Some url ->
        (* let+ favicon = get_favicon_of_referer url in *)
        Lwt.return (Some { url; favicon = None })
    | None -> Lwt.return None
  in
  match host_opt with
  | None ->
      Lwt.return
        { url; ua; referer; timestamp; ip_digest = "none"; ip_info = None }
  | Some _ ->
      (* TODO: we need a more secure way to protect the IP:

         - We should remove the data every 30 days

         - We need to use a salt when hashing the IPs *)
      (* let+ ip_info = Ip_info.get ip in let ip_digest =
         Digestif.SHA256.digest_string ip |> Digestif.SHA256.to_raw_string in {
         url; ua; referer; timestamp; ip_digest; ip_info } *)
      Lwt.return
        { url; ua; referer; timestamp; ip_digest = "none"; ip_info = None }

let get_count ~get_el events =
  let hashtbl = Hashtbl.create 256 in
  let rec aux = function
    | [] -> ()
    | el :: rest ->
        let () =
          match get_el el with
          | None -> ()
          | Some el -> (
              match Hashtbl.find_opt hashtbl el with
              | Some i -> Hashtbl.replace hashtbl el (i + 1)
              | None -> Hashtbl.add hashtbl el 1)
        in
        aux rest
  in

  aux events;
  hashtbl |> Hashtbl.to_seq |> List.of_seq
  |> List.sort (fun (_, count_1) (_, count_2) -> Int.compare count_2 count_1)

let top_pages events = get_count ~get_el:(fun event -> Some event.url) events

let top_browsers events =
  get_count ~get_el:(fun event -> Some event.ua.ua_family) events

let top_os events =
  get_count ~get_el:(fun event -> Some event.ua.os_family) events

let top_devices events =
  get_count ~get_el:(fun event -> Some event.ua.device_family) events

let top_referers events = get_count ~get_el:(fun event -> event.referer) events

let top_countries events =
  get_count
    ~get_el:(fun event ->
      Option.map (fun info -> info.Ip_info.country) event.ip_info)
    events

let unique_visitors events =
  get_count ~get_el:(fun event -> Some event.ip_digest) events

let total_unique_visitors events = List.length (unique_visitors events)
