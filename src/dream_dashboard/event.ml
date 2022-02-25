type t = {
  url : string;
  ua : User_agent.t;
  referer : string option;
  timestamp : float;
  ip_digest : string;
  ip_info : Ip_info.t option;
}

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
      match event.ip_info with
      | None -> None
      | Some info -> Some info.Ip_info.country)
    events

let unique_visitors events =
  get_count ~get_el:(fun event -> Some event.ip_digest) events
