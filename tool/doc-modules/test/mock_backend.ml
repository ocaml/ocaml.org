(* A mock of the documentation backend, for scrape_test.sh.

   mock_backend.exe ROOT PORT_FILE

   Serves ROOT/p/<pkg>/<version>/doc/sidebar.json over HTTP/1.1 (kept-alive
   connections): 200 with an ETag (the MD5 of the body) and a Last-Modified (the
   file's mtime), 304 when If-None-Match matches, 404 when the file does not
   exist. Like the real backend, it gzips the body when the request accepts
   gzip, with an ETag of its own (suffixed "-gzip"). A file `<path>.status` next
   to a sidebar, or ROOT/status for every request, holds a status code to answer
   instead (with an empty body). A file `<path>.mode` holds a misbehaviour
   instead: `slow` (answer after 3 seconds), `truncated` (a Content-Length
   longer than the body, then close the connection) or `garbled` (200 with a
   body that is not JSON). Every request path is appended to ROOT/requests.log,
   followed by " gzip" if the request accepts gzip, and a line per accepted
   connection to ROOT/connections.log. Writes the port it listens on to
   PORT_FILE.

   Plain Unix I/O and one system thread per connection: a client that gave up on
   a `slow` answer must not hold up the next connection.

   Open question: could this be written with Dream, the project's web server
   (Lwt-based, already a dependency), instead of parsing and answering HTTP by
   hand? The doubt is the `truncated` mode, which must send a Content-Length
   longer than the body, then close the connection: Dream's HTTP layer may
   correct or refuse that. Untested; a streamed response that sets the header
   itself and closes early might work. The other modes look straightforward
   (`slow` with Lwt_unix.sleep). *)

let root = ref ""
let log_mutex = Mutex.create ()
let read_all path = In_channel.with_open_bin path In_channel.input_all

let gzip s =
  let i = De.bigstring_create De.io_buffer_size in
  let o = De.bigstring_create De.io_buffer_size in
  let w = De.Lz77.make_window ~bits:15 in
  let q = De.Queue.create 0x1000 in
  let out = Buffer.create (String.length s) in
  let pos = ref 0 in
  let refill buf =
    let len = min (String.length s - !pos) De.io_buffer_size in
    for k = 0 to len - 1 do
      Bigarray.Array1.unsafe_set buf k s.[!pos + k]
    done;
    pos := !pos + len;
    len
  in
  let flush buf len =
    for k = 0 to len - 1 do
      Buffer.add_char out (Bigarray.Array1.unsafe_get buf k)
    done
  in
  let cfg = Gz.Higher.configuration Gz.Unix (fun () -> 0l) in
  Gz.Higher.compress ~w ~q ~level:4 ~refill ~flush () cfg i o;
  Buffer.contents out

let file_opt path =
  if Sys.file_exists path then Some (String.trim (read_all path)) else None

let status_text = function
  | 200 -> "OK"
  | 304 -> "Not Modified"
  | 400 -> "Bad Request"
  | 404 -> "Not Found"
  | 429 -> "Too Many Requests"
  | 500 -> "Internal Server Error"
  | 503 -> "Service Unavailable"
  | _ -> "Status"

(* An RFC 9110 date, as Last-Modified. *)
let http_date t =
  let tm = Unix.gmtime t in
  let days = [| "Sun"; "Mon"; "Tue"; "Wed"; "Thu"; "Fri"; "Sat" |] in
  let months =
    [|
      "Jan";
      "Feb";
      "Mar";
      "Apr";
      "May";
      "Jun";
      "Jul";
      "Aug";
      "Sep";
      "Oct";
      "Nov";
      "Dec";
    |]
  in
  Printf.sprintf "%s, %02d %s %04d %02d:%02d:%02d GMT" days.(tm.tm_wday)
    tm.tm_mday months.(tm.tm_mon) (tm.tm_year + 1900) tm.tm_hour tm.tm_min
    tm.tm_sec

let reply oc ?(headers = []) ?content_length code body =
  let len = Option.value content_length ~default:(String.length body) in
  Printf.fprintf oc "HTTP/1.1 %d %s\r\n" code (status_text code);
  List.iter (fun (k, v) -> Printf.fprintf oc "%s: %s\r\n" k v) headers;
  Printf.fprintf oc "Content-Length: %d\r\n\r\n%s" len body;
  flush oc

let log file line =
  Mutex.protect log_mutex (fun () ->
      Out_channel.with_open_gen [ Open_append; Open_creat; Open_wronly ] 0o644
        (Filename.concat !root file) (fun log ->
          output_string log (line ^ "\n")))

let accepts_gzip request_headers =
  match List.assoc_opt "accept-encoding" request_headers with
  | Some a ->
      List.mem "gzip" (List.map String.trim (String.split_on_char ',' a))
  | None -> false

(* Answers one request, given its target and its headers (names lowercased);
   false to close the connection. *)
let answer oc target request_headers =
  log "requests.log"
    (target ^ if accepts_gzip request_headers then " gzip" else "");
  if List.mem ".." (String.split_on_char '/' target) then (
    reply oc 400 "";
    true)
  else
    let path = Filename.concat !root target in
    match file_opt (path ^ ".mode") with
    | Some "garbled" ->
        reply oc 200 "<html>not json";
        true
    | Some "truncated" ->
        reply oc ~content_length:1000 200 "[{\"node\":";
        false
    | mode -> (
        if mode = Some "slow" then Thread.delay 3.;
        let forced =
          match file_opt (Filename.concat !root "status") with
          | Some s -> Some s
          | None -> file_opt (path ^ ".status")
        in
        match forced with
        | Some code ->
            reply oc (int_of_string code) "";
            true
        | None when not (Sys.file_exists path) ->
            reply oc 404 "";
            true
        | None ->
            let body = read_all path in
            let gzipped = accepts_gzip request_headers in
            let digest = Digest.to_hex (Digest.string body) in
            let etag, body, encoding =
              if gzipped then
                ( "\"" ^ digest ^ "-gzip\"",
                  gzip body,
                  [ ("Content-Encoding", "gzip") ] )
              else ("\"" ^ digest ^ "\"", body, [])
            in
            let headers =
              [
                ("ETag", etag);
                ("Last-Modified", http_date (Unix.stat path).st_mtime);
                ("Vary", "Accept-Encoding");
              ]
              @ encoding
            in
            if List.assoc_opt "if-none-match" request_headers = Some etag then
              reply oc ~headers 304 ""
            else
              reply oc
                ~headers:(headers @ [ ("Content-Type", "application/json") ])
                200 body;
            true)

(* The headers of a request, up to the empty line, names lowercased. *)
let rec read_headers ic acc =
  match In_channel.input_line ic with
  | None -> None
  | Some line -> (
      let line = String.trim line in
      if line = "" then Some acc
      else
        match String.index_opt line ':' with
        | None -> read_headers ic acc
        | Some i ->
            let name = String.lowercase_ascii (String.sub line 0 i) in
            let value =
              String.trim (String.sub line (i + 1) (String.length line - i - 1))
            in
            read_headers ic ((name, value) :: acc))

(* Requests on one connection, until the client closes it or a misbehaviour
   does. Requests carry no body: they are all GETs. *)
let serve fd =
  let ic = Unix.in_channel_of_descr fd and oc = Unix.out_channel_of_descr fd in
  let rec loop () =
    match In_channel.input_line ic with
    | None -> ()
    | Some request_line -> (
        match
          ( String.split_on_char ' ' (String.trim request_line),
            read_headers ic [] )
        with
        | _, None -> ()
        | [ "GET"; target; _ ], Some headers ->
            if answer oc target headers then loop ()
        | _, Some _ -> reply oc 400 "")
  in
  (* A client that gave up leaves a broken pipe: not worth a trace. *)
  (try loop () with Sys_error _ | Unix.Unix_error _ -> ());
  try Unix.close fd with Unix.Unix_error _ -> ()

let () =
  match Sys.argv with
  | [| _; dir; port_file |] ->
      Sys.set_signal Sys.sigpipe Sys.Signal_ignore;
      root := dir;
      let sock = Unix.socket Unix.PF_INET Unix.SOCK_STREAM 0 in
      Unix.setsockopt sock Unix.SO_REUSEADDR true;
      Unix.bind sock (Unix.ADDR_INET (Unix.inet_addr_loopback, 0));
      Unix.listen sock 64;
      let port =
        match Unix.getsockname sock with
        | Unix.ADDR_INET (_, port) -> port
        | Unix.ADDR_UNIX _ -> assert false
      in
      Out_channel.with_open_bin (port_file ^ ".tmp") (fun oc ->
          output_string oc (string_of_int port));
      Sys.rename (port_file ^ ".tmp") port_file;
      while true do
        let fd, _ = Unix.accept sock in
        log "connections.log" "accepted";
        ignore (Thread.create serve fd)
      done
  | _ ->
      prerr_endline "usage: mock_backend.exe ROOT PORT_FILE";
      exit 2
