let get_sync url =
  let open Piaf in
  let open Lwt_result.Syntax in
  let config = Config.{ default with follow_redirects = true } in
  Lwt_main.run
    (let* response = Client.Oneshot.get ~config (Uri.of_string url) in
     let message = Status.to_string response.status in
     if Status.is_successful response.status then (
       print_endline (Printf.sprintf "GET %s returned %s" url message);
       Body.to_string response.body)
     else
       raise (Failure (Printf.sprintf "GET %s returned %s" url message)))
