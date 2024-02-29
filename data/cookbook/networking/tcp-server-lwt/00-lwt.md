---
packages:
- name: lwt
  version: "5.7.0"
- name: logs
  version: "0.7.0"
sections:
- filename: main.ml
  language: ocaml
  code_blocks:
  - explanation: |
      Defines some constants. The `listen_address` is typically `Unix.inet_addr_loopback`, `Unix.inet_addr_any`. Other values may be used to listen only on one network interface. The `(let*)` operator permits the chaining of multiple Lwt statements.
    code: |
      let (let*) = Lwt.bind

      let listen_address = Unix.inet_addr_loopback
      let port = 9000
      let backlog = 10
  - explanation: |
      This `loop` function loop forever a given Lwt promise.
    code: |
      let rec loop f =
        let* () = f () in
        loop f
  - explanation: |
      This defines a function which will handle the connection with a single client. `ic` and `oc` are input and output channels that can be used with `Lwt_io` functions.
    code: |
      let rec handle_connection ic oc =
        let* () = Lwt_io.write_line oc "Give me your name:" in
        let* line = Lwt_io.read_line_opt ic in
        match line with
        | Some line' ->
           let* () = Lwt_io.write_line oc ("Hello, " ^ line') in
           handle_connection ic oc
        | None ->
           Logs_lwt.info (fun m -> m "Connection closed")
  - explanation: |
      This defines a function which "accepts" a new connection and runs `handle_connection` on this connection. `Lwt.on_failure` returns immediately and execute this function in paralel with the other tasks.
    code: |
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
  - explanation: |
      The main function initialise the socket that will serve for the server and loop forever the `accept_connection` function.
    code: |
      let () =
        Logs.set_reporter (Logs.format_reporter ());
        Logs.set_level (Some Logs.Info);
        Lwt_main.run @@
          let socket_fd = Lwt_unix.(socket PF_INET SOCK_STREAM 0) in
          let* () = Lwt_unix.bind socket_fd (ADDR_INET(listen_address, port)) in
          Lwt_unix.listen socket_fd backlog;
          loop (fun () ->
            accept_connection socket_fd)
- filename: dune
  language: dune
  code_blocks:
  - explanation: |
      The program mainly use Lwt and Logs.
    code: |
      (executable
        (name main)
        (libraries
            lwt lwt.unix
            logs.lwt))
---

- **Understanding TCP server:** Implementing a TCP server needs initilising a main socket file descriptor that will be used to accept connections. Each connection is associated to a dedicated file descriptor that is used to create input and output channels. Since the server have to handle multiple connections concurrently, we have to use the Lwt scheduling and have multiple concurrent promises. The I/O functions provided by `Lwt_unix` must be used instead of blocking functions from other libraries.
- **Alternative Libraries:** Other concurrent libraries can be used (`Async`, `Eio`). The `Unix` library can also be used with the `fork` function that creates a new process.
- **Credit:** The program is heavily inspired by [this article](https://medium.com/@aryangodara_19887/tcp-server-and-client-in-ocaml-13ebefd54f60)
