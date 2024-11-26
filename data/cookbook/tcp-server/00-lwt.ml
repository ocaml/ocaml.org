---
packages:
- name: lwt
  tested_version: "5.9.0"
  used_libraries:
  - lwt
  - lwt.unix
---

let ( let* ) = Lwt.bind

(* Handles communication with a connected client by echoing received lines back. *)
let handle_client (input, output) =
  let rec echo_loop () =
    let* line_opt = Lwt_io.read_line_opt input in
(* `Lwt_io.read_line_opt`: Asynchronously reads a line from the input. Returns None if the client disconnects. *)
    match line_opt with
    | None -> Lwt_io.printl "Client disconnected"
(* `Lwt_io.printl`: Asynchronously prints a line to stdout. `Lwt_io.write_line`:
  Asynchronously writes a line to the output. *)
    | Some line ->
        let* () = Lwt_io.printl ("Received: " ^ line) in
        let* () = Lwt_io.write_line output line in
        echo_loop ()
  in
  echo_loop ()

(* Accepts incoming client connections and starts handling them. *)
let rec accept_connections server_socket =
  let* (client_socket, _addr) =
(* `Lwt_unix.accept`: Asynchronously accepts a new connection on the server socket. *)
  Lwt_unix.accept server_socket in
  let input =
    Lwt_io.of_fd ~mode:Lwt_io.input client_socket in
  let output =
    Lwt_io.of_fd ~mode:Lwt_io.output client_socket in

(* `Lwt.async`: Schedules the handling of the client in a separate thread. *)
  Lwt.async (fun () -> handle_client (input, output));
  accept_connections server_socket

(* Initializes the server socket and starts accepting connections on the specified port. *)
let start_server port =
  let sockaddr =
    Unix.(ADDR_INET (inet_addr_any, port)) in
  let server_socket =
    Lwt_unix.socket Unix.PF_INET Unix.SOCK_STREAM 0 in

  Lwt_unix.setsockopt
    server_socket Unix.SO_REUSEADDR true;
(* `Lwt_unix.bind`: Asynchronously binds the server socket to the specified address.
   `Lwt_unix.listen`: Prepares the socket to accept incoming connections. *)
  let* () = Lwt_unix.bind server_socket sockaddr in
  Lwt_unix.listen server_socket 10;
  let* () =
    Lwt_io.printlf "Server started on port %d" port
  in
  accept_connections server_socket

(* `Lwt_main.run`: Runs the Lwt main loop, starting the server. *)
let () =
  let port = 12345 in
  Lwt_main.run (start_server port)
