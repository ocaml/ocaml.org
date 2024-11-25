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
---

(* Defines some constants about the remote host. The `( let* )` operator permits the chaining of multiple Lwt statements. *)
   let (let*) = Lwt.bind

      let connect_host = "localhost"
      let connect_service = "smtp"
(* We setup some `Logs` options. Afterwards `Lwt_main.run` creates a Lwt context. and schedules the following functions. *)
let () =
        Logs.set_reporter (Logs.format_reporter ());
        Logs.set_level (Some Logs.Info);
        Lwt_main.run @@
(* We are looking for host and service names. Hostnames are typically resolved with the `/etc/host` and DNS, while service names are typically resolved with `/etc/services`. Service names are bound to port numbers. (Note: `gethostbyname` and `getservbyname` raise an exception if the host or service is not found).  *)
      let* host_entry = Lwt_unix.gethostbyname connect_host in
          if Array.length host_entry.h_addr_list = 0 then
             Logs_lwt.err (fun m -> m "No addresses not found")
          else
            let* service_entry = Lwt_unix.getservbyname connect_service "tcp" in
            let rec handle_connection ic oc =
(* With host and service entries, we build a socket address that can be used to connect a distant host. Note: between the socket creation and its usage by `connect`, it is possible to set some options (`setsockopt`, `bind`). *)
      let socket_fd = Lwt_unix.(socket PF_INET SOCK_STREAM 0) in
            let* () = Lwt_unix.connect socket_fd
                        (Unix.ADDR_INET(host_entry.h_addr_list.(0),
                                        service_entry.s_port)) in
            let* () = Logs_lwt.info (fun m -> m "Connected") in
(* When we are connected, we can convert the socket into a pair of channels and use the available functions that deal with them. *)
            let* line = Lwt_io.read_line_opt ic in
            match line with
            | None ->
               Logs_lwt.info (fun m -> m ("Connection closed"))
            | Some line' ->
               let* () = Logs_lwt.info (fun m -> m "Received:%s" line') in
               let* () = Lwt_io.write_line oc "EHLO localhost" in
               let* line = Lwt_io.read_line_opt ic in
               match line with
               | None ->
                  Logs_lwt.info (fun m -> m ("Connection closed"))
               | Some line' ->
                  let* () = Logs_lwt.info (fun m -> m "Received: %s" line') in
                  Lwt.return ()
