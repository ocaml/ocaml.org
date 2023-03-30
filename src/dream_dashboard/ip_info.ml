type json = {
  ip_address : string; [@key "ipAddress"]
  continent_code : string; [@key "continentCode"]
  continent_name : string; [@key "continentName"]
  country_code : string; [@key "countryCode"]
  country_name : string; [@key "countryName"]
  state_province : string; [@key "stateProv"]
  city : string; [@key "city"]
}
[@@deriving yojson]

type t = { continent : string; country : string; city : string }

let cache = Hashtbl.create 512

let digest ip =
  Digestif.SHA256.digest_string ip |> Digestif.SHA256.to_raw_string

let query_dbip ip =
  let response =
    Hyper.get
      ~headers:
        [
          ("Host", "api.db-ip.com");
          ("User-Agent", "hyper");
          ("Accept", "application/json");
        ]
      (Printf.sprintf "http://api.db-ip.com/v2/free/%s" ip)
  in
  let json = Yojson.Safe.from_string response in
  match json_of_yojson json with
  | Ok json ->
      Ok
        {
          continent = json.continent_name;
          country = json.country_name;
          city = json.city;
        }
  | Error err -> Error err

let get ip =
  (* To improve:

     - Check that the IP is actually an IP. So we don't query the dbip API for
     nothing.

     - Store the errors in the cache, so we don't query the same IP if the
     answer is an error. *)
  let ip_digest = digest ip in
  match Hashtbl.find_opt cache ip_digest with
  | Some x -> Some x
  | None -> (
      let result = query_dbip ip in
      match result with
      | Ok x ->
          Hashtbl.add cache ip_digest x;
          Some x
      | Error err ->
          Dream.error (fun m ->
              m "Could not get the location from the IP address: %s" err);
          None)
