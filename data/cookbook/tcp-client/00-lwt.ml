---
packages:
- name: lwt
  tested_version: "5.9.0"
  used_libraries:
  - lwt
  - lwt.unix
---

let ( let* ) = Lwt.bind

(* Connect to the server and send/receive messages. We resolve
   the host address using `Lwt_unix.getaddrinfo`, which performs
   asynchronous DNS resolution to obtain the server's address. *)
let echo_client host port =
  let* addr_info =
    Lwt_unix.getaddrinfo
      host
      (string_of_int port)
      [Unix.(AI_FAMILY PF_INET)]
  in
  let* addr =
    match addr_info with
    | [] -> Lwt.fail_with "Failed to resolve host"
    | addr :: _ -> Lwt.return addr.Unix.ai_addr
  in
(* Create a socket for communication using `Lwt_unix.socket`, which
   creates a non-blocking socket for asynchronous I/O. *)
  let socket =
    Lwt_unix.socket Unix.PF_INET Unix.SOCK_STREAM 0
  in
(* Connect the socket to the resolved address using `Lwt_unix.connect`,
   which establishes a connection in a non-blocking manner. *)
  let* () = Lwt_unix.connect socket addr in
  let input =
    Lwt_io.of_fd ~mode:Lwt_io.input socket
  in
  let output =
    Lwt_io.of_fd ~mode:Lwt_io.output socket
  in

(* Read a line from standard input using `Lwt_io.read_line`, which
       is a non-blocking read operation.
   Send the message to the server using `Lwt_io.write_line`, which
       writes asynchronously to the output.
   Read the server's response using `Lwt_io.read_line`, which
       is also non-blocking. *)
  let rec send_messages () =
    let* message = Lwt_io.read_line Lwt_io.stdin in
    let* () = Lwt_io.write_line output message in
    let* response = Lwt_io.read_line input in
    let* () =
      Lwt_io.printlf "Server replied: %s" response
    in
    send_messages ()
  in
  send_messages ()
;;

(* Run the echo_client function within the Lwt main loop *)
let () =
  let host = "127.0.0.1" and port = 12345 in
  Lwt_main.run (echo_client host port)
