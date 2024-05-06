---
packages:
- name: lwt
  tested_version: "5.7.0"
  used_libraries:
  - lwt
  - lwt.unix
- name: logs
  tested_version: "0.7.0"
  used_libraries:
  - logs
discussion: |
  - **Understanding TCP server:** Implementing a TCP server needs to initialise a main socket file descriptor that will be used to accept connections. Each connection is associated to a dedicated file descriptor, which is used to create input and output channels. Since the server has to handle multiple connections concurrently, we have to use the Lwt scheduling and have multiple concurrent promises. The I/O functions provided by `Lwt_unix` must be used instead of blocking functions from other libraries.
  - **Alternative Libraries:** Other concurrent libraries can be used (`Async`, `Eio`). The `Unix` library can also be used with the `fork` function that creates a new process.
  - **Credit:** The program is heavily inspired by [this article](https://medium.com/@aryangodara_19887/tcp-server-and-client-in-ocaml-13ebefd54f60)
---
(* Defines some constants. The `listen_address` is typically `Unix.inet_addr_loopback`, `Unix.inet_addr_any`. Other values may be used to listen only on one network interface. The `(let*)` operator permits the chaining of multiple Lwt statements. *)
   let (let*) = Lwt.bind

      let listen_address = Unix.inet_addr_loopback
      let port = 9000
      let backlog = 10
(* This `loop` function loop forever a given Lwt promise. *)
let rec loop f =
        let* () = f () in
        loop f
(* This defines a function that will handle the connection with a single client. `ic` and `oc` are input and output channels that can be used with `Lwt_io` functions. *)
let rec handle_connection ic oc =
        let* () = Lwt_io.write_line oc "Give me your name:" in
        let* line = Lwt_io.read_line_opt ic in
        match line with
        | Some line' ->
           let* () = Lwt_io.write_line oc ("Hello, " ^ line') in
           handle_connection ic oc
        | None ->
           Logs_lwt.info (fun m -> m "Connection closed")
(* This defines a function that "accepts" a new connection and runs `handle_connection` on it. `Lwt.on_failure` returns immediately and executes this function in parallel with the other tasks. *)
let accept_connection socket_fd =
        let* conn = Lwt_unix.accept socket_fd in
        let fd, _client_addr = conn in
        let ic = Lwt_io.of_fd ~mode:Lwt_io.Input fd in
        let oc = Lwt_io.of_fd ~mode:Lwt_io.Output fd in
        Lwt.on_failure
          (handle_connection ic oc)
          (fun exc -> Logs.err
                        (fun m -> m "%s" (Printexc.to_string exc) ));
        Logs_lwt.info (fun m -> m "New connection")
(* The main function initialises the socket that will be used to accept clients and loop forever through the `accept_connection` function. *)
let () =
        Logs.set_reporter (Logs.format_reporter ());
        Logs.set_level (Some Logs.Info);
        Lwt_main.run @@
          let socket_fd = Lwt_unix.(socket PF_INET SOCK_STREAM 0) in
          let* () = Lwt_unix.bind socket_fd (ADDR_INET(listen_address, port)) in
          Lwt_unix.listen socket_fd backlog;
          loop (fun () ->
            accept_connection socket_fd)
