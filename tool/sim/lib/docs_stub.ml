(* A stand-in for the external documentation server.

   The server fetches documentation status and pages from an external host for
   package pages. In a simulation, that makes package-page latency depend on the
   network and on name resolution inside the container, which failed
   intermittently in our runs and caused most of the slow requests. By default,
   `sim run` points the server at this stub instead: a minimal HTTP responder on
   the host, reached by IP address (so no name resolution is involved), that
   answers every request with 404, which the server treats as "no documentation
   built". Package pages then exercise the server's no-documentation path,
   deterministically and without the network.

   Requests are counted per kind ([status.json], [HEAD], other) for the run's
   record. *)

open Lwt.Syntax

type t = { server : Lwt_io.server; counts : (string, int) Hashtbl.t }

let response =
  "HTTP/1.1 404 Not Found\r\nContent-Length: 0\r\nConnection: close\r\n\r\n"

let kind request_line =
  match String.split_on_char ' ' request_line with
  | "HEAD" :: _ -> "head"
  | _ :: path :: _ when Filename.check_suffix path "status.json" ->
      "status_json"
  | _ -> "other"

(* Read the request head (up to the empty line), answer 404, close. *)
let handle counts (ic, oc) =
  Lwt.catch
    (fun () ->
      let* first = Lwt_io.read_line ic in
      let rec skip () =
        let* line = Lwt_io.read_line ic in
        if String.trim line = "" then Lwt.return_unit else skip ()
      in
      let* () = skip () in
      let k = kind first in
      Hashtbl.replace counts k
        (1 + Option.value ~default:0 (Hashtbl.find_opt counts k));
      Lwt_io.write oc response)
    (fun _ -> Lwt.return_unit)

let start ~host ~port =
  let counts = Hashtbl.create 4 in
  let addr = Unix.ADDR_INET (Unix.inet_addr_of_string host, port) in
  let+ server =
    Lwt_io.establish_server_with_client_address addr (fun _ chans ->
        handle counts chans)
  in
  { server; counts }

let stop t = Lwt_io.shutdown_server t.server

let counts t =
  Hashtbl.fold (fun k n acc -> (k, n) :: acc) t.counts [] |> List.sort compare
